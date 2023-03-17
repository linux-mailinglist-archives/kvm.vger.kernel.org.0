Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619BF6BF14C
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCQTAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 15:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCQTAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 15:00:13 -0400
Received: from out-23.mta1.migadu.com (out-23.mta1.migadu.com [IPv6:2001:41d0:203:375::17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB172CC4A
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:59:53 -0700 (PDT)
Date:   Fri, 17 Mar 2023 18:59:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679079590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wzTsWYADM0cjjTS3imUxmJv/ZyUrI7sGxeLSP/fqqPU=;
        b=RVN+5Kc58V8e8TBxBO0Gyne5bhZ/ZXkke3c0hwolkmMZRxuyuCIJyuOIflSen6/DR6+JIA
        x57TGBoIm/dRkP5DWGmvdxnj3ewNrpocFdzk/CKwZ1js/c1rllP76kAG3OppPg16wwjrm/
        CHqVzH6tmM4n3ts+C1TUmnxSZoN3+Kw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
Message-ID: <ZBS4o75PVHL4FQqw@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-10-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315021738.1151386-10-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 02:17:33AM +0000, Anish Moorthy wrote:
> Add documentation, memslot flags, useful helper functions, and the
> actual new capability itself.
> 
> Memory fault exits on absent mappings are particularly useful for
> userfaultfd-based live migration postcopy. When many vCPUs fault upon a
> single userfaultfd the faults can take a while to surface to userspace
> due to having to contend for uffd wait queue locks. Bypassing the uffd
> entirely by triggering a vCPU exit avoids this contention and can improve
> the fault rate by as much as 10x.
> ---
>  Documentation/virt/kvm/api.rst | 37 +++++++++++++++++++++++++++++++---
>  include/linux/kvm_host.h       |  6 ++++++
>  include/uapi/linux/kvm.h       |  3 +++
>  tools/include/uapi/linux/kvm.h |  2 ++
>  virt/kvm/kvm_main.c            |  7 ++++++-
>  5 files changed, 51 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f9ca18bbec879..4932c0f62eb3d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
>    /* for kvm_userspace_memory_region::flags */
>    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>    #define KVM_MEM_READONLY	(1UL << 1)
> +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)

call it KVM_MEM_EXIT_ABSENT_MAPPING

>  
>  This ioctl allows the user to create, modify or delete a guest physical
>  memory slot.  Bits 0-15 of "slot" specify the slot id and this value
> @@ -1342,12 +1343,15 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>  be identical.  This allows large pages in the guest to be backed by large
>  pages in the host.
>  
> -The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
> -KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
> +The flags field supports three flags
> +
> +1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
>  writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
> -use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
> +use it.
> +2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
>  to make a new slot read-only.  In this case, writes to this memory will be
>  posted to userspace as KVM_EXIT_MMIO exits.
> +3.  KVM_MEM_ABSENT_MAPPING_FAULT: see KVM_CAP_MEMORY_FAULT_NOWAIT for details.
>  
>  When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
>  the memory region are automatically reflected into the guest.  For example, an
> @@ -7702,10 +7706,37 @@ Through args[0], the capability can be set on a per-exit-reason basis.
>  Currently, the only exit reasons supported are
>  
>  1. KVM_MEMFAULT_REASON_UNKNOWN (1 << 0)
> +2. KVM_MEMFAULT_REASON_ABSENT_MAPPING (1 << 1)
>  
>  Memory fault exits with a reason of UNKNOWN should not be depended upon: they
>  may be added, removed, or reclassified under a stable reason.
>  
> +7.35 KVM_CAP_MEMORY_FAULT_NOWAIT
> +--------------------------------
> +
> +:Architectures: x86, arm64
> +:Returns: -EINVAL.
> +
> +The presence of this capability indicates that userspace may pass the
> +KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> +to exit to populate 'kvm_run.memory_fault' and exit to userspace (*) in response
> +to page faults for which the userspace page tables do not contain present
> +mappings. Attempting to enable the capability directly will fail.
> +
> +The 'gpa' and 'len' fields of kvm_run.memory_fault will be set to the starting
> +address and length (in bytes) of the faulting page. 'flags' will be set to
> +KVM_MEMFAULT_REASON_ABSENT_MAPPING.
> +
> +Userspace should determine how best to make the mapping present, then take
> +appropriate action. For instance, in the case of absent mappings this might
> +involve establishing the mapping for the first time via UFFDIO_COPY/CONTINUE or
> +faulting the mapping in using MADV_POPULATE_READ/WRITE. After establishing the
> +mapping, userspace can return to KVM to retry the previous memory access.
> +
> +(*) NOTE: On x86, KVM_CAP_X86_MEMORY_FAULT_EXIT must be enabled for the
> +KVM_MEMFAULT_REASON_ABSENT_MAPPING_reason: otherwise userspace will only receive
> +a -EFAULT from KVM_RUN without any useful information.

I'm not a fan of this architecture-specific dependency. Userspace is already
explicitly opting in to this behavior by way of the memslot flag. These sort
of exits are entirely orthogonal to the -EFAULT conversion earlier in the
series.

>  8. Other capabilities.
>  ======================
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d3ccfead73e42..c28330f25526f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -593,6 +593,12 @@ static inline bool kvm_slot_dirty_track_enabled(const struct kvm_memory_slot *sl
>  	return slot->flags & KVM_MEM_LOG_DIRTY_PAGES;
>  }
>  
> +static inline bool kvm_slot_fault_on_absent_mapping(
> +	const struct kvm_memory_slot *slot)

Style again...

I'd strongly recommend using 'exit' instead of 'fault' in the verbiage of the
KVM implementation. I understand we're giving userspace the illusion of a page
fault mechanism, but the term is then overloaded in KVM since we handle
literal faults from hardware.

-- 
Thanks,
Oliver
