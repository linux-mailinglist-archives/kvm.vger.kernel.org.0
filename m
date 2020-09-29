Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84B327BBD6
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 06:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgI2EQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 00:16:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:49236 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgI2EQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 00:16:18 -0400
IronPort-SDR: 8x9ufB+8lNPuLi2gUoTdevAeyDOpEU4GeBKUBa+hn3XoAL6FSiG4xARD8RNqlPq9fUASnDjTsH
 fH5fpt3i7s4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="141511349"
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="141511349"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:03:14 -0700
IronPort-SDR: H+A8gaOj84RpkZt74p+GjpzFAfHlGf+IYoh0enZRvL1fIkCabp2geqNngGtJ0RW1hP8m88adg4
 YJ7mfJIdYITg==
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="350068368"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:03:13 -0700
Date:   Mon, 28 Sep 2020 21:03:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pbonzini@redhat.com,
        vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: Re: [PATCH 1/6 v3] KVM: x86: Change names of some of the kvm_x86_ops
 functions to make them more semantical and readable
Message-ID: <20200929040309.GI31514@linux.intel.com>
References: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
 <1595895050-105504-2-git-send-email-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595895050-105504-2-git-send-email-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This needs a changelog.

I would also split the non-x86 parts, i.e. the kvm_arch_* renames, to a
separate patch.

On Tue, Jul 28, 2020 at 12:10:45AM +0000, Krish Sadhukhan wrote:
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
> @@ -4016,15 +4016,15 @@ static int svm_vm_init(struct kvm *kvm)
>  	.tlb_flush_gva = svm_flush_tlb_gva,
>  	.tlb_flush_guest = svm_flush_tlb,
>  
> -	.run = svm_vcpu_run,
> +	.vcpu_run = svm_vcpu_run,
>  	.handle_exit = handle_exit,
>  	.skip_emulated_instruction = skip_emulated_instruction,
>  	.update_emulated_instruction = NULL,
>  	.set_interrupt_shadow = svm_set_interrupt_shadow,
>  	.get_interrupt_shadow = svm_get_interrupt_shadow,
>  	.patch_hypercall = svm_patch_hypercall,
> -	.set_irq = svm_set_irq,
> -	.set_nmi = svm_inject_nmi,
> +	.inject_irq = svm_set_irq,

I would strongly prefer these renames to be fully recursive within a single
patch, i.e. rename svm_set_irq() as well.

Ditto for the unsetup->teardown change.

> +	.inject_nmi = svm_inject_nmi,
>  	.queue_exception = svm_queue_exception,
>  	.cancel_injection = svm_cancel_injection,
>  	.interrupt_allowed = svm_interrupt_allowed,
> @@ -4080,8 +4080,8 @@ static int svm_vm_init(struct kvm *kvm)
>  	.enable_smi_window = enable_smi_window,
>  
>  	.mem_enc_op = svm_mem_enc_op,
> -	.mem_enc_reg_region = svm_register_enc_region,
> -	.mem_enc_unreg_region = svm_unregister_enc_region,
> +	.mem_enc_register_region = svm_register_enc_region,
> +	.mem_enc_unregister_region = svm_unregister_enc_region,
>  
>  	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>  

...

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4fdf303..cb6f153 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1469,15 +1469,15 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
>  #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
>  /* Memory Encryption Commands */
> -#define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
> +#define KVM_MEM_ENC_OP	            _IOWR(KVMIO, 0xba, unsigned long)

Renaming macros in uapi headers will break userspace.

We could do

  #define KVM_MEMORY_ENCRYPT_OP	KVM_MEM_ENC_OP

internally, but personally I think it would do more harm than good.

>  struct kvm_enc_region {
>  	__u64 addr;
>  	__u64 size;
>  };
>  
> -#define KVM_MEMORY_ENCRYPT_REG_REGION    _IOR(KVMIO, 0xbb, struct kvm_enc_region)
> -#define KVM_MEMORY_ENCRYPT_UNREG_REGION  _IOR(KVMIO, 0xbc, struct kvm_enc_region)
> +#define KVM_MEM_ENC_REGISTER_REGION    _IOR(KVMIO, 0xbb, struct kvm_enc_region)
> +#define KVM_MEM_ENC_UNREGISTER_REGION  _IOR(KVMIO, 0xbc, struct kvm_enc_region)
>  
>  /* Available with KVM_CAP_HYPERV_EVENTFD */
>  #define KVM_HYPERV_EVENTFD        _IOW(KVMIO,  0xbd, struct kvm_hyperv_eventfd)
