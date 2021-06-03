Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2D839A0E3
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhFCMbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:31:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47956 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbhFCMbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:31:49 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3F0C91FD5F;
        Thu,  3 Jun 2021 12:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622723404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ay29fbK54m4zOFfL7XcmFsEYA4OX6juXQudbeB8sPOQ=;
        b=IxQOuHBDhCNrwRyvI4tuzAz+xokqxOPodbSr0KeN/TVRRw+DLsLx7+5EYeFkunE3MFHhHs
        /vn4NLzdnPuDE2wDY2WHHTGA/z4Dx8HC/wphlN+SlBkMSKuqm5Bo/vVQlZ0pfLzT33VLYw
        qNTNzQsLvY9n5SS/ijIwGGj2656nbww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622723404;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ay29fbK54m4zOFfL7XcmFsEYA4OX6juXQudbeB8sPOQ=;
        b=T2ODzoY4SedaKOAKMAGgXx//H24cCGhJIJppa1IMcM3WyUbmv9qcIHydLepohMdIveUuRN
        RCUzfsOY2uMPhOCQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7887C118DD;
        Thu,  3 Jun 2021 12:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622723404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ay29fbK54m4zOFfL7XcmFsEYA4OX6juXQudbeB8sPOQ=;
        b=IxQOuHBDhCNrwRyvI4tuzAz+xokqxOPodbSr0KeN/TVRRw+DLsLx7+5EYeFkunE3MFHhHs
        /vn4NLzdnPuDE2wDY2WHHTGA/z4Dx8HC/wphlN+SlBkMSKuqm5Bo/vVQlZ0pfLzT33VLYw
        qNTNzQsLvY9n5SS/ijIwGGj2656nbww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622723404;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ay29fbK54m4zOFfL7XcmFsEYA4OX6juXQudbeB8sPOQ=;
        b=T2ODzoY4SedaKOAKMAGgXx//H24cCGhJIJppa1IMcM3WyUbmv9qcIHydLepohMdIveUuRN
        RCUzfsOY2uMPhOCQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id aFrXGkvLuGCiFwAALh3uQQ
        (envelope-from <cfontana@suse.de>); Thu, 03 Jun 2021 12:30:03 +0000
From:   Claudio Fontana <cfontana@suse.de>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
Subject: [PATCH v2 1/2] i386: reorder call to cpu_exec_realizefn
Date:   Thu,  3 Jun 2021 14:30:00 +0200
Message-Id: <20210603123001.17843-2-cfontana@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210603123001.17843-1-cfontana@suse.de>
References: <20210603123001.17843-1-cfontana@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

i386 realizefn code is sensitive to ordering, and recent commits
aimed at refactoring it, splitting accelerator-specific code,
broke assumptions which need to be fixed.

We need to:

* process hyper-v enlightements first, as they assume features
  not to be expanded

* only then, expand features

* after expanding features, attempt to check them and modify them in the
  accel-specific realizefn code called by cpu_exec_realizefn().

* after the framework has been called via cpu_exec_realizefn,
  the code can check for what has or hasn't been set by accel-specific
  code, or extend its results, ie:

  - check and evenually set code_urev default
  - modify cpu->mwait after potentially being set from host CPUID.
  - finally check for phys_bits assuming all user and accel-specific
    adjustments have already been taken into account.

Fixes: f5cc5a5c ("i386: split cpu accelerators from cpu.c"...)
Fixes: 30565f10 ("cpu: call AccelCPUClass::cpu_realizefn in"...)
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Claudio Fontana <cfontana@suse.de>
---
 target/i386/cpu.c         | 79 +++++++++++++++++++++++++--------------
 target/i386/kvm/kvm-cpu.c | 12 +++++-
 2 files changed, 61 insertions(+), 30 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9e211ac2ce..f7eb5f7f6e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6133,39 +6133,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     Error *local_err = NULL;
     static bool ht_warned;
 
