Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E873F4018
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhHVOpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhHVOpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:45:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F14F61247;
        Sun, 22 Aug 2021 14:45:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mHoiZ-006VES-Ky; Sun, 22 Aug 2021 15:44:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH 1/3] hw/arm/virt: KVM: Probe for KVM_CAP_ARM_VM_IPA_SIZE when creating scratch VM
Date:   Sun, 22 Aug 2021 15:44:39 +0100
Message-Id: <20210822144441.1290891-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210822144441.1290891-1-maz@kernel.org>
References: <20210822144441.1290891-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although we probe for the IPA limits imposed by KVM (and the hardware)
when computing the memory map, we still use the old style '0' when
creating a scratch VM in kvm_arm_create_scratch_host_vcpu().

On systems that are severely IPA challenged (such as the Apple M1),
this results in a failure as KVM cannot use the default 40bit that
'0' represents.

Instead, probe for the extension and use the reported IPA limit
if available.

Cc: Andrew Jones <drjones@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 target/arm/kvm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index d8381ba224..cc3371a99b 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -70,12 +70,17 @@ bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
                                       struct kvm_vcpu_init *init)
 {
     int ret = 0, kvmfd = -1, vmfd = -1, cpufd = -1;
+    int max_vm_pa_size;
 
     kvmfd = qemu_open_old("/dev/kvm", O_RDWR);
     if (kvmfd < 0) {
         goto err;
     }
-    vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);
+    max_vm_pa_size = ioctl(kvmfd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
+    if (max_vm_pa_size < 0) {
+        max_vm_pa_size = 0;
+    }
+    vmfd = ioctl(kvmfd, KVM_CREATE_VM, max_vm_pa_size);
     if (vmfd < 0) {
         goto err;
     }
-- 
2.30.2

