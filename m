Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96B62CE4F4
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbgLDBU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388385AbgLDBUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C189C08E9AA
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=LaUe/QmOefkcaR4iiIPUR7+R4NgZBHPFYrIHcObvBWk=; b=OzH9wO83hyF7OjQrtT46KV6TfP
        zA2clR6+5669KuC9txXQqD09WtM5YknfMeAD617/ttpRIJVw4s0ec82QTs1eHbFjEHGOpd5A/AvWd
        yWTxk1M26/azS85mSUix69w1+plJO6yd71IrqGvuAo8D4zJBgry/saMkLdXVzdc1MELU+cGBIl4YA
        544jw/ya1q3xJXK+RCkId9YS5PUXLjdWGRAZ/FIqc6Wee92QQnlRPF1WanRkeVR3L15Hh6H0hZ5hj
        Bk8rS3QfMbl0RY2uNYTrKGZ9tP1uz4xzCbj3NatN7OBEOHVZl07r8Bsm1MVbRff7ZPhA1dliiGpTt
        Ew+0zjDg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkK-0004Kc-Ok; Fri, 04 Dec 2020 01:18:55 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CSA2-Av; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 07/15] KVM: x86/xen: add definitions of compat_shared_info, compat_vcpu_info
Date:   Fri,  4 Dec 2020 01:18:40 +0000
Message-Id: <20201204011848.2967588-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

There aren't a lot of differences for the things that the kernel needs
to care about, but there are a few.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index afc6dad41fb5..870ac7197a3a 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -21,4 +21,43 @@ static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
 }
 
+
+/* 32-bit compatibility definitions */
+#include <asm/pvclock-abi.h>
+#include <asm/xen/interface.h>
+
+struct compat_arch_vcpu_info {
+	unsigned int cr2;
+	unsigned int pad[5];
+};
+
+struct compat_vcpu_info {
+        uint8_t evtchn_upcall_pending;
+        uint8_t evtchn_upcall_mask;
+        uint32_t evtchn_pending_sel;
+        struct compat_arch_vcpu_info arch;
+        struct pvclock_vcpu_time_info time;
+}; /* 64 bytes (x86) */
+
+struct compat_arch_shared_info {
+	unsigned int max_pfn;
+	unsigned int pfn_to_mfn_frame_list_list;
+	unsigned int nmi_reason;
+	unsigned int p2m_cr3;
+	unsigned int p2m_vaddr;
+	unsigned int p2m_generation;
+	uint32_t wc_sec_hi;
+};
+
+struct compat_shared_info {
+	struct compat_vcpu_info vcpu_info[MAX_VIRT_CPUS];
+	uint32_t evtchn_pending[sizeof(compat_ulong_t) * 8];
+	uint32_t evtchn_mask[sizeof(compat_ulong_t) * 8];
+	uint32_t wc_version;
+	uint32_t wc_sec;
+	uint32_t wc_nsec;
+	struct compat_arch_shared_info arch;
+
+};
+
 #endif /* __ARCH_X86_KVM_XEN_H__ */
-- 
2.26.2

