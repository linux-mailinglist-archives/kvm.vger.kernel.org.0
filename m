Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E6A31C560
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhBPCRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:17:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:39373 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhBPCQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:16:21 -0500
IronPort-SDR: SWejoa3N3h6dmEQ9bd73H0Ziu2c8VjR3h8G0331+guAi9K6mKmHPBoSsiSyhhAFvcOpErCIp7k
 ATUM7gA4Ypsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244270200"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244270200"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:51 -0800
IronPort-SDR: x998+QN+qsZQSDZtQ8EZL80B4rh+IhI/vkQfEaN30yn/Zy6zy6KpWrvRvxdKIOr71I+VRwFkyF
 rBBFk+x65wpQ==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705401"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:51 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 07/23] i386/kvm: Squash getting/putting guest state for TDX VMs
Date:   Mon, 15 Feb 2021 18:13:03 -0800
Message-Id: <ef3c6b6127b5a6442df69fcd9269ff414181c61a.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Ignore get/put state of TDX VMs as accessing/mutating guest state of
producation TDs is not supported.
Allow kvm_arch_get_registers() to run as normal, except for MSRs, for
debug TDs, and silently ignores attempts to read guest state for
non-debug TDs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 target/i386/kvm/kvm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ab7a896bd2..9c5f669b7c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2565,6 +2565,11 @@ void kvm_put_apicbase(X86CPU *cpu, uint64_t value)
 {
     int ret;
 
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (vm_type == KVM_X86_TDX_VM) {
+            return;
+    }
+
     ret = kvm_put_one_msr(cpu, MSR_IA32_APICBASE, value);
     assert(ret == 1);
 }
@@ -4019,6 +4024,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
 
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (vm_type == KVM_X86_TDX_VM) {
+        return 0;
+    }
+
     /* must be before kvm_put_nested_state so that EFER.SVME is set */
     ret = kvm_put_sregs(x86_cpu);
     if (ret < 0) {
@@ -4129,9 +4139,11 @@ int kvm_arch_get_registers(CPUState *cs)
     if (ret < 0) {
         goto out;
     }
-    ret = kvm_get_msrs(cpu);
-    if (ret < 0) {
-        goto out;
+    if (vm_type != KVM_X86_TDX_VM) {
+        ret = kvm_get_msrs(cpu);
+        if (ret < 0) {
+            goto out;
+        }
     }
     ret = kvm_get_apic(cpu);
     if (ret < 0) {
-- 
2.17.1

