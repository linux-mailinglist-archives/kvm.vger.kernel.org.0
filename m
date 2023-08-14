Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B6277C365
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 00:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbjHNWZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 18:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjHNWZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 18:25:00 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB03E54
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 15:24:59 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVfzd-00FWLo-WA; Tue, 15 Aug 2023 00:24:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From;
        bh=Od6WH++ZJ7arVsz4Q1GR/IAuFpCxd/491K/hDK5ZDoQ=; b=xKHJMEUgqeg9uU6Mz7+S14HlPJ
        BKsT4mBrvOfNTLzh5NmRt7GiO2tYbgpmn1ld9Wsrt2W2GDawJhJiPRE+JzitsWctk2shle1iXMZR0
        CtHCzYM67+ZMouUWUf43ajI8HPLtg5e48byq3/0yixwG+EhHgOiqSwjfhlrWuJ/MmQn/MAZHzVqOP
        eVrtW3RHoghQrexhkayjOKwBKzlFabeD8z47Coh8Ntjip5D8XiH1kmz86UrszvliEXPZD4Oa58KVz
        LXm3OL2Yxi/PtrjJJXjDs0sAs701y0p+ldmcNuIRV+62LhhgNKLInXVuYH2XGGcIRipyiIlRxG+yH
        5Fc4A2Ng==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVfzY-0000aH-IZ; Tue, 15 Aug 2023 00:24:52 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVfzH-00077S-3G; Tue, 15 Aug 2023 00:24:35 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net
Cc:     kvm@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 2/3] KVM: x86: Force TLB flush on changes to special registers
Date:   Tue, 15 Aug 2023 00:08:36 +0200
Message-ID: <20230814222358.707877-3-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230814222358.707877-1-mhal@rbox.co>
References: <20230814222358.707877-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can directly modify content of vCPU's EFER/CRn via
KVM_SYNC_X86_SREGS and KVM_SET_SREGS{,2}. Make sure that when MMU context
reset is triggered, guest's TLB and paging-structure caches will be
flushed.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c247d3a7f6f9..4e92ef30a736 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11565,8 +11565,10 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (ret)
 		return ret;
 
-	if (mmu_reset_needed)
+	if (mmu_reset_needed) {
 		kvm_mmu_reset_context(vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+	}
 
 	max_bits = KVM_NR_INTERRUPTS;
 	pending_vec = find_first_bit(
@@ -11607,8 +11609,10 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 		mmu_reset_needed = 1;
 		vcpu->arch.pdptrs_from_userspace = true;
 	}
-	if (mmu_reset_needed)
+	if (mmu_reset_needed) {
 		kvm_mmu_reset_context(vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+	}
 	return 0;
 }
 
-- 
2.41.0

