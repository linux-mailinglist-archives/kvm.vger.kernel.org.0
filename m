Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016EF445C02
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 23:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhKDWKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 18:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhKDWKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 18:10:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EAFC061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 15:07:44 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o14so9613061plg.5
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 15:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PamW47+b4tMqWw+sFDfzqtrHhdS+IOv79aGoo2p8uNY=;
        b=GED2Ehm9Zi6y79Gi5Mm1sz6hmGvAyOmP6xLjj4vPjSlv5M0Uf+U34+gNa4y59w71je
         B3vtzx3bXczA1+Cn/8XoCoUamSjqYuIJN6qMDqhxm+nfdRk1G+ionkQE/94jjx7SdxiW
         kiiiuUE0YmyxXyTvX6WcrFf6oVloz+hPmNzQXI6nh23f27GrEPmQZS/zuF/aMz6z8Ynk
         dGsEuSwQRC+F86Kfomkojp8PtdFKpqrRkV49fPFTXEqmOIOQLR60/UwY+87BL3h1s9dJ
         tK4jzB7GGx76604HPXZnxXU5Ow64iHXqCv3hO8FBSznCBxE1oF72qBsVDR6MFNdIJW4S
         ckag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PamW47+b4tMqWw+sFDfzqtrHhdS+IOv79aGoo2p8uNY=;
        b=uyi21Lfpz38NJfvYz5lwSEGKCam0GsbUuma80YM+OANCF6H+rGpzfmcPCQ5c3B87Jk
         35n+8o1qw5g8Ex6nwtoOT39wWalM7TF9cImpLOIAuyb643FX+PYn3yKwpd2mrZW4ooR5
         Zk14kV5VON13U9XFmCGG35AgmFZjVHWZSwK+T5uL+3F3kMOW/bxOOplg47CF8gBRlXVk
         2eXXnVHrJ/n5O6lFlem5GgvoGSzNY/quNGlrYv7ZJdqIigFUPxrt6wWLafZsDryQ5NsP
         xq/oN+GnfihYvZE31h3LJpFDh0HP7xl+9hLkJeWxtx/wuGybQPNwp95mBhfUrKb2bq5Q
         XZYw==
X-Gm-Message-State: AOAM532MGazDFhRAM2T/ddzmaJnb64xJOxIlRgIYK8Oph4iHFOu96alu
        mqFZIN3Fskf/woiabBZXQ1PTYn2yvKfujA==
X-Google-Smtp-Source: ABdhPJw3ooQFr3oV3qEUDHIIHTYPrkenU3e32atxmCM38GiIadnH0I3IhF3Z1utMudLmA3UXqUmqbw==
X-Received: by 2002:a17:90a:de0b:: with SMTP id m11mr25179200pjv.39.1636063664152;
        Thu, 04 Nov 2021 15:07:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s2sm4485755pgd.13.2021.11.04.15.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 15:07:43 -0700 (PDT)
Date:   Thu, 4 Nov 2021 22:07:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V11 2/5] KVM: SEV: Add support for SEV intra host
 migration
Message-ID: <YYRZq+Zt52FSyjVW@google.com>
References: <20211021174303.385706-1-pgonda@google.com>
 <20211021174303.385706-3-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021174303.385706-3-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo and anyone else, any thoughts before I lead Peter on an even longer wild
goose chase?

On Thu, Oct 21, 2021, Peter Gonda wrote:
> @@ -6706,6 +6706,21 @@ MAP_SHARED mmap will result in an -EINVAL return.
>  When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
>  perform a bulk copy of tags to/from the guest.
>  
> +7.29 KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM
> +-------------------------------------
> +
> +Architectures: x86 SEV enabled

I'd drop the "SEV enabled" part.  In a way, it's technically a lie for this one
patch since an SEV-ES VM is also an SEV VM, but doesn't support this capability.
And AFAICT no other ioctl()/capability provides this level of granularity.

