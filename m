Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD218C209
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 22:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfHMUTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 16:19:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:42196 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfHMUTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 16:19:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 13:19:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="167162883"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 13 Aug 2019 13:19:14 -0700
Date:   Tue, 13 Aug 2019 13:19:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190813201914.GI13991@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813133316.6fc6f257@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 01:33:16PM -0600, Alex Williamson wrote:
> On Tue, 13 Aug 2019 11:57:37 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:

> Could it be something with the gfn test:
> 
>                         if (sp->gfn != gfn)
>                                 continue;
> 
> If I remove it, I can't trigger the misbehavior.  If I log it, I only
> get hits on VM boot/reboot and some of the gfns look suspiciously like
> they could be the assigned GPU BARs and maybe MSI mappings:
> 
>                (sp->gfn) != (gfn)

Hits at boot/reboot makes sense, memslots get zapped when userspace
removes a memory region/slot, e.g. remaps BARs and whatnot.

...
 
> Is this gfn optimization correct?  Overzealous?  Doesn't account
> correctly for something about MMIO mappings?  Thanks,

Yes?  Shadow pages are stored in a hash table, for_each_valid_sp() walks
all entries for a given gfn.  The sp->gfn check is there to skip entries
that hashed to the same list but for a completely different gfn.

Skipping the gfn check would be sort of a lightweight zap all in the
sense that it would zap shadow pages that happend to collide with the
target memslot/gfn but are otherwise unrelated.

What happens if you give just the GPU BAR at 0x80000000 a pass, i.e.:

	if (sp->gfn != gfn && sp->gfn != 0x80000)
		continue;

If that doesn't work, it might be worth trying other gfns to see if you
can pinpoint which sp is being zapped as collateral damage.

It's possible there is a pre-existing bug somewhere else that was being
hidden because KVM was effectively zapping all SPTEs during (re)boot,
and the hash collision is also hiding the bug by zapping the stale entry.

Of course it's also possible this code is wrong, :-)
