Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C50562BAF
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 08:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbiGAG33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 02:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbiGAG3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 02:29:21 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71D5635DCB;
        Thu, 30 Jun 2022 23:28:49 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id A67D61E80D21;
        Fri,  1 Jul 2022 14:27:19 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1r7Sg3ixidkE; Fri,  1 Jul 2022 14:27:16 +0800 (CST)
Received: from localhost.localdomain (unknown [112.65.12.78])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 242571E80D09;
        Fri,  1 Jul 2022 14:27:15 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     anup@brainfault.org, atishp@atishpatra.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Cc:     kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] RISC-V: KVM: Fix variable spelling mistake
Date:   Fri,  1 Jul 2022 14:28:38 +0800
Message-Id: <20220701062838.6727-1-jiaming@nfschina.com>
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

There is a spelling mistake in mmu.c and vcpu_exit.c. Fix it.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 arch/riscv/kvm/mmu.c       | 8 ++++----
 arch/riscv/kvm/vcpu_exit.c | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1c00695ebee7..2965284a490d 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -611,7 +611,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 {
 	int ret;
 	kvm_pfn_t hfn;
-	bool writeable;
+	bool writable;
 	short vma_pageshift;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct vm_area_struct *vma;
@@ -659,7 +659,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 
 	mmu_seq = kvm->mmu_notifier_seq;
 
-	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
+	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
 				vma_pageshift, current);
@@ -673,14 +673,14 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	 * for write faults.
 	 */
 	if (logging && !is_write)
-		writeable = false;
+		writable = false;
 
 	spin_lock(&kvm->mmu_lock);
 
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
 
-	if (writeable) {
+	if (writable) {
 		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
 		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index dbb09afd7546..f4e569688619 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -417,17 +417,17 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	struct kvm_memory_slot *memslot;
 	unsigned long hva, fault_addr;
-	bool writeable;
+	bool writable;
 	gfn_t gfn;
 	int ret;
 
 	fault_addr = (trap->htval << 2) | (trap->stval & 0x3);
 	gfn = fault_addr >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
-	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writeable);
+	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 
 	if (kvm_is_error_hva(hva) ||
-	    (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writeable)) {
+	    (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writable)) {
 		switch (trap->scause) {
 		case EXC_LOAD_GUEST_PAGE_FAULT:
 			return emulate_load(vcpu, run, fault_addr,
-- 
2.25.1

