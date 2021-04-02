Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C3B352F0A
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 20:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbhDBSRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 14:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhDBSRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 14:17:38 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A3AC061788
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 11:17:36 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l76so4011032pga.6
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 11:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qqXjWnc9ML/bcpzIHf5bRqeBJESqpwHUrhP4MHjE0T4=;
        b=UgFw2oY+ZRmjBrI+HocdCghz5U/RM8efiWjByi4mf5E3a69DOscOhrc+CO3/VVTKiQ
         waImCXeKsFs2ApQGGYaRN2NUQMvigRTqu2cB568Evid8OO5/Ds48WBYQ7y36yZJOBMD5
         0RjOegQnwjhOsWeTAQ6dVvSBbvv0OFwOT9XgiIUqQo6yxWZjJCVCSS/6TVvxI+1l1y20
         fVzHU7Vc7TIjwB6tNBof5yeY3M1hW2JZf8w45SLXzu8KTGtiH9woveAkkLyjG+Pq103S
         gDoFSvBgpHvrEqiezBxagHkxO+1DAjFiPDGV39pPwQ1snn6mI2RfCEqOTlqhN4B6kV+p
         fk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qqXjWnc9ML/bcpzIHf5bRqeBJESqpwHUrhP4MHjE0T4=;
        b=sWzgV5pBWoBn0q9wjj+QdV/a+/lQKIAtmvhUsKWTK5YBANzKCrJoGN+yuiTl2/hVIW
         6WCMOYyP1rqvb2KG9PsrAGseiJ2IgEtnrR2eDfNEjXVR7OkklCOvVfM9Hi8ziJYQvyq6
         wcDS8qA4XQmGEX0vYkeL3QXqMRSGQpeo73vEZOyQurPpRJYdqAiEtEi2uCTbrrpCYwgi
         E5tCasBu4hmb6GO2MkobF7RXSsmWStH+TpHObHA3RQZAOfJhxCu9U47CJelo9re9Pwoy
         7LZnWhGQmt7yTxh4qe7RlKr1WW6voCbFVXY5o5AEX6zLCJNuaYE9T4GX3IuiJZ6CKKvV
         YeWQ==
X-Gm-Message-State: AOAM532W7sdTsUxryOgX2xErNpqOnpd+he1PCYhg5C9vJP+nXZCogEoh
        O8I+8C0jYW3UckR3kVQpe7J7bA==
X-Google-Smtp-Source: ABdhPJxlfKESClPxc5SRHaI+PcMJk0/mwNXEX9ztpongx5imilBRMt1Fx8h9plp/vryUGjp6ZcmiYQ==
X-Received: by 2002:a63:6742:: with SMTP id b63mr4225651pgc.295.1617387455980;
        Fri, 02 Apr 2021 11:17:35 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 8sm8810808pjj.53.2021.04.02.11.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 11:17:35 -0700 (PDT)
Date:   Fri, 2 Apr 2021 18:17:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nathan Tempelman <natet@google.com>
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Ashish.Kalra@amd.com, dovmurik@linux.vnet.ibm.com,
        lersek@redhat.com, jejb@linux.ibm.com, frankeh@us.ibm.com
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <YGdfu2Ex3y+Nm9Zf@google.com>
References: <20210316014027.3116119-1-natet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316014027.3116119-1-natet@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021, Nathan Tempelman wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 874ea309279f..b2c90c67a0d9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -66,6 +66,11 @@ static int sev_flush_asids(void)
>  	return ret;
>  }
>  
> +static inline bool is_mirroring_enc_context(struct kvm *kvm)
> +{
> +	return to_kvm_svm(kvm)->sev_info.enc_context_owner;

This is one of the few times where I actually think "!!" would be helpful.

> +}
> +
>  /* Must be called with the sev_bitmap_lock held */
>  static bool __sev_recycle_asids(int min_asid, int max_asid)
>  {
> @@ -1124,6 +1129,10 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
>  		return -EFAULT;
>  
> +	/* enc_context_owner handles all memory enc operations */
> +	if (is_mirroring_enc_context(kvm))

This needs to be checked after acquiring kvm->lock to avoid TOCTOU.

> +		return -ENOTTY;

-ENOTTY doesn't seem right, -EINVAL feels more appropriate.

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
> +		return -ENOTTY;

Same comment about -ENOTTY vs. -EINVAL.

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
> @@ -1282,6 +1299,71 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  	return ret;
>  }
>  
> +int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +	struct file *source_kvm_file;
> +	struct kvm *source_kvm;
> +	struct kvm_sev_info *mirror_sev;

Can we just call this "sev" to match "kvm".  If there's ever confusion, the
source can be "source_sev".

