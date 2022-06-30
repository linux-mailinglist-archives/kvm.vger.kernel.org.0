Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D53561B00
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 15:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiF3NIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 09:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbiF3NIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 09:08:47 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E7DC13D5C;
        Thu, 30 Jun 2022 06:08:46 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 548981E80D11;
        Thu, 30 Jun 2022 21:07:24 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8kwn5uBiFNEb; Thu, 30 Jun 2022 21:07:21 +0800 (CST)
Received: from localhost.localdomain (unknown [112.65.12.78])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id AAA571E80CB6;
        Thu, 30 Jun 2022 21:07:20 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        tsbogend@alpha.franken.de
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        renyu@nfschina.com, Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] KVM: MIPS/MMU: Fix spelling mistake in a variable
Date:   Thu, 30 Jun 2022 21:08:39 +0800
Message-Id: <20220630130839.9464-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a spelling mistake in a variable.
Change 'writeable' to 'writable'.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 arch/mips/kvm/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 1bfd1b501d82..a331407b6b04 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -594,7 +594,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	int srcu_idx, err;
 	kvm_pfn_t pfn;
 	pte_t *ptep, entry, old_pte;
-	bool writeable;
+	bool writable;
 	unsigned long prot_bits;
 	unsigned long mmu_seq;
 
@@ -630,7 +630,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	smp_rmb();
 
 	/* Slow path - ask KVM core whether we can access this GPA */
-	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writeable);
+	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
 	if (is_error_noslot_pfn(pfn)) {
 		err = -EFAULT;
 		goto out;
@@ -654,7 +654,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 
 	/* Set up the PTE */
 	prot_bits = _PAGE_PRESENT | __READABLE | _page_cachable_default;
-	if (writeable) {
+	if (writable) {
 		prot_bits |= _PAGE_WRITE;
 		if (write_fault) {
 			prot_bits |= __WRITEABLE;
-- 
2.25.1

