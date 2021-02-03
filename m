Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2373230DD7A
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhBCPCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbhBCPCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:37 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8537C0617A7
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/SmdfoaH86ezA0lj562lVCASTsr/buKE9dL9IXW/R38=; b=RiFWTzYZmFz2yDMpmu18dzMnXk
        fjwx7jskPwmRzn49Ej0Z0mdibUH9pKSvozs8vAhz6fKjhvBYkg8q6CEewPjIL4jg/S42HIb5+ktbm
        6LjCHLjh7t2G/NbiQndKuR5AklswhjIDW9cBphOlGv02MYPtqxsDzukn9t4og35GnZOtpd2Y6yE9V
        mhfsunlGiBBLMnXJckvyfC59W1M5zZvOwxn9PRDfmj1lxpnveE2Kx/i/QlKgAPSKkqoLTS6uNpzuW
        3BCKQcD5T8q99fRdKNrB33KVzrjRrivoj3XANHRG+ilOTKkzGc/iQJSp0c9aL/lSJ5lwQ8o+7D1Pz
        CPnutkUQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Jeg-00015m-AG; Wed, 03 Feb 2021 15:01:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reT-6z; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 07/19] KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR
Date:   Wed,  3 Feb 2021 15:01:02 +0000
Message-Id: <20210203150114.920335-8-dwmw2@infradead.org>
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

From: Joao Martins <joao.m.martins@oracle.com>

This will be used to set up shared info pages etc.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c       | 20 ++++++++++++++++++++
 arch/x86/kvm/xen.c       | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h       |  2 ++
 include/uapi/linux/kvm.h | 11 +++++++++++
 4 files changed, 63 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d98e08faea23..78734bd5b842 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5610,6 +5610,26 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = kvm_xen_hvm_config(kvm, &xhc);
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
index 7d03d918e595..a3fd791b0354 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -18,6 +18,36 @@
 
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
+int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	int r = -ENOENT;
+
+	mutex_unlock(&kvm->lock);
+
+	switch (data->type) {
+	default:
+		break;
+	}
+
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
+int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	int r = -ENOENT;
+
+	mutex_lock(&kvm->lock);
+
+	switch (data->type) {
+	default:
+		break;
+	}
+
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index ec3d8f6d0ef5..0e2467fcfb9f 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -13,6 +13,8 @@
 
 extern struct static_key_false_deferred kvm_xen_enabled;
 
+int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
+int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9eee81bcd0e0..71b8ca359265 100644
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
+		__u64 pad[8];
+	} u;
+};
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.29.2

