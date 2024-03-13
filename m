Return-Path: <kvm+bounces-11741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F18887A9A8
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2790A28291E
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049103D0DD;
	Wed, 13 Mar 2024 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JOmX3w+o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD8B4A07
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710340942; cv=none; b=bnFJdYorFrjDCQARr5GwesEkmRdmQ6VFpbOyIKHYgcX8m5mbHu951AAiJdo7V1jjm1j+c03fn2zpHv4yvxTC+z6Rzb7DchXhXw5K/3n9K4UgKP/MVjvZlczGruaRnQ5EHX7lDforcltrIN/LlHiG+YW3MszYZcLoz03gm9FbTW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710340942; c=relaxed/simple;
	bh=chSdJDUtKzDuTUHtdpxMes7gNjiM378d/wKDulIvMMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sAa7ms86WpR5jTd+FxpzyonzRNwAeT/bkSIRdmfSiO3IZe/dwhW+D2kJsrBwBuueLARDXK7ISEaadMbRFHLbd2ox3em25mY5U7ZUNxIPah67pZAEECjqHDk+qMkCiOdEguLJMdelO3ym9Wc6ut/2y9y1tnKyjXlOmqr08e46ahE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JOmX3w+o; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1dd8158ed26so12113995ad.1
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 07:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710340940; x=1710945740; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DsNKRRM5eqSpZG2xIM+UvbeP4kbCL6MaPJhxll06mGE=;
        b=JOmX3w+oqIU6KuLkFHyDzPpwKe5G+DEeYBq48twDtZ5BBeXcmlYbUygc567atDUNcf
         lRDKZdU88N4xBMJB0tPDWKuThr+fxzaFaxa87LkVzTdbGkrYEDiUzgiscT1x81P+stll
         7V8fLehlMOt7md/z3HwTzm3PM38E78ZPKIK7HvwcL9HUxHjT3XBB8QodRq+jEeTcGcPA
         ORPV5hcsg4LTMDqibuWdCyQ5mHxqSKodbkNzC+bLfay7eTiFBbAoL7QzK5VMPJNJKH12
         15Gt8IgWkGsAyaotGbUMnh0wITvnZlKzdd6x9SDjuE1XLQe3VJSuN4ZtL/WFNYeFvdiE
         gBYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710340940; x=1710945740;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DsNKRRM5eqSpZG2xIM+UvbeP4kbCL6MaPJhxll06mGE=;
        b=DNDenS7Ouud5H/yRDlliH3bHY5uLiw8zm4aRC//hR7rpmU5W8KY+1Aq/LeF3MLX4q4
         2L2gbjf38ZmW6uZIdAfp2T0b1yB3wvUCTLUcXTmL1e6BzPe1r10/e+VwTdvi+59dhVIn
         Qijx7FhwUx+qq8RS+utofB7nmYZ+/Xc0fuTAeFV2dj78Ir5kooUlnyY578zR2xtrNNJh
         5OsAPNoGmK0t0iS03Yq5+tUtw/IKGyZk/27x8H0uZmKyp4vpENvwb0eLMabQhB3CHAyq
         KJC6Iwf5bqohR3NoSfHOC4p/6s9KfNR9M0ld4X73whGsjSysinV09PjBGjxHKawXXbYp
         UFBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxLo9lWBxzi4+tpAU+R5OcYQI1OZW93ZcA5wrV9d46V0KS2mKv+71D54Y0jYGmZuxicMnL0gkaeR2Ypc3Hl+HlODQ7
X-Gm-Message-State: AOJu0Yyjmq1AiUAUsL6txxxlfvUi89pEBG1pHVZv77RTqNdfECWFgQ/A
	CIgISm57ZlSEGT1+e8wwi4y3oqOjbqOvNJbhgoP1gKtgeQ76q25WrBKpvVbsXUam4fosf632hnL
	KcQ==
X-Google-Smtp-Source: AGHT+IHmi4XfzjW9EmfmQD9pOXVOy3+HJOzNMlldLJHQy/DYtS/xbnEr/IVuJdigkFptyFLAb8v8t0j5vGY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41cc:b0:1dd:9250:2d5d with SMTP id
 u12-20020a17090341cc00b001dd92502d5dmr8798ple.9.1710340940087; Wed, 13 Mar
 2024 07:42:20 -0700 (PDT)
