Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0906A1750
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjBXH3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjBXH3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:29:32 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39B663DE3;
        Thu, 23 Feb 2023 23:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223710; x=1708759710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nh0EZ36XDc6eXxI1es5e8QKbI0iZ09qaD62YA+DOlsU=;
  b=fIIhs/sJTGOm3IydHWcV+Q2yljXToDPegOamvuue7xCo98EU3zbZalrd
   GhLE7fKEF2IWU9hiuC0IdQVzQRkXkE4eakZwm9YGXPeVnMC7o6MXi8LqA
   L0MkKSQESa3PJ3Gq4SSE5qbTE1tX6faEJHJINyR3xUK0Zvl7OtIZJ+wHZ
   QZDSITtplqpErifp1kqcxg60WYTiMS6ZwQk95T5iDFNTkYXmHklzJrCh1
   8v8iQ7SH89sFAxdzYWsCVXfNiqY9j3dZWBMl25CWujDwcLEDiCUA64oXx
   DnrZQ4Mb66aWk0SUcVxca9qixj4HitW5UnDTH8ly5TY1CzbR9Ae8pCSny
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334836169"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334836169"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639281"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639281"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:26 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 29/32] x86/ia32: do not modify the DPL bits for a null selector
Date:   Thu, 23 Feb 2023 23:01:42 -0800
Message-Id: <20230224070145.3572-30-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224070145.3572-1-xin3.li@intel.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

