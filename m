Return-Path: <kvm+bounces-67747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A175D12CC9
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:29:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DBD6A3089411
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7040435B126;
	Mon, 12 Jan 2026 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WukuqzMm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tVjHAsP5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F074358D09
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224260; cv=none; b=axfQe+spUTCMBhbBtong6tQkQKpnIxU7Pg+e5MD4CY3pyzqZ6MMFgUMGxYmOl/i5wjtcMeYTRAsw6ALaZBkMv97ksXxMyHg7Re9Mk60QErk3i/IPPNDsj02Rfh/uQaPY5WDgE+vA6kNsS4PYWEkL58EyO2gxi6YTo7ttMW49MbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224260; c=relaxed/simple;
	bh=EYtqalX/+aFTNRpPgvxurbd0P5tT9OQqg3qi7w4Ii8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPCbASixofndKao8Zdyp0/Kx30ajR+Dy2fzuSdjXCYZiqIL6AkAcLbG1dOClIsyCS7qodOl4sSY0WbI/dPDli+8Mm2sSeLgxIQR8huk2HkKQwwmP3lWo9Ba6sUaXILUIqMVqRixKdoRNcOecXS83WsajnFlHeQ+zMmyLlLaCkwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WukuqzMm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tVjHAsP5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Xl2NZDHarHkXqS5yrKrfSXN4c45GQhJC2FoUsQnchs=;
	b=WukuqzMmExHKznFfPea7I23fBOTYPUq1QJJZfPIDTSvsv4FSn6G+yh1Gag8mPG8dhKwxOt
	DHudSQiGRtnjxXEudlCxVKbC4yKXb/dNNrNC7Ev6EcuYxenWEZts+Sext6JwXYuzHi0LZ9
	aqR0qeJ9TMaEVWOHp0j6ZMErKDLWOUw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-OJ7j0vjPMdC3AeGVWcWgyw-1; Mon, 12 Jan 2026 08:24:17 -0500
X-MC-Unique: OJ7j0vjPMdC3AeGVWcWgyw-1
X-Mimecast-MFC-AGG-ID: OJ7j0vjPMdC3AeGVWcWgyw_1768224256
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b609c0f6522so11640882a12.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224256; x=1768829056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Xl2NZDHarHkXqS5yrKrfSXN4c45GQhJC2FoUsQnchs=;
        b=tVjHAsP5n4T6yj09HIz+dUCkUlRNI0/U5WK8mcFcznu0Dkz3tqpBYyWnV0FsVV4IG/
         /INKzOVGuJ7FavyJxr7b+O0EJG26gQGc1zfl7HaBwEC/dTtgaw+iTeMk8qMFfdb8zJT+
         Vz0JGfIRMwMxBiU/htUBZ423oscsYfmls9kW4UsnAEqPxU4Oj9yqz/a/mHcevUdk5wZ1
         V6SS4N8eBpzl49YPdaJvxpBxzJ3hwEh/1mQlWb5V0+HWfaGVFyheSNRFq11OyFmSLALy
         Rmfh6GyV2pcC8vEVdNR9PeOrV2/kbLW3k9eFu5+ek+KRAZHj6zkaoPLJNU5nhTZLxoLw
         FbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224256; x=1768829056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Xl2NZDHarHkXqS5yrKrfSXN4c45GQhJC2FoUsQnchs=;
        b=jLqeWZwY+FBEmAbgzOkUGK3iOdvQ+z3AVrBXEavwzmCGuMSMUxUTXKS9NsZ00mizqe
         xDl2c1umEusLG4g0oZ6kyyyrE5FjcfDZ3nU9GJzrqY7Y331FSshPvciur1mn84a3oN3I
         I7glwisUhtmXzBi8ePmwHxCvws0xcnDk6I7DWnN3INPqZ9rXop9yEkUYsFgtusjpAr2b
         7wPS7AtKaD8I7ohBXn22EuUFsdA4+0fCHal6Knj7KdqVJku7ERxFgJYD39xtZkI7Ca2n
         ON4IJiV88pmxrlKhQGxS7mEJEXPStjx9v7harULyASR1ucJwOJuyiqRzMfsM310MF2zF
         J1Pg==
