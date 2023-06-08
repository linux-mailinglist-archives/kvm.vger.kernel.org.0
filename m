Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D86F7277FB
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbjFHHA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235100AbjFHHAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:00:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F118269F;
        Thu,  8 Jun 2023 00:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686207620; x=1717743620;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M5UMIB8Ck4c/VhTzKDXztRonGBXX6Ba4wGQ/5JgfDiQ=;
  b=cPtz7PvlH2TudX3Ykl6uHAr2LCikTzORRKk/RX7zDKL7bMV3v+T8XYgs
   OKWWlOL6hiG8GQfjU8QpuKW81GAqU82TEGqcz64enRkBWILC9l2KCbLSl
   H+1f+2TQWDHx46aQX8c+b0Zy2d7pNf5K+Q5ITuvE6G7xu3YVVBD1XfhYK
   NBr/stbpGnrOY+3XXizh5u7LW1tkMarAck3c9T5Ahs2EdyluhcCowb5jN
   6GRsxTgLoNt3oDm29+P/Wa2kcCjseG2KVh4Ln6L5vbGN11dQlka+J04PJ
   03WS20hLGuIOa+Z29/RL1I6o34SpqTOnuwYHB5hJliqHAPOOCBxGRcHCC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="360563117"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="360563117"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 00:00:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="799708120"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="799708120"
Received: from zli1-mobl2.ccr.corp.intel.com (HELO localhost) ([10.254.210.156])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 00:00:17 -0700
Date:   Thu, 8 Jun 2023 15:00:16 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
Message-ID: <20230608070016.f3dz6dhvdkxsomdb@linux.intel.com>
References: <20230602011518.787006-1-seanjc@google.com>
 <20230602011518.787006-2-seanjc@google.com>
 <20230607073728.vggwcoylibj3cp6s@linux.intel.com>
 <ZICUbIF2+Cvbb9GM@google.com>
 <20230607172243.c2bkw43hcet4sfnb@linux.intel.com>
 <ZIDENf2vzwUjzcl2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIDENf2vzwUjzcl2@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> Flushing when KVM zaps SPTEs is definitely necessary.  But the flush in
> vmx_set_apic_access_page_addr() *should* be redundant.
> 
> > Could we try to return false in kvm_unmap_gfn_range() to indicate no more
> > flush is needed, if the range to be unmapped falls within guest APIC base,
> > and leaving the TLB invalidation work to vmx_set_apic_access_page_addr()?
> 
> No, because vmx_flush_tlb_current(), a.k.a. KVM_REQ_TLB_FLUSH_CURRENT, flushes
> only the current root, i.e. on the current EP4TA.  kvm_unmap_gfn_range() isn't
> tied to a single vCPU and so needs to flush all roots.  We could in theory more
> precisely track which roots needs to be flushed, but in practice it's highly
> unlikely to matter as there is typically only one "main" root when TDP (EPT) is
> in use.  In other words, KVM could avoid unnecessarily flushing entries for other
> roots, but it would incur non-trivial complexity, and the probability of the
> precise flushing having a measurable impact on guest performance is quite low, at
> least outside of nested scenarios.

Well, I can understand the invalidation shall be performed for both current EP4TA,
and the nested EP4TA(EPT02) when host retries to reclaim a normal page, because L1
may assign this page to L2. But for APIC base address, will L1 map this address to
L2? 

Also, what if the virtualize APIC access is to be supported in L2, and the backing
page is being reclaimed in L0? I saw nested_get_vmcs12_pages() will check vmcs12
and set the APIC access address in VMCS02, but not sure if this routine will be
triggered by the mmu notifier...

B.R.
Yu

> 
> But as above, flushing in vmx_set_apic_access_page_addr() shouldn't be necessary.
> If there were SPTEs, then KVM would already have zapped and flushed.  If there
> weren't SPTEs, then it should have been impossible for the guest to have valid
> TLB entries.  KVM needs to flush when VIRTUALIZE_APIC_ACCESSES is toggled on, as
> the CPU could have non-vAPIC TLB entries, but that's handled by vmx_set_virtual_apic_mode().
> 
> I'll send a follow-up patch to drop the flush from vmx_set_apic_access_page_addr(),
> I don't *think* I'm missing an edge case...
