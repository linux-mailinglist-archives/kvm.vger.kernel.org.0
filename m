Return-Path: <kvm+bounces-45171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FC5AA64CD
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 22:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 119C57AA25B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F30253B65;
	Thu,  1 May 2025 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y2s/aE7O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDB421B9F6
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131681; cv=none; b=WmpFUHLDs2Z9ZzSy9RgFOqwDKhTokWLzhLZSKYsV5uE/kYqEmJkVq+luRFs93mAZshHhbJDIU/jQJNSnHPQINpfHXcnCF8xcM9LO2m64m+4hdbNkIbKcbzE0SH4uF3loaA0WXwanAhGuhGYxkEF671ANrTjznvr9P9x+27R2A9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131681; c=relaxed/simple;
	bh=hU1GPYOS/p1CqrHi+G/ryco1Fmo8RhxEJs2RLJWMe64=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cG2VSMlvCzRBjJNPQyNyPEri7+bc6rdQP1K272gzVKimZiBrmgw8f7ZRlT1c6xfrtSBqSUC4VXaFEYTJaMuxZMG0UQEIJnXd30p/STmCcIxEozlDtSScnHRLWZi/TwmXPoQSV+1UoelL7vS07FFE7puZcXFuZr5kQVNHoFOx3EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y2s/aE7O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746131678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qylf8yURimfWi0owjqfP15rhCmH9Mk/8UKHeIezSz1M=;
	b=Y2s/aE7OcFvb2X/LuftmOViuDcLJuO8Ef596X4qupNjvIo6rA+IPgKXb5Aoc/Ig67zWkh7
	ghWImZlFxyfNxryo+oXPZU09NCRxKjzFt46nskV4IPafI4gPUknJgXdf1keB+N3jiwnRsE
	kKQLRKYdrVbaZ3e6KKxVfgUTfuXHAtM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-dvI-ZmmBOPCa6CZfTPfdTA-1; Thu, 01 May 2025 16:34:37 -0400
X-MC-Unique: dvI-ZmmBOPCa6CZfTPfdTA-1
X-Mimecast-MFC-AGG-ID: dvI-ZmmBOPCa6CZfTPfdTA_1746131676
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5e2a31f75so443233085a.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 13:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746131676; x=1746736476;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qylf8yURimfWi0owjqfP15rhCmH9Mk/8UKHeIezSz1M=;
        b=xDYSym2gepQ5aa7odBZcEl+pktWmBgC2dNPCpxD0c6l4hhe2Xf2uGrZBsaiuhhPYrB
         edvD2p3qe99yS14tAw5v4wL0AQaICt/EDdPcJiqWI1os5Gu8t8czYt0UETmvRcF5KdDJ
         KMty9BptXQSaPnGux0MpHlDAZptUhe+5UwLaWpfDbq4bKJcW4n96A9dQ0Of/JuyJdr3X
         uN309eZhjYN0gHi2xvzPy7c6WyjT7MNaTvKrBMY4q2RC0OOyNN2L7c6XhHC9fmqz3sN3
         LvAMEFyTVlNBs3ZKCikLE2+jcRAPTtVdpV/iALDJKDlsAHK9dKPxEljqgBmzDU84vb6E
         UuEA==
X-Forwarded-Encrypted: i=1; AJvYcCXk98NyacR05DP24OSLH3vkyya/Rmnt7t4J8jgAYmRyb3TMwbY4Z6hHHvf17Cj88tT9iwA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtn5HRxCC+MFnLrqgZHGpvnUXf7A2FUMFUILVlYlcH7kk5xtBO
	AxLIKN9ezAPzHPxEAjiteUehNnxf07l5yAF2Ygx6ObpKFUUXy6aX0Y5ISwk39Bulo790XEbCt1h
	M0xLQUwNtRCyS0sGTibSKfjy8cmoR5uo5Mqb/ORWvACdGPRmifsUiBn6BMw==
