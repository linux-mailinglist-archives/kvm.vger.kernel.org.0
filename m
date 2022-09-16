Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A31C5BA3A6
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIPA5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 20:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiIPA4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 20:56:52 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7144486C09
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 17:56:50 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oYzey-002MaT-MC; Fri, 16 Sep 2022 02:56:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=OCgAeRyK21iu06MarXun36XlV9L5XwhDb3ZlDvZkScY=; b=TfWjSzhG39ao623TlmP+lUp7xM
        WxKGbkp70yN8qqz0dTq11WKoEWvRWZdbbTl1ryKq0IZ02J2l6zhbzxq8jV4hHDYxXq9r6cD/81RPU
        bnCyTsg01mK2xfMqaUEzhxk1dPLLHNP8wNzPIHkJSBfuAupuWOoKQG+oVQR3TS+NQpoyGcPiX0ZDA
        56zDZViaLxEeTgRLUrb1Ux/SPcolyJhaV1fIvSnwA7P7Z8whCBKMLCxfEdvZSPS+cqKoOIwCUT2ZZ
        G7QumxvdK3QDH5oI/TSwb13L3deIYps+eLJquJSea/5K0O41l3oDEYET2NkL6ozDO8xyPo9Jc+m8K
        akO7QKpA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oYzey-00081Y-DW; Fri, 16 Sep 2022 02:56:48 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oYzek-0000xy-Mm; Fri, 16 Sep 2022 02:56:34 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [RFC PATCH 2/4] KVM: x86/xen: Ensure kvm_xen_schedop_poll() can use shinfo_cache
Date:   Fri, 16 Sep 2022 02:54:03 +0200
Message-Id: <20220916005405.2362180-3-mhal@rbox.co>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220916005405.2362180-1-mhal@rbox.co>
References: <20220916005405.2362180-1-mhal@rbox.co>
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

Before taking gpc->lock, ensure it has been initialized.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/xen.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e32c2cf06223..c5d431a54afa 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -965,6 +965,9 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 	bool ret = true;
 	int idx, i;
 
+	if (!gpc->active)
+		return true;
+
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
 	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
-- 
2.37.2

