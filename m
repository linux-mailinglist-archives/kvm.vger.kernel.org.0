Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44057660AA2
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbjAGANd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbjAGANa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:13:30 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD3959FA0
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:13:29 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpz-004nJo-IE; Sat, 07 Jan 2023 01:13:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=Zr05VKeT1x+qeEuutQZXUGyRBc7jl4NVLxkeYLRX+pI=; b=Zo0OL8euCamta4Dw4bs15sClWg
        hggsV0P+WAN/BSnLCgqil1dFcj/dmstfPAay0fZ8/M87549x2JTuBrtRVnF7t1CXFfceeCP9cF4K9
        Fdd2OAhN5JlGSUPvy7TRgLnixfLqfqLc4fYUtQEzzpr8GZpwfZuWYlD7Fac/tmB4I5zJC1S9edTNb
        jWK1HcR6vWnWVsjJYpJKP32xRIFnxCSOqOXkMlY2UE77iA6X0dUeHTQ+uAaLeQXuK24fkZNDScX7h
        7pRutJP5phUjJyc2d02GBiVJCJPX0LbKz6OOZrQlYiUP1Myc9/zyujadD3CLLOd+PdjpI2hLPzZPK
        aodTS5ew==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpk-0002cK-57; Sat, 07 Jan 2023 01:13:12 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pDwpj-0002mN-0b; Sat, 07 Jan 2023 01:13:11 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 2/6] KVM: x86: Optimize kvm->lock and SRCU interaction (KVM_X86_SET_MSR_FILTER)
Date:   Sat,  7 Jan 2023 01:12:52 +0100
Message-Id: <20230107001256.2365304-3-mhal@rbox.co>
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

Reduce time spent holding kvm->lock: unlock mutex before calling
synchronize_srcu().

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..7d398e0da834 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6491,12 +6491,12 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 	old_filter = srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1);
 
 	rcu_assign_pointer(kvm->arch.msr_filter, new_filter);
+	mutex_unlock(&kvm->lock);
 	synchronize_srcu(&kvm->srcu);
 
 	kvm_free_msr_filter(old_filter);
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);
-	mutex_unlock(&kvm->lock);
 
 	return 0;
 }
-- 
2.39.0

