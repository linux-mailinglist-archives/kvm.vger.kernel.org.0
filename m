Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A280652388
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 16:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiLTPPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 10:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiLTPPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 10:15:35 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C76B4AC
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 07:15:33 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p7eL5-00E3iI-5p; Tue, 20 Dec 2022 16:15:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=X1ejq6ggTIozaKNSSHRmTaYPrKcXsVu2lyBzP4QTPFI=; b=YzXNK4JKQoRzL
        IojkyD7tRfySJh6KkhwBRXPnPOmwcYgV0yv1fiVQ3ScVLFEK7r+wnBjWNvbAPhJrOG5APUW9Fqp8w
        Xb4QFw+WJhCH5mSRGglsJxOsmXqWMWwP3lN0GsQaSTkRfzUWU/hLguILgcfbeiqdwLMk7Xp+tjRyU
        u8Xg57UuZzz0x4wPzn0eyPzLQzNbZCnAXO3gHaBsCPcWZ92txhHHxoU8CrxTm6aTKWopC86FzqheS
        O6SojUpjurIt5kVbPPLsHcbFNjeGtCNNvSVdJ8XG+1/5kKmI8o8jgNAF8/MmDiNy07TD8tbbH1HRK
        iNVVt1WQgVsz3lZy1PR7g==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p7eL1-0001c0-Qy; Tue, 20 Dec 2022 16:15:28 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p7eKk-0007rk-2H; Tue, 20 Dec 2022 16:15:10 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2] KVM: x86/xen: Fix memory leak in kvm_xen_write_hypercall_page()
Date:   Tue, 20 Dec 2022 16:14:54 +0100
Message-Id: <20221220151454.712165-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
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

Release page irrespectively of kvm_vcpu_write_guest() return value.

Suggested-by: Paul Durrant <paul@xen.org>
Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/xen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index f3098c0e386a..439a65437075 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -889,6 +889,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
 				  : kvm->arch.xen_hvm_config.blob_size_32;
 		u8 *page;
+		int ret;
 
 		if (page_num >= blob_size)
 			return 1;
@@ -899,10 +900,10 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
-		if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
-			kfree(page);
+		ret = kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE);
+		kfree(page);
+		if (ret)
 			return 1;
-		}
 	}
 	return 0;
 }
-- 
2.39.0

