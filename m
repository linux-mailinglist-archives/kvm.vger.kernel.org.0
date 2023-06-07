Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDC9726724
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjFGRXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 13:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjFGRXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 13:23:18 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046FB1FE2;
        Wed,  7 Jun 2023 10:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686158597; x=1717694597;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Raa3CMHXB9WrqI2ttWxq6HepaOwkLt4ZQ6ht8uAn8rU=;
  b=Y/YRCTzzSaibOYubarB712k5lHTjLWI2EE9u48xy19vuZEhC05UPVUw1
   KAE+O9wTFl4L5mFenAN4zsIUITwh+ee090u8NFcTKiu6t6M3vesZ4VUPe
   PrtERSUS6MRnB9BMiRqilP2HsKuvBumTXQ66XfSDzXWB2i2V0nwqXmdKD
   qXzm8CLPJb0iCKlr5i7DOJkiwlZHc6CxlpVmW9s1Wf+TsunSR80TasFd5
   oKDVenKeUhx6D3TgH4m7STlpDRclNPDTwm0Bp1oHeN7J0rNCf6enhdZvR
   LvHXwJxyx5/b/mjzTR0FKuFmxfxu7qZ56K5Q4t5KKe0Q5yNCXNTxcx6JA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="359524236"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="359524236"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 10:23:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="956378738"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="956378738"
Received: from jli128-mobl1.ccr.corp.intel.com (HELO localhost) ([10.254.211.124])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 10:23:13 -0700
Date:   Thu, 8 Jun 2023 01:23:11 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
Message-ID: <20230607172243.c2bkw43hcet4sfnb@linux.intel.com>
References: <20230602011518.787006-1-seanjc@google.com>
 <20230602011518.787006-2-seanjc@google.com>
 <20230607073728.vggwcoylibj3cp6s@linux.intel.com>
 <ZICUbIF2+Cvbb9GM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZICUbIF2+Cvbb9GM@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Pending requests block KVM from actually entering the guest.  If a request comes
> in after vcpu_enter_guest()'s initial handling of requests, KVM will bail before
> VM-Enter and go back through the entire "outer" run loop.
> 
> This isn't necessarily the most efficient way to handle the stall, e.g. KVM does
> a fair bit of prep for VM-Enter before detecting the pending request.  The
> alternative would be to have kvm_vcpu_reload_apic_access_page() return value
> instructing vcpu_enter_guest() whether to bail immediately or continue on.  I
> elected for the re-request approach because (a) it didn't require redefining the
> kvm_x86_ops vendor hook, (b) this should be a rare situation and not performance
> critical overall, and (c) there's no guarantee that bailing immediately would
> actually yield better performance from the guest's perspective, e.g. if there are
> other pending requests/work, then the KVM can handle those items while the vCPU
> is stalled instead of waiting until the invalidation completes to proceed.
> 

Wah! Thank you so much! Especially for the code snippets below! :)

> > One more dumb question - why does KVM not just pin the APIC access page?
> 
> Definitely not a dumb question, I asked myself the same thing multiple times when
> looking at this :-)  Pinning the page would be easier, and KVM actually did that
> in the original implementation.  The issue is in how KVM allocates the backing
> page.  It's not a traditional kernel allocation, but is instead anonymous memory
> allocated by way of vm_mmap(), i.e. for all intents and purposes it's a user
> allocation.  That means the kernel expects it to be a regular movable page, e.g.
> it's entirely possible the page (if it were pinned) could be the only page in a
> 2MiB chunk preventing the kernel from migrating/compacting and creating a hugepage.
> 
> In hindsight, I'm not entirely convinced that unpinning the page was the right
> choice, as it resulted in a handful of nasty bugs.  But, now that we've fixed all
> those bugs (knock wood), there's no good argument for undoing all of that work.
> Because while the code is subtle and requires hooks in a few paths, it's not *that*
> complex and for the most part doesn't require active maintenance.
> 

Thanks again! One more thing that bothers me when reading the mmu notifier,
is about the TLB flush request. After the APIC access page is reloaded, the
TLB will be flushed (a single-context EPT invalidation on not-so-outdated
CPUs) in vmx_set_apic_access_page_addr(). But the mmu notifier will send the
KVM_REQ_TLB_FLUSH as well, by kvm_mmu_notifier_invalidate_range_start() ->
__kvm_handle_hva_range(), therefore causing the vCPU to trigger another TLB
flush - normally a global EPT invalidation I guess.

But, is this necessary?

Could we try to return false in kvm_unmap_gfn_range() to indicate no more
flush is needed, if the range to be unmapped falls within guest APIC base,
and leaving the TLB invalidation work to vmx_set_apic_access_page_addr()?

But there are multiple places in vmx_set_apic_access_page_addr() to return
earlier(e.g., if xapic mode is disabled for this vCPU) with no TLB flush being
triggered, I am not sure if doing so would cause more problems... Any comment?
Thanks!

B.R.
Yu

