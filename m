Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D10F30DD93
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhBCPFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbhBCPDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:03:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDD7C061352
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+wmFjc0FnL0RuLPZBxu7kgsbWkmJBuZ+QfOcgldsRWE=; b=BMcojsbw6P2Rmi2TFouz7ccRJN
        0yUxedaIX8ViObkePzdpb6IgF5AhNxtwfZsgBxdBGbwH4PCUayYNS/4Uj3PA9l+SniagAT6qgMdRH
        rOE2BCN7F1brl9b+MK31rEmXfMpUgX4iBAZpGkHdaFOZwgCAne1QLZ5MRUQGOt6Bp9wKOY/pP9MpO
        HxxElg4XBVaaU72y8Ovp/waw58O7BQpSLdIZ16sG9Ks6o7ZypMumKnu+6fKz6lXhAWk4jzWZHGXkb
        hQKItznOGpMpNshaY57oNx5eebdb6Di0EScJJ+MVaGn4cpyfqctde0nNHYd7g42bSyqcwpy4er/fc
        i/K6o60A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zI-Kz; Wed, 03 Feb 2021 15:01:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reZ-8U; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 09/19] KVM: x86/xen: add definitions of compat_shared_info, compat_vcpu_info
Date:   Wed,  3 Feb 2021 15:01:04 +0000
Message-Id: <20210203150114.920335-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
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
 arch/x86/kvm/xen.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 0e2467fcfb9f..12a3dc32e78e 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -27,4 +27,40 @@ static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 		 KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL);
 }
 
+
+/* 32-bit compatibility definitions, also used natively in 32-bit build */
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
+	uint32_t evtchn_pending[32];
+	uint32_t evtchn_mask[32];
+	struct pvclock_wall_clock wc;
+	struct compat_arch_shared_info arch;
+};
+
 #endif /* __ARCH_X86_KVM_XEN_H__ */
-- 
2.29.2

