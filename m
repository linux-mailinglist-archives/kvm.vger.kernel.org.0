Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9EB4848D8
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiADTtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiADTth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:49:37 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785F8C06179C
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:49:35 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d14-20020a170903230e00b001491f21adf2so4554741plh.8
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Z8f3pbOlFfhJc+MZxj7F3/2ZMbhtOsD2BP3YM7tyFSI=;
        b=OaSbR2gJ2IXGYHNG7buKj7VOZ4GeQdjTTsbGWOeIcUNX+UJFsEii0dDfyTGsoPxIKb
         wx8UL7lfUSB21kFvjQEyLl3E6BqGHYLI+Elic6yKmOAqNsqWrB2r+zSmPpF4uLaGQyZY
         vukjKlc6W07BGNSQgd0GvWKr3TjPRMlVohLF3oUb/hBfj87jwlubT++V0yjMwdC2JSxn
         ohSNZKVRuRxMUv7IpOQt7LgtleeUnSC40Ulh3+yelQU4udeIldttZVuQ4/lEB/Yz5nFP
         eZUjGHJTGiIafggw16v3rJ8NP92X239/cHs8ddu1jKMcMoA9KKCV7D4g7AdzGagdG9I6
         gtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Z8f3pbOlFfhJc+MZxj7F3/2ZMbhtOsD2BP3YM7tyFSI=;
        b=15O78BRUjtrkd5YVxJX3KcRXD+x6LmcCNKcB7Zp6kBWCHcfEaP4vMwy/hEBYyFoPpO
         x9HBvF/FSRPExi92u5tb7oJ/xRJgoluWjuHpyWil9xl5lOwS0vqhkJ3BT4/d5HkxH6kS
         P/52QYffsDRkZ1g9+VDTGaKmBXwueDSGYrU3OC51GIZOSmFuG0SmQNASp3scm2vTI8Ok
         7VC08ErsiJTnk1iAprIimfx1hhcVf3GEMxKLQHXEqZvEkxmOmvDJica+PX+L0fX6qwQ2
         b4GMYLpUQaHBq7U4bRs1FvG7pfOwSauFliGNXcgERrMQPOJeo/sKurGTCJsJA0xjwVJ+
         cYqA==
X-Gm-Message-State: AOAM533ZNP6AeA2K82RJTVSzidWrJtGGE9Eh1FTlcc2YqfiLDayIpRk/
        lqpWiaFOgrAJEk4w2MI49oJTGqSsAWgV
X-Google-Smtp-Source: ABdhPJwRTLWTJz2U+utOgtiR1Vb8LCrr/pZS/a+ivsj8Sv6sdQTy02D1hR10crnPg22DzkZHlLaKsOHvhnxJ
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:81ce:0:b0:4bc:d8ec:9748 with SMTP id
 c14-20020aa781ce000000b004bcd8ec9748mr1389383pfn.29.1641325774964; Tue, 04
 Jan 2022 11:49:34 -0800 (PST)
Date:   Tue,  4 Jan 2022 19:49:10 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-4-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 03/11] KVM: Introduce KVM_CAP_ARM_HVC_FW_REG_BMAP
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the KVM ARM64 capability, KVM_CAP_ARM_HVC_FW_REG_BMAP,
to indicate the support for psuedo-firmware bitmap extension.
Each of these registers holds a feature-set exposed to the guest
in the form of a bitmap. If supported, a simple 'read' of the
capability should return the number of psuedo-firmware registers
supported. User-space can utilize this to discover the registers.
It can further explore or modify the features using the classical
GET/SET_ONE_REG interface.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 2 files changed, 22 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..646176537f2c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6925,6 +6925,27 @@ indicated by the fd to the VM this is called on.
 This is intended to support intra-host migration of VMs between userspace VMMs,
 upgrading the VMM process without interrupting the guest.
 
+7.30 KVM_CAP_ARM_HVC_FW_REG_BMAP
+--------------------------------
+
+:Architectures: arm64
+:Parameters: None
+:Returns: Number of psuedo-firmware registers supported
+
+This capability indicates that KVM for arm64 supports the psuedo-firmware
+register bitmap extension. Each of these registers represent the features
+supported by a particular type in the form of a bitmap. By default, these
+registers are set with the upper limit of the features that are supported.
+
+The registers can be accessed via the standard SET_ONE_REG and KVM_GET_ONE_REG
+interfaces. The user-space is expected to read the number of these registers
+available by reading KVM_CAP_ARM_HVC_FW_REG_BMAP, read the current bitmap
+configuration via GET_ONE_REG for each register, and then write back the
+desired bitmap of features that it wishes the guest to see via SET_ONE_REG.
+
+Note that KVM doesn't allow the user-space to modify these registers after
+the VM (any of the vCPUs) has started running.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..209b43dbbc3c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_ARM_HVC_FW_REG_BMAP 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1.448.ga2b2bfdf31-goog

