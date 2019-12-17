Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11170122DA8
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 14:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfLQN4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 08:56:38 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8135 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728593AbfLQN4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 08:56:37 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 67B59EAF1F2CC9E98F81;
        Tue, 17 Dec 2019 21:56:30 +0800 (CST)
Received: from DESKTOP-1NISPDV.china.huawei.com (10.173.221.248) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 17 Dec 2019 21:56:22 +0800
From:   <yezengruan@huawei.com>
To:     <yezengruan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <maz@kernel.org>, <james.morse@arm.com>, <linux@armlinux.org.uk>,
        <suzuki.poulose@arm.com>, <julien.thierry.kdev@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <will@kernel.org>, <steven.price@arm.com>,
        <daniel.lezcano@linaro.org>
Subject: [PATCH 1/5] KVM: arm64: Document PV-lock interface
Date:   Tue, 17 Dec 2019 21:55:45 +0800
Message-ID: <20191217135549.3240-2-yezengruan@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20191217135549.3240-1-yezengruan@huawei.com>
References: <20191217135549.3240-1-yezengruan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.173.221.248]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zengruan Ye <yezengruan@huawei.com>

Introduce a paravirtualization interface for KVM/arm64 to obtain the vcpu
is currently running or not.

A hypercall interface is provided for the guest to interrogate the
hypervisor's support for this interface and the location of the shared
memory structures.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
---
 Documentation/virt/kvm/arm/pvlock.rst | 31 +++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/pvlock.rst

diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
new file mode 100644
index 000000000000..eec0c36edf17
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pvlock.rst
@@ -0,0 +1,31 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Paravirtualized lock support for arm64
+======================================
+
+KVM/arm64 provids some hypervisor service calls to support a paravirtualized
+guest obtaining the vcpu is currently running or not.
+
+Two new SMCCC compatible hypercalls are defined:
+
+* PV_LOCK_FEATURES:   0xC5000040
+* PV_LOCK_PREEMPTED:  0xC5000041
+
+The existence of the PV_LOCK hypercall should be probed using the SMCCC 1.1
+ARCH_FEATURES mechanism before calling it.
+
+PV_LOCK_FEATURES
+    ============= ========    ==========
+    Function ID:  (uint32)    0xC5000040
+    PV_call_id:   (uint32)    The function to query for support.
+    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
+                              PV-lock feature is supported by the hypervisor.
+    ============= ========    ==========
+
+PV_LOCK_PREEMPTED
+    ============= ========    ==========
+    Function ID:  (uint32)    0xC5000041
+    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the IPA of
+                              this vcpu's pv data structure is configured by
+                              the hypervisor.
+    ============= ========    ==========
-- 
2.19.1


