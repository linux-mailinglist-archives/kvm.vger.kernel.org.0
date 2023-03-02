Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387AD6A7AE9
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjCBFvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjCBFuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:50:55 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5294BEA8;
        Wed,  1 Mar 2023 21:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677736253; x=1709272253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LlMW1NlXfuZMtqkxnDoQy5w38JDnEhwHgVFWrTwAnVg=;
  b=EM/UM2+a29EBWhNVAc5Z/K/A3HDeoz0BeNaunYAwyxrD39V9XbopnIYK
   iY+H1xqARuIx6Yoqj2lH7mXBLJ7rBrlbJF0FXsyJwVDSYHDv47BLrREbl
   Y8yHHds74I+yywwDkoLIOMKy3/AAze+9hopgXAevIS6f045EQYQ56PT3E
   H4ESsfNLNvGu9moPpj/tIzy+DVm1Yx69U8eChk2WzRHbcsuvzJs4GoCCa
   1SvPjNLV0P0i4wtA8WdcuU1RTScnLRgxoLmRAfsb3j3OjKanvnQwD31KS
   fnprupcRwHgjCNXA6CbzzHqzPWgWpZ0vCzsxB2iCBIbmVd8f13eb7B5BC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420887105"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="420887105"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 21:50:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920530893"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="920530893"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 21:50:47 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v4 08/34] x86/objtool: teach objtool about ERETU and ERETS
Date:   Wed,  1 Mar 2023 21:24:45 -0800
Message-Id: <20230302052511.1918-9-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230302052511.1918-1-xin3.li@intel.com>
References: <20230302052511.1918-1-xin3.li@intel.com>
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
Tested-by: Shan Kang <shan.kang@intel.com>
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

