Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5973A1F0099
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 21:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgFETy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 15:54:56 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:46810 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727868AbgFETyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 15:54:55 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7871D4C850;
        Fri,  5 Jun 2020 19:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1591386892; x=
        1593201293; bh=BT7V5OPoBcBnhfBrfhmq0i+EDq9gDtiAbV9QTbz/h8U=; b=R
        50Bb1VTZzycUjukTARC54JTmCSTL5oH8Q45PWrI2Wb/FSUmt8rEdMfs9D+5NW1b5
        SjiPkzgw7C9qu6XSItai0oxK7dtl1jgNkVwHFHjHybfjIsvDSP4TgPB564Wgg7dA
        qnZLxrXbUtNpIWtZf306zdWSdKOs26vrDTu/2XdKwA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xHMBA-P1y4mm; Fri,  5 Jun 2020 22:54:52 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0C0424B169;
        Fri,  5 Jun 2020 22:54:52 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 5 Jun
 2020 22:54:51 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Nadav Amit <namit@vmware.com>,
        Richard Henderson <rth@twiddle.net>
Subject: [kvm-unit-tests PATCH] x86: realmode: Relax smsw test
Date:   Fri, 5 Jun 2020 22:49:18 +0300
Message-ID: <20200605194915.37330-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
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

The test currently asserts a kind of undefined behaviour in SMSW per
Intel SDM:

  In non-64-bit modes, when the destination operand is a 32-bit register,
  the low-order 16 bits of register CR0 are copied into the low-order 16
  bits of the register and the high-order 16 bits are undefined.

TCG doesn't write high-order 16 bits and the test fails for it. Instead
of CR0.CD, set CR0.PE and check only if low-order bits match to avoid
ambiguity with the undefined behaviour.

Cc: Nadav Amit <namit@vmware.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 x86/realmode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

An alternative would be to change the undefined behaviour of TCG itself:
https://github.com/roolebo/qemu/commit/a5e5ee3a41c52031dfda3b1b903100bcb5639742

diff --git a/x86/realmode.c b/x86/realmode.c
index 3518224..700639a 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1714,7 +1714,7 @@ static void test_smsw(void)
 {
 	MK_INSN(smsw, "movl %cr0, %ebx\n\t"
 		      "movl %ebx, %ecx\n\t"
-		      "or $0x40000000, %ebx\n\t"
+		      "or $0x00000001, %ebx\n\t"
 		      "movl %ebx, %cr0\n\t"
 		      "smswl %eax\n\t"
 		      "movl %ecx, %cr0\n\t");
@@ -1722,7 +1722,9 @@ static void test_smsw(void)
 	init_inregs(&(struct regs){ .eax = 0x12345678 });
 
 	exec_in_big_real_mode(&insn_smsw);
-	report("smsw", R_AX | R_BX | R_CX, outregs.eax == outregs.ebx);
+	report("smsw", R_AX | R_BX | R_CX,
+	       (outregs.eax & 0xffff) == (outregs.ebx & 0xffff) &&
+	       (outregs.eax & 0x1));
 }
 
 static void test_xadd(void)
-- 
2.26.1

