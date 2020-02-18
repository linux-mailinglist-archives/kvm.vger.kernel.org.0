Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FFF163597
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgBRV6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:58:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:52969 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbgBRV6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:58:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:58:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436004637"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 13:58:30 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com
Cc:     hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        liran.alon@oracle.com, luto@kernel.org, joro@8bytes.org,
        rick.p.edgecombe@intel.com, kristen@linux.intel.com,
        arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, John Andersen <john.s.andersen@intel.com>
Subject: [RFC v2 1/4] X86: Update mmu_cr4_features during identification
Date:   Tue, 18 Feb 2020 13:58:59 -0800
Message-Id: <20200218215902.5655-2-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200218215902.5655-1-john.s.andersen@intel.com>
References: <20200218215902.5655-1-john.s.andersen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In identify_cpu when setting up SMEP/SMAP/UMIP call
cr4_set_bits_and_update_boot instead of cr4_set_bits. This ensures that
mmu_cr4_features contains those bits, and does not disable those
protections when in hibernation asm.

setup_arch updates mmu_cr4_features to save what identified features are
supported for later use in hibernation asm when cr4 needs to be modified
to toggle PGE. cr4 writes happen in restore_image and restore_registers.
setup_arch occurs before identify_cpu, this leads to mmu_cr4_features
not containing some of the cr4 features which were enabled via
identify_cpu when hibernation asm is executed.

On CPU bringup when cr4_set_bits_and_update_boot is called
mmu_cr4_features will now be written to. For the boot CPU,
the __ro_after_init on mmu_cr4_features does not cause a fault. However,
__ro_after_init was removed due to it triggering faults on non-boot
CPUs.

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 arch/x86/kernel/cpu/common.c | 6 +++---
 arch/x86/kernel/setup.c      | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 52c9bfbbdb2a..08682757e547 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -297,7 +297,7 @@ __setup("nosmep", setup_disable_smep);
 static __always_inline void setup_smep(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SMEP))
-		cr4_set_bits(X86_CR4_SMEP);
+		cr4_set_bits_and_update_boot(X86_CR4_SMEP);
 }
 
 static __init int setup_disable_smap(char *arg)
@@ -316,7 +316,7 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_SMAP)) {
 #ifdef CONFIG_X86_SMAP
-		cr4_set_bits(X86_CR4_SMAP);
+		cr4_set_bits_and_update_boot(X86_CR4_SMAP);
 #else
 		cr4_clear_bits(X86_CR4_SMAP);
 #endif
@@ -333,7 +333,7 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 	if (!cpu_has(c, X86_FEATURE_UMIP))
 		goto out;
 
-	cr4_set_bits(X86_CR4_UMIP);
+	cr4_set_bits_and_update_boot(X86_CR4_UMIP);
 
 	pr_info_once("x86/cpu: User Mode Instruction Prevention (UMIP) activated\n");
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a74262c71484..9e71d6f6e564 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -138,9 +138,9 @@ EXPORT_SYMBOL(boot_cpu_data);
 
 
 #if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
-__visible unsigned long mmu_cr4_features __ro_after_init;
+__visible unsigned long mmu_cr4_features;
 #else
-__visible unsigned long mmu_cr4_features __ro_after_init = X86_CR4_PAE;
+__visible unsigned long mmu_cr4_features = X86_CR4_PAE;
 #endif
 
 /* Boot loader ID and version as integers, for the benefit of proc_dointvec */
-- 
2.21.0

