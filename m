Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F13C7455
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhGMQWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230273AbhGMQWM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SdNhsy7o3104wP05E4ywfqm1n4wVUzK4agiNhE9tp/8=;
        b=Ba32A79rzSOFGpwO5Y06wKCcAb40skehRL7vxeFxfk2iMObrR4LMcxAWat1EPyD9mVBY3/
        mJ+7VYi18ORieQcDVQBQrU8mM4ziwd+ex+CkBBufqmToEWRbGTmg+UX5ljLEFEioAIz5ee
        LtUvpUS9BKO4GZ7ZBIgrzPb55NPjg0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-10elKf_6NZGC6fU9eTPHvg-1; Tue, 13 Jul 2021 12:19:19 -0400
X-MC-Unique: 10elKf_6NZGC6fU9eTPHvg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96C918015C6;
        Tue, 13 Jul 2021 16:19:18 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D94A5C1C5;
        Tue, 13 Jul 2021 16:19:14 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Michael Roth <michael.roth@amd.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PULL 08/11] target/i386: suppress CPUID leaves not defined by the CPU vendor
Date:   Tue, 13 Jul 2021 12:09:54 -0400
Message-Id: <20210713160957.3269017-9-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

Currently all built-in CPUs report cache information via CPUID leaves 2
and 4, but these have never been defined for AMD. In the case of
SEV-SNP this can cause issues with CPUID enforcement. Address this by
allowing CPU types to suppress these via a new "x-vendor-cpuid-only"
CPU property, which is true by default, but switched off for older
machine types to maintain compatibility.

Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>
Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-Id: <20210708003623.18665-1-michael.roth@amd.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/cpu.h | 3 +++
 hw/i386/pc.c      | 1 +
 target/i386/cpu.c | 6 ++++++
 3 files changed, 10 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 8f3747dd285..950a991a71c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1748,6 +1748,9 @@ struct X86CPU {
     /* Enable auto level-increase for all CPUID leaves */
     bool full_cpuid_auto_level;
 
+    /* Only advertise CPUID leaves defined by the vendor */
+    bool vendor_cpuid_only;
+
     /* Enable auto level-increase for Intel Processor Trace leave */
     bool intel_pt_auto_level;
 
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 8e1220db728..aa79c5e0e6f 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -98,6 +98,7 @@ GlobalProperty pc_compat_6_0[] = {
     { "qemu64" "-" TYPE_X86_CPU, "family", "6" },
     { "qemu64" "-" TYPE_X86_CPU, "model", "6" },
     { "qemu64" "-" TYPE_X86_CPU, "stepping", "3" },
+    { TYPE_X86_CPU, "x-vendor-cpuid-only", "off" },
 };
 const size_t pc_compat_6_0_len = G_N_ELEMENTS(pc_compat_6_0);
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 46befde3876..6b7043e4253 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5155,6 +5155,9 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (cpu->cache_info_passthrough) {
             host_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
+        } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
+            *eax = *ebx = *ecx = *edx = 0;
+            break;
         }
         *eax = 1; /* Number of CPUID[EAX=2] calls required */
         *ebx = 0;
@@ -5176,6 +5179,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             if ((*eax & 31) && cs->nr_cores > 1) {
                 *eax |= (cs->nr_cores - 1) << 26;
             }
+        } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
+            *eax = *ebx = *ecx = *edx = 0;
         } else {
             *eax = 0;
             switch (count) {
@@ -6651,6 +6656,7 @@ static Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto_level, true),
     DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
     DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
+    DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
     DEFINE_PROP_BOOL("lmce", X86CPU, enable_lmce, false),
     DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
     DEFINE_PROP_BOOL("kvm-no-smi-migration", X86CPU, kvm_no_smi_migration,
-- 
2.31.1

