Return-Path: <kvm+bounces-25232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7AAA9621DA
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 09:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F434282DD1
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 07:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B73015B552;
	Wed, 28 Aug 2024 07:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gKUQIaDN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C5D15B10E
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 07:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724831812; cv=none; b=tD2627lIOk8Gao5IFfjGbM2lGD/yLeQpp3kPrkFLNFbh4iDS/VeVrb9zjJPK0FFVU3TfJ8bzFpqjdKMy/E7cXHkFQdkmQvRKdrL0AFndZncX7jpSyeSHXXkNP+dEkLpdVCgQq5WMQVXnK47K7kIl23RBuHErTQfr1ssJni08zao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724831812; c=relaxed/simple;
	bh=I70JZdMDL1O7ekktfEOR+rSvYTxjzC2eN40c0XnBc0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNlFnylbPZGRVcLyTX2w+iNwBClxD3vA+lmGReGe+XhXtlN/TBJlx5rzXe7XvO1ZtOIe4jxszsnjJqzIfSpq58ghI//VmgUe2oQL9/lzJoKctJUuZe0MoZNYosjqnUoJsFxjqoTLNDV5bQKT/dcZ6XxpPn+zFueXKKuu5a0csr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gKUQIaDN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724831809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zYl3uaCkxHjT2nDUPL1WDle3wL/fOkENv7M02v+JPJY=;
	b=gKUQIaDN87zxthEiqYIYbBSEqQwloMn60Fxtbv0sMIJcszFEEOSQ+clgybuHEzIg4/7+H3
	ZYfi4q+Ha/a/sd47dDjGFccjOJapRZdxtbGi3tgoPVeksH3AaoCT75laGVjhpApjv8RRoT
	dFgocKvPQShPJBMqkjozIto3vxE8yn8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-OUWt5Bv2Oriai92le_RE2Q-1; Wed, 28 Aug 2024 03:56:46 -0400
X-MC-Unique: OUWt5Bv2Oriai92le_RE2Q-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2d3bd8a0bd4so7319018a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 00:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724831805; x=1725436605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYl3uaCkxHjT2nDUPL1WDle3wL/fOkENv7M02v+JPJY=;
        b=B07EgZGuRichet8NlkslcwX3rhB1jpSWo+gI5vbDkMvNTBdXz0aJ05Ad8Nmhxxt7hl
         jDWISJMa6ne4bzWI8OGKkXDIfgq4MQa0mwnsZ7NdPiJLby/oGwLpKwKvTICLmDTOxE5L
         67vseEKeoRS2h880O+Nr5TCJke4Owa7OFE7g0boEDB7157jgGZMsVGaZ7DoLeubmqBxm
         OPYv6h8s/6AbG37Bff9KnNg+Rv1BYaCMv5H6+7LyM+xjxwIG19NZr/9zvwnAsN3wlz6T
         xZ+mNcVaGV04xStMG0mntOnSmuVmSU3chXFEGO9/y5S+sW4ZYsuWruPn2GbzZ2WRns6K
         mWfA==
X-Forwarded-Encrypted: i=1; AJvYcCXgzoufc9sDmu0b47SrN+y1ByifQYcyBqqTIrMU7vGFShm/Dqleqzh26x5Bwzu8uoa229o=@vger.kernel.org
X-Gm-Message-State: AOJu0YynVdPLFRMc/tp+PHflNboZ3q/16w5iLLq3Xxyb2cQXo0yAqq7U
	JyVwesNG0nXyGq+AtkXjm2BpEJ4mVGWKjA+NJQ0EDrT9thYyLT0vIbHrfmXmLUqBMQFqfA98+IA
	Qn19QAZB+55mpnlm3e8+IkNQRoGP42D7yP3/E7WMXpjlYPxNngQ==
X-Received: by 2002:a17:90a:7408:b0:2d3:cc3e:4d6d with SMTP id 98e67ed59e1d1-2d646b91092mr14510030a91.9.1724831805451;
        Wed, 28 Aug 2024 00:56:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnS9wmiNKpmg/gLxiSQVdrbd8UyjUO09X7ptuxTKXWPb9mBB1kZo5ol5VgojZc/qD+8UvY6w==
X-Received: by 2002:a17:90a:7408:b0:2d3:cc3e:4d6d with SMTP id 98e67ed59e1d1-2d646b91092mr14510013a91.9.1724831805035;
        Wed, 28 Aug 2024 00:56:45 -0700 (PDT)
Received: from localhost.localdomain ([115.96.157.236])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2d8445fbf0dsm1013534a91.19.2024.08.28.00.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 00:56:44 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	zhao1.liu@intel.com,
	cfontana@suse.de,
	armbru@redhat.com,
	qemu-trivial@nongnu.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 2/2] kvm: refactor core virtual machine creation into its own function
Date: Wed, 28 Aug 2024 13:26:29 +0530
Message-ID: <20240828075630.7754-3-anisinha@redhat.com>
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

Refactoring the core logic around KVM_CREATE_VM into its own separate function
so that it can be called from other functions in future patches. There is
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

v2: s/fprintf/warn_report as suggested by zhao
v3: s/warn_report/error_report. function names adjusted to conform to
other names. fprintf -> error_report() moved to its own patch.
v4: added tags and rebased.
v5: rebased.

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index fcc157f0e6..cf3d820b94 100644
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
+        error_report("ioctl(KVM_CREATE_VM) failed: %s", strerror(-ret));
+
+#ifdef TARGET_S390X
+        if (ret == -EINVAL) {
+            error_printf("Host kernel setup problem detected."
+                         " Please verify:\n");
+            error_printf("- for kernels supporting the"
+                        " switch_amode or user_mode parameters, whether");
+            error_printf(" user space is running in primary address space\n");
+            error_printf("- for kernels supporting the vm.allocate_pgste"
+                         " sysctl, whether it is enabled\n");
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
-        error_report("ioctl(KVM_CREATE_VM) failed: %s", strerror(-ret));
-
-#ifdef TARGET_S390X
-        if (ret == -EINVAL) {
-            error_printf("Host kernel setup problem detected."
-                         " Please verify:\n");
-            error_printf("- for kernels supporting the"
-                        " switch_amode or user_mode parameters, whether");
-            error_printf(" user space is running in primary address space\n");
-            error_printf("- for kernels supporting the vm.allocate_pgste"
-                         " sysctl, whether it is enabled\n");
-        }
-#elif defined(TARGET_PPC)
-        if (ret == -EINVAL) {
-            error_printf("PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
-                         (type == 2) ? "pr" : "hv");
-        }
-#endif
         goto err;
     }
 
-- 
2.42.0


