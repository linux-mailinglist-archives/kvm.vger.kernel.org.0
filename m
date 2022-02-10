Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E144B025A
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiBJBcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:32:01 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiBJBbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:31:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32685F47
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JG1kCAvlUbp2aaGqscsx7yUF7CXhQvJDhw2H3fyYAAQ=; b=c/peA/xEgqpvnKbFzSCx3g/NNV
        C7mvSZCDUR7oxuyfNXzZ1e2hMM/3nBgVglmUxbTB3Wu4kj3b2BC3A6lmJeeNf/Bjnl28yW5qJcclf
        RBFr4v/gf3gJrLlBqtPLYP1qavlgvmm35X4zzrZtR7vawYM7EULLSTkHy4FRqT9MPPJ3z/L7FHUZl
        +LSuTOEc4Z1N5uTlNXENd+fc5K9oh+fgQuo9nqX0FcyP9qiQnt+bUQg1SdA4wHhPj7LshcfKROjqP
        BQq2DbulXplRI6HYU7YJjwBDFmmUGncPKSsxIiSCxUCDvI3EhkkAgE08CFKWeBmLNKFYTIAbDUqKm
        J/TffRfQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008xlB-P3; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-0019Dc-7Y; Thu, 10 Feb 2022 00:27:24 +0000
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
Subject: [PATCH v0 12/15] KVM: x86/xen: Kernel acceleration for XENVER_version
Date:   Thu, 10 Feb 2022 00:27:18 +0000
Message-Id: <20220210002721.273608-13-dwmw2@infradead.org>
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

Turns out this is a fast path for PV guests because they use it to
trigger the event channel upcall. So letting it bounce all the way up
to userspace is not great.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/xen.c              | 18 ++++++++++++++++++
 include/uapi/linux/kvm.h        |  3 ++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ddfdc8cc8e60..1c064c2ec937 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1021,6 +1021,7 @@ struct msr_bitmap_range {
 
 /* Xen emulation context */
 struct kvm_xen {
+	u32 xen_version;
 	bool long_mode;
 	u8 upcall_vector;
 	struct gfn_to_pfn_cache shinfo_cache;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c042c7d6ee02..735fccd44488 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -18,6 +18,7 @@
 #include <trace/events/kvm.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/version.h>
 #include <xen/interface/event_channel.h>
 #include <xen/interface/sched.h>
 
@@ -479,6 +480,12 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		r = kvm_xen_setattr_evtchn(kvm, data);
 		break;
 
+	case KVM_XEN_ATTR_TYPE_XEN_VERSION:
+		mutex_lock(&kvm->lock);
+		kvm->arch.xen.xen_version = data->u.xen_version;
+		mutex_unlock(&kvm->lock);
+		break;
+
 	default:
 		break;
 	}
@@ -511,6 +518,11 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
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
@@ -1049,6 +1061,12 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
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
index f485b536112f..243917851e0d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1703,7 +1703,7 @@ struct kvm_xen_hvm_attr {
 				__u32 padding[4];
 			} deliver;
 		} evtchn;
-
+		__u32 xen_version;
 		__u64 pad[8];
 	} u;
 };
@@ -1714,6 +1714,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
 #define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
+#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
-- 
2.33.1

