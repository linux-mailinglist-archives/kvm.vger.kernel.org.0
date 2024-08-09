Return-Path: <kvm+bounces-23666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AF1294C96A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 06:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 874921F248AF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 04:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF3216728E;
	Fri,  9 Aug 2024 04:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V3bu/l5R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03AB24B34
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 04:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723179224; cv=none; b=SG4vqFTDW2x7WxAKRVUD/bnK5MsspI2hW/OA7UF65XPnt60D/WpHym7oZZzssLHBDd4DMYyzye75/revmJMg6U/1J+gGBeOY2WF50WHeBCJBKdpFpsxy1V1usHQvfITCiN9B6NMZyxsQnSOyoODBBJ+BO0xjCr9aWvLVxsXY9Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723179224; c=relaxed/simple;
	bh=+L8SQdFJXXqDe1qbFN1BR4gCQVawaP9pb7iQb+RWN4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdpHeBwUZ4HX86+hmG9ySUWGMhWV+gkVNOh0MgFk+mZUi0jTZk5TEgLNYxflQ5jAca4wYBqx2Z3ry4oOI+DjN5T0vDBuhfE3r3G/FVbfALvBLgiNOhAtYhHtZZtjGidKuGUhmtTJqV8BTawGHfgzfd41p5EkjfcydJaK3NZ6GbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V3bu/l5R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723179220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FfU6XyO2Jk8i4FOiwyJKt1ccqOlc2vNSvzjRNpOVJfs=;
	b=V3bu/l5RtioFB7QOePeUCsW3BmBAiC9sDIanc7EwCRa2L9qwcIzLLwPO0gXSZKqyhUUvvP
	ccg2aDktLSxnzVVv82vnOvsaXkonthKb3sH2RUW0bxAXk4siSfgW4jemHNFxmfe37C4zG9
	LyWghoFaDN/qjuIVsNdvoWZxOQR0zmY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-eUWN-kl4Nay04xdQBiTB0Q-1; Fri, 09 Aug 2024 00:53:39 -0400
X-MC-Unique: eUWN-kl4Nay04xdQBiTB0Q-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-70eab26e146so1726389b3a.3
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 21:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723179218; x=1723784018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfU6XyO2Jk8i4FOiwyJKt1ccqOlc2vNSvzjRNpOVJfs=;
        b=KEdFq/Q4KEU+1j0WQfelAqKeB5yJD8+8KApYzvauAcOMSMYATJMXsCcYdOHKXWoJwO
         5nmhMt5pYohVrWbwXEdOC4maWDMweiR9EL/sRNPGTVN95H4/OJYovmCne9+FLWGlfvgU
         0rn3ZoO50Lhw4UmYyVL60fXY+wVMeAkpX9cgpolqWpeIqkwd6eWC1bUHK9IAPZ5MO0md
         e1n9i/hAoVngrwD8T1GJwbNvPixJKLHyGCGt7W2snGOPwxoUQ5HQZieVv4//NxW4iGtU
         XFrKxcFYMekczPr2g+qZcm3IV9KhYM/MAL7agaAvAQsXo6Mrbm7P44vSBCjvOCqbjxSj
         CGGg==
X-Forwarded-Encrypted: i=1; AJvYcCWJUXdkmDv4VlPZmmVvy8BANCJsKpkKReQ7/XFSz9jvNK0wZdacIYCGX4wRgkvu1CFZk34+ST2r3BDRDlI9io8rzVCI
X-Gm-Message-State: AOJu0Yyk/IaJkyrwq2HUVaxMO2rnBYiZyjLeE95YYR66rZz0xpO6qw0t
	ccnkWtmNshUK1qCIS3WT2E0KqnD/OcbNtseEF4nW0DB5mgzxPqpLcEe4Z0519EB4WBp1g8CsoNL
	AmZcMuqUtraVsXgN12D0Ug4pKpmGnkKpWi90OZZg6cJA8Aaxggg==
X-Received: by 2002:a05:6a21:3993:b0:1c0:f5fa:d1e9 with SMTP id adf61e73a8af0-1c89fce5652mr592196637.15.1723179217722;
        Thu, 08 Aug 2024 21:53:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXIKuqH70u2Lx+GwuqOZ8MGvHc3rF9cXAtufWKuQhkfNhxF7aPPB1+YhD3cDXDoG1FQCrEFQ==
X-Received: by 2002:a05:6a21:3993:b0:1c0:f5fa:d1e9 with SMTP id adf61e73a8af0-1c89fce5652mr592182637.15.1723179217298;
        Thu, 08 Aug 2024 21:53:37 -0700 (PDT)
Received: from localhost.localdomain ([115.96.114.241])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1ff58f6a540sm133516895ad.118.2024.08.08.21.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 21:53:36 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-trivial@nongnu.org,
	zhao1.liu@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH 1/2] kvm: replace fprintf with error_report() in kvm_init() for error conditions
Date: Fri,  9 Aug 2024 10:21:52 +0530
Message-ID: <20240809045153.1744397-2-anisinha@redhat.com>
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

error_report() is more appropriate for error situations. Replace fprintf with
error_report. Cosmetic. No functional change.

CC: qemu-trivial@nongnu.org
CC: zhao1.liu@intel.com
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..899b5264e3 100644
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
 
@@ -2488,30 +2488,26 @@ static int kvm_init(MachineState *ms)
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
-        goto err;
     }
+        goto err;
 
     s->vmfd = ret;
 
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
+        error_report("kvm does not support %s", missing_cap->name);
+        error_report("%s", upgrade_note);
         goto err;
     }
 
-- 
2.45.2


