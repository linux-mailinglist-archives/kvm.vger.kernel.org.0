Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9A75AA880
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiIBHGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbiIBHGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:06:13 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C743ED6A;
        Fri,  2 Sep 2022 00:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662102320; x=1693638320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xcDo/D2QvP8U4j+89T0M37m9pNJoQwtOiHvvxnTTBGs=;
  b=HIMzcrbZeC5+AKOp8YtZ0dFRBDU50Q4tvHvGRXSlq/NMK9/s4486YDL1
   r73ixEdBwVFMiZ6OiTqrjDoVuCL6pLHPzrI2uiTf+n5x3zBkxDhMkc41V
   qW5b+jLpbV+0zFrUIcXN6MlzUx/igoBYeWlXVkoq0VxzqLXKrUzGwQ7YP
   yQdhhLlSpG5PAv8+mzyMaIY0NfNyuqOyIdRMMvf6YV8+n9E8RY+M46R9T
   pvx/9zKbFOGHUGpcUVxNNmI/Iay2O5L72VpJCalfvmoq2vrEVhhhfZ2vV
   lqrmPiXKrPbXQF5vk3mpZBgaDXxT/FhJxy1XMY5WCQua89EuKTQMbt2n7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="293489203"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="293489203"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 00:05:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="642795114"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga008.jf.intel.com with ESMTP; 02 Sep 2022 00:05:18 -0700
Date:   Fri, 2 Sep 2022 15:05:17 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 048/103] KVM: VMX: Split out guts of EPT violation to
 common/exposed function
Message-ID: <20220902070517.ijjciqdvx453bqha@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <43ba6d1e69e8379fa438fbe15f260c94e2ee8f0b.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43ba6d1e69e8379fa438fbe15f260c94e2ee8f0b.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:33PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> The difference of TDX EPT violation is how to retrieve information, GPA,
> and exit qualification.  To share the code to handle EPT violation, split
> out the guts of EPT violation handler so that VMX/TDX exit handler can call
> it after retrieving GPA and exit qualification.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/kvm/vmx/common.h | 33 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c    | 29 +++++------------------------
>  2 files changed, 38 insertions(+), 24 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/common.h
>
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
> +static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> +					     unsigned long exit_qualification)
> +{
> +	u64 error_code;
> +
> +	/* Is it a read fault? */
> +	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> +		     ? PFERR_USER_MASK : 0;
> +	/* Is it a write fault? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> +		      ? PFERR_WRITE_MASK : 0;
> +	/* Is it a fetch fault? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> +		      ? PFERR_FETCH_MASK : 0;
> +	/* ept page table entry is present? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
> +		      ? PFERR_PRESENT_MASK : 0;
> +
> +	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> +	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> +
> +	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +}
> +
> +#endif /* __KVM_X86_VMX_COMMON_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4a3b3dc5d4d2..3af8cd164274 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -50,6 +50,7 @@
>  #include <asm/vmx.h>
>
>  #include "capabilities.h"
> +#include "common.h"
>  #include "cpuid.h"
>  #include "evmcs.h"
>  #include "hyperv.h"
> @@ -5646,11 +5647,10 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
>
>  static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long exit_qualification;
> -	gpa_t gpa;
> -	u64 error_code;
> +	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
> +	gpa_t gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>
> -	exit_qualification = vmx_get_exit_qual(vcpu);
> +	trace_kvm_page_fault(gpa, exit_qualification);
>
>  	/*
>  	 * EPT violation happened while executing iret from NMI,
> @@ -5663,25 +5663,6 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  			(exit_qualification & INTR_INFO_UNBLOCK_NMI))
>  		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO, GUEST_INTR_STATE_NMI);
>
> -	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> -	trace_kvm_page_fault(gpa, exit_qualification);
> -
> -	/* Is it a read fault? */
> -	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> -		     ? PFERR_USER_MASK : 0;
> -	/* Is it a write fault? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> -		      ? PFERR_WRITE_MASK : 0;
> -	/* Is it a fetch fault? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> -		      ? PFERR_FETCH_MASK : 0;
> -	/* ept page table entry is present? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
> -		      ? PFERR_PRESENT_MASK : 0;
> -
> -	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> -	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> -
>  	vcpu->arch.exit_qualification = exit_qualification;
>
>  	/*
> @@ -5695,7 +5676,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
>  		return kvm_emulate_instruction(vcpu, 0);
>
> -	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
>  }
>
>  static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
> --
> 2.25.1
>
