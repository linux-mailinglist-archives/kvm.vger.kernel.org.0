Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43FA6B6465
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCLJzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCLJzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:38 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2043E603
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614914; x=1710150914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HDGk8QMutdu85ZF2s/5AkqdVFOdeo9U9crkljcB3vxU=;
  b=XATburba5ljJkI8hgKawTM6XDqxYD3XitILlwoZKA4JkENvhS+ibLAyh
   K7Xxiket6qViOcOiOqg3qqf6tquO2TWlUxMJXcuUczsSaI87zjeQNnTFj
   5Eo6G7rJ22EPCtBh5t22+G5rGWzLZXgNomKg1iQRWsxmONWAult/ei/01
   wz2pcWoGM4RYP7ZOKO1A8GhA8c6GIBbapt6QpKnf6ZYaW7av7HbX1eShV
   xuun5KzTdv8396C4PL+3ibfenYv1VfFJGXWk8EL/eWW8aYmb6RxuA0yvB
   y9y9hO/6CxHB4rtXdIlH/EHhn6cH6qxMhA3GTUZGZO9h249dQzi1RM0U1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623022"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623022"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660792"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660792"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:04 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-3 04/22] pkvm: x86: Add buddy page allocator
Date:   Mon, 13 Mar 2023 02:01:34 +0800
Message-Id: <20230312180152.1778338-5-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180152.1778338-1-jason.cj.chen@intel.com>
References: <20230312180152.1778338-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compile in buddy page allocator for pKVM on Intel platform, to support
its own page allocation.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/kvm_pkvm.h      | 5 +++++
 arch/x86/include/asm/pkvm_spinlock.h | 9 +++++++++
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   | 5 +++++
 virt/kvm/pkvm/gfp.h                  | 1 +
 4 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/kvm_pkvm.h b/arch/x86/include/asm/kvm_pkvm.h
index 224143567aaa..480051f28ebc 100644
--- a/arch/x86/include/asm/kvm_pkvm.h
+++ b/arch/x86/include/asm/kvm_pkvm.h
@@ -13,6 +13,11 @@ unsigned long pkvm_virt_to_phys(void *virt);
 
 #define __pkvm_pa(virt)	pkvm_virt_to_phys((void *)(virt))
 #define __pkvm_va(phys)	pkvm_phys_to_virt((unsigned long)(phys))
+
+/*TODO: unify the API name: __pkvm vs. __hyp? */
+#define __hyp_pa __pkvm_pa
+#define __hyp_va __pkvm_va
+
 #endif
 
 #endif
diff --git a/arch/x86/include/asm/pkvm_spinlock.h b/arch/x86/include/asm/pkvm_spinlock.h
index 1af9c1243576..e105402c695f 100644
--- a/arch/x86/include/asm/pkvm_spinlock.h
+++ b/arch/x86/include/asm/pkvm_spinlock.h
@@ -61,4 +61,13 @@ static inline void pkvm_spin_unlock(pkvm_spinlock_t *lock)
 
 }
 
+/*
+ * Redefine for virt/kvm/pkvm/page_alloc.c usage
+ * TODO: unify the API name: pkvm_ vs. hyp_ ?
+ */
+#define hyp_spinlock_t pkvm_spinlock_t
+#define hyp_spin_lock_init pkvm_spin_lock_init
+#define hyp_spin_lock pkvm_spin_lock
+#define hyp_spin_unlock pkvm_spin_unlock
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index f659debf4d76..578d6955a1d1 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
+KVM_PKVM = virt/kvm/pkvm
+
+ccflags-y += -I $(srctree)/$(KVM_PKVM)/
 ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-y += -I $(srctree)/arch/x86/kvm/vmx/pkvm/include
 ccflags-y += -fno-stack-protector
@@ -7,12 +10,14 @@ ccflags-y += -D__DISABLE_EXPORTS
 ccflags-y += -D__PKVM_HYP__
 
 lib-dir		:= lib
+virt-dir	:= ../../../../../../$(KVM_PKVM)
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o
 
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
 pkvm-hyp-$(CONFIG_DEBUG_LIST)	+= $(lib-dir)/list_debug.o
+pkvm-hyp-y	+= $(virt-dir)/page_alloc.o
 
 pkvm-obj 	:= $(patsubst %.o,%.pkvm.o,$(pkvm-hyp-y))
 obj-$(CONFIG_PKVM_INTEL)	+= pkvm.o
diff --git a/virt/kvm/pkvm/gfp.h b/virt/kvm/pkvm/gfp.h
index 1c3ff697efea..38015b4ec231 100644
--- a/virt/kvm/pkvm/gfp.h
+++ b/virt/kvm/pkvm/gfp.h
@@ -2,6 +2,7 @@
 #ifndef __PKVM_GFP_H
 #define __PKVM_GFP_H
 
+#include <linux/mmzone.h>
 #include <linux/list.h>
 
 #include <buddy_memory.h>
-- 
2.25.1

