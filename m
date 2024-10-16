Return-Path: <kvm+bounces-29009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F049A0F2D
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 17:59:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C2FC1C22DD2
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 15:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B6620F5CB;
	Wed, 16 Oct 2024 15:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AtBBgWgc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4A31384B3
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729094371; cv=none; b=ReTjgDxzWLhT54itcSegbXAhzioY81svkgBXn0kJalsIF6YMtwNnyGw+wUQwi298/eApDfzxUtz0o2K565vbNFb0XWdhEkbUQGTECRKJ9hpC7oGMJ6XEpulL+/+6ImQp6GhdHSWkcP1IeREVsSoMQbQsWhi8myahHD6XxcwfgTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729094371; c=relaxed/simple;
	bh=cfGz0oIT2VUMmd58kRE4RTgmyoKJOCsM3kEpd8tGNHE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kYIrUDlWlC/68A6GvgGysVdUhdIvJAFt6MSrGUkCdA1hQjzRWZv65PmAfSk52j9IcEvhLouEbF1D9fmf47HSmAsW303jD+CrA5If8Stk/eNwnAxpr72Myqgx1wbStzSeGTVrF+KtdI87wKmgwa8FH2SMOSDSXfgy0cWVmzT5Npo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AtBBgWgc; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3705b2883so521427b3.3
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 08:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729094369; x=1729699169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iYXZbXCOGWbSeLqASLTyAQWqQbNT9MrywW3ddj/9vNU=;
        b=AtBBgWgcSf1bMI7Maq/ZBjGBkBheP77W+/iz+5Mx7xw24SPKTj5cb+lIYIaq4hVrKh
         Pi56U1oVPQscwHxw5TRkEONqgieqc4c5TWteBepkjOs+BbHMOQNdTyLf8mzgJeSZc2cK
         j9c3jL3Ja0kdLK0+UIvC4fHTcLvzawNaUc33lEmKsoQL8okxAzhTkq+ybLs8WbJb9n7b
         vQ/cXf4NMqdF5RdU8iShhq5d+Q5gSq7PY2uyZFKe1dQ4SIbRR+kWGOwv5W8VyBNrhAM3
         61RCwXcmPuecNvGvC3g5a4HWuKqrqjofCLy4ZxEtW/muuECMhZK6YRvwOlI7aZlE1H8G
         fZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729094369; x=1729699169;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iYXZbXCOGWbSeLqASLTyAQWqQbNT9MrywW3ddj/9vNU=;
        b=WQpG/pP0S9EZPEXFNS48GyF44D8LY1uMroZY04LEfCxzM+V+oD8NJmR80vx0h9lNCN
         JVN4tsWQ3or5+Ufdyv6hyns7eIPnnS1z6fVwTkxlzGigGPSr+Dc+XOuazz7WzgB/PZ9S
         fwGVlvCR7EPzaeKunJh/WvM+dA0WeRqbDS+3U8kFlxkoOuCd9jSi7ThBjswyrCrH0jc6
         UrrBYSc8xhHjnTTiU8VcdPyFFgH1I7H1Wzwb7sUHD50HEgvL5w69vtF6soaVgIeG1t7a
         C55geMTBQ6D7dZJhdvKkIea5NLJ8a43nVXtxeBGAARDVkWXjr8X6ZPspaHDZyvTLVNAx
         Ikvg==
X-Forwarded-Encrypted: i=1; AJvYcCVrLxWT3BcRpMkuEAhwFj8cuOPA+Cyual3s6kNiOlL/4SWS321jnHoI8el6V1kHfPiLY2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSZHLXdteccT2sqfvZxv/lhCtGCJMqPykuOdrDBio34E6OjJIy
	Ai78h/GR+fIyCjiLaBLlf0txwkfm5/EKmipG1Fj9AmhHA73xsvrNrGrfYn7iASXEgL1B2CFH5Ss
	nhw==
