Return-Path: <kvm+bounces-45172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3426AA64CF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 22:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 537739A39D8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E092253924;
	Thu,  1 May 2025 20:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KXmeeUIA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34A4B674
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 20:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131714; cv=none; b=TmGPYjUob5i63NU+xX/XcVhmNZ2wD3q7syWDgmPRwLjcozLzX2hUuiw9UPpu5TatPSvQ+R670wj5yhXqIyJE2s1YvrfwOr9/QCuvnn9KC0RqJKpn+VTJVSN+pTMBz4lz+orsgRDt1hArdkL/1Rx7yS8bNJeOHxxkdKPHkAhMx44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131714; c=relaxed/simple;
	bh=744IgpeZI8AQ86NxfJtwPzupuE+/l+50aWVDFLPfm1s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=thbEMTZEN1rWtcbLsEMvupFom/kynKqxZ1E+DjbjHcjL6YINwfOQBftgyxYXz8hibMp2OVLSvxxzGw4KzMkbWZHwrEt7S5lNtrM27Chuzmb3R5MpqHCQ/kcPw7IiHn/UbrtXveBkuM91rsuTJm0RzjxUFKBQmVlmwxYX+Abe4kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KXmeeUIA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746131711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hdVWSIZLz1k/wCeHJMz+JEKUkQKBnamYo2OoM4WNzZo=;
	b=KXmeeUIAGMD+VzRETBq0H88uZ97fDCOl96CrMKi0imuv0HCdeE8/rY+zIjo3kO4UvKNAq+
	BPys5T9iZWWWf/xkN1dhCjrxjGH6PgXPMwfCfQeKowveGKZCEvhI5LyPKXgql6hxAtUKaP
	9r7GHX3fusz4Mwia6mEo4xElDkZ/B9k=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-ZMav_Qd_NQirNcLDVqXrVA-1; Thu, 01 May 2025 16:35:09 -0400
X-MC-Unique: ZMav_Qd_NQirNcLDVqXrVA-1
X-Mimecast-MFC-AGG-ID: ZMav_Qd_NQirNcLDVqXrVA_1746131709
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6f0e2d30ab4so28417616d6.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 13:35:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746131709; x=1746736509;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hdVWSIZLz1k/wCeHJMz+JEKUkQKBnamYo2OoM4WNzZo=;
        b=WoukbRaQ5/vcb2K0q5w+28bhvTfI8Vu0F6vdtGa+0HnNEekHpwi21ZqzuK6pK6nQGv
         Lj4wetPtiGow7La9LDa9hb9kRmg6JGq1Ise24nM7DEPo2bYhyR9DTogVJPMeNId2ZaFI
         9Uyw9a7hEMpGB81EoplZBNnoghqCRbd35bI+jw4BjzOjARE9rUgVF9I32hUNrn3STaXl
         uz4OGMJZ90pNMaDw1FG/EGdj7Zl+esLXDN1CytbXgFHO8iuTrGC4d2xDi/I+lDSG7RVS
         4oQz6x2+wBeuIWj7b2cbnZMwri0GXcglgxcZclZiCpBikw/wyVso9A4jRHNnfI4ldCZZ
         cGEg==
X-Gm-Message-State: AOJu0YyXcRUC6cFrNEyX1uVfQkJUPSFmCjw/T+0V4NBTb91yP18+41Pm
	fAIdqnfJc05DSMk7b0A8kmoKU/LJh9UoYuONtrKCAXiZeHzE3demTXLRQ2ttwiR6WdV2yxQzZhS
	CSF4mjRL3e9gGZ64AIi6rWLjQ5WGlWgd0Zl6GTZQtgIiE07cDkA==
X-Gm-Gg: ASbGncuXPC/AcVhOPPI5UiL9B2U7Q5gXZdQ8todB5y/csfFwx9KK7MkX88jx31TIhkj
	TrkLieLTNa6N16TjV7MB5mZH8zjK05iQBLSgN1IIBxIntllnxlnFuPJniMWjMi2jxFGUGxDfAbW
	tl8IklmTqPqA6BgSdUIOoknGIjKixaEn6bp9PK6cEb4NQEa+ZokaK/QYV9EGfJxsQ6BUSxdjNvQ
	XvtvV1l2HWjb+xZLesqB/DFrcQKpehNhSWUzy7woxRu1sspkpP66k/eCJZaffvwFWpmVykdErLL
	RYrkxnqRzDSiLnf7clklFaprnqw6GCUF1JOq4WD1coc+byfeeoeBQsQHHqs=
