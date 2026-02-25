Return-Path: <kvm+bounces-71767-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBMpIfFxnml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71767-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB6319156F
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 77996304BE86
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DBA26C3BD;
	Wed, 25 Feb 2026 03:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PCKNnNpu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0IrKUx7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CA91A2C0B
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991510; cv=none; b=P+rjNfUedwDx9oHcLqccizpX9VMYlg/4k59DkysfLtE+PQj1lLZBce4ladVfaN4C1EnJqfIZA767SXarbI0qSU0xQz1W59ianUjqUDEcviT1ryekyJMZqJCS7fTa7otH3gornD1OjQjSFD3esyKd/q828RtCtWHOwjbH/DsGbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991510; c=relaxed/simple;
	bh=aIBZRHgTI46YENEp9vrLHz41j6MRIp1EPepEYfbUbms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIiPak14ii3QS9oLpSikg02UkuyWd1kQIgEV5RJt3Z9DLJu8VZ6CsRGtOT2H9yAQKmtAxS+aJw9wEm+j6zCrugsAgUFrhePYeOj40dLE5oYIj+Z85U9U3dEK+n7Dtp7c1XapW51SrDy/D5zJvl+ED+pOGyirG5lrvARH+odhvYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PCKNnNpu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=i0IrKUx7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M5fiyO5toFV4jV0KLoqJkMTJePRwiukufXlV5ZgaA7k=;
	b=PCKNnNpuinNn0tyFtF56jhmWMgsNgFkn52S0JNcMlDYw/jZuAM7s3W+RNC75roJ2BpVoHs
	Dmvp6ov5UTc092OWJ1Ax+fGOTq6NuRibD85Wj/n5QCveicLhNYAkwSUMR1V4XgfADJdesj
	f+/L31eknYZ7ZldpPGc5Lra0w0aj2Tc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-ayQOD52LPTScQelZwuW7fQ-1; Tue, 24 Feb 2026 22:51:44 -0500
X-MC-Unique: ayQOD52LPTScQelZwuW7fQ-1
X-Mimecast-MFC-AGG-ID: ayQOD52LPTScQelZwuW7fQ_1771991504
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354c44bf176so6356229a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991503; x=1772596303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5fiyO5toFV4jV0KLoqJkMTJePRwiukufXlV5ZgaA7k=;
        b=i0IrKUx765mLrAQ0V3B7+8bNroq5n5L3j4oTueu0Fi38fVQvdxasKWmws/+KON6Dxh
         f3Nir/rKVWHOE7MBVWm3foeniAYc54zxUeUUp8IvXtOXmH0pl1yH8qr+uni6ZU786n2d
         iDeC/wmmzl7H8KumFAhSzp5p3Dl+yt5MmeFfcCoMZJoPJ6j8mIJlZQ21L3YP60H1Tj8w
         WWGUkt2K9Aa8Md95ZEhTrUcDbliJff95bRkEAZY/U4WpJYHtMxsNKrVXOSpXH7v2epR6
         EPV7fg8WZ+iJ4lYG7SQ97+x3Ij115anM+kd8dmjkEPJErwZQq/VT2y2dOWUuUEjhGWkg
         /XNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991503; x=1772596303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M5fiyO5toFV4jV0KLoqJkMTJePRwiukufXlV5ZgaA7k=;
        b=hBPV1AVrCZVrCaSnLvHSa8RpoYXOegY96X01ZuKSA4ArPorbNQmAVKE3Um3mh4wAIm
         tfXxaCRani1wKUAV9ZFSsLJiSFnnldD27uO8i8P2XDWMa2ne9G+LgZ+FHqG0yB7a6AQO
         Zs8+ymr5XY87Ov1O5jiU8nvNNoJX3yDviDvs5vpexKPdTpq9LlkTiWgxShtQHwF1buKq
         i+E4/TKlAtGkvHQlUJytauc3rKBsP9KIG5IpbqeNDDKLGoSHUy3jMOfe2ICQzPD6VKW3
         k9S1ToVwl2L0nZKR1deOZaOWYHsffkHIYr/fmA/xfMEO001RWMgFwrZrVTe7kS0Ff17/
         fAyA==