-    /* Process Hyper-V enlightenments */
-    x86_cpu_hyperv_realize(cpu);
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
-    if (xcc->host_cpuid_required && !accel_uses_host_cpuid()) {
-        g_autofree char *name = x86_cpu_class_get_model_name(xcc);
-        error_setg(&local_err, "CPU model '%s' requires KVM or HVF", name);
-        goto out;
-    }
-
-    if (cpu->ucode_rev == 0) {
-        /* The default is the same as KVM's.  */
-        if (IS_AMD_CPU(env)) {
-            cpu->ucode_rev = 0x01000065;
-        } else {
-            cpu->ucode_rev = 0x100000000ULL;
-        }
-    }
-
-    /* mwait extended info: needed for Core compatibility */
-    /* We always wake on interrupt even if host does not have the capability */
-    cpu->mwait.ecx |= CPUID_MWAIT_EMX | CPUID_MWAIT_IBE;
-
     if (cpu->apic_id == UNASSIGNED_APIC_ID) {
         error_setg(errp, "apic-id property was not initialized properly");
         return;
     }
 
+    /*
+     * Process Hyper-V enlightenments.
+     * Note: this currently has to happen before the expansion of CPU features.
+     */
+    x86_cpu_hyperv_realize(cpu);
+
     x86_cpu_expand_features(cpu, &local_err);
     if (local_err) {
         goto out;
@@ -6190,11 +6168,56 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
            & CPUID_EXT2_AMD_ALIASES);
     }
 
+    /*
+     * note: the call to the framework needs to happen after feature expansion,
+     * but before the checks/modifications to ucode_rev, mwait, phys_bits.
+     * These may be set by the accel-specific code,
+     * and the results are subsequently checked / assumed in this function.
+     */
+    cpu_exec_realizefn(cs, &local_err);
+    if (local_err != NULL) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+    if (xcc->host_cpuid_required && !accel_uses_host_cpuid()) {
+        g_autofree char *name = x86_cpu_class_get_model_name(xcc);
+        error_setg(&local_err, "CPU model '%s' requires KVM or HVF", name);
+        goto out;
+    }
+
+    if (cpu->ucode_rev == 0) {
+        /*
+         * The default is the same as KVM's. Note that this check
+         * needs to happen after the evenual setting of ucode_rev in
+         * accel-specific code in cpu_exec_realizefn.
+         */
+        if (IS_AMD_CPU(env)) {
+            cpu->ucode_rev = 0x01000065;
+        } else {
+            cpu->ucode_rev = 0x100000000ULL;
+        }
+    }
+
+    /*
+     * mwait extended info: needed for Core compatibility
+     * We always wake on interrupt even if host does not have the capability.
+     *
+     * requires the accel-specific code in cpu_exec_realizefn to
+     * have already acquired the CPUID data into cpu->mwait.
+     */
+    cpu->mwait.ecx |= CPUID_MWAIT_EMX | CPUID_MWAIT_IBE;
+
     /* For 64bit systems think about the number of physical bits to present.
      * ideally this should be the same as the host; anything other than matching
      * the host can cause incorrect guest behaviour.
      * QEMU used to pick the magic value of 40 bits that corresponds to
      * consumer AMD devices but nothing else.
+     *
+     * Note that this code assumes features expansion has already been done
+     * (as it checks for CPUID_EXT2_LM), and also assumes that potential
+     * phys_bits adjustments to match the host have been already done in
+     * accel-specific code in cpu_exec_realizefn.
      */
     if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
         if (cpu->phys_bits &&
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index c660ad4293..afd5f01413 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -26,10 +26,18 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
     /*
      * The realize order is important, since x86_cpu_realize() checks if
      * nothing else has been set by the user (or by accelerators) in
-     * cpu->ucode_rev and cpu->phys_bits.
+     * cpu->ucode_rev and cpu->phys_bits, and updates the CPUID results in
+     * mwait.ecx.
+     * This accel realization code also assumes cpu features are already expanded.
      *
      * realize order:
-     * kvm_cpu -> host_cpu -> x86_cpu
+     *
+     * x86_cpu_realize():
+     *  -> x86_cpu_expand_features()
+     *  -> cpu_exec_realizefn():
+     *            -> accel_cpu_realizefn()
+     *               kvm_cpu_realizefn() -> host_cpu_realizefn()
+     *  -> check/update ucode_rev, phys_bits, mwait
      */
     if (cpu->max_features) {
         if (enable_cpu_pm && kvm_has_waitpkg()) {
-- 
2.26.2

