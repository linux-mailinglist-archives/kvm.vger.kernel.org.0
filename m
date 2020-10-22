Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2AE295654
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 04:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894984AbgJVCYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 22:24:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:5735 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442924AbgJVCYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 22:24:33 -0400
IronPort-SDR: lRR36phq5QOdo+daLaDDYkHgYaXIRRRWBKBZ7QZIVDkFAoMVjhE6OPgVv5x55CiQ1Can/CZtcs
 TCQfWer5uR6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="163969517"
X-IronPort-AV: E=Sophos;i="5.77,403,1596524400"; 
   d="scan'208";a="163969517"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 19:24:32 -0700
IronPort-SDR: 1X/SyVqtilx5M/h3hrw0oZxUb5K9t0aVhwnCBdrK0OiyDCv10YwwfU7KTcqDfsEpnJr5hh9PUA
 6huGueAZCR/w==
X-IronPort-AV: E=Sophos;i="5.77,403,1596524400"; 
   d="scan'208";a="533767364"
Received: from jwan147-mobl2.ccr.corp.intel.com (HELO localhost) ([10.254.211.184])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 19:24:26 -0700
Date:   Thu, 22 Oct 2020 10:24:23 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 07/20] kvm: x86/mmu: Support zapping SPTEs in the TDP
 MMU
Message-ID: <20201022022423.yqyvgpagymxz6ok5@linux.intel.com>
References: <20201014182700.2888246-1-bgardon@google.com>
 <20201014182700.2888246-8-bgardon@google.com>
 <20201021150225.2eeriqlffqnsm4b3@linux.intel.com>
 <6985f630-3b2a-75f5-5b55-bd76cf32f20b@redhat.com>
 <20201021172409.aids3y2mlyx776lx@linux.intel.com>
 <0f2e00fe-4f30-88d3-e345-089f1afc4fb9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f2e00fe-4f30-88d3-e345-089f1afc4fb9@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 08:00:47PM +0200, Paolo Bonzini wrote:
> On 21/10/20 19:24, Yu Zhang wrote:
> > On Wed, Oct 21, 2020 at 07:20:15PM +0200, Paolo Bonzini wrote:
> >> On 21/10/20 17:02, Yu Zhang wrote:
> >>>>  void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
> >>>>  {
> >>>> +	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
> >>>> +
> >>> boot_cpu_data.x86_phys_bits is the host address width. Value of the guest's
> >>> may vary. So maybe we should just traverse the memslots and zap the gfn ranges
> >>> in each of them?
> >>>
> >>
> >> It must be smaller than the host value for two-dimensional paging, though.
> > 
> > Yes. And using boot_cpu_data.x86_phys_bits works, but won't it be somewhat
> > overkilling? E.g. for a host with 46 bits and a guest with 39 bits width?
> 
> It would go quickly through extra memory space because the PML4E entries
> above the first would be empty.  So it's just 511 comparisons.
> 

Oh, yes. The overhead seems not as big as I assumed. :)

Yu
> Paolo
> 