X-Gm-Gg: ASbGncvmwDl0ip5WCaPfT2+mwRtGebqjY86UFxOu2ShRanngPywL0LHkdcLqaPF+OM6
	Ud5rS+y4I8hCyJkeu6wCBRWi3Lm2DPkk8Ond7Y5Ni1BS3913H+c0f9uV9icI1BuhvZ5D1Lrnf57
	Fh6UkK+bPPS8bA1bgmJqnrL7lkmrj4OilPtVAk3ZXOoxH9zK7G1xyyYLgrFvzNk3r9cwOLhmtc2
	vwSspPHHejPnP5aFtxcnqiXpZvwuUfFiY2sNfkoZMAHf57ZxKBr7aOnDzNttg68CCEyPue3c3Uk
	Yd7sHLFDawweqvMm8zzZikiJj9Q26gDh1s1LOzub3EqFbMZsZPUiPWzjEAM=
X-Received: by 2002:a05:620a:2415:b0:7c5:9fd3:a90b with SMTP id af79cd13be357-7cad5bbaa29mr64560885a.47.1746131675901;
        Thu, 01 May 2025 13:34:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnJML61DpLHuJzY1vxpiK5BGDB0Ts3eXsJDqN3rpjbD2GVzXfb/Uqm5TI0zC7PQNvGmIk1Jw==
X-Received: by 2002:a05:620a:2415:b0:7c5:9fd3:a90b with SMTP id af79cd13be357-7cad5bbaa29mr64557085a.47.1746131675449;
        Thu, 01 May 2025 13:34:35 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cad23b51f9sm88272585a.21.2025.05.01.13.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 13:34:35 -0700 (PDT)
Message-ID: <517ee0b7ba1a68a63e9e1068ec2570c62471d695.camel@redhat.com>
Subject: Re: [PATCH 1/3] x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write
 with access functions
From: mlevitsk@redhat.com
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, Sean Christopherson
 <seanjc@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar
 <mingo@redhat.com>,  linux-kernel@vger.kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>
Date: Thu, 01 May 2025 16:34:34 -0400
In-Reply-To: <1a0325af-f264-47de-b9f7-da9721366c20@linux.intel.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
	 <20250416002546.3300893-2-mlevitsk@redhat.com>
	 <1a0325af-f264-47de-b9f7-da9721366c20@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-04-23 at 17:51 +0800, Mi, Dapeng wrote:
