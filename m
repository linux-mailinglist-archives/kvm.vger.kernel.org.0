Return-Path: <kvm+bounces-25158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C057961099
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92525B26100
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C701C5788;
	Tue, 27 Aug 2024 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Af6xSWlA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894CA1C6887
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771446; cv=none; b=aSEHxRHX5y9UDWzQ7Ln2i22hGMYiKMnI1HrrhSH+a/x1VTtP1cZBTQHm9GTAjqlK5xDJbhbj74TfvczKJvxPMja4FDPbp8qXWtlfrVpvzVnq+DMU8+e+Mz9DYTuJlF2sWheFoBhvvvcOm249ZwcgyD45lWr11MQGzfgzaC4mVfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771446; c=relaxed/simple;
	bh=XW/6uYQNb6VuWC5eOxfMgT/hq/5SI9IonnjR1cshHUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWV3pnzSRU39BbaiWoDZV+ZfnGl2H2pTezKYXux7pqXLhynlyTTGe1kwyt4Q5jeLfxdO9o3EVTb86CrZeHC/VAwkvauvKwB19N78KqDVzKdueWEBN7YtsfJ/IyOVRYxm0BaVcQOOxmdycP2VBg+dZGvS4IWpAT8UFZpvaFOZsjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Af6xSWlA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724771443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4c8TB2xHXASJ1uR1do61nTZjlIA4R+OAlBc+Ffu1q0=;
	b=Af6xSWlA2JPu7Ie/vNgwU5P6fXx+uS8zKiiotqvisEUf9H6XjsxMV0gSMRQ8/9YIFUjOjC
	NaRirGpAzwI0gPJa7lo11asXmgmBEVni/OFm9Toso274anmzOU2SFClDpX3ij8NcaCR9zm
	w5IktSriwXgxjVlq2WDO7GrpVq2mJMg=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-kLx5xTpbPMOpNaEsEtTAlw-1; Tue, 27 Aug 2024 11:10:41 -0400
X-MC-Unique: kLx5xTpbPMOpNaEsEtTAlw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7142a78918bso7201413b3a.0
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 08:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724771440; x=1725376240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4c8TB2xHXASJ1uR1do61nTZjlIA4R+OAlBc+Ffu1q0=;
        b=BDZh9D7fv6Rr3h0ZJDHZUxdK1RzQ1Di9oE0DAE6tMcoyVpGrGRE9Sof5qW3DtzjSGG
         ZceDaUWVWB5LXeMT3gy/E+Ec1ZzAxFZLw3rMI9UBMSpS/bfY7ce2PpAXwt+INyBgHRk3
         dXXMHPmApCSDvqMFXjxGoyNsMFSjFtVPIynbmIYIhYr0AjDfuGuDMmuhzvBma94DMq9U
         GHx0lnorw1cULxo+b5pHP7BKErhlHBo5Vjem1nkuE2MZQXG3YPlUCN4fVkbEopVLLnWm
         8/Z4AR6U66fT2MOvxWm1ytVEt/UhItPpkaX90VanSaDB0R2MiHKSoSjaLFDmQSU+GyWq
         Inag==
X-Forwarded-Encrypted: i=1; AJvYcCUjflT0FYFZWsiIUZhCAYBsV8rseBgZf5NwcyvkMJGw3we8YnqIYNTe8wa4bm1O4is6tAk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+lIynLLbFYA1djqvSzxrKpGTxP7QMGnhlbrJQWr8aIJptzQPG
	skwK6nt0wzw6TBjS3X3mLJVvwsLeM+Ms2xOz60wr37F4u2WXtVvBTIV1TlJadCrGRAa4lxtwcPK
	n7Y3SPo+7albTIUK28ClgRn7hIm+efIXO65mb2FOT5ezGokkl5A==
X-Received: by 2002:a05:6a00:1805:b0:714:3325:d8e9 with SMTP id d2e1a72fcca58-71445e1153fmr16802139b3a.22.1724771440575;
        Tue, 27 Aug 2024 08:10:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUEAqtApzRiyNS0JKuFBiyF3z3Asq7TBCcUFBE8fW8JjKPSqwZF7934+py5nk9lIIjydb91g==
X-Received: by 2002:a05:6a00:1805:b0:714:3325:d8e9 with SMTP id d2e1a72fcca58-71445e1153fmr16802090b3a.22.1724771439974;
        Tue, 27 Aug 2024 08:10:39 -0700 (PDT)
Received: from localhost.localdomain ([115.96.30.188])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7143430636esm8679062b3a.165.2024.08.27.08.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:10:39 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	zhao1.liu@intel.com,
	cfontana@suse.de,
	armbru@redhat.com,
	qemu-trivial@nongnu.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 2/2] kvm: refactor core virtual machine creation into its own function
Date: Tue, 27 Aug 2024 20:40:22 +0530
Message-ID: <20240827151022.37992-3-anisinha@redhat.com>
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

Refactoring the core logic around KVM_CREATE_VM into its own separate function
so that it can be called from other functions in subsequent patches. There is
no functional change in this patch.

CC: pbonzini@redhat.com
CC: zhao1.liu@intel.com
CC: cfontana@suse.de
CC: armbru@redhat.com
CC: qemu-trivial@nongnu.org
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Claudio Fontana <cfontana@suse.de>
Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 accel/kvm/kvm-all.c | 86 ++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 33 deletions(-)

changelog:
v2: s/fprintf/warn_report as suggested by zhao
v3: s/warn_report/error_report. function names adjusted to conform to
other names. fprintf -> error_report() moved to its own patch.
v4: added tags and rebased.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d9f477bb06..391279c995 100644
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
+            error_printf("Host kernel setup problem detected. Please verify:");
+            error_printf("\n- for kernels supporting the"
+                        " switch_amode or user_mode parameters, whether");
+            error_printf(" user space is running in primary address space\n");
+            error_printf("- for kernels supporting the vm.allocate_pgste "
+                         "sysctl, whether it is enabled\n");
+        }
+#elif defined(TARGET_PPC)
+        if (ret == -EINVAL) {
+            error_printf("PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
+                         (type == 2) ? "pr" : "hv");
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
-            error_printf("Host kernel setup problem detected. Please verify:");
-            error_printf("\n- for kernels supporting the"
-                        " switch_amode or user_mode parameters, whether");
-            error_printf(" user space is running in primary address space\n");
-            error_printf("- for kernels supporting the vm.allocate_pgste "
-                         "sysctl, whether it is enabled\n");
-        }
-#elif defined(TARGET_PPC)
-        if (ret == -EINVAL) {
-            error_printf("PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
-                        (type == 2) ? "pr" : "hv");
-        }
-#endif
         goto err;
     }
 
-- 
2.42.0


