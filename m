Return-Path: <kvm+bounces-7200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 582C283E289
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 20:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B0A61C2332D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E38225A6;
	Fri, 26 Jan 2024 19:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="StYpRRKc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143FE224D6
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 19:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706297465; cv=none; b=l30eOi2iuM+9edL8Aa4yMJwjeRY+BZEwx3cOldZsfwtaNKouMIbFKPZ37K7GXf17dwiws9PzVubPsgf4+xwm1yCUVRi8oc3+x3XEQ9F0TtUUrVWipI16PMTdYVbQ2GRFcwQodbGmaVXLLEmqd/2abUiVc4nOCu9KTkibj13DZgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706297465; c=relaxed/simple;
	bh=JGegk8kL7SgIcKsQtZ+urXvd9z0l9LfLJR8VXMRefoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K/Sim8eWECknfeMTBGzqrrluAdvp0b500EcVRI+E4BGnRsgDnvN8xdhpavOd4ItxTcWIjNm++/V6hKUcEiWnICu+SgJ1uxCvoslpTTtmkesFwo245Dp49UHAC7Ea8stMzxv5tRKloAtibNxeHwxHBoaUrL+GaSJGaJmlNzGcDVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=StYpRRKc; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-783d39b7469so61633185a.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 11:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706297463; x=1706902263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugXUIN/Pk2lZ8Sgmd1g24vx3njzXKNYOE94mHsj1aMY=;
        b=StYpRRKcWa+xmtEd66ELnRWj9hpMJ0DD87yWSiHKS6CFuhHfnejGfVXX2nncq8XEcV
         EsezWEgRqSjq0nUdRgcXioYZY2+whF8+uc1EGg5sH6vNPjwpazj3GeT7gV7MlmQa56Mf
         v3AwUPTKAr0Sp+fU1Yo+7zAajDKPgzjAIFIlpPgb9wZ7DLapHGMKzgHMhccB9YlJFqDN
         Io/GRciHdvlxl3/pmD21q5hbaVxURFLSUDhHzwnMfJs8YRF3WGo6I4f+4FmVWFKpmGxo
         j8cyAKFwJ4nG3RL97u7Mqp5sgXX9jF32dF+GBchFCUKAutAUTpyS8O55l35hvLxVGOGI
         YePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706297463; x=1706902263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ugXUIN/Pk2lZ8Sgmd1g24vx3njzXKNYOE94mHsj1aMY=;
        b=u6bXgNYiZ4fydWe3S7KYfv9CpkN1Smg2xSIn96U/ZpK0+moQ568qS5Ee+0HhWDscvf
         JL1rfRNexEXPhKt/OWqPXhawPyMrBCisSwnvKamE23WSpTyS6G9TwA3ZpPcGhJN6HXfd
         OhF/rEP/tH6Q1sSxjHuwscG5sQcZ5I8gWOSnax4HEl13hlUALKFUj7QWE3RHsPB45WTF
         C2CcBrcQXygCCOKRjCxejNq7fGZBkzx2dcMq2Hme66ht4teX1FP9+oDetfrDmIn0RruP
         YKdsei2Lg5P+j6cqeIfwRByK8ianYERPv/R+uo1rraaYi8bnAcMOM0DpiDtg+CWgiD/G
         65RA==
X-Gm-Message-State: AOJu0YwAB+DwXGzHY0sjIRVUuLLj0paE194L6PyETMzkuBKQ16rJ+h3P
	V7CJuCtgVE+L4s0/0h3jOzDHPCYtLw8aGFHzz9KnX1yRMu6e2E36mH136/6l0n8nB+RSwclh1tc
	1uJ77GKvFb1JBkI4aX4o+LoXV+oVJsFv8Ksxg
X-Google-Smtp-Source: AGHT+IEl3G31lI+FOY1PxxXOx0PDciIsgiyoB6bGCduGLrHnyZmNqsHFfzbM98jsQS/5MYBUcw71Fk+ryeXrT9lBv18=
X-Received: by 2002:a05:6214:4008:b0:685:2233:678d with SMTP id
 kd8-20020a056214400800b006852233678dmr351666qvb.27.1706297462775; Fri, 26 Jan
 2024 11:31:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com> <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com> <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
 <ZbGAXpFUso9JzIjo@google.com> <ZbGOK9m6UKkQ38bK@google.com>
 <ZbGUfmn-ZAe4lkiN@google.com> <ZbGn8lAj4XxiecFn@google.com> <ZbP7BTvdZ1-b3MmE@google.com>
In-Reply-To: <ZbP7BTvdZ1-b3MmE@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Fri, 26 Jan 2024 11:30:25 -0800
Message-ID: <CAL715WKMpui=+U56Qc5AiuLhUw_g-bjvtN5OmVz_hGdJmF1M5g@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
To: Sean Christopherson <seanjc@google.com>, Frederick Mayle <fmayle@google.com>, 
	Steven Moreland <smoreland@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+Frederick Mayle +Steven Moreland

On Fri, Jan 26, 2024 at 10:33=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Jan 25, 2024, Mingwei Zhang wrote:
> > On Wed, Jan 24, 2024, Sean Christopherson wrote:
> > > On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > > > I think this makes a lot of confusions on migration where VMM on th=
e source
> > > > believes that a non-zero value from KVM_GET_MSRS is valid and the V=
MM on the
> > > > target will find it not true.
> > >
> > > Yes, but seeing a non-zero value is a KVM bug that should be fixed.
> > >
> > How about adding an entry in vmx_get_msr() for
> > MSR_IA32_PERF_CAPABILITIES and check pmu_version? This basically pairs
> > with the implementation in vmx_set_msr() for MSR_IA32_PERF_CAPABILITIES=
.
> > Doing so allows KVM_GET_MSRS return 0 for the MSR instead of returning
> > the initial permitted value.
>
> Hrm, I don't hate it as a stopgap.  But if we are the only people that ar=
e affected,
> because again I'm pretty sure QEMU is fine, I would rather we just fix th=
ings in
> our VMM and/or internal kernel.

It is not just QEMU. crossvm is another open source VMM that suffers
from this one.

>
> Long term, I want some form of fix for the initialization code, even if t=
hat means
> adding a quirk to let userspace opt out of KVM setting default values for=
 platform
> MSRs.

Yeah, that I definitely agree. It applies to all future platform MSRs.
Potentially, any patch trying to add a new platform MSR and initialize
it at vcpu create time should be rejected. And VMM should be told to
get the feature value and set it appropriately.

For existing platform MSRs, I think we should prioritize the "fix"
solution. Refactoring existing code that requires ABI changes may
raise complaints from production folks.

>
> Side topic, vmx_set_msr() should check X86_FEATURE_PDCM, not just the PMU=
 version.

You are right.
>
> > The benefit is that it is not enforcing the VMM to explicitly set the
> > value. In fact, there are several platform MSRs which has initial value
> > that VMM may rely on instead of explicitly setting.
> > MSR_IA32_PERF_CAPABILITIES is only one of them.
>
> Yeah, and all of those are broken.  AFAICT, the bad behavior got introduc=
ed for
> MSR_PLATFORM_INFO, and then people kept copy+pasting that broken pattern =
:-(

