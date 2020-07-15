Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEE82203F5
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgGOE11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:27:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:59539 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOE11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:27:27 -0400
IronPort-SDR: 1myXmjA3WpzCTn8bKX2UnmSqPQiJCt6TAvHd7WUOrDOrFcW4hLBCC1rVAQPJ+oMU2UtSk+jXVl
 6UWHSSe7wLeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233936293"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="233936293"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:27:26 -0700
IronPort-SDR: yYi6MGSXlFAUgYHAavn7DNXJz8sblz4eHr1QSjSPTnAAwL+UU2MJqDmHiBsBLaw30xLzyHH2CO
 dZJlNyRonj2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="308118773"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jul 2020 21:27:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
Subject: [PATCH 0/8] KVM: x86/mmu: ITLB multi-hit workaround fixes
Date:   Tue, 14 Jul 2020 21:27:17 -0700
Message-Id: <20200715042725.10961-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 is a minor fix for a very theoretical bug where KVM could skip
the final "commit zap" when recovering shadow pages for the NX huge
page mitigation.

Patch 2 is cleanup that's made possible by patch 1.

Patches 3-5 are the main course and fix bugs in the NX huge page
accounting where shadow pages are incorrectly added to the list of
disallowed huge pages.  KVM doesn't actually check to see if the page
could actually have been a large page when adding to the disallowed list.
This result in what are effectively spurious zaps.  The biggest issue is
likely with shadow pages in the upper levels, i.e. levels 3 and 4, as they
are either unlikely to be huge (1gb) or flat out can't be huge (512tb).
And because of the way KVM zaps, the upper levels will be zapped first,
i.e. KVM is likely zapping and rebuilding a decent number of its shadow
pages for zero benefit.

Ideally, patches 3-5 would be a single patch to ease backporting.  In the
end, I decided the change is probably not suitable for stable as at worst
it creates an infrequent performance spike (assuming the admin isn't going
crazy with the recovery frequency), and it's far from straightforward or
risk free.  Cramming everything into a single patch was a mess.

Patches 6-8 are cleanups in related code.  The 'hlevel' name in particular
has been on my todo list for a while.

Sean Christopherson (8):
  KVM: x86/mmu: Commit zap of remaining invalid pages when recovering
    lpages
  KVM: x86/mmu: Refactor the zap loop for recovering NX lpages
  KVM: x86/mmu: Move "huge page disallowed" calculation into mapping
    helpers
  KVM: x86/mmu: Capture requested page level before NX huge page
    workaround
  KVM: x86/mmu: Account NX huge page disallowed iff huge page was
    requested
  KVM: x86/mmu: Rename 'hlevel' to 'level' in FNAME(fetch)
  KVM: x86/mmu: Hoist ITLB multi-hit workaround check up a level
  KVM: x86/mmu: Track write/user faults using bools

 arch/x86/kvm/mmu/mmu.c         | 58 +++++++++++++++++++++-------------
 arch/x86/kvm/mmu/paging_tmpl.h | 39 ++++++++++++-----------
 2 files changed, 57 insertions(+), 40 deletions(-)

-- 
2.26.0

