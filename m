Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2993758C07
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 05:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjGSDZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 23:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjGSDZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 23:25:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814611BDD;
        Tue, 18 Jul 2023 20:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689737152; x=1721273152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=qeP1TX20L6bDrbjHG7LXoPTITHr/t0Ikc6UPLombWJs=;
  b=JlWoO4ocGildF4EUkShycmzmJNnVEAXXd3H5blx8h/ZTTzz+f0FbXwCC
   RPGVKZum1lBepVidFBKtS1uCyMAWCmkVD5Nlt6SQYaBpAJakDuZbZsvz2
   dxNJ/EVHWMFbktO3kytItoSjQhfWIX57RQtk1vJOZLFzegCwZoMir3L8w
   o4Y74KqRzs5WSWLnQnoh2cGMja5Y+MrgH7ca46X/OYH9f51CN5Bd9PBPd
   axxxSgXH5Jyz1d12d2HdTP8D8dcIF1JcX6e0OCvvKf0PtBTO7LSRuKBBX
   t8GDFRtObS/XguQQPNwu6o504fIXCjloKeo4qMAcotEwjZWzPxsz69JC3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="346665819"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="346665819"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 20:25:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="813980269"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="813980269"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 20:25:49 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v2 3/8] KVM: x86: Add an emulation flag for implicit system access
Date:   Wed, 19 Jul 2023 10:45:53 +0800
Message-Id: <20230719024558.8539-4-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230719024558.8539-1-guang.zeng@intel.com>
References: <20230719024558.8539-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Binbin Wu <binbin.wu@linux.intel.com>

Add an emulation flag X86EMUL_F_IMPLICIT to identify the behavior of
implicit system access in instruction emulation.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/kvm_emulate.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 9fc7d34a4ac1..c0e48f4fa7c4 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -92,6 +92,7 @@ struct x86_instruction_info {
 #define X86EMUL_F_WRITE			BIT(0)
 #define X86EMUL_F_FETCH			BIT(1)
 #define X86EMUL_F_BRANCH		BIT(2)
+#define X86EMUL_F_IMPLICIT		BIT(3)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
-- 
2.27.0

