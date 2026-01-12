Return-Path: <kvm+bounces-67748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD0ED12C51
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6CA0A302DDCC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD033590C5;
	Mon, 12 Jan 2026 13:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVaEK20S";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wq2G7wRd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC812222C4
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224275; cv=none; b=oJUk4un81RG2fe/HiCoWj9q8qmNWEAF767okYvyGEasgy7lmIMb/dS/vWQlksyYBTnpgyY1vPn4MsR4/iasLx+zQuIy7o4MJys4qOMAOSqg8G23Xah/qD/1TYX/pYqhgpDUwug2q6wy+HAEEyIp7Pl+PPULZTXHRhF5u2nUuao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224275; c=relaxed/simple;
	bh=jyJg/5KfLRSEXuH6dbTE7ntAG/kp5FZktT6NE+9AVh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEff0WypI0aIooAJD/PQRSYaHKY5McARYjPuC2MaNfQ30nj5rJ2vNDJtXfDW36XI6tnz2pkVYvOyiUkiNPfcMY5W/Y8AJNI9oxs9ztSZD01CAe3vZWISLV99SShRBk9I72yof/DM7CwE95+xTuJgsZm/3+fmKfmhjgogV1k+XXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVaEK20S; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wq2G7wRd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RpRJ5BfFh6w1tZPB1hD41jTrZGWAAbYwgmsxDiyQj2w=;
	b=FVaEK20SJ5yC+lKjpRmDum1PFAwSvD0/obYLtc6OmPF/63XhGYO2jna5AwcdLHbKtB0Cnh
	N7iX7FaSzBcNhCp9QMWtUEpORKHmjOz20Ip8Y4n7mDxjYj/O1FNV83fwiYpPhjfiNjvD1Y
	ulH9N++ZTMxNeZqbO6TCfIL/WFoLPXo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-QR5E96g-PzCAcWXUvF4j3g-1; Mon, 12 Jan 2026 08:24:32 -0500
X-MC-Unique: QR5E96g-PzCAcWXUvF4j3g-1
X-Mimecast-MFC-AGG-ID: QR5E96g-PzCAcWXUvF4j3g_1768224271
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so7609236a91.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224271; x=1768829071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpRJ5BfFh6w1tZPB1hD41jTrZGWAAbYwgmsxDiyQj2w=;
        b=Wq2G7wRdTPNM8NeXET4I18Z1irltRW9ElQVc6g+2rrAQsfnVbfQpGvwxKCLj1krNTX
         FCjtUmotpd0ANOxkug8t5JJgDnxLBRrCbsdwY+ThUcE0O+j9k8Tj2Q/Ydabxvw0ShWm+
         ePuR48cgHJieGt+tn51oZ5cW1dtXUg4gSQFuOurbu6AligIYigmrHDTbq8oF19+GrIkK
         JvWnaxP5vmWh3XNQcamFuU+BEYppWR4248TgnfdvX/YuFh6DIP8yU5quRUoxCr6h3dpi
         IXHLnoMjzTVSeSAAPa/rkomOt+8WT4B8i+FYFFhlm7KmVxpbh1fJNfjjYibO4S6vOMsT
         Rdbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224271; x=1768829071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RpRJ5BfFh6w1tZPB1hD41jTrZGWAAbYwgmsxDiyQj2w=;
        b=kVG7OQUNOmY92deFCnTYbArshbEBUh7viznHVhixEAKtlPTIiUJD42w7nixyLAd3tY
         cIaddIVqkhV64uethuO3RjNSvMElxUefQQttq4itN0wRpCna6BCODu3ceQznnA3GGc1a
         v3Tkgyesa1U8YBUHXF/EMmmK9EILykHuctTX8zZayHbxD7HZav/Ipi8FnyjNKthCmBD/
         oiY1ebPT2VET8B1iHvmzrZpVvVqqrqR25QAcOvhk5a7Zj9kmN/NDDU6f4vBSTEIIRO1K
         gVg1w2pgPc7AEGqG+VuUVObr/l3DAzOtg6ITPmkoxJ7x9yUgDlrK784eAW8V/SC4bJW2
         yhVw==
X-Forwarded-Encrypted: i=1; AJvYcCXpwzwxFstY1YtokyzNqGRH3UrqAn0slT+gNBYlX64cuzHdKooEVzZ2uwdXC+Z8dDk9AK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAh1bbKCrbiUbXdytMP6R0NxbO4Nk2LZ3oHHb/Sz6VgpUX6WXU
	Qf3jjo9yL4+oXJkTj7CMyqMNirEDv1cpGFO2wq/bW15y/i9ekFKK0eGz41c9heti6ucGSaZcjhL
	tKrSgZBcqrrM3FJffy/b2dqVsakL+IQzODpAta9YMGQLuOhn83lD1KA==