X-Google-Smtp-Source: AGHT+IG/y4BavRDFeI7M1MIg9zdlDt7p1T4tdUb+JqsaJdWT/IiFxduapCObf6CfWr8kmS4NK50CtdTMTXY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ad64:0:b0:e16:68fb:f261 with SMTP id
 3f1490d57ef6-e297830baadmr2171276.5.1729094368661; Wed, 16 Oct 2024 08:59:28
 -0700 (PDT)
Date: Wed, 16 Oct 2024 08:59:27 -0700
In-Reply-To: <ZwzczkIlYGX+QXJz@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211185552.3856862-1-jmattson@google.com> <7fe8970c-ecb7-4e46-be76-488d7697d8db@gmail.com>
 <ZwzczkIlYGX+QXJz@intel.com>
Message-ID: <Zw_i37S0FmRWfhM3@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] nVMX: Simple posted interrupts test
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Like Xu <like.xu.linux@gmail.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2024, Chao Gao wrote:
> On Wed, Oct 09, 2024 at 02:48:28PM +0800, Like Xu wrote:
> >On 12/12/23 2:55 AM, Jim Mattson wrote:
> >> I reported recently that commit 26844fee6ade ("KVM: x86: never write t=
o
> >> memory from kvm_vcpu_check_block()") broke delivery of a virtualized p=
osted
> >> interrupt from an L1 vCPU to a halted L2 vCPU (see
> >> https://lore.kernel.org/all/20231207010302.2240506-1-jmattson@google.c=
om/).
> >> The test that exposed the regression is the final patch of this series=
. The
> >> others are prerequisites.
> >>=20
> >> It would make sense to add "vmx_posted_interrupts_test" to the set of =
tests
> >> to be run under the unit test name, "vmx_apicv_test," but that is
> >> non-trivial. The vmx_posted_interrupts_test requires "smp =3D 2," but =
I find
> >> that adding that to the vmx_apicv_tests causes virt_x2apic_mode_test t=
o
> >> fail with:
> >>=20
> >> FAIL: x2apic - reading 0x310: x86/vmx_tests.c:2151: Assertion failed: =
(expected) =3D=3D (actual)
> >> 	LHS: 0x0000000000000012 - 0000'0000'0000'0000'0000'0000'0000'0000'000=
0'0000'0000'0000'0000'0000'0001'0010 - 18
> >> 	RHS: 0x0000000000000001 - 0000'0000'0000'0000'0000'0000'0000'0000'000=
0'0000'0000'0000'0000'0000'0000'0001 - 1
> >> Expected VMX_VMCALL, got VMX_EXTINT.
> >> 	STACK: 406ef8 40725a 41299f 402036 403f59 4001bd
> >>=20
> >> I haven't investigated.
> >
> >This vmx_apicv_test test still fails when 'ept=3DN' (SPR + v6.12-rc2):
> >
> >--- Virtualize APIC accesses + Use TPR shadow test ---
> >FAIL: xapic - reading 0x080: read 0x0, expected 0x70.
> >FAIL: xapic - writing 0x12345678 to 0x080: exitless write; val is 0x0, w=
ant
> >0x70
> >
> >--- APIC-register virtualization test ---
> >FAIL: xapic - reading 0x020: read 0x0, expected 0x12345678.
> >FAIL: xapic - writing 0x12345678 to 0x020: x86/vmx_tests.c:2164: Asserti=
on
> >failed: (expected) =3D=3D (actual)
> >	LHS: 0x0000000000000038 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'=
0000'0000'0000'0000'0000'0011'1000
> >- 56
> >	RHS: 0x0000000000000012 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'=
0000'0000'0000'0000'0000'0001'0010
> >- 18
> >Expected VMX_APIC_WRITE, got VMX_VMCALL.
> >	STACK: 406f7f 40d178 40202f 403f54 4001bd
>=20
> These failures occur because KVM flushes TLB with the wrong VPID, causing=
 TLB
> for the 'APIC-access page' to be retained across nested transitions. This=
 TLB
> entry exists because L1 writes to that page before entering the guest, se=
e
> test_xapic_rd():
>=20
>         /* Setup virtual APIC page */
>         if (!expectation->virtualize_apic_accesses) {
>                 apic_access_address[apic_reg_index(reg)] =3D val;
>                 virtual_apic_page[apic_reg_index(reg)] =3D 0;
>         } else if (exit_reason_want =3D=3D VMX_VMCALL) {
>                 apic_access_address[apic_reg_index(reg)] =3D 0;
>                 virtual_apic_page[apic_reg_index(reg)] =3D val;
>         }
>=20
>=20
> Specifically, in the failing scenario, EPT is disabled, and VPID is enabl=
ed in
> L0 but disabled in L1. As a result, vmcs01 and vmcs02 share the same VPID
> (vmx->vpid, see prepare_vmcs02_early_rare()), and vmx->nested.vpid02 is n=
ever
> used. But during nested transitions, KVM incorrectly flushes TLB using
> vmx->nested.vpid02. The sequence is as follows:
>=20
> 	nested_vmx_transition_tlb_flush ->
> 	  kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu) ->
> 	    kvm_vcpu_flush_tlb_guest ->=09
> 	      vmx_flush_tlb_guest ->
> 		vmx_get_current_vpid ->
>=20
> With the diff below applied, these failures disappear.
>=20
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index cce4e2aa30fb..246d9c6e20d0 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -61,13 +61,6 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu=
 *vcpu)
