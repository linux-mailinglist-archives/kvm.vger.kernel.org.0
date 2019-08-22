Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926D9996B0
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388674AbfHVOar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 10:30:47 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40782 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732001AbfHVOap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 10:30:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id h3so3582647pls.7;
        Thu, 22 Aug 2019 07:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a4p8TCPaKfvEooizyzxHRIZAkY4d+DzJCKHmH6UyvCo=;
        b=MAdP3FsXFIrJVFxUSj2otOJoFvfqmDO4tlehtTrismgS9VWaoUbSDZ7iiGkOIl8ABq
         +R0lxcqwgaMHRWBPVZjRr11rLMFNfF9E1/n3bm0ur2uDpHcYwNiunvkQDy00EpPZQLkC
         2I6b5nyVgR77g3KgCw6cX6JFOmeJIcZy2HBlpQuxK8fKLb5D4lNGkRc8USRR2wIw4kke
         0/7jcrc5jpjqbMcIzrUy057QTDW2ZJY242WvPtstx9GFS+F46HAAhQmxnAEIZIuQtt0S
         kalZ8NM/e2CABcSb4MhGanmdmmSxlCP9tgkTgG5qDF2AWnUPSumsDhIQFa8l4hJ0VtJs
         IiOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a4p8TCPaKfvEooizyzxHRIZAkY4d+DzJCKHmH6UyvCo=;
        b=oJVoikOozfxx12V+M8QYVvx8Kix7pcOHAMvAFw6CDKglRxQolIa6habbdeK+GDK7+O
         7jjOtKepIMjLKQOMriwnhF41wSnM1lWFs4+SQ1ESj/5bHbc+uDZg4Cgua60QCWUiU8HF
         twBkgk0JcLnX2sN8cVxKtjPXkfNIN9EjEEwE1tL9WoJF0wp6cxW9opI4ciDJu/PQY+1z
         JK4yGOwK0bsGn2ZySChiCmsJrZb3kQ8ftRs1OBsv1LrIbEBwSxthw91F8sdD50otYaai
         0DI0u0LzAbgOPwd/i7HJUiqRmmzEHTeNUOfMscGRgWioqLhx/Mdl3yGlBeDFD2vIjxvh
         Fwkw==
X-Gm-Message-State: APjAAAXwSkT4zQvHw2fPeDxuEbYo5xFBCaXCNC7cHv1tXrIEgvwvX3N+
        aM0zFrzA0r8D5fquwX+R+NM=
X-Google-Smtp-Source: APXvYqwALLBfgiwxGFa9tOYNMRQrYeu3WlICxCBO1gzKOzDYuX9mmAPLFJ71qGPupq8dDLKzgc0xVw==
X-Received: by 2002:a17:902:b084:: with SMTP id p4mr39521574plr.309.1566484245065;
        Thu, 22 Aug 2019 07:30:45 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id r23sm32263161pfg.10.2019.08.22.07.30.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 22 Aug 2019 07:30:44 -0700 (PDT)
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
Subject: [PATCH V4 2/3] KVM/Hyper-V: Add new KVM capability KVM_CAP_HYPERV_DIRECT_TLBFLUSH
Date:   Thu, 22 Aug 2019 22:30:20 +0800
Message-Id: <20190822143021.7518-3-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190822143021.7518-1-Tianyu.Lan@microsoft.com>
References: <20190822143021.7518-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V direct tlb flush function should be enabled for
guest that only uses Hyper-V hypercall. User space
hypervisor(e.g, Qemu) can disable KVM identification in
CPUID and just exposes Hyper-V identification to make
sure the precondition. Add new KVM capability KVM_CAP_
HYPERV_DIRECT_TLBFLUSH for user space to enable Hyper-V
direct tlb function and this function is default to be
disabled in KVM.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
	- Update Changelog.
Change since v1:
	- Update description of KVM_CAP_HYPERV_DIRECT_TLBFLUSH
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

