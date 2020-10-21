Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2582A295192
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 19:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503580AbgJURfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 13:35:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:45514 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404404AbgJURfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 13:35:43 -0400
IronPort-SDR: AxG3/eHShXPgTBg2Rtf76wvoz1tPSIaTZ5Jzu9m4zgoB62N0jMF5bz0/JDVx9lgdLHv0lL7oor
 Je1o248AFAOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231600581"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="231600581"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:35:41 -0700
IronPort-SDR: hKulPrEKiCQDbWyW9R5N7rd6q/Vd/eQmRl2nDwht2xpE4sS245MllNRSZczMsbTOnMBWg/Ad+Z
 Y8wj3J0SfIRA==
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="533619910"
Received: from zhangyu-optiplex-9020.bj.intel.com (HELO localhost) ([10.238.135.148])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 21 Oct 2020 10:35:37 -0700
Date:   Thu, 22 Oct 2020 01:24:09 +0800
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
Message-ID: <20201021172409.aids3y2mlyx776lx@linux.intel.com>
References: <20201014182700.2888246-1-bgardon@google.com>
 <20201014182700.2888246-8-bgardon@google.com>
 <20201021150225.2eeriqlffqnsm4b3@linux.intel.com>
 <6985f630-3b2a-75f5-5b55-bd76cf32f20b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6985f630-3b2a-75f5-5b55-bd76cf32f20b@redhat.com>
User-Agent: NeoMutt/20180622-66-b94505
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 07:20:15PM +0200, Paolo Bonzini wrote:
> On 21/10/20 17:02, Yu Zhang wrote:
> >>  void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
> >>  {
> >> +	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
> >> +
> > boot_cpu_data.x86_phys_bits is the host address width. Value of the guest's
> > may vary. So maybe we should just traverse the memslots and zap the gfn ranges
> > in each of them?
> > 
> 
> It must be smaller than the host value for two-dimensional paging, though.

Yes. And using boot_cpu_data.x86_phys_bits works, but won't it be somewhat
overkilling? E.g. for a host with 46 bits and a guest with 39 bits width?

Any concern for doing the zap by going through the memslots? Thanks. :)

B.R.
Yu
> 
> Paolo
> 
