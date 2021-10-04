Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFFD4215BD
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbhJDR7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235765AbhJDR66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:58:58 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6EDE61269;
        Mon,  4 Oct 2021 17:57:09 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5G-00EhBv-MO; Mon, 04 Oct 2021 18:49:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 10/16] KVM: arm64: Add some documentation for the MMIO guard feature
Date:   Mon,  4 Oct 2021 18:48:43 +0100
Message-Id: <20211004174849.2831548-11-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com, tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document the hypercalls user for the MMIO guard infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/arm/index.rst      |  1 +
 Documentation/virt/kvm/arm/mmio-guard.rst | 74 +++++++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst

diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 78a9b670aafe..e77a0ee2e2d4 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -11,3 +11,4 @@ ARM
    psci
    pvtime
    ptp_kvm
+   mmio-guard
diff --git a/Documentation/virt/kvm/arm/mmio-guard.rst b/Documentation/virt/kvm/arm/mmio-guard.rst
new file mode 100644
index 000000000000..8b3c852c5d92
--- /dev/null
+++ b/Documentation/virt/kvm/arm/mmio-guard.rst
@@ -0,0 +1,74 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+KVM MMIO guard
+==============
+
+KVM implements device emulation by handling translation faults to any
+IPA range that is not contained in a memory slot. Such a translation
+fault is in most cases passed on to userspace (or in rare cases to the
+host kernel) with the address, size and possibly data of the access
+for emulation.
+
+Should the guest exit with an address that is not one that corresponds
+to an emulatable device, userspace may take measures that are not the
+most graceful as far as the guest is concerned (such as terminating it
+or delivering a fatal exception).
+
+There is also an element of trust: by forwarding the request to
+userspace, the kernel assumes that the guest trusts userspace to do
+the right thing.
+
+The KVM MMIO guard offers a way to mitigate this last point: a guest
+can request that only certain regions of the IPA space are valid as
+MMIO. Only these regions will be handled as an MMIO, and any other
+will result in an exception being delivered to the guest.
+
+This relies on a set of hypercalls defined in the KVM-specific range,
+using the HVC64 calling convention.
+
+* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO
+
+    ==============    ========    ================================
+    Function ID:      (uint32)    0xC6000002
+    Arguments:        none
+    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
+                      (uint64)    Protection Granule (PG) size in
+                                  bytes (r0)
+    ==============    ========    ================================
+
+* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL
+
+    ==============    ========    ==============================
+    Function ID:      (uint32)    0xC6000003
+    Arguments:        none
+    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
+                                  RET_SUCCESS(0) (r0)
+    ==============    ========    ==============================
+
+* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP
+
+    ==============    ========    ====================================
+    Function ID:      (uint32)    0xC6000004
+    Arguments:        (uint64)    The base of the PG-sized IPA range
+                                  that is allowed to be accessed as
+                                  MMIO. Must be aligned to the PG size
+                                  (r1)
+                      (uint64)    Index in the MAIR_EL1 register
+		                  providing the memory attribute that
+				  is used by the guest (r2)
+    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
+                                  RET_SUCCESS(0) (r0)
+    ==============    ========    ====================================
+
+* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP
+
+    ==============    ========    ======================================
+    Function ID:      (uint32)    0xC6000005
+    Arguments:        (uint64)    PG-sized IPA range aligned to the PG
+                                  size which has been previously mapped.
+                                  Must be aligned to the PG size and
+                                  have been previously mapped (r1)
+    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
+                                  RET_SUCCESS(0) (r0)
+    ==============    ========    ======================================
-- 
2.30.2

