Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722C66CAC76
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 19:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjC0R4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 13:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjC0Rzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 13:55:52 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B28198B
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 10:55:24 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pgr3x-00G2vH-1Z
        for kvm@vger.kernel.org; Mon, 27 Mar 2023 19:55:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=KcWcEhbQnzaM+OWGrcO8TZoiwnEN030AVSvJxRyahQA=; b=RM4IXxkzaqpb7
        yS9UjqEPHZ8KJPlTri7M1tdyU9LxlOEx9biLrOWqPXJHGlfd04eYj1WJwot7eE+kiVpb6Ip9LjlRz
        8FEu722fZoX9XWzP6QvtA5Opsd05duH/9oD8KeLXyz7B7CC6uE1Er7VEThoTqAeQHxHhYdamaotFf
        NTjwHvxLscb3/+ymzeiF2CLbCRR9zYY2O8QrZ8PXR1ytEIrDy+OBC+q1FyMaWLAWc6FFwDMBDlZFU
        4R+G4QWEejRY+vKMuILlogeQQpcwiu6k2qakeNfMUN/X8/pI9jGcYxP8CbnGhn51B7/po9kuXHtl0
        N381ze1H8oRBJADaBKbag==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pgr3w-00016n-Bz; Mon, 27 Mar 2023 19:55:20 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pgr3u-0006eO-N1; Mon, 27 Mar 2023 19:55:18 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] KVM: Don't kfree(NULL) on kzalloc() failure in kvm_assign_ioeventfd_idx()
Date:   Mon, 27 Mar 2023 19:54:57 +0200
Message-Id: <20230327175457.735903-1-mhal@rbox.co>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On kzalloc() failure, taking the `goto fail` path leads to kfree(NULL).
Such no-op has no use. Move it out.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 virt/kvm/eventfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2a3ed401ce46..385368e706e5 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -856,9 +856,9 @@ static int kvm_assign_ioeventfd_idx(struct kvm *kvm,
 
 unlock_fail:
 	mutex_unlock(&kvm->slots_lock);
+	kfree(p);
 
 fail:
-	kfree(p);
 	eventfd_ctx_put(eventfd);
 
 	return ret;
-- 
2.40.0

