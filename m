Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFB531C553
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBPCQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:16:05 -0500
Received: from mga06.intel.com ([134.134.136.31]:39370 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhBPCPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:15:54 -0500
IronPort-SDR: DZFrCxXJs72A1do3ciVcgfv+SjtomPHFFjDsGAjo2hnNn5wgbXBYyCiCZXeMDVgoT8R9CGS9av
 z3bI6GLh04uQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244270194"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244270194"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:50 -0800
IronPort-SDR: BJ3gNTgiWLJnlFPV3wYnA31/SdKC5ZlJvs2lJHh+FIN+u4RmZgSORWxYKOdFF/KvHziTN38xa7
 fSJ9YSdH/zJg==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705383"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:50 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 01/23] target/i386: Expose x86_cpu_get_supported_feature_word() for TDX
Date:   Mon, 15 Feb 2021 18:12:57 -0800
Message-Id: <c77664a9e03d53ed870635064551caa663b3dfc4.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Expose x86_cpu_get_supported_feature_word() outside of cpu.c so that it
can be used by TDX to setup the VM-wide CPUID configuration.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9c3d2d60b7..578e1fe25f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5043,8 +5043,8 @@ CpuDefinitionInfoList *qmp_query_cpu_definitions(Error **errp)
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
index 8d599bb5b8..7274e8d1b4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1815,6 +1815,9 @@ void cpu_set_ignne(void);
 /* mpx_helper.c */
 void cpu_sync_bndcs_hflags(CPUX86State *env);
 
+uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
+                                            bool migratable_only);
+
 /* this function must always be used to load data in the segment
    cache: it synchronizes the hflags with the segment cache values */
 static inline void cpu_x86_load_seg_cache(CPUX86State *env,
-- 
2.17.1

