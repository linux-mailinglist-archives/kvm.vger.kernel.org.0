Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2A4660AA1
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjAGANc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjAGANV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:13:21 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7594D60877
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:13:20 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpq-004nJU-L8; Sat, 07 Jan 2023 01:13:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=pABIdWrOy9FmO2XYu+ZJ87/PmCSn0Zw4sSM1VsE7V/w=; b=s+t2B5x0cxFlY/PZTyhUGNofin
        2tF0RTYFPKd7+314XeLNCbvW0e+jfM9AcI17pBUz6iqdsKCTFnaW+hifV0yply2VPnlpJJLFDa97Y
        BBxnfnaZUEo47+9tBAgdlo7FgfZk//mxr5wYRkQ9ECROT3obQeV1CYHuagjYLTSq/GiRV7ZuK7gCi
        3Zwof5159hDRfz/2a5L+bLFcvin9vIGkqRvW3aS8EhURYWlCZYWH7w0veaoVjblSMDMuJgDvgW5ex
        PrQ0pZeHBe3648+pvXx4vuXyu/By3l13G75ik7zB2rPE7S3NzgriBqce+956iamHRO0ppZmvX3G/m
        V28ju0Vg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpl-0002cO-B1; Sat, 07 Jan 2023 01:13:13 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pDwpk-0002mN-68; Sat, 07 Jan 2023 01:13:12 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 5/6] KVM: x86: Remove unnecessary initialization in kvm_vm_ioctl_set_msr_filter()
Date:   Sat,  7 Jan 2023 01:12:55 +0100
Message-Id: <20230107001256.2365304-6-mhal@rbox.co>
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

Do not initialize the value of `r`, as it will be overwritten.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a35183dc2314..18d5b82eb46d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6460,7 +6460,7 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 	struct kvm_x86_msr_filter *new_filter, *old_filter;
 	bool default_allow;
 	bool empty = true;
-	int r = 0;
+	int r;
 	u32 i;
 
 	if (filter->flags & ~KVM_MSR_FILTER_VALID_MASK)
-- 
2.39.0

