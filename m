Return-Path: <kvm+bounces-67742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 63D10D12C42
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 04482300AC91
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41413587A1;
	Mon, 12 Jan 2026 13:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VvYyC24B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="H0ofkHsn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792CC359F90
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224247; cv=none; b=mDevDt5o6I8m4CLiEgr3sLlTt+mhwxAWkmFxOJ35EQ3HUGbVI8wUkeOtXSJMajHUT+37X2KFxhB5xzi93shHR9zo6+4ZI9+e28wqqHso3H/707tY8orVx351ynsrufgv/bYNxFWUZ89Ay2py99HdYYjfue9okQIOyc5KQQTlM/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224247; c=relaxed/simple;
	bh=zWsrXYWWEkoJdqLkkbnziYQbUVeU+5LUmPp+25RTJ1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMZRYPQVQM03Ml5kboTqhfg4O/OYm6m52jVoVvGUGfz39vroLNSXjdSPQx/lwVMyeF6FCMksOu0Fq0NIHqoor9uglc+i4MfcleQsB/oHCj1UwkFwuQFsxpWCKI9XWnmWglgcBtca8X6ZAsCF+GBJrYhnNyntcPAHzhqDKQvkVXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VvYyC24B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=H0ofkHsn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=re0muZmMrtqo8EWO5a5L2LHVK2cH9w5XVHhtUQzVCdc=;
	b=VvYyC24BdqmIrXz7Drcs7jT5i4u2nk0zQFCMvAx0ycanW0lzfaOfiI6j8dQ/agxNHjlRzo
	5nF+nlsmKL3UNQBwLFWVMq4ZQ/LrjwlDwxG36CYVYbDZawqCR7ES9ft+xjD8TbsxBOzxlV
	SZRfRgLMSqj6ErtGeHka1NiM33am/S4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-inKOpTgpN5uv92oe9684OA-1; Mon, 12 Jan 2026 08:24:04 -0500
X-MC-Unique: inKOpTgpN5uv92oe9684OA-1
X-Mimecast-MFC-AGG-ID: inKOpTgpN5uv92oe9684OA_1768224243
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29f177f4d02so70927445ad.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224243; x=1768829043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=re0muZmMrtqo8EWO5a5L2LHVK2cH9w5XVHhtUQzVCdc=;
        b=H0ofkHsn10KzMlZpx76KEGiTLnAegJ2no3SFvjacCUo404AtHPV+yDapt0y2SvOUnI
         QvNK4MUHFUCMfMF9lkhJGLkim2MH1KFSoZ7VSV2LPMSCpTPeECVvbAfgDQ0UC2bMsA51
         5akPiC+jgNDyBTLMi2Er5azrV/cRCjZF8JZMFav2iUQiIfdfEHYCiwrcUdtTP0PMFxg5
         iNZLVujQVVjkzO73RKVA5JlAEUAKGqJU1rK21ded/5J/KMjMbZ+6Y4tXy9/XIwMKHZt2
         dL9rlkUmFLro1t/bcHDgpWzax9yW/2qxgKv1x3jLDNLat9Ejmxt+Gi/wS7ZaB1p63VRF
         9VBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224243; x=1768829043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=re0muZmMrtqo8EWO5a5L2LHVK2cH9w5XVHhtUQzVCdc=;
        b=c+l6igmk1NpvxVwVF9o/YwSgdzu2pWU5PMM6oytuh/4Qe9Or/pcU069IWFzZiyomYT
         0QoV95uGo+cojqLTy7vh4bS9MpZNwC6++NCjBFzB23qvE26cJwE1v529wBaMfiCm8XNU
         wgDuRmLlr2geeNuXBXvVYwjqmOMMQQ09Wd+YkVVi9TQMu7cThjByUNka3gh0hpFOK5Y5
         V9unCciaIyU3XzwqjeCI7TTxSL3KIGx8svA8TPQbJY0QmM/xVt5GbgUZA5QMD9HWKAx4
         ToFKdVk0bRLIxsp0VaMMdvW3x/tmRKsZcvjGkhpXNVLvbWXeR1MZj4o3x+AlBTzQ7iii
         Hoiw==
X-Forwarded-Encrypted: i=1; AJvYcCUOgXbQoSfsiHNDXqPcXhOnhe6+v43uFVxGKAHoHN8qzcPgqHba+o+fJroayn51LFHXP84=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFz8zHu0ghwht4Gc+DSPR/JhvUO8gBL7ku1LcwR+9vIq83ABXu
	q4mbCBAxxw9yMdtq2ki0he8aaC9LeXeeZ7Z3Cj6y1RbeAMYUPmh57RvVV+bmYKCfNai885LFrI8
	4FUiCcjTQWBzIwNPpad34LO5QglzjgIcOwaGDx1xQlcoraPGnXczs5g==
X-Gm-Gg: AY/fxX7uB44YQeMCdyuwiHMR5MovLSS5UMoqlPl43TowyPw1mYrd7y6PGxqR37Bbq1X
	i6Nv4P/iAAYqrKxYaZmJw1volN/ZoTHdYeMvGnY6h8HRhNQzQDz0t4GAqWYSO6fhE+3PUTi1zQ1
	V/ySv4p8vWrOimX1NaEWL5czEQSzXOMv+cKeBmdNhRnNAtgTN4TzTvdFc8uOgO/Zvd9An3ed3oL
	mCWZaGi2zb2jSWhj7qyvMEUpWUV4sQrO7YHutMveFSxVmd5HygTRKw8QZgF170zD7FLKOo+CQNn
	L9NKuhDbLZxqhm18wYcXcCpHU4hu/EpR+Guzz9rz2CrvZYFHjspFlgjvZmmG3XcEYZhY/b5451e
	US5DcST6wijxcs6siGV8jTXd3nOMa5RrLx4S+u4O0toA=
