Return-Path: <kvm+bounces-23676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D3AD94CACD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 08:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 243C9280F81
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 06:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC9A16D338;
	Fri,  9 Aug 2024 06:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="audfpNKx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A181B964
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 06:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723186256; cv=none; b=hdhaqpxyWIH7NmT5hlx0HOcYDNyTNa4k3hSXmnHG01ZUpNR94wpSIt0KU3kCT9qV1ksR5U4EnCTEkIv04DHLPj8ZZeQgeexrmXBvgmb36Un2SYcavNqt/oHri4TJZuil4ejkjFL9ch3L1JOSkb6ztv/wuXDhEYq56vIZvVyOax8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723186256; c=relaxed/simple;
	bh=WgnEv3yJM/b0SXErt4w412lNbrK+7Cg/w0YpaWPvsf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rm83xaxcyLe6dcY4Hz+/a1HSz9d7b6TohH75yNQrhgSbgup9piln19MNg6N0QV54+vcfX9w1pr/6CbcHf5vt8P4VCIIzp6ZsNnKlR7sZVBycxp+oRxSACyjoQRPN26o2F4JZ41NTrTEiDuavxfMT4h1SkoMEdoj1veLC8oh0RXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=audfpNKx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723186253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r7Z50sX7S2lP3FksAHizbuHlweuHnvbw/fal6Z+4SqY=;
	b=audfpNKx3ob2z/psZ+ImdkblfVY4xvAk8WasTznH7PkFNXYNznwRUBB02m2jaIMnyOe/oR
	1tTjP+yIPxtuPx0+kRGFy/4njDzjEnCRzHGlDD1LRkEHnIl8lD7oAFkJQQLIU7UbqeFXex
	ySb+jhE5SCzJqJ3XJORDKyjQEZ7BGeU=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-UbA0E9GDPCiLzdAK56-PtA-1; Fri, 09 Aug 2024 02:50:52 -0400
X-MC-Unique: UbA0E9GDPCiLzdAK56-PtA-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3db1b451e43so1968483b6e.0
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 23:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723186250; x=1723791050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r7Z50sX7S2lP3FksAHizbuHlweuHnvbw/fal6Z+4SqY=;
        b=heLJUT0nZioscYkbL0PjSb/333O9IXYZFtY2i8Vl0Iur+JgtTNovbeHwy13UBEisKC
         GEY+NGKs6dsF/BDJzu9Mi67WA3e7jbLLOdUxGYTLURsgp6ujEnkSgZsSNkwHsLb/1Qc5
         1PDnRkBPSUnJH6wNYX4b2irSNMjXoTjK+RO9p7qwc4EG9l12k3ofQ2O/jIVVtbdDWepE
         kipR4/Xlg2fhGWeoWDYQYU6LM88NlRpeu8wrQvtO1MGRltyUrceVC+gHni5pvYB7+60/
         Fxmlx8SQfKxKaR+ew9c5TfJU5M66197UyK20Rifc1+srIBMAT8MsMECaZuE4oQjsdPmE
         fYyg==
X-Forwarded-Encrypted: i=1; AJvYcCUFqXnEJH0owysE4pYb+VxnGICk9RQJm8uOl0fB/vHOkjMDLTDdgz/9zN49W3rcSso5UUd57YiGqPDrI54GXlAoK2c9
X-Gm-Message-State: AOJu0Yz2CDBry/aiR7hnFof2FM0ntMFhe1iLECUUduR7iMFGm1kEfhYE
	xBu9GGDiEDtSYURSkEMtKKTN9hK39/4ToyfyZcRQJwNZ16E/Lb3p976K4hZof4L61gvtDv8zGrW
	Nl7quUWtogMezZNc5dXh8xP1LsnHO/3w/jx8dhd0BFse+S9BNPUqfPYzHoA==
X-Received: by 2002:a05:6808:1b08:b0:3da:a48b:d1e6 with SMTP id 5614622812f47-3dc4167be9bmr622730b6e.16.1723186250395;
        Thu, 08 Aug 2024 23:50:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHkTD65z+yldFUt1QaxBa4CrGdN0oQ16aB+/2N5VM7yzbXUvvKg2qlQyzVOkVm4Ijwc9puiw==
