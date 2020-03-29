Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE093196B92
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 09:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgC2HLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 03:11:41 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:38724 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbgC2HLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 03:11:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C9FCC412CB;
        Sun, 29 Mar 2020 07:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1585465897; x=
        1587280298; bh=2cSHbNB51jSlGHATfwhD/NrmlqCB0ieKHzp9nS9g3JE=; b=U
        2FLUuXbaNBZIBg18Jxi/hO1aZslgzvjGtfpZRF8sVGcWDl1O1cn8eltQxXm7gzNa
        PstaM+oWHMnGMKsXixp+nJdmQ8jmF+6iF7o4uDbOJOyvFqmw1csmN1hxV+y1YZ7/
        C0QwbsgUAJxJxYLrWN/8x+ImJ/pM1hD0y96md7zYWI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wGDyf2UlRISQ; Sun, 29 Mar 2020 10:11:37 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id ACE854127D;
        Sun, 29 Mar 2020 10:11:37 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sun, 29
 Mar 2020 10:11:38 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH] x86: realmode: Test interrupt delivery after STI
Date:   Sun, 29 Mar 2020 10:11:25 +0300
Message-ID: <20200329071125.79253-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If interrupts are disabled, STI is inhibiting interrupts for the
instruction following it. If STI is followed by HLT, the CPU is going to
handle all pending or new interrupts as soon as HLT is executed.

Test if emulator properly clears inhibition state and allows the
scenario outlined above.

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 x86/realmode.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/x86/realmode.c b/x86/realmode.c
index 31f84d0..3518224 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -814,6 +814,26 @@ static void test_int(void)
 	report("int 1", 0, 1);
 }
 
+static void test_sti_inhibit(void)
+{
+	init_inregs(NULL);
+
+	*(u32 *)(0x73 * 4) = 0x1000; /* Store IRQ 11 handler in the IDT */
+	*(u8 *)(0x1000) = 0xcf; /* 0x1000 contains an IRET instruction */
+
+	MK_INSN(sti_inhibit, "cli\n\t"
+			     "movw $0x200b, %dx\n\t"
+			     "movl $1, %eax\n\t"
+			     "outl %eax, %dx\n\t" /* Set IRQ11 */
+			     "movl $0, %eax\n\t"
+			     "outl %eax, %dx\n\t" /* Clear IRQ11 */
+			     "sti\n\t"
+			     "hlt\n\t");
+	exec_in_big_real_mode(&insn_sti_inhibit);
+
+	report("sti inhibit", ~0, 1);
+}
+
 static void test_imul(void)
 {
 	MK_INSN(imul8_1, "mov $2, %al\n\t"
@@ -1739,6 +1759,7 @@ void realmode_start(void)
 	test_xchg();
 	test_iret();
 	test_int();
+	test_sti_inhibit();
 	test_imul();
 	test_mul();
 	test_div();
-- 
2.24.1

