Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79B172309F
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 22:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjFEUC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 16:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjFEUCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 16:02:25 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8136C91
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 13:02:23 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q6GPD-00CUHy-Tt; Mon, 05 Jun 2023 22:02:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject
        :Cc:To:From; bh=00nyeVZJ6VRcL1OwY4DdGhPIbZPY2BxiMshUhUbl2Cs=; b=F5vG9S2KsKckl
        5Au7Sr/A/d0wXdniVd/gIoNrLZ6JZor+HSgJ5FdrMLtcDox9OZp9YgZJCc6IFQup1hiUqUB7AfXbA
        0Zbr9dXCPk3EWkm5LQdrTmZ3Ec/LUiVAUSgdJX26IRa2BIz0hDGzgY97i9u0GeShTwVs9LppMctBB
        PK3kYbBOPn5iwwBF+sgSqfOifh7mZ5xA1LXIqUmq8L0xI2qNE7JVuMUV9wf5pjgoTSsTvHrImcJ7a
        8AsT1xDuzMwQ6D/mM8keAVeMfxRxCFelKBX4uQCT1/1Zlxdp48LvoY1HTnbThZhnuPDaO5o6Fdqb2
        fdjWPG9AdmSyawclbpZ4A==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q6GPD-00048G-CM; Mon, 05 Jun 2023 22:02:19 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q6GP9-0007f4-Mm; Mon, 05 Jun 2023 22:02:15 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] KVM: x86: Clean up: remove redundant bool conversions
Date:   Mon,  5 Jun 2023 22:01:21 +0200
Message-ID: <20230605200158.118109-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As test_bit() returns bool, explicitly converting result to bool is
unnecessary. Get rid of '!!'.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/x86.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aa0b90972376..4048938a9564 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -739,7 +739,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 
 	BUG_ON(offset == MSR_INVALID);
 
-	return !!test_bit(bit_write,  &tmp);
+	return test_bit(bit_write, &tmp);
 }
 
 static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ad55ef71433..4532b2e4b841 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1809,7 +1809,7 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 		unsigned long *bitmap = ranges[i].bitmap;
 
 		if ((index >= start) && (index < end) && (flags & type)) {
-			allowed = !!test_bit(index - start, bitmap);
+			allowed = test_bit(index - start, bitmap);
 			break;
 		}
 	}
-- 
2.41.0

