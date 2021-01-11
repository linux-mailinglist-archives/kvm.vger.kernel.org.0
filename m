Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA3E2F2031
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 20:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391419AbhAKT6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391402AbhAKT6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 14:58:53 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845FCC0617A5
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 11:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=w5nOpMx5/jgKliwp2IcY2IIBdFqwxK6hESaqOZsVbdQ=; b=if1jztLtTFkfmHqX1CBr0sHgyc
        EONze21sKd+H1sflhB1RoAJT4VIngUj80vC7l7E/YfnbOzKDddVoAogTjHgaXKbj+zG+2EhPMCgMB
        G8d4NXvKz3rcCYLdfMtU02kuzVCkQFBEUDhF/NRtQ82zW5BxLFkDvh7gTjCUCeK72DRZDbRnR/YEy
        f+yy0ombj8M4z7AUyJ0lLlnHcaIukQX0nu/iGmAnJFA9jfRddwLK7slZK4Y5mVrslH/I/cUuwnJYc
        kiIbstplIR4lLBxTMkz2mZI9M/QB4yLCqJHeMI6Pb2K4Bip55wfc/20wVkAI4/Q9EGHkKP1mLUKgN
        IuRnEaXA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kz3Jg-0001h4-J1; Mon, 11 Jan 2021 19:57:29 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jf-0001HU-Ge; Mon, 11 Jan 2021 19:57:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v5 04/16] KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR
Date:   Mon, 11 Jan 2021 19:57:13 +0000
Message-Id: <20210111195725.4601-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111195725.4601-1-dwmw2@infradead.org>
References: <20210111195725.4601-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

This will be used to set up shared info pages etc.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c       | 20 ++++++++++++++++++++
 arch/x86/kvm/xen.c       | 24 ++++++++++++++++++++++++
 arch/x86/kvm/xen.h       |  2 ++
 include/uapi/linux/kvm.h | 11 +++++++++++
 4 files changed, 57 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4e6b8c4d7824..fd0a4ff1157e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5618,6 +5618,26 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_XEN_HVM_GET_ATTR: {
+		struct kvm_xen_hvm_attr xha;
+
+		r = -EFAULT;
+		if (copy_from_user(&xha, argp, sizeof(xha)))
+			goto out;
+		r = kvm_xen_hvm_get_attr(kvm, &xha);
+		if (!r && copy_to_user(argp, &xha, sizeof(xha)))
+			r = -EFAULT;
+		break;
+	}
+	case KVM_XEN_HVM_SET_ATTR: {
+		struct kvm_xen_hvm_attr xha;
+
+		r = -EFAULT;
+		if (copy_from_user(&xha, argp, sizeof(xha)))
+			goto out;
+		r = kvm_xen_hvm_set_attr(kvm, &xha);
+		break;
+	}
 	case KVM_SET_CLOCK: {
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 503935d8212e..c0b2c67e0235 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -16,6 +16,30 @@
 
 #include "trace.h"
 
+int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	int r = -ENOENT;
+
+	switch (data->type) {
+	default:
+		break;
+	}
+
+	return r;
+}
+
+int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	int r = -ENOENT;
+
+	switch (data->type) {
+	default:
+		break;
+	}
+
+	return r;
+}
+
 int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 81e12f716d2e..d06b5afcc1f2 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,6 +9,8 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
+int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9eee81bcd0e0..31d4eb100efd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1585,6 +1585,17 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+#define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
+#define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 pad[4];
+	} u;
+};
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.29.2

