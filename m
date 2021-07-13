Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432833C743F
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhGMQWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhGMQWD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wS7SO4/3KCWiUzr2yC16eiPT9KA3yQWcb7HDMTmC2dY=;
        b=NXXpvkXxD18CHd/fxfrrmNy1Bjys25xxF/K97vh1YkI7ukf+SxRmr8HustYAbZviDpYX81
        oCLkfVmi5nyFyaGfpZu2JM62t6/igve5xwJZIV3yzYFOkogJIBPopjdDmdorFMwAxT/X8I
        UkE9N7YLo8ZnJNHg8uhhziE4S9x7gco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-B1-NFwiwPQqcIPuqkxsBUA-1; Tue, 13 Jul 2021 12:19:11 -0400
X-MC-Unique: B1-NFwiwPQqcIPuqkxsBUA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AC05DF8A0;
        Tue, 13 Jul 2021 16:19:10 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 474DF5C1C5;
        Tue, 13 Jul 2021 16:19:10 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PULL 03/11] i386: make hyperv_expand_features() return bool
Date:   Tue, 13 Jul 2021 12:09:49 -0400
Message-Id: <20210713160957.3269017-4-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Return 'false' when hyperv_expand_features() sets an error.

No functional change intended.

Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210608120817.1325125-5-vkuznets@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm/kvm.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 02216b70311..ef127762bca 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1220,12 +1220,12 @@ static uint32_t hv_build_cpuid_leaf(CPUState *cs, uint32_t func, int reg)
  * of 'hv_passthrough' mode and fills the environment with all supported
  * Hyper-V features.
  */
-static void hyperv_expand_features(CPUState *cs, Error **errp)
+static bool hyperv_expand_features(CPUState *cs, Error **errp)
 {
     X86CPU *cpu = X86_CPU(cs);
 
     if (!hyperv_enabled(cpu))
-        return;
+        return true;
 
     if (cpu->hyperv_passthrough) {
         cpu->hyperv_vendor_id[0] =
@@ -1273,49 +1273,49 @@ static void hyperv_expand_features(CPUState *cs, Error **errp)
 
     /* Features */
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_RELAXED, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_VAPIC, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_TIME, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_CRASH, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_RESET, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_VPINDEX, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_RUNTIME, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_SYNIC, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_STIMER, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_FREQUENCIES, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_REENLIGHTENMENT, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_TLBFLUSH, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_EVMCS, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_IPI, errp)) {
-        return;
+        return false;
     }
     if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_STIMER_DIRECT, errp)) {
-        return;
+        return false;
     }
 
     /* Additional dependencies not covered by kvm_hyperv_properties[] */
@@ -1325,7 +1325,10 @@ static void hyperv_expand_features(CPUState *cs, Error **errp)
         error_setg(errp, "Hyper-V %s requires Hyper-V %s",
                    kvm_hyperv_properties[HYPERV_FEAT_SYNIC].desc,
                    kvm_hyperv_properties[HYPERV_FEAT_VPINDEX].desc);
+        return false;
     }
+
+    return true;
 }
 
 /*
@@ -1591,8 +1594,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
 
     /* Paravirtualization CPUIDs */
-    hyperv_expand_features(cs, &local_err);
-    if (local_err) {
+    if (!hyperv_expand_features(cs, &local_err)) {
         error_report_err(local_err);
         return -ENOSYS;
     }
-- 
2.31.1

