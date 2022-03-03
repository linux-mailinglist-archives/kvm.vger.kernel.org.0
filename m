Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7374CC1C3
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 16:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiCCPnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 10:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbiCCPmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 10:42:38 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FEF1959CE
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 07:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=t/t4vi32xyAB8sLIX5XXV6CjhaOVeCGNYqhNLORlvw0=; b=Mie/wLUys5Jp+iRy70LqBzekD2
        SMeE9C86hTMjpeZCS5wVhCxq7our94Ec5TRlOh/HK0QSlhbK46YjQ4K7cnWvS3Nu1Rm5mIBNRHtac
        faKqUCPb+z1cJVHGT5FEI3nPU/fWL6gcAZhCFUk1j2wrQqr6GDvLl1I4hxVpEeIIV6jks3xLEQIj7
        bnX9NSe2IGAgA3hJ3KRUQ37PK8CncxUt4ifhUgyN7FPOj4Fn0N1Kh2cIKOnsIhj2B9eEDfMYKucwb
        6iOvnY4sTtuLdIp5hnIlyRQ805jTzlYNA0GDqwag55JlwRHs108Cablc5IfCHXM2jlTXPXQ0W8XDR
        a4TLi3Jw==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPna6-00EwkC-Q3; Thu, 03 Mar 2022 15:41:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPna5-000qnH-3n; Thu, 03 Mar 2022 15:41:29 +0000
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
Subject: [PATCH v3 14/17] KVM: x86/xen: Support per-vCPU event channel upcall via local APIC
Date:   Thu,  3 Mar 2022 15:41:24 +0000
Message-Id: <20220303154127.202856-15-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220303154127.202856-1-dwmw2@infradead.org>
References: <20220303154127.202856-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
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

Windows uses a per-vCPU vector, and it's delivered via the local APIC
basically like an MSI (with associated EOI) unlike the traditional
guest-wide vector which is just magically asserted by Xen (and in the
KVM case by kvm_xen_has_interrupt() / kvm_cpu_get_extint()).

Now that the kernel is able to raise event channel events for itself,
being able to do so for Windows guests is also going to be useful.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/xen.c              | 40 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  2 ++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74b10c5859aa..30f6fc549235 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -602,6 +602,7 @@ struct kvm_vcpu_hv {
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
 	u32 current_runstate;
+	u8 upcall_vector;
 	struct gfn_to_pfn_cache vcpu_info_cache;
 	struct gfn_to_pfn_cache vcpu_time_info_cache;
 	struct gfn_to_pfn_cache runstate_cache;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 747a11ee0950..fe8661545db3 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -332,6 +332,22 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
+static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
+{
+	struct kvm_lapic_irq irq = { };
+	int r;
+
+	irq.dest_id = v->vcpu_id;
+	irq.vector = v->arch.xen.upcall_vector;
+	irq.dest_mode = APIC_DEST_PHYSICAL;
+	irq.shorthand = APIC_DEST_NOSHORT;
+	irq.delivery_mode = APIC_DM_FIXED;
+	irq.level = 1;
+
+	/* The fast version will always work for physical unicast */
+	WARN_ON_ONCE(!kvm_irq_delivery_to_apic_fast(v->kvm, NULL, &irq, &r, NULL));
+}
+
 /*
  * On event channel delivery, the vcpu_info may not have been accessible.
  * In that case, there are bits in vcpu->arch.xen.evtchn_pending_sel which
@@ -392,6 +408,10 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	}
 	read_unlock_irqrestore(&gpc->lock, flags);
 
+	/* For the per-vCPU lapic vector, deliver it as MSI. */
+	if (v->arch.xen.upcall_vector)
+		kvm_xen_inject_vcpu_vector(v);
+
 	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
@@ -726,6 +746,15 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR:
+		if (data->u.vector && data->u.vector < 0x10)
+			r = -EINVAL;
+		else {
+			vcpu->arch.xen.upcall_vector = data->u.vector;
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -813,6 +842,11 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR:
+		data->u.vector = vcpu->arch.xen.upcall_vector;
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -1246,6 +1280,12 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 				kick_vcpu = true;
 			}
 		}
+
+		/* For the per-vCPU lapic vector, deliver it as MSI. */
+		if (kick_vcpu && vcpu->arch.xen.upcall_vector) {
+			kvm_xen_inject_vcpu_vector(vcpu);
+			kick_vcpu = false;
+		}
 	}
 
  out_rcu:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index bffaae565550..a3cf8a4b8a50 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1753,6 +1753,7 @@ struct kvm_xen_vcpu_attr {
 			__u32 priority;
 			__u64 expires_ns;
 		} timer;
+		__u8 vector;
 	} u;
 };
 
@@ -1766,6 +1767,7 @@ struct kvm_xen_vcpu_attr {
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
 #define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
+#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.33.1