X-Forwarded-Encrypted: i=1; AJvYcCUUyn9buGYSHYyApfuBhBlprnqz+RgL7L6XRGpYjfouH0YcX2tNFcOP0Ti/r27K6C2wz/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGR7RcXtr4bm5ovap+wD9b+FzAQ0oILBPO8RYCzzHjl7BreApA
	Ad6xn6T9ST2l1A/pv92khYVZPIf9sBBe0mp1tH9wLOhQIbLQZog0WlDVSjAqFO13/HasCV4iWdF
	F3I275IffWZiRFJpT2KLfZIsuNGUx3/wImHOsmpOoe5skNQoeTEKyLA==
X-Gm-Gg: AY/fxX4a4dSHiECG/c21O9TQ1PlWIpGOD2Jyv1Xjmt8nj9mkX5ryMUgRCT7fFqNmok7
	wKnxrwqRGhqTl8z3r1DazgJG7lV5HWuMMY+3LtU7Q3Z5vAgpob/qfY02qP6nRK7SuTbhevu9zZ3
	eCyhAhrMRUgs/oljLPfdY+dqCQUNXlShRxjls3Ux3jEAyv/JL5KSS0vGP8xSXYi083RYreZGvOt
	kZcijA6u/xgqrJeYuUkgoXF10tAzKkg2O1BVDjIblhr+LGgZBK9GlYo9SEYmpUAIEtSeWQt13jr
	xRPgiVnTpMC5aD2+VpDIW/7SS/Ku2fHEZuD142XHRiaDs2PI0Xux96WTA6d+So89B0H0vVP8QOd
	o0KgNemqdnskYNx8wyedavVceEPcRQ3BgnbRqEy4h6aU=
X-Received: by 2002:a05:6a21:3389:b0:364:13e1:10f0 with SMTP id adf61e73a8af0-3898f990467mr15895553637.48.1768224255812;
        Mon, 12 Jan 2026 05:24:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHkV+5Pj+vPwdorDJk/3GEPIk0RVkmzj9pSTKP97TxM+k+HNRr4FYBWDj0fQukT5a54s7G7qw==
X-Received: by 2002:a05:6a21:3389:b0:364:13e1:10f0 with SMTP id adf61e73a8af0-3898f990467mr15895534637.48.1768224255391;
        Mon, 12 Jan 2026 05:24:15 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:15 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 19/32] i386/sev: add support for confidential guest reset
Date: Mon, 12 Jan 2026 18:52:32 +0530
Message-ID: <20260112132259.76855-20-anisinha@redhat.com>
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

When the KVM VM file descriptor changes as a part of the confidential guest
reset mechanism, it necessary to create a new confidential guest context and
re-encrypt the VM memeory. This happens for SEV-ES and SEV-SNP virtual machines
as a part of SEV_LAUNCH_FINISH, SEV_SNP_LAUNCH_FINISH operations.

A new resettable interface for SEV module has been added. A new reset callback
for the reset 'exit' state has been implemented to perform the above operations
when the VM file descriptor has changed during VM reset.

Tracepoints has been added also for tracing purpose.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c        | 52 ++++++++++++++++++++++++++++++++++++++++
 target/i386/trace-events |  1 +
 2 files changed, 53 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index d7425dde96..d45356843c 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -30,8 +30,10 @@
 #include "system/kvm.h"
 #include "kvm/kvm_i386.h"
 #include "sev.h"
+#include "system/cpus.h"
 #include "system/system.h"
 #include "system/runstate.h"
+#include "system/reset.h"
 #include "trace.h"
 #include "migration/blocker.h"
 #include "qom/object.h"
