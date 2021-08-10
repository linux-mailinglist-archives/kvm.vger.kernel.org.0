Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136FA3E58C3
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 13:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239985AbhHJLBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 07:01:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:30776 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237696AbhHJLBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 07:01:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="213021969"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="213021969"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 04:00:40 -0700
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="515756235"
Received: from yilonggu-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.175.101])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 04:00:35 -0700
Date:   Tue, 10 Aug 2021 19:00:31 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
Message-ID: <20210810110031.h7vaqf3nljwm3wym@linux.intel.com>
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-2-wei.huang2@amd.com>
 <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
 <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
 <20210809042703.25gfuuvujicc3vj7@linux.intel.com>
 <73bbaac0-701c-42dd-36da-aae1fed7f1a0@amd.com>
 <20210809064224.ctu3zxknn7s56gk3@linux.intel.com>
 <YRFKABg2MOJxcq+y@google.com>
 <20210810074037.mizpggevgyhed6rm@linux.intel.com>
 <0ac41a07-beeb-161e-9e5d-e45477106c01@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ac41a07-beeb-161e-9e5d-e45477106c01@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 11:25:27AM +0200, Paolo Bonzini wrote:
> On 10/08/21 09:40, Yu Zhang wrote:
> > About "host can't easily mirror L1's desired paging mode", could you please elaborate?
> > Thanks!
> 
> Shadow pgae tables in KVM will always have 3 levels on 32-bit machines and
> 4/5 levels on 64-bit machines.  L1 instead might have any number of levels
> from 2 to 5 (though of course not more than the host has).

Thanks Paolo.

I guess it's because, unlike EPT which are with either 4 or 5 levels, NPT's
level can range from 2 to 5, depending on the host paging mode...

> 
> Therefore, when shadowing 32-bit NPT page tables, KVM has to add extra fixed
> levels on top of those that it's shadowing.  See mmu_alloc_direct_roots for
> the code.

So when shadowing NPTs(can be 2/3 levels, depending on the paging mode in L1),
and if L0 Linux is running in 4/5 level mode, extra levels of paging structures
is needed in the shadow NPT.

But shadow EPT does not have such annoyance. Is above understanding correct?

B.R.
Yu
