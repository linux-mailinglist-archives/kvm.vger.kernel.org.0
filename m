Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1046DC45E
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjDJIlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 04:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDJIlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 04:41:06 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6844D40D9;
        Mon, 10 Apr 2023 01:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681116065; x=1712652065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4lCYxmSNxB+oTxZx5ZOjZmvc7OZS0xLkR1RLWDKH14M=;
  b=LLrqgmjWy2L3uZZoF3vDx4gp/YMNkJ+zQUB2bJGW8Ac1HQPSscDcoI+l
   Yxg0VENINCpcfLkgMu/vDY55Js+drF8EouG1HvWJoyLM87vF1kkQ5sJP3
   +WopWkulCshowSPSNgXTC3mEBLyT2ax1+mb4C3rKM04lyq7eZOF4sM9R4
   I1aKY90K7BiHu8X+ylZF6BXdaf05pUNgEq/JEVSjQVFXXaX5hzg7YE11z
   NTO5t5J56+aN8YYq6afl48P5uvZi17MophQql4iUh6GkWFc58rOUEGU5v
   NvPzk3HwgDc4zqIJjAUv1egup10dsChDgIvDcmVQ9pXjFF7tlR4M13I8I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="342077945"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342077945"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 01:41:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799436266"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="799436266"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2023 01:41:03 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v8 08/33] x86/objtool: teach objtool about ERETU and ERETS
Date:   Mon, 10 Apr 2023 01:14:13 -0700
Message-Id: <20230410081438.1750-9-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410081438.1750-1-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Update the objtool decoder to know about the ERETU and ERETS
instructions (type INSN_CONTEXT_SWITCH.)

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 tools/objtool/arch/x86/decode.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 9ef024fd648c..8e9c802f78ec 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -509,11 +509,20 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 
 		if (op2 == 0x01) {
 
-			if (modrm == 0xca)
-				insn->type = INSN_CLAC;
-			else if (modrm == 0xcb)
-				insn->type = INSN_STAC;
-
+			switch (insn_last_prefix_id(&ins)) {
+			case INAT_PFX_REPE:
+			case INAT_PFX_REPNE:
+				if (modrm == 0xca)
+					/* eretu/erets */
+					insn->type = INSN_CONTEXT_SWITCH;
+				break;
+			default:
+				if (modrm == 0xca)
+					insn->type = INSN_CLAC;
+				else if (modrm == 0xcb)
+					insn->type = INSN_STAC;
+				break;
+			}
 		} else if (op2 >= 0x80 && op2 <= 0x8f) {
 
 			insn->type = INSN_JUMP_CONDITIONAL;
-- 
2.34.1

