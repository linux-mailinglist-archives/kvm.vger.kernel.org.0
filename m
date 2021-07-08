Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A3D3BF2FF
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhGHA6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:27077 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230120AbhGHA6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209381414"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209381414"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:52 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423769979"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:51 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 01/44] target/i386: Expose x86_cpu_get_supported_feature_word() for TDX
Date:   Wed,  7 Jul 2021 17:54:31 -0700
Message-Id: <f78aa143d508c5fd0f54da4f31c339e79ebdd105.1625704980.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Expose x86_cpu_get_supported_feature_word() outside of cpu.c so that it
can be used by TDX to setup the VM-wide CPUID configuration.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d8f3ab3192..45b81a63df 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4894,8 +4894,8 @@ CpuDefinitionInfoList *qmp_query_cpu_definitions(Error **errp)
     return cpu_list;
 }
 
-static uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
-                                                   bool migratable_only)
+uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
+                                            bool migratable_only)
 {
     FeatureWordInfo *wi = &feature_word_info[w];
     uint64_t r = 0;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index f7fa5870b1..ff8f9532b9 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1838,6 +1838,9 @@ void cpu_clear_ignne(void);
 /* mpx_helper.c */
 void cpu_sync_bndcs_hflags(CPUX86State *env);
 
+uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
+                                            bool migratable_only);
+
 /* this function must always be used to load data in the segment
    cache: it synchronizes the hflags with the segment cache values */
 static inline void cpu_x86_load_seg_cache(CPUX86State *env,
-- 
2.25.1