> The shortlog "x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write with
> access functions" doesn't follow Sean's suggestion
> (https://github.com/kvm-x86/linux/blob/next/Documentation/process/maintai=
ner-kvm-x86.rst#shortlog).
> Please modify. Thanks.
>=20
>=20
> On 4/16/2025 8:25 AM, Maxim Levitsky wrote:
> > Instead of reading and writing GUEST_IA32_DEBUGCTL vmcs field directly,
> > wrap the logic with get/set functions.
> >=20
> > Also move the checks that the guest's supplied value is valid to the ne=
w
> > 'set' function.
> >=20
> > In particular, the above change fixes a minor security issue in which L=
1
> > hypervisor could set the GUEST_IA32_DEBUGCTL, and eventually the host's
> > MSR_IA32_DEBUGCTL to any value by performing a VM entry to L2 with
> > VM_ENTRY_LOAD_DEBUG_CONTROLS set.
> >=20
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c    | 15 +++++++---
> >  arch/x86/kvm/vmx/pmu_intel.c |  9 +++---
> >  arch/x86/kvm/vmx/vmx.c       | 58 +++++++++++++++++++++++-------------
> >  arch/x86/kvm/vmx/vmx.h       |  3 ++
> >  4 files changed, 57 insertions(+), 28 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index e073e3008b16..b7686569ee09 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2641,6 +2641,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, =
struct vmcs12 *vmcs12,
> >  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> >  	struct hv_enlightened_vmcs *evmcs =3D nested_vmx_evmcs(vmx);
> >  	bool load_guest_pdptrs_vmcs12 =3D false;
> > +	u64 new_debugctl;
> > =20
> >  	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
> >  		prepare_vmcs02_rare(vmx, vmcs12);
> > @@ -2653,11 +2654,17 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu=
, struct vmcs12 *vmcs12,
> >  	if (vmx->nested.nested_run_pending &&
> >  	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
> >  		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
> > +		new_debugctl =3D vmcs12->guest_ia32_debugctl;
> >  	} else {
> >  		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
> > +		new_debugctl =3D vmx->nested.pre_vmenter_debugctl;
> >  	}
> > +
> > +	if (CC(!vmx_set_guest_debugctl(vcpu, new_debugctl, false))) {
> > +		*entry_failure_code =3D ENTRY_FAIL_DEFAULT;
> > +		return -EINVAL;
> > +	}
> > +
> >  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
> >  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
> >  		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
> > @@ -3520,7 +3527,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_roo=
t_mode(struct kvm_vcpu *vcpu,
> > =20
> >  	if (!vmx->nested.nested_run_pending ||
> >  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> > -		vmx->nested.pre_vmenter_debugctl =3D vmcs_read64(GUEST_IA32_DEBUGCTL=
);
> > +		vmx->nested.pre_vmenter_debugctl =3D vmx_get_guest_debugctl(vcpu);
> >  	if (kvm_mpx_supported() &&
> >  	    (!vmx->nested.nested_run_pending ||
> >  	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
> > @@ -4788,7 +4795,7 @@ static void load_vmcs12_host_state(struct kvm_vcp=
u *vcpu,
> >  	__vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
> > =20
> >  	kvm_set_dr(vcpu, 7, 0x400);
> > -	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
> > +	vmx_set_guest_debugctl(vcpu, 0, false);
> > =20
> >  	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
> >  				vmcs12->vm_exit_msr_load_count))
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.=
c
> > index 8a94b52c5731..f6f448adfb80 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -19,6 +19,7 @@
> >  #include "lapic.h"
> >  #include "nested.h"
> >  #include "pmu.h"
> > +#include "vmx.h"
> >  #include "tdx.h"
> > =20
> >  /*
> > @@ -652,11 +653,11 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu=
)
> >   */
> >  static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcp=
u)
> >  {
> > -	u64 data =3D vmcs_read64(GUEST_IA32_DEBUGCTL);
> > +	u64 data =3D vmx_get_guest_debugctl(vcpu);
> > =20
> >  	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
> >  		data &=3D ~DEBUGCTLMSR_LBR;
> > -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> > +		vmx_set_guest_debugctl(vcpu, data, true);
>=20
> Two questions.=C2=A0
>=20
> 1. why to call vmx_set_guest_debugctl() to do the extra check? currently
> IA32_DEBUGCTL MSR is always intercepted and it's already checked at
> vmx_set_msr() and seems unnecessary to check here again.

Hi,


I wanted this to be consistent. KVM has plenty of functions that can be bot=
h
guest triggered and internally triggered. For example kvm_set_cr4()

Besides the=C2=A0vmx_set_guest_debugctl also notes the value the guest wrot=
e
to be able to return it back to the guest if we choose to overide some
bits of the MSR, so it made sense to have one common function to set the ms=
r.

Do you think that can affect performance?=C2=A0


>=20
> 2. why the argument "host_initiated" is true? It looks the data is not fr=
om
> host.

This is my mistake.

>=20
>=20
> >  	}
> >  }
> > =20
> > @@ -729,7 +730,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu=
)
> > =20
> >  	if (!lbr_desc->event) {
> >  		vmx_disable_lbr_msrs_passthrough(vcpu);
> > -		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
> > +		if (vmx_get_guest_debugctl(vcpu) & DEBUGCTLMSR_LBR)
> >  			goto warn;
> >  		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
> >  			goto warn;
> > @@ -751,7 +752,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu=
)
> > =20
> >  static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
> >  {
> > -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> > +	if (!(vmx_get_guest_debugctl(vcpu) & DEBUGCTLMSR_LBR))
> >  		intel_pmu_release_guest_lbr_event(vcpu);
> >  }
> > =20
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index ef2d7208dd20..4237422dc4ed 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2154,7 +2154,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr=
_data *msr_info)
> >  			msr_info->data =3D vmx->pt_desc.guest.addr_a[index / 2];
> >  		break;
> >  	case MSR_IA32_DEBUGCTLMSR:
> > -		msr_info->data =3D vmcs_read64(GUEST_IA32_DEBUGCTL);
> > +		msr_info->data =3D vmx_get_guest_debugctl(vcpu);
> >  		break;
> >  	default:
> >  	find_uret_msr:
> > @@ -2194,6 +2194,41 @@ static u64 vmx_get_supported_debugctl(struct kvm=
_vcpu *vcpu, bool host_initiated
> >  	return debugctl;
> >  }
> > =20
> > +u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
> > +{
> > +	return vmcs_read64(GUEST_IA32_DEBUGCTL);
> > +}
> > +
> > +static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
> > +{
> > +	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> > +}
>=20
> IMO,=C2=A0 it seems unnecessary to add these 2=C2=A0 wrappers since the o=
riginal code
> is already intuitive enough and simple. But if you want, please add
> "inline" before these 2 wrappers.

