Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB50E3B0848
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhFVPLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 11:11:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56800 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhFVPLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 11:11:53 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lvi1Z-0000T7-2p; Tue, 22 Jun 2021 15:09:13 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: x86/mmu: Fix uninitialized boolean variable flush
Date:   Tue, 22 Jun 2021 16:09:12 +0100
Message-Id: <20210622150912.23429-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where kvm_memslots_have_rmaps(kvm) is false the boolean
variable flush is not set and is uninitialized.  If is_tdp_mmu_enabled(kvm)
is true then the call to kvm_tdp_mmu_zap_collapsible_sptes passes the
uninitialized value of flush into the call. Fix this by initializing
flush to false.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: e2209710ccc5 ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ed24e97c1549..b8d20f139729 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5689,7 +5689,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
 	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
-	bool flush;
+	bool flush = false;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-- 
2.31.1

