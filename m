Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6F3205BDB
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 21:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgFWTfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 15:35:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:11007 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733309AbgFWTfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 15:35:43 -0400
IronPort-SDR: 2mwWk0sby4tCvc0rJNa1K8Y8icUos6UEtcwxHT1zg1gc1A9xRDDO8r6YYFYy3NGNKXWNbZL8yj
 1+Sjxi+YBNbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="142430966"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="142430966"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 12:35:43 -0700
IronPort-SDR: w6DCk5L9cIhRfbhUuZT1pBFGa7B7OXBCXGDP8PbeXVBFzTrGCpF+awJ71LdnnZorr4xA6xGRJ4
 xsY1D0eKysQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="263428285"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jun 2020 12:35:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: x86/mmu: Zapping and recycling cleanups
Date:   Tue, 23 Jun 2020 12:35:38 -0700
Message-Id: <20200623193542.7554-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Semi-random, but related, changes that deal with the handling of active
root shadow pages during zapping and the zapping of arbitary/old pages.

Patch 1 changes the low level handling to keep zapped active roots off the
active page list.  KVM already relies on the vCPU to explicitly free the
root, putting invalid root pages back on the list is just a quirk of the
implementation.

Patches 2 reworks the MMU page recycling to batch zap pages instead of
zapping them one at a time.  This provides better handling for active root
pages and also avoids multiple remote TLB flushes.

Patch 3 applies the batch zapping to the .shrink_scan() path.  This is a
significant change in behavior, i.e. is the scariest of the changes, but
unless I'm missing something it provides the intended functionality that
has been lacking since shrinker support was first added.

Patch 4 changes the page fault handlers to return an error to userspace
instead of restarting the guest if there are no MMU pages available.  This
is dependent on patch 2 as theoretically the old recycling flow could
prematurely bail if it encountered an active root.

v2:
  - Add a comment for the list shenanigans in patch 1. [Paolo]
  - Add patches 2-4.
  - Rebased to kvm/queue, commit a037ff353ba6 ("Merge branch ...")

Sean Christopherson (4):
  KVM: x86/mmu: Don't put invalid SPs back on the list of active pages
  KVM: x86/mmu: Batch zap MMU pages when recycling oldest pages
  KVM: x86/mmu: Batch zap MMU pages when shrinking the slab
  KVM: x86/mmu: Exit to userspace on make_mmu_pages_available() error

 arch/x86/kvm/mmu/mmu.c         | 94 +++++++++++++++++++++-------------
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
 2 files changed, 61 insertions(+), 36 deletions(-)

-- 
2.26.0

