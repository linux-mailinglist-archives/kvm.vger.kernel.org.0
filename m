Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7F8CCF7
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 09:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfHNHfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 03:35:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36184 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHNHfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 03:35:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id g4so3875370plo.3;
        Wed, 14 Aug 2019 00:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MzJoKewNZEQ0mEDUeUGXKCvAaKajOM2I1xl8yohm2Ow=;
        b=CNvyTSovjSg08jGzLY8E21LyGC6g6hmd/cnpXE/F7jXludaZzhzWEVADd/B6B70i6u
         S+99J4WDYFg0PKvZVDtY1Ola9RuGEDcdBcYg9l3sD9qzFhnX2tnE2zcSL+yLagzzVTp6
         z93OnWHPRYwDrrSpFQmyMOgiDf2c6r7WFnpSaqgtnWPmlY4/mudENgOEPGBFiy4lHbhA
         VcORFECnzaJ4qh3BMosiTT6V1yapAiEoMf1wyilvhiOzi24lCDzX8sW1JN9KNiDFnHRD
         QJc5tZY4JfOb3tgZESgPp8K73IR/I28y5Sjmw0vEBpZxJLCZF9iCu/CJ3OB1YH1wOpi0
         xdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MzJoKewNZEQ0mEDUeUGXKCvAaKajOM2I1xl8yohm2Ow=;
        b=je7mxkipB5mxY+dRXSN/9wY++bOqTSFuPm5NOow0KjO0ZxYORHCjqc/4/cg3GCribh
         TrZjUrNOQboxCbdcPG/XwjURcor9QwtbGgMg3eCAfPAyDKfTRZ1IRIkCp4ca6FusfU/H
         /3+BbKNJBk3xBLnD6JyK+xGQM4FSh6RVZl27uIyepEvY6jLKhk114rNYVcC53Bj2dhDy
         JVAS6z/q1SCEGJE2lykUoozFSy8wlCJSlpK0bM3Y6aKWEulu/5KHpgcQAVWQNdHIyxBg
         yZOW7Cmj4bftgnhrNz1lIpXl6slf0jm+Pso9Y+DkXi2uKNpGZuESE8CsThrgc7CjvyeS
         xwdQ==
X-Gm-Message-State: APjAAAUre6/g3Pwmv4aqBHJLzL05ydFXBkFqTzYqCwJRsMg2lP3FUKzC
        +B3FfeFnP1igG5tzaH1JjKKc00qWft8=
X-Google-Smtp-Source: APXvYqyNrhAZwamhc2A9bvD+Ejl7Nu/P29reO1ovOKWk8hfL8iNf6kyAQa02Vh0FIc9rDQd3ZqZHUQ==
X-Received: by 2002:a17:902:223:: with SMTP id 32mr25669388plc.220.1565768108213;
        Wed, 14 Aug 2019 00:35:08 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id v184sm109639230pfb.82.2019.08.14.00.35.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Aug 2019 00:35:07 -0700 (PDT)
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
Subject: [PATCH V2 2/3] KVM/Hyper-V: Add new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH
Date:   Wed, 14 Aug 2019 15:34:46 +0800
Message-Id: <20190814073447.96141-3-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190814073447.96141-1-Tianyu.Lan@microsoft.com>
References: <20190814073447.96141-1-Tianyu.Lan@microsoft.com>
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
+thinks it's running on Hyper-V and only uses Hyper-V hypercalls.
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

