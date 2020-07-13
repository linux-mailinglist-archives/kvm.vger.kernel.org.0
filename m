Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED721CE5B
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 06:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgGMElq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 00:41:46 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:34358 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgGMElq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jul 2020 00:41:46 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Sun, 12 Jul 2020 21:41:45 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 86F26B1F07;
        Mon, 13 Jul 2020 00:41:45 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Date:   Sun, 12 Jul 2020 21:39:08 -0700
Message-ID: <20200713043908.39605-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The low CR3 bits are reserved but not MBZ according to tha APM. The
tests should therefore not check that they cause failed VM-entry. Tests
on bare-metal show they do not.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/svm.h       |  4 +---
 x86/svm_tests.c | 26 +-------------------------
 2 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index f8e7429..15e0f18 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -325,9 +325,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
 #define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
-#define	SVM_CR3_LEGACY_RESERVED_MASK		0xfe7U
-#define	SVM_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
-#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
+#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000000U
 #define	SVM_CR4_LEGACY_RESERVED_MASK		0xff88f000U
 #define	SVM_CR4_RESERVED_MASK			0xffffffffff88f000U
 #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 3b0d019..1908c7c 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2007,38 +2007,14 @@ static void test_cr3(void)
 {
 	/*
 	 * CR3 MBZ bits based on different modes:
-	 *   [2:0]		    - legacy PAE
-	 *   [2:0], [11:5]	    - legacy non-PAE
-	 *   [2:0], [11:5], [63:52] - long mode
+	 *   [63:52] - long mode
 	 */
 	u64 cr3_saved = vmcb->save.cr3;
-	u64 cr4_saved = vmcb->save.cr4;
-	u64 cr4 = cr4_saved;
-	u64 efer_saved = vmcb->save.efer;
-	u64 efer = efer_saved;
 
-	efer &= ~EFER_LME;
-	vmcb->save.efer = efer;
-	cr4 |= X86_CR4_PAE;
-	vmcb->save.cr4 = cr4;
-	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
-	    SVM_CR3_LEGACY_PAE_RESERVED_MASK);
-
-	cr4 = cr4_saved & ~X86_CR4_PAE;
-	vmcb->save.cr4 = cr4;
-	SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
-	    SVM_CR3_LEGACY_RESERVED_MASK);
-
-	cr4 |= X86_CR4_PAE;
-	vmcb->save.cr4 = cr4;
-	efer |= EFER_LME;
-	vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
 	    SVM_CR3_LONG_RESERVED_MASK);
 
-	vmcb->save.cr4 = cr4_saved;
 	vmcb->save.cr3 = cr3_saved;
-	vmcb->save.efer = efer_saved;
 }
 
 static void test_cr4(void)
-- 
2.25.1

