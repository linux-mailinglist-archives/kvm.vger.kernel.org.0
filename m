Return-Path: <kvm+bounces-67749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B3628D12CD2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B3283302CDD0
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256792222C4;
	Mon, 12 Jan 2026 13:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HdahEDxz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BHE1ftPK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74E73596EE
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224278; cv=none; b=RlucsmMtaNDkMtyjzbR6zzzuoms+jeu11denWhS0uEaBh13tPLiHLkm8GA5JYoAzzPh9UXfXCkcs8r4yRR5s+77SjxEc0EP9syzca/hyAH97cM1A8dGzFD7541SnlNguT5HR9W/tjI4cDiB7C1EWLIPV8MUUnXXuU6+OBusbyPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224278; c=relaxed/simple;
	bh=Py9sYNgT06gvB0gwh9FSlwUf7IliHOL4HvJuHNioSRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7s/lZStZdeTMKKKV/V82tp23LGHnVye4j7rCUQijTfvae5FVNSq8ao7FunVrkBq8vgrvuhgr1S2saHzHgxrJ/foVzWpfoRY0ZEdEnkZG2qVhBpOA11DW0trkvy4T9pJgCx0ODQt9+AtiFHRhBUckzDigRqtGZCEOZWPY8i59bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HdahEDxz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BHE1ftPK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mNZOVGpLRkq1Bf/PS8HZ5/0yQ0n0eM+fBjQiQ5vegE=;
	b=HdahEDxzkCjouGtfzZ0CKMnXC81ggxsbuh1AiXm8e5bpvT+HpK1fP400geqlnBOZyHsu7f
	omAKNA6Fm68ncPKxoTgDI/Lm47VRvyuHXahppdj85YzHjqGe+aWQaxh3zm7rD6t6ScNSFB
	FYO4fvEfodF3xoTR4XrIQz9VpicBJz0=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433--Luz0JZyMQid05nxv5D-YQ-1; Mon, 12 Jan 2026 08:24:29 -0500
X-MC-Unique: -Luz0JZyMQid05nxv5D-YQ-1
X-Mimecast-MFC-AGG-ID: -Luz0JZyMQid05nxv5D-YQ_1768224268
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so4538477a12.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224268; x=1768829068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mNZOVGpLRkq1Bf/PS8HZ5/0yQ0n0eM+fBjQiQ5vegE=;
        b=BHE1ftPKpcOnjA9G0ZzVGS1Ri7nfSx73YOSCaSZRPcgIOcLnZtArREumfE6dBF7YNN
         Ly8d42Wzsa4KTuwvsnF67DVmG17w5XqfhWOby8fMkQOGVcONMyfo+wa/FhrhUTEtkUn/
         MJ2Lw1NNL1j/AeM7XP4/bk1foqurz54ZtlDRMZiwR0o+bRRXMy6WSkXdnlSHv240BYYc
         iskwolvgbvYQXezF8FvglRvwgINBkDFG0L6YkZ8Hzb/Ge4xYRO9TB/662g2TJvcWdMHM
         GcWxy/xUSyvD22+ZJuaev7t0p+ac1+xHR0+xPjFFc+EQrSy7MwZ3jz6suIi3At0f7VUO
         DlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224268; x=1768829068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5mNZOVGpLRkq1Bf/PS8HZ5/0yQ0n0eM+fBjQiQ5vegE=;
        b=cPhP7TvLIfPCOaaBbMRqUtJYthQKtV4Ug56DaMT34CUfLVYcPxhjlmB8VvH+MoEIpJ
         ZUthfpQBQQ6fdLwQr1TCYdj5mvQy4NuEsjbLLdhmxJqSC7r4JsRA+9L9uRodqQTj/4oN
         QcWPU2GVZXJwgAXa5hVJKwcohSp9ZDuftzWjW2S27cfQB4CGqX8UEIYV1KOWgpHe/0wk
         bnjaFPwL7ZbQTM5k9o99gduMI5ph5RPI9KsE9MoGWbfcKwoqGQCFwr5OuLVMzh8g8/RT
         5KBe/pe9quMnVdXuG0W17nKq6awnqw6w15lEBsQwyNyM/yt8W7MREsVbmzwnmSUjh8Ft
         ZG/g==
