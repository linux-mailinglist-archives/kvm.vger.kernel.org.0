Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8575756B73A
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 12:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbiGHKZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 06:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbiGHKZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 06:25:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670A322BFB;
        Fri,  8 Jul 2022 03:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657275933; x=1688811933;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Q+E4LoDet/Mx5+pBeJs1uVYlUAFyEaQJKSz+LHQc2b4=;
  b=Z2D4Vle85WLNIJK3rtEYxeiMnqVuuezFYHveHVjXyXbUNaWg4Ir5nkJ3
   6Bt7/wg/zBvP/rGUHTL049+eDbTk0ywjjgX5rzsiQStjmUtdGb4xQiY9M
   BLujtJ76dsOR9xEnFQtaANSvlbZ68G14Tw3v0E6j/uAJLmgQjc9jYPkOM
   okAhVh1+dK5CzrZXM5jQEgsF9K2iL+tiriKWwA2jd5ADiv48AE/xmVvaq
   3ldqYoh9YhvX7UZmBDLx63wrL1iaIhFpcmX0pV15bEyhACx5q4/Db+Mcy
   0MVwDa0Lvo71d41Xo85fcNRIBHVz7C7J0XlZRB9tv7YHd0lsja9xaIqT6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="285378336"
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="285378336"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 03:25:09 -0700
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="626664222"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 03:25:07 -0700
Message-ID: <5085857e16cdb133803ee3edf3b1e8b776b2a7b1.camel@intel.com>
Subject: Re: [PATCH v7 050/102] KVM: VMX: Split out guts of EPT violation to
 common/exposed function
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Fri, 08 Jul 2022 22:25:05 +1200
In-Reply-To: <5202bef37eb1d9683891f29ccba182bbdceafca4.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <5202bef37eb1d9683891f29ccba182bbdceafca4.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> The difference of TDX EPT violation is how to retrieve information, GPA,
> and exit qualification.  To share the code to handle EPT violation, split
> out the guts of EPT violation handler so that VMX/TDX exit handler can ca=
ll
> it after retrieving GPA and exit qualification.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/common.h | 33 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c    | 32 ++++++--------------------------
>  2 files changed, 39 insertions(+), 26 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/common.h
>=20
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> new file mode 100644
> index 000000000000..235908f3e044
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_X86_VMX_COMMON_H
> +#define __KVM_X86_VMX_COMMON_H
> +
> +#include <linux/kvm_host.h>
> +
> +#include "mmu.h"
> +
> +static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_=
t gpa,
> +					     unsigned long exit_qualification)
> +{
> +	u64 error_code;
> +
> +	/* Is it a read fault? */
> +	error_code =3D (exit_qualification & EPT_VIOLATION_ACC_READ)
> +		     ? PFERR_USER_MASK : 0;
> +	/* Is it a write fault? */
> +	error_code |=3D (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> +		      ? PFERR_WRITE_MASK : 0;
> +	/* Is it a fetch fault? */
> +	error_code |=3D (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> +		      ? PFERR_FETCH_MASK : 0;
> +	/* ept page table entry is present? */
> +	error_code |=3D (exit_qualification & EPT_VIOLATION_RWX_MASK)
> +		      ? PFERR_PRESENT_MASK : 0;
> +
> +	error_code |=3D (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) !=
=3D 0 ?
> +	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> +
> +	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +}
> +
> +#endif /* __KVM_X86_VMX_COMMON_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e3d304b14df0..2f1dc06aec3c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -50,6 +50,7 @@
>  #include <asm/vmx.h>
> =20
>  #include "capabilities.h"
> +#include "common.h"
>  #include "cpuid.h"
>  #include "evmcs.h"
>  #include "hyperv.h"
> @@ -5578,11 +5579,10 @@ static int handle_task_switch(struct kvm_vcpu *vc=
pu)
> =20
>  static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long exit_qualification;
> -	gpa_t gpa;
> -	u64 error_code;
> +	unsigned long exit_qualification =3D vmx_get_exit_qual(vcpu);
> +	gpa_t gpa =3D vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> =20
> -	exit_qualification =3D vmx_get_exit_qual(vcpu);
> +	trace_kvm_page_fault(gpa, exit_qualification);
> =20
>  	/*
>  	 * EPT violation happened while executing iret from NMI,
> @@ -5591,29 +5591,9 @@ static int handle_ept_violation(struct kvm_vcpu *v=
cpu)
>  	 * AAK134, BY25.
>  	 */
>  	if (!(to_vmx(vcpu)->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
> -			enable_vnmi &&
> -			(exit_qualification & INTR_INFO_UNBLOCK_NMI))
> +	    enable_vnmi && (exit_qualification & INTR_INFO_UNBLOCK_NMI))

Why this code change?

With this removed:

Reviewed-by: Kai Huang <kai.huang@intel.com>

>  		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO, GUEST_INTR_STATE_NMI);
> =20
> -	gpa =3D vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> -	trace_kvm_page_fault(gpa, exit_qualification);
> -
> -	/* Is it a read fault? */
> -	error_code =3D (exit_qualification & EPT_VIOLATION_ACC_READ)
> -		     ? PFERR_USER_MASK : 0;
> -	/* Is it a write fault? */
> -	error_code |=3D (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> -		      ? PFERR_WRITE_MASK : 0;
> -	/* Is it a fetch fault? */
> -	error_code |=3D (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> -		      ? PFERR_FETCH_MASK : 0;
> -	/* ept page table entry is present? */
> -	error_code |=3D (exit_qualification & EPT_VIOLATION_RWX_MASK)
> -		      ? PFERR_PRESENT_MASK : 0;
> -
> -	error_code |=3D (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) !=
=3D 0 ?
> -	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> -
>  	vcpu->arch.exit_qualification =3D exit_qualification;
> =20
>  	/*
> @@ -5627,7 +5607,7 @@ static int handle_ept_violation(struct kvm_vcpu *vc=
pu)
>  	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, =
gpa)))
>  		return kvm_emulate_instruction(vcpu, 0);
> =20
> -	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
>  }
> =20
>  static int handle_ept_misconfig(struct kvm_vcpu *vcpu)

