Return-Path: <kvm+bounces-65842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 397FECB910C
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31FCD30E1AF2
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A0C322C70;
	Fri, 12 Dec 2025 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxkZk5A5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ebfSgape"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D5930FC30
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551944; cv=none; b=ZhJFkeV41t4zJPu3SGOtgzCSrm63fjD5DADPKpdy1wCL7Fs1T97wS74wcW6kK+/d2fEoMldPnKIjJwvVevqxrpZNgAVH/cIK1nZzA1auzHRkPk7MxmiqnKQf0nCm+v/cB5xLfi+sJmeRoBXHTFYz6BEwyxtQFhTpjpC99Lct2dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551944; c=relaxed/simple;
	bh=1eXSunyG5T+vf76raZGhgxOYQ4kFOashEutfltpWdS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl/B7lR5wHhpRKeTl8nEXJ1yC6rsDQiC6viHUaWf/6g1qLBqzmoM74aK5coEALSR3fTq+j7iH05HaUGDln3AyBeXfvuuIcaTzArhcx6rl41jHFmCmW+FnG/byVyM0lL0loEnNwiD6/PTm6c5mW6cpjdW1UuuVvqIbb/YBINGej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OxkZk5A5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ebfSgape; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JNcrE+4f8j63y44F5BmyHdkxQ8nR4MpXkUljLFk9KRg=;
	b=OxkZk5A5BvcmED+0FBzWtdWfZvvFRywwNdaDdnOSaQl3CegfBAPRTePnRS54Csk1VaOz/0
	UwJNBB3sBozxwZur2p/drGNuw00ZBwYALHRivNpC4/CQJiYWY35/ANx2fPWPOUyPjX1t03
	GI7hclj9JNaI5iaNedS1TB002XiLFsA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-Hb_4vfCNOFKCU9z0REWOHg-1; Fri, 12 Dec 2025 10:05:39 -0500
X-MC-Unique: Hb_4vfCNOFKCU9z0REWOHg-1
X-Mimecast-MFC-AGG-ID: Hb_4vfCNOFKCU9z0REWOHg_1765551938
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29557f43d56so16175605ad.3
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551938; x=1766156738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JNcrE+4f8j63y44F5BmyHdkxQ8nR4MpXkUljLFk9KRg=;
        b=ebfSgapewXfihFzEDULZKVlWkhju8duu6Z5PB7PzF4CA09I/pIUHocTsYjpD8HzZ03
         zenVijIxF5RrXdG8DBc0TIGqie3MirN9TvHRoXjtcb4dlEYRraAJ8aNNV/Va+tqhc9QJ
         m25W91c8i0sY+cxNgEcL5FRaHscZAGUhQn8ehAHJvLBRhjblYLLrtkQjqgu8W9xJazlU
         J2kk+9yMBHbWHi/NQHrG0y2YN7bSQlZuiWEBqtXqJBlaSnGcvWdF+WjdKXDskdIUm8H+
         H2xPwwzeXMLd33nzYissBW8s9VS6TdWBuiXef+chcixfu+1uGskv9Eqj7j2hmSfLnjah
         7gGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551938; x=1766156738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JNcrE+4f8j63y44F5BmyHdkxQ8nR4MpXkUljLFk9KRg=;
        b=KKpqP/wB1Oz9zg7q3akc4mM2zebLiWfqDLMQAvRb5sFMdgLWM1L6xewYGzVxfNdXnl
         rGJtKuk/KilFDVPvVah+KpzXWeB9eAmzAlfLt/vPeFrt0o1/9fCfayG7VOgBVr40P49s
         QYxHojQ+ku/iG8P33nTYtqA+cTURZefuN2a3Q3uwOr73NM//csEArUcHUysLgg6pG5Hc
         j+VL5hDPzPzbStaR54/s3mu6J3LlEiJj4llXHX0qwChcdWtchhD+xKzJrtBe8VRv6Fo6
         xo/PMhpi4bZr8OI6hsT193V8bs9E7RwQuSYv0wXbzvtVj+U7mnp0gHei2SWXUFPY2hKA
         9fwQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+f+jv+T9byRf3695WcJOPREa8jOKJtmxWjpqGMQm+dYpRZtO2ZAJimVBdgGhCOEQkEqk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx22ikR9mdm090f5s5D0m5dz0rZ05RGa8gz81PYZe4ixLR5MY3w
	kdAhJ6dj05J98W6ej4rC1uPeqsGIa8okSBC5y7GRLSKxyD6Hb8CRgfERQra9FvgZCc8PbB0z82m
	DewdMZMJSCGDYNV/A9Ace8hgx4jxMScOCczFn7qUhhAt6X0rLuMEB+A==
X-Gm-Gg: AY/fxX5MGEiHewS6t2x9Z8ZK7/1qs31R7Tn6NnsX4cr9Ta3xanvuoswqD5v8tSirP8q
	oxY0QDFuRY2hy9up/wKUEYr++Oo+j1E9l6NwV/4NF12eeVZfXjPi5QIjAZXLt+XJwpGlQvJugw9
	j1QNjLwnymUQTNvTTTCM+8CAkEVsEKCRCV8o7AmQT32JftXGMKA6OwhiF74i0t3TaZHSEYq9A8r
	FWGZfr9ZpSOCed/bmKwz7dm7uFi0K6G2IsdtQSI8WDadowpn56Y4LiWZc0TI63ciS5qyMn6OG1a
	q8f5n67Uonqf2DSsd9o1KfID8W0FycfpD68eSZOOGhXq0XNYNjUrAt09Up5l1+70wJJpMAwxzIk
	+YDBUaOYSpykgaeZZCDIE7YsglfUzCrOqyZQsW6sNzQg=
X-Received: by 2002:a17:903:2cd:b0:269:82a5:f9e9 with SMTP id d9443c01a7336-29f2404b62emr22001795ad.29.1765551938073;
        Fri, 12 Dec 2025 07:05:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnq9WRvTLwHHfQ5V/fKnINCsQGztH87yOnmYhTJLhbvtEkf/NeEcL0ENt723AVANrzo/wAIQ==
X-Received: by 2002:a17:903:2cd:b0:269:82a5:f9e9 with SMTP id d9443c01a7336-29f2404b62emr22001405ad.29.1765551937580;
        Fri, 12 Dec 2025 07:05:37 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:37 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 23/28] kvm/xen-emu: re-initialize capabilities during confidential guest reset
Date: Fri, 12 Dec 2025 20:33:51 +0530
Message-ID: <20251212150359.548787-24-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
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