The __vmx_set_guest_debugctl in the next patch will store the written value=
 in
a field, this is why I did it this way.

The vmx_get_guest_debugctl will read this value instead, also in the next p=
atch.

I thought it would be cleaner to first introduce the trivial wrappers and t=
hen
extend them.

>=20
>=20
> > +
> > +bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host=
_initiated)
>=20
> Since most of code in this function checks guest debugctl, better to rena=
me
> it to "vmx_check_and_set_guest_debugctl".

I don't mind doing so.

>=20
>=20
> > +{
> > +	u64 invalid =3D data & ~vmx_get_supported_debugctl(vcpu, host_initiat=
ed);
> > +
> > +	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
> > +		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
> > +		data &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> > +		invalid &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
>=20
> Add space around above 3 "|".

I copied this code "as is" from the wrmsr code. I can add this though.

Best regards,
	Maxim Levitsky

>=20
>=20
> > +	}
> > +
> > +	if (invalid)
> > +		return false;
> > +
> > +	if (is_guest_mode(vcpu) && (get_vmcs12(vcpu)->vm_exit_controls &
> > +					VM_EXIT_SAVE_DEBUG_CONTROLS))
> > +		get_vmcs12(vcpu)->guest_ia32_debugctl =3D data;
> > +
> > +	if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &=
&
> > +	    (data & DEBUGCTLMSR_LBR))
> > +		intel_pmu_create_guest_lbr_event(vcpu);
> > +
> > +	__vmx_set_guest_debugctl(vcpu, data);
> > +	return true;
> > +}
> > +
> >  /*
> >   * Writes msr value into the appropriate "register".
> >   * Returns 0 on success, non-0 otherwise.
> > @@ -2263,26 +2298,9 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct ms=
r_data *msr_info)
> >  		vmcs_writel(GUEST_SYSENTER_ESP, data);
> >  		break;
> >  	case MSR_IA32_DEBUGCTLMSR: {
> > -		u64 invalid;
> > -
> > -		invalid =3D data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_=
initiated);
> > -		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
> > -			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
> > -			data &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> > -			invalid &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> > -		}
> > -
> > -		if (invalid)
> > +		if (!vmx_set_guest_debugctl(vcpu, data, msr_info->host_initiated))
> >  			return 1;
> > =20
> > -		if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
> > -						VM_EXIT_SAVE_DEBUG_CONTROLS)
> > -			get_vmcs12(vcpu)->guest_ia32_debugctl =3D data;
> > -
> > -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> > -		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event =
&&
> > -		    (data & DEBUGCTLMSR_LBR))
> > -			intel_pmu_create_guest_lbr_event(vcpu);
> >  		return 0;
> >  	}
> >  	case MSR_IA32_BNDCFGS:
> > @@ -4795,7 +4813,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
> >  	vmcs_write32(GUEST_SYSENTER_CS, 0);
> >  	vmcs_writel(GUEST_SYSENTER_ESP, 0);
> >  	vmcs_writel(GUEST_SYSENTER_EIP, 0);
> > -	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
> > +	__vmx_set_guest_debugctl(&vmx->vcpu, 0);
> > =20
> >  	if (cpu_has_vmx_tpr_shadow()) {
> >  		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 6d1e40ecc024..8ac46fb47abd 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -404,6 +404,9 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu=
);
> > =20
> >  gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned=
 int flags);
> > =20
> > +bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 value, bool hos=
t_initiated);
> > +u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu);
> > +
> >  static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u3=
2 msr,
> >  					     int type, bool value)
> >  {


