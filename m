Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4532203ED
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgGOE1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:27:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:59539 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgGOE11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:27:27 -0400
IronPort-SDR: rdKDBCCr0sQNNk++uBrIur9cfBae2UiSmnL9e3xxeXejqYE9kRMbeTOVZ6GPCp6NcD6hTmDA+k
 bBvehhDYzs1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233936294"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="233936294"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:27:26 -0700
IronPort-SDR: DNE1cujfr2YcOX6Y8wIRz+c51jOPkd1aM06hjDa0GiaU/wlWW0/H97wHq1+QkQ3uAJ/ShSDN6z
 Dj5rKSlifSMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="308118775"
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
Subject: [PATCH 1/8] KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages
Date:   Tue, 14 Jul 2020 21:27:18 -0700
Message-Id: <20200715042725.10961-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715042725.10961-1-sean.j.christopherson@intel.com>
References: <20200715042725.10961-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 77810ce66bdb4..48be51027af64 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6340,6 +6340,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				cond_resched_lock(&kvm->mmu_lock);
 		}
 	}
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
-- 
2.26.0

