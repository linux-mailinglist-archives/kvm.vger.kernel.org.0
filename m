Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F7D4D5A00
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344030AbiCKEuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346500AbiCKEuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:01 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299ED1AC2BD
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:55 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id x10-20020a170902a38a00b00151e09a4e15so3911673pla.15
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YvkdLZdpcr97EpSsUi5adIM71O6zx1+CVaghTM2lKQc=;
        b=WW9mUBlAXTHtpKEr3Ay7NmT20frRkus2LqacrMY+0B0b1ZhuU3tEvhK6b3wZU/ORFt
         sa55nV3ZrgY5MgtjlQVBpdtqyFbjZppWQCm2l0cVBWAqi1VDRVbjrjB/uu1VrUXHsT3v
         JTQv7fegNAfQHGW26cOwiExvl2UWjMKnpBMAexNgf8VDKqrGSfZLt3A33jk7p/97Cfn4
         9+3/YGnvvaatyDI8WqBeDbkRQt/2eHQO/TObdfaHNMTWEOnV/efpI33e3RpcIgKOFDFS
         ++uMr4ZigfVe97viZ9lx3iiQPIXSsluL57ZzBOGYES5FDwrFO0ILP8RZ5oAwpA43s2IW
         Abzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YvkdLZdpcr97EpSsUi5adIM71O6zx1+CVaghTM2lKQc=;
        b=HVu7GzTRGnvrjOfHsbmRioAv84DwN1jUOo0X5o0Lfs4NYBiXswJ+m6OhbxOprYrTO/
         YlLuwnN87H7woizqaXBhrOLgvHJb7dSZgowOt9qAYbvZPGQWz74KkIEoAo/sSgTLivFZ
         ySBlNyPL59yrmSjbDRkW5P/yPWWZ/fGyGTbs9GF/TBs330OFDh5oDjm/i1OhAp3FQjUn
         wKSsqwdHcGIslmtlNh2OwiYPotIEx5NqVYni++RoP2xJCgf5eZCJqX1IUTH3AmhWY6vN
         0thBCIoHVuEVSoLSRfhg0fqYZljYs0P86tFDmWMouvr7/F1vEmu1ogXIopVz/TSAyI7m
         emtw==
X-Gm-Message-State: AOAM53110cwcDiV19Qwu+CcvLAYExretvMgYCuSrZ47/1RZuK7FEVCrd
        Faviapb/0ARJuGXmLw1trEzGD8Q32F8=
X-Google-Smtp-Source: ABdhPJyXnNci0fOzvDdVKJf4gcHvVbtR1SLTxJuXYaGJpVy9F9SwRVGou9JVMngVfwiQy4DD8uTH1DNToK8=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:c96:b0:4f7:203a:e8de with SMTP id
 a22-20020a056a000c9600b004f7203ae8demr8180188pfv.32.1646974134582; Thu, 10
 Mar 2022 20:48:54 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:48:00 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-15-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 14/25] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE
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
index 9f3172376ec3..d2cd404d74c2 100644
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
@@ -7575,3 +7579,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
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
index 507ee1f2aa96..a9351727a7aa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1135,6 +1135,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
 #define KVM_CAP_PPC_AIL_MODE_3 210
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 211
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.723.g4982287a31-goog

