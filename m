Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33483C7442
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhGMQWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhGMQWE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ChhBpIOmM7bjTCqQfbUgW2k7UPcZXj6pn5J4aX1nGDI=;
        b=DNO+MeGzcpgGXHYEpbVQaZgu5NsNsp6q0LDDReZWkx/lapv/n3LQrrpCPNevl6OMEpm0FG
        lBTy4SYRjnStwyK+oVi/xUHERuslGXVnNt5kLnlEqySa9RBH4o0w9Pni1dp9pjUrNcI8G3
        8epATGkhPgGQS28Qyw9fIAJrgDk0gCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-36QAGRBpNdG0Is3cPZew1Q-1; Tue, 13 Jul 2021 12:19:12 -0400
X-MC-Unique: 36QAGRBpNdG0Is3cPZew1Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56DA7DF8A7;
        Tue, 13 Jul 2021 16:19:11 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D76E5D9CA;
        Tue, 13 Jul 2021 16:19:11 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PULL 04/11] i386: expand Hyper-V features during CPU feature expansion time
Date:   Tue, 13 Jul 2021 12:09:50 -0400
Message-Id: <20210713160957.3269017-5-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

To make Hyper-V features appear in e.g. QMP query-cpu-model-expansion we
need to expand and set the corresponding CPUID leaves early. Modify
x86_cpu_get_supported_feature_word() to call newly intoduced Hyper-V
specific kvm_hv_get_supported_cpuid() instead of
kvm_arch_get_supported_cpuid(). We can't use kvm_arch_get_supported_cpuid()
as Hyper-V specific CPUID leaves intersect with KVM's.

Note, early expansion will only happen when KVM supports system wide
KVM_GET_SUPPORTED_HV_CPUID ioctl (KVM_CAP_SYS_HYPERV_CPUID).

Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210608120817.1325125-6-vkuznets@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm/kvm_i386.h |  1 +
 target/i386/cpu.c          |  4 ++++
 target/i386/kvm/kvm-stub.c |  5 +++++
 target/i386/kvm/kvm.c      | 24 ++++++++++++++++++++----
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index dc725083891..54667b35f09 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -47,6 +47,7 @@ bool kvm_has_x2apic_api(void);
 bool kvm_has_waitpkg(void);
 
 bool kvm_hv_vpindex_settable(void);
+bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
 
 uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5f595a0d7e2..46befde3876 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5974,6 +5974,10 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
     if (env->cpuid_xlevel2 == UINT32_MAX) {
         env->cpuid_xlevel2 = env->cpuid_min_xlevel2;
     }
+
+    if (kvm_enabled()) {
+        kvm_hyperv_expand_features(cpu, errp);
+    }
 }
 
 /*
diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
index 92f49121b8f..f6e7e4466e1 100644
--- a/target/i386/kvm/kvm-stub.c
+++ b/target/i386/kvm/kvm-stub.c
@@ -39,3 +39,8 @@ bool kvm_hv_vpindex_settable(void)
 {
     return false;
 }
+
+bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
+{
+    abort();
+}
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ef127762bca..556815db13d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1220,13 +1220,22 @@ static uint32_t hv_build_cpuid_leaf(CPUState *cs, uint32_t func, int reg)
  * of 'hv_passthrough' mode and fills the environment with all supported
  * Hyper-V features.
  */
-static bool hyperv_expand_features(CPUState *cs, Error **errp)
+bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
 {
-    X86CPU *cpu = X86_CPU(cs);
+    CPUState *cs = CPU(cpu);
 
     if (!hyperv_enabled(cpu))
         return true;
 
+    /*
+     * When kvm_hyperv_expand_features is called at CPU feature expansion
+     * time per-CPU kvm_state is not available yet so we can only proceed
+     * when KVM_CAP_SYS_HYPERV_CPUID is supported.
+     */
+    if (!cs->kvm_state &&
+        !kvm_check_extension(kvm_state, KVM_CAP_SYS_HYPERV_CPUID))
+        return true;
+
     if (cpu->hyperv_passthrough) {
         cpu->hyperv_vendor_id[0] =
             hv_cpuid_get_host(cs, HV_CPUID_VENDOR_AND_MAX_FUNCTIONS, R_EBX);
@@ -1593,8 +1602,15 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
 
-    /* Paravirtualization CPUIDs */
-    if (!hyperv_expand_features(cs, &local_err)) {
+    /*
+     * kvm_hyperv_expand_features() is called here for the second time in case
+     * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle
+     * 'query-cpu-model-expansion' in this case as we don't have a KVM vCPU to
+     * check which Hyper-V enlightenments are supported and which are not, we
+     * can still proceed and check/expand Hyper-V enlightenments here so legacy
+     * behavior is preserved.
+     */
+    if (!kvm_hyperv_expand_features(cpu, &local_err)) {
         error_report_err(local_err);
         return -ENOSYS;
     }
-- 
2.31.1

