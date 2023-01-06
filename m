Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F288865FD97
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjAFJVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjAFJUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2EF63188;
        Fri,  6 Jan 2023 01:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996817; x=1704532817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o7a+0760MneBwxPKzFiaj9Nq7KFWmVxmzGnbcDhAUFY=;
  b=KYB4DbBec/JF8CbKctjZjdQBK0rCOojU2N+ABq4oosJCLUGYJ9ZWtjQ8
   6judQxcKrRohuMnfjRTYhbFEQxCWJT+4ep3JE58AlURBXNGfhvzi9wy67
   ivfoXR1JQuRI/Z12OaddB+6Y5GexTzGN/feEMxEqzJnAhwMOfWyqpl0HY
   BTM5pA2KN1WqUR3vHEtqN6y280Cm9NeiOtoHxMsupNCapcrcTHC5g7X4T
   UFKw/z6TmGCynXjMw2mswZiEwy8MXpps5aHjF7EH9oApQuXU+x17aztfb
   HEkfFXi4rwxmOGDAMAvk75wpAN1O1TBLldTIwjAy+9UEmVG2q6nFZTm/J
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511439"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511439"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139367"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139367"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:12 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 08/32] x86/objtool: teach objtool about ERETU and ERETS
Date:   Fri,  6 Jan 2023 00:55:53 -0800
Message-Id: <20230106085617.17248-9-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Update the objtool decoder to know about the ERETU and ERETS
instructions (type INSN_CONTEXT_SWITCH.)

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 tools/objtool/arch/x86/decode.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 1c253b4b7ce0..fbfe0a39599a 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -480,12 +480,22 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
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

