Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCEE2F061E
	for <lists+kvm@lfdr.de>; Sun, 10 Jan 2021 10:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbhAJJIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jan 2021 04:08:49 -0500
Received: from mga12.intel.com ([192.55.52.136]:13938 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbhAJJIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jan 2021 04:08:48 -0500
IronPort-SDR: R4ELyBeOsOj9loycJda/NjbauaIyP02IpbybE9FKa0LpqMlXOF7SzlUcWEyEba/5hZ9ua1kbJn
 qN4dsAygA8fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9859"; a="156933671"
X-IronPort-AV: E=Sophos;i="5.79,336,1602572400"; 
   d="scan'208";a="156933671"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2021 01:08:08 -0800
IronPort-SDR: KP5jeN2C8Carec+zIm/PwpLs67WQUUwlWxk0W9mV3EIUf5B0IwyRzHqXhUnAOeg7I9Ir0frAb3
 IUW2FoWaSRHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,336,1602572400"; 
   d="scan'208";a="380643426"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.149])
  by orsmga008.jf.intel.com with ESMTP; 10 Jan 2021 01:08:06 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH] x86/access: Fixed test stuck issue on new 52bit machine
Date:   Sun, 10 Jan 2021 17:19:42 +0800
Message-Id: <20210110091942.12835-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the application is tested on a machine with 52bit-physical-address, the
synthesized 52bit GPA triggers EPT(4-Level) fast_page_fault infinitely. On the
other hand, there's no reserved bits in 51:max_physical_address on machines with
52bit-physical-address.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/access.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 7dc9eb6..bec1c4d 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -15,6 +15,7 @@ static _Bool verbose = false;
 typedef unsigned long pt_element_t;
 static int invalid_mask;
 static int page_table_levels;
+static int max_phyaddr;
 
 #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
 #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
@@ -394,9 +395,10 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
     if (!F(AC_PDE_ACCESSED))
         at->ignore_pde = PT_ACCESSED_MASK;
 
-    pde_valid = F(AC_PDE_PRESENT)
-        && !F(AC_PDE_BIT51) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
+    pde_valid = F(AC_PDE_PRESENT) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
         && !(F(AC_PDE_NX) && !F(AC_CPU_EFER_NX));
+    if (max_phyaddr < 52)
+        pde_valid &= !F(AC_PDE_BIT51);
 
     if (!pde_valid) {
         at->expected_fault = 1;
@@ -420,9 +422,10 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
 
     at->expected_pde |= PT_ACCESSED_MASK;
 
-    pte_valid = F(AC_PTE_PRESENT)
-        && !F(AC_PTE_BIT51) && !F(AC_PTE_BIT36)
+    pte_valid = F(AC_PTE_PRESENT) && !F(AC_PTE_BIT36)
         && !(F(AC_PTE_NX) && !F(AC_CPU_EFER_NX));
+    if (max_phyaddr < 52)
+        pte_valid &= !F(AC_PTE_BIT51);
 
     if (!pte_valid) {
         at->expected_fault = 1;
@@ -964,13 +967,11 @@ static int ac_test_run(void)
     shadow_cr4 = read_cr4();
     shadow_efer = rdmsr(MSR_EFER);
 
-    if (cpuid_maxphyaddr() >= 52) {
-        invalid_mask |= AC_PDE_BIT51_MASK;
-        invalid_mask |= AC_PTE_BIT51_MASK;
-    }
-    if (cpuid_maxphyaddr() >= 37) {
+    if (max_phyaddr  >= 37 && max_phyaddr < 52) {
         invalid_mask |= AC_PDE_BIT36_MASK;
         invalid_mask |= AC_PTE_BIT36_MASK;
+        invalid_mask |= AC_PDE_BIT51_MASK;
+        invalid_mask |= AC_PTE_BIT51_MASK;
     }
 
     if (this_cpu_has(X86_FEATURE_PKU)) {
@@ -1038,6 +1039,7 @@ int main(void)
     int r;
 
     printf("starting test\n\n");
+    max_phyaddr = cpuid_maxphyaddr();
     page_table_levels = 4;
     r = ac_test_run();
 
-- 
2.17.2

