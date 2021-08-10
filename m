Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15373E5479
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 09:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhHJHlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 03:41:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:56797 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhHJHlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 03:41:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="236858554"
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="236858554"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 00:40:45 -0700
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="515665387"
Received: from yilonggu-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.175.101])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 00:40:41 -0700
Date:   Tue, 10 Aug 2021 15:40:37 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
Message-ID: <20210810074037.mizpggevgyhed6rm@linux.intel.com>
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-2-wei.huang2@amd.com>
 <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
 <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
 <20210809042703.25gfuuvujicc3vj7@linux.intel.com>
 <73bbaac0-701c-42dd-36da-aae1fed7f1a0@amd.com>
 <20210809064224.ctu3zxknn7s56gk3@linux.intel.com>
 <YRFKABg2MOJxcq+y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRFKABg2MOJxcq+y@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021 at 03:30:08PM +0000, Sean Christopherson wrote:
> On Mon, Aug 09, 2021, Yu Zhang wrote:
> > On Sun, Aug 08, 2021 at 11:33:44PM -0500, Wei Huang wrote:
> > > 
> > > On 8/8/21 11:27 PM, Yu Zhang wrote:
> > > > On Sun, Aug 08, 2021 at 11:11:40PM -0500, Wei Huang wrote:
> > > > > 
> > > > > 
> > > > > On 8/8/21 10:58 PM, Yu Zhang wrote:
> > > > > > On Sun, Aug 08, 2021 at 02:26:56PM -0500, Wei Huang wrote:
> > > > > > > AMD future CPUs will require a 5-level NPT if host CR4.LA57 is set.
> > > > > > 
> > > > > > Sorry, but why? NPT is not indexed by HVA.
> > > > > 
> > > > > NPT is not indexed by HVA - it is always indexed by GPA. What I meant is NPT
> > > > > page table level has to be the same as the host OS page table: if 5-level
> > > > > page table is enabled in host OS (CR4.LA57=1), guest NPT has to 5-level too.
> > > > 
> > > > I know what you meant. But may I ask why?
> > > 
> > > I don't have a good answer for it. From what I know, VMCB doesn't have a
> > > field to indicate guest page table level. As a result, hardware relies on
> > > host CR4 to infer NPT level.
> > 
> > I guess you mean not even in the N_CR3 field of VMCB? 
> 
> Correct, nCR3 is a basically a pure representation of a regular CR3.
> 
> > Then it's not a broken design - it's a limitation of SVM. :)
> 
> That's just a polite way of saying it's a broken design ;-)
> 
> Joking aside, NPT opted for a semblance of backwards compatibility at the cost of
> having to carry all the baggage that comes with a legacy design.  Keeping the core
> functionality from IA32 paging presumably miminizes design and hardware costs, and
> required minimal enabling in hypervisors.  The downside is that it's less flexible
> than EPT and has a few warts, e.g. shadowing NPT is gross because the host can't
> easily mirror L1's desired paging mode.

Thanks for your explaination, Sean. Everything has a cost, and now it's time to pay
the price. :)

As to the max level, it is calculated in kvm_init(). Though I do not see any chance
that host paging mode will be changed after kvm_init(), or any case that Linux uses
different paging levels in different pCPUs, I am wondering, should we do something,
e.g., to document this as an open?

About "host can't easily mirror L1's desired paging mode", could you please elaborate?
Thanks!

B.R.
Yu

