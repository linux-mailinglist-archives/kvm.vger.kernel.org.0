Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F2D87697
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 11:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406160AbfHIJu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 05:50:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46966 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfHIJu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 05:50:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id c2so44740291plz.13;
        Fri, 09 Aug 2019 02:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Atc4BJswO9FqSuTtYaBzlXzj28k8fIGbRP3z5mb0CLo=;
        b=rEZkCZMk5CPxG24fbgvRRyk7BDHZ2M1b3XQUCUTFP/DLFesJrUZlgHGWF3weO28T/F
         Nc3AkdOeg/fOyeGOKV69x71UqUNH9PTRwQ2W7AO3Aq063LzHvlRlwkENUtZ7FbOF6FvB
         kgU2mmGXe+IaDjijV6EXq9wsyAhhOAyoVVdDrocn0nV3xbhSfCsuShMSWeAQY1BW5FiP
         YUa8OW/v4d6R3L6yjaHZxGzjnV61upYIBulsOb9hhOXEjUxVs2RFhqNQH5F4y1yjfHb/
         AN160tvH9YzJ6Y7A0JCVN6wTL8MqcN5dyz+yuQMkVCoG8XIVcWkIzKutZWGyPcTu6emL
         5Xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Atc4BJswO9FqSuTtYaBzlXzj28k8fIGbRP3z5mb0CLo=;
        b=Rt3SbpKu0i5UivqIjxFbYxIbxaXEQdQi1tFTmu5j6rmPhHJ2kZOGT0q99ztLqC9dBN
         FyojH18y1WByIxmJhi90AepdszJ6uu+SQ9O036akgVuUaOfy6R216lf/IzfP03wL3hwR
         /OCo8zejG1+i2No7enYDZeESU5LxTKPb94DqmVNL3BiQ4yIMEhosKgsH4atQMwBEMqWK
         UgwSHJqmfI+Sukiplm1r/go/ichptgEhrTEeMvRjcn5ozR8IMTacE4082MesbxKDVQMV
         7V3z7yTMebDftlVh5HjTd0207DR6ASEASyLIy1zfXXwi64sIF+5KBTIvpmfzNx4I+Isq
         KIDg==
X-Gm-Message-State: APjAAAXm7QAd0M9shsxRoLB3a9lhSpj9SFWCRQWVrkpQHpdhYOdXGB5S
        31XTnEwG8kjFi8kApuICakU=
X-Google-Smtp-Source: APXvYqyQvioXozfaCcOY1rFaU8I0RHo0Isan7blQvSuI0A4SMQOVkO7vzQaQIQeJKR4mZETm9zs2vQ==
X-Received: by 2002:a17:902:8689:: with SMTP id g9mr16880319plo.252.1565344227241;
        Fri, 09 Aug 2019 02:50:27 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id b16sm159653631pfo.54.2019.08.09.02.50.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Aug 2019 02:50:26 -0700 (PDT)
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
Subject: [PATCH 2/3] KVM/Hyper-V: Add new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH
Date:   Fri,  9 Aug 2019 17:49:38 +0800
Message-Id: <20190809094939.76093-3-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190809094939.76093-1-Tianyu.Lan@microsoft.com>
References: <20190809094939.76093-1-Tianyu.Lan@microsoft.com>
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
 Documentation/virtual/kvm/api.txt | 10 ++++++++++
 arch/x86/include/asm/kvm_host.h   |  2 ++
 arch/x86/kvm/x86.c                |  8 ++++++++
 include/uapi/linux/kvm.h          |  1 +
 4 files changed, 21 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 2cd6250b2896..45308ed6dd75 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -5289,3 +5289,13 @@ Architectures: x86
 This capability indicates that KVM supports paravirtualized Hyper-V IPI send
 hypercalls:
 HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
+8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
+
+Architecture: x86
+
+This capability indicates that KVM supports Hyper-V direct tlb flush function.
+User space should enable this feature only when Hyper-V hypervisor capability
+is exposed to guest and KVM profile is hided. Both Hyper-V and KVM hypercalls
+use RAX and RCX registers to pass parameters. If KVM hypercall is exposed
+to L2 guest with direct tlbflush enabled, Hyper-V may mistake KVM hypercall
+for Hyper-V tlb flush Hypercall due to paremeter register overlap.
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
2.14.2