X-Forwarded-Encrypted: i=1; AJvYcCWh9AXdVcAdnpxwoMsg7mVElLUwFxw0i8ew7aUIVN4yRv6a7wmMyt9nPvE4Xl6zS4ZD03k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhJaNH9wo0DGkZjHWzz/Ksa9u9rMZ+E44JmmC7opEmI6ZQI7F2
	M2I98PtYYFSeG7esmJf8aJ5tr5USddZ/PJGv0r8GiTD2d6nizn0Bwf6T7YZfZ7NoBK0M/Gbknm5
	g0xbLeg311PFhhRba5MPuM/UmDlM/bW5FbNEQ19Iei8NxsxYi+dUSng==
X-Gm-Gg: ATEYQzy0zpWJO0c+YKtHo3zNLgGrxEMjyvzSGadKLV+EjTsKkclj1uSokFOWEjdVxvT
	P+lFPRupTubaaBYXKk+OC3OyXwzBLIUcJWtkh8RhmAtmnusyXDPsuxfjSR889a/5AC2Qu/Pf9cX
	qlTHC38Q/yzal3is00SK+zpO3sZB0lMCRJlK64pi8qdWZRMeRx4ZMScB0x8D1KzgslKCSSU8iHZ
	LgTcYiDbmc4X3SellLXe5ihL6GhtksUHgBNYg+Tp/nOxL5ApH4krF3wuIYRUnQKdiWLNEfevxRi
	1mf23WMnJYnB7D/v0WBvwXw9Ep0KxveckXcHKIn7naIiQUEnpxrhGIMPqWi6kXbON/MkfEDNDxa
	2BjhakCHQf1zgxXrwhUx21Z1nEe80JJ+JvJDynehlwTUTPh2IcMmfVmI=
X-Received: by 2002:a17:90b:5185:b0:340:b912:536 with SMTP id 98e67ed59e1d1-3590f1f3c09mr822871a91.31.1771991503592;
        Tue, 24 Feb 2026 19:51:43 -0800 (PST)
X-Received: by 2002:a17:90b:5185:b0:340:b912:536 with SMTP id 98e67ed59e1d1-3590f1f3c09mr822856a91.31.1771991503196;
        Tue, 24 Feb 2026 19:51:43 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:42 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 28/35] kvm/xen-emu: re-initialize capabilities during confidential guest reset
Date: Wed, 25 Feb 2026 09:19:33 +0530
Message-ID: <20260225035000.385950-29-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71767-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DCB6319156F
X-Rspamd-Action: no action

On confidential guests KVM virtual machine file descriptor changes as a
part of the guest reset process. Xen capabilities needs to be re-initialized in
KVM against the new file descriptor.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/xen-emu.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 52de019834..29364a9279 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -44,9 +44,12 @@
 
 #include "xen-compat.h"
 
+NotifierWithReturn xen_vmfd_change_notifier;
+static uint32_t xen_msr;
 static void xen_vcpu_singleshot_timer_event(void *opaque);
 static void xen_vcpu_periodic_timer_event(void *opaque);
 static int vcpuop_stop_singleshot_timer(CPUState *cs);
+static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr);
 
 #ifdef TARGET_X86_64
 #define hypercall_compat32(longmode) (!(longmode))
@@ -54,6 +57,23 @@ static int vcpuop_stop_singleshot_timer(CPUState *cs);
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
+    ret = do_initialize_xen_caps(kvm_state, xen_msr);
+    if (ret < 0) {
+        return ret;
+    }
+    return 0;
+}
+
 static bool kvm_gva_to_gpa(CPUState *cs, uint64_t gva, uint64_t *gpa,
                            size_t *len, bool is_write)
 {
@@ -111,7 +131,7 @@ static inline int kvm_copy_to_gva(CPUState *cs, uint64_t gva, void *buf,
     return kvm_gva_rw(cs, gva, buf, sz, true);
 }
 
-int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
+static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr)
 {
     const int required_caps = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
         KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL | KVM_XEN_HVM_CONFIG_SHARED_INFO;
@@ -143,6 +163,19 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
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
+    xen_msr = hypercall_msr;
 
     /* If called a second time, don't repeat the rest of the setup. */
     if (s->xen_caps) {
@@ -185,6 +218,9 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
     xen_primary_console_reset();
     xen_xenstore_reset();
 
+    xen_vmfd_change_notifier.notify = xen_handle_vmfd_change;
+    kvm_vmfd_add_change_notifier(&xen_vmfd_change_notifier);
+
     return 0;
 }
 
-- 
2.42.0


