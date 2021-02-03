Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DEB30DD92
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhBCPFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhBCPDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:03:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CA3C061354
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=X9w+vez3eG6iu5zevZc+0jh7gNDc/1ulg2EpKMq3RE8=; b=cel2MjGfguM2kbr//lLo+FK1cb
        ihpuyCznbeLa4XMs7Sh3/yJ5Ep+/6IcL2bKEoMwXsA4fubaEZHNOTt7ZWU8qsIjrtWtvgDqOxYTCv
        cINxvu9ED1GGeANhK+G8Z5TRL70OMihhf6gjCVq+MkQ+bqd9RrEQhNVLCiCOomJaqzuTqZ093z4QR
        uOO10B5MNf1LjAuuznz3VbQsx1W9XdlfyIIRVwckqvyUCSTWCVy00HHkVfJ0VDPLZeeA1N3iR6rdb
        l5yM6NEmf79/kajg7POhZc70n3SLRuDsuDFNV++pJ4SzmtDDO0FJFBemK4PoGvJAoxFo/T3SoMNgV
        2jK8DUnA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zK-OW; Wed, 03 Feb 2021 15:01:19 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003rel-C8; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 13/19] KVM: x86/xen: Add KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR
Date:   Wed,  3 Feb 2021 15:01:08 +0000
Message-Id: <20210203150114.920335-14-dwmw2@infradead.org>
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

This will be used for per-vCPU setup such as runstate and vcpu_info.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c       | 20 ++++++++++++++++++++
 arch/x86/kvm/xen.c       | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h       |  2 ++
 include/uapi/linux/kvm.h | 13 +++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 434cda36f5f4..16549b9fb347 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5009,6 +5009,26 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_SUPPORTED_HV_CPUID:
 		r = kvm_ioctl_get_supported_hv_cpuid(vcpu, argp);
 		break;
+	case KVM_XEN_VCPU_GET_ATTR: {
+		struct kvm_xen_vcpu_attr xva;
+
+		r = -EFAULT;
+		if (copy_from_user(&xva, argp, sizeof(xva)))
+			goto out;
+		r = kvm_xen_vcpu_get_attr(vcpu, &xva);
+		if (!r && copy_to_user(argp, &xva, sizeof(xva)))
+			r = -EFAULT;
+		break;
+	}
+	case KVM_XEN_VCPU_SET_ATTR: {
+		struct kvm_xen_vcpu_attr xva;
+
+		r = -EFAULT;
+		if (copy_from_user(&xva, argp, sizeof(xva)))
+			goto out;
+		r = kvm_xen_vcpu_set_attr(vcpu, &xva);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index eab4dce93be1..5cbf6955e509 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -118,6 +118,36 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 	return r;
 }
 
+int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
+{
+	int r = -ENOENT;
+
+	mutex_lock(&vcpu->kvm->lock);
+
+	switch (data->type) {
+	default:
+		break;
+	}
+
+	mutex_unlock(&vcpu->kvm->lock);
+	return r;
+}
+
+int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
+{
+	int r = -ENOENT;
+
+	mutex_lock(&vcpu->kvm->lock);
+
+	switch (data->type) {
+	default:
+		break;
+	}
+
+	mutex_unlock(&vcpu->kvm->lock);
+	return r;
+}
+
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 12a3dc32e78e..fb85377fdbdc 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -13,6 +13,8 @@
 
 extern struct static_key_false_deferred kvm_xen_enabled;
 
+int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
+int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3c5b7ca7dce3..af09f07d6d02 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1585,6 +1585,7 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+/* Per-VM Xen attributes */
 #define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
 #define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
 
@@ -1603,6 +1604,18 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 
+/* Per-vCPU Xen attributes */
+#define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
+#define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
+
+struct kvm_xen_vcpu_attr {
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

