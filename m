Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896611F19B1
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 15:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgFHNM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 09:12:58 -0400
Received: from 10.mo178.mail-out.ovh.net ([46.105.76.150]:32931 "EHLO
        10.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728938AbgFHNM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 09:12:58 -0400
X-Greylist: delayed 2399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2020 09:12:57 EDT
Received: from player699.ha.ovh.net (unknown [10.108.42.184])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id 0137DA5553
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 13:57:25 +0200 (CEST)
Received: from kaod.org (82-64-250-170.subs.proxad.net [82.64.250.170])
        (Authenticated sender: clg@kaod.org)
        by player699.ha.ovh.net (Postfix) with ESMTPSA id E1AEA131F7A48;
        Mon,  8 Jun 2020 11:57:18 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-100R0039a28aace-0423-48ac-9d27-88d758f13fba,B6B0473EF73D0859AD85419D5DB97E88249038E4) smtp.auth=clg@kaod.org
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH] KVM: PPC: Book3S HV: increase KVMPPC_NR_LPIDS on POWER8 and POWER9
Date:   Mon,  8 Jun 2020 13:57:14 +0200
Message-Id: <20200608115714.1139735-1-clg@kaod.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2856689540546005937
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudehuddggeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkffogggtgfesthekredtredtjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeikeekleffteegleevveejheetuddviedvleejvedvueevtdfgieduieeviedugfenucfkpheptddrtddrtddrtddpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheileelrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

POWER8 and POWER9 have 12-bit LPIDs. Change LPID_RSVD to support up to
(4096 - 2) guests on these processors. POWER7 is kept the same with a
limitation of (1024 - 2), but it might be time to drop KVM support for
POWER7.

Tested with 2048 guests * 4 vCPUs on a witherspoon system with 512G
RAM and a bit of swap.

Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/include/asm/reg.h      | 3 ++-
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 88e6c78100d9..b70bbfb0ea3c 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -473,7 +473,8 @@
 #ifndef SPRN_LPID
 #define SPRN_LPID	0x13F	/* Logical Partition Identifier */
 #endif
-#define   LPID_RSVD	0x3ff		/* Reserved LPID for partn switching */
+#define   LPID_RSVD_POWER7	0x3ff	/* Reserved LPID for partn switching */
+#define   LPID_RSVD		0xfff	/* Reserved LPID for partn switching */
 #define	SPRN_HMER	0x150	/* Hypervisor maintenance exception reg */
 #define   HMER_DEBUG_TRIG	(1ul << (63 - 17)) /* Debug trigger */
 #define	SPRN_HMEER	0x151	/* Hyp maintenance exception enable reg */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 18aed9775a3c..23035ab2ec50 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -260,11 +260,15 @@ int kvmppc_mmu_hv_init(void)
 	if (!mmu_has_feature(MMU_FTR_LOCKLESS_TLBIE))
 		return -EINVAL;
 
-	/* POWER7 has 10-bit LPIDs (12-bit in POWER8) */
 	host_lpid = 0;
 	if (cpu_has_feature(CPU_FTR_HVMODE))
 		host_lpid = mfspr(SPRN_LPID);
-	rsvd_lpid = LPID_RSVD;
+
+	/* POWER8 and above have 12-bit LPIDs (10-bit in POWER7) */
+	if (cpu_has_feature(CPU_FTR_ARCH_207S))
+		rsvd_lpid = LPID_RSVD;
+	else
+		rsvd_lpid = LPID_RSVD_POWER7;
 
 	kvmppc_init_lpid(rsvd_lpid + 1);
 
-- 
2.25.4

