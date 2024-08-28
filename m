Return-Path: <kvm+bounces-25231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 614219621D8
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 09:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FE7B1C23601
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 07:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62EF15B0E4;
	Wed, 28 Aug 2024 07:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MhYmjhv0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43C714D6EB
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 07:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724831809; cv=none; b=nxuPO7ke2N7YYTrjj2Q9KA+aVjQ2DjHSbb3UMb5R368YVmwOVvznGwBAXfgJSk/jaRVlT8ROVpr3zgCoICE2uCSRNtxzy+fuAhW77aj802pdJvq7klR4j1pjkrPtuCkJhXogmT9LLAtEsVWJ1PNzCHUHAo1YBLftuqViMgpGPmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724831809; c=relaxed/simple;
	bh=F+2ualCaU6lYRASEfaKKFQIE3pbDTI7gaBA5gOx78K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCDbcwSUZ5M/Dro3vvv5CxRcFQIHj9jT5qtv9fHbAvJywwGQTiL8Vjwbi3ph6v9MJ3rpbjnBhg/C3le/jwIfFVcNMCwdN2qdKZX5UBazYwv9DTMRvt/U15OWwwKBBU6bTE3mss/T5csJxM6CupNsgrlKLhtTw8arT9UiareG0vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MhYmjhv0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724831805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=19Zh4Zt/ZVNN5Ajo9sSQWEIPYsVM5bJD7k1vakhLQ/o=;
	b=MhYmjhv010YmAqOdtuZBh+yIscWMJonTqbY36dn1vSzwLzB9yxQNswh+Ml+0uTKGVYQEiV
	jOV3lNNhC0bbuPMykIwbVRHFKquaFYzARHJie/7TS7db1pMVyS/Gu0VsafPVuCKnEXHBse
	IHh+GuAIpfTSAHQYcFM9tTA1Kuiq4Ww=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-ay_i7oymPTukfHpGwwMynQ-1; Wed, 28 Aug 2024 03:56:43 -0400
X-MC-Unique: ay_i7oymPTukfHpGwwMynQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-714318beb82so6768713b3a.2
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 00:56:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724831802; x=1725436602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19Zh4Zt/ZVNN5Ajo9sSQWEIPYsVM5bJD7k1vakhLQ/o=;
        b=XKx1LQ+vvt/mx7ELq/ye+Y88hG70cVdYBjoPU9wv5N95mz17P5Ql0ee7pgUVhbk9or
         MAwwJNcDTftLRGJUJZDwcYXoZEYitpv3weOA3AmkBlggtrKOSiCBvf2UhsC30sNxaaB3
         3XWw4cG7DssM2Mb00x4j3r0PTlfpve9Cq0NENjL8hYrrrL63S82Vimo60zS4qWLtVSCy
         wdYFWUq18jetW/iaCQL5a+RiYT2vlxkCwC8F7AzOpReiIZBVZPKpvuLbFLNMXDWM9ilT
         huO9YfimUAFpA2XOU2JwjQ4B6Q26Jg+FTzaPg0idTvzCFEljCkMlfrs8kls/91EZoPiY
         AtUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSYzC3+nzsMjdZOxbdKobBjxGLjJIkPFAYJPCvYJI/rSyW15LbpsIM64Z17VKMx8Aa+tM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIFkztrk3B6lVwEwBK67umzpgnsljlFw5ve2YGDCShQjWvnGps
	Ws82Wjc492chHs66uB136QP36l6Ig8QyVdQL/U1i5/h0XxQdNumbaFxQue8l118QHReLQx+bzao
	pO1Xrykl/4Miw7UDLRUAbhqC9b9l4c+YgiY7OPrTNIlnQmYT5YmmbO8AYy82R
X-Received: by 2002:a05:6a21:3409:b0:1c4:d4b2:ffe6 with SMTP id adf61e73a8af0-1ccd288d5d0mr1009071637.19.1724831801982;
        Wed, 28 Aug 2024 00:56:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/HVRKqcTrIT/WM260RBM0Z07SE8tr4atgSV/pWEwV/3FDxDJ6N7qyGLfHX0GADHsgfQ5siA==
X-Received: by 2002:a05:6a21:3409:b0:1c4:d4b2:ffe6 with SMTP id adf61e73a8af0-1ccd288d5d0mr1009052637.19.1724831801581;
        Wed, 28 Aug 2024 00:56:41 -0700 (PDT)
Received: from localhost.localdomain ([115.96.157.236])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2d8445fbf0dsm1013534a91.19.2024.08.28.00.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 00:56:41 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-trivial@nongnu.org,
	zhao1.liu@intel.com,
	armbru@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 1/2] kvm: replace fprintf with error_report()/printf() in kvm_init()
Date: Wed, 28 Aug 2024 13:26:28 +0530
Message-ID: <20240828075630.7754-2-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240828075630.7754-1-anisinha@redhat.com>
References: <20240828075630.7754-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

error_report() is more appropriate for error situations. Replace fprintf with
error_report() and error_printf() as appropriate. Cosmetic. No functional
change.

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
v5: more changes from Markus's comments on v4.

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


