Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CFB2D0319
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgLFLER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 06:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgLFLEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 06:04:16 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E4FC061A51
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 03:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yanMONemVgXNfp/liw6HjKwLpmnJvJ/soapoNao/Ncg=; b=NBkqm+sTVWQNZkMjXZGTlcg32t
        dXeEoF99sm63YyhTS763q1PmUOqTlhACdlTRFkKm/SFqSODcL5a3bM1WV2ggeHN8KDu6l+QkpVQlW
        sTqjPr42TelhEGZ1Bh/uRJ8M9M20ZCjhu3PknHHsuRcWAhC5lnRaKWXIkqA7gLtVEfAWP33D3Rs8A
        8kIu1jy4wU/4WPeCu1wADg3XLB7iuNACej2O3C4B5nlLnIkSdk1OF6yIgPD442Dv22jMaLcfqdZi9
        eXsNcDOVcgjNv/oQwPbUtXDEI1tf0JDeuRg+/VPCsn5yh/RxE3zqWQgLq+dUR5fALN7CFxe8vqwtv
        lg0c+yqQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klrpE-0004tK-PH; Sun, 06 Dec 2020 11:03:32 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1klrpD-000jpS-NL; Sun, 06 Dec 2020 11:03:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de
Subject: [PATCH v2 07/16] KVM: x86/xen: add definitions of compat_shared_info, compat_vcpu_info
Date:   Sun,  6 Dec 2020 11:03:18 +0000
Message-Id: <20201206110327.175629-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206110327.175629-1-dwmw2@infradead.org>
References: <20201206110327.175629-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

There aren't a lot of differences for the things that the kernel needs
to care about, but there are a few.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.h | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index afc6dad41fb5..cd3c52b62068 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -21,4 +21,41 @@ static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
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
+
+};
+
 #endif /* __ARCH_X86_KVM_XEN_H__ */
-- 
2.26.2

