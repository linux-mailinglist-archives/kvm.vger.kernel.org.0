Return-Path: <kvm+bounces-25157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1F6961097
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52EE01C2374E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53001C3F19;
	Tue, 27 Aug 2024 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crThXzDk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B913412E4D
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771441; cv=none; b=Rg1HWab0hoe6LKDulmhLyQ0b/69F/scJGtzHjuaio9xW9D+XdcCslLgZ8Y+El3X/fXAYdryj6qTvu3gMvzz8fUHMUpvsrx/gBLwqY5/sag2xvKhKewHPfEu+jzHNQOpMDrhiojU7wPr0F6frQ/0ft8yWJBQ7BixSnOlwPIUi8U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771441; c=relaxed/simple;
	bh=H7e3TJX3q33f3Y/0/RWpzihNvPMF7v93hWhSjauJLWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOcgG7EAg8Ofi22ClAISJNuVvMXKGwa1iTi3Le2WRVIGqCV3SkbZd/5Zd10XOqe+9USe0hR5ipcLcydOqguvgmJWpZ1vGo/YaKtJgwrD7y5KID3F5WYax/Hc/zY3y60SG1O8TV/yBqjX6Xpue9qlUVloc7dchbKVZcFjq0vOaV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crThXzDk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724771438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M8CF5R5awVwAxYxGrhoKMF7ffh+xm8TgWTdEgRArz0g=;
	b=crThXzDkWk72JkwRKTQluGAIZqaivF451ADVDUx5S7YtvSoJiyf6bDLyHwtRc3+O+IWeBK
	7ml+EI1E4w4x5lV15sFy+r2VVobxQLmlTrqa9DZdsjMZnbO//97JLtbJcTI/uz5+JOxs2b
	7IJqZIIUShxhdQUA516mOjc1fzwjRLI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-CZc8igPbNNCVzrP9lzCMmQ-1; Tue, 27 Aug 2024 11:10:37 -0400
X-MC-Unique: CZc8igPbNNCVzrP9lzCMmQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-71447057259so3542209b3a.0
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 08:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724771436; x=1725376236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8CF5R5awVwAxYxGrhoKMF7ffh+xm8TgWTdEgRArz0g=;
        b=HubPi6z2xJwckMyTOhHQsReCLN4DQwJdTFE1Mzmfb0x9RBwavD1SX3DOp88UVs2Cwu
         qwtjMUjCGTZ1TMKR/wbo1prjt28AxOYfSQNREsmx3sHxxWxeKrJ/pP5s6gs8Qzte7f/w
         dyecHEZd44X2tjUrzM3zctRRDZranohKZa9OMKrapEISEQLFdtWj/XKAkjXER5eMUY2A
         1+A9i4DRgeT1YETBKKGFu1HosD3hPtiZ2DeQeJpznbv4rmkyKpLT5wEi3OKbz5ns96Vw
         xhjiabLnneoZNQVY9UDB/Q3zDOUv+1wcFzuaeHpBkKFBNMj7nMGcXnMh1E6Rs4ZDAIYy
         +Tag==
X-Forwarded-Encrypted: i=1; AJvYcCU0AUjHRmFTYi2xHcbUGe16EpF8qLNyaxJxZtPYvAphmtN+Uh8dSUyGpD+4n5FIQCEhW34=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJp/CuNlt7nUbfVgCnWnZDS9uq/6M8UWWorKtzL/U6uuoYFU5L
	rXISOpYRrMR4OX6Trxwt/u+Gtw9vMuSik//IW6g+u+HfM7IKPl3eN7yrGDhLWMlTcBH5srJVZ/y
	PQKWnkP93A/cb8Ophc3KzFcb4dcwaDb9aQMuTN8utVuynT9jekA==
X-Received: by 2002:a05:6a00:4f94:b0:714:2d92:39db with SMTP id d2e1a72fcca58-715bfff985bmr3440383b3a.16.1724771436498;
        Tue, 27 Aug 2024 08:10:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmiDJHM76Y13C5DYfMIOZ/jwgV5kOIAra5Gn0srPjDkXgH00hJlfr7+YaxSbfw7ucDvYkfqg==
X-Received: by 2002:a05:6a00:4f94:b0:714:2d92:39db with SMTP id d2e1a72fcca58-715bfff985bmr3440342b3a.16.1724771436112;
        Tue, 27 Aug 2024 08:10:36 -0700 (PDT)
Received: from localhost.localdomain ([115.96.30.188])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7143430636esm8679062b3a.165.2024.08.27.08.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:10:35 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-trivial@nongnu.org,
	zhao1.liu@intel.com,
	armbru@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 1/2] kvm: replace fprintf with error_report/printf() in kvm_init()
Date: Tue, 27 Aug 2024 20:40:21 +0530
Message-ID: <20240827151022.37992-2-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240827151022.37992-1-anisinha@redhat.com>
References: <20240827151022.37992-1-anisinha@redhat.com>
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
CC: armbru@redhat.com
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

changelog:
v2: fix a bug.
v3: replace one instance of error_report() with error_printf(). added tags.
v4: changes suggested by Markus.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..d9f477bb06 100644
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
+            error_printf("Host kernel setup problem detected. Please verify:");
+            error_printf("\n- for kernels supporting the"
+                        " switch_amode or user_mode parameters, whether");
+            error_printf(" user space is running in primary address space\n");
+            error_printf("- for kernels supporting the vm.allocate_pgste "
+                         "sysctl, whether it is enabled\n");
         }
 #elif defined(TARGET_PPC)
         if (ret == -EINVAL) {
-            fprintf(stderr,
-                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
-                    (type == 2) ? "pr" : "hv");
+            error_printf("PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
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
2.42.0