Date: Wed, 13 Mar 2024 07:42:18 -0700
In-Reply-To: <DS0PR11MB63731F54EA26D14CF7D6A3FDDC2A2@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240313003739.3365845-1-mizhang@google.com> <DS0PR11MB63731F54EA26D14CF7D6A3FDDC2A2@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZfG7SgyqTTtqF3cw@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Return correct value of IA32_PERF_CAPABILITIES
 for userspace after vCPU has run
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Aaron Lewis <aaronlewis@google.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024, Wei W Wang wrote:
> On Wednesday, March 13, 2024 8:38 AM, Mingwei Zhang wrote:
> > Return correct value of IA32_PERF_CAPABILITIES when userspace tries to =
read
> > it after vCPU has already run. Previously, KVM will always return the g=
uest
> > cached value on get_msr() even if guest CPUID lacks X86_FEATURE_PDCM. T=
he
> > guest cached value on default is kvm_caps.supported_perf_cap. However,
> > when userspace sets the value during live migration, the call fails bec=
ause of
> > the check on X86_FEATURE_PDCM.
>=20
> Could you point where in the set_msr path that could fail?
> (I don=E2=80=99t find there is a check of X86_FEATURE_PDCM in vmx_set_msr=
 and
> kvm_set_msr_common)

The changelog is misleading, it's not the PDCM feature bit, it's the PMU ve=
rsion
check in vmx_set_msr():

	case MSR_IA32_PERF_CAPABILITIES:
		if (data && !vcpu_to_pmu(vcpu)->version)
			return 1;

> > Initially, it sounds like a pure userspace issue. It is not. After vCPU=
 has run,
> > KVM should faithfully return correct value to satisify legitimate reque=
sts from
> > userspace such as VM suspend/resume and live migrartion. In this case, =
KVM
> > should return 0 when guest cpuid lacks X86_FEATURE_PDCM.=20
> Some typos above (satisfy, migration, CPUID)
>=20
> Seems the description here isn=E2=80=99t aligned to your code below?
> The code below prevents userspace from reading the MSR value (not return =
0 as the
> read value) in that case.

Ya.

> >So fix the
> > problem by adding an additional check in vmx_set_msr().
> >=20
> > Note that IA32_PERF_CAPABILITIES is emulated on AMD side, which is fine
> > because it set_msr() is guarded by kvm_caps.supported_perf_cap which is
> > always 0.
> >=20
> > Cc: Aaron Lewis <aaronlewis@google.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >=20
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > 40e3780d73ae..6d8667b56091 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2049,6 +2049,17 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu,
> > struct msr_data *msr_info)
> >  		msr_info->data =3D to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
> >  			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
> >  		break;
> > +	case MSR_IA32_PERF_CAPABILITIES:
> > +		/*
> > +		 * Host VMM should not get potentially invalid MSR value if
> > vCPU
> > +		 * has already run but guest cpuid lacks the support for the
> > +		 * MSR.
> > +		 */
> > +		if (msr_info->host_initiated &&
> > +		    kvm_vcpu_has_run(vcpu) &&
> > +		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> > +			return 1;

As Wei pointed out, this doesn't match the changelog.  And I don't think th=
is is
what we want, at least not in isolation.  Making KVM more restrictive on us=
erspace
reads doesn't solve the live migration save/restore issue, and the kvm_vcpu=
_has_run()
adds yet another flavor of MSR handling.

We discussed this whole MSRs mess at PUCK this morning.  I forgot to hit RE=
CORD,
but Paolo took notes and will post them soon.

Going from memory, the plan is to:

  1. Commit to, and document, that userspace must do KVM_SET_CPUID{,2} prio=
r to
     KVM_SET_MSRS.

  2. Go with roughly what I proposed in the CET thread (for unsupported MSR=
S,
     read 0 and drop writes of '0')[*].

  3. Add a quire for PERF_CAPABILITIES, ARCH_CAPABILITIES, and PLATFORM_INF=
O
     (if quirk=3D=3Denabled, keep KVM's current behavior; if quirk=3D=3Ddis=
abled, zero-
      initialize the MSRs).

With those pieces in place, KVM can simply check X86_FEATURE_PDCM for both =
reads
and writes to PERF_CAPABILITIES, and the common userspace MSR handling will
convert "unsupported" to "success" as appropriate.

[*] https://lore.kernel.org/all/ZfDdS8rtVtyEr0UR@google.com

