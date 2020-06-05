Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258091F0271
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgFEVjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:39:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:49312 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728227AbgFEVjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:09 -0400
IronPort-SDR: a+l7TQttL4EPzDmuOTBV/u+clvB2UgI4OJ36C4TGB1IPlEJc78wh4ZjtFwgZXa71LqDxSBmJln
 QJd2RFmEnyCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:08 -0700
IronPort-SDR: QsmbfClzyf8D/ICjb7dDyC1MYIA7FZOgNpuwJmABrVoK4JXXrioxZ9474jHd7ZQQ7Li6SBtZbe
 e6i3ypJcbYaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860877"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 04/21] KVM: x86/mmu: Remove superfluous gotos from mmu_topup_memory_caches()
Date:   Fri,  5 Jun 2020 14:38:36 -0700
Message-Id: <20200605213853.14959-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return errors directly from mmu_topup_memory_caches() instead of
branching to a label that does the same.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36c90f004ef4..ba70de24a5b0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1100,13 +1100,11 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
 				   8 + PTE_PREFETCH_NUM);
 	if (r)
-		goto out;
+		return r;
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache, 8);
 	if (r)
-		goto out;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
-out:
-	return r;
+		return r;
+	return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
 }
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
-- 
2.26.0