> +	unsigned int asid;
> +	int ret;
> +
> +	source_kvm_file = fget(source_fd);
> +	if (!file_is_kvm(source_kvm_file)) {
> +		ret = -EBADF;
> +		goto e_source_put;
> +	}
> +
> +	source_kvm = source_kvm_file->private_data;
> +	mutex_lock(&source_kvm->lock);
> +
> +	if (!sev_guest(source_kvm)) {
> +		ret = -ENOTTY;
> +		goto e_source_unlock;
> +	}
> +
> +	/* Mirrors of mirrors should work, but let's not get silly */
> +	if (is_mirroring_enc_context(source_kvm) || source_kvm == kvm) {
> +		ret = -ENOTTY;

Again, -ENOTTY does not feel right, especially for the "source_kvm == kvm" case.

> +		goto e_source_unlock;
> +	}
> +
> +	asid = to_kvm_svm(source_kvm)->sev_info.asid;
> +
> +	/*
> +	 * The mirror kvm holds an enc_context_owner ref so its asid can't
> +	 * disappear until we're done with it
> +	 */
> +	kvm_get_kvm(source_kvm);

My comment from before still stands; why can't we simply keep source_kvm_file?

> +
> +	fput(source_kvm_file);
> +	mutex_unlock(&source_kvm->lock);
> +	mutex_lock(&kvm->lock);
> +
> +	if (sev_guest(kvm)) {
> +		ret = -ENOTTY;

-EINVAL again?

> +		goto e_mirror_unlock;
> +	}
> +
> +	/* Set enc_context_owner and copy its encryption context over */
> +	mirror_sev = &to_kvm_svm(kvm)->sev_info;
> +	mirror_sev->enc_context_owner = source_kvm;
> +	mirror_sev->asid = asid;
> +	mirror_sev->active = true;
> +
> +	mutex_unlock(&kvm->lock);
> +	return 0;
> +
> +e_mirror_unlock:
> +	mutex_unlock(&kvm->lock);
> +	kvm_put_kvm(source_kvm);
> +	return ret;
> +e_source_unlock:
> +	mutex_unlock(&source_kvm->lock);
> +e_source_put:
> +	fput(source_kvm_file);
> +	return ret;
> +}
> +
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1293,6 +1375,12 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  	mutex_lock(&kvm->lock);
>  
> +	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
> +	if (is_mirroring_enc_context(kvm)) {
> +		kvm_put_kvm(sev->enc_context_owner);
> +		return;

This returns without dropping kvm->lock.  This is the last reference to the VM,
so it should be safe to simply do this out of the lock.  I actually don't know
why this function takes the lock in the first place, AFAICT there is nothing
else that can conflict.

> +	}
> +
>  	/*
>  	 * Ensure that all guest tagged cache entries are flushed before
>  	 * releasing the pages back to the system for use. CLFLUSH will
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 42d4710074a6..9ffb2bcf5389 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4608,6 +4608,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.mem_enc_reg_region = svm_register_enc_region,
>  	.mem_enc_unreg_region = svm_unregister_enc_region,
>  
> +	.vm_copy_enc_context_from = svm_vm_copy_asid_from,

Looking at this in tree, I feel even more strongly that this sould be a flavor
of KVM_MEMORY_ENCRYPT_OP.  There's practically zero chance this will be useful
for TDX, and IIRC the same is true for other architctures.

> +
>  	.can_emulate_instruction = svm_can_emulate_instruction,
>  
>  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 39e071fdab0c..779009839f6a 100644
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
> +int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3fa140383f5d..343cb05c2a24 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3753,6 +3753,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_X86_USER_SPACE_MSR:
>  	case KVM_CAP_X86_MSR_FILTER:
>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> +	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
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
> +	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
> +		r = -ENOTTY;
> +		if (kvm_x86_ops.vm_copy_enc_context_from)
> +			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);

static_call()

> +		return r;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e126ebda36d0..dc5a81115df7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -637,6 +637,7 @@ void kvm_exit(void);
>  
>  void kvm_get_kvm(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
> +bool file_is_kvm(struct file *file);
>  void kvm_put_kvm_no_destroy(struct kvm *kvm);
>  
>  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 63f8f6e95648..9dc00f9baf54 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1077,6 +1077,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SYS_HYPERV_CPUID 191
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
> +#define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 194
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 001b9de4e727..5baf82b01e0c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4041,6 +4041,12 @@ static struct file_operations kvm_vm_fops = {
>  	KVM_COMPAT(kvm_vm_compat_ioctl),
>  };
>  
> +bool file_is_kvm(struct file *file)
> +{
> +	return file && file->f_op == &kvm_vm_fops;
> +}
> +EXPORT_SYMBOL_GPL(file_is_kvm);
> +
>  static int kvm_dev_ioctl_create_vm(unsigned long type)
>  {
>  	int r;
> -- 
> 2.31.0.rc2.261.g7f71774620-goog
> 
