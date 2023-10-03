Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF907B747A
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 01:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjJCXEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 19:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjJCXEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 19:04:43 -0400
Received: from out-196.mta0.migadu.com (out-196.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA7AAB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 16:04:39 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696374277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YNbDmwInvCXAtoQgmaXvITi9eX9wImyOeBxRJGtU+1I=;
        b=DK2D4tfyGgo/f3Vs3hFL8DNfpSyJg7fVU2VWylCjDc4qrZ4DI88mbpNQkYkGadqDVMr/g2
        u/GfUCBxiAhCzHQBAulTsa7EJq2zD44JwF21Pf70sya/iY1tHEReQ/il7hmGa4VdVWMNlJ
        JzVGKomfrW0DJilGYZ0oODf2pI4EQ3Y=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v11 10/12] KVM: arm64: Document vCPU feature selection UAPIs
Date:   Tue,  3 Oct 2023 23:04:06 +0000
Message-ID: <20231003230408.3405722-11-oliver.upton@linux.dev>
In-Reply-To: <20231003230408.3405722-1-oliver.upton@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/arm64 has a couple schemes for handling vCPU feature selection now,
which is a lot to put on userspace. Add some documentation about how
these interact and provide some recommendations for how to use the
writable ID register scheme.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst               |  4 ++
 Documentation/virt/kvm/arm/index.rst         |  1 +
 Documentation/virt/kvm/arm/vcpu-features.rst | 48 ++++++++++++++++++++
 3 files changed, 53 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/vcpu-features.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d55c2b68c0a9..8d4050eedb26 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3370,6 +3370,8 @@ return indicates the attribute is implemented.  It does not necessarily
 indicate that the attribute can be read or written in the device's
 current state.  "addr" is ignored.
 
+.. _KVM_ARM_VCPU_INIT:
+
 4.82 KVM_ARM_VCPU_INIT
 ----------------------
 
@@ -6070,6 +6072,8 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+.. _KVM_ARM_GET_REG_WRITABLE_MASKS:
+
 4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
 -------------------------------------------
 
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index e84848432158..7f231c724e16 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -11,3 +11,4 @@ ARM
    hypercalls
    pvtime
    ptp_kvm
+   vcpu-features
diff --git a/Documentation/virt/kvm/arm/vcpu-features.rst b/Documentation/virt/kvm/arm/vcpu-features.rst
new file mode 100644
index 000000000000..2d2f89c5781f
--- /dev/null
+++ b/Documentation/virt/kvm/arm/vcpu-features.rst
@@ -0,0 +1,48 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================
+vCPU feature selection on arm64
+===============================
+
+KVM/arm64 provides two mechanisms that allow userspace to configure
+the CPU features presented to the guest.
+
+KVM_ARM_VCPU_INIT
+=================
+
+The ``KVM_ARM_VCPU_INIT`` ioctl accepts a bitmap of feature flags
+(``struct kvm_vcpu_init::features``). Features enabled by this interface are
+*opt-in* and may change/extend UAPI. See :ref:`KVM_ARM_VCPU_INIT` for complete
+documentation of the features controlled by the ioctl.
+
+Otherwise, all CPU features supported by KVM are described by the architected
+ID registers.
+
+The ID Registers
+================
+
+The Arm architecture specifies a range of *ID Registers* that describe the set
+of architectural features supported by the CPU implementation. KVM initializes
+the guest's ID registers to the maximum set of CPU features supported by the
+system. The ID register values are VM-scoped in KVM, meaning that the values
+are identical for all vCPUs in a VM.
+
+KVM allows userspace to *opt-out* of certain CPU features described by the ID
+registers by writing values to them via the ``KVM_SET_ONE_REG`` ioctl. The ID
+registers are mutable until the VM has started, i.e. userspace has called
+``KVM_RUN`` on at least one vCPU in the VM. Userspace can discover what fields
+are mutable in the ID registers using the ``KVM_ARM_GET_REG_WRITABLE_MASKS``.
+See the :ref:`ioctl documentation <KVM_ARM_GET_REG_WRITABLE_MASKS>` for more
+details.
+
+Userspace is allowed to *limit* or *mask* CPU features according to the rules
+outlined by the architecture in DDI0487J 'D19.1.3 Principles of the ID scheme
+for fields in ID register'. KVM does not allow ID register values that exceed
+the capabilities of the system.
+
+.. warning::
+   It is **strongly recommended** that userspace modify the ID register values
+   before accessing the rest of the vCPU's CPU register state. KVM may use the
+   ID register values to control feature emulation. Interleaving ID register
+   modification with other system register accesses may lead to unpredictable
+   behavior.
-- 
2.42.0.609.gbb76f46606-goog

