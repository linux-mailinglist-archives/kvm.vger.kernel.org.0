Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16DC54DD6C
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376355AbiFPItd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376283AbiFPIsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CDD15705;
        Thu, 16 Jun 2022 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369262; x=1686905262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IKjbYcydGhUQOtO5VnHy7aAu+jLJsu2LqXV0XPrI8+M=;
  b=UhUIz0bj+7pY7qY4tlLJlE0hP5ByrHMA//lR3Kg3Ty8zBbQzouplfuLc
   M6FLBZ2r4/Q86hy3JUq+TW34W1dfN+b+uRm6wuv6EC9FUqZNYBHYgwmi4
   WjWp5G9zqoXZIl3dVUN5p6GovVanBcO2JLfMejx31W0XlSTHvCUBGW0X9
   bJdRsp5wnzT8K3hKAYyyeBUU9Zm2GWZU3I+LzGi2qQ7rbUwggxZZqqzf3
   NzXBpNnZ1ZkbqgQgSv4bNAEG6KgHNbMAp992+IjWygSddr7HOwq1Hx2NK
   2ZVfERhB6gyJstaC7wolTVVkAKKE0gcAfJYx5ARTEbwRfxvmfoefqyFNB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259664550"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259664550"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083128"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com, Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 01/19] x86/cet/shstk: Add Kconfig option for Shadow Stack
Date:   Thu, 16 Jun 2022 04:46:25 -0400
Message-Id: <20220616084643.19564-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yu-cheng Yu <yu-cheng.yu@intel.com>

Shadow Stack provides protection against function return address
corruption. It is active when the processor supports it, the kernel has
CONFIG_X86_SHADOW_STACK enabled, and the application is built for the
feature. This is only implemented for the 64-bit kernel. When it is
enabled, legacy non-Shadow Stack applications continue to work, but without
protection.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Cc: Kees Cook <keescook@chromium.org>

---
v2:
 - Remove already wrong kernel size increase info (tlgx)
 - Change prompt to remove "Intel" (tglx)
 - Update line about what CPUs are supported (Dave)

Yu-cheng v25:
 - Remove X86_CET and use X86_SHADOW_STACK directly.

Yu-cheng v24:
 - Update for the splitting X86_CET to X86_SHADOW_STACK and X86_IBT.

 arch/x86/Kconfig           | 17 +++++++++++++++++
 arch/x86/Kconfig.assembler |  1 +
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9783ebc4e021..79c6b0490350 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,6 +26,7 @@ config X86_64
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_SHADOW_STACK
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select HAVE_ARCH_SOFT_DIRTY
@@ -1969,6 +1970,22 @@ config X86_SGX
 
 	  If unsure, say N.
 
+config ARCH_HAS_SHADOW_STACK
+	def_bool n
+
+config X86_SHADOW_STACK
+	prompt "X86 Shadow Stack"
+	def_bool n
+	depends on ARCH_HAS_SHADOW_STACK
+	help
+	  Shadow Stack protection is a hardware feature that detects function
+	  return address corruption. Today the kernel's support is limited to
+	  virtualizing it in KVM guests.
+
+	  CPUs supporting shadow stacks were first released in 2020.
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 26b8c08e2fc4..41428391e475 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -19,3 +19,4 @@ config AS_TPAUSE
 	def_bool $(as-instr,tpause %ecx)
 	help
 	  Supported by binutils >= 2.31.1 and LLVM integrated assembler >= V7
+
-- 
2.27.0

