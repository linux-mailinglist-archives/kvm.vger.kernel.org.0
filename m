Return-Path: <kvm+bounces-1161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0960A7E54F9
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E3D1B21260
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1FD168AC;
	Wed,  8 Nov 2023 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="sE+JHi5R"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B8615E8F;
	Wed,  8 Nov 2023 11:19:55 +0000 (UTC)
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FAE1BD4;
	Wed,  8 Nov 2023 03:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442395; x=1730978395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LwvxkM973QXPotqf1BmHlmaFhGY0KPkEa30ixGz574A=;
  b=sE+JHi5RRfWD6k0hVhdwIFulDOEIzbEvBk1b20Dtzd+LgoeZDDXT9ZP1
   rK/bYKS8hJlfuxIMXlpuQXE+F0CufSmv3NYAAFrFYY4cesWml5X+UXPTa
   83aWhUFHSCCL1xxv2imR9frXrfMK5SvUJ0bjsPDxo6zGpfALx9bFAhamv
   0=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="164958920"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:19:53 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id DDFEC48DA2;
	Wed,  8 Nov 2023 11:19:49 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:37568]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.45.210:2525] with esmtp (Farcaster)
 id b100eba5-8ee9-421b-9077-66ac2c5bb9c6; Wed, 8 Nov 2023 11:19:48 +0000 (UTC)
X-Farcaster-Flow-ID: b100eba5-8ee9-421b-9077-66ac2c5bb9c6
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:42 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:38 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 07/33] KVM: x86: hyper-v: Introduce KVM_CAP_HYPERV_VSM
Date: Wed, 8 Nov 2023 11:17:40 +0000
Message-ID: <20231108111806.92604-8-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D033UWC002.ant.amazon.com (10.13.139.196) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Introduce a new capability to enable Hyper-V Virtual Secure Mode (VSM)
emulation support.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/hyperv.h           | 5 +++++
 arch/x86/kvm/x86.c              | 5 +++++
 include/uapi/linux/kvm.h        | 1 +
 4 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 00cd21b09f8c..7712e31b7537 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1118,6 +1118,8 @@ struct kvm_hv {
 
 	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
+
+	bool hv_enable_vsm;
 };
 
 struct msr_bitmap_range {
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index f83b8db72b11..2bfed69ba0db 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -238,4 +238,9 @@ static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu)
 
 int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
 
+static inline bool kvm_hv_vsm_enabled(struct kvm *kvm)
+{
+       return kvm->arch.hyperv.hv_enable_vsm;
+}
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4cd3f00475c1..b0512e433032 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4485,6 +4485,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_CPUID:
 	case KVM_CAP_HYPERV_ENFORCE_CPUID:
 	case KVM_CAP_SYS_HYPERV_CPUID:
+	case KVM_CAP_HYPERV_VSM:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
@@ -6519,6 +6520,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_HYPERV_VSM:
+		kvm->arch.hyperv.hv_enable_vsm = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5ce06a1eee2b..168b6ac6ebe5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1226,6 +1226,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_GUEST_MEMFD 233
 #define KVM_CAP_VM_TYPES 234
 #define KVM_CAP_APIC_ID_GROUPS 235
+#define KVM_CAP_HYPERV_VSM 237
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.40.1


