Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958AC2D031F
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgLFLE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 06:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbgLFLE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 06:04:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB74C08E862
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 03:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wWbW/z7plT1a0tP1DNYERJVWzen2M3NsSH+vdxLYVlk=; b=Woj2Ff8b/wbgQSj7Th0VUUWXrC
        ZAVcc0Jg0M9rCNxUltlLbJ/LmIIIJaZXqQxEbLcSC9RTj8yy0KdpYJaOU/IafOdVI6tKzr4YLN6E3
        MHSz1ElsavpNU1OQ8d8fZzadABru4oAj7bGZb/QQu52i2QmFeRLp20tO+Ibe0ELog2H1HpHhnsj1+
        y7q+Nuvz16oiZLKvl4ud5o2NM0IOUxte1qnObZGPvpM7rjoAJz9V9pPUEvdTJHHMxjOWIT0x/H4TW
        7a9UJpwWpHjb0bpyjlH2Lioqq0gR14O9uDN5V535bhfNpplmFBWYmORfW9U4CVSeDZ8okYn1G19v3
        98QfZ+0w==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klrpE-0006Fq-5s; Sun, 06 Dec 2020 11:03:40 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1klrpD-000jpY-OM; Sun, 06 Dec 2020 11:03:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de
Subject: [PATCH v2 09/16] KVM: x86/xen: setup pvclock updates
Date:   Sun,  6 Dec 2020 11:03:20 +0000
Message-Id: <20201206110327.175629-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206110327.175629-1-dwmw2@infradead.org>
References: <20201206110327.175629-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

This means when we set shared_info page GPA, and request a master
clock update. This will trigger all vcpus to update their respective
shared pvclock data with guests. We follow a similar approach
as Hyper-V and KVM and adjust it accordingly.

Note however that Xen differs a little on how pvclock pages are set up.
Specifically KVM assumes 4KiB page alignment and pvclock data starts in
the beginning of the page. Whereas Xen you can place that information
anywhere in the page.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c |  2 ++
 arch/x86/kvm/xen.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h |  1 +
 3 files changed, 62 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a960629687c..e9191dfffbbb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2719,6 +2719,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	if (vcpu->pv_time_enabled)
 		kvm_setup_pvclock_page(v);
+	if (ka->xen.shinfo)
+		kvm_xen_setup_pvclock_page(v);
 	if (v == kvm_get_vcpu(v->kvm, 0))
 		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c156ed1ef972..5373273e1be9 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -55,9 +55,68 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	if (ret)
 		return ret;
 
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MASTERCLOCK_UPDATE);
+
 	return 0;
 }
 
+void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
+{
+	struct kvm_vcpu_arch *vcpu = &v->arch;
+	struct pvclock_vcpu_time_info *guest_hv_clock;
+	unsigned int offset;
+	void *hva;
+	int idx;
+
+	if (v->vcpu_id >= MAX_VIRT_CPUS)
+		return;
+
+	BUILD_BUG_ON(offsetof(struct shared_info, vcpu_info) != 0);
+	BUILD_BUG_ON(offsetof(struct compat_shared_info, vcpu_info) != 0);
+	BUILD_BUG_ON(sizeof(struct vcpu_info) != sizeof(struct compat_vcpu_info));
+	BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
+		     offsetof(struct compat_vcpu_info, time));
+
+	idx = srcu_read_lock(&v->kvm->srcu);
+	hva = READ_ONCE(v->kvm->arch.xen.shinfo);
+	if (!hva)
+		goto out;
+
+	offset = v->vcpu_id * sizeof(struct vcpu_info);
+	offset += offsetof(struct vcpu_info, time);
+
+	guest_hv_clock = hva + offset;
+
+	if (guest_hv_clock->version & 1)
+		++guest_hv_clock->version;  /* first time write, random junk */
+
+	vcpu->hv_clock.version = guest_hv_clock->version + 1;
+	guest_hv_clock->version = vcpu->hv_clock.version;
+
+	smp_wmb();
+
+	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
+	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
+
+	if (vcpu->pvclock_set_guest_stopped_request) {
+		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
+		vcpu->pvclock_set_guest_stopped_request = false;
+	}
+
+	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
+
+	*guest_hv_clock = vcpu->hv_clock;
+
+	smp_wmb();
+
+	vcpu->hv_clock.version++;
+
+	guest_hv_clock->version = vcpu->hv_clock.version;
+
+ out:
+	srcu_read_unlock(&v->kvm->srcu, idx);
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index cd3c52b62068..950a364f5b22 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,6 +9,7 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+void kvm_xen_setup_pvclock_page(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
-- 
2.26.2

