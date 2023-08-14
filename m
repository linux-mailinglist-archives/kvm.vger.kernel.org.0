Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1CD77C366
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjHNWZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 18:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjHNWZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 18:25:00 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A52DE4A
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 15:24:59 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVfzc-00FWLb-Cd; Tue, 15 Aug 2023 00:24:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From;
        bh=0fhry1kkrX6Ab+R3GzTnKZ7Ksd5sDrugDllzgcieiVA=; b=HVJDv8+mwTM13m7WEqt9WPNgiu
        QDkFNqZP1+6TIU7uDoLEqzaKr9rGw4DQGxOuNZLvlKChiDjNtvpfhAauiEAJnkrRwUP6CRofxEYLl
        U/mOKKovGkKX51MWLmHI8UZ7Wtk+Z/iur8ilIocdWbYNx+oEJK1CabvqrmU5exxCZ/x3C3pf5IO7M
        3CA/YyZX4CGsCYxpEbCvuH8f8lKcp9CQO8+XgoPcLCPHGQfe8Q2RAA8jBKMTIrfdNE9FyKkLd6p+O
        PAHYR+TuT5tAlQxz9MJsdwKxw+8AVzvwURPRwqRX5GpIROmnIlAQeaRhhyLu3588EMr3Oxtoz2E1e
        GcLyN9cQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVfzW-0000a4-1D; Tue, 15 Aug 2023 00:24:50 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVfzG-00077S-Lg; Tue, 15 Aug 2023 00:24:34 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net
Cc:     kvm@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 1/3] KVM: x86: Remove redundant vcpu->arch.cr0 assignments
Date:   Tue, 15 Aug 2023 00:08:35 +0200
Message-ID: <20230814222358.707877-2-mhal@rbox.co>
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

Drop the vcpu->arch.cr0 assignment after static_call(kvm_x86_set_cr0).
CR0 was already set by {vmx,svm}_set_cr0().

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/smm.c | 1 -
 arch/x86/kvm/x86.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index b42111a24cc2..dc3d95fdca7d 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -324,7 +324,6 @@ void enter_smm(struct kvm_vcpu *vcpu)
 
 	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
-	vcpu->arch.cr0 = cr0;
 
 	static_call(kvm_x86_set_cr4)(vcpu, 0);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c381770bcbf1..c247d3a7f6f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11522,7 +11522,6 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 
 	*mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
 	static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
-	vcpu->arch.cr0 = sregs->cr0;
 
 	*mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	static_call(kvm_x86_set_cr4)(vcpu, sregs->cr4);
-- 
2.41.0

