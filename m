Return-Path: <kvm+bounces-40127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D12A4F603
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 05:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AF223A9F16
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDE51C6FF2;
	Wed,  5 Mar 2025 04:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PaArDxeJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CB41AAA1D
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 04:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741148240; cv=none; b=DdG3U3VZA9SRIbH6amZX1qmvJ8A7ozpxGLakqcicIG37qapomZWhGNtDQzlEFbMPo+AtVsgJcSr5FVXJ6F7v4mL1rwqrdYddbuP3XCfU2tpUmP7Hq2/fTobzBQoR5FKAdMrK3NKzM57Sy/WdUPHE/wuk6ps7jzJGlLTFSAa/+XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741148240; c=relaxed/simple;
	bh=HwBqRobMEjc1RHDutE1Wec8IsX+1zzZJtF0f3kRjfZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dj8zIQ2lWC9BGP1ZnRZ48vVrpYoIl0/9NIKic0n3LalIIwYNSu6m9sHL4LnHJMba+AxaWVrZ4EKkAcvOoo/YWsh2/zs2my5jXNiiA1MrhgL6MgNODdOMSEWwpZRq25LGYJAQYpY7kd9kXlQ2R5f4zvQJiTHcwlcAqnRVQjVvEcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PaArDxeJ; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-47509b2bb7dso9444961cf.2
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 20:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741148236; x=1741753036; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XcHAlTO4gyMhCqU3G5F6EtU5yvv2W4gq8broR/6eQhA=;
        b=PaArDxeJGiGw8KgQgWhIGz6Vw8JFggpR69SIRf6a0wKU+au3ITv4AAPWPLb2/zpT90
         2Tkg+9xmgIeNZZFcXsvd/HK4324DQtZgrgpFu++7TmFaVUx1ZbndP25InQJhTAn3cl0y
         brBZOw83YLaDadsD25X9FO2k19int4Z0Kan2/p8D9xRmh2eqAs4zDOUS1hZgAslEkyzm
         jJ6h2N9aWF0kIQ22RoWuKzurtKfEwVLodNHghDM9VXPAP/aPzcZOtnnMhAkH0PCazwsT
         74K8jwh9RqmuLIgCHhCO66krZE6B1F2T+fUxBd4gK+xS78fx52/Pk8ovZeIbrqzgCUTM
         hpaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741148236; x=1741753036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XcHAlTO4gyMhCqU3G5F6EtU5yvv2W4gq8broR/6eQhA=;
        b=veMuRopYWmyNy+9uBN9oX+Kg7m5+MvAlM18auOJxDhs41kCUBB55Bij3dHIDQ9bWe2
         i08bQkekCx/MLqv1GCuTmOsKaLAB3RZHvay/MAka83lqvoh2NnAc4+I5JplrkM2Uxy8p
         DyLcAoDfFx94JKTQSOV8EBT6tPLcs9t6IRy0VqVUB7poCNMPWgxzUo35nEci0HCxjIDc
         qmd0YIVgb/f9S99p0THLSCZSM4uRqaXVtDjLj0dNPl24trxnpg4THfXVef4Djlss4aFR
         nFg+NQAOZE/fk+gHn9LtIsTMPh5JaS+Khc4D+E7d2kbu29GwJgygswQUnJXSqDphE0CW
         qxig==
X-Forwarded-Encrypted: i=1; AJvYcCWuXKLgBfA0/Oz7H3XpWgXlWRRuL03NCbcx2X3jZKgZ55hIJVPz8vSqiroB2lFhhy0hf/s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1E4RmJBpxVlVBD/tHzw1pU15ne9PiJ9v1qEWAZchwr/DhvGLD
	RIFOy/migSSJD5wpZAEWHlMKbN4QjAZ7+lTKm+r2QWrhuTWH138Oy2GvJ/a383I2+y9WYYNYG8/
	CmPq3D6AEZUvHFidGZrtbM4k92eCuJqRPJFuP
X-Gm-Gg: ASbGncuUbWXuNaiP+JpuLiFQ7mKJiji048AezD0eAycoaT6ac8AFOtnhsV8B0ZnJFL0
	jved2ffn0MzZ8yzzTNvzr7BCS/LZJi6BudPeY1V85qIdIZDr1AC2tTMKggoDM+CbzsFRPPO5f95
	xTG8BKahwk0Kgr7cc2cz7tj4TDuDPAQIqMRbgcY98+aKPsDpVn+IhqZJUj
X-Google-Smtp-Source: AGHT+IFJNFqHI05Gy+INURBdfismHLlToIOAN2sGK8FQGemkQqgtUPkgQBuqxpFP5bBRssTUaN9X8dG7bt2dplInltQ=
X-Received: by 2002:ac8:5d8d:0:b0:473:8a27:5b70 with SMTP id
 d75a77b69052e-4750b442ffbmr24970761cf.19.1741148236174; Tue, 04 Mar 2025
 20:17:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250221053927.486476-1-suleiman@google.com> <20250221053927.486476-3-suleiman@google.com>
 <Z8NCGFcH9H14VOV-@char.us.oracle.com>
In-Reply-To: <Z8NCGFcH9H14VOV-@char.us.oracle.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Wed, 5 Mar 2025 13:17:04 +0900
X-Gm-Features: AQ5f1JoH4jwPGSW282LkcEOTlJZEQawNQoZu1dnFNF46VUE5HwqLizIhVtKljd8
Message-ID: <CABCjUKCU_3q_VfzergdmRK4Tc2BxUcmCotf+E8MpWX6o+g0CTA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] KVM: x86: Include host suspended time in steal time
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 2, 2025 at 2:22=E2=80=AFAM Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> On Fri, Feb 21, 2025 at 02:39:27PM +0900, Suleiman Souhlal wrote:
> > When the host resumes from a suspend, the guest thinks any task
> > that was running during the suspend ran for a long time, even though
> > the effective run time was much shorter, which can end up having
> > negative effects with scheduling.
> >
> > To mitigate this issue, the time that the host was suspended is include=
d
> > in steal time, which lets the guest can subtract the duration from the
>
> s/can//
> > tasks' runtime.
> >
> > In order to implement this behavior, once the suspend notifier fires,
> > vCPUs trying to run block until the resume notifier finishes. This is
>
> s/run/run will/
> > because the freezing of userspace tasks happens between these two point=
s,
> Full stop at the end of that                                             =
 ^
> > which means that vCPUs could otherwise run and get their suspend steal
> > time misaccounted, particularly if a vCPU would run after resume before
> > the resume notifier.
>
> s/notifier/notifier fires/
>
> > Incidentally, doing this also addresses a potential race with the
> > suspend notifier setting PVCLOCK_GUEST_STOPPED, which could then get
> > cleared before the suspend actually happened.
> >
> > One potential caveat is that in the case of a suspend happening during
> > a VM migration, the suspend time might not be accounted.
>
> s/accounted/accounted for./
> > A workaround would be for the VMM to ensure that the guest is entered
> > with KVM_RUN after resuming from suspend.
>
> So ..does that mean there is a QEMU patch as well?

No, I am not planning on making a QEMU patch.
A QEMU patch would only be needed if you cared about the caveat mentioned t=
here.

Thanks,
-- Suleiman

