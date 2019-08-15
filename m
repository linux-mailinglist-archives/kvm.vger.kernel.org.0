Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849238F47B
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbfHOTZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 15:25:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:39680 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728979AbfHOTZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 15:25:32 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 12:25:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="376481353"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 15 Aug 2019 12:25:31 -0700
Date:   Thu, 15 Aug 2019 12:25:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190815192531.GE27076@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <20190815160006.GC27076@linux.intel.com>
 <20190815121607.29055aa2@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815121607.29055aa2@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 12:16:07PM -0600, Alex Williamson wrote:
> On Thu, 15 Aug 2019 09:00:06 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> If I print out the memslot base_gfn, it seems pretty evident that only
> the assigned device mappings are triggering this branch.  The base_gfns
> exclusively include:
> 
>  0x800000
>  0x808000
>  0xc0089
> 
> Where the first two clearly match the 64bit BARs and the last is the
> result of a page that we need to emulate within the BAR @0xc0000000 at
> offset 0x88000, so the base_gfn is the remaining direct mapping.

That's consistent with my understanding of userspace, e.g. normal memory
regions aren't deleted until the VM is shut down (barring hot unplug).

> I don't know if this implies we're doing something wrong for assigned
> device slots, but maybe a more targeted workaround would be if we could
> specifically identify these slots, though there's no special
> registration of them versus other slots.

What is triggering the memslot removal/update?  Is it possible that
whatever action is occuring is modifying multiple memslots?  E.g. KVM's
memslot-only zapping is allowing the guest to access stale entries for
the unzapped-but-related memslots, whereas the full zap does not.

FYI, my VFIO/GPU/PCI knowledge is abysmal, please speak up if any of my
ideas are nonsensical.

> Did you have any non-device
> assignment test cases that took this branch when developing the series?

The primary testing was performance oriented, using a slightly modified
version of a synthetic benchmark[1] from a previous series[2] that touched
the memslot flushing flow.  From a functional perspective, I highly doubt
that test would have been able expose an improper zapping bug.

We do have some amount of coverage via kvm-unit-tests, as an EPT test was
triggering a slab bug due not actually zapping the collected SPTEs[3].

[1] http://lkml.iu.edu/hypermail/linux/kernel/1305.2/00277/mmtest.tar.bz2
[2] https://lkml.kernel.org/r/1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com
[3] https://patchwork.kernel.org/patch/10899283/

> > One other thought would be to force a call to kvm_flush_remote_tlbs(kvm),
> > e.g. set flush=true just before the final kvm_mmu_remote_flush_or_zap().
> > Maybe it's a case where there are no SPTEs for the memslot, but the TLB
> > flush is needed for some reason.
> 
> This doesn't work.  Thanks,
> 
> Alex
