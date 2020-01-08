Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532231337E4
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 01:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgAHATB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 19:19:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:45392 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgAHATA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 19:19:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 16:19:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,407,1571727600"; 
   d="scan'208";a="211360872"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 07 Jan 2020 16:19:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Fix a benign Bitwise vs. Logical OR mixup
Date:   Tue,  7 Jan 2020 16:18:59 -0800
Message-Id: <20200108001859.25254-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a Logical OR in __is_rsvd_bits_set() to combine the two reserved bit
checks, which are obviously intended to be logical statements.  Switching
to a Logical OR is functionally a nop, but allows the compiler to better
optimize the checks.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7269130ea5e2..72e845709027 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3970,7 +3970,7 @@ __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check, u64 pte, int level)
 {
 	int bit7 = (pte >> 7) & 1, low6 = pte & 0x3f;
 
-	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) |
+	return (pte & rsvd_check->rsvd_bits_mask[bit7][level-1]) ||
 		((rsvd_check->bad_mt_xwr & (1ull << low6)) != 0);
 }
 
-- 
2.24.1

