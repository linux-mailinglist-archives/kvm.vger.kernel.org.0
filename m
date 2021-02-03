Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5CB30DD7C
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhBCPCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbhBCPCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:42 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D634CC0617AA
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vCdOzjK0v6dz40/RG1f2sxzhjEUWubl5OPMLz5k9DEQ=; b=g/6rzHmUbtXpIp++3ZCl2gpXtl
        QAHU0rXi4CGW7T9nd0+wSzw2+7lNUQqbc35ovxamAdP8kiGQIbGKCZpNI2pWlRkrghNop86URpZWF
        9DVfrG92NNKSAFd50/bOTxNsZwwZHToQSGvWz2zw0NxpOLhHPPPxDwVeREOb3b4oCeReWyBLnVih8
        oPT6gw4sWz4m9ViL5qwj/KeGZE2mZv0KFQmJxkSOwa0Nl/Mzv/Vw7O6RJZ3LvhyOBHBNLu84cEqyC
        NOzX3J47qUYrGt+7PrlWJiNwuLJxxZ7gUtonUumO70HLLZzW8G1r73zt1iXu3mn+2ADY7eZRsA3it
        ZtTtyQ+A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Jeg-00015l-8d; Wed, 03 Feb 2021 15:01:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reQ-6G; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 06/19] KVM: x86/xen: Add kvm_xen_enabled static key
Date:   Wed,  3 Feb 2021 15:01:01 +0000
Message-Id: <20210203150114.920335-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The code paths for Xen support are all fairly lightweight but if we hide
them behind this, they're even *more* lightweight for any system which
isn't actually hosting Xen guests.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c |  2 ++
 arch/x86/kvm/xen.c | 17 +++++++++++++++++
 arch/x86/kvm/xen.h | 10 ++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a74ae5f70bdc..d98e08faea23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7953,6 +7953,7 @@ void kvm_arch_exit(void)
 	kvm_mmu_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_fpu_cache);
+	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
 }
 
 static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
@@ -10529,6 +10530,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);
 	kvm_page_track_cleanup(kvm);
+	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
 }
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index b52549fc6dbc..7d03d918e595 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -16,6 +16,8 @@
 
 #include "trace.h"
 
+DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
+
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -93,10 +95,25 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 	     xhc->blob_size_32 || xhc->blob_size_64))
 		return -EINVAL;
 
+	mutex_lock(&kvm->lock);
+
+	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
+		static_branch_inc(&kvm_xen_enabled.key);
+	else if (!xhc->msr && kvm->arch.xen_hvm_config.msr)
+		static_branch_slow_dec_deferred(&kvm_xen_enabled);
+
 	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
+
+	mutex_unlock(&kvm->lock);
 	return 0;
 }
 
+void kvm_xen_destroy_vm(struct kvm *kvm)
+{
+	if (kvm->arch.xen_hvm_config.msr)
+		static_branch_slow_dec_deferred(&kvm_xen_enabled);
+}
+
 static int kvm_xen_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 {
 	kvm_rax_write(vcpu, result);
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 28e9c9892628..ec3d8f6d0ef5 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,14 +9,20 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+#include <linux/jump_label_ratelimit.h>
+
+extern struct static_key_false_deferred kvm_xen_enabled;
+
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
+void kvm_xen_destroy_vm(struct kvm *kvm);
 
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
-	return kvm->arch.xen_hvm_config.flags &
-		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
+	return static_branch_unlikely(&kvm_xen_enabled.key) &&
+		(kvm->arch.xen_hvm_config.flags &
+		 KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL);
 }
 
 #endif /* __ARCH_X86_KVM_XEN_H__ */
-- 
2.29.2

