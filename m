Return-Path: <kvm+bounces-23611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C397A94BB2D
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 12:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76E831F21B42
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 10:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CBC18A6C7;
	Thu,  8 Aug 2024 10:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TwK4ugR/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720A418A6B8
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 10:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723113279; cv=none; b=mRoDPGNaPD0GrSGIo+OFX48vNqkH8UAfNpRB+Rljt/28+ad+gNszLjQmerc4Ti/mZPDI1nmJKIh87tRA9PLPbncoaH86B4hhp9k6f8t+PUe5jZ+opbdTk/azbGZGISzt31ymOTj/OPuflfW3VFqEbCgp9xbzkw+WHsimi85Ce3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723113279; c=relaxed/simple;
	bh=+/cNCLUs8Dgsr0cDh0FAwg93H1ykaEsD0NEY4JlujXM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aW+ND89k8A7E33HowGiGvXiPDNs7K/XMUauyBWSQYYrD+9WxYLyP1sL780pRlZ6hX1mjUCpgoztKzTS18L5xnrXgP2e103X5nj5FiqmoeVGOe0KSl8b7gSt6i2raPslP2khra3ZQKngweFf5epqYNSOAScj3jse9bd5qlPq0dNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TwK4ugR/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723113276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3jp20j69AOkCh4ksiug+Aiw4wNRR8vEVdoqWHRD95fw=;
	b=TwK4ugR/PtK4FqoCZZ7TYtUdce2gnYl6u1MEX5FQCQe8SNJgv6dWztbsusDFTdNwMMTyt4
	1Cctm1ryuoQb5FEV21HqZuwfODbyRDogoKgysm9ZICmmbmY0Jiot3Z1tPuBd1BZ1DtNczu
	Vj2Anrc+UIAy4uzd7wQQPu0mjHNoSMU=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-XFRneSLZOme5ycr9lpf9Hw-1; Thu, 08 Aug 2024 06:34:35 -0400
X-MC-Unique: XFRneSLZOme5ycr9lpf9Hw-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-70d1c8d98baso977651b3a.3
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 03:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723113274; x=1723718074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jp20j69AOkCh4ksiug+Aiw4wNRR8vEVdoqWHRD95fw=;
        b=m6H9TXTgKUjan4cy78WlM2fYD1XiTzmv3oz6jxBpD5d+55S4Vycgt28oDQYOosTNmb
         NaMOQ2IrVgFh47Afy+x2EKWtV1abKMVuZlv9YqajM9AvZa7Ug6RSypvJB+IlubB9hgLG
         RU/yvEzSGXbp8KXSds2kcMcIUi7DdWROGdOgx9e9eYKOCG8qMvd7L2XmnKHcuOrFrIDL
         kMRsjHdCT4FV83vRZoLUaOdWzmoEP2SM0U7BQBcxhPcEaRFKSa+K9i4wBcRmIK5Jzoal
         ES5jx0Kqgsglb09aH9ip7iN2JmUE6/+RDs1GRuRlaI6VyZaVJ9nvVkjMTYvCqXK5NDqI
         HaFw==
X-Forwarded-Encrypted: i=1; AJvYcCX7EyiSjtGKVUacIhxTRSWbAEwiPAe4rLxZXPkE50DDVnnz+NTj4RS4mAJrNcHEFBZONrgv3KeiJJMK6yn9B86u+Mdw
X-Gm-Message-State: AOJu0Yxr82LpIc+f5wTKX9KVpLPOVt2AaPmN/mYYdLk2NymXrzjfuDlC
	ISdqyBGI3GtzlXAdOMqsqu34UIrQxP4cI51o9ffDPSEsv4HbS3Yol39kuvAX9eW/RK9UDf0b82T
	zd4Wgy25qBuICf4PTC4SnPx1onGv5sH18w/zwTYiKdxZEJOxnKg==
X-Received: by 2002:a05:6a00:2293:b0:70b:2efd:7bee with SMTP id d2e1a72fcca58-710cae1c228mr1847949b3a.21.1723113273920;
        Thu, 08 Aug 2024 03:34:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPLc3kXqGoPqUMUK2UiRu0w2H2clgC5tCMbLgI/76PbvADokfZOrDKqq7qkameuDjloxqOaQ==
X-Received: by 2002:a05:6a00:2293:b0:70b:2efd:7bee with SMTP id d2e1a72fcca58-710cae1c228mr1847928b3a.21.1723113273466;
        Thu, 08 Aug 2024 03:34:33 -0700 (PDT)
Received: from localhost.localdomain ([115.96.146.217])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-710cb20a175sm909127b3a.16.2024.08.08.03.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 03:34:32 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH] kvm: refactor core virtual machine creation into its own function
Date: Thu,  8 Aug 2024 16:03:36 +0530
Message-ID: <20240808103336.1675148-1-anisinha@redhat.com>
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
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 97 ++++++++++++++++++++++++++++-----------------
 1 file changed, 60 insertions(+), 37 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..2bcd00126a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2385,6 +2385,64 @@ uint32_t kvm_dirty_ring_size(void)
     return kvm_state->kvm_dirty_ring_size;
 }
 
+static int do_create_vm(MachineState *ms, int type)
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
+        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
+                strerror(-ret));
+
+#ifdef TARGET_S390X
+        if (ret == -EINVAL) {
+            fprintf(stderr,
+                    "Host kernel setup problem detected. Please verify:\n");
+            fprintf(stderr, "- for kernels supporting the switch_amode or"
+                    " user_mode parameters, whether\n");
+            fprintf(stderr,
+                    "  user space is running in primary address space\n");
+            fprintf(stderr,
+                    "- for kernels supporting the vm.allocate_pgste sysctl, "
+                    "whether it is enabled\n");
+        }
+#elif defined(TARGET_PPC)
+        if (ret == -EINVAL) {
+            fprintf(stderr,
+                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
+                    (type == 2) ? "pr" : "hv");
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
@@ -2467,49 +2525,14 @@ static int kvm_init(MachineState *ms)
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
+    ret = do_create_vm(ms, type);
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


