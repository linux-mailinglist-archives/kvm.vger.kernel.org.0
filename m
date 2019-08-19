Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C24E92497
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 15:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfHSNSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 09:18:14 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40876 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbfHSNSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 09:18:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so1165167pfn.7;
        Mon, 19 Aug 2019 06:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jhCOccuCzPzG2s+OQkIdwKuf0Hs2BSmGnlAfPo3gJDY=;
        b=SSbDy30NapSw8nHHwn1JLMwbNA0vfTRGU1iDjq3SKBqN1KGP/m+LeAv3PRlyAzQmQg
         bkkueQgMJu7eFwNVM6y84oTQ5gHMh6D6iksUAvH45v83RXY5v/dK5qeLWS4Wl2uDFBPz
         f9ovypltlxBT4ybYgThtMHe8Pul/7LnCbP6RdXytBQmktC7+1MIflQkRl6JoRaOx6K4M
         u+iZ07xWrHxaRXPTySmoFjWO303tExfRTaBdWvjLLRiIf/J34q1ECFEPxu3YgtmkbCLi
         rxQUrXLoHtEb613F9ONPS1TC9U64qt995cYo+9xWlwvdBFNMLwvGM6r19ywCR2uk+XNH
         GqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jhCOccuCzPzG2s+OQkIdwKuf0Hs2BSmGnlAfPo3gJDY=;
        b=XnxOPALrTgal66JBooDbi3IK/swP9lgqyTltWvhMLqxIsQnG7phCa51O8R7tNiBrPf
         ix87VLa6yZBgltFADQQ6pvif3dgFysrUABiqCFh0FplIY+Vc1Llm2XK/+f3NUWx94lsc
         LlJe0ucV7MG+TZdZNsb49VcwiEbMSmtKi+NXiPQFibKLvY1ndNKDGLKG3Swt09n3zlq4
         TvcOjLuF6Fe7S5zkTMn10r+kzkSCYb5zdT4vmooVZ9T8xt4mu3m0cmaVsDgAoumFnslB
         bXhLoi+2+dkSveDqjs1u9DtQckBJmRjAeQ1X/l9XFwGTiYAi2cQ/7QmBQJQSE0VT5exa
         2ESw==
X-Gm-Message-State: APjAAAW1Ta4ffhas5y3+kMEZzXq4/ct6APbxMMPpGKVZ64vlfVWC7xyA
        boNzLs93raUa9tTwHsvgY5VVvzgiv1o=
X-Google-Smtp-Source: APXvYqzO69+SFNQD25sX+v/CwJUb3PhBiHPL7gAr9CGC0HPcUtSl++xVF3BgpvmVUKjdi/rviIxLMw==
X-Received: by 2002:a63:ee04:: with SMTP id e4mr19888533pgi.53.1566220691994;
        Mon, 19 Aug 2019 06:18:11 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id h20sm16184329pfq.156.2019.08.19.06.18.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Aug 2019 06:18:11 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: [PATCH V3 2/3] KVM/Hyper-V: Add new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH
Date:   Mon, 19 Aug 2019 21:17:36 +0800
Message-Id: <20190819131737.26942-3-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190819131737.26942-1-Tianyu.Lan@microsoft.com>
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

This patch adds new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH and let
user space to enable direct tlb flush function when only Hyper-V
hypervsior capability is exposed to VM. This patch also adds
enable_direct_tlbflush callback in the struct kvm_x86_ops and
platforms may use it to implement direct tlb flush support.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v1:
       Update description of KVM_CAP_HYPERV_DIRECT_TLBFLUSH
       in the KVM API doc.
---
 Documentation/virtual/kvm/api.txt | 13 +++++++++++++
 arch/x86/include/asm/kvm_host.h   |  2 ++
 arch/x86/kvm/x86.c                |  8 ++++++++
 include/uapi/linux/kvm.h          |  1 +
 4 files changed, 24 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 2cd6250b2896..0c6e1b25d0c8 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -5289,3 +5289,16 @@ Architectures: x86
 This capability indicates that KVM supports paravirtualized Hyper-V IPI send
 hypercalls:
 HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
+8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
+
+Architecture: x86
+
+This capability indicates that KVM running on top of Hyper-V hypervisor
+enables Direct TLB flush for its guests meaning that TLB flush
+hypercalls are handled by Level 0 hypervisor (Hyper-V) bypassing KVM.
+Due to the different ABI for hypercall parameters between Hyper-V and
+KVM, enabling this capability effectively disables all hypercall
+handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
+flush hypercalls by Hyper-V) so userspace should disable KVM identification
+in CPUID and only exposes Hyper-V identification. In this case, guest
+thinks it's running on Hyper-V and only use Hyper-V hypercalls.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0cc5b611a113..667d154e89d4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1205,6 +1205,8 @@ struct kvm_x86_ops {
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+
+	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d7b9e6a0939..a9d8ee7f7bf0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3183,6 +3183,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = kvm_x86_ops->get_nested_state ?
 			kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
 		break;
+	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
+		r = kvm_x86_ops->enable_direct_tlbflush ? 1 : 0;
+		break;
 	default:
 		break;
 	}
@@ -3953,6 +3956,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				r = -EFAULT;
 		}
 		return r;
+	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
+		if (!kvm_x86_ops->enable_direct_tlbflush)
+			return -ENOTTY;
+
+		return kvm_x86_ops->enable_direct_tlbflush(vcpu);
 
 	default:
 		return -EINVAL;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a7c19540ce21..cb959bc925b1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -996,6 +996,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 174
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.14.5

