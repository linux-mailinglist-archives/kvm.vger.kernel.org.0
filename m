Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EE0660A9D
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbjAGANT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjAGANR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:13:17 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E71359FA0
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:13:16 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpl-0047fj-GU; Sat, 07 Jan 2023 01:13:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=xV2/TdpTSiQpTHoXJU8/ntXNFQ5M3TbjS3BqvVEG6hA=; b=kByhev+Go+YYEH2x4ASl+56ktq
        1bRD9LyMEDXPRTYCzEmtOXTL5YDRkDZsDFHoShDScIJ9Yfn6sHl7RzF1xzCyozxJGjBV6X1uxDlt7
        MLGjTiMfLfeQiF/vWeA0IeWvu431lFq5Owh1+psDH8gFS+EwCeJ0PC8yNgSg/zr8Gq1GCM/fOTwGi
        oVLNm/oqUQsIlxdNMyahA9BHhogJH1o1Bje7A4ksNVhyNcnHQAccuswWmcl9mmd8eHwKBamaaQ4+m
        TeV0tlcEihqKKxGPM1owcnDFVoyLA3xOJULPqyeydOOl1wxR6pDf/7SkT9bF3849qMoH/e+QukK/f
        GTYzw9rQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpk-0003vv-OO; Sat, 07 Jan 2023 01:13:12 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pDwpj-0002mN-DB; Sat, 07 Jan 2023 01:13:11 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 3/6] KVM: x86: Simplify msr_filter update
Date:   Sat,  7 Jan 2023 01:12:53 +0100
Message-Id: <20230107001256.2365304-4-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107001256.2365304-1-mhal@rbox.co>
References: <20230107001256.2365304-1-mhal@rbox.co>
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

Replace srcu_dereference()+rcu_assign_pointer() sequence with
a single rcu_replace_pointer().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7d398e0da834..8abce24ec020 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6486,11 +6486,8 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 	}
 
 	mutex_lock(&kvm->lock);
-
 	/* The per-VM filter is protected by kvm->lock... */
-	old_filter = srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1);
-
-	rcu_assign_pointer(kvm->arch.msr_filter, new_filter);
+	old_filter = rcu_replace_pointer(kvm->arch.msr_filter, new_filter, 1);
 	mutex_unlock(&kvm->lock);
 	synchronize_srcu(&kvm->srcu);
 
-- 
2.39.0

