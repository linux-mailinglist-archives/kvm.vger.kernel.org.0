Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B740C71F336
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 21:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjFATwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 15:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjFATwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 15:52:14 -0400
Received: from out-53.mta0.migadu.com (out-53.mta0.migadu.com [IPv6:2001:41d0:1004:224b::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398A7C0
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 12:52:11 -0700 (PDT)
Date:   Thu, 1 Jun 2023 19:52:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685649128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NoZCcOiN20JW5+BJemNVrpWkGm4r8Ind9ZoZaXZrn+M=;
        b=v+OlLCXKytKKWij4pF5DOlx/Y8DqO4i/ZzqJJtQMxh+Klca8XxkQbsVulfhH1lN5K6rg3C
        ri9AhVXstZ7k+sBHx+rJUpUpKMz0S8CO8gUrD80En7eRyCughavLJlRjAqrIh11W/VgDNE
        X0Ns7fBWjyTre9/UEw+1khicWLF09eM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 05/22] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZHj25HsCExz/uCo/@linux.dev>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-6-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412213510.1220557-6-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 09:34:53PM +0000, Anish Moorthy wrote:

[...]

> +7.34 KVM_CAP_MEMORY_FAULT_INFO
> +------------------------------
> +
> +:Architectures: x86, arm64
> +:Parameters: args[0] - KVM_MEMORY_FAULT_INFO_ENABLE|DISABLE to enable/disable
> +             the capability.
> +:Returns: 0 on success, or -EINVAL if unsupported or invalid args[0].
> +
> +When enabled, EFAULTs "returned" by KVM_RUN in response to failed vCPU guest
> +memory accesses may be annotated with additional information. When KVM_RUN
> +returns an error with errno=EFAULT, userspace may check the exit reason: if it
> +is KVM_EXIT_MEMORY_FAULT, userspace is then permitted to read the 'memory_fault'
> +member of the run struct.

So the other angle of my concern w.r.t. NOWAIT exits is the fact that
userspace gets to decide whether or not we annotate such an exit. We all
agree that a NOWAIT exit w/o context isn't actionable, right?

Sean is suggesting that we abuse the fact that kvm_run already contains
junk for EFAULT exits and populate kvm_run::memory_fault unconditionally
[*]. I agree with him, and it eliminates the odd quirk of 'bare' NOWAIT
exits too. Old userspace will still see 'garbage' in kvm_run struct,
but one man's trash is another man's treasure after all :)

So, based on that, could you:

 - Unconditionally prepare MEMORY_FAULT exits everywhere you're
   converting here

 - Redefine KVM_CAP_MEMORY_FAULT_INFO as an informational cap, and do
   not accept an attempt to enable it. Instead, have calls to
   KVM_CHECK_EXTENSION return a set of flags describing the supported
   feature set.

   Eventually, you can stuff a bit in there to advertise that all
   EFAULTs are reliable.

[*] https://lore.kernel.org/kvmarm/ZHjqkdEOVUiazj5d@google.com/

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf7d3de6f3689..f3effc93cbef3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1142,6 +1142,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  	spin_lock_init(&kvm->mn_invalidate_lock);
>  	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
>  	xa_init(&kvm->vcpu_array);
> +	kvm->fill_efault_info = false;
>  
>  	INIT_LIST_HEAD(&kvm->gpc_list);
>  	spin_lock_init(&kvm->gpc_lock);
> @@ -4096,6 +4097,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  			put_pid(oldpid);
>  		}
>  		r = kvm_arch_vcpu_ioctl_run(vcpu);
> +		WARN_ON_ONCE(r == -EFAULT &&
> +					 vcpu->run->exit_reason != KVM_EXIT_MEMORY_FAULT);

This might be a bit overkill, as it will definitely fire on unsupported
architectures. Instead you may want to condition this on an architecture
actually selecting support for MEMORY_FAULT_INFO.

>  		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
>  		break;
>  	}
> @@ -4672,6 +4675,15 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  
>  		return r;
>  	}
> +	case KVM_CAP_MEMORY_FAULT_INFO: {
> +		if (!kvm_vm_ioctl_check_extension_generic(kvm, cap->cap)
> +			|| (cap->args[0] != KVM_MEMORY_FAULT_INFO_ENABLE
> +				&& cap->args[0] != KVM_MEMORY_FAULT_INFO_DISABLE)) {
> +			return -EINVAL;
> +		}
> +		kvm->fill_efault_info = cap->args[0] == KVM_MEMORY_FAULT_INFO_ENABLE;
> +		return 0;
> +	}
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> @@ -6173,3 +6185,35 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
>  
>  	return init_context.err;
>  }
> +
> +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> +					uint64_t gpa, uint64_t len)
> +{
> +	if (!vcpu->kvm->fill_efault_info)
> +		return;
> +
> +	preempt_disable();
> +	/*
> +	 * Ensure the this vCPU isn't modifying another vCPU's run struct, which
> +	 * would open the door for races between concurrent calls to this
> +	 * function.
> +	 */
> +	if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
> +		goto out;
> +	/*
> +	 * Try not to overwrite an already-populated run struct.
> +	 * This isn't a perfect solution, as there's no guarantee that the exit
> +	 * reason is set before the run struct is populated, but it should prevent
> +	 * at least some bugs.
> +	 */
> +	else if (WARN_ON_ONCE(vcpu->run->exit_reason != KVM_EXIT_UNKNOWN))
> +		goto out;
> +
> +	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> +	vcpu->run->memory_fault.gpa = gpa;
> +	vcpu->run->memory_fault.len = len;
> +	vcpu->run->memory_fault.flags = 0;
> +
> +out:
> +	preempt_enable();
> +}
> -- 
> 2.40.0.577.gac1e443424-goog
> 

-- 
Thanks,
Oliver