X-Received: by 2002:a05:6214:124d:b0:6f2:b14e:46e6 with SMTP id 6a1803df08f44-6f51526d362mr11171276d6.17.1746131709084;
        Thu, 01 May 2025 13:35:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGb8Nz4DcL3Cu1Ltf4oqxo2dugA5EurJTjUsbVrmXo5j90y4igGFrBf/DqJmp7vnSttsl2I0A==
X-Received: by 2002:a05:6214:124d:b0:6f2:b14e:46e6 with SMTP id 6a1803df08f44-6f51526d362mr11170946d6.17.1746131708713;
        Thu, 01 May 2025 13:35:08 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f50f3b05a3sm8993096d6.22.2025.05.01.13.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 13:35:08 -0700 (PDT)
Message-ID: <14eab14d368e68cb9c94c655349f94f44a9a15b4.camel@redhat.com>
Subject: Re: [PATCH 1/3] x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write
 with access functions
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav
 Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 01 May 2025 16:35:07 -0400
In-Reply-To: <aAgnRx2aMbNKOlXY@google.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
	 <20250416002546.3300893-2-mlevitsk@redhat.com>
	 <aAgnRx2aMbNKOlXY@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-04-22 at 16:33 -0700, Sean Christopherson wrote:
> On Tue, Apr 15, 2025, Maxim Levitsky wrote:
> > Instead of reading and writing GUEST_IA32_DEBUGCTL vmcs field directly,
> > wrap the logic with get/set functions.
>=20
> Why?  I know why the "set" helper is being added, but it needs to called =
out.
>=20
> Please omit the getter entirely, it does nothing more than obfuscate a ve=
ry
> simple line of code.

In this patch yes. But in the next patch I switch to reading from 'vmx->msr=
_ia32_debugctl'
You want me to open code this access? I don't mind, if you insist.

>=20
> > Also move the checks that the guest's supplied value is valid to the ne=
w
> > 'set' function.
>=20
> Please do this in a separate patch.  There's no need to mix refactoring a=
nd
> functional changes.

I thought that it was natural to do this in a the same patch. In this patch=
 I introduce
a 'vmx_set_guest_debugctl' which should be used any time we set the msr giv=
en
the guest value, and VM entry is one of these cases.

I can split this if you want.

>=20
> > In particular, the above change fixes a minor security issue in which L=
1
>=20
> Bug, yes.  Not sure it constitutes a meaningful security issue though.

I also think so, but I wanted to mention this just in case.

>=20
> > hypervisor could set the GUEST_IA32_DEBUGCTL, and eventually the host's
> > MSR_IA32_DEBUGCTL
>=20
> No, the lack of a consistency check allows the guest to set the MSR in ha=
rdware,
> but that is not the host's value.

That's what I meant - the guest can set the real hardware MSR. Yes, after t=
he
guest exits, the OS value is restored. I'll rephrase this in v2.

>=20
> > to any value by performing a VM entry to L2 with VM_ENTRY_LOAD_DEBUG_CO=
NTROLS
> > set.
>=20
> Any *legal* value.  Setting completely unsupported bits will result in VM=
-Enter
> failing with a consistency check VM-Exit.

True.

>=20
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
>=20
> The consistency check belongs in nested_vmx_check_guest_state(), only nee=
ds to
> check the VM_ENTRY_LOAD_DEBUG_CONTROLS case, and should be posted as a se=
parate
> patch.

I can move it there. Can you explain why though you want this? Is it becaus=
e of the
order of checks specified in the PRM?

Currently GUEST_IA32_DEBUGCTL of the host is *written* in prepare_vmcs02.=
=C2=A0
Should I also move this write to nested_vmx_check_guest_state?

Or should I write the value blindly in prepare_vmcs02 and then check the va=
lue
of 'vmx->msr_ia32_debugctl' in nested_vmx_check_guest_state and fail if the=
 value
contains reserved bits?=C2=A0
I don't like that idea that much IMHO.


>=20
> > +		*entry_failure_code =3D ENTRY_FAIL_DEFAULT;
> > +		return -EINVAL;
> > +	}
> > +
> > +static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
> > +{
> > +	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> > +}
> > +
> > +bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host=
_initiated)
> > +{
> > +	u64 invalid =3D data & ~vmx_get_supported_debugctl(vcpu, host_initiat=
ed);
> > +
> > +	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
> > +		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
> > +		data &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> > +		invalid &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
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
>=20
> Return 0/-errno, not true/false.

There are plenty of functions in this file and KVM that return boolean.

e.g:=C2=A0

static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmptr)

static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
						=C2=A0struct vmcs12 *vmcs12)


static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)

...


I personally think that functions that emulate hardware should return boole=
an values
or some hardware specific status code (e.g VMX failure code) because the re=
al hardware
never returns -EINVAL and such.


Best regards,
	Maxim Levitsky




>=20


