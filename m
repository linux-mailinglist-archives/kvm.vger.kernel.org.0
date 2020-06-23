Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BFF204692
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 03:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbgFWBQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 21:16:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:18970 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731639AbgFWBQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 21:16:19 -0400
IronPort-SDR: B0QKe2KVWswrKI5VgIzJyYwm2KFJbeSBWYwbXz7EV80dWUgryHONmjyY0Ps4r2oiR02PhFPfke
 8jTdxft7Rctg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="124193942"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="124193942"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 18:15:41 -0700
IronPort-SDR: TUcmWrm43qUGmO9EuUS72JpqKgmzOA1tf4ziybRypb0LtWcAbP2isrydyxFq4LXZgcUVGH14o3
 09w080pSh6Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="278945537"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 22 Jun 2020 18:15:41 -0700
Date:   Mon, 22 Jun 2020 18:15:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Don't put invalid SPs back on the list of
 active pages
Message-ID: <20200623011541.GD6151@linux.intel.com>
References: <20200622191850.8529-1-sean.j.christopherson@intel.com>
 <d1916978-6efb-2839-d45a-c39ff2f6dc1f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1916978-6efb-2839-d45a-c39ff2f6dc1f@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 02:23:53AM +0200, Paolo Bonzini wrote:
> On 22/06/20 21:18, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index fdd05c233308..fa5bd3f987dd 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2757,10 +2757,13 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
> >  	if (!sp->root_count) {
> >  		/* Count self */
> >  		(*nr_zapped)++;
> > -		list_move(&sp->link, invalid_list);
> > +		if (sp->role.invalid)
> > +			list_add(&sp->link, invalid_list);
> > +		else
> > +			list_move(&sp->link, invalid_list);
> 
> It's late here, but I think this part needs a comment anyway...

No argument here.  I'll spin a v2, I just realized there is a separate
optimization that can build on this patch.  I was planning on sending it
separately, but I misread the loop in make_mmu_pages_available().
