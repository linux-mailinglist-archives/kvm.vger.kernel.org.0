Return-Path: <kvm+bounces-23670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C2094C97D
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEC25B22536
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 05:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CA216849F;
	Fri,  9 Aug 2024 05:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJ5R7ync"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215F3168483
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 05:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723180291; cv=none; b=RHYjST/LYVX7f0HLCRV8SGOi+QJzKAeVour6LHvKzphmCAttarbBft2dak+ljoKLeveLwHf1MEfXgtig0cvOX7t8i6o44qPjuAfbnLbUEnZvmDMoFjE/DUlgY3GRJKh9Py8dKLEIKPGyUcCnEnt5p6BkSeuPkRXneFEkV3vBLbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723180291; c=relaxed/simple;
	bh=MG7Dvd7d5o4SUT0LE/qpNly4u3rkW8VpI+lEYJrow8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMHk2D146muICCAu5IFTX0eqlgGTOI589iYt1Qmn+yrBOosh+xjeFmfa3bC+2WWgYLZFLzZqPiub55r28bNseM0ofIOdK2V5wwz0Q5O6soNFpyhNKNvgOwj0I2HgmgZu8EI2afKKSa3wJGoDUs94Q0Kn8iimPX0sjrRHISG467M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJ5R7ync; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723180287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VFVzUlNsVsXQ/Du+Ve53FGF58OzF7Hoq8mZruS9vw88=;
	b=MJ5R7yncd2dyLWpMyjJsl0P76U/xQ+Eh5xEeioheeC/kTON2vTa0xngs1bAm//7Lj4IrU2
	MS+JUBb7emZUW/R5KzVTOmmeU6D7l/JAozHb+1KuAnIYuCXFXMp6Drt16SQZa17MGJ+USg
	Oq3QYy+aKW5QUv7XRlQU3gz4C1ZYUzc=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-rZ4QnyVFPzSLHzhr9d_a-w-1; Fri, 09 Aug 2024 01:11:26 -0400
X-MC-Unique: rZ4QnyVFPzSLHzhr9d_a-w-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-672bea19bedso39999237b3.3
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 22:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723180285; x=1723785085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VFVzUlNsVsXQ/Du+Ve53FGF58OzF7Hoq8mZruS9vw88=;
        b=VrT3otkAyN9fPqL9IO16sLvWH+9KJDGXCc+7LtfTFqqmUhV9pyv09jdcqYV1F0LWoS
         DYBRRbrAby1bly0gBlsXS+ezPn3NKLi4gp0A3qgD4tDxc8vN2IB1FdhyEp4RSG87Q0jJ
         C4z+Dh22sy3JZqHW+87MbMh5Qo/q9+kbNLyqUrn6gYytuV08gjF/L4vPmpeW2stlFLXy
         DPW7Ku5H5gh8JKa9tnl79h5Xy5gXAmI75g0ZJTkhXsYmSRa31u2j/skbiAtKIZuGNOat
         qYKCzWHe3noLzqDCVr0f0vIAUhQ5V3pwH2giA6k1W9YU+0r3r9H929tobmVldRpGz77b
         /puw==
X-Forwarded-Encrypted: i=1; AJvYcCXzj4tuaqVnAFE4/rGsgC9oxAuXhTM4l7BUk0OlxUhoDTDGq0jK6FCwWf906Jk/Y2sCUVT0svD9VF2YUs2lfTavsj4U
X-Gm-Message-State: AOJu0YxwTKKxhxJ40DLvbK/0HKe9Ug9cJV0Nz+NqhftbDnjlJehSKTIK
	zlhlqOzM1QqzMYZz1vqJOr/OBybQfiS2hRDdpD4vk6i8eju2g9HqmnYxCwnBHCAYUhYmGInAPEg
	LPan7u51F5+YsC9dPMSAUM6Mvhl3TZ2TBQFwosDaiCOFKXqQMrQ==
X-Received: by 2002:a05:690c:4292:b0:651:6888:a018 with SMTP id 00721157ae682-69ec5f414d7mr4786097b3.26.1723180285576;
        Thu, 08 Aug 2024 22:11:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESxQ+gkuExf9qc7vHUqL759aFOHOfgP2U0oqXC1HAlKJzIsPV8FKQvsxiLnMad+g7fVVCucA==
X-Received: by 2002:a05:690c:4292:b0:651:6888:a018 with SMTP id 00721157ae682-69ec5f414d7mr4785867b3.26.1723180285247;
        Thu, 08 Aug 2024 22:11:25 -0700 (PDT)
Received: from localhost.localdomain ([115.96.114.241])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-710cb2e52bfsm1961777b3a.145.2024.08.08.22.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 22:11:24 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	zhao1.liu@intel.com,
	cfontana@suse.de,
	qemu-trivial@nongnu.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 2/2] kvm: refactor core virtual machine creation into its own function
Date: Fri,  9 Aug 2024 10:40:54 +0530
Message-ID: <20240809051054.1745641-3-anisinha@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240809051054.1745641-1-anisinha@redhat.com>
References: <20240809051054.1745641-1-anisinha@redhat.com>
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
 accel/kvm/kvm-all.c | 86 ++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 33 deletions(-)

changelog:
v2: s/fprintf/warn_report as suggested by zhao
v3: s/warn_report/error_report. function names adjusted to conform to
other names. fprintf -> error_report() moved to its own patch.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index ac168b9663..610b3ead32 100644
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
@@ -2467,45 +2518,14 @@ static int kvm_init(MachineState *ms)
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
         goto err;
     }
 
-- 
2.45.2


