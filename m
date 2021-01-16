Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDCB2F8106
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 17:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbhAOQle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 11:41:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:47243 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbhAOQle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 11:41:34 -0500
IronPort-SDR: X61q8rdyMaBJMgQGl8judovh7+fqShB3BxGyzrAn6o5dujqVj/CPg8fVHGFge5kW7uVOoeKOIc
 Br3XY1gCx+KQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="197242510"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="197242510"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 08:39:47 -0800
IronPort-SDR: RrEB2VPQ6fmVivwsyoWos3bubN3OdgSMLVj/pIs2xh2DeSGw07aXxNksiS65+g4n7oEugX9lyP
 uJmyM3VgL68w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="354358704"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.148])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jan 2021 08:39:45 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: [PATCH] KVM: x86/MMU: Do not check unsync status for root SP.
Date:   Sat, 16 Jan 2021 08:21:00 +0800
Message-Id: <20210116002100.17339-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In shadow page table, only leaf SPs may be marked as unsync.
And for non-leaf SPs, we use unsync_children to keep the number
of the unsynced children. In kvm_mmu_sync_root(), sp->unsync
shall always be zero for the root SP, hence no need to check it.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481a..1a6bb03 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3412,8 +3412,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		 * mmu_need_write_protect() describe what could go wrong if this
 		 * requirement isn't satisfied.
 		 */
-		if (!smp_load_acquire(&sp->unsync) &&
-		    !smp_load_acquire(&sp->unsync_children))
+		if (!smp_load_acquire(&sp->unsync_children))
 			return;
 
 		spin_lock(&vcpu->kvm->mmu_lock);
-- 
1.9.1

