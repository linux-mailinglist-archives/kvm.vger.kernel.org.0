Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0053A2ADDDA
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 19:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgKJSJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 13:09:59 -0500
Received: from foss.arm.com ([217.140.110.172]:59528 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730705AbgKJSJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 13:09:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98F721063;
        Tue, 10 Nov 2020 10:09:58 -0800 (PST)
Received: from camtx2.cambridge.arm.com (camtx2.cambridge.arm.com [10.1.7.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 993E83F7BB;
        Tue, 10 Nov 2020 10:09:57 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/2] arm: Add support for the DEVICE_nGRE and NORMAL_WT memory types
Date:   Tue, 10 Nov 2020 18:09:24 +0000
Message-Id: <20201110180924.95106-3-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201110180924.95106-1-nikos.nikoleris@arm.com>
References: <20201110180924.95106-1-nikos.nikoleris@arm.com>
X-ARM-No-Footer: FoSSMail
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/pgtable-hwdef.h | 2 ++
 arm/cstart64.S                | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index c31bc11..48a1d1a 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -153,5 +153,7 @@
 #define MT_DEVICE_GRE		2
 #define MT_NORMAL_NC		3	/* writecombine */
 #define MT_NORMAL		4
+#define MT_NORMAL_WT		5
+#define MT_DEVICE_nGRE		6
 
 #endif /* _ASMARM64_PGTABLE_HWDEF_H_ */
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 6610779..0428014 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -154,6 +154,8 @@ halt:
  *   DEVICE_GRE         010     00001100
  *   NORMAL_NC          011     01000100
  *   NORMAL             100     11111111
+ *   NORMAL_WT          101     10111011
+ *   DEVICE_nGRE        110     00001000
  */
 #define MAIR(attr, mt) ((attr) << ((mt) * 8))
 
@@ -184,7 +186,9 @@ asm_mmu_enable:
 		     MAIR(0x04, MT_DEVICE_nGnRE) |	\
 		     MAIR(0x0c, MT_DEVICE_GRE) |	\
 		     MAIR(0x44, MT_NORMAL_NC) |		\
-		     MAIR(0xff, MT_NORMAL)
+		     MAIR(0xff, MT_NORMAL) |	        \
+		     MAIR(0xbb, MT_NORMAL_WT) |         \
+		     MAIR(0x08, MT_DEVICE_nGRE)
 	msr	mair_el1, x1
 
 	/* TTBR0 */
-- 
2.17.1

