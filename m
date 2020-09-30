Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6672227DFDF
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 07:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgI3FG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 01:06:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:18834 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3FG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 01:06:57 -0400
IronPort-SDR: 7qxptBwO7NJO6sBwh+6r/1VHVFcUzmuCh00XikxG9kxRhZvv8VU4yRBeQLxHXFHjt7p0HCM3tU
 qeCeX5LwSKpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="163225128"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="163225128"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:06:53 -0700
IronPort-SDR: +HIBeq4USoH0PoB0JIaXndoXH9SHURfLExUeP4G8ILPsCN0omU1FXvWZVlPY6M7lp1OJ+zxFeN
 4lSwqsRYRZ+w==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="457524730"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:06:53 -0700
Date:   Tue, 29 Sep 2020 22:06:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
Message-ID: <20200930050651.GB29405@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
 <9ebecd06-950c-e7ee-c991-94e63ecec4a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ebecd06-950c-e7ee-c991-94e63ecec4a2@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 26, 2020 at 02:04:49AM +0200, Paolo Bonzini wrote:
> On 25/09/20 23:22, Ben Gardon wrote:
> >  EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
> >  
> > -static bool is_mmio_spte(u64 spte)
> > +bool is_mmio_spte(u64 spte)
> >  {
> >  	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
> >  }
> > @@ -623,7 +612,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
> >  	return vcpu->arch.efer & EFER_NX;
> >  }
> >  
> > -static int is_shadow_present_pte(u64 pte)
> > +int is_shadow_present_pte(u64 pte)
> >  {
> >  	return (pte != 0) && !is_mmio_spte(pte);
> >  }
> > @@ -633,7 +622,7 @@ static int is_large_pte(u64 pte)
> >  	return pte & PT_PAGE_SIZE_MASK;
> >  }
> >  
> > -static int is_last_spte(u64 pte, int level)
> > +int is_last_spte(u64 pte, int level)
> >  {
> >  	if (level == PG_LEVEL_4K)
> >  		return 1;
> > @@ -647,7 +636,7 @@ static bool is_executable_pte(u64 spte)
> >  	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
> >  }
> >  
> > -static kvm_pfn_t spte_to_pfn(u64 pte)
> > +kvm_pfn_t spte_to_pfn(u64 pte)
> >  {
> >  	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
> >  }
> 
> Should these be inlines in mmu_internal.h instead?

Ya, that would be my preference as well.
