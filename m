Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6997CAFB7
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbjJPQh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbjJPQgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:36:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9432B768C;
        Mon, 16 Oct 2023 09:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473374; x=1729009374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/5zkp3rNm7BgRzQAmi/3rkFYqYcx9+jnzyMWZ6+Iju0=;
  b=JJ5PL0+3VHETDu70fGiLoa1Bahrl8U7SXdP53xs3ECABGztkulwVFDjB
   IXm8gLzr+neI/kV0oijvT+lM0tRxZ7LZlORadnbuaPUMBEYPO90yrHZBo
   dMeOFCrSlsl5147GOdXfa2M/8wnVqJM++uwjRwouV9dtn9hsBRd5WA0+g
   5kW2LRClucpP9IL6Z+QDrmocIlxwEHFg8JMYqUzL++T+Pey6sdWf7aWiE
   uMzdczKfdZgYfRwwBK56tZ0bg3J6yW+r6oR2ycmddNq+p55CXY53FB91J
   Fsoq9GcH6bb4R4ROW2obUS3aQ1PawMDbvAcbmhpgSmTsO7BAlkR0WhfNj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365826009"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365826009"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126086"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126086"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:33 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 028/116] KVM: x86/mmu: introduce config for PRIVATE KVM MMU
Date:   Mon, 16 Oct 2023 09:13:40 -0700
Message-Id: <da12122604c62657567fe0a50112627b0da69740.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 4a864dbaa982..e08cc4ad5749 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -168,4 +168,8 @@ config KVM_PROVE_MMU
 config KVM_EXTERNAL_WRITE_TRACKING
 	bool
 
+config KVM_MMU_PRIVATE
+	def_bool y
+	depends on INTEL_TDX_HOST && KVM_INTEL
+
 endif # VIRTUALIZATION
-- 
2.25.1

