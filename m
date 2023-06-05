Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158597224DF
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 13:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjFELtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 07:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjFELtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 07:49:23 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019569C
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 04:49:20 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q68i6-00BUh9-Cp
        for kvm@vger.kernel.org; Mon, 05 Jun 2023 13:49:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject
        :Cc:To:From; bh=29hRA4iwJI3jyKdceam+EoIutwRa//Yz8WrFwHASpbg=; b=KBT1M80cpSP+l
        2FwF8N7RhuA80xIJUgoyPYhBhsb2E3KAXkwCKP38TgCvaadwEpQN/ldyAdJ7ZL10q3r4g0TBf/j8E
        SzlwOqrgwPKbTB1jB9aaY+aAA2YvorlHrbYDWzG8tHFjdJfsl2yff1ek1v4bxcSPd59w8BJEkqZ/q
        cUJ7h5ZnXewSmVogxNiqlvSjEFgzzKtAEQQ6Kk7BFrjSLr/nVD/eYOFlPGJcrgm26Bw+MxA5u/gjR
        rxkknDKbDXEqN9pX8DmAuZiChSuLVnxlXFlMJxCS261Dp5cwHOpTrudRN2tTRxzPZ9vi5lVg5Mauu
        3j2uvXUMbjCkkeEvb/hxQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q68i5-0006Yp-Ud; Mon, 05 Jun 2023 13:49:18 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q68i3-0001jQ-U9; Mon, 05 Jun 2023 13:49:16 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] KVM: Clean up kvm_vm_ioctl_create_vcpu()
Date:   Mon,  5 Jun 2023 13:44:19 +0200
Message-ID: <20230605114852.288964-1-mhal@rbox.co>
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

Since c9d601548603 ("KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond")
'cond' is internally converted to boolean, so caller's explicit conversion
from void* is unnecessary.

Remove the double bang.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a658f30af91..64dd940c549e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3975,7 +3975,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r < 0)
 		goto kvm_put_xa_release;
 
-	if (KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
+	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
 		r = -EINVAL;
 		goto kvm_put_xa_release;
 	}

base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7
-- 
2.41.0

