Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1ECC558F25
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 05:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiFXDhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 23:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiFXDhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 23:37:12 -0400
Received: from out0-145.mail.aliyun.com (out0-145.mail.aliyun.com [140.205.0.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8C753A70;
        Thu, 23 Jun 2022 20:37:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047206;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.OBfZx3-_1656041825;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OBfZx3-_1656041825)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 11:37:05 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] KVM: x86/mmu: Reduce gfn range of tlb flushing in tdp_mmu_map_handle_target_level()
Date:   Fri, 24 Jun 2022 11:36:59 +0800
Message-Id: <1b95b17331e6a863f8336e305df936b0d164b688.1656039275.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the children SP is zapped, the gfn range of tlb flushing should be
the range covered by children SP not parent SP. Replace sp->gfn which is
the base gfn of parent SP with iter->gfn and use the correct size of
gfn range for children SP to reduce tlb flushing range.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f3a430d64975..85838ae169b8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1075,8 +1075,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-						   KVM_PAGES_PER_HPAGE(iter->level + 1));
+		kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter->gfn,
+						   KVM_PAGES_PER_HPAGE(iter->level));
 
 	/*
 	 * If the page fault was caused by a write but the page is write
-- 
2.31.1

