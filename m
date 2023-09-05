Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BFD790FB5
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 03:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350348AbjIDBsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Sep 2023 21:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbjIDBsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Sep 2023 21:48:55 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 7F8CCF4;
        Sun,  3 Sep 2023 18:48:51 -0700 (PDT)
Received: from localhost.localdomain (unknown [219.141.250.2])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 57F716018CCC6;
        Mon,  4 Sep 2023 09:48:49 +0800 (CST)
X-MD-Sfrom: zeming@nfschina.com
X-MD-SrcIP: 219.141.250.2
From:   Li zeming <zeming@nfschina.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li zeming <zeming@nfschina.com>
Subject: [v2 PATCH] =?UTF-8?q?x86/kvm/mmu:=20Remove=20unnecessary=20=E2=80=98?= =?UTF-8?q?NULL=E2=80=99=20values=20from=20sptep?=
Date:   Wed,  6 Sep 2023 02:20:06 +0800
Message-Id: <20230905182006.2964-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_24_48,
        RDNS_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove spte and sptep initialization assignments, add sptep assignment
check and processing.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 v2:
   1. Remove spte initialization assignment.
   2. Add sptep assignment check.

 arch/x86/kvm/mmu/mmu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..0d11bfeae2f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3456,8 +3456,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
-	u64 spte = 0ull;
-	u64 *sptep = NULL;
+	u64 spte;
+	u64 *sptep;
 	uint retry_count = 0;
 
 	if (!page_fault_can_be_fast(fault))
@@ -3473,6 +3473,14 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		else
 			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
+		/*
+		 * It's entirely possible for the mapping to have been zapped
+		 * by a different task, but the root page is should always be
+		 * available as the vCPU holds a reference to its root(s).
+		 */
+		if (WARN_ON_ONCE(!sptep))
+			spte = REMOVED_SPTE;
+
 		if (!is_shadow_present_pte(spte))
 			break;
 
-- 
2.18.2

