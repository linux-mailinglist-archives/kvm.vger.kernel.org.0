Return-Path: <kvm+bounces-70066-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yH5YC0M/gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70066-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:32:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA51DDA20
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E206431C927C
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D21E36403F;
	Tue,  3 Feb 2026 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NsIhzxHL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636642264AD
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 18:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142766; cv=none; b=H98OprAKCki10L8VJzT5cCzPikx0J76eizqwuDXF9VXcM+wUdXClyhqeWIkCcK0pyEUyQXN00YJeHnrikAfNPOcGpm/a+B2nBAwfTobbvLaFsFn78zkBuLwIYc9QHWB4pNBHSYY1/rArr61Mw22c0q91dBUhh6+d76dc3nr4UmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142766; c=relaxed/simple;
	bh=l22a5oe1mNUs96P/dWE4w90GjFwTlVKZXSrjiX8hfFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k5u01CPAIzlccR2bxI9IewQ+5vQsq8upLYkeVTh+Ob3s1CAQ/m+QMHd+IX9ukKtnTU2rk3FzL5ZRfB1Bd4EXVGOBUmyIBpNx/yAdf5WVg8u6i/j36aCy3pyUARiy+a1SCPfQguba+fr9teUSoDm2cLStGD0//NvDYF9vQu25KQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NsIhzxHL; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142764; x=1801678764;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l22a5oe1mNUs96P/dWE4w90GjFwTlVKZXSrjiX8hfFo=;
  b=NsIhzxHLBRzZR/rD6RlfkDduebHuvY8ERQr3p3VWOFEsLOFVJc4CpvMX
   BZYc3lnyuEX6RKxnhS/SBnWUnrnVJG+/kFfXZWqKE0O8n9/0AjIuv5AR3
   4j2HbLDjU6f4pHbZGdbno8cUKOyuQyoJRWMK5jLI2Rr9djqblJQe63DWm
   YuSqUlnliV/XmWmWT7hIbAa1I4jyzOG1Jp+/PMa67bWc5MS2nIga2qRBE
   JSDLxGfuViyyAsFymXDFknl9YH/ouGJj6Qr0j6K3t5om8w4bcTti8eL9E
   xeqRgx8rEC0+2sc5ApZYuP/Sz9SYDo+jroFK0ckbTJfWFOjTsQL51Wp8C
   w==;
X-CSE-ConnectionGUID: h6rmg+IHTWKeCtuGBHIwEA==
X-CSE-MsgGUID: 0bTLI0cjRu+pid+DoXGdZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="70523244"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="70523244"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:19:24 -0800
X-CSE-ConnectionGUID: N0vYvOQ6QnGs//hQtFl67A==
X-CSE-MsgGUID: bW63XZYmRQuLOe76lXbkKg==
X-ExtLoop1: 1
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:19:24 -0800
From: isaku.yamahata@intel.com
To: qemu-devel@nongnu.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org
Subject: [PATCH 1/2] target/i386: Add definition of VMX proc based tertiary controls
Date: Tue,  3 Feb 2026 10:19:18 -0800
Message-ID: <e41ffc4af96b8b4ee3a65f8da1f52dac7f3f4913.1770116952.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70066-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9EA51DDA20
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

As APIC timer virtualization is supported for KVM nested VMX, support the
related feature bits for it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/cpu.c | 31 ++++++++++++++++++++++++++++++-
 target/i386/cpu.h |  5 +++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 45f0b80deb02..5b8d8298b404 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1638,7 +1638,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, NULL, NULL, "vmx-hlt-exit",
             NULL, "vmx-invlpg-exit", "vmx-mwait-exit", "vmx-rdpmc-exit",
             "vmx-rdtsc-exit", NULL, NULL, "vmx-cr3-load-noexit",
-            "vmx-cr3-store-noexit", NULL, NULL, "vmx-cr8-load-exit",
+            "vmx-cr3-store-noexit", "vmx-tertiary-ctls", NULL, "vmx-cr8-load-exit",
             "vmx-cr8-store-exit", "vmx-flexpriority", "vmx-vnmi-pending", "vmx-movdr-exit",
             "vmx-io-exit", "vmx-io-bitmap", NULL, "vmx-mtf",
             "vmx-msr-bitmap", "vmx-monitor-exit", "vmx-pause-exit", "vmx-secondary-ctls",
@@ -1665,6 +1665,31 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         }
     },
 
+    [FEAT_VMX_TERTIARY_CTLS] = {
+        .type = MSR_FEATURE_WORD,
+        .feat_names = {
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            "apic-timer-virt", NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
+        .msr = {
+            .index = MSR_IA32_VMX_PROCBASED_CTLS3,
+        }
+    },
+
     [FEAT_VMX_PINBASED_CTLS] = {
         .type = MSR_FEATURE_WORD,
         .feat_names = {
@@ -1979,6 +2004,10 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_VMX_SECONDARY_CTLS,  VMX_SECONDARY_EXEC_ENABLE_VMFUNC },
         .to = { FEAT_VMX_VMFUNC,            ~0ull },
     },
+    {
+        .from = { FEAT_VMX_PROCBASED_CTLS,  VMX_CPU_BASED_ACTIVATE_TERTIARY_CONTROLS },
+        .to = { FEAT_VMX_TERTIARY_CTLS,    ~0ull },
+    },
     {
         .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_SVM },
         .to = { FEAT_SVM,                   ~0ull },
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index da5161fc1a50..f073ffce620a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -592,6 +592,7 @@ typedef enum X86Seg {
 #define MSR_IA32_VMX_TRUE_EXIT_CTLS      0x0000048f
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
+#define MSR_IA32_VMX_PROCBASED_CTLS3    0x00000492
 
 #define MSR_APIC_START                  0x00000800
 #define MSR_APIC_END                    0x000008ff
@@ -693,6 +694,7 @@ typedef enum FeatureWord {
     FEAT_PERF_CAPABILITIES,
     FEAT_VMX_PROCBASED_CTLS,
     FEAT_VMX_SECONDARY_CTLS,
+    FEAT_VMX_TERTIARY_CTLS,
     FEAT_VMX_PINBASED_CTLS,
     FEAT_VMX_EXIT_CTLS,
     FEAT_VMX_ENTRY_CTLS,
@@ -1370,6 +1372,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define VMX_CPU_BASED_RDTSC_EXITING                 0x00001000
 #define VMX_CPU_BASED_CR3_LOAD_EXITING              0x00008000
 #define VMX_CPU_BASED_CR3_STORE_EXITING             0x00010000
+#define VMX_CPU_BASED_ACTIVATE_TERTIARY_CONTROLS    0x00020000
 #define VMX_CPU_BASED_CR8_LOAD_EXITING              0x00080000
 #define VMX_CPU_BASED_CR8_STORE_EXITING             0x00100000
 #define VMX_CPU_BASED_TPR_SHADOW                    0x00200000
@@ -1405,6 +1408,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define VMX_SECONDARY_EXEC_TSC_SCALING              0x02000000
 #define VMX_SECONDARY_EXEC_ENABLE_USER_WAIT_PAUSE   0x04000000
 
+#define VMX_TERTIARY_EXEC_APIC_TIMER_VIRT           0x0000000000000100ull
+
 #define VMX_PIN_BASED_EXT_INTR_MASK                 0x00000001
 #define VMX_PIN_BASED_NMI_EXITING                   0x00000008
 #define VMX_PIN_BASED_VIRTUAL_NMIS                  0x00000020

base-commit: b377abc220fc53e9cab2aac3c73fc20be6d85eea
-- 
2.45.2


