Return-Path: <kvm+bounces-25248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A75B49627A4
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC85A1C208B0
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E70176AB9;
	Wed, 28 Aug 2024 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CzVsbzv6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1716C17AE00
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724849177; cv=none; b=JqaH6yWASksoRpazNxls2MVIMQTRbRTdfMaOu6jjbuZIRsIBhA5YuV2FdxoDwtmV5wqK0a6W2EXRTJLJeaydlCnSmtlSeCWH7SvWOEvX400mDF8VBTv+n0tV4YgreeHiJboVX+2j3qsT9dItL4gN7wjRxs5YFGIsrQZcl9bzEoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724849177; c=relaxed/simple;
	bh=yTbThRHXY9I+o1hajj2ygD0U8qXPGndCbdXnJoTyTmE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LY1YnYIbap5ZaJTKiUDXrOoAU+98Zc46JSXxP+ZtxOqE2v2Ldje6Ho45zVUiB8jVWXZn+BsSjdJkxjBZOQ8V5tw5aR9gN0bfxJNrfdHraUe4V7QD/s/o0TzhDM5/I2OhG7vGDGJS7rBuIC3gNV6pexnfimUclKZBjFVOATD+VIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CzVsbzv6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724849174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2T1tTA9ko0YOWVFq5y4ifBO7b+LeUQvtX/jUULrFmb0=;
	b=CzVsbzv6gPQzBL4k2Z7XelBAVngQgU3Sw5/a5ot8uyOGGhGxikBU5k+dB2yUM0B7hLLRPh
	263IlHRiRUrPAn91UiLfKHgS8heyc7ITJRpsFEO3J2n+B7V5y4SNoTiA1LnaDwbfY6pVDn
	Y1bcB1lldnE3HpGBZNSCH+HPpt+VK1c=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-yrW-uEPqPl2Hm3zsUjWl6g-1; Wed, 28 Aug 2024 08:46:13 -0400
X-MC-Unique: yrW-uEPqPl2Hm3zsUjWl6g-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1fd6d695662so75766365ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 05:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724849172; x=1725453972;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2T1tTA9ko0YOWVFq5y4ifBO7b+LeUQvtX/jUULrFmb0=;
        b=b6MB61Iikqq5+GYC8XJZoLRB1f9cqBtB+R6bnZk/boPC56Q87hk/d0ZPA1xVTipvuV
         x5I4/DuK2B4SMjYD/TE92JdqMIGa64SQLwkZHqATW4mz56PyhDUXMdFwHf6iZaBl76K5
         Qg+sEzoxuAKWgZwjJlzLpqewH4IG3r3TJ45AbyCiKADvph+TUfokH5VIEpqpWwbrIbvk
         MGR2Vxnh4+2hZnqm2WsZJtSFiQK2yhP8YA2/vBlgvoPQhILE4WQ4ZDvl8IRUftLEPUIa
         IOeZTGF321Fwma8jVveCWmOTszYRN1Cfs+/Rb8TtxqHFr4yhhcVsNOu1tJk15y3++NoM
         /Y5g==
X-Forwarded-Encrypted: i=1; AJvYcCVzwWRsb3CCD/FN7Dp1S+XHFr4mJaXXzNOcPvL4rxY+4QTri9V0EWj46IhNREQkiS7gGKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWI1QPgPnjMo965jv54Ki3r2k6PwVE9zGnEqNIdeqp0ZmWIP5V
	su/dD4uGgh9GIdrd+MEFLNIjDlK9hsBzY0slTJ3vd46CNYEWDFG5jB4EVSJXFkvi+WqA117yRJe
	fg1KMweBVeQFBgllHiTuP2qFU+r7pA3wRsTmQMMXKLXZCedl1VA==
X-Received: by 2002:a17:902:e750:b0:202:401f:ec6c with SMTP id d9443c01a7336-2039e4f1d23mr188247205ad.48.1724849171927;
        Wed, 28 Aug 2024 05:46:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIbCZfQ1T//KOqu77wrHDWoUYiCjpxF2W/r8bUX4UIMnm1FyADOmQECxRobicGc7XZR1lQQg==
X-Received: by 2002:a17:902:e750:b0:202:401f:ec6c with SMTP id d9443c01a7336-2039e4f1d23mr188246975ad.48.1724849171473;
        Wed, 28 Aug 2024 05:46:11 -0700 (PDT)
Received: from localhost.localdomain ([115.96.157.236])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-204f1b80cf5sm15047485ad.164.2024.08.28.05.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 05:46:10 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-trivial@nongnu.org,
	zhao1.liu@intel.com,
	armbru@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6] kvm: replace fprintf with error_report()/printf() in kvm_init()
Date: Wed, 28 Aug 2024 18:15:39 +0530
Message-ID: <20240828124539.62672-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

error_report() is more appropriate for error situations. Replace fprintf with
error_report() and error_printf() as appropriate. Some improvement in error
reporting also happens as a part of this change. For example:

From:
$ ./qemu-system-x86_64 --accel kvm
Could not access KVM kernel module: No such file or directory

To:
$ ./qemu-system-x86_64 --accel kvm
qemu-system-x86_64: --accel kvm: Could not access KVM kernel module: No such file or directory

CC: qemu-trivial@nongnu.org
CC: zhao1.liu@intel.com
CC: armbru@redhat.com
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

changelog:
v2: fix a bug.
v3: replace one instance of error_report() with error_printf(). added tags.
v4: changes suggested by Markus.
v5: more changes from Markus's comments on v4.
v6: commit message update as per suggestion from Markus. Tag added.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..fcc157f0e6 100644
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
+        error_report("ioctl(KVM_CREATE_VM) failed: %s", strerror(-ret));
 
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
+            error_printf("Host kernel setup problem detected."
+                         " Please verify:\n");
+            error_printf("- for kernels supporting the"
+                        " switch_amode or user_mode parameters, whether");
+            error_printf(" user space is running in primary address space\n");
+            error_printf("- for kernels supporting the vm.allocate_pgste"
+                         " sysctl, whether it is enabled\n");
         }
 #elif defined(TARGET_PPC)
         if (ret == -EINVAL) {
-            fprintf(stderr,
-                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
-                    (type == 2) ? "pr" : "hv");
+            error_printf("PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
+                         (type == 2) ? "pr" : "hv");
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
+        error_report("kvm does not support %s", missing_cap->name);
+        error_printf("%s", upgrade_note);
         goto err;
     }
 
-- 
2.42.0


