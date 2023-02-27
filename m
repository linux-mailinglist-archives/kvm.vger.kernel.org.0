Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18956A3C83
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjB0IZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjB0IYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:16 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E0F1CACE;
        Mon, 27 Feb 2023 00:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486253; x=1709022253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6IUEaKr0ie2ujCgGN6VZgF9eKrBotyox/Fn0sSiFqCA=;
  b=cTG9cgTC6D3ObJlEIR5H/XfHS9qsMt5gCLiLvvsVOzVer7W+SApUp/FJ
   Q9ApsIFjlDHe0bNvkumkXMewh6FdFlpe8PFldEg94VschhfjC5+mfZy6j
   pPkXgxNEI648ua8BeUJPoy64ghSpalkTZMtApfyO+a5tSyGbkn70BK8pX
   /K0hkMMyQpRo+V77FZLQjgTvt2EInP2BSP8IklJZ5ZYVlabHcNlApnlTl
   E7LK38YRBKdCkbid2zdRNsPlqZIQD6aZnenxGPmemXHVN0UT+QYJN5BOf
   KFr8hyf+W8pI3a5GRw6eEtAcPVqlM7CnuZ82D5mkob3OFaaepa1baDO0v
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608750"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608750"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242104"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242104"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:04 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 021/106] KVM: x86/mmu: introduce config for PRIVATE KVM MMU
Date:   Mon, 27 Feb 2023 00:22:20 -0800
Message-Id: <f047c0022458a19b3ad9c8c7a3ca4d8e6c8ecd94.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 718010600956..45ac6b01af44 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -153,4 +153,8 @@ config KVM_XEN
 config KVM_EXTERNAL_WRITE_TRACKING
 	bool
 
+config KVM_MMU_PRIVATE
+	def_bool y
+	depends on INTEL_TDX_HOST && KVM_INTEL
+
 endif # VIRTUALIZATION
-- 
2.25.1

