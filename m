Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB856127D1
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJ3GYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJ3GYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C92CD;
        Sat, 29 Oct 2022 23:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111047; x=1698647047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WrHckUqFHfiof4poG5sF1RlRME0x5PTeFyG15y9QQLI=;
  b=JuwHeMaClDFiQPeO/nYmkLcD9YjHSiGqJkjMrMZD3rv8oFmtjQG2l0SC
   SBW1gik5ze1EMVndryYU2JgOevlTZ1yyJE50uxrRBOUozTyb3x+aLlWhe
   3RCoXOtjj3RiOZ5Vd3QJ166sDpBxrkuZr58PVfT/jbgrE8vsfgxVsZwAq
   fPH4mt5fS/meqWjlMq7zrPwPMQ/+J2rzW7Ozcsgcr56pe9ArL/hw2pCdU
   eE7RmV3G8f6sWDKf9qiDgg503OaTIJP79Kc5xn2fSc+OMR211tUpPp8Hq
   TW+rYWnkyvgtiTHy5+q97fzSlPLIyuTJUEu5XKpYDldCOjrfeeXC9YZzR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037140"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037140"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392928"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392928"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:01 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 028/108] KVM: x86/mmu: introduce config for PRIVATE KVM MMU
Date:   Sat, 29 Oct 2022 23:22:29 -0700
Message-Id: <f45e5a6159ee013411dacb54bd6c1663e5829c7a.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

To keep the case of non TDX intact, introduce a new config option for
private KVM MMU support.  At the moment, this is synonym for
CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The config makes it clear
that the config is only for x86 KVM MMU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 73fdfa429b20..6bafdb2ce284 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -133,4 +133,8 @@ config KVM_XEN
 config KVM_EXTERNAL_WRITE_TRACKING
 	bool
 
+config KVM_MMU_PRIVATE
+	def_bool y
+	depends on INTEL_TDX_HOST && KVM_INTEL
+
 endif # VIRTUALIZATION
-- 
2.25.1

