Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19A74B426A
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbiBNHBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:01:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241082AbiBNHBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:01:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3696575DD
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:00:55 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ml24-20020a17090b361800b001b8877a4b6eso10298324pjb.5
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LqqSQ+pfjPkcBMVZaT7DXOpSryezslmtHzw2gvxdUKE=;
        b=BXNGQJEPXj526bgkijx0svS6AKh+wH5vz+CbiZqi9LTPYrppZNqH1xhYeJcxPJ5KmD
         fLdIRkEuCi8EKF+K6RLiw0e7mv4Zn8WsF/aWGLoL/NQJP3thK4ZeeCZVnDZ5DiTkKtyh
         CB16pqTyBC0mYbZbgg7MY4vqc0YSPHcLL1B/pPU3SMrbo90o8frKVSPeqB1UR3/gCfdi
         6WeqIw7fNOXxjZ1N3MpkxxiG1jx9t7gSBJmh910trAu4csbKLiS9cO+nnv3tl70rPFgs
         ROEn0N+WhhmpRsZJLhuJEp0M7OD90CUJtgic/1vGeRE8MgxoOfAcDDAviTAS3aXiXn0s
         K9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LqqSQ+pfjPkcBMVZaT7DXOpSryezslmtHzw2gvxdUKE=;
        b=uFVzV4vG8j242/OVanpaiR9CbD6crsnbpdwPMwLSWEyfCpBbWX+t8ESptn+qOzAxmf
         g2gJVuQJKZkuks26+80vhStbLmehr7prMuRUQkRTDekMQ6h7tnqgLisI5nSBNQZzU6VG
         LfItg8hXvLmPdW2BhFRbg5qXC9EO9+8F6IGx3QEpaYqPz/63vp5zVaGfXXc/NhflMX7t
         Mvpa9dPxrEhns5INeGf1UYuyTIjwYhmVuIfN2apaigofqh6cuq1N2IOUFJopJzG7DOAl
         Sef0FaK0PHH25GnQK1/0QDkQaHANbTVikB+f1dRbqseznShGqaIFewOTLQJI21vcR0xC
         woUw==
X-Gm-Message-State: AOAM532QPq1RqId1bRHHZwK47dqLH6Cwf4U9ngLGevtVGWWeN4UqraNe
        e95hxXgdis/JmVBBMtnxqkZocm+h/X4=
X-Google-Smtp-Source: ABdhPJz6IFXa9hWbUTsAZTdoeoQlMhXZJjw8CsklsTYlXwId7cdlTGLWp5HcrUaCg10o3Cb+CSmqrI+AFz0=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a63:a1f:: with SMTP id 31mr4796173pgk.79.1644822055226;
 Sun, 13 Feb 2022 23:00:55 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:35 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-17-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 16/27] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE
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
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index a4267104db50..901ab8486189 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2607,6 +2607,10 @@ EINVAL.
 After the vcpu's SVE configuration is finalized, further attempts to
 write this register will fail with EPERM.
 
+The arm64 ID registers (where Op0=3, Op1=0, CRn=0, 0<=CRm<8, 0<=Op2<8)
+are allowed to set by userspace if KVM_CAP_ARM_ID_REG_CONFIGURABLE is
+available.  They become immutable after calling KVM_RUN on any of the
+vcpus in the guest (modifying values of those registers will fail).
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -7561,3 +7565,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
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
index e7dcc7704302..68ffced5b09e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -210,6 +210,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_CONFIGURABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..6e09f2c2c0c1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.265.g69c8d7142f-goog

