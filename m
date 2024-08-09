Return-Path: <kvm+bounces-23669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF7D94C97C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4B5A28653D
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 05:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB6516848B;
	Fri,  9 Aug 2024 05:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WOAgv/2R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE13167D80
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 05:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723180288; cv=none; b=Ls/ZeI6VT+Mv074Tn7ok1LoOiE++pj+vkjbYNC19hXPQfkpoFE0J4Adb5+i9COxjDnjPfBySOe2TN0tXuJEWGHdwULF8WMSMgxt1mJtek0gmvQLIWN8IguhVGJ34iWas9lTBg2ahDpfSGFxkQTX7Qx4lchUUdJRGh4SCMt4VPLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723180288; c=relaxed/simple;
	bh=UGDB/QsnROgUGsQoRjxWRyyuMh9lRll9OpO2hd18eLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCiPr28BicHldjHTbohu3VufA1VMl0YSEEZTvG+q3ZVf3Q2mZ+s7RrvEjIQOd2rdc59q2h45Aitl4NxfT6SMEbhtFn8fzrRDFhoOBUy96/wlmNLPzmU6/uf91VwhGVsfQFvh6ysMloTcW4z+tM7UUJRhHwa1bdfDScX0z1BtoYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WOAgv/2R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723180285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cqMbqqTDoxkH4lSjzfRzKJ8KXs/o+RTOSJGbYKXw66A=;
	b=WOAgv/2R84uy4DDXiqEyK8e2yCaeQAXvh21pkl1J6iWQpZ+s9cxwG9xg8U6qOTD7tfiq9Q
	hSmrbfgmWdLFh0GXlRP/4CItnxH9x1cY7FUDOrXy/m9Po/wzbsnnK3RQV3/mZwie/BCyqc
	28fLTf5aKdhs1/blRsY3YU0OeM+JSco=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-cwbqn5fKNh2Z3g8GqZwBWw-1; Fri, 09 Aug 2024 01:11:23 -0400
X-MC-Unique: cwbqn5fKNh2Z3g8GqZwBWw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-70d14fc3317so1689565b3a.1
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 22:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723180282; x=1723785082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cqMbqqTDoxkH4lSjzfRzKJ8KXs/o+RTOSJGbYKXw66A=;
        b=cZ47itaKl7teRLDzhqKCitBi9XZ83rKXc8e2AbJid5bKvNcjTL0O/twv64o1lrYtPQ
         J5WXOgrQp3jjD9EHi0d2dRVFKl82KL320UQtd4GUv7O7TdrHmteMxjA/scHPMXTEtCTe
         6ezpiURpMGMYgHUBwX1DRi2bSC4BXCWRU6HyjIUCicQ3s9lIVxjhDBQrnIk5e8Wfo2y4
         nDPQ6q8OtGC25bBe+Lp+nEeA++a/c4MiPS2LicjZtyhCn8NzCtFQG+XikZwb/sce7MYh
         51cGIMVurg8SlsGdNIdaX/qCd846UI9n8FI90AFsRvdaPc78DWr+WhGpXleE60UpaO6W
         yATA==
X-Forwarded-Encrypted: i=1; AJvYcCWZn4/JY1cNauFgDwPLIz8UcllO+P2OMqJpQ+3gpMcV5KY7/a5liP/jAH7Xd+Lh+DO4fnxJoGTRphCyTiA8zl4/bhlg
X-Gm-Message-State: AOJu0Yw98/OGHtLrNDh22AiBFK5pNHx2BVV1HPIkZez3l3JiamYXwvro
	jiTC3EQNPcKRSmoMNh8lC5tVJk0QtbJCEg6Zye78JJM86pj9TJkVz//+OGjua9AZ5TUMnZA3E4t
	t0lja5argnyApNBEccdORDA+s9ZPyhOxe4O0Hekl0uIBoUhyTVg==
X-Received: by 2002:a05:6a00:855:b0:710:6e83:cd5e with SMTP id d2e1a72fcca58-710dc2ccebfmr516747b3a.0.1723180282432;
        Thu, 08 Aug 2024 22:11:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8t0EAoP7cgCq1cRFAtmK6Tr42nsp3je6iK76kbLnen1NCNIOlxzNdQMxqQhXKXDPa/XxChA==
X-Received: by 2002:a05:6a00:855:b0:710:6e83:cd5e with SMTP id d2e1a72fcca58-710dc2ccebfmr516717b3a.0.1723180281966;
        Thu, 08 Aug 2024 22:11:21 -0700 (PDT)
Received: from localhost.localdomain ([115.96.114.241])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-710cb2e52bfsm1961777b3a.145.2024.08.08.22.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 22:11:21 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	qemu-trivial@nongnu.org,
	zhao1.liu@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 1/2] kvm: replace fprintf with error_report() in kvm_init() for error conditions
Date: Fri,  9 Aug 2024 10:40:53 +0530
Message-ID: <20240809051054.1745641-2-anisinha@redhat.com>
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

error_report() is more appropriate for error situations. Replace fprintf with
error_report. Cosmetic. No functional change.

CC: qemu-trivial@nongnu.org
CC: zhao1.liu@intel.com
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

changelog:
v2: fix a bug.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..ac168b9663 100644
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
+        error_report("kvm does not support %s", missing_cap->name);
+        error_report("%s", upgrade_note);
         goto err;
     }
 
-- 
2.45.2


