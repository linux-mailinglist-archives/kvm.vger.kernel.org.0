Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC671FB1A
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 09:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbjFBHkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 03:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjFBHkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 03:40:02 -0400
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90AE123
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 00:40:00 -0700 (PDT)
From:   Shiyuan Gao <gaoshiyuan@baidu.com>
To:     <pbonzini@redhat.com>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>
CC:     <likexu@tencent.com>, Shiyuan Gao <gaoshiyuan@baidu.com>
Subject: [PATCH] kvm: limit the maximum CPUID.0xA.edx[0..4] to 3
Date:   Fri, 2 Jun 2023 15:38:57 +0800
Message-ID: <20230602073857.96790-1-gaoshiyuan@baidu.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) To
 bjkjy-mail-ex26.internal.baidu.com (172.31.50.42)
X-FEAS-Client-IP: 172.31.51.58
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now, the CPUID.0xA depends on the KVM report. The value of CPUID.0xA.edx[0..4]
and num_architectural_pmu_fixed_counters are inconsistent when the host kernel
before this commit 2e8cd7a3b828 ("kvm: x86: limit the maximum number of vPMU
fixed counters to 3") on icelake microarchitecture.

This also break the live-migration between source host kernel before commit
2e8cd7a3b828 and dest host kernel after the commit on icelake microarchitecture.

Signed-off-by: Shiyuan Gao <gaoshiyuan@baidu.com>
---
 target/i386/kvm/kvm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6..e77129b737 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1761,7 +1761,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
-    uint32_t limit, i, j, cpuid_i;
+    uint32_t limit, i, j, cpuid_i, cpuid_0xa;
     uint32_t unused;
     struct kvm_cpuid_entry2 *c;
     uint32_t signature[3];
@@ -1773,6 +1773,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     memset(&cpuid_data, 0, sizeof(cpuid_data));
 
     cpuid_i = 0;
+    cpuid_0xa = 0;
 
     has_xsave2 = kvm_check_extension(cs->kvm_state, KVM_CAP_XSAVE2);
 
@@ -2045,6 +2046,9 @@ int kvm_arch_init_vcpu(CPUState *cs)
             c->function = i;
             c->flags = 0;
             cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            if (0x0a == i) {
+                cpuid_0xa = cpuid_i - 1;
+            }
             if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
                 /*
                  * KVM already returns all zeroes if a CPUID entry is missing,
@@ -2059,7 +2063,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (limit >= 0x0a) {
         uint32_t eax, edx;
 
-        cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
+        assert(cpuid_0xa >= 0x0a);
+
+        c = &cpuid_data.entries[cpuid_0xa];
+        eax = c->eax;
+        edx = c->edx;
 
         has_architectural_pmu_version = eax & 0xff;
         if (has_architectural_pmu_version > 0) {
@@ -2078,6 +2086,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
                 if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
                     num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
+                    c->edx = (edx & ~0x1f) | num_architectural_pmu_fixed_counters;
                 }
             }
         }
-- 
2.36.1

