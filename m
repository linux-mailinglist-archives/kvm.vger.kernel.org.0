Return-Path: <kvm+bounces-29419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8999AB1B3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 17:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FF06286853
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 15:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDC21A264A;
	Tue, 22 Oct 2024 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XpPwQtiI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE35D13A865
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729609718; cv=none; b=EzXNls+3jdEqsO++U/ehoTREwMksVMC8FjWIDxMjPRi8Bg6KeP62mMwHvhQgYe9GyPpaNM2GxxjlibeXmgSIOSsJ5c/phb2qaeTADKh/Iukx1Euko0+quEuVxnqMJqHmW+GWTrJz+QsmqEpLWoTxNEzMhqFHeGsG/25opvsfpwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729609718; c=relaxed/simple;
	bh=IVPoKTT/PdKGGjUbgzY5M6CpI8HSyHJLQWK7ISZxKI4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pPTHkNPdIZq1rwH2npzkJdHkyEsthpsBp3no5s7rZeN5+vE+H0sz+DnMW9z56mrZwkfujCFKqgxtnJPoAH8ylmlYA6OiXVX7wNDxoZvo1kn24lLcm5Hr1DGeYeuG77hBIyTMqD2WM+xcMMmzGJgACYO+UEgOKUD5TAhQqL1azTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XpPwQtiI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2bac0c38aso7412891a91.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 08:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729609716; x=1730214516; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SfLZJa9MIUtHXHwJqxHcWn5oL7MLhSurbcLYJY1Gqig=;
        b=XpPwQtiIE9rfWzV9MZ3wMXaiZDo/l8lpDWV6g0OAlPJ9hru5B1AJwUjrPF8NXiKL4H
         ObLM7J5SBINz0K6x6DBu31zE4YV5LpZTJ2B8zSsp1jDZEjF1Ljw8JO0D6p2Aw+IR8xkX
         VkIwMauVA/e+I+VL83IPBr/LIapoCAPSM//ShIy9S8A+SRFstrXn2Zf/grjjQnQa9fIN
         rmxZ5C8DYTRGS8GOSLEv51Np0FsJjYWejBWoOIeUMB6dcx+SZXIQhrDj8rRyfepYWPPn
         o+239U0YznHg4pZ2YIVZncbLUIzUaLuQPGOdNHgryEopt84ay9hcABcsxORndPLOb3Gt
         oz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729609716; x=1730214516;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SfLZJa9MIUtHXHwJqxHcWn5oL7MLhSurbcLYJY1Gqig=;
        b=SATsfCWCLTiPrd7njswz8AzSfH2+BbbBgtA7towDBOetLp9UgD7pc92OfACUrL0eSb
         IXMo/h2Nl5ipf2q5gfStvjDAWb+Niigl+RSkPFFAkQEYTS37dNqAWTZrwSBU2wccjkFC
         JPC2e5orgsMbeccOzBf2sGexStbXmGWqcYRnP+VAupO18MKthsmIb3g9mVjOHRkWY6ld
         vSuP+Wf8KrmXLMdZXwWRzZ3QXamSraf3YVBo2dMumnApin2Ss8BcoB+756WVvNf2LcJO
         6rRhRFx6BrV2KszRTj7QwNUZ4Q5I2JOCQxIYDi59usMgA3DojHeIxbD669KyunUQ8/i/
         Vj7A==
X-Forwarded-Encrypted: i=1; AJvYcCW/2L7NTxsA5SAYNGoEXrPPgpBgnQo4+d3WoZEpT1NmpoUUXX8gMgGbWxFzq1QRONmY1Sc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO3aQCwRzLRDjmFOk6szondgVSfvAr2VJe9LrZm9rkJZeTbJSy
	zuAzm0LwMdbwjZiiiT61kypl8A5JDyAIhBpUzx2wSuGADpz+J24wa6Yl3qH0x3pM1WbOJpjmoZf
	vGQ==
X-Google-Smtp-Source: AGHT+IFWMPUjcgioCdVgKaSR3yYj7Z65E9xYGDW9uxj82uAg7VT0m8AW8MLuOVrKTVrqo3KoopcOf0PONGc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:984:b0:2e3:8136:3e78 with SMTP id
 98e67ed59e1d1-2e5615dec74mr58548a91.2.1729609715986; Tue, 22 Oct 2024
 08:08:35 -0700 (PDT)
Date: Tue, 22 Oct 2024 08:08:34 -0700
In-Reply-To: <20241022093236.GAZxdxNCTki88ttFmy@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241022054810.23369-1-manali.shukla@amd.com> <20241022054810.23369-2-manali.shukla@amd.com>
 <20241022093236.GAZxdxNCTki88ttFmy@fat_crate.local>
Message-ID: <Zxe-lhHmVUz-8lYw@google.com>
Subject: Re: [PATCH v4 1/4] x86/cpufeatures: Add CPUID feature bit for Idle
 HLT intercept
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org, 
	nikunj@amd.com, thomas.lendacky@amd.com, vkuznets@redhat.com, 
	babu.moger@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2024, Borislav Petkov wrote:
> On Tue, Oct 22, 2024 at 05:48:07AM +0000, Manali Shukla wrote:
> > From: Manali Shukla <Manali.Shukla@amd.com>
> >=20
> > The Idle HLT Intercept feature allows for the HLT instruction
> > execution by a vCPU to be intercepted by the hypervisor only if there
> > are no pending events (V_INTR and V_NMI) for the vCPU. When the vCPU
> > is expected to service the pending events (V_INTR and V_NMI), the Idle
> > HLT intercept won=E2=80=99t trigger. The feature allows the hypervisor =
to
> > determine if the vCPU is idle and reduces wasteful VMEXITs.
> >=20
> > In addition to the aforementioned use case, the Idle HLT intercept
> > feature is also used for enlightened guests who aim to securely manage
> > events without the hypervisor=E2=80=99s awareness. If a HLT occurs whil=
e
> > a virtual event is pending and the hypervisor is unaware of this
> > pending event (as could be the case with enlightened guests), the
> > absence of the Idle HLT intercept feature could result in a vCPU being
> > suspended indefinitely.
> >=20
> > Presence of Idle HLT intercept feature for guests is indicated via CPUI=
D
> > function 0x8000000A_EDX[30].
> >=20
> > Signed-off-by: Manali Shukla <Manali.Shukla@amd.com>
> > Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
> > ---
> >  arch/x86/include/asm/cpufeatures.h | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/=
cpufeatures.h
> > index dd4682857c12..7461a49e1045 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -382,6 +382,7 @@
> >  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual S=
PEC_CTRL */
> >  #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
> >  #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* SVME addr check */
> > +#define X86_FEATURE_IDLE_HLT		(15*32+30) /* "" IDLE HLT intercept */
>=20
> Whoever commits this, you can remove the "" in the comment now as they're=
 not
> needed anymore.

Ya, will do.

