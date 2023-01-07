Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B20660AA3
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbjAGANj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbjAGANg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:13:36 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2A360877
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:13:35 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pDwq6-0047go-0M; Sat, 07 Jan 2023 01:13:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=Q3rOjDmxnoWl/ThW2e6qlUIU6e7qTV/IJfCXwgxs1r8=; b=cOlnjKRsYvVLm7jXAwlY0gyxZD
        IvFog5Hk/7ttpVrd+Hq53E4mzNdPt9kN+04dfHNXG7Gk8qXqrq2TOM4KapO6iAr4XN0+xNzjxkXw5
        MtTGJ+GrgqR5R56KktHQWs0gsG62Y3tRk9yPy6fIFPW5StdJhaL3PMnMMzZcTpQM/0Kr/SDbI6X3k
        Kw6CNxRBFMJ8nyYaf6XujkoUpsmd1s9O7PNvzTvcCjrBEzZvRCq5JT3f3ymncr/zViiL2NPH12BPn
        PU2/XQDXNiSEyjf/R4pifkiVmXGM9D2ued70z6Er7p/PDZYbfM0UXifESJ4SSp+fIftFNbbyEtF5p
        xumcbicw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pDwq5-0003xI-FG; Sat, 07 Jan 2023 01:13:33 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pDwpj-0002mN-Ph; Sat, 07 Jan 2023 01:13:11 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 4/6] KVM: x86: Explicitly state lockdep condition of msr_filter update
Date:   Sat,  7 Jan 2023 01:12:54 +0100
Message-Id: <20230107001256.2365304-5-mhal@rbox.co>
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

Replace `1` with the actual mutex_is_locked() check.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8abce24ec020..a35183dc2314 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6487,7 +6487,8 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 
 	mutex_lock(&kvm->lock);
 	/* The per-VM filter is protected by kvm->lock... */
-	old_filter = rcu_replace_pointer(kvm->arch.msr_filter, new_filter, 1);
+	old_filter = rcu_replace_pointer(kvm->arch.msr_filter, new_filter,
+					 mutex_is_locked(&kvm->lock));
 	mutex_unlock(&kvm->lock);
 	synchronize_srcu(&kvm->srcu);
 
-- 
2.39.0