X-Gm-Gg: AY/fxX4f0jhoSg1174c5M175AxsbPEJmKFkFDBgFy4NU37sQosguKcGzfhLW99KlvUK
	5sqghvfkGeIfr2K0GXdgd1/bKo7INNBrQNnNKaoPHhCKJ9hTPhc943wC2wVfQoGZMSN6eW0+5/d
	baYdZG3svAjNNIQTYqEcHlGpH/dolZUYoFY+itCcum8iQ6+KDYw3LXxOo5YK1DaOLKdBz2JjbE5
	qAYmGTjQQ6IaVE77XlLI0kraW9BqtO5Fv+x6XNcAAD1pfxtExioqjT1OuM/wyynBZMZWWBF2vnu
	BJ7O7oYqg0TWz9tmb7jzpGdPgYdxTmAoqmky8F9kgvbP/ECutGVBbdUUSLcl/Zs5RM1omFxheSE
	s39gPLNkAgWAl2V+89s3r8hHyzjKNB3a+dp2EPGL2mus=
X-Received: by 2002:a17:90a:ec8b:b0:34a:4a8d:2e2e with SMTP id 98e67ed59e1d1-34f68c912a3mr18358605a91.17.1768224271322;
        Mon, 12 Jan 2026 05:24:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKfMO1nNe9YkfbS9kvxYn3RL7QyyACZ9YBAdaWIhk2qR1dryaLY76HSePS1Am5ohAQYe5qyw==
X-Received: by 2002:a17:90a:ec8b:b0:34a:4a8d:2e2e with SMTP id 98e67ed59e1d1-34f68c912a3mr18358589a91.17.1768224270927;
        Mon, 12 Jan 2026 05:24:30 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:30 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 25/32] kvm/xen-emu: re-initialize capabilities during confidential guest reset
Date: Mon, 12 Jan 2026 18:52:38 +0530
Message-ID: <20260112132259.76855-26-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On confidential guests KVM virtual machine file descriptor changes as a
part of the guest reset process. Xen capabilities needs to be re-initialized in
KVM against the new file descriptor.

This patch is untested on confidential guests and exists only for completeness.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/xen-emu.c | 45 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 52de019834..4f4cde7c58 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -44,9 +44,12 @@
 
 #include "xen-compat.h"
 
+NotifierWithReturn xen_vmfd_change_notifier;
+static bool hyperv_enabled;
 static void xen_vcpu_singleshot_timer_event(void *opaque);
 static void xen_vcpu_periodic_timer_event(void *opaque);
 static int vcpuop_stop_singleshot_timer(CPUState *cs);
+static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr);
 
 #ifdef TARGET_X86_64
 #define hypercall_compat32(longmode) (!(longmode))
@@ -54,6 +57,25 @@ static int vcpuop_stop_singleshot_timer(CPUState *cs);
 #define hypercall_compat32(longmode) (false)
 #endif
 
+static int xen_handle_vmfd_change(NotifierWithReturn *n,
+                                  void *data, Error** errp)
+{
+    int ret;
+
+    ret = do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (hyperv_enabled) {
+        ret = do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR_HYPERV);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+    return 0;
+}
+
 static bool kvm_gva_to_gpa(CPUState *cs, uint64_t gva, uint64_t *gpa,
                            size_t *len, bool is_write)
 {
@@ -111,15 +133,16 @@ static inline int kvm_copy_to_gva(CPUState *cs, uint64_t gva, void *buf,
     return kvm_gva_rw(cs, gva, buf, sz, true);
 }
 
-int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
+static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr)
 {
+    int xen_caps, ret;
     const int required_caps = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
         KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL | KVM_XEN_HVM_CONFIG_SHARED_INFO;
+
     struct kvm_xen_hvm_config cfg = {
         .msr = hypercall_msr,
         .flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
     };
-    int xen_caps, ret;
 
     xen_caps = kvm_check_extension(s, KVM_CAP_XEN_HVM);
     if (required_caps & ~xen_caps) {
@@ -143,6 +166,21 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
                      strerror(-ret));
         return ret;
     }
+    return xen_caps;
+}
+
+int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
+{
+    int xen_caps;
+
+    xen_caps = do_initialize_xen_caps(s, hypercall_msr);
+    if (xen_caps < 0) {
+        return xen_caps;
+    }
+
+    if (!hyperv_enabled && (hypercall_msr == XEN_HYPERCALL_MSR_HYPERV)) {
+        hyperv_enabled = true;
+    }
 
     /* If called a second time, don't repeat the rest of the setup. */
     if (s->xen_caps) {
@@ -185,6 +223,9 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
     xen_primary_console_reset();
     xen_xenstore_reset();
 
+    xen_vmfd_change_notifier.notify = xen_handle_vmfd_change;
+    kvm_vmfd_add_change_notifier(&xen_vmfd_change_notifier);
+
     return 0;
 }
 
-- 
2.42.0


