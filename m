Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2B7276017
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgIWShi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:37:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:9454 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgIWShi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:37:38 -0400
IronPort-SDR: U7K1mg4muKoDpt4gMUOdyzARVDydOlwm06OBQvNkNstkrpstUsw/cPOlZTV7nYoGsAaYqOhkzl
 2VeuDJqHi0RA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160276859"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160276859"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:37:37 -0700
IronPort-SDR: xzdtHKopGeCmbqsC4quJMFzcNpajTENd5zQcy3HZ3WoY5zKm4LV5iC5ZpZEmgqz8j4dIJTFtCg
 3bFv1hzQmQrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486561611"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga005.jf.intel.com with ESMTP; 23 Sep 2020 11:37:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
Subject: [PATCH v2 0/8] KVM: x86/mmu: ITLB multi-hit workaround fixes
Date:   Wed, 23 Sep 2020 11:37:27 -0700
Message-Id: <20200923183735.584-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

v2:
  - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
    feature on AMD").

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
2.28.0

