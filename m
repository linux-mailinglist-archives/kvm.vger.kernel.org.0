Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56AF6AD579
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjCGDHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjCGDHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:07:08 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BF88617C;
        Mon,  6 Mar 2023 19:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158344; x=1709694344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5IBl0XY5xGj0Ul5jZJTZVlHtGnpVju3gJ8HZ07Stwk0=;
  b=XqsEtj/jBx1QF0bytxBb5r/ognPBKR0r5PyFLBNfFynHexbHIhYuZ1wS
   gY1Lr9W2eezIu8jVugMOw1A+N4axP8bHpfP8seG2cSp9uMMiNnhLthg36
   E9xpUvJW88S/6wbVvQ+hZARdL7Zf8ZvcCuWUETZosu3sAyqZWiftzT1QC
   3TSPaVuXEISWQNbUJyPzpCRtwmkLS91HG350zm96m9+SO9188i+M77D+f
   Elr3YCaP/dguN8uhTh1XQAUihulGq2a2CA87wqgRgHKa9Rt5XBIIi466e
   6Pk5hfx+JktPNZ1UmEKjk+rk0rUhCN2UohOitFuwTT3RkLdwlnDMNX5BP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072594"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072594"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409932"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409932"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:21 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 29/34] x86/ia32: do not modify the DPL bits for a null selector
Date:   Mon,  6 Mar 2023 18:39:41 -0800
Message-Id: <20230307023946.14516-30-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307023946.14516-1-xin3.li@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a null selector is to be loaded into a segment register,
reload_segments() sets its DPL bits to 3. Later when the IRET
instruction loads it, it zeros the segment register. The two
operations offset each other to actually effect a nop.

Unlike IRET, ERETU does not make any of DS, ES, FS, or GS null
if it is found to have DPL < 3. It is expected that a FRED-enabled
operating system will return to ring 3 (in compatibility mode)
only when those segments all have DPL = 3.

Thus when FRED is enabled, we end up with having 3 in a segment
register even when it is initially set to 0.

Fix it by not modifying the DPL bits for a null selector.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/signal_32.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 9027fc088f97..7796cf84fca2 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -36,22 +36,27 @@
 #ifdef CONFIG_IA32_EMULATION
 #include <asm/ia32_unistd.h>
 
+static inline u16 usrseg(u16 sel)
+{
+	return sel <= 3 ? sel : sel | 3;
+}
+
 static inline void reload_segments(struct sigcontext_32 *sc)
 {
 	unsigned int cur;
 
 	savesegment(gs, cur);
-	if ((sc->gs | 0x03) != cur)
-		load_gs_index(sc->gs | 0x03);
+	if (usrseg(sc->gs) != cur)
+		load_gs_index(usrseg(sc->gs));
 	savesegment(fs, cur);
-	if ((sc->fs | 0x03) != cur)
-		loadsegment(fs, sc->fs | 0x03);
+	if (usrseg(sc->fs) != cur)
+		loadsegment(fs, usrseg(sc->fs));
 	savesegment(ds, cur);
-	if ((sc->ds | 0x03) != cur)
-		loadsegment(ds, sc->ds | 0x03);
+	if (usrseg(sc->ds) != cur)
+		loadsegment(ds, usrseg(sc->ds));
 	savesegment(es, cur);
-	if ((sc->es | 0x03) != cur)
-		loadsegment(es, sc->es | 0x03);
+	if (usrseg(sc->es) != cur)
+		loadsegment(es, usrseg(sc->es));
 }
 
 #define sigset32_t			compat_sigset_t
-- 
2.34.1

