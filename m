Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7684CC1BC
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 16:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiCCPmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 10:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbiCCPmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 10:42:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53061959D4
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 07:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qXQPDeK2OuN2+qxDSrZcgR83nw3T7IpEVRsQUisArbQ=; b=eL23JkcDvq3CmACmHTBYpO5t7X
        A4SzEoh1gRij1RQgvyxo6gby5We91+hSiWe6IrSlNPcoy8MKU6TAZt4TYMboX8KmuVIxxTu0kdhWE
        COMC7wsOZJDLR2y7k3cT9T0vSd2hOFdJw9lGhjcIrQbegOhVrFADCK8H3lye/C/J2MkzL8ga817aC
        riVBHc1FwzlIusYQ0EUC6U5fER04ktuVTpFvZ0Ce1Id5zuAwyc/z81hWVw2JMCzzwkZqpGHYq4gSd
        6seOAjcwmoODKCVL3L/tZLUR4AQwFS9sodzSiV4/9MOzdQ7zsJfEVxnT1sedWZpESk/QJ61ryl8B3
        diyWQ+sg==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPna7-00BlVt-Bh; Thu, 03 Mar 2022 15:41:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPna5-000qnE-37; Thu, 03 Mar 2022 15:41:29 +0000
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
Subject: [PATCH v3 13/17] KVM: x86/xen: Kernel acceleration for XENVER_version
Date:   Thu,  3 Mar 2022 15:41:23 +0000
Message-Id: <20220303154127.202856-14-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220303154127.202856-1-dwmw2@infradead.org>
References: <20220303154127.202856-1-dwmw2@infradead.org>
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

Turns out this is a fast path for PV guests because they use it to
trigger the event channel upcall. So letting it bounce all the way up
to userspace is not great.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/xen.c              | 19 +++++++++++++++++++
 include/uapi/linux/kvm.h        |  3 ++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 62ae7cf41fbb..74b10c5859aa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1023,6 +1023,7 @@ struct msr_bitmap_range {
 
 /* Xen emulation context */
 struct kvm_xen {
+	u32 xen_version;
 	bool long_mode;
 	u8 upcall_vector;
 	struct gfn_to_pfn_cache shinfo_cache;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c4253f4d7788..747a11ee0950 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -18,6 +18,7 @@
 #include <trace/events/kvm.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/version.h>
 #include <xen/interface/event_channel.h>
 #include <xen/interface/sched.h>
 
@@ -483,6 +484,13 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		r = kvm_xen_setattr_evtchn(kvm, data);
 		break;
 
+	case KVM_XEN_ATTR_TYPE_XEN_VERSION:
+		mutex_lock(&kvm->lock);
+		kvm->arch.xen.xen_version = data->u.xen_version;
+		mutex_unlock(&kvm->lock);
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -515,6 +523,11 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_ATTR_TYPE_XEN_VERSION:
+		data->u.xen_version = kvm->arch.xen.xen_version;
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -1077,6 +1090,12 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 				params[3], params[4], params[5]);
 
 	switch (input) {
+	case __HYPERVISOR_xen_version:
+		if (params[0] == XENVER_version && vcpu->kvm->arch.xen.xen_version) {
+			r = vcpu->kvm->arch.xen.xen_version;
+			handled = true;
+		}
+		break;
 	case __HYPERVISOR_event_channel_op:
 		if (params[0] == EVTCHNOP_send)
 			handled = kvm_xen_hcall_evtchn_send(vcpu, params[1], &r);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 96aa5c3d01be..bffaae565550 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1710,7 +1710,7 @@ struct kvm_xen_hvm_attr {
 				__u32 padding[4];
 			} deliver;
 		} evtchn;
-
+		__u32 xen_version;
 		__u64 pad[8];
 	} u;
 };
@@ -1721,6 +1721,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
 #define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
+#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
-- 
2.33.1

