Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56D06A1720
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjBXH2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjBXH2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:28:00 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E28CFA;
        Thu, 23 Feb 2023 23:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223676; x=1708759676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LPt5KI78RHrT+nU0CTWy5sIjKcY7qI5WuuF75Mzk9KE=;
  b=FOyHO+P+PgPhBp3/aZD05bBqV/hH+KXihA3COHmVpGY9xw9ObdVydZ2O
   10f6gA2Y4+mDdBUgXWJzpzfkLSNupnveg7fQLsZLCjSzyLLO6WyLT7se2
   5syE29CqD2wFXT3F6vrggGC9Hz1GUFczSpD+wr2VkHkwneHfAHH4M4uuz
   +vsL7YCT2BkiWl2pTP4tdRMP8zFt9hf2+JAad6rEyvI7IPXNPd8+s7uWO
   C5TJSnW/581PizhovqFoNldH0VPzZ+9/abYD7vTapfEVE07hmMTOFNXic
   85S/ET/L85s+GPk0rvXjQeEiMkWxbkZM5aDwf5ScmBnigsVTqmEs6TkdG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334835980"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334835980"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639210"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639210"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:21 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 08/32] x86/objtool: teach objtool about ERETU and ERETS
Date:   Thu, 23 Feb 2023 23:01:21 -0800
Message-Id: <20230224070145.3572-9-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Update the objtool decoder to know about the ERETU and ERETS
instructions (type INSN_CONTEXT_SWITCH.)

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 tools/objtool/arch/x86/decode.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index e7b030f7e2a5..735c909540b5 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -509,12 +509,22 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 	case 0x0f:
 
 		if (op2 == 0x01) {
-
-			if (modrm == 0xca)
-				*type = INSN_CLAC;
-			else if (modrm == 0xcb)
-				*type = INSN_STAC;
-
+			switch (insn_last_prefix_id(&insn)) {
+			case INAT_PFX_REPE:
+			case INAT_PFX_REPNE:
+				if (modrm == 0xca) {
+					/* eretu/erets */
+					*type = INSN_CONTEXT_SWITCH;
+				}
+				break;
+			default:
+				if (modrm == 0xca) {
+					*type = INSN_CLAC;
+				} else if (modrm == 0xcb) {
+					*type = INSN_STAC;
+				}
+				break;
+			}
 		} else if (op2 >= 0x80 && op2 <= 0x8f) {
 
 			*type = INSN_JUMP_CONDITIONAL;
-- 
2.34.1

