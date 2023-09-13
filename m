Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3FE79ED58
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjIMPkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjIMPkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE7A1BDA;
        Wed, 13 Sep 2023 08:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619592; x=1726155592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AEWudJDZ+NDRaTIFe/yzf4ZaPBnztbnXXDvtdbIDNGE=;
  b=WiEoHAyqSsBkDGyse4vvga40pj543fcyySqjTkum63wxwW8bPxBt42yP
   GPJq0guDfTJ8d7d5qj03uQhHR2HxLnmlqEp58WHzevENSJtx50JU+ZaRG
   nkV9pNFvgCSAHEVtJts8rx1KVjEGi7gZMfcU5C0Nd4mypkls1fEp1WNR1
   MI3w3bLxQsNBs+IyED7RKUUks6vNi+8FjRQvjkzsqFZ7ZrL0GeZgkaegS
   +HpGj7rqdX3rhLY7JyG55HOOLdgf0W7j2dd5+8bjoM6RlVVkWvX2Ukdna
   Q3yCKkJOxh5W9WaStD62svm2+o6F6Vz3cj2BDm27SnGYBsbqB63CscRoN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030160"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030160"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852081"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852081"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:49 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 04/16] KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
Date:   Wed, 13 Sep 2023 20:42:15 +0800
Message-Id: <20230913124227.12574-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an emulation flag X86EMUL_F_INVLPG, which is used to identify an
instruction that does TLB invalidation without true memory access.

Only invlpg & invlpga implemented in emulator belong to this kind.
invlpga doesn't need additional information for emulation. Just pass
the flag to em_invlpg().

Linear Address Masking (LAM) and Linear Address Space Separation (LASS)
don't apply to addresses that are inputs to TLB invalidation. The flag
will be consumed to support LAM/LASS virtualization.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/emulate.c     | 4 +++-
 arch/x86/kvm/kvm_emulate.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 274d6e7aa0c1..f54e1a2cafa9 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3441,8 +3441,10 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	ulong linear;
+	unsigned int max_size;
 
-	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
+	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, ctxt->mode,
+			 &linear, X86EMUL_F_INVLPG);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->ops->invlpg(ctxt, linear);
 	/* Disable writeback. */
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 5f9869018332..70f329a685fe 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -93,6 +93,7 @@ struct x86_instruction_info {
 #define X86EMUL_F_FETCH			BIT(1)
 #define X86EMUL_F_BRANCH		BIT(2)
 #define X86EMUL_F_IMPLICIT		BIT(3)
+#define X86EMUL_F_INVLPG		BIT(4)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
-- 
2.25.1

