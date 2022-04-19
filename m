Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479D650651A
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349129AbiDSHA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349119AbiDSHAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:25 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2D427B37
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:42 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m8-20020a17090aab0800b001cb1320ef6eso1185436pjq.3
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U4uOGGGNJJAvE+8qhBWKzG6xiqX6UboPrGG2sNPZOY8=;
        b=BewbNlPjPqMatcm5XCUJOCpQZV4IoUW4ifHD5JfI6GHGlRBqW2sLCDsPuTDMbF2jUH
         Wlv1w+R+Edq3e7b8T/1GKHqWp2fKfCDQosSdPRzW1wXYl688u7L0nZNPdsN1cV8hUJlj
         dA7dU+yyYorRaosHIs3zf7EDl5GaiYDINtqkhAEv928ecEPq4g9QENwKQkaqEVUO+EdU
         kLtR11yTTd7eAasAJcwfVzE8tSgBo/4cH2y9b/7wc9XFcuKMcMQ188Jx2nOlz6c8Pt6r
         4SpvFqlxMnxNrUpursSPLQOzcC+Kc38iLMoD9FEUJ9QWJjCdK6M8OTNlU4b8jYjVazsJ
         NFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U4uOGGGNJJAvE+8qhBWKzG6xiqX6UboPrGG2sNPZOY8=;
        b=jAW6VayljAMyR1bCUcdi9hLZRQY3EXbADU3b0pJXFE6XMSOK3Ax7eMSSzDbGsYRKXT
         DxKD0TQx5H+l2dqstGLFVNXMvK3QiJGdOgqIMrCkGzGrhrVpS9MAMLPDAWVJ0H2y8UMJ
         Z9plQXROjZ+RYYF7aF3omidbpASGEIiRUc1FcOjD5Sownz+pi0rjJEHsE578f3lp9498
         EmsDXZ7fDqgM/W3qwERSoy044M7Eqx83wdtEPddL0mpnKgFvw46WJdkRGqoVRpXiKKvC
         CBIs+QqbK7DrydznOinV7GHiHLSOpknCTJWIRiS46UHAqxfkv3e/IWmyk67U3LvXK/V/
         vFdw==
X-Gm-Message-State: AOAM531gZJ7Az0KwZ8R7qM8bLJYOE9tFB/akgtXIw6B2Q9ip6bcx8621
        B4hRtqfssg/0aBftQC4GapK9T2x4/08=
X-Google-Smtp-Source: ABdhPJwNvsMFXxj/P4c/uyL22/CuuuumZEIUldC8yuu2qFzsobmd9UhZjjZnKg5gGPfNpCl6SSEUeTinmLA=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:cc0b:b0:1cb:8351:a47e with SMTP id
 b11-20020a17090acc0b00b001cb8351a47emr17191716pju.67.1650351461844; Mon, 18
 Apr 2022 23:57:41 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:28 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-23-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 22/38] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE
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
 Documentation/virt/kvm/api.rst | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c           |  1 +
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 18 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85c7abc51af5..e2e7b08e64c1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2601,6 +2601,14 @@ EINVAL.
 After the vcpu's SVE configuration is finalized, further attempts to
 write this register will fail with EPERM.
 
+The arm64 ID registers with encoding Op0=3, Op1=0, CRn=0, 1<=CRm<8, 0<=Op2<8
+are allowed to modified by userspace only for AArch64 EL1 vCPUs if
+KVM_CAP_ARM_ID_REG_CONFIGURABLE is available.
+They become immutable after calling KVM_RUN on any of the
+vcpus in the guest (modifying values of those registers will fail).
+Those ID registers are always immutable for AArch32 EL1 vCPUs, which
+KVM_ARM_VCPU_EL1_32BIT is configured for, even when
+KVM_CAP_ARM_ID_REG_CONFIGURABLE is available.
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -7724,6 +7732,14 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
 this capability will disable PMU virtualization for that VM.  Usermode
 should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 
+8.35 KVM_CAP_ARM_ID_REG_CONFIGURABLE
+------------------------------------
+
+:Architectures: arm64
+
+This capability indicates that userspace can modify the ID registers
+via KVM_SET_ONE_REG ioctl.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5c1cee04aa95..b4db368948cc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -211,6 +211,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_CONFIGURABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 91a6fe4e02c0..171f1d0ea1e1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 214
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

