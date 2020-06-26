Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FB020AEF1
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 11:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgFZJ0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 05:26:06 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:59908 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726556AbgFZJ0D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 05:26:03 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 26 Jun 2020 02:25:55 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 15053B216A;
        Fri, 26 Jun 2020 05:26:00 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 3/3] x86: realmode: fix lss test
Date:   Fri, 26 Jun 2020 02:23:33 -0700
Message-ID: <20200626092333.2830-4-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626092333.2830-1-namit@vmware.com>
References: <20200626092333.2830-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running lss with some random descriptor and then performing pop does not
work so well. Use mov instructions instead of push/pop pair.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/realmode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index 301b013..90ecd13 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1378,10 +1378,10 @@ static void test_lds_lss(void)
 		outregs.eax == (unsigned long)desc.address &&
 		outregs.ebx == desc.sel);
 
-	MK_INSN(lss, "pushl %ss\n\t"
+	MK_INSN(lss, "mov %ss, %dx\n\t"
 		     "lss (%ebx), %eax\n\t"
 		     "mov %ss, %ebx\n\t"
-		     "popl %ss\n\t");
+		     "mov %dx, %ss\n\t");
 	exec_in_big_real_mode(&insn_lss);
 	report("lss", R_AX | R_BX,
 		outregs.eax == (unsigned long)desc.address &&
-- 
2.20.1

