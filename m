Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12F51159EA
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfLFX6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:58:39 -0500
Received: from mga07.intel.com ([134.134.136.100]:55585 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfLFX5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530340"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] KVM: x86/mmu: Refactor the per-slot level calculation in mapping_level()
Date:   Fri,  6 Dec 2019 15:57:19 -0800
Message-Id: <20191206235729.29263-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invert the loop which adjusts the allowed page level based on what's
compatible with the associated memslot to use a largest-to-smallest
page size walk.  This paves the way for passing around a "max level"
variable instead of having redundant checks and/or multiple booleans.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e4a96236aa14..bd1711201181 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1326,7 +1326,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 			 bool *force_pt_level)
 {
-	int host_level, level, max_level;
+	int host_level, max_level;
 	struct kvm_memory_slot *slot;
 
 	if (unlikely(*force_pt_level))
@@ -1343,12 +1343,12 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 		return host_level;
 
 	max_level = min(kvm_x86_ops->get_lpage_level(), host_level);
-
-	for (level = PT_DIRECTORY_LEVEL; level <= max_level; ++level)
-		if (__mmu_gfn_lpage_is_disallowed(large_gfn, level, slot))
+	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
+		if (!__mmu_gfn_lpage_is_disallowed(large_gfn, max_level, slot))
 			break;
+	}
 
-	return level - 1;
+	return max_level;
 }
 
 /*
-- 
2.24.0

