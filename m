Return-Path: <kvm+bounces-23614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D5E994BC66
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 13:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C8EE285F48
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 11:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C41818B486;
	Thu,  8 Aug 2024 11:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QovoMGOO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA1513A257
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 11:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723117145; cv=none; b=UqPnGIRskikkmFYUaFkEteyVl8dqqo3HLyK6UtOCN6vAZLUkbl/7WBafBnzsCu5PhT5tjL2vShuv5SUDme/W353SwewxcNkgjV2kNy93b9l5+kelOn1AXI6b1dmIbhoI1RaTb0FXlKBBQDTZX+k+v6d3WRYSR+W2IcyOI0fjiW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723117145; c=relaxed/simple;
	bh=2yJX9Pd0EIxgWv4hkKRGi6Y8zjXSU7rLIm993cp6jLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=olyLJwnSgDulxBE9ebrCaMVHa3NBMH2qI6e3LDAfik8EwOMYS8I0FXSj2nO81acoubh1EOMG67B9ARLwPtHLk9iglQBrEIBJfhLMoWemdZDjjU+/OZaJmD7Wxqe+9tI7R1zreCs0tgCUR+jmnkgiLeP0cRkFg8E0m3tQ1RiLETk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QovoMGOO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723117142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nXtLRQ2oPUYqp5KSsNYob3Fl3+peknmF9tE6ROEjpF0=;
	b=QovoMGOOis+SyzHiL7gU4x5CaQTGkHWvzpp3SCg04M+XrAfoKc8V1mmJ8NFux1f0c6gADT
	b6sggyDEE8ocutvF904sucNoLb3s6mCdaJDJDqW/z4HIb6LOniykDrQIxx9zh6aO9d6Kz9
	MldBRtzruvGYfDdVyOIaoNo8Mwe+VOc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-1VIOtUPdN8ewyFq5B6hPvQ-1; Thu, 08 Aug 2024 07:38:58 -0400
X-MC-Unique: 1VIOtUPdN8ewyFq5B6hPvQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1fc6f3ac7beso8965505ad.1
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 04:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723117138; x=1723721938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nXtLRQ2oPUYqp5KSsNYob3Fl3+peknmF9tE6ROEjpF0=;
        b=MSXquztzBE7de+ej7tngzGCt0UJt5IZsuFgfwMwA+C/35BDSG2KzP69vJZkH9trJZd
         wzx4ys2fKk8r0qh2m3RQ0GPRef1GN3iNWJJKz7PVVTax8/c70Heyo9b0ju95SmL8pp7n
         pKiUNn6bl4yUlCSNPm6cm12P8WlEj+ms4Zz+GZRRsyEZ9n44dmW0uFsRB1F6N9n8Z01U
         dvle5p9vPyHnxBDzkppWCjQUZ7nAY4aW+3O0sQbbPLycLoRWpEYDLhaXM7JXCI2Bpos6
         8EBdCphC7mM03ic8AjbVCImzNwbm4T2nmpfA4DKpJaZnMfcvTzBXyX9y9+IGWvdHo2ig
         E9oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDU6YePeRf3zykLTen5xj899fi5HNuna6wVVJAAKa3P2A17g7qAW5f1evR96wC4R51uGRO3zQZaXeK7x1B3Uhb1T3A
X-Gm-Message-State: AOJu0YzZqcWFuf34ilNwECcnIOFa74xWReCEMUPnD9/JnLlZ7TNBYefh
	2htp/5jFd1fzSifsknvnkBrF3ItiK3sIQU1s2jJIQlUiufdfHveqM6tUzDoUnmJkMxXWXxRE6fe
	oiUXg5CL1JRoVk3B41kBhdftG7ocha+zI5sIGMRzsD2mUKvFVcQ==
X-Received: by 2002:a17:902:ced2:b0:1fc:726e:15b4 with SMTP id d9443c01a7336-2009525ebf4mr20323275ad.28.1723117137758;
        Thu, 08 Aug 2024 04:38:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvVFaLF9oQkLVng5OH4Ty0GBNS1LouM5Ox2xgGRWOluP8qj8etxA0d22WlIXoCbwu3GvQ+wA==
