Return-Path: <kvm+bounces-71240-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MLCkJRCmlWkxTAIAu9opvQ
	(envelope-from <kvm+bounces-71240-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED98155FD9
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40368301FC81
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50AF30DD37;
	Wed, 18 Feb 2026 11:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vv6AQx+7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="V51mppOo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45F62FFDD5
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415054; cv=none; b=f1i1yCMg3yCb1NkI7w1M8lb7r5p7LEBY69aB/4cy8waWoATGjFCtuR/qoeSAeYT0SsSO+xPKOQWPxnP9mqH18kSINW9yyqhRW4lBAoKQa2FJcHTr4q2GUaPue0yLezAD2w32HfHRNSbuvzCaoac7UcuXQTxNuZYS0ZDhAABMpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415054; c=relaxed/simple;
	bh=IPksgd8tAPT00FC5dIFN5ta9KlatPLxmHV9qZYXJIwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRJNGJvJHclf0BfDS6RUebGiBQGHbIPzghxCIuheYPcRIYp4glNmYa+IccFWy/wvnaAuDMl1OS5ZfAsjkufkncWfipB/quOVzzC+WKepJZ+z1EVk0UaOgQhA5sY4ihfCHS4ASWPcPH9KOnWMTOOneUnt715w3U4w47PTujqaPx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vv6AQx+7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=V51mppOo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771415051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
	b=Vv6AQx+7FPzipL5BqjdS5w+JCSSTM3QXlwRnihfS1FA4BnlWE/4fbIo2/SQB0w+CoOyhUS
	c1eBpLxHpEyKC3+up4q0XZZCBGNDxWDMStE2NxQdhVwZhEEQdmTVS42gLvNk9xJMwuan8C
	cIdWP8mW7t/3UCMlx5K5b89GuXrm3f4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-2e4qMdQRN0-W8op5WGQX7w-1; Wed, 18 Feb 2026 06:44:10 -0500
X-MC-Unique: 2e4qMdQRN0-W8op5WGQX7w-1
X-Mimecast-MFC-AGG-ID: 2e4qMdQRN0-W8op5WGQX7w_1771415049
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aad5fec176so64552755ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771415049; x=1772019849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
        b=V51mppOoA7i8HNInrjgLd4aDUaHJyXemx1f1nxyij+MQNEnxrgNuJf6xbmuPw2T4Ei
         ZMFp/lyrIPrqQCvAA3Ww9U3G7fi86mSilfBbDEhpS6PUdwdR2egFWu4RHPR6KKScM2hi
         hGBcH3eZ116WbKi+JD8jLIQXZIgijjcDWwVbYW6h7n2uogNVFAThNl7+TL7lttXvZ13T
         q319jtdRwMOAs/w+54cX4QpujmtC9yP+HI4ZXxocfCFDXw7xdType3c3myHJgJzmFrrt
         7jEiJxu2KFSgLxmlOSo4ReCM6e0MRGvneriRPGRkUZrKZK/F4fJ5EgO7g4jlXPAImtxj
         D7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415049; x=1772019849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
        b=KC5KzWgUNi7eJzIhzEMURPDsRGtLoo33gknoyWc4TsqIathvskUMYWu3JE3YImptz5
         ALE0FoYuF0hpYVSnRxJos4Yks4+6dZ8ZlfzPMRFWn+5hF7uv+I4tu4kbNHF70JANMFug
         +MnHaFV5u6SNYDzHu1xxLKXE+EeirG8V8HIDbOuuHfrQvVn1qoa25z2q8Jz1UV5d6ouH
         T+9Xs0JFXJSxUjKh+L0Daotb1vgFOLtuC1t2kg/OZKMWxP4OXgW8V3sVOooB1Llx/ZzG
         g13PvFOiQP7wHznd34NHPH7MryXlIGSX4pY7m0Lv/xIxtZRcIF7ddDCWvqAyzRAXZxt/
         Whig==
X-Forwarded-Encrypted: i=1; AJvYcCWNjz05gSi5eBG/Q4iDyEwfE8HVkULTULpT66nsm/qTGlDEBsd9wS8rxhGM5t+SpbWT5eI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX9yjKOepbZo9UwJjFyZAqpKh6/f/XuhwVcE0BUk06yKIrecP+
	1gHTu7a+XPLNjKKsQFw9PXGr2HBFhTPAJZrRpQSxKG1/ZrF1rmDGc8pRfpVQw4jYQqJ6TvXjGJ5
	0za+EdCoeHqxz1aTjom5PesveVwsaIoPHzWwXSm28+leGYGrMwKYUjA==
X-Gm-Gg: AZuq6aJ76xlcGpigzKetgYOqCGVhwfjgRHcXNO+DRumLXkj7mFnY+bb89e2rRcRHqrm
	oIzucVRDKs6KmsRoO4d7kV+qh5Dg7w/mXFfMQNmc8OPIVqBLCNV4DZHAu7l0H2ghcRcl7na7rfR
	ldhiDjmOnCLPRdm8+Td2FM2/N6kEdpTgubM63zkqB1LRFOIDz2NrLZbx5fXrVLCrjlAExHjo/D2
	GNPybcKSaVi8RWWQOXMfAIctXwEkXXJDD5eWMPCIjXI0SYq3Q3ig0dqvuVSa8L/aSFOp3ZWq84v
	XWeQ2q/rOF/EwlWqEZdrabFLXZKZouaTJrmpv/SBSTS1WrkrylKGb6z0hMa/kyl8RVlUzYRxrQw
	COYQD5Q50JK6iX9zEUR5prx7VAENhJNlnyN97B0pgeZgQmlvRZdaA
X-Received: by 2002:a17:902:cccd:b0:297:cf96:45bd with SMTP id d9443c01a7336-2ad50eb31b4mr16065735ad.19.1771415049247;
        Wed, 18 Feb 2026 03:44:09 -0800 (PST)
X-Received: by 2002:a17:902:cccd:b0:297:cf96:45bd with SMTP id d9443c01a7336-2ad50eb31b4mr16065545ad.19.1771415048913;
        Wed, 18 Feb 2026 03:44:08 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:44:08 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 27/34] kvm/xen-emu: re-initialize capabilities during confidential guest reset
Date: Wed, 18 Feb 2026 17:12:20 +0530
Message-ID: <20260218114233.266178-28-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71240-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4ED98155FD9
X-Rspamd-Action: no action

On confidential guests KVM virtual machine file descriptor changes as a
part of the guest reset process. Xen capabilities needs to be re-initialized in
KVM against the new file descriptor.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/xen-emu.c | 50 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 52de019834..69527145eb 100644
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
@@ -54,6 +57,30 @@ static int vcpuop_stop_singleshot_timer(CPUState *cs);
 #define hypercall_compat32(longmode) (false)
 #endif
 
+static int xen_handle_vmfd_change(NotifierWithReturn *n,
+                                  void *data, Error** errp)
+{
+    int ret;
+
+    /* we are not interested in pre vmfd change notification */
+    if (((VmfdChangeNotifier *)data)->pre) {
+        return 0;
+    }
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
@@ -111,15 +138,16 @@ static inline int kvm_copy_to_gva(CPUState *cs, uint64_t gva, void *buf,
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
@@ -143,6 +171,21 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
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
@@ -185,6 +228,9 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
     xen_primary_console_reset();
     xen_xenstore_reset();
 
+    xen_vmfd_change_notifier.notify = xen_handle_vmfd_change;
+    kvm_vmfd_add_change_notifier(&xen_vmfd_change_notifier);
+
     return 0;
 }
 
-- 
2.42.0