X-Forwarded-Encrypted: i=1; AJvYcCVYKAJYpxIXjyizplv2e4QCoVqcnVk66sqcziUfuOdWJQOH+BdjGQbKDzp2Kdw0+XETpwA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4OS3aWtKK3BEz1dUW47VDk+T1gEa5Zc56DrV3iQZneZ3sOPwN
	Uubz0AifY2jK4hGzF0a4sV/j6PqYlYfD9pIJwsetbnH/5vb3a5aUfxcDxjEk8FzyZn48CINjl/c
	WekRZk8DrsrK5YlYvKpsOPuWl6znwSrgbNhWfAhuUOhKs5VIZSBzvIA==
X-Gm-Gg: AY/fxX6NQ0DVxeCE+d5RDOlZ9f5GkLtNNclVqm7pMTiNeDgixXzWWlRQemWe9Nb3k3Y
	adPuj8Rkfvsl2Gut9Ese7oZe7Lb+Ppm4QuSnU27TjScfCpF/2+SbjLeEomTx1WHz3txNPxUqa6y
	weKRY6A9LfiIhLzIPMGrpK/Sk2hsbdVBuo5iHdxZXEliBDR1O9zfvBTKqm8TyLKbwdo+yhaUWnV
	F34rNq+xUROwVt2xT1Dfp+JcGVr2sht/CHYWO/I6hPYOz1H7Hx/d3UnlAc40Pfe25GCcGM7ciev
	D9/2+1s6f1lgbV5JPXft3zT/TtnKErJ4Uj5SAFYdHpLouOrZt96ieI4IOmzqLWx64gII/bQDkfY
	WaopTOTrsd+hrTPtp58kOgZ/Hp5HoIWtt6oSdDiJanFA=
X-Received: by 2002:a05:6a20:6a08:b0:37e:8eea:3e3f with SMTP id adf61e73a8af0-3898f9c28a9mr16110803637.80.1768224268303;
        Mon, 12 Jan 2026 05:24:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGD9RUhQ3GTJxL2ONxoegYo4Rf5YfwQeYOo30AP0UNkHIJItgroqtE20TpG/pfeVSe07ySt6g==
X-Received: by 2002:a05:6a20:6a08:b0:37e:8eea:3e3f with SMTP id adf61e73a8af0-3898f9c28a9mr16110784637.80.1768224267933;
        Mon, 12 Jan 2026 05:24:27 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:27 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v2 24/32] accel/kvm: add a per-confidential class callback to unlock guest state
Date: Mon, 12 Jan 2026 18:52:37 +0530
Message-ID: <20260112132259.76855-25-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a part of the confidential guest reset process, the existing encrypted guest
state must be made mutable since it would be discarded after reset. A new
encrypted and locked guest state must be established after the reset. To this
end, a new callback per confidential guest support class (eg, tdx or sev-snp)
is added that will indicate whether its possible to rebuild guest state:

bool (*can_rebuild_guest_state)(ConfidentialGuestSupport *cgs)