X-Received: by 2002:a05:6a20:5493:b0:366:14ac:8c6d with SMTP id adf61e73a8af0-3898f9cf622mr16237021637.67.1768224242889;
        Mon, 12 Jan 2026 05:24:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjz1PJMGZym0PSu5C9k8ojaJS95nPXlOCAztYTfHj1g2CJ3fKTkb5Z0vZjd85rOHWGK+xRjg==
X-Received: by 2002:a05:6a20:5493:b0:366:14ac:8c6d with SMTP id adf61e73a8af0-3898f9cf622mr16237004637.67.1768224242460;
        Mon, 12 Jan 2026 05:24:02 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:02 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 14/32] i386/tdx: finalize TDX guest state upon reset
Date: Mon, 12 Jan 2026 18:52:27 +0530
Message-ID: <20260112132259.76855-15-anisinha@redhat.com>
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

When the confidential virtual machine KVM file descriptor changes due to the
guest reset, some TDX specific setup steps needs to be done again. This
includes finalizing the inital guest launch state again. This change
re-executes some parts of the TDX setup during the device reset phaze using a
resettable interface. This finalizes the guest launch state again and locks
it in. Machine done notifier which was previously used is no longer needed as
the same code is now executed as a part of VM reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c        | 38 +++++++++++++++++++++++++++++++-----
 target/i386/kvm/tdx.h        |  1 +
 target/i386/kvm/trace-events |  3 +++
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b595eabb6a..cba07785f7 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,7 @@
 #include "crypto/hash.h"
 #include "system/kvm_int.h"
 #include "system/runstate.h"
+#include "system/reset.h"
 #include "system/system.h"
 #include "system/ramblock.h"
 #include "system/address-spaces.h"
@@ -38,6 +39,7 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 #include "tdx-quote-generator.h"
+#include "trace.h"
 
 #include "standard-headers/asm-x86/kvm_para.h"
 
@@ -389,9 +391,19 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     CONFIDENTIAL_GUEST_SUPPORT(tdx_guest)->ready = true;
 }
 
-static Notifier tdx_machine_done_notify = {
-    .notify = tdx_finalize_vm,
-};
+static void tdx_handle_reset(Object *obj, ResetType type)
+{
+    if (!runstate_is_running() && !phase_check(PHASE_MACHINE_READY)) {
+        return;
+    }
+
+    if (!kvm_enable_hypercall(BIT_ULL(KVM_HC_MAP_GPA_RANGE))) {
+        error_setg(&error_fatal, "KVM_HC_MAP_GPA_RANGE not enabled for guest");
+    }
+
+    tdx_finalize_vm(NULL, NULL);
+    trace_tdx_handle_reset();
+}
 
 /*
  * Some CPUID bits change from fixed1 to configurable bits when TDX module
@@ -738,8 +750,6 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
      */
     kvm_readonly_mem_allowed = false;
 
-    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
-
     tdx_guest = tdx;
     return 0;
 }
@@ -1505,6 +1515,7 @@ OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    TDX_GUEST,
                                    X86_CONFIDENTIAL_GUEST,
                                    { TYPE_USER_CREATABLE },
+                                   { TYPE_RESETTABLE_INTERFACE },
                                    { NULL })
 
 static void tdx_guest_init(Object *obj)
@@ -1538,20 +1549,37 @@ static void tdx_guest_init(Object *obj)
 
     tdx->event_notify_vector = -1;
     tdx->event_notify_apicid = -1;
+    qemu_register_resettable(obj);
 }
 
 static void tdx_guest_finalize(Object *obj)
 {
 }
 
+static ResettableState *tdx_reset_state(Object *obj)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+    return &tdx->reset_state;
+}
+
 static void tdx_guest_class_init(ObjectClass *oc, const void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
+    ResettableClass *rc = RESETTABLE_CLASS(oc);
 
     klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
     x86_klass->check_features = tdx_check_features;
+
+    /*
+     * the exit phase makes sure sev handles reset after all legacy resets
+     * have taken place (in the hold phase) and IGVM has also properly
+     * set up the boot state.
+     */
+    rc->phases.exit = tdx_handle_reset;
+    rc->get_state = tdx_reset_state;
+
 }
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 1c38faf983..264fbe530c 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -70,6 +70,7 @@ typedef struct TdxGuest {
 
     uint32_t event_notify_vector;
     uint32_t event_notify_apicid;
+    ResettableState reset_state;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
diff --git a/target/i386/kvm/trace-events b/target/i386/kvm/trace-events
index 1f4786f687..47473001d8 100644
--- a/target/i386/kvm/trace-events
+++ b/target/i386/kvm/trace-events
@@ -14,3 +14,6 @@ kvm_xen_soft_reset(void) ""
 kvm_xen_set_shared_info(uint64_t gfn) "shared info at gfn 0x%" PRIx64
 kvm_xen_set_vcpu_attr(int cpu, int type, uint64_t gpa) "vcpu attr cpu %d type %d gpa 0x%" PRIx64
 kvm_xen_set_vcpu_callback(int cpu, int vector) "callback vcpu %d vector %d"
+
+# tdx.c
+tdx_handle_reset(void) ""
-- 
2.42.0


