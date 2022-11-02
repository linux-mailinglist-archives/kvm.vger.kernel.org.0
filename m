Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB0E61685D
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiKBQUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiKBQU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:20:26 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F5530F41
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:14:49 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id i5-20020a1c3b05000000b003cf47dcd316so1595215wma.4
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXj/+tvutn9072ZUAQ/Fj8mIysO5PQhhp6FCeEN8Zrw=;
        b=A1TppZwD1Iw4IiArSoEXOboBO1payKvnhkZBo3OOtZHRLZ4/rXNVt6HQfaMag0SB3I
         o7IG79mBlebjo+m4QnYUOSccej3xGTMo2gfsJxfeykR32qFtNfnKcKC/xBPaneuroKb1
         FZmHjMcT+hD//AuJYINwjZTuxoioQ+LfktSZbFrIy8ZZbm0bZt1wYOF6wRd7RphI1kmt
         2xqKYWexAvzjDguIaLOmSDiOSrsYLM4XEGpfZzTZO4lq9uDHcZIq0T6w+mgWVR4gjLOD
         JVRPHC8kAAdfUu+ij3PWrhXEBc5OiM6ZdIrP/JUKHIaVIJoX2aguWijsZNu16WKRGULF
         HxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXj/+tvutn9072ZUAQ/Fj8mIysO5PQhhp6FCeEN8Zrw=;
        b=7PUGFLRQwtO16pCQlgjzEu4746uG/CsEy1CsUi1g/XLiPI/fycmobiSPyVMR/on0ns
         QaLcWfIcXjLvyROjUGkbaIHvRx8pJ7ZNNggDbaWxSx5ZRY3xwXmMOUFfogscj4mSrSz0
         sj1fmLxpo1YUPhqDHnfL2/HyfBOMRnj/tGRe2oLMvm9UTheTmoLyUtyNoGzCteHkaOhq
         FoA/wB4QF6y1BZ6UAvOMWEUz+kFO/WF1r5HYunTYr1zlfHCfpvp0DcR/JgrNaLPpklFi
         U7v1sV5/ANy2b3HbeTFhX8Y9SZeqJwMxWXt0Td0q1jO1Ahx8RWA/nroY5fHzR/gBmaeE
         oqYQ==
X-Gm-Message-State: ACrzQf3CIhc+fDEY8eyuz4yLihVqzOOEg9soMso5rKEpgsFt0mlZkazg
        99+iCzjWNxmHAbjgMCNu3QfkPg==
X-Google-Smtp-Source: AMsMyM7qHohe8t2aLsIgDI8jervh0lNgxUy3saJvw7Yjrle9KJulmdFLIMMRUOI9RkGHuYDYlrh0IQ==
X-Received: by 2002:a05:600c:4313:b0:3cf:894d:1d05 with SMTP id p19-20020a05600c431300b003cf894d1d05mr896047wme.32.1667405659085;
        Wed, 02 Nov 2022 09:14:19 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b4d7:0:6a08:9b26:ab04:7065])
        by smtp.gmail.com with ESMTPSA id m17-20020a5d56d1000000b0022cc6b8df5esm13230923wrw.7.2022.11.02.09.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:14:18 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [RFC 1/6] KVM: arm64: Document PV-lock interface
Date:   Wed,  2 Nov 2022 16:13:35 +0000
Message-Id: <20221102161340.2982090-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221102161340.2982090-1-usama.arif@bytedance.com>
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
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
hypervisor's support for this interface and the location of the shared
memory structures.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 Documentation/virt/kvm/arm/pvlock.rst   | 64 +++++++++++++++++++++++++
 Documentation/virt/kvm/devices/vcpu.rst | 23 +++++++++
 2 files changed, 87 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/pvlock.rst

diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
new file mode 100644
index 000000000000..766aeef50b2d
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pvlock.rst
@@ -0,0 +1,64 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Paravirtualized lock support for arm64
+======================================
+
+KVM/arm64 provides hypervisor service calls for paravirtualized guests to check
+whether a VCPU is currently running or not.
+
+Two new SMCCC compatible hypercalls are defined:
+
+* PV_LOCK_FEATURES:   0xC6000020
+* PV_LOCK_PREEMPTED:  0xC6000021
+
+The existence of the PV_LOCK hypercall should be probed using the SMCCC 1.1
+ARCH_FEATURES mechanism before calling it.
+
+PV_LOCK_FEATURES
+    ============= ========    ==========
+    Function ID:  (uint32)    0xC6000020
+    PV_call_id:   (uint32)    The function to query for support.
+                              Currently only PV_LOCK_PREEMPTED is supported.
+    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
+                              PV-lock feature is supported by the hypervisor.
+    ============= ========    ==========
+
+PV_LOCK_PREEMPTED
+    ============= ========    ==========
+    Function ID:  (uint32)    0xC6000021
+    Return value: (int64)     IPA of the pv lock data structure for this
+                              VCPU. On failure:
+                              NOT_SUPPORTED (-1)
+    ============= ========    ==========
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
+| preempted |      8      |      0      | Indicate if the VCPU that owns  |
+|           |             |             | this struct is running or not.  |
+|           |             |             | Non-zero values mean the VCPU   |
+|           |             |             | has been preempted. Zero means  |
+|           |             |             | the VCPU is not preempted.      |
++-----------+-------------+-------------+---------------------------------+
+
+The preempted field will be updated to 1 by the hypervisor prior to scheduling
+a VCPU. When the VCPU is scheduled out, the preempted field will be updated
+to 0 by the hypervisor.
+
+The structure will be present within a reserved region of the normal memory
+given to the guest. The guest should not attempt to write into this memory.
+There is a structure per VCPU of the guest.
+
+For the user space interface see Documentation/virt/kvm/devices/vcpu.rst
+section "4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL".
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 716aa3edae14..223ac2fe62f0 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -263,3 +263,26 @@ From the destination VMM process:
 
 7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
    respective value derived in the previous step.
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

