Return-Path: <kvm+bounces-1163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D867E5501
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C36B328142B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C8315EAC;
	Wed,  8 Nov 2023 11:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="aykVI1Qf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725C415E89;
	Wed,  8 Nov 2023 11:20:29 +0000 (UTC)
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC5F101;
	Wed,  8 Nov 2023 03:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442429; x=1730978429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O25EX7uu/BZNg+CriP/M93KalXQ52Vh7t09zkAv2Ya4=;
  b=aykVI1QfFrWWdgvl5K28nJc2jLfTCZz/bsoiUlASsTpFbkDS41nZfZr3
   D6azOjVhkVl7UL9tqeYijznMZNP5k8HOiCYJHwm4bfyvTjk6jYm4M++87
   qhmwsdlgVGNs+hOQearaS91Oy2ZVQ5ATF/zBhTpyNuvjCuCQE0ToZBBkX
   I=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="593807472"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:20:27 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com (Postfix) with ESMTPS id 527E148E12;
	Wed,  8 Nov 2023 11:20:23 +0000 (UTC)
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:53919]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.33.209:2525] with esmtp (Farcaster)
 id 70e20ac2-f2b6-471e-8f0e-3ab2809c6acc; Wed, 8 Nov 2023 11:20:21 +0000 (UTC)
X-Farcaster-Flow-ID: 70e20ac2-f2b6-471e-8f0e-3ab2809c6acc
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:21 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:20:16 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 10/33] KVM: x86: hyper-v: Introduce KVM_HV_GET_VSM_STATE
Date: Wed, 8 Nov 2023 11:17:43 +0000
Message-ID: <20231108111806.92604-11-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

HVCALL_GET_VP_REGISTERS exposes the VTL call hypercall page entry
offsets to the guest. This hypercall is implemented in user-space while
the hypercall page patching happens in-kernel. So expose it as part of
the partition wide VSM state.

NOTE: Alternatively there is the option of sharing this information
through a VTL KVM device attribute (the device is introduced in
subsequent patches).

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/include/uapi/asm/kvm.h |  5 +++++
 arch/x86/kvm/hyperv.c           |  8 ++++++++
 arch/x86/kvm/hyperv.h           |  2 ++
 arch/x86/kvm/x86.c              | 18 ++++++++++++++++++
 include/uapi/linux/kvm.h        |  4 ++++
 5 files changed, 37 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index f73d137784d7..370483d5d5fd 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -570,4 +570,9 @@ struct kvm_apic_id_groups {
 	__u8 n_bits; /* nr of bits used to represent group in the APIC ID */
 };
 
+/* for KVM_HV_GET_VSM_STATE */
+struct kvm_hv_vsm_state {
+	__u64 vsm_code_page_offsets;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2cf430f6ddd8..caaa859932c5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2990,3 +2990,11 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 	return 0;
 }
+
+int kvm_vm_ioctl_get_hv_vsm_state(struct kvm *kvm, struct kvm_hv_vsm_state *state)
+{
+	struct kvm_hv* hv = &kvm->arch.hyperv;
+
+	state->vsm_code_page_offsets = hv->vsm_code_page_offsets.as_u64;
+	return 0;
+}
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 5433107e7cc8..b3d1113efe82 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -261,4 +261,6 @@ static inline bool kvm_hv_vsm_enabled(struct kvm *kvm)
        return kvm->arch.hyperv.hv_enable_vsm;
 }
 
+int kvm_vm_ioctl_get_hv_vsm_state(struct kvm *kvm, struct kvm_hv_vsm_state *state);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0512e433032..57f9c58e1e32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7132,6 +7132,24 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		r = kvm_vm_ioctl_set_apic_id_groups(kvm, &groups);
 		break;
 	}
+	case KVM_HV_GET_VSM_STATE: {
+		struct kvm_hv_vsm_state vsm_state;
+
+		r = -EINVAL;
+		if (!kvm_hv_vsm_enabled(kvm))
+			goto out;
+
+		r = kvm_vm_ioctl_get_hv_vsm_state(kvm, &vsm_state);
+		if (r)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_to_user(argp, &vsm_state, sizeof(vsm_state)))
+			goto out;
+
+		r = 0;
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 168b6ac6ebe5..03f5c08fd7aa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2316,4 +2316,8 @@ struct kvm_create_guest_memfd {
 #define KVM_GUEST_MEMFD_ALLOW_HUGEPAGE		(1ULL << 0)
 
 #define KVM_SET_APIC_ID_GROUPS _IOW(KVMIO, 0xd7, struct kvm_apic_id_groups)
+
+/* Get/Set Hyper-V VSM state. Available with KVM_CAP_HYPERV_VSM */
+#define KVM_HV_GET_VSM_STATE _IOR(KVMIO, 0xd5, struct kvm_hv_vsm_state)
+
 #endif /* __LINUX_KVM_H */
-- 
2.40.1


