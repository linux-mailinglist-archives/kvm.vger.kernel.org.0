Return-Path: <kvm+bounces-37594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4673A2C5A5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 15:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C506F3A951A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A3623ED6D;
	Fri,  7 Feb 2025 14:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f/FhYyVX"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C2E1DE4DD
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 14:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939051; cv=none; b=OLny6ms83cgWuyskVTtyneJwiKmE/UEvEyTch82qGACtugS0xK2CBeL65z0QZchKjBHYvW4lbHuqFD6Hv4XEY2RoPsUzRfNnKHxa2L+FD3u2qmgUCnnXQVgtokC1xopm4ATk0PU0CUFo076wl/z5JY//tXqZC/11uV0gkh6IRDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939051; c=relaxed/simple;
	bh=Vnymuty3u6WwYF60abTNaCqFw+aN4pSr+S5YnHXeze8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sSJ01GFfwO/i8Rb17DJpLAY2NqBW+0+xbWLkGzYkL43iSioriHrz4/a3jUbdRrmzr7Pk/VPAeGvip2IcMpEHX1l9BqZbUrXeLJBjNh9SbUnG4tR5VE/LcKt42L6xDYtb4VeB6X2NYpXfBYuYZf/e4bZTeWGTYi/ttIDYdMogQlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f/FhYyVX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0iLbiXf0JAInaIYlB0oBe9NqYMClY9KNDWGNrILCnR4=; b=f/FhYyVX1yiyt6eD5J0U0KCy9a
	2LD5NrvXhQWV1JOoysvnvV8f2wYjXSoMrt2v+12QdyTMf+0/ZK9h5BdOAP2UnVv8KX0sl/OO0V21c
	AF67Us2MuwKMNHY9TPuPsuAuzGweux7pjcUvgxkYwy3xiuu4m6jLxsxs5NxG7Yb5Z8dfCF48kJZfS
	Byu0sSzJ3pn7327mk/QE8BD7S41aiqswNlXgcxr8ZgoYiznkNMy47BkAxVj09n2Mse2nSdqyUzkqS
	jJROFyLk4yk+QsA6pzscZbI7gQc+1SCflLvbahat4/zMLrErCEdTk7rAUhheQZrKElkpqsSEsSkMP
	lkMF4WJQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tgPTw-00000007yYM-2RIX;
	Fri, 07 Feb 2025 14:37:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgPTw-0000000080p-1DMh;
	Fri, 07 Feb 2025 14:37:24 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 1/2] i386/xen: Move KVM_XEN_HVM_CONFIG ioctl to kvm_xen_init_vcpu()
Date: Fri,  7 Feb 2025 14:37:23 +0000
Message-ID: <20250207143724.30792-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

At the time kvm_xen_init() is called, hyperv_enabled() doesn't yet work, so
the correct MSR index to use for the hypercall page isn't known.

Rather than setting it to the default and then shifting it later for the
Hyper-V case with a confusing second call to kvm_init_xen(), just do it
once in kvm_xen_init_vcpu().

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 target/i386/kvm/kvm.c     | 16 +++++---------
 target/i386/kvm/xen-emu.c | 44 ++++++++++++++++++++-------------------
 target/i386/kvm/xen-emu.h |  4 ++--
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee8..b4deec6255 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2129,6 +2129,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->kvm_state->xen_version) {
 #ifdef CONFIG_XEN_EMU
         struct kvm_cpuid_entry2 *xen_max_leaf;
+        uint32_t hypercall_msr =
+            hyperv_enabled(cpu) ? XEN_HYPERCALL_MSR_HYPERV : XEN_HYPERCALL_MSR;
 
         memcpy(signature, "XenVMMXenVMM", 12);
 
@@ -2150,13 +2152,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         c->function = kvm_base + XEN_CPUID_HVM_MSR;
         /* Number of hypercall-transfer pages */
         c->eax = 1;
-        /* Hypercall MSR base address */
-        if (hyperv_enabled(cpu)) {
-            c->ebx = XEN_HYPERCALL_MSR_HYPERV;
-            kvm_xen_init(cs->kvm_state, c->ebx);
-        } else {
-            c->ebx = XEN_HYPERCALL_MSR;
-        }
+        c->ebx = hypercall_msr;
         c->ecx = 0;
         c->edx = 0;
 
@@ -2194,7 +2190,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
             }
         }
 
