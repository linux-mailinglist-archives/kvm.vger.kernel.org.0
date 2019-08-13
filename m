Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F7E8C363
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 23:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfHMVOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 17:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfHMVOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 17:14:18 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5AAE6155DB;
        Tue, 13 Aug 2019 21:14:18 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C049B10016E8;
        Tue, 13 Aug 2019 21:14:17 +0000 (UTC)
Date:   Tue, 13 Aug 2019 15:14:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190813151417.2cf979ca@x1.home>
In-Reply-To: <cd9e5c9d-a321-b2f3-608d-0b8f74a5075f@redhat.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
        <20190205210137.1377-11-sean.j.christopherson@intel.com>
        <20190813100458.70b7d82d@x1.home>
        <20190813170440.GC13991@linux.intel.com>
        <20190813115737.5db7d815@x1.home>
        <20190813133316.6fc6f257@x1.home>
        <20190813201914.GI13991@linux.intel.com>
        <cd9e5c9d-a321-b2f3-608d-0b8f74a5075f@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 13 Aug 2019 21:14:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Aug 2019 22:37:14 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 13/08/19 22:19, Sean Christopherson wrote:
> > Yes?  Shadow pages are stored in a hash table, for_each_valid_sp() walks
> > all entries for a given gfn.  The sp->gfn check is there to skip entries
> > that hashed to the same list but for a completely different gfn.
> > 
> > Skipping the gfn check would be sort of a lightweight zap all in the
> > sense that it would zap shadow pages that happend to collide with the
> > target memslot/gfn but are otherwise unrelated.
> > 
> > What happens if you give just the GPU BAR at 0x80000000 a pass, i.e.:
> > 
> > 	if (sp->gfn != gfn && sp->gfn != 0x80000)
> > 		continue;

Not having any luck with this yet.  Tried 0x80000, 0x8xxxxx, 0.
 
> > If that doesn't work, it might be worth trying other gfns to see if you
> > can pinpoint which sp is being zapped as collateral damage.
> > 
> > It's possible there is a pre-existing bug somewhere else that was being
> > hidden because KVM was effectively zapping all SPTEs during (re)boot,
> > and the hash collision is also hiding the bug by zapping the stale entry.
> > 
> > Of course it's also possible this code is wrong, :-)  
> 
> Also, can you reproduce it with one vCPU?  This could (though not really
> 100%) distinguish a missing invalidation from a race condition.

That's a pretty big change, I'll give it a shot, but not sure how
conclusive it would be.

> Do we even need the call to slot_handle_all_level?  The rmap update
> should be done already by kvm_mmu_prepare_zap_page (via
> kvm_mmu_page_unlink_children -> mmu_page_zap_pte -> drop_spte).
> 
> Alex, can you replace it with just "flush = false;"?

Replace the continue w/ flush = false?  I'm not clear on this
suggestion.  Thanks,

Alex
