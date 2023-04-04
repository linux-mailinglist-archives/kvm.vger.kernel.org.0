Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B658F6D5E63
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbjDDK4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbjDDKzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:55:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BB51703;
        Tue,  4 Apr 2023 03:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680605644; x=1712141644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5IBl0XY5xGj0Ul5jZJTZVlHtGnpVju3gJ8HZ07Stwk0=;
  b=J/+w+j+z1I6x9F0G8sbVebnnhzKgSVb3rUk0NVfKbCS9FPPm6mije3qV
   dIotGJPltpJtVdIGC5g9Gyd2EYd3rTSfGuRGnj0ExaY/bvOc4Uj6Frykd
   YwWLq941zVmc06IIRo942UM5YtOCP+s2yIPM/R4/vrzJg2s6ac1/ku8rm
   yvJBZVODs89ps5xguAojYikCTpG6Nd2s62QuhGdYIS0fOUeBVDDFQup5u
   pFjK3qA1GvwqrrbSmXu6Cw8y4CphF/c2klAIslWpB73qkLozgNM3LYxVS
   eUrN0cpsmW6LnvY+LiZLtF1jtlMx3NqB9bJroN+cFtI2wxW8aNXJRhT3Y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330734210"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="330734210"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:53:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775597862"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="775597862"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 03:53:06 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v7 28/33] x86/ia32: do not modify the DPL bits for a null selector
Date:   Tue,  4 Apr 2023 03:27:11 -0700
Message-Id: <20230404102716.1795-29-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404102716.1795-1-xin3.li@intel.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

