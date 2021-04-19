Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6A03647A4
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241951AbhDSQCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:02:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241864AbhDSQCK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 12:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618848099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6rNirdImjt13Zaa5C1kiS2DEdBv1mU5YTPV6hDvXQxc=;
        b=gvRCvVgpmz0BCSQAoAlK90brUpMSg4ek+xNvsDK2eqhUU9Zao3TZEml6+NfWfOmoZulXoM
        6x34gzvpzuA5nAd7ezwQu2tRr+xLbTf5DjxNtikjb6v38i41hiPGRGr71tQTejTaVy+qHV
        2iNDdVHv3QOjs4WtCsn3YJn9hFeoSZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-a4bXRVAfPy6Q0wPZZ2TpIQ-1; Mon, 19 Apr 2021 12:01:38 -0400
X-MC-Unique: a4bXRVAfPy6Q0wPZZ2TpIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B8A66D4F4;
        Mon, 19 Apr 2021 16:01:36 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 376B32BFE6;
        Mon, 19 Apr 2021 16:01:34 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/30] KVM: x86: hyper-v: Introduce KVM_CAP_HYPERV_ENFORCE_CPUID
Date:   Mon, 19 Apr 2021 18:00:59 +0200
Message-Id: <20210419160127.192712-3-vkuznets@redhat.com>
In-Reply-To: <20210419160127.192712-1-vkuznets@redhat.com>
References: <20210419160127.192712-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modeled after KVM_CAP_ENFORCE_PV_FEATURE_CPUID, the new capability allows
for limiting Hyper-V features to those exposed to the guest in Hyper-V
CPUIDs (0x40000003, 0x40000004, ...).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst  | 11 +++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/hyperv.c           | 21 +++++++++++++++++++++
 arch/x86/kvm/hyperv.h           |  1 +
 arch/x86/kvm/x86.c              |  4 ++++
 include/uapi/linux/kvm.h        |  1 +
 6 files changed, 39 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 307f2fcf1b02..cdcaacf3d783 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6727,3 +6727,14 @@ vcpu_info is set.
 The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
 features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
 supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
+
+8.31 KVM_CAP_HYPERV_ENFORCE_CPUID
+-----------------------------
+
+Architectures: x86
+
+When enabled, KVM will disable emulated Hyper-V features provided to the
+guest according to the bits Hyper-V CPUID feature leaves. Otherwise, all
+currently implmented Hyper-V features are provided unconditionally when
+Hyper-V identification is set in the HYPERV_CPUID_INTERFACE (0x40000001)
+leaf.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3768819693e5..dc40897c41bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -530,6 +530,7 @@ struct kvm_vcpu_hv {
 	struct kvm_vcpu_hv_stimer stimer[HV_SYNIC_STIMER_COUNT];
 	DECLARE_BITMAP(stimer_pending_bitmap, HV_SYNIC_STIMER_COUNT);
 	cpumask_t tlb_flush;
+	bool enforce_cpuid;
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f98370a39936..557897c453a9 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1809,6 +1809,27 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->arch.hyperv_enabled = false;
 }
 
+int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
+{
+	struct kvm_vcpu_hv *hv_vcpu;
+	int ret = 0;
+
+	if (!to_hv_vcpu(vcpu)) {
+		if (enforce) {
+			ret = kvm_hv_vcpu_init(vcpu);
+			if (ret)
+				return ret;
+		} else {
+			return 0;
+		}
+	}
+
+	hv_vcpu = to_hv_vcpu(vcpu);
+	hv_vcpu->enforce_cpuid = enforce;
+
+	return ret;
+}
+
 bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.hyperv_enabled && to_kvm_hv(vcpu->kvm)->hv_guest_os_id;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 60547d5cb6d7..730da8537d05 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -138,6 +138,7 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm);
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
 void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu);
+int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce);
 int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca63625aee4..a06a6f48386d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3745,6 +3745,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_HYPERV_ENFORCE_CPUID:
 	case KVM_CAP_SYS_HYPERV_CPUID:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
@@ -4669,6 +4670,9 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 		return static_call(kvm_x86_enable_direct_tlbflush)(vcpu);
 
+	case KVM_CAP_HYPERV_ENFORCE_CPUID:
+		return kvm_hv_set_enforce_cpuid(vcpu, cap->args[0]);
+
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		vcpu->arch.pv_cpuid.enforce = cap->args[0];
 		if (vcpu->arch.pv_cpuid.enforce)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6afee209620..723bd729787f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1078,6 +1078,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_HYPERV_ENFORCE_CPUID 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.30.2