-        r = kvm_xen_init_vcpu(cs);
+        r = kvm_xen_init_vcpu(cs, hypercall_msr);
         if (r) {
             return r;
         }
@@ -3245,9 +3241,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
             error_report("kvm: Xen support only available in PC machine");
             return -ENOTSUP;
         }
-        /* hyperv_enabled() doesn't work yet. */
-        uint32_t msr = XEN_HYPERCALL_MSR;
-        ret = kvm_xen_init(s, msr);
+        ret = kvm_xen_init(s);
         if (ret < 0) {
             return ret;
         }
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index e81a245881..1144a6efcd 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -108,15 +108,11 @@ static inline int kvm_copy_to_gva(CPUState *cs, uint64_t gva, void *buf,
     return kvm_gva_rw(cs, gva, buf, sz, true);
 }
 
-int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
+int kvm_xen_init(KVMState *s)
 {
     const int required_caps = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
         KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL | KVM_XEN_HVM_CONFIG_SHARED_INFO;
-    struct kvm_xen_hvm_config cfg = {
-        .msr = hypercall_msr,
-        .flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
-    };
-    int xen_caps, ret;
+    int xen_caps;
 
     xen_caps = kvm_check_extension(s, KVM_CAP_XEN_HVM);
     if (required_caps & ~xen_caps) {
@@ -130,20 +126,6 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
             .u.xen_version = s->xen_version,
         };
         (void)kvm_vm_ioctl(s, KVM_XEN_HVM_SET_ATTR, &ha);
-
-        cfg.flags |= KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
-    }
-
-    ret = kvm_vm_ioctl(s, KVM_XEN_HVM_CONFIG, &cfg);
-    if (ret < 0) {
-        error_report("kvm: Failed to enable Xen HVM support: %s",
-                     strerror(-ret));
-        return ret;
-    }
-
-    /* If called a second time, don't repeat the rest of the setup. */
-    if (s->xen_caps) {
-        return 0;
     }
 
     /*
@@ -185,10 +167,14 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
     return 0;
 }
 
-int kvm_xen_init_vcpu(CPUState *cs)
+int kvm_xen_init_vcpu(CPUState *cs, uint32_t hypercall_msr)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
+    struct kvm_xen_hvm_config cfg = {
+        .msr = hypercall_msr,
+        .flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
+    };
     int err;
 
     /*
@@ -210,6 +196,22 @@ int kvm_xen_init_vcpu(CPUState *cs)
                          strerror(-err));
             return err;
         }
+
+        cfg.flags |= KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+    }
+
+    /*
+     * This is a per-KVM setting, but hyperv_enabled() can't be used
+     * when kvm_xen_init() is called from kvm_arch_init(), so do it
+     * when the BSP is initialized.
+     */
+    if (cs->cpu_index == 0) {
+        err = kvm_vm_ioctl(cs->kvm_state, KVM_XEN_HVM_CONFIG, &cfg);
+        if (err) {
+            error_report("kvm: Failed to enable Xen HVM support: %s",
+                         strerror(-err));
+            return err;
+        }
     }
 
     env->xen_vcpu_info_gpa = INVALID_GPA;
diff --git a/target/i386/kvm/xen-emu.h b/target/i386/kvm/xen-emu.h
index fe85e0b195..7a7c72eee5 100644
--- a/target/i386/kvm/xen-emu.h
+++ b/target/i386/kvm/xen-emu.h
@@ -23,8 +23,8 @@
 
 #define XEN_VERSION(maj, min) ((maj) << 16 | (min))
 
-int kvm_xen_init(KVMState *s, uint32_t hypercall_msr);
-int kvm_xen_init_vcpu(CPUState *cs);
+int kvm_xen_init(KVMState *s);
+int kvm_xen_init_vcpu(CPUState *cs, uint32_t hypercall_msr);
 int kvm_xen_handle_exit(X86CPU *cpu, struct kvm_xen_exit *exit);
 int kvm_put_xen_state(CPUState *cs);
 int kvm_get_xen_state(CPUState *cs);
-- 
2.48.1


