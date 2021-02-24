Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BEE32433D
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 18:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhBXRiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 12:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBXRhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 12:37:54 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC61AC061574
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 09:37:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t9so1762673pjl.5
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 09:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sjZi1dBu9YhEG4sx69YtYggxBikEkWlnZUpAMg3oH2c=;
        b=v3GKcTc0LEtqG3aClW5To6YfovGekmv0kagm5Zkeh5dKEJg95RhiFFrI47up68AkIx
         egBULCuES3+c74HbKe27bMeUUVkUsbX698b4WXscufRVUGv5mr/ytbeKllkmFgtADWIA
         s8ccEV+Ce7j9tumTxghyB/3tMOeKEm/X7PaHCW2I7gSazdyI3/8XL2ZVUxzm+mn3xK95
         cU6HTIAxqN/pf3RYAqPMtAMCORckYiSRvmORRnG5q7gvQDSQcHIQ2IoL4YE2bv4DUyN3
         gcvtZQf//ejTaXhAjyHNqtdLGbakSgBuPCGGY7tQjAwUuWhEI6KG0Xdcb/vaSdSWFtia
         jLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sjZi1dBu9YhEG4sx69YtYggxBikEkWlnZUpAMg3oH2c=;
        b=OrFX2ClI1CwgAhn1dnINwwrqQ/Evdw0FSXk1ACTQoqbEZfegUKE4quZ3lj7z3X+2GL
         TYXchZ5SkA6EKDqU3jV4X9sKQHiCNJgnxFuoNnm01+h3JMl/c0m+k3S4uzj/eQ5tOm3V
         6qnyYKeAfO4hqO5D4Ue0JR+a2CZOVK6SONjpqRDJw1WfP0tGRhPfHeET9QrCutZoC50D
         eb+7QsZB0LpQ+AxEgePRjPkVON6QRFLB1VMns3PRHTOM+DWtKH5+it/01vPt6MlTCvlM
         fi6KxfFilk9Y7QtYz6mfYqinZVleOIvnMw+Sr4sTbbiy427iXaKxeY+El3HXdzWtufg5
         dEkw==
X-Gm-Message-State: AOAM533G1uMRp3fwdtXl5qMKSn/ZmL2V+sa8JZJ6OHZfonu+XgNCanE0
        I7ubj8z+X3zK5kllUM1JSBqy6Q==
X-Google-Smtp-Source: ABdhPJxt0KtbW9Q7Y1ChbbSolD8GUcs2y1enIlg1H8tWv7CH3n4jVNVJo5mQKhMD3B9vSGaQswJOuA==
X-Received: by 2002:a17:902:e5c8:b029:e3:9201:5121 with SMTP id u8-20020a170902e5c8b02900e392015121mr33197735plf.84.1614188234004;
        Wed, 24 Feb 2021 09:37:14 -0800 (PST)
Received: from google.com ([2620:15c:f:10:385f:4012:d20f:26b5])
        by smtp.gmail.com with ESMTPSA id gg5sm3477382pjb.3.2021.02.24.09.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 09:37:13 -0800 (PST)
