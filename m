Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CBD485FC2
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiAFE2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiAFE2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:28:54 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1EFC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:28:54 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id y5-20020a17090a390500b001b2b8bb4e3dso4017303pjb.3
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qsXbUWt4k61IeDMaJ9yBb2pGASPsSAD6bL2wC01t25c=;
        b=X3r9aCI3viml7Ve7M/vnUEWHj5rEsNNVR6sb7qQzcD8l+h1EFbuICdNFRrf6JnRz0D
         HhyUCXipJ72usL89WgDrd35ksSuWYF4UeGu6JX7EvzzJ2gbnkaUfxVvPrAcfnuQUR5CO
         BrXhEsgD4G5nKCZemrjqh8BnoYfw9EZcn2+XSGolSgF4YpW5Pyd3NMq4FC7rnxIpUGPO
         ptAYwJWAyXeEfXygvuj2jHN9J/6ZsLXnuh7reAuronSnzdQicn1PWyHNTmR62yJzghab
         iKAmQ95r2rug/zKKw1R6nEFh88SK98Ne0RgxUktyWbpS0m5TryJUKxgXFd0STRu3RD6k
         YFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qsXbUWt4k61IeDMaJ9yBb2pGASPsSAD6bL2wC01t25c=;
        b=l+bf+KYMS41tm/uo9xWLEe0s+1Jpe+t17Vav4YN0EZ7JPg5y70ro/zfaieRmPf5dMw
         Zl1aBodaZE1mkT8cVkRM7fLrLhi6syGo1oQjvq8YJGpNrKWI+VoD1pIfVONw12NnUxdG
         nN3tKoRxLIEG1mncr+gQxnymOYAYY+MF5YeOF5fv+wz9ahEHTrCWfc6elFh2RrEhCO25
         x8LOup/E0DAntRXtlPSV2jMujbnXfixiauTCFCUTTlWzIA2fXuHg64EBvcZat3yZKsGH
         EKtDRrv1udTR6qrfT5Xvqabh6kAO/U1AKs7XYJDf7uH3uqCse5GuPRv2lDyJ+7nYQvyB
         tLbw==
X-Gm-Message-State: AOAM531w/fneJU1pWB3zbZsgDqwG5q2QVCtnyOhbltbC6W/1AzItMB4/
        m5s8HIYESEyrGsDIaANxiNkE6Og6nN8=
X-Google-Smtp-Source: ABdhPJw50t65HXqO3xQ2kp1MCKMxMqyY4SYSE/3YVObavipJJ7gE0Al1VQutdOv3vePKB24kL3IGH5TXOOk=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:350b:: with SMTP id
 ls11mr7818734pjb.97.1641443333689; Wed, 05 Jan 2022 20:28:53 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:26:57 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-16-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 15/26] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE
 capability
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new capability KVM_CAP_ARM_ID_REG_CONFIGURABLE to indicate
that ID registers are writable by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 Documentation/virt/kvm/api.rst | 12 ++++++++++++
 arch/arm64/kvm/arm.c           |  1 +
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 14 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..86099a9b0bae 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2574,6 +2574,10 @@ EINVAL.
 After the vcpu's SVE configuration is finalized, further attempts to
 write this register will fail with EPERM.
 
+The arm64 ID registers (where Op0=3, Op1=0, CRn=0, 0<=CRm<8, 0<=Op2<8)
+are allowed to set by userspace if KVM_CAP_ARM_ID_REG_CONFIGURABLE is
+available.  They become immutable after calling KVM_RUN on any of the
+vcpus in the guest (modifying values of those registers will fail).
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -7484,3 +7488,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_ARM_ID_REG_CONFIGURABLE
+------------------------------------
+
+:Architectures: arm64
+
+This capability indicates that userspace can modify the ID registers
+via KVM_SET_ONE_REG ioctl.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 16fc2ce32069..876f2777acf2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -216,6 +216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_CONFIGURABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..9697c06a7f5b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1.448.ga2b2bfdf31-goog

