Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829D3435B4B
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 09:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhJUHIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 03:08:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:34561 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhJUHIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 03:08:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="228909601"
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="228909601"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 00:05:50 -0700
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="594983769"
Received: from chenyi-pc.sh.intel.com ([10.239.159.60])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 00:05:48 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: MMU: Reset mmu->pkru_mask to avoid stale data
Date:   Thu, 21 Oct 2021 15:10:22 +0800
Message-Id: <20211021071022.1140-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When updating mmu->pkru_mask, the value can only be added but it isn't
reset in advance. This will make mmu->pkru_mask keep the stale data.
Fix this issue.

Fixes: commit 2d344105f57c ("KVM, pkeys: introduce pkru_mask to cache conditions")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ddb042b281..fe73d7ee5492 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4556,10 +4556,10 @@ static void update_pkru_bitmask(struct kvm_mmu *mmu)
 	unsigned bit;
 	bool wp;
 
-	if (!is_cr4_pke(mmu)) {
-		mmu->pkru_mask = 0;
+	mmu->pkru_mask = 0;
+
+	if (!is_cr4_pke(mmu))
 		return;
-	}
 
 	wp = is_cr0_wp(mmu);
 
-- 
2.17.1