X-Received: by 2002:a17:902:ced2:b0:1fc:726e:15b4 with SMTP id d9443c01a7336-2009525ebf4mr20323025ad.28.1723117137292;
        Thu, 08 Aug 2024 04:38:57 -0700 (PDT)
Received: from localhost.localdomain ([115.96.146.217])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1ff58f19efdsm122143365ad.31.2024.08.08.04.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 04:38:56 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	zhao1.liu@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2] kvm: refactor core virtual machine creation into its own function
Date: Thu,  8 Aug 2024 17:08:38 +0530
Message-ID: <20240808113838.1697366-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactoring the core logic around KVM_CREATE_VM into its own separate function
so that it can be called from other functions in subsequent patches. There is
no functional change in this patch.

CC: pbonzini@redhat.com
CC: zhao1.liu@intel.com
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 93 +++++++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 37 deletions(-)

changelog:
v2: s/fprintf/warn_report as suggested by zhao

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..c2e177c39f 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2385,6 +2385,60 @@ uint32_t kvm_dirty_ring_size(void)
     return kvm_state->kvm_dirty_ring_size;
 }
 
+static int do_kvm_create_vm(MachineState *ms, int type)
+{
+    KVMState *s;
+    int ret;
+
+    s = KVM_STATE(ms->accelerator);
+
+    do {
+        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
+    } while (ret == -EINTR);
+
+    if (ret < 0) {
+        warn_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
+                    strerror(-ret));
+
+#ifdef TARGET_S390X
+        if (ret == -EINVAL) {
+            warn_report("Host kernel setup problem detected. Please verify:");
+            warn_report("- for kernels supporting the switch_amode or"
+                        " user_mode parameters, whether");
+            warn_report("  user space is running in primary address space");
+            warn_report("- for kernels supporting the vm.allocate_pgste "
+                        "sysctl, whether it is enabled");
+        }
+#elif defined(TARGET_PPC)
+        if (ret == -EINVAL) {
+            warn_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
+                        (type == 2) ? "pr" : "hv");
+        }
+#endif
+    }
+
+    return ret;
+}
+
+static int find_kvm_machine_type(MachineState *ms)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+    int type;
+
+    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
+        g_autofree char *kvm_type;
+        kvm_type = object_property_get_str(OBJECT(current_machine),
+                                           "kvm-type",
+                                           &error_abort);
+        type = mc->kvm_type(ms, kvm_type);
+    } else if (mc->kvm_type) {
+        type = mc->kvm_type(ms, NULL);
+    } else {
+        type = kvm_arch_get_default_type(ms);
+    }
+    return type;
+}
+
 static int kvm_init(MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
@@ -2467,49 +2521,14 @@ static int kvm_init(MachineState *ms)
     }
     s->as = g_new0(struct KVMAs, s->nr_as);
 
-    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
-        g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
-                                                            "kvm-type",
-                                                            &error_abort);
-        type = mc->kvm_type(ms, kvm_type);
-    } else if (mc->kvm_type) {
-        type = mc->kvm_type(ms, NULL);
-    } else {
-        type = kvm_arch_get_default_type(ms);
-    }
-
+    type = find_kvm_machine_type(ms);
     if (type < 0) {
         ret = -EINVAL;
         goto err;
     }
 
-    do {
-        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
-    } while (ret == -EINTR);
-
+    ret = do_kvm_create_vm(ms, type);
     if (ret < 0) {
-        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
-                strerror(-ret));
-
-#ifdef TARGET_S390X
-        if (ret == -EINVAL) {
-            fprintf(stderr,
-                    "Host kernel setup problem detected. Please verify:\n");
-            fprintf(stderr, "- for kernels supporting the switch_amode or"
-                    " user_mode parameters, whether\n");
-            fprintf(stderr,
-                    "  user space is running in primary address space\n");
-            fprintf(stderr,
-                    "- for kernels supporting the vm.allocate_pgste sysctl, "
-                    "whether it is enabled\n");
-        }
-#elif defined(TARGET_PPC)
-        if (ret == -EINVAL) {
-            fprintf(stderr,
-                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
-                    (type == 2) ? "pr" : "hv");
-        }
-#endif
         goto err;
     }
 
-- 
2.45.2


