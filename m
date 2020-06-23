Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38217204A40
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 08:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgFWGxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 02:53:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:6827 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730688AbgFWGxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 02:53:50 -0400
IronPort-SDR: yOdSviwHOn+YOjpmOf/m44Aq1Z3dExqdTAHPmKzdvRT8mAVc0WD4CKqKGRKSnbMBAAWxZpX1y/
 FjXnkFV/K6Kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="143047816"
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="143047816"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 23:53:48 -0700
IronPort-SDR: vXYGhTn5jjwCXa1TPq2WcjobErcEKb5oX7SP1jRjbQBs3qmdFjCxe35EuPr4Xm7mi4Xfv6h8PP
 qgKOf/f+HmIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="279012600"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 22 Jun 2020 23:53:48 -0700
Date:   Mon, 22 Jun 2020 23:53:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Feiner <pfeiner@google.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: x86 mmu: avoid mmu_page_hash lookup for
 direct_map-only VM
Message-ID: <20200623065348.GA23054@linux.intel.com>
References: <20200508182425.69249-1-jcargill@google.com>
 <20200508201355.GS27052@linux.intel.com>
 <CAM3pwhEw+KYq9AD+z8wPGyG10Bex7xLKaPM=yVV-H+W_eHTW4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM3pwhEw+KYq9AD+z8wPGyG10Bex7xLKaPM=yVV-H+W_eHTW4w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 03:36:21PM -0700, Peter Feiner wrote:
> On Fri, May 8, 2020 at 1:14 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, May 08, 2020 at 11:24:25AM -0700, Jon Cargille wrote:
> > > From: Peter Feiner <pfeiner@google.com>
> > >
> > > Optimization for avoiding lookups in mmu_page_hash. When there's a
> > > single direct root, a shadow page has at most one parent SPTE
> > > (non-root SPs have exactly one; the root has none). Thus, if an SPTE
> > > is non-present, it can be linked to a newly allocated SP without
> > > first checking if the SP already exists.
> >
> > Some mechanical comments below.  I'll think through the actual logic next
> > week, my brain needs to be primed anytime the MMU is involved :-)
> >
> > > This optimization has proven significant in batch large SP shattering
> > > where the hash lookup accounted for 95% of the overhead.

Is it the hash lookup or the hlist walk that is expensive?  If it's the
hash lookup, then a safer fix would be to do the hash lookup once in
kvm_mmu_get_page() instead of doing it for both the walk and the insertion.
Assuming, that's the case, I'll send a patch.  Actually, I'll probably send
a patch no matter what, I've been looking for an excuse to get rid of that
obnoxiously long hash lookup line.  :-)

> > > Signed-off-by: Peter Feiner <pfeiner@google.com>
> > > Signed-off-by: Jon Cargille <jcargill@google.com>
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > >
> > > ---
> > >  arch/x86/include/asm/kvm_host.h | 13 ++++++++
> > >  arch/x86/kvm/mmu/mmu.c          | 55 +++++++++++++++++++--------------
> > >  2 files changed, 45 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index a239a297be33..9b70d764b626 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -913,6 +913,19 @@ struct kvm_arch {
> > >       struct kvm_page_track_notifier_node mmu_sp_tracker;
> > >       struct kvm_page_track_notifier_head track_notifier_head;
> > >
> > > +     /*
> > > +      * Optimization for avoiding lookups in mmu_page_hash. When there's a
> > > +      * single direct root, a shadow page has at most one parent SPTE
> > > +      * (non-root SPs have exactly one; the root has none). Thus, if an SPTE
> > > +      * is non-present, it can be linked to a newly allocated SP without
> > > +      * first checking if the SP already exists.

I'm pretty sure this will break due to the "zap oldest shadow page"
behavior of make_mmu_pages_available() and mmu_shrink_scan().  In that case,
KVM can zap a parent SP and leave a dangling child.  If/when the zapped
parent SP is rebuilt, it should find and relink the temporarily orphaned
child.  I believe the error will not actively manifest since the new,
duplicate SP will be added to the front of the hlist, i.e. the newest entry
will always be observed first.  But, it will "leak" the child and all its
children, at least until they get zapped in turn.

Hitting the above is probably extremely rare in the current code base.
Presumably the make_mmu_pages_available() path is rarely hit, and the
mmu_shrink_scan() path is basically broken (it zaps at most a single page
after reporting to the scanner that it can potentially free thousands of
pages; I'm working on a series).

One thought would be to zap the entire family tree when zapping a shadow
page for a direct MMU.  Then the above assumption would hold.  I think
that would be ok/safe-ish?  It definitely would have "interesting" side
effects.

Actually, there's another case that would break, though it's contrived and
silly.  If a VM is configured to have vCPUs with different physical address
widths (yay KVM) and caused KVM to use both 4-level and 5-level EPT, then
the "single direct root" rule above would be violated.

If we do get agressive and zap all children (or if my analysis is wrong),
and prevent the mixed level insansity, then a simpler approach would be to
skip the lookup if the MMU is direct.  I.e. no need for the per-VM toggle.
Direct vs. indirect MMUs are guaranteed to have different roles and so the
direct MMU's pages can't be reused/shared.
