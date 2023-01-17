Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8626E66DB16
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbjAQKas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbjAQKaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:30:21 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345A72FCE3
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:38 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d2so9952631wrp.8
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOVpxHZD0ZxVt/Val7yzJDOKpsPkSooq27SOBhqL+Kk=;
        b=g1p3ubnYwRTHrjE4Z2DfA/MH2EnDrh/8t2YbdFdGQ2RXS4HCOPoDRzLc6RbgsSk7EZ
         wiVV99cgkBmBSDrFgSxkSKw+h7LrY5waW8HRALrEO4NhQVKA4EY/LHdIOm6VAl6XxM5j
         6kAgMinmi+lStYZQSun536mzqwEGcQzCWTyvlYeAm+8vuw+zX3dcBUapeO4+TO+IeXbQ
         v8uLeKNqsgFGn+WhKtX21orc6zZELYXdRHZriJFDI9/HVEBnxQ1M4eKmKJvopJHyg11g
         UcS8wqDaZUwVO9tvmMZXDTCTYQxa5DvYEMivbSqOc2MFSL1zycMGKA+dj4Yo1KeJvF+6
         HecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOVpxHZD0ZxVt/Val7yzJDOKpsPkSooq27SOBhqL+Kk=;
        b=Q/YvJS6EwQDpGfeBYOE2MeHwePMyrbasYlsRVKN9m/Ub0CJ9Q4PtEj8ru1+cFIcTS3
         xfTWnG/0/fVrplmgHEMLxOWeIGiDyqBNuyCkKH0iERkVjFDl1qQbAw4QXCs96Oo6LOYJ
         NbkiZCq10/LxyN/Kv0Tq8oFzPbJ0JIuh0cRZfecA2kgwuIRfTHJ6g0EP/zm4pnlQ0eUJ
         srAkVDEYeaaDfBa0aX563NPbcn5JU2JUi5zUUWXNlqzX+2iVtAbbZchsowOM4pEQiHju
         TCSvOmbWzqx7DASvkdlCYCfum5AnWz4SezO9RT567j6W6UzDHH2uutGvkgXdAGSJc2md
         57eQ==
X-Gm-Message-State: AFqh2kqE47nUESfvjvRkxe67yu0GyDU9gY0Wziqb2m5tXko7WxgF4/PV
        zZxZ9qvKmFHGoVxp4ddIAVLVSGLGPedbiPI0Ims=
X-Google-Smtp-Source: AMrXdXuy/hWkhxW9y7rCTLOqE/Nibr8MFx8zKk9jZqoyS1EmphFslhRskgoNwSz+fAiunB8+BlVPog==
X-Received: by 2002:adf:fd83:0:b0:2bd:dbd8:d41e with SMTP id d3-20020adffd83000000b002bddbd8d41emr2309747wrr.57.1673951376751;
        Tue, 17 Jan 2023 02:29:36 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:17d8:e5ec:f870:7b46])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d452f000000b0028f9132e9ddsm28389844wra.39.2023.01.17.02.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:29:36 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, pbonzini@redhat.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v3 1/6] KVM: arm64: Document PV-lock interface
Date:   Tue, 17 Jan 2023 10:29:25 +0000
Message-Id: <20230117102930.1053337-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230117102930.1053337-1-usama.arif@bytedance.com>
References: <20230117102930.1053337-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a paravirtualization interface for KVM/arm64 to obtain whether
the VCPU is currently running or not.

The PV lock structure of the guest is allocated by user space.

A hypercall interface is provided for the guest to interrogate the
location of the shared memory structures.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 Documentation/virt/kvm/arm/index.rst    |  1 +
 Documentation/virt/kvm/arm/pvlock.rst   | 54 +++++++++++++++++++++++++
 Documentation/virt/kvm/devices/vcpu.rst | 25 ++++++++++++
 3 files changed, 80 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/pvlock.rst

diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index e84848432158..b8499dc00a6a 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -10,4 +10,5 @@ ARM
    hyp-abi
    hypercalls
    pvtime
+   pvlock
    ptp_kvm
diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
new file mode 100644
index 000000000000..1b9ff7d8a385
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pvlock.rst
@@ -0,0 +1,54 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Paravirtualized lock support for arm64
+======================================
+
+KVM/arm64 provides a hypervisor service call for paravirtualized guests to
+determine whether a VCPU is currently running or not.
+
+A new SMCCC compatible hypercall is defined:
+
+* ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID:   0xC6000002
+
+ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID
+
+    ============= ========    ==========================================
+    Function ID:  (uint32)    0xC6000002
+    Return value: (int64)     IPA of the pv lock data structure for this
+                              VCPU. On failure:
+                              NOT_SUPPORTED (-1)
+    ============= ========    ==========================================
+
+The IPA returned by PV_LOCK_PREEMPTED should be mapped by the guest as normal
+memory with inner and outer write back caching attributes, in the inner
+shareable domain.
+
+PV_LOCK_PREEMPTED returns the structure for the calling VCPU.
+
+PV lock state
+-------------
+
+The structure pointed to by the PV_LOCK_PREEMPTED hypercall is as follows:
+
++-----------+-------------+-------------+---------------------------------+
+| Field     | Byte Length | Byte Offset | Description                     |
++===========+=============+=============+=================================+
+| preempted |      8      |      0      | Used to indicate if the VCPU    |
+|           |             |             | which owns this struct is       |
+|           |             |             | running or not.                 |
+|           |             |             | A non-zero value mean the VCPU  |
+|           |             |             | has been scheduled out. A zero  |
+|           |             |             | value means the VCPU has been   |
+|           |             |             | scheduled in.                   |
++-----------+-------------+-------------+---------------------------------+
+
+The preempted field will be updated to 0 by the hypervisor prior to scheduling
+a VCPU. When the VCPU is scheduled out, the preempted field will be updated
+to 1 by the hypervisor.
+
+The structure will be present within a reserved region of the normal memory
+given to the guest. The guest should not attempt to write into this memory.
+There is a structure per VCPU of the guest.
+
+For the user space interface see
+:ref:`Documentation/virt/kvm/devices/vcpu.rst <kvm_arm_vcpu_pvlock_ctrl>`.
\ No newline at end of file
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 31f14ec4a65b..0f999919ba92 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -265,3 +265,28 @@ From the destination VMM process:
 
 7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
    respective value derived in the previous step.
+
+.. _kvm_arm_vcpu_pvlock_ctrl:
+
+5. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL
+==================================
+
+:Architectures: ARM64
+
+5.1 ATTRIBUTE: KVM_ARM_VCPU_PVLOCK_IPA
+--------------------------------------
+
+:Parameters: 64-bit base address
+
+Returns:
+
+	 =======  ======================================
+	 -ENXIO   PV lock not implemented
+	 -EEXIST  Base address already set for this VCPU
+	 -EINVAL  Base address not 64 byte aligned
+	 =======  ======================================
+
+Specifies the base address of the pv lock structure for this VCPU. The
+base address must be 64 byte aligned and exist within a valid guest memory
+region. See Documentation/virt/kvm/arm/pvlock.rst for more information
+including the layout of the pv lock structure.
-- 
2.25.1

