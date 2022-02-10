Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6243E4B0260
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiBJBbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:31:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiBJBbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:31:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE07205F2
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=J+XshkmIT/StMwJqjcuIYm/D2WKwNqr6xvXhipXBTTA=; b=Cuna54O38hm49NZbs8gNMJYQ8F
        DIHQljzdiVBjgA5y093qL6a68crZCgjWzBY1U2YaDxrw+sxk+9k1cL3Rs9dBWWH9cw7jzVPGTSRE4
        UvIV71JSVGbFabtfuFIubo7ZafyoJXMUmrOMl6ksYie0hp0rPbb/0j/gLSGhr9Y+K0/qJPw+RLkC4
        eYb1+0UJ10UYUlz33soGiB4tltNsD0QGLVHbndlwDnNPXPx5bjE2JR4rfJN5bliGf8Cqgrx+7Rnzy
        fiUlVBnyiiSFszGX1SliWo+NhrT3GDRjOgOIa2J5O2CP76SNOpZoVUcjnn+QCU8zwvJaO8Ql9AYbE
        Axu3wlgA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008xl6-JO; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-0019DD-3q; Thu, 10 Feb 2022 00:27:24 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v0 07/15] KVM: x86/xen: Support direct injection of event channel events
Date:   Thu, 10 Feb 2022 00:27:13 +0000
Message-Id: <20220210002721.273608-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220210002721.273608-1-dwmw2@infradead.org>
References: <20220210002721.273608-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This adds a KVM_XEN_HVM_EVTCHN_SEND ioctl which allows direct injection
of events given an explicit { vcpu, port, priority } in precisely the
same form that those fields are given in the IRQ routing table.

Userspace is currently able to inject 2-level events purely by setting
the bits in the shared_info and vcpu_info, but FIFO event channels are
harder to deal with; we will need the kernel to take sole ownership of
delivery when we support those.

A patch advertising this feature with a new bit in the KVM_CAP_XEN_HVM
ioctl will be added in a subsequent patch.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c       |  9 +++++++++
 arch/x86/kvm/xen.c       | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h       |  1 +
 include/uapi/linux/kvm.h |  3 +++
 4 files changed, 45 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72c72a36bd4d..a54bd731cf41 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6440,6 +6440,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = kvm_xen_hvm_set_attr(kvm, &xha);
 		break;
 	}
+	case KVM_XEN_HVM_EVTCHN_SEND: {
+		struct kvm_irq_routing_xen_evtchn uxe;
+
+		r = -EFAULT;
+		if (copy_from_user(&uxe, argp, sizeof(uxe)))
+			goto out;
+		r = kvm_xen_hvm_evtchn_send(kvm, &uxe);
+		break;
+	}
 #endif
 	case KVM_SET_CLOCK:
 		r = kvm_vm_ioctl_set_clock(kvm, argp);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index ac3aeecad56e..90fffca518f0 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1089,6 +1089,38 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
 	return 0;
 }
 
+/*
+ * Explicit event sending from userspace with KVM_XEN_HVM_EVTCHN_SEND ioctl.
+ */
+int kvm_xen_hvm_evtchn_send(struct kvm *kvm, struct kvm_irq_routing_xen_evtchn *uxe)
+{
+	struct kvm_xen_evtchn e;
+	int ret;
+
+	if (!uxe->port || uxe->port >= max_evtchn_port(kvm))
+		return -EINVAL;
+
+	/* We only support 2 level event channels for now */
+	if (uxe->priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
+		return -EINVAL;
+
+	e.port = uxe->port;
+	e.vcpu_id = uxe->vcpu;
+	e.vcpu_idx = -1;
+	e.priority = uxe->priority;
+
+	ret = kvm_xen_set_evtchn(&e, kvm);
+
+	/*
+	 * None of that 'return 1 if it actually got delivered' nonsense.
+	 * We don't care if it was masked (-ENOTCONN) either.
+	 */
+	if (ret > 0 || ret == -ENOTCONN)
+		ret = 0;
+
+	return ret;
+}
+
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index e28feb32add6..852286de574e 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -20,6 +20,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
+int kvm_xen_hvm_evtchn_send(struct kvm *kvm, struct kvm_irq_routing_xen_evtchn *evt);
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_init_vm(struct kvm *kvm);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b46bcdb0cab1..f82b503e26e2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1692,6 +1692,9 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
 #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
 
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_HVM_EVTCHN_SEND	_IOW(KVMIO,  0xd0, struct kvm_irq_routing_xen_evtchn)
+
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
-- 
2.33.1

