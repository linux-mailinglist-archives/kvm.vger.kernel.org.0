Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8115628D6E
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 00:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiKNX3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 18:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237821AbiKNX3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 18:29:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5691B647D
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 15:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668468548; x=1700004548;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0KkYvm5wCH4Zs4tVezdy5XoZ+qfuiVYyA22a/r2vt4g=;
  b=fd/O+PLPVD3dYVL0HmO2UgtfsBVjQxWjuuK6/fb7Hshhgqr+U1tl22jz
   qwWnwRsxcOhMgXN9F1osjDLQ+BBNSvSTvwZE8VwQ7znCzNuR2WY3YLIgQ
   ETzabgjDOGREUyZem2yFoqblRpCIAmEZN3CPMhMpQ11xjIZJPWQ9eoEMp
   ZHc9zKxojwefM7vXzbbMski0mC9i09cjIJcIiFEjeejj4FU3f1RzM68lG
   iAUjKIzh7O6fAfN4bgGSLemsP063ZIOmKVAbtRem/Wfh8MmHbSsldVmrb
   xX7at7iJ2AH9JQDtL/7PQLthODr+S7N+zdirSeeIMkOOpZAA05vV90c/V
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="295472901"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="295472901"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 15:29:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702204750"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702204750"
Received: from yjiang5-mobl.amr.corp.intel.com (HELO localhost) ([10.212.78.37])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 15:29:07 -0800
Date:   Mon, 14 Nov 2022 15:29:06 -0800
From:   Yunhong Jiang <yunhong.jiang@linux.intel.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <20221114232906.GA7867@yjiang5-mobl.amr.corp.intel.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113170507.208810-2-shivam.kumar1@nutanix.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 13, 2022 at 05:05:06PM +0000, Shivam Kumar wrote:
> Define variables to track and throttle memory dirtying for every vcpu.
> 
> dirty_count:    Number of pages the vcpu has dirtied since its creation,
>                 while dirty logging is enabled.
> dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
>                 more, it needs to request more quota by exiting to
>                 userspace.
> 
> Implement the flow for throttling based on dirty quota.
> 
> i) Increment dirty_count for the vcpu whenever it dirties a page.
> ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
> count equals/exceeds dirty quota) to request more dirty quota.
> 
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>  Documentation/virt/kvm/api.rst | 35 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/Kconfig           |  1 +
>  include/linux/kvm_host.h       |  5 ++++-
>  include/linux/kvm_types.h      |  1 +
>  include/uapi/linux/kvm.h       | 13 +++++++++++++
>  tools/include/uapi/linux/kvm.h |  1 +
>  virt/kvm/Kconfig               |  4 ++++
>  virt/kvm/kvm_main.c            | 25 +++++++++++++++++++++---
>  8 files changed, 81 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index eee9f857a986..4568faa33c6d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6513,6 +6513,26 @@ array field represents return values. The userspace should update the return
>  values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>  spec refer, https://github.com/riscv/riscv-sbi-doc.
>  
> +::
> +
> +		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
> +		struct {
> +			__u64 count;
> +			__u64 quota;
> +		} dirty_quota_exit;
> +
> +If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
> +exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
> +makes the following information available to the userspace:
> +    count: the current count of pages dirtied by the VCPU, can be
> +    skewed based on the size of the pages accessed by each vCPU.
> +    quota: the observed dirty quota just before the exit to userspace.
> +
> +The userspace can design a strategy to allocate the overall scope of dirtying
> +for the VM among the vcpus. Based on the strategy and the current state of dirty
> +quota throttling, the userspace can make a decision to either update (increase)
> +the quota or to put the VCPU to sleep for some time.
> +
>  ::
>  
>      /* KVM_EXIT_NOTIFY */
> @@ -6567,6 +6587,21 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>  
>  ::
>  
> +	/*
> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
> +	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
> +	 * is reached/exceeded.
> +	 */
> +	__u64 dirty_quota;
> +
> +Please note that enforcing the quota is best effort, as the guest may dirty
> +multiple pages before KVM can recheck the quota.  However, unless KVM is using
> +a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
> +KVM will detect quota exhaustion within a handful of dirtied pages.  If a
> +hardware ring buffer is used, the overrun is bounded by the size of the buffer
> +(512 entries for PML).
> +
> +::
>    };
>  
>  
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 67be7f217e37..bdbd36321d52 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -48,6 +48,7 @@ config KVM
>  	select KVM_VFIO
>  	select SRCU
>  	select INTERVAL_TREE
> +	select HAVE_KVM_DIRTY_QUOTA
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	help
>  	  Support hosting fully virtualized guest machines using hardware
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 18592bdf4c1b..0b9b5c251a04 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -151,11 +151,12 @@ static inline bool is_error_page(struct page *page)
>  #define KVM_REQUEST_NO_ACTION      BIT(10)
>  /*
>   * Architecture-independent vcpu->requests bit members
> - * Bits 3-7 are reserved for more arch-independent bits.
> + * Bits 5-7 are reserved for more arch-independent bits.
>   */
>  #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UNBLOCK           2
> +#define KVM_REQ_DIRTY_QUOTA_EXIT  4
Sorry if I missed anything. Why it's 4 instead of 3?

