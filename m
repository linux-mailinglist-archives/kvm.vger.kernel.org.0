Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380F645438A
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 10:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbhKQJXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 04:23:44 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:50531 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234944AbhKQJXm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 04:23:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Ux26S4B_1637140842;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0Ux26S4B_1637140842)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Nov 2021 17:20:42 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86/mmu: Pass parameter flush as false in kvm_tdp_mmu_zap_collapsible_sptes()
Date:   Wed, 17 Nov 2021 17:20:40 +0800
Message-Id: <21453a1d2533afb6e59fb6c729af89e771ff2e76.1637140154.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
References: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since tlb flush has been done for legacy MMU before
kvm_tdp_mmu_zap_collapsible_sptes(), so the parameter flush
should be false for kvm_tdp_mmu_zap_collapsible_sptes().

Fixes: e2209710ccc5d ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d57319e596a9..4b2be04e9862 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5853,7 +5853,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
 {
-	bool flush = false;
+	bool flush;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
@@ -5870,7 +5870,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
+		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, false);
 		if (flush)
 			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
-- 
2.31.1

