Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEEC276033
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgIWSmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:42:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:9838 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgIWSmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:42:38 -0400
IronPort-SDR: v8pJFzpbi4C9nA4gR3RsFx8Rxvozla4Kwy3lTMKdaSE/XrZqyHMnB3bA28rieYf0oLkAY8oVW3
 D9qNg897GyxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160276861"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160276861"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:37:37 -0700
IronPort-SDR: VMcmoaIlgkERQ1mH6uE/4KT7MQHddhXLk0+SqEYv2740mytxNvTuPLvWrBKKA1ShvrkhorD3+h
 +KRWsoIUQd8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486561616"
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
Subject: [PATCH v2 1/8] KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages
Date:   Wed, 23 Sep 2020 11:37:28 -0700
Message-Id: <20200923183735.584-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923183735.584-1-sean.j.christopherson@intel.com>
References: <20200923183735.584-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call kvm_mmu_commit_zap_page() after exiting the "prepare zap" loop in
kvm_recover_nx_lpages() to finish zapping pages in the unlikely event
that the loop exited due to lpage_disallowed_mmu_pages being empty.
Because the recovery thread drops mmu_lock() when rescheduling, it's
possible that lpage_disallowed_mmu_pages could be emptied by a different
thread without to_zap reaching zero despite to_zap being derived from
the number of disallowed lpages.

Fixes: 1aa9b9572b105 ("kvm: x86: mmu: Recovery of shattered NX large pages")
Cc: Junaid Shahid <junaids@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76c5826e29a2..dde6503d8926 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6376,6 +6376,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				cond_resched_lock(&kvm->mmu_lock);
 		}
 	}
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
-- 
2.28.0