> +Type: vm
> +Parameters: args[0] is the fd of the source vm
> +Returns: 0 on success
> +
> +This capability enables userspace to migrate the encryption context from the VM
> +indicated by the fd to the VM this is called on.
> +
> +This is intended to support intra-host migration of VMs between userspace VMMs.
> +in-guest workloads scheduled by the host. This allows for upgrading the VMM
> +process without interrupting the guest.
> +

...

> +static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {

Braces not needed.

> +		mutex_unlock(&vcpu->mutex);
> +	}
> +}
> +
> +static void sev_migrate_from(struct kvm_sev_info *dst,
> +			      struct kvm_sev_info *src)
> +{
> +	dst->active = true;
> +	dst->asid = src->asid;
> +	dst->misc_cg = src->misc_cg;

Ah, this is not correct.  If @dst is in a different cgroup, then @dst needs to
be charged and @src needs to be uncharged.

That would also provide a good opportunity to more tightly couple ->asid and
->misc_cg in the form of a helper.  Looking at the code, there's an invariant
that misc_cg is NULL if an ASID is not assigned.  I.e. these three lines belong
in a helper, irrespective of this code.

	misc_cg_uncharge(type, sev->misc_cg, 1);
	put_misc_cg(sev->misc_cg);
	sev->misc_cg = NULL;

> +	dst->handle = src->handle;
> +	dst->pages_locked = src->pages_locked;
> +
> +	src->asid = 0;
> +	src->active = false;
> +	src->handle = 0;
> +	src->pages_locked = 0;
> +	src->misc_cg = NULL;
> +	INIT_LIST_HEAD(&dst->regions_list);
> +	list_replace_init(&src->regions_list, &dst->regions_list);
> +}
> +
> +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> +	struct file *source_kvm_file;
> +	struct kvm *source_kvm;
> +	struct kvm_vcpu *vcpu;
> +	int i, ret;
> +
> +	ret = sev_lock_for_migration(kvm);
> +	if (ret)
> +		return ret;
> +
> +	if (sev_guest(kvm)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	source_kvm_file = fget(source_fd);
> +	if (!file_is_kvm(source_kvm_file)) {
> +		ret = -EBADF;
> +		goto out_fput;
> +	}
> +
> +	source_kvm = source_kvm_file->private_data;
> +	ret = sev_lock_for_migration(source_kvm);
> +	if (ret)
> +		goto out_fput;
> +
> +	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
> +		ret = -EINVAL;
> +		goto out_source;
> +	}
> +	ret = sev_lock_vcpus_for_migration(kvm);
> +	if (ret)
> +		goto out_dst_vcpu;
> +	ret = sev_lock_vcpus_for_migration(source_kvm);
> +	if (ret)
> +		goto out_source_vcpu;
> +
> +	sev_migrate_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
> +	kvm_for_each_vcpu(i, vcpu, source_kvm) {

Braces not needed.

> +		kvm_vcpu_reset(vcpu, /* init_event= */ false);

Phooey.  I made this suggestion, but in hindsight, it's a bad suggestion as KVM
doesn't currently have a true RESET path; there are quite a few blobs of code
that assume the vCPU has never been run if init_event=false.

And to go through kvm_vcpu_reset(), the vcpu needs to be loaded, not just locked.
It won't fail as hard as VMX, where KVM would write the wrong VMCS, but odds are
good something will eventually go sideways.

Aha!  An idea.  Marking the VM bugged doesn't work because "we need to keep using
the  source VM even after the state is transfered"[*], but the core idea is sound,
it just needs to add a different flag to more precisely prevent kvm_vcpu_ioctl().

If we rename KVM_REQ_VM_BUGGED=>KVM_REQ_VM_DEAD in a prep patch (see below), then
this patch can add something here (can't think of a good name)

	source_kvm->??? = true;
	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_DEAD);

and then check it in kvm_vcpu_ioctl()

	struct kvm *kvm = vcpu->kvm;

	if (kvm->mm != current->mm || kvm->vm_bugged || kvm->???)
		return -EIO;

That way the source vCPUs don't need to be locked and all vCPU ioctls() are
blocked, which I think is ideal since the vCPUs are in a frankenstate and really
should just die.

Maybe we can call the flag "zombie", or "mostly_dead" :-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c80fa1d378c9..e3f49ca01f95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9423,7 +9423,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
        }

        if (kvm_request_pending(vcpu)) {
-               if (kvm_check_request(KVM_REQ_VM_BUGGED, vcpu)) {
+               if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
                        r = -EIO;
                        goto out;
                }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f18df7fe874..de8d25cef183 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -150,7 +150,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
-#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VM_DEAD                  (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8

 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -654,7 +654,7 @@ struct kvm {
 static inline void kvm_vm_bugged(struct kvm *kvm)
 {
        kvm->vm_bugged = true;
-       kvm_make_all_cpus_request(kvm, KVM_REQ_VM_BUGGED);
+       kvm_make_all_cpus_request(kvm, KVM_REQ_VM_DEAD);
 }

 #define KVM_BUG(cond, kvm, fmt...)


Back when I made this bad suggestion in v7, you said "we need to keep using the
source VM even after the state is transfered"[*].  What all do you need to do
after the migration?  I assume it's mostly memory related per-VM ioctls?


[*] https://lkml.kernel.org/r/CAMkAt6q3as414YMZco6UyCycY+jKbaYS5BUdC+U+8iWmBft3+A@mail.gmail.com

> +	}
> +	ret = 0;
> +
> +out_source_vcpu:
> +	sev_unlock_vcpus_for_migration(source_kvm);
> +
> +out_dst_vcpu:
> +	sev_unlock_vcpus_for_migration(kvm);
> +
> +out_source:
> +	sev_unlock_after_migration(source_kvm);
> +out_fput:
> +	if (source_kvm_file)
> +		fput(source_kvm_file);
> +out_unlock:
> +	sev_unlock_after_migration(kvm);
> +	return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 68294491c23d..c2e25ae4757f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4637,6 +4637,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.mem_enc_unreg_region = svm_unregister_enc_region,
>  
>  	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
> +	.vm_migrate_protected_vm_from = svm_vm_migrate_from,
>  
>  	.can_emulate_instruction = svm_can_emulate_instruction,
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6d8d762d208f..d7b44b37dfcf 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -80,6 +80,7 @@ struct kvm_sev_info {
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
>  	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>  	struct misc_cg *misc_cg; /* For misc cgroup accounting */
> +	atomic_t migration_in_progress;
>  };
>  
>  struct kvm_svm {
> @@ -557,6 +558,7 @@ int svm_register_enc_region(struct kvm *kvm,
>  int svm_unregister_enc_region(struct kvm *kvm,
>  			      struct kvm_enc_region *range);
>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
> +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd);
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_set_cpu_caps(void);
>  void __init sev_hardware_setup(void);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0c8b5129effd..c80fa1d378c9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5665,6 +5665,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		if (kvm_x86_ops.vm_copy_enc_context_from)
>  			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
>  		return r;
> +	case KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM:

I wonder... would it make sense to hedge and just call this KVM_CAP_VM_MIGRATE_VM_FROM?
I can't think of a use case where KVM would "need" to do this for a non-protected
VM, but I also don't see a huge naming problem if the "PROTECTED" is omitted.

> +		r = -EINVAL;
> +		if (kvm_x86_ops.vm_migrate_protected_vm_from)
> +			r = kvm_x86_ops.vm_migrate_protected_vm_from(
> +				kvm, cap->args[0]);

Either let that poke out and/or refactor to avoid the indentation.  E.g.

		r = -EINVAL;
		if (!kvm_x86_ops.vm_migrate_protected_vm_from)
			break;

		return kvm_x86_ops.vm_migrate_protected_vm_from(kvm, cap->args[0]);

		
> +		return r;
>  	case KVM_CAP_EXIT_HYPERCALL:
>  		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
>  			r = -EINVAL;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a067410ebea5..77b292ed01c1 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_BINARY_STATS_FD 203
>  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>  #define KVM_CAP_ARM_MTE 205
> +#define KVM_CAP_VM_MIGRATE_PROTECTED_VM_FROM 206
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.33.0.1079.g6e70778dc9-goog
> 
