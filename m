Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D6879ED57
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjIMPjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjIMPjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:39:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21260E6D;
        Wed, 13 Sep 2023 08:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619587; x=1726155587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AL9NLmjLAmLl2N/LQxSbngv0yfUQsc3dB+GYH+2Agn0=;
  b=Tp0Zda9arpcFQ2uhxcFTIb+9qNrVXXxt1yVltoHIxq5Fj9Q8RDTyTCIt
   SHujVft1Lwv50J+3YYnPXOialaDiCvPu66Q5QQdSIPHSSvlH6/7MATI/9
   NRK+JltTsT2F38CxUiyTG4ifgi9CAaBRHsZi6HWt4FUnPLBkOL2U66fxz
   2BZaGFp/jCzlX5/nhIHxJA6g2g6a6Ex536rjdqvHGs7+GZC7lf0sn2iqh
   4G84FG22+Qlrkbv33W0KhLnmzaKWcps/lRkKNtC1C7e1dHYJvdADE5iyH
   nJdcxzbEHRDje7JQZX3yCVl2B2gDMQMi3Gadvlc1KbyKyWowaBS6GuYSo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030126"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030126"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852012"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852012"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:43 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 02/16] KVM: x86: Use a new flag for branch targets
Date:   Wed, 13 Sep 2023 20:42:13 +0800
Message-Id: <20230913124227.12574-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F_FETCH in assign_eip()
to distinguish instruction fetch and branch target computation for features
that handle differently on them, e.g. Linear Address Space Separation (LASS).

As of this patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH are identical as far
as KVM is concerned.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/emulate.c     | 5 +++--
 arch/x86/kvm/kvm_emulate.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 87ee1802166a..274d6e7aa0c1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -721,7 +721,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 		    (flags & X86EMUL_F_WRITE))
 			goto bad;
 		/* unreadable code segment */
-		if (!(flags & X86EMUL_F_FETCH) && (desc.type & 8) && !(desc.type & 2))
+		if (!(flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH)) &&
+		    (desc.type & 8) && !(desc.type & 2))
 			goto bad;
 		lim = desc_limit_scaled(&desc);
 		if (!(desc.type & 8) && (desc.type & 4)) {
@@ -772,7 +773,7 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
 	rc = __linearize(ctxt, addr, &max_size, 1, ctxt->mode, &linear,
-			 X86EMUL_F_FETCH);
+			 X86EMUL_F_BRANCH);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index e24c8ac7b930..e1fd83908334 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -91,6 +91,7 @@ struct x86_instruction_info {
 /* x86-specific emulation flags */
 #define X86EMUL_F_WRITE			BIT(0)
 #define X86EMUL_F_FETCH			BIT(1)
+#define X86EMUL_F_BRANCH		BIT(2)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
-- 
2.25.1

