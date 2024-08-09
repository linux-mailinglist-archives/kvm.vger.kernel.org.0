Return-Path: <kvm+bounces-23667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 739BB94C96B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 06:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01FF31F25101
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 04:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66CDF167DB8;
	Fri,  9 Aug 2024 04:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="av5wUfbq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B14167D83
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 04:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723179227; cv=none; b=TM0C3ISLfDPAuhhoWiJdSRJlr9WWdb/ayuyqsDE6HWOGMRe2nfjiSEw6Y2JyaCgOPfit1VxvHNXAUMVEAMcWgQzjgI8b8OoZH5UolM7SUFoobv7MD42caN0NY4lDF2W/ljJwmO7kRnmbfJF5yTG1w+9DFJUWC5nP+siEzQqOvvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723179227; c=relaxed/simple;
	bh=rDNEov/cRhEnGQ7pld5Hbi6C7dXUskxK8d7UN6XaKPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKUnx5Ly0Idg2gQKS7TpX+J/rQ35WakufGeWmCxXwMCvI17pKLVQID8t+XBSJVhJLtp7H0fQ9aFSi2+dKbZRF1RolOw975h3bRsgiSCWgaKhIU8smDhI3K5R9ZHSPxS2mNZF5nX1T/Xavx3ax0cnB07KGrtwUE8vrBKgSsOHPJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=av5wUfbq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723179224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6y/Dx9WfBuoEyBP+LUel142LcScGzpkHOUr2wWRP0X0=;
	b=av5wUfbqQC4nVhcbRv4gRqZbgF/5L67UJOTOlGMQH+zOgWAnXK3myuGjCyGRnq2F8bImKf
	Fho/yk6216Q3WMe0iOleT7ijs4jNwnupSGSAHsXnELlwlq+TUNeAyyd1Co2eO50xHaPjxz
	M74trJ8SyZc+qGn3xH491P+U6yvYwbw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-wZqBIn-jMfOqhplCEjS5wg-1; Fri, 09 Aug 2024 00:53:42 -0400
X-MC-Unique: wZqBIn-jMfOqhplCEjS5wg-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-7a242496897so1749010a12.2
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 21:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723179221; x=1723784021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6y/Dx9WfBuoEyBP+LUel142LcScGzpkHOUr2wWRP0X0=;
        b=D0mqc90u8r8ozUhNo5OABmDbenJqSxFUSIhl7AeLHGfgPEW1q7VmKKdYNyron1WoIP
         wD8vwCFwBSt39x3ldw6SDVqUWal6HCout6I+1jDeBN/foFHh5qjlbn+fl03BFyaHaoTU
         Pe1KfvLanart7iAQY8N2EHLDfdPJsDmNiW5ILI5YALn9xpjAWc/f4fR+sG4GmZIHuATW
         Pr1LHF7F75tXUA6shEpAZwIjNWHa3A+inTEYwSX6BxQaZ8ETnPEd9TKtpJwZWlcxbY2I
         wv+wQ8rJyirqh7XO7MhNRmBkXzH6KBRl8eQMUNr8ChXJzPOc2/72Kr63RVsR39d/sHZb
         50CQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtT7M11zyrg9TNnsFDB4qhcfXuhM1mLdCIO5i4bDtuPEAn+iQHvaL29VyL1Di/lwRyVRFvHvhchcWQa0Ayd9PxKa++
X-Gm-Message-State: AOJu0YyoI2PG2LvZX5T477YOAgHYVo+zWYtETF600UOeYV6h1tqwwuos
	WbKOpBq6YvXNkKtdoArPyLfemMl6gY7RRFsTPsLjNPvVJMvAYdzRbsvbP0YIEP0O5EE9/rWd3Ke
	kh8Bnue/qHgd9xjgM5hLOxK1C9QqxhR/MwpqgQk8HI9KH4ohC5g==
X-Received: by 2002:a05:6a21:458a:b0:1c4:8650:d6d7 with SMTP id adf61e73a8af0-1c89fec2cd2mr507346637.16.1723179221102;
        Thu, 08 Aug 2024 21:53:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7CZUoFnBycRjnM0orNNjv+/SuxPUpkqJGSE9wtp9gfcdEF73syhQeo7PZom0vG5inUvKBJQ==
X-Received: by 2002:a05:6a21:458a:b0:1c4:8650:d6d7 with SMTP id adf61e73a8af0-1c89fec2cd2mr507328637.16.1723179220671;
        Thu, 08 Aug 2024 21:53:40 -0700 (PDT)
Received: from localhost.localdomain ([115.96.114.241])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1ff58f6a540sm133516895ad.118.2024.08.08.21.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 21:53:40 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	zhao1.liu@intel.com,
	cfontana@suse.de,
	qemu-trivial@nongnu.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 2/2] kvm: refactor core virtual machine creation into its own function
Date: Fri,  9 Aug 2024 10:21:53 +0530
Message-ID: <20240809045153.1744397-3-anisinha@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240809045153.1744397-1-anisinha@redhat.com>
References: <20240809045153.1744397-1-anisinha@redhat.com>
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
CC: cfontana@suse.de
CC: qemu-trivial@nongnu.org
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 88 +++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 34 deletions(-)

changelog:
v2: s/fprintf/warn_report as suggested by zhao
v3: s/warn_report/error_report. function names adjusted to conform to
other names. fprintf -> error_report() moved to its own patch.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 899b5264e3..610b3ead32 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2385,6 +2385,57 @@ uint32_t kvm_dirty_ring_size(void)
     return kvm_state->kvm_dirty_ring_size;
 }
 
+static int kvm_create_vm(MachineState *ms, KVMState *s, int type)
+{
+    int ret;
+
+    do {
+        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
+    } while (ret == -EINTR);
+
+    if (ret < 0) {
+        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
+                    strerror(-ret));
+
+#ifdef TARGET_S390X
+        if (ret == -EINVAL) {
+            error_report("Host kernel setup problem detected. Please verify:");
+            error_report("- for kernels supporting the switch_amode or"
+                        " user_mode parameters, whether");
+            error_report("  user space is running in primary address space");
+            error_report("- for kernels supporting the vm.allocate_pgste "
+                        "sysctl, whether it is enabled");
+        }
+#elif defined(TARGET_PPC)
+        if (ret == -EINVAL) {
+            error_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
+                        (type == 2) ? "pr" : "hv");
+        }
+#endif
+    }
+
+    return ret;
+}
+
+static int kvm_machine_type(MachineState *ms)
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
@@ -2467,47 +2518,16 @@ static int kvm_init(MachineState *ms)
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
+    type = kvm_machine_type(ms);
     if (type < 0) {
         ret = -EINVAL;
         goto err;
     }
 
-    do {
-        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
-    } while (ret == -EINTR);
-
+    ret = kvm_create_vm(ms, s, type);
     if (ret < 0) {
-        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
-                    strerror(-ret));
-
-#ifdef TARGET_S390X
-        if (ret == -EINVAL) {
-            error_report("Host kernel setup problem detected. Please verify:");
-            error_report("- for kernels supporting the switch_amode or"
-                        " user_mode parameters, whether");
-            error_report("  user space is running in primary address space");
-            error_report("- for kernels supporting the vm.allocate_pgste "
-                        "sysctl, whether it is enabled");
-        }
-#elif defined(TARGET_PPC)
-        if (ret == -EINVAL) {
-            error_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
-                        (type == 2) ? "pr" : "hv");
-        }
-#endif
-    }
         goto err;
+    }
 
     s->vmfd = ret;
 
-- 
2.45.2


