Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2428D38C3DC
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhEUJxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:53:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234067AbhEUJxl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OWRu6F9YQnkUvBHMgKmUA/JZ0y4Pl/Sm0bkLmXTrGg0=;
        b=WTc0dcVq6i8vtyPehqJLj6Mxx/WlJCcOi3ihLgcUKWcC+ST769c4FjlIEhwaT26shkZuM4
        9c5tfHBzTrQks27BXt+vbHFyBvHj9qjSQ9hw4tCiHlucNqM1tiObxnuvMp0KmXbXv/x1ve
        6tqXbdmWuxcJaiMwL6FTp8LoR7b18VY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-3j6SDLUXOnensruh1LUE9w-1; Fri, 21 May 2021 05:52:14 -0400
X-MC-Unique: 3j6SDLUXOnensruh1LUE9w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF945107ACC7;
        Fri, 21 May 2021 09:52:13 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CE596A037;
        Fri, 21 May 2021 09:52:11 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/30] KVM: x86: hyper-v: Introduce KVM_CAP_HYPERV_ENFORCE_CPUID
Date:   Fri, 21 May 2021 11:51:36 +0200
Message-Id: <20210521095204.2161214-3-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 7fcb2fd38f42..80154d5d98a1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6891,3 +6891,14 @@ This capability is always enabled.
 This capability indicates that the KVM virtual PTP service is
 supported in the host. A VMM can check whether the service is
 available to the guest on migration.
+
+8.33 KVM_CAP_HYPERV_ENFORCE_CPUID
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
index 55efbacfc244..7c739999441b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -543,6 +543,7 @@ struct kvm_vcpu_hv {
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
index 9b6bca616929..36b99ae1eb60 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3862,6 +3862,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_HYPERV_ENFORCE_CPUID:
 	case KVM_CAP_SYS_HYPERV_CPUID:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
@@ -4790,6 +4791,9 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 		return static_call(kvm_x86_enable_direct_tlbflush)(vcpu);
 
+	case KVM_CAP_HYPERV_ENFORCE_CPUID:
+		return kvm_hv_set_enforce_cpuid(vcpu, cap->args[0]);
+
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		vcpu->arch.pv_cpuid.enforce = cap->args[0];
 		if (vcpu->arch.pv_cpuid.enforce)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..c2e46b4b94c7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_HYPERV_ENFORCE_CPUID 199
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.31.1

