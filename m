Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E329B67C271
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 02:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbjAZBfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 20:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbjAZBfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 20:35:02 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B466442BCC
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 17:35:00 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pKrAI-0008Hc-Ie; Thu, 26 Jan 2023 02:34:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=mkKLd+Nl0dzHhO/ZpUOh7csjuX9tYuDb2agNDk37ukg=; b=E4XqGX+dXh3GtwtL9Ud1bwXaA/
        JUDshGCcIo4vQGy+UwVY7NP+989Kx3uXogrMNFypTck5uYCeO/sRDTHybyf2kJsTwdj6/clumqeQg
        UqTdDfW2dMrOICZfx5X8qYibAse9LhFpuDobt3VERYL05KCz+4QLUGLYXAHA4ZKNfQDPyhPwMPCVi
        1j7DgDLzAg3GC7VOrd7DUGkcDtmb8dxtXGi9JVux0YAYbJGPrJNIrlDZDq1a24zoW9XW+0Yivgatr
        uZdjYex3sGnbFyShl43BKfrTi3Kb7xtUOPOkiGff6ZiyUH7jnh2f/gO5Vj9soKrfFaJtajFlA6I9j
        QoXpghSQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pKrAI-0003BJ-9r; Thu, 26 Jan 2023 02:34:58 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pKrA7-00010H-QQ; Thu, 26 Jan 2023 02:34:47 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [kvm-unit-tests PATCH 3/3] x86: Test CPL=3 DS/ES/FS/GS RPL=DPL=0 segment descriptor load
Date:   Thu, 26 Jan 2023 02:34:05 +0100
Message-Id: <20230126013405.2967156-4-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230126013405.2967156-1-mhal@rbox.co>
References: <20230126013405.2967156-1-mhal@rbox.co>
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

User space loading of DS, ES, FS, or GS is forbidden for a DPL=0
segment descriptor (conforming code segment being an exception).
Verify that #GP is raised if

	((segment is a data or nonconforming code segment)
	 AND ((RPL > DPL) or (CPL > DPL)))

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Test is implemented only for x86_64 as it's making use of
run_in_user(). Should it be reimplemented for _32 as well?

 x86/emulator64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index 7f55d38..c58441c 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -355,6 +355,21 @@ static void test_movabs(uint64_t *mem)
 	report(rcx == 0x9090909090909090, "64-bit mov imm2");
 }
 
+static void load_dpl0_seg(void)
+{
+	asm volatile(KVM_FEP "mov %0, %%fs" :: "r" (KERNEL_CS)); /* RPL=0 */
+}
+
+static void test_user_load_dpl0_seg(void)
+{
+	bool raised_vector;
+
+	run_in_user((usermode_func)load_dpl0_seg, GP_VECTOR, 0, 0, 0, 0,
+		    &raised_vector);
+
+	report(raised_vector, "Wanted #GP on CPL=3 DPL=0 segment load");
+}
+
 static void test_push16(uint64_t *mem)
 {
 	uint64_t rsp1, rsp2;
@@ -456,6 +471,7 @@ static void test_emulator_64(void *mem)
 	if (is_fep_available()) {
 		test_mmx_movq_mf(mem);
 		test_movabs(mem);
+		test_user_load_dpl0_seg();
 	}
 
 	test_push16(mem);
-- 
2.39.0