X-Received: by 2002:a05:6808:1b08:b0:3da:a48b:d1e6 with SMTP id 5614622812f47-3dc4167be9bmr622715b6e.16.1723186249971;
        Thu, 08 Aug 2024 23:50:49 -0700 (PDT)
Received: from localhost.localdomain ([115.96.114.241])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-710cb2d11besm2042982b3a.127.2024.08.08.23.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 23:50:49 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-trivial@nongnu.org,
	zhao1.liu@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3] kvm: replace fprintf with error_report/printf() in kvm_init()
Date: Fri,  9 Aug 2024 12:19:40 +0530
Message-ID: <20240809064940.1788169-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

error_report() is more appropriate for error situations. Replace fprintf with
error_report. Cosmetic. No functional change.

CC: qemu-trivial@nongnu.org
CC: zhao1.liu@intel.com
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

changelog:
v2: fix a bug.
v3: replace one instance of error_report() with error_printf(). added tags.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..5bc9d35b61 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
     QLIST_INIT(&s->kvm_parked_vcpus);
     s->fd = qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
     if (s->fd == -1) {
-        fprintf(stderr, "Could not access KVM kernel module: %m\n");
+        error_report("Could not access KVM kernel module: %m");
         ret = -errno;
         goto err;
     }
@@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
         if (ret >= 0) {
             ret = -EINVAL;
         }
-        fprintf(stderr, "kvm version too old\n");
+        error_report("kvm version too old");
         goto err;
     }
 
     if (ret > KVM_API_VERSION) {
         ret = -EINVAL;
-        fprintf(stderr, "kvm version not supported\n");
+        error_report("kvm version not supported");
         goto err;
     }
 
@@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
     } while (ret == -EINTR);
 
     if (ret < 0) {
-        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
-                strerror(-ret));
+        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
+                    strerror(-ret));
 
 #ifdef TARGET_S390X
         if (ret == -EINVAL) {
-            fprintf(stderr,
-                    "Host kernel setup problem detected. Please verify:\n");
-            fprintf(stderr, "- for kernels supporting the switch_amode or"
-                    " user_mode parameters, whether\n");
-            fprintf(stderr,
-                    "  user space is running in primary address space\n");
-            fprintf(stderr,
-                    "- for kernels supporting the vm.allocate_pgste sysctl, "
-                    "whether it is enabled\n");
+            error_report("Host kernel setup problem detected. Please verify:");
+            error_report("- for kernels supporting the switch_amode or"
+                        " user_mode parameters, whether");
+            error_report("  user space is running in primary address space");
+            error_report("- for kernels supporting the vm.allocate_pgste "
+                        "sysctl, whether it is enabled");
         }
 #elif defined(TARGET_PPC)
         if (ret == -EINVAL) {
-            fprintf(stderr,
-                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
-                    (type == 2) ? "pr" : "hv");
+            error_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
+                        (type == 2) ? "pr" : "hv");
         }
 #endif
         goto err;
@@ -2526,9 +2522,9 @@ static int kvm_init(MachineState *ms)
                         nc->name, nc->num, soft_vcpus_limit);
 
             if (nc->num > hard_vcpus_limit) {
-                fprintf(stderr, "Number of %s cpus requested (%d) exceeds "
-                        "the maximum cpus supported by KVM (%d)\n",
-                        nc->name, nc->num, hard_vcpus_limit);
+                error_report("Number of %s cpus requested (%d) exceeds "
+                             "the maximum cpus supported by KVM (%d)",
+                             nc->name, nc->num, hard_vcpus_limit);
                 exit(1);
             }
         }
@@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
     }
     if (missing_cap) {
         ret = -EINVAL;
-        fprintf(stderr, "kvm does not support %s\n%s",
-                missing_cap->name, upgrade_note);
+        error_printf("kvm does not support %s\n%s",
+                     missing_cap->name, upgrade_note);
         goto err;
     }
 
-- 
2.45.2


