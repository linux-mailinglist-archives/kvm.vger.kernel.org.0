Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C9E65FDB7
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbjAFJWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjAFJU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:27 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B30263188;
        Fri,  6 Jan 2023 01:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996826; x=1704532826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yvHd27MPzoRPhJLMrlSGr6kQm8k0tLId/1KA4wMkuYk=;
  b=l18YeScoNqjTXbO0bMfuVFF/sV8dH7FDdnh0q7p6kgH2Luuh4V7d85vw
   DTNogyKGI9KbmJRORfR7xf/LDaRdOnvoYH1Z947ec72TGIdXy9jGcriUo
   6MdU7Iq4FTpgHNdRvfY0AL722d77Or0oA0ecJ1IsJrhvO6TgxaDbp00AJ
   rfwIhDIfsN/v/jy0jsOnAuRpWVamAhP5jyZ7rc9wab3Wcqf+w+uGDQ9EA
   M78LFdKjV5yx09qjIOrqpeaO7bIu/igTsvhH+4HDlgjnjRA6KOT/OcpRq
   9sOTwuCSSicITz6CdO/PIXlsca6RDrDwGEb4fZgNJEPAnxprPgiY1d5w/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511640"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511640"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139460"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139460"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:18 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 29/32] x86/ia32: do not modify the DPL bits for a null selector
Date:   Fri,  6 Jan 2023 00:56:14 -0800
Message-Id: <20230106085617.17248-30-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/ia32/ia32_signal.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 14c739303099..31f5bbb59441 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -36,22 +36,27 @@
 #include <asm/smap.h>
 #include <asm/gsseg.h>
 
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
 
 /*
-- 
2.34.1

