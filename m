Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CEB7527C8
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 17:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjGMPyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 11:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjGMPyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 11:54:51 -0400
X-Greylist: delayed 6147 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Jul 2023 08:54:49 PDT
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D89D26AE
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 08:54:49 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qJx3L-000wFe-Gy; Thu, 13 Jul 2023 16:12:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject
        :Cc:To:From; bh=srfvtAuZTlZfeDu1t/9mVfKjQ9ungTgfaR0/nPFqtM4=; b=XMOqjpwADu7xn
        rTS0vksQZJ3aQlMljzZ4WUnqf9IP/TrtJwDVpqmqXkZK5bY6g4QFPVLxlSvrqAb12yuH2X284XmOX
        uVKs64ClwaJemicqBm9eOD8DAcgZswClYFwOa/p5+oBHSz4ipWrakmqc5+jcPYEvb1FwbfHvIZ9qg
        cQmlSPNgHqy0VeFE2T3pBFs526edFUDTc+Eye9zRl8wXiVvWPvmdFbI3/ZNccJhZgP+8pDUnFwhRW
        6F2GgIYoSxX9KlDzQMvJSkBb41h1GhXlt4qu/0FpGc8gCyHAfbbcUlX/VEVeHQ8B6F9NLTI5iIaKo
        OPBBDe7LIv7McBw5DM4vw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qJx3K-0008I0-OZ; Thu, 13 Jul 2023 16:12:19 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qJx3C-0001y6-Up; Thu, 13 Jul 2023 16:12:11 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [kvm-unit-tests RFC PATCH] x86/emulator: Test indirect CALL (gpa_available)
Date:   Thu, 13 Jul 2023 16:08:01 +0200
Message-ID: <20230713141136.1179342-1-mhal@rbox.co>
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

It seems em_call_near_abs() is missing a TwoMemOp flag.

If there's a match between ~PAGE_MASK (lower 12) bits of
	- address of memory storing CALL's target, and
	- stack pointer at the time of pushing the return address,
emulator, while pushing the return address, will skip GVA->GPA walk and use GPA
provided by nPF. See arch/x86/kvm/x86.c:emulator_read_write_onepage().

Problem is that nPF came from reading CALL's SrcMem (pointer to CALL's target),
so the "push" will overwrite CALL's SrcMem, not touching the stack at all. Then
RET comes along and attempts to pop the return address, which was never written.

I guess it's hight time I admit I have no idea if such indirect CALL + nPF setup
was meant to be supported and/or this has any real world consequences :) That
said, here's a KUT testcase where the bamboozled emulator makes RET twist the
execution flow.

Please let me know if this is worth submitting a TwoMemOp patch. em_call_far()
appears to have the same "problem".

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 x86/emulator.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index ad94374..425f838 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -787,6 +787,49 @@ static void test_mov_pop_ss_code_db(void)
 	handle_exception(DB_VECTOR, old_db_handler);
 }
 
+static void test_indirect_call(void)
+{
+	long page1, page2, old_sp, sp, dest, tmp;
+	int status;
+
+	page1 = (long)vmap(IORAM_BASE_PHYS, PAGE_SIZE * 2);
+	page2 = page1 + PAGE_SIZE;
+
+	sp = page1 + PAGE_SIZE;
+	dest = page2 + PAGE_SIZE - sizeof(dest);
+
+	assert(((sp - sizeof(sp)) & ~PAGE_MASK) == (dest & ~PAGE_MASK));
+
+	asm volatile("mov %%"R "sp, %[old_sp]\n\t"
+		     "mov %[sp], %%"R "sp\n\t"
+
+		     "lea Lret_diverted, %0\n\t"
+		     "mov %0, -"S"(%%"R "sp)\n\t"
+
+		     "lea Lcall_target, %0\n\t"
+		     "mov %0, (%[dest])\n\t"
+
+		     "mov $-1, %[status]\n\t"
+		     "call *(%[dest])\n\t"
+		     "jmp Lout\n\t"
+
+		     "Lcall_target:\n\t"
+		     "endbr" xstr(BITS_PER_LONG)"\n\t"
+		     "mov $0, %[status]\n\t"
+		     "ret\n\t"
+
+		     "Lret_diverted:\n\t"
+		     "mov $1, %[status]\n\t"
+
+		     "Lout:\n\t"
+		     "mov %[old_sp], %%"R "sp\n\t"
+		     : "=&r"(tmp), [old_sp]"=&r"(old_sp), [status]"=&r"(status)
+		     : [sp]"r"(sp), [dest]"r"(dest)
+		     : "memory");
+
+	report(!status, "indirect call (gpa_val), status = %d", status);
+}
+
 int main(void)
 {
 	void *mem;
@@ -834,6 +877,7 @@ int main(void)
 	test_string_io_mmio(mem);
 	test_illegal_movbe();
 	test_mov_pop_ss_code_db();
+	test_indirect_call();
 
 #ifdef __x86_64__
 	test_emulator_64(mem);
-- 
2.41.0