>  		nested_vmx_is_evmptr12_set(vmx);
>  }
> =20
> -static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> -
> -	return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
> -}
> -
>  static inline unsigned long nested_ept_get_eptp(struct kvm_vcpu *vcpu)
>  {
>  	/* return the page table to be shadowed - in our case, EPT12 */
> @@ -187,6 +180,16 @@ static inline bool nested_cpu_has_vpid(struct vmcs12=
 *vmcs12)
>  	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_VPID);
>  }
> =20
> +static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> +
> +	if (nested_cpu_has_vpid(get_vmcs12(vcpu)) && vmx->nested.vpid02)

This isn't quite right.  When KVM emulates INVVPID for L1, there is no way =
to
know which vmcs12 will be used and thus no way to know if KVM should invali=
date
vpid02 or vpid01.  So I'm fairly certain the correct fix is:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a4438358c5e..896f0fea0306 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3216,7 +3216,7 @@ void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
=20
 static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 {
-       if (is_guest_mode(vcpu))
+       if (is_guest_mode(vcpu) && nested_cpu_has_vpid(get_vmcs12(vcpu)))
                return nested_get_vpid02(vcpu);
        return to_vmx(vcpu)->vpid;
 }

Note, it's tempting, but subtly wrong (though not a violation of the archit=
ecture),
to use vpid02 when VPID is disabled in vmcs12, i.e. this would also resolve=
 the
issue, but would result in over-flushing.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a8e7bc04d9bf..ce89e2e27681 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2316,7 +2316,7 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx=
 *vmx,
        vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA);
=20
        if (enable_vpid) {
-               if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
+               if (vmx->nested.vpid02)
                        vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->nested.vpid=
02);
                else
                        vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);

And it's wrong because the comment in nested_vmx_transition_tlb_flush() is =
wrong:

	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
	 * full TLB flush from the guest's perspective

Per the SDM, only VPID=3D0 is flushed:

  If the =E2=80=9Cenable VPID=E2=80=9D VM-execution control is 0, VM entrie=
s and VM exits invalidate
  linear mappings and combined mappings associated with VPID 0000H (for all=
 PCIDs).
  Combined mappings for VPID 0000H are invalidated for all EPTRTAs.

so using vpid01, which mimics using L1's host VPID (of '0'), is correct.  A=
s above,
the fallout is simply that KVM will over-flush, e.g. if L1 runs L2 X with V=
PID=3D1,
then L2 Y with VPID disabled, and then runs X again, it's legal to retain T=
LB
entries for VPID=3D1 even though there was a VMX transition with VPID disab=
led.

I'll post a proper patch with lots of comments.

Thanks Chao!

