Return-Path: <kvm+bounces-69205-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADSRF1BLeGkKpQEAu9opvQ
	(envelope-from <kvm+bounces-69205-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:21:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C59CE9017E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:21:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8DA61308B02A
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E34329387;
	Tue, 27 Jan 2026 05:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OBdsiD2d";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYpm+O9P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869A9242925
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491077; cv=none; b=H5lntwAOfBHAfkSTrcZ490uDInyIh4X5VXulQnj6Ibhna4ZEqi6TCU04VPoyB291JeTzcIPu+VsLEhTCnR3iLzPpkyOW5rG5BPH/kTocq9YofRJEEY2vfsyfBk6zex79F8+WpLvHgJEwFGlVJfswN5Wx2yrsCbkmYxMRwm60B1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491077; c=relaxed/simple;
	bh=IPksgd8tAPT00FC5dIFN5ta9KlatPLxmHV9qZYXJIwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/1sTVXWvUSnoibs8H1HiClmf8xhegx5ReXT+mIAxtW8Q+B2xEccaG9xJSUxqP7WyLJH+R3N98dzxRHzF2ck1gL+9bJPkbLSDyZDnEoPLx6UVXM+LGdbWsB5NZNc1Z5Ak3LRiV0H9BYR98cQ2dP7VcF1CmG73fdw8dpl04GfA4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OBdsiD2d; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZYpm+O9P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
	b=OBdsiD2dgxJ2fSI7pct5bGF79ZKLhUmZB1RAJhbkoaOwFeTT6Avv8GUjdbgywa34WQRSqZ
	I0cbwRyB/+30/3ClEj2tc+cMXMrCoY6IvXWGd9Tg8SQi8YjsqA/0q00rYC/L3wl9ftDa8c
	STzD8BOT7BKb6T4cgB7Bfbe8k8lvAMk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-VrdL-yAzNj6ijWXBP-qsGg-1; Tue, 27 Jan 2026 00:17:54 -0500
X-MC-Unique: VrdL-yAzNj6ijWXBP-qsGg-1
X-Mimecast-MFC-AGG-ID: VrdL-yAzNj6ijWXBP-qsGg_1769491073
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b630753cc38so9673078a12.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491073; x=1770095873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
        b=ZYpm+O9Pr3DTKtATWpEcKqOgRjdKmw4B1ovQfLhE4UvsWvZEXogREtKzYDbCwD0BR/
         Jy/4H2XsBpQ4d7LeXyFugwYsE7cQ5Lx/kF9OR9+6R26zI5qAc5QH9T62NEkYJSxI7FLt
         p75c52MLvVQ+Yn9UN0shqN7j3NESob0La85tkrlJC0lK1UYBrw6WpGup/YtTQWg1cOfH
         JCXRuQG2CXjuJb8NpNhHDZSmQf5dWrMkvgUCCYSMD2oSONcqV30db7uFBiwXkEZnA1w3
         d7DymgZeughYk+S+Vq6Vo2p/sqf++m/uu6Dh1AC7T5eD7RFyuChsMsQgffSKcj6L+n8O
         KOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491073; x=1770095873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lc7U1GbS1JHxjc6G1Vv9nRCpYH775c/aB7pSkgG/wFs=;
        b=JGOxjd/a+x9UOTqRBizk12Hv9YuwrJLVlZWzsy52+J8pUypq9pyMtxAlgPvgRCalmv
         ffsYxEPcao9pzzvH/hbNX+Eg91wO2b4C5rGzbUqouWwr0y/GpMh1Gs5RVTmgqweHjrdM
         bnwLwm7IsPl34T14tluuZi2D+m1myZB6dQwCyb/2ZG02el2dP4qz5IQyrYU+vUx0fzCo
         iuFaM+/SBl8nK4GABMMHvpkNEFwUwQFefeYTEgg0fkdjmJR2pK2NLK3Dgir1GmZjSkTD
         UzQYWx4QvQSQ6jHwUVkR9zXY4NHqKF4pFM1fV43lcCD+XvYZHIHYv1wmjMNxYQqYE9K1
         HoWw==
X-Forwarded-Encrypted: i=1; AJvYcCXejt5IRAmNgqALRpxZKGEjaYJ5GLlh2riu8ulA2zqBx26qjzSLObdTBggWW4tbhnuYXrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWUECFK4gPCX+fBHX4nsa34v8z/nSp762wMB/D1uC5laWw6J2M
	TGIozfBF7QXvGO7fO+F4TzS45e1mqwZ3jYrKHKBYICub9lTekrpU5dT2DX6kNLfzdOTNkIW2RzG
	8WsTT3SAQ3hDj/H1VXJxNOO1qJ68Lq2pKu4ziBOv09ejpRjIL4mXYPQ==
X-Gm-Gg: AZuq6aIpuGYHnLPbCk3n+CAumXY2GZ6/oZ28nCfnagW6qgbzKWNnYKVLPv2P0WkBcd9
	OoX4qwSOdB8gDoGn9zm+eK7OvR3RS4HPnL2kIYygYwaDGc8aCXDLCypxmdTjT16HAHEyvF9ekUN
	VMn3xgIA89FN9qHcv9+Og/y69TNl/tHGDnTuC6uBGnssw0wZPk734qfpEYAiMsAxqP4INqWX9La
	ygf75sIog6x0wWCm9tRzZYnvWiTzFtaLP/It6JaP6sR8aOrnnQlt8Kane/xVvVQBE/x6Of4NpzB
	0nxlMis6WEifx8gl/v5fE4c/L47HqKV5Bkyn2uR5geVRCHECWZ9XsPIWTiYUPrmXPIVU3hOx1c8
	RPaZKdmedWpvq7JHZWkmW/V1YLg3tciINj+Ou3IyScA==
X-Received: by 2002:a17:90b:1a86:b0:340:776d:f4ca with SMTP id 98e67ed59e1d1-353fed9c9f9mr708737a91.26.1769491072938;
        Mon, 26 Jan 2026 21:17:52 -0800 (PST)
X-Received: by 2002:a17:90b:1a86:b0:340:776d:f4ca with SMTP id 98e67ed59e1d1-353fed9c9f9mr708718a91.26.1769491072587;
        Mon, 26 Jan 2026 21:17:52 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:52 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 26/33] kvm/xen-emu: re-initialize capabilities during confidential guest reset
Date: Tue, 27 Jan 2026 10:45:54 +0530
Message-ID: <20260127051612.219475-27-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69205-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C59CE9017E
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


