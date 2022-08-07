Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882C458BD96
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbiHGWHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237216AbiHGWF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:05:28 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1098AB845;
        Sun,  7 Aug 2022 15:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909786; x=1691445786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IRBrGdKRfquiGF7sDCfmGSS240++oz142fl2JeTijGI=;
  b=nBSV31RX//j3NvnT4egYXfLovLwitcZ7jtu+7kanpBsnn6faSCNdBFcX
   7x1mdccLgv3qVwcRYq90pC1CJXSwxN1TftW4d86+kuwrXmiuGXx8hPV1H
   AQsqgVMNTEL7YXKUDQT6dwGMDv/6wcttKOP/xCm1EOpl+jS8PAV5klN3r
   zKTjX33qcEdYnTbmjnylOC0Shw4OXlTaKAs8Ity4h1H8azGN8Jw36NHWO
   pFbKZRddTJb14Y5LWfD/hCnwBLZqrLNv28MRZmGSXSCif46k57xHdGOmI
   yuRB2GlpJIazFJwbCLabudZrmQT6h2u3/GmvqEWATwLWDm5DQajFJMZYQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240391"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240391"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:42 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682725"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:42 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 085/103] KVM: TDX: handle EXIT_REASON_OTHER_SMI
Date:   Sun,  7 Aug 2022 15:02:10 -0700
Message-Id: <18c868394d02c3676a440fc70e2fa4b2c4855b83.1659854791.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

If the control reaches EXIT_REASON_OTHER_SMI, #SMI is delivered and
handled right after returning from the TDX module to KVM nothing needs to
be done in KVM.  Continue TDX vcpu execution.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/vmx.h | 1 +
 arch/x86/kvm/vmx/tdx.c          | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index a5faf6d88f1b..b3a30ef3efdd 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -34,6 +34,7 @@
 #define EXIT_REASON_TRIPLE_FAULT        2
 #define EXIT_REASON_INIT_SIGNAL			3
 #define EXIT_REASON_SIPI_SIGNAL         4
+#define EXIT_REASON_OTHER_SMI           6
 
 #define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fc0895f1fe75..53dce2b601dc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1206,6 +1206,13 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
 
 	switch (exit_reason.basic) {
+	case EXIT_REASON_OTHER_SMI:
+		/*
+		 * If reach here, it's not a Machine Check System Management
+		 * Interrupt(MSMI).  #SMI is delivered and handled right after
+		 * SEAMRET, nothing needs to be done in KVM.
+		 */
+		return 1;
 	default:
 		break;
 	}
-- 
2.25.1

