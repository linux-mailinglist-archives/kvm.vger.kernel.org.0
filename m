Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4E06BDD4C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 01:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCQACc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 20:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCQACb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 20:02:31 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EADEE2765
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:02:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id bc12so2914478plb.0
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679011349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2CzypZrzuWfhutXM9cUGMct3IxtRSPGh7WrBeRV/saM=;
        b=TvCH8bD/Ld3BofqCGFhqXUfhJlWP8rnVZKNNJJ5V1jFfwuJglVla5206ithFE2zSxI
         jbpK6eH9A+Ro9Cfx1HP3KFJyrwgh0poYQSvPJRLw6seCReX47udMG9r06TGVbzLtd6iW
         +ANApBfqm8JPCZeOmjwvWJjcp7BZ1ukpfDh9coyx48jo2nmFq/1zAq8pJJlkAR9FS4dW
         /KzYT7gvTDKx8sbUHR3F+XDiuAeatmlcajXyG8PWdRSGqmSHvY0fN46dgD8K0hwc11JI
         A6MT2bzdNSmoYsgb6VWmv3vd2GSxXFOJHyYrGMB9goVhS2FBLNyTGzYetRiXVlqEdV5p
         EyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679011349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CzypZrzuWfhutXM9cUGMct3IxtRSPGh7WrBeRV/saM=;
        b=7T7nO2XXGLbbZfqhesZXbft0xlsustVureVqy+oXlSN+mk2RUYps+YokTGTZllCqxp
         EOWvunqgGlXYsvREj7J7kK21VWi6Tb4qqCZ1izDbIUIjR062ZFImA3H7NGFqWBUAmShG
         kORBXDHsu2fZwZusYPMWyDtCQBQ2Nua5PpZaeJojDOkD+akTABamQ2voN8J+I3skimuB
         wLbGysUenl92lQJ7cJ0OPHP03p3+QOPqKu8AlytP4lKeRXV1EnARYKNZK+lVeZskgkOU
         tQ7C0ulVdXuRKRIIRT2hBXjNPunFdQH+8ZAwqaJSY99Yl6HQrvrrFcE7Bt+KcafUV+pE
         jHFw==
X-Gm-Message-State: AO0yUKUyBsxWkx9Kq0fjH/6hldfIQbsEg1mDnO0acuNjaigdRNKE4DQV
        3jtRccipr/DKkefXteMvHds=
X-Google-Smtp-Source: AK7set8IxkNDvltJDT014rblq87JJS9guX4TlpsE+wGCTDMUbmxhv2jBMmN/pAo3am66wFBLOnMSlg==
X-Received: by 2002:a17:90a:1c6:b0:231:24c1:8028 with SMTP id 6-20020a17090a01c600b0023124c18028mr5991922pjd.29.1679011348585;
        Thu, 16 Mar 2023 17:02:28 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id co10-20020a17090afe8a00b0023b5566f744sm3757924pjb.39.2023.03.16.17.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 17:02:27 -0700 (PDT)
Date:   Thu, 16 Mar 2023 17:02:26 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
Message-ID: <20230317000226.GA408922@ls.amr.corp.intel.com>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-5-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230315021738.1151386-5-amoorthy@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 02:17:28AM +0000,
Anish Moorthy <amoorthy@google.com> wrote:

> Memory fault exits allow KVM to return useful information from
> KVM_RUN instead of having to -EFAULT when a guest memory access goes
> wrong. Document the intent and API of the new capability, and introduce
> helper functions which will be useful in places where it needs to be
> implemented.
> 
> Also allow the capability to be enabled, even though that won't
> currently *do* anything: implementations at the relevant -EFAULT sites
> will performed in subsequent commits.
> ---
>  Documentation/virt/kvm/api.rst | 37 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c             |  1 +
>  include/linux/kvm_host.h       | 16 +++++++++++++++
>  include/uapi/linux/kvm.h       | 16 +++++++++++++++
>  tools/include/uapi/linux/kvm.h | 15 ++++++++++++++
>  virt/kvm/kvm_main.c            | 28 +++++++++++++++++++++++++
>  6 files changed, 113 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 62de0768d6aa5..f9ca18bbec879 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6636,6 +6636,19 @@ array field represents return values. The userspace should update the return
>  values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>  spec refer, https://github.com/riscv/riscv-sbi-doc.
>  
> +::
> +
> +		/* KVM_EXIT_MEMORY_FAULT */
> +		struct {
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 len; /* in bytes */
> +		} memory_fault;
> +
> +Indicates a memory fault on the guest physical address range [gpa, gpa + len).
> +flags is a bitfield describing the reasons(s) for the fault. See
> +KVM_CAP_X86_MEMORY_FAULT_EXIT for more details.
> +
>  ::
>  
>      /* KVM_EXIT_NOTIFY */
> @@ -7669,6 +7682,30 @@ This capability is aimed to mitigate the threat that malicious VMs can
>  cause CPU stuck (due to event windows don't open up) and make the CPU
>  unavailable to host or other VMs.
>  
> +7.34 KVM_CAP_X86_MEMORY_FAULT_EXIT
> +----------------------------------
> +
> +:Architectures: x86

Why x86 specific?

> +:Parameters: args[0] is a bitfield specifying what reasons to exit upon.
> +:Returns: 0 on success, -EINVAL if unsupported or if unrecognized exit reason
> +          specified.
> +
> +This capability transforms -EFAULTs returned by KVM_RUN in response to guest
> +memory accesses into VM exits (KVM_EXIT_MEMORY_FAULT), with 'gpa' and 'len'
> +describing the problematic range of memory and 'flags' describing the reason(s)
> +for the fault.
> +
> +The implementation is currently incomplete. Please notify the maintainers if you
> +come across a case where it needs to be implemented.
> +
> +Through args[0], the capability can be set on a per-exit-reason basis.
> +Currently, the only exit reasons supported are
> +
> +1. KVM_MEMFAULT_REASON_UNKNOWN (1 << 0)
> +
> +Memory fault exits with a reason of UNKNOWN should not be depended upon: they
> +may be added, removed, or reclassified under a stable reason.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f706621c35b86..b3c1b2f57e680 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4425,6 +4425,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VAPIC:
>  	case KVM_CAP_ENABLE_CAP:
>  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +	case KVM_CAP_X86_MEMORY_FAULT_EXIT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8ada23756b0ec..d3ccfead73e42 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -805,6 +805,7 @@ struct kvm {
>  	struct notifier_block pm_notifier;
>  #endif
>  	char stats_id[KVM_STATS_NAME_SIZE];
> +	uint64_t memfault_exit_reasons;
>  };
>  
>  #define kvm_err(fmt, ...) \
> @@ -2278,4 +2279,19 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>  /* Max number of entries allowed for each kvm dirty ring */
>  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>  
> +/*
> + * If memory fault exits are enabled for any of the reasons given in exit_flags
> + * then sets up a KVM_EXIT_MEMORY_FAULT for the given guest physical address,
> + * length, and flags and returns -1.
> + * Otherwise, returns -EFAULT
> + */
> +inline int kvm_memfault_exit_or_efault(
> +	struct kvm_vcpu *vcpu, uint64_t gpa, uint64_t len, uint64_t exit_flags);
> +
> +/*
> + * Checks that all of the bits specified in 'reasons' correspond to known
> + * memory fault exit reasons.
> + */
> +bool kvm_memfault_exit_flags_valid(uint64_t reasons);
> +
>  #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d77aef872a0a0..0ba1d7f01346e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -264,6 +264,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_RISCV_SBI        35
>  #define KVM_EXIT_RISCV_CSR        36
>  #define KVM_EXIT_NOTIFY           37
> +#define KVM_EXIT_MEMORY_FAULT     38
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -505,6 +506,17 @@ struct kvm_run {
>  #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
>  			__u32 flags;
>  		} notify;
> +		/* KVM_EXIT_MEMORY_FAULT */
> +		struct {
> +			/*
> +			 * Indicates a memory fault on the guest physical address range
> +			 * [gpa, gpa + len). flags is a bitfield describing the reasons(s)
> +			 * for the fault.
> +			 */
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 len; /* in bytes */
> +		} memory_fault;
>  		/* Fix the size of the union. */
>  		char padding[256];
>  	};
> @@ -1184,6 +1196,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>  #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>  #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
> +#define KVM_CAP_X86_MEMORY_FAULT_EXIT 227
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -2237,4 +2250,7 @@ struct kvm_s390_zpci_op {
>  /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
>  #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
>  
> +/* Exit reasons for KVM_EXIT_MEMORY_FAULT */
> +#define KVM_MEMFAULT_REASON_UNKNOWN (1 << 0)
> +
>  #endif /* __LINUX_KVM_H */
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 55155e262646e..2b468345f25c3 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -264,6 +264,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_RISCV_SBI        35
>  #define KVM_EXIT_RISCV_CSR        36
>  #define KVM_EXIT_NOTIFY           37
> +#define KVM_EXIT_MEMORY_FAULT     38
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -505,6 +506,17 @@ struct kvm_run {
>  #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
>  			__u32 flags;
>  		} notify;
> +		/* KVM_EXIT_MEMORY_FAULT */
> +		struct {
> +			/*
> +			 * Indicates a memory fault on the guest physical address range
> +			 * [gpa, gpa + len). flags is a bitfield describing the reasons(s)
> +			 * for the fault.
> +			 */
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 len; /* in bytes */
> +		} memory_fault;
>  		/* Fix the size of the union. */
>  		char padding[256];
>  	};
> @@ -2228,4 +2240,7 @@ struct kvm_s390_zpci_op {
>  /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
>  #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
>  
> +/* Exit reasons for KVM_EXIT_MEMORY_FAULT */
> +#define KVM_MEMFAULT_REASON_UNKNOWN (1 << 0)
> +
>  #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e38ddda05b261..00aec43860ff1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1142,6 +1142,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  	spin_lock_init(&kvm->mn_invalidate_lock);
>  	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
>  	xa_init(&kvm->vcpu_array);
> +	kvm->memfault_exit_reasons = 0;
>  
>  	INIT_LIST_HEAD(&kvm->gpc_list);
>  	spin_lock_init(&kvm->gpc_lock);
> @@ -4671,6 +4672,14 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  
>  		return r;
>  	}
> +	case KVM_CAP_X86_MEMORY_FAULT_EXIT: {
> +		if (!kvm_vm_ioctl_check_extension(kvm, KVM_CAP_X86_MEMORY_FAULT_EXIT))
> +			return -EINVAL;
> +		else if (!kvm_memfault_exit_flags_valid(cap->args[0]))
> +			return -EINVAL;
> +		kvm->memfault_exit_reasons = cap->args[0];
> +		return 0;
> +	}

Is KVM_CAP_X86_MEMORY_FAULT_EXIT really specific to x86?
If so, this should go to kvm_vm_ioctl_enable_cap() in arch/x86/kvm/x86.c.
(Or make it non-arch specific.)


>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> @@ -6172,3 +6181,22 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
>  
>  	return init_context.err;
>  }
> +
> +inline int kvm_memfault_exit_or_efault(
> +	struct kvm_vcpu *vcpu, uint64_t gpa, uint64_t len, uint64_t exit_flags)
> +{
> +	if (!(vcpu->kvm->memfault_exit_reasons & exit_flags))
> +		return -EFAULT;
> +	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> +	vcpu->run->memory_fault.gpa = gpa;
> +	vcpu->run->memory_fault.len = len;
> +	vcpu->run->memory_fault.flags = exit_flags;
> +	return -1;

Why -1? 0? Anyway enum exit_fastpath_completion is x86 kvm mmu internal
convention. As WIP, it's okay for now, though.


> +}
> +
> +bool kvm_memfault_exit_flags_valid(uint64_t reasons)
> +{
> +	uint64_t valid_flags = KVM_MEMFAULT_REASON_UNKNOWN;
> +
> +	return !(reasons & !valid_flags);
> +}
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