@@ -85,6 +87,10 @@ typedef struct QEMU_PACKED PaddedSevHashTable {
     uint8_t padding[ROUND_UP(sizeof(SevHashTable), 16) - sizeof(SevHashTable)];
 } PaddedSevHashTable;
 
+static void sev_handle_reset(Object *obj, ResetType type);
+
+SevKernelLoaderContext sev_load_ctx = {};
+
 QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
 
 #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
@@ -128,6 +134,7 @@ struct SevCommonState {
     uint8_t build_id;
     int sev_fd;
     SevState state;
+    ResettableState reset_state;
 
     QTAILQ_HEAD(, SevLaunchVmsa) launch_vmsa;
 };
@@ -1984,6 +1991,38 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     return 0;
 }
 
+/*
+ * handle sev vm reset
+ */
+static void sev_handle_reset(Object *obj, ResetType type)
+{
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(sev_common);
+
+    if (!sev_common) {
+        return;
+    }
+
+    if (!runstate_is_running()) {
+        return;
+    }
+
+    sev_add_kernel_loader_hashes(&sev_load_ctx, &error_fatal);
+    if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
+        /* this calls sev_snp_launch_finish() etc */
+        klass->launch_finish(sev_common);
+    }
+
+    trace_sev_handle_reset();
+    return;
+}
+
+static ResettableState *sev_reset_state(Object *obj)
+{
+    SevCommonState *sev_common = SEV_COMMON(obj);
+    return &sev_common->reset_state;
+}
+
 int
 sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
 {
@@ -2462,6 +2501,8 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
         return false;
     }
 
+    /* save the context here so that it can be re-used when vm is reset */
+    memcpy(&sev_load_ctx, ctx, sizeof(*ctx));
     return klass->build_kernel_loader_hashes(sev_common, area, ctx, errp);
 }
 
@@ -2722,8 +2763,16 @@ static void
 sev_common_class_init(ObjectClass *oc, const void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
+    ResettableClass *rc = RESETTABLE_CLASS(oc);
 
     klass->kvm_init = sev_common_kvm_init;
+    /*
+     * the exit phase makes sure sev handles reset after all legacy resets
+     * have taken place (in the hold phase) and IGVM has also properly
+     * set up the boot state.
+     */
+    rc->phases.exit = sev_handle_reset;
+    rc->get_state = sev_reset_state;
 
     object_class_property_add_str(oc, "sev-device",
                                   sev_common_get_sev_device,
@@ -2758,6 +2807,8 @@ sev_common_instance_init(Object *obj)
     cgs->get_mem_map_entry = cgs_get_mem_map_entry;
     cgs->set_guest_policy = cgs_set_guest_policy;
 
+    qemu_register_resettable(OBJECT(sev_common));
+
     QTAILQ_INIT(&sev_common->launch_vmsa);
 
     /* add migration blocker */
@@ -2779,6 +2830,7 @@ static const TypeInfo sev_common_info = {
     .abstract = true,
     .interfaces = (const InterfaceInfo[]) {
         { TYPE_USER_CREATABLE },
+        { TYPE_RESETTABLE_INTERFACE },
         { }
     }
 };
diff --git a/target/i386/trace-events b/target/i386/trace-events
index 51301673f0..b320f655ee 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -14,3 +14,4 @@ kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data
 kvm_sev_snp_launch_start(uint64_t policy, char *gosvw) "policy 0x%" PRIx64 " gosvw %s"
 kvm_sev_snp_launch_update(uint64_t src, uint64_t gpa, uint64_t len, const char *type) "src 0x%" PRIx64 " gpa 0x%" PRIx64 " len 0x%" PRIx64 " (%s page)"
 kvm_sev_snp_launch_finish(char *id_block, char *id_auth, char *host_data) "id_block %s id_auth %s host_data %s"
+sev_handle_reset(void) ""
-- 
2.42.0