Date:   Wed, 24 Feb 2021 09:37:07 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Nathan Tempelman <natet@google.com>
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Ashish.Kalra@amd.com
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <YDaOw48Ug7Tgr+M6@google.com>
References: <20210224085915.28751-1-natet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224085915.28751-1-natet@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021, Nathan Tempelman wrote:
>  static bool __sev_recycle_asids(int min_asid, int max_asid)
>  {
> @@ -1124,6 +1129,10 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
>  		return -EFAULT;
>  
> +	/* enc_context_owner handles all memory enc operations */
> +	if (is_mirroring_enc_context(kvm))
> +		return -ENOTTY;

Is this strictly necessary?  Honest question, as I don't know the hardware/PSP
flows well enough to understand how asids are tied to the state managed by the
PSP.

> +
>  	mutex_lock(&kvm->lock);
>  
>  	switch (sev_cmd.id) {
> @@ -1186,6 +1195,10 @@ int svm_register_enc_region(struct kvm *kvm,
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> +	/* If kvm is mirroring encryption context it isn't responsible for it */
> +	if (is_mirroring_enc_context(kvm))

Hmm, preventing the mirror from pinning memory only works if the two VMs are in
the same address space (process), which isn't guaranteed/enforced by the ioctl().
Obviously we could check and enforce that, but do we really need to?

Part of me thinks it would be better to treat the new ioctl() as a variant of
sev_guest_init(), i.e. purely make this a way to share asids.

> +		return -ENOTTY;
> +
>  	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>  		return -EINVAL;
>  
> @@ -1252,6 +1265,10 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  	struct enc_region *region;
>  	int ret;
>  
> +	/* If kvm is mirroring encryption context it isn't responsible for it */
> +	if (is_mirroring_enc_context(kvm))
> +		return -ENOTTY;
> +
>  	mutex_lock(&kvm->lock);
>  
>  	if (!sev_guest(kvm)) {
> @@ -1282,6 +1299,65 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  	return ret;
>  }
>  
> +int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int mirror_kvm_fd)
> +{
> +	struct file *mirror_kvm_file;
> +	struct kvm *mirror_kvm;
> +	struct kvm_sev_info *mirror_kvm_sev;

What about using src and dst, e.g. src_kvm, dest_kvm_fd, dest_kvm, etc...?  For
my brain, the mirror terminology adds an extra layer of translation.

> +	unsigned int asid;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	/* Mirrors of mirrors should work, but let's not get silly */

Do we really care?

> +	if (is_mirroring_enc_context(kvm)) {
> +		ret = -ENOTTY;
> +		goto failed;
> +	}
> +
> +	mirror_kvm_file = fget(mirror_kvm_fd);
> +	if (!kvm_is_kvm(mirror_kvm_file)) {
> +		ret = -EBADF;
> +		goto failed;
> +	}
> +
> +	mirror_kvm = mirror_kvm_file->private_data;
> +
> +	if (mirror_kvm == kvm || is_mirroring_enc_context(mirror_kvm)) {

This is_mirroring_enc_context() check needs to be after mirror_kvm->lock is
acquired, else there's a TOCTOU race.

I also suspect there needs to be more checks on the destination.  E.g. what
happens if the destination already has vCPUs that are currently running?  Though
on that front, sev_guest_init() also doesn't guard against this.  Feels like
that flow and this one should check kvm->created_vcpus.

> +		ret = -ENOTTY;
> +		fput(mirror_kvm_file);

Nit, probably worth adding a second error label to handle this fput(), e.g. in
case additional checks are needed in the future.  Actually, I suspect that's
already needed to fix the TOCTOU bug.

> +		goto failed;
> +	}
> +
> +	asid = *&to_kvm_svm(kvm)->sev_info.asid;

Don't think "*&" is necessary. :-)

> +
> +	/*
> +	 * The mirror_kvm holds an enc_context_owner ref so its asid can't
> +	 * disappear until we're done with it
> +	 */
> +	kvm_get_kvm(kvm);

Do we really need/want to take a reference to the source 'struct kvm'?  IMO,
the so called mirror should never be doing operations with its source context,
i.e. should not have easy access to 'struct kvm'.  We already have a reference
to the fd, any reason not to use that to ensure liveliness of the source?

> +
> +	mutex_unlock(&kvm->lock);
> +	mutex_lock(&mirror_kvm->lock);
> +
> +	/* Set enc_context_owner and copy its encryption context over */
> +	mirror_kvm_sev = &to_kvm_svm(mirror_kvm)->sev_info;
> +	mirror_kvm_sev->enc_context_owner = kvm;
> +	mirror_kvm_sev->asid = asid;
> +	mirror_kvm_sev->active = true;

I would prefer a prep patch to move "INIT_LIST_HEAD(&sev->regions_list);" from
sev_guest_init() to when the VM is instantiated.  Shaving a few cycles in that
flow is meaningless, and not initializing the list of regions is odd, and will
cause problems if mirrors are allowed to pin memory (or do PSP commands).

> +
> +	mutex_unlock(&mirror_kvm->lock);
> +	fput(mirror_kvm_file);
> +	return 0;
> +
> +failed:
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}
> +
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1293,6 +1369,12 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  	mutex_lock(&kvm->lock);
>  
> +	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
> +	if (is_mirroring_enc_context(kvm)) {
> +		kvm_put_kvm(sev->enc_context_owner);
> +		return;
> +	}
> +
>  	/*
>  	 * Ensure that all guest tagged cache entries are flushed before
>  	 * releasing the pages back to the system for use. CLFLUSH will
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 42d4710074a6..5308b7f8c11c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4608,6 +4608,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.mem_enc_reg_region = svm_register_enc_region,
>  	.mem_enc_unreg_region = svm_unregister_enc_region,
>  
> +	.vm_copy_enc_context_to = svm_vm_copy_asid_to,
> +
>  	.can_emulate_instruction = svm_can_emulate_instruction,
>  
>  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 39e071fdab0c..1e65c912552d 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -65,6 +65,7 @@ struct kvm_sev_info {
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> +	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>  };
>  
>  struct kvm_svm {
> @@ -561,6 +562,7 @@ int svm_register_enc_region(struct kvm *kvm,
>  			    struct kvm_enc_region *range);
>  int svm_unregister_enc_region(struct kvm *kvm,
>  			      struct kvm_enc_region *range);
> +int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int child_fd);
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3fa140383f5d..7bbcf37fcc2b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3753,6 +3753,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_X86_USER_SPACE_MSR:
>  	case KVM_CAP_X86_MSR_FILTER:
>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> +	case KVM_CAP_VM_COPY_ENC_CONTEXT_TO:
>  		r = 1;
>  		break;
>  	case KVM_CAP_XEN_HVM:
> @@ -4649,7 +4650,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  			kvm_update_pv_runtime(vcpu);
>  
>  		return 0;
> -
>  	default:
>  		return -EINVAL;
>  	}
> @@ -5321,6 +5321,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			kvm->arch.bus_lock_detection_enabled = true;
>  		r = 0;
>  		break;
> +	case KVM_CAP_VM_COPY_ENC_CONTEXT_TO:
> +		r = -ENOTTY;
> +		if (kvm_x86_ops.vm_copy_enc_context_to)
> +			r = kvm_x86_ops.vm_copy_enc_context_to(kvm, cap->args[0]);

This can be a static call.

On a related topic, does this really need to be a separate ioctl()?  TDX can't
share encryption contexts, everything that KVM can do for a TDX guest requires
the per-VM context.  Unless there is a known non-x86 use case, it might be
better to make this a mem_enc_op, and then it can be named SEV_SHARE_ASID or
something.

> +		return r;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e126ebda36d0..18491638f070 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -637,6 +637,7 @@ void kvm_exit(void);
>  
>  void kvm_get_kvm(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
> +bool kvm_is_kvm(struct file *file);
>  void kvm_put_kvm_no_destroy(struct kvm *kvm);
>  
>  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 63f8f6e95648..5b6296772db9 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1077,6 +1077,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SYS_HYPERV_CPUID 191
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
> +#define KVM_CAP_VM_COPY_ENC_CONTEXT_TO 194
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 001b9de4e727..5f31fcda4777 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -739,6 +739,8 @@ void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
>  {
>  }
>  
> +static struct file_operations kvm_vm_fops;

I'd probably prefer to put the helper just below kvm_vm_fops instead of adding
a forward declaration.  IMO it's not all that important to add the helper close
to kvm_get/put_kvm().

> +
>  static struct kvm *kvm_create_vm(unsigned long type)
>  {
>  	struct kvm *kvm = kvm_arch_alloc_vm();
> @@ -903,6 +905,12 @@ void kvm_put_kvm(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(kvm_put_kvm);
>  
> +bool kvm_is_kvm(struct file *file)

Heh, maybe kvm_file_is_kvm()?  or just file_is_kvm()?

> +{
> +	return file && file->f_op == &kvm_vm_fops;
> +}
> +EXPORT_SYMBOL_GPL(kvm_is_kvm);
> +
>  /*
>   * Used to put a reference that was taken on behalf of an object associated
>   * with a user-visible file descriptor, e.g. a vcpu or device, if installation
> -- 
> 2.30.0.617.g56c4b15f3c-goog
> 