This api returns true if rebuilding guest state is possible,
false otherwise. A KVM based confidential guest reset is only possible when
the existing state is locked but its possible to rebuild guest state.
Otherwise, the guest is not resettable.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 include/system/confidential-guest-support.h | 27 +++++++++++++++++++++
 system/runstate.c                           | 11 +++++++--
 target/i386/kvm/tdx.c                       |  6 +++++
 target/i386/sev.c                           |  9 +++++++
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/system/confidential-guest-support.h b/include/system/confidential-guest-support.h
index 0cc8b26e64..3c37227263 100644
--- a/include/system/confidential-guest-support.h
+++ b/include/system/confidential-guest-support.h
@@ -152,6 +152,11 @@ typedef struct ConfidentialGuestSupportClass {
      */
     int (*get_mem_map_entry)(int index, ConfidentialGuestMemoryMapEntry *entry,
                              Error **errp);
+
+    /*
+     * is it possible to rebuild the guest state?
+     */
+    bool (*can_rebuild_guest_state)(ConfidentialGuestSupport *cgs);
 } ConfidentialGuestSupportClass;
 
 static inline int confidential_guest_kvm_init(ConfidentialGuestSupport *cgs,
@@ -167,6 +172,28 @@ static inline int confidential_guest_kvm_init(ConfidentialGuestSupport *cgs,
     return 0;
 }
 
+static inline bool
+confidential_guest_can_rebuild_state(ConfidentialGuestSupport *cgs)
+{
+    ConfidentialGuestSupportClass *klass;
+
+    if (!cgs) {
+        /* non-confidential guests */
+        return true;
+    }
+
+    klass = CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs);
+    if (klass->can_rebuild_guest_state) {
+        return klass->can_rebuild_guest_state(cgs);
+    }
+
+    /*
+     * by default, we should not be able to unprotect the
+     * confidential guest state
+     */
+    return false;
+}
+
 static inline int confidential_guest_kvm_reset(ConfidentialGuestSupport *cgs,
                                                Error **errp)
 {
diff --git a/system/runstate.c b/system/runstate.c
index b0ce0410fa..710f5882d9 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -58,6 +58,7 @@
 #include "system/reset.h"
 #include "system/runstate.h"
 #include "system/runstate-action.h"
+#include "system/confidential-guest-support.h"
 #include "system/system.h"
 #include "system/tpm.h"
 #include "trace.h"
@@ -564,7 +565,12 @@ void qemu_system_reset(ShutdownCause reason)
     if (cpus_are_resettable()) {
         cpu_synchronize_all_post_reset();
     } else {
-        assert(runstate_check(RUN_STATE_PRELAUNCH));
+        /*
+         * for confidential guests, cpus are not resettable but their
+         * state can be rebuilt under some conditions.
+         */
+        assert(runstate_check(RUN_STATE_PRELAUNCH) ||
+               (current_machine->cgs && runstate_is_running()));
     }
 
     vm_set_suspended(false);
@@ -713,7 +719,8 @@ void qemu_system_reset_request(ShutdownCause reason)
     if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
         reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
         shutdown_requested = reason;
-    } else if (!cpus_are_resettable()) {
+    } else if (!cpus_are_resettable() &&
+               !confidential_guest_can_rebuild_state(current_machine->cgs)) {
         error_report("cpus are not resettable, terminating");
         shutdown_requested = reason;
     } else {
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 314d316b7c..a89b14d401 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1589,6 +1589,11 @@ static ResettableState *tdx_reset_state(Object *obj)
     return &tdx->reset_state;
 }
 
+static bool tdx_can_rebuild_guest_state(ConfidentialGuestSupport *cgs)
+{
+    return true;
+}
+
 static void tdx_guest_class_init(ObjectClass *oc, const void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
@@ -1596,6 +1601,7 @@ static void tdx_guest_class_init(ObjectClass *oc, const void *data)
     ResettableClass *rc = RESETTABLE_CLASS(oc);
 
     klass->kvm_init = tdx_kvm_init;
+    klass->can_rebuild_guest_state = tdx_can_rebuild_guest_state;
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index d45356843c..c52027c935 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -2632,6 +2632,14 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t *ptr, uint64_t len,
     return -1;
 }
 
+static bool sev_can_rebuild_guest_state(ConfidentialGuestSupport *cgs)
+{
+    if (!sev_snp_enabled() && !sev_es_enabled()) {
+        return false;
+    }
+    return true;
+}
+
 static int cgs_get_mem_map_entry(int index,
                                  ConfidentialGuestMemoryMapEntry *entry,
                                  Error **errp)
@@ -2806,6 +2814,7 @@ sev_common_instance_init(Object *obj)
     cgs->set_guest_state = cgs_set_guest_state;
     cgs->get_mem_map_entry = cgs_get_mem_map_entry;
     cgs->set_guest_policy = cgs_set_guest_policy;
+    cgs->can_rebuild_guest_state = sev_can_rebuild_guest_state;
 
     qemu_register_resettable(OBJECT(sev_common));
 
-- 
2.42.0


