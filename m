Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145DD4CC1C2
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 16:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbiCCPnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 10:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbiCCPmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 10:42:38 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BEC1959C4
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 07:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2cJ7FVaC/11ocenFv0PRnIluCkukUujiZ2fXiWvQ80c=; b=GyKP1ERU99DbQVUiztkmLptTAv
        xD0vSSzQBX2Rz4D+k7/g2kq54+Aj7wbRz7tG8MMtmoMMQ2WZ8D0EfQZYyTTzcM8VnePa8CfhYh3/c
        HlsKDGuH+ag9VvbeKiE16bVQCduCBuBNAkXayzhvWM5Pfzg/w4XXvbQV6fIzWW+9+9bZm1P2S+s10
        ypaD+x50V8R7WRXDU8lN+DYPrlrEM8NBoPnOTh3j9scJbPvC8Gk2GiCqzYncy61ogxUjNYSTkSuoy
        W9DxBTD8Bg//Do+LpcmMLTRSclkoLMeqcl6ycmliSR2y56nAIkHK3ksaJvSUl1e4gD5h/L0b12mwB
        Kf5HSL+g==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPna6-00EwkB-Q4; Thu, 03 Mar 2022 15:41:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPna5-000qn8-1M; Thu, 03 Mar 2022 15:41:29 +0000
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
Subject: [PATCH v3 11/17] KVM: x86/xen: Add KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
Date:   Thu,  3 Mar 2022 15:41:21 +0000
Message-Id: <20220303154127.202856-12-dwmw2@infradead.org>
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

In order to intercept hypercalls such as VCPUOP_set_singleshot_timer, we
need to be aware of the Xen CPU numbering.

This looks a lot like the Hyper-V handling of vpidx, for obvious reasons.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              |  1 +
 arch/x86/kvm/xen.c              | 19 +++++++++++++++++++
 arch/x86/kvm/xen.h              |  5 +++++
 include/uapi/linux/kvm.h        |  3 +++
 5 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6bfdc0635b64..88cf04d4698e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -609,6 +609,7 @@ struct kvm_vcpu_xen {
 	u64 runstate_entry_time;
 	u64 runstate_times[4];
 	unsigned long evtchn_pending_sel;
+	u32 vcpu_id; /* The Xen / ACPI vCPU ID */
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf17bef2cdc2..2cfb5dbb87f1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11171,6 +11171,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
+	kvm_xen_init_vcpu(vcpu);
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
 	kvm_set_tsc_khz(vcpu, max_tsc_khz);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 0dae583c4a1d..244cf3cd858a 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -603,6 +603,15 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID:
+		if (data->u.vcpu_id >= KVM_MAX_VCPUS)
+			r = -EINVAL;
+		else {
+			vcpu->arch.xen.vcpu_id = data->u.vcpu_id;
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -678,6 +687,11 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		r = -EINVAL;
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID:
+		data->u.vcpu_id = vcpu->arch.xen.vcpu_id;
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -1377,6 +1391,11 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r)
 	return true;
 }
 
+void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.xen.vcpu_id = vcpu->vcpu_idx;
+}
+
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 852286de574e..54d587aae85b 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -25,6 +25,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_init_vm(struct kvm *kvm);
 void kvm_xen_destroy_vm(struct kvm *kvm);
+void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu);
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu);
 int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
 			    struct kvm *kvm);
@@ -75,6 +76,10 @@ static inline void kvm_xen_destroy_vm(struct kvm *kvm)
 {
 }
 
+static inline void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index fe99c1cb4830..77db59bea915 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1746,6 +1746,7 @@ struct kvm_xen_vcpu_attr {
 			__u64 time_blocked;
 			__u64 time_offline;
 		} runstate;
+		__u32 vcpu_id;
 	} u;
 };
 
@@ -1756,6 +1757,8 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.33.1

