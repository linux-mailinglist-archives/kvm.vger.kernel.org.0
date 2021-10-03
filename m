Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381064202EC
	for <lists+kvm@lfdr.de>; Sun,  3 Oct 2021 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJCQsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 12:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231175AbhJCQr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 12:47:59 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1BA161A54;
        Sun,  3 Oct 2021 16:46:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mX4cs-00EUhe-6h; Sun, 03 Oct 2021 17:46:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v2 3/5] hw/arm/virt: Honor highmem setting when computing the memory map
Date:   Sun,  3 Oct 2021 17:46:03 +0100
Message-Id: <20211003164605.3116450-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211003164605.3116450-1-maz@kernel.org>
References: <20211003164605.3116450-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even when the VM is configured with highmem=off, the highest_gpa
field includes devices that are above the 4GiB limit.
Similarily, nothing seem to check that the memory is within
the limit set by the highmem=off option.

This leads to failures in virt_kvm_type() on systems that have
a crippled IPA range, as the reported IPA space is larger than
what it should be.

Instead, honor the user-specified limit to only use the devices
at the lowest end of the spectrum, and fail if we have memory
crossing the 4GiB limit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index bcf58f677d..9d2abdbd5f 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1628,6 +1628,11 @@ static void virt_set_memmap(VirtMachineState *vms)
         exit(EXIT_FAILURE);
     }
 
+    if (!vms->highmem &&
+        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
+        error_report("highmem=off, but memory crosses the 4GiB limit\n");
+        exit(EXIT_FAILURE);
+    }
     /*
      * We compute the base of the high IO region depending on the
      * amount of initial and device memory. The device memory start/size
@@ -1657,7 +1662,9 @@ static void virt_set_memmap(VirtMachineState *vms)
         vms->memmap[i].size = size;
         base += size;
     }
-    vms->highest_gpa = base - 1;
+    vms->highest_gpa = (vms->highmem ?
+                        base :
+                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
     if (device_memory_size > 0) {
         ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
         ms->device_memory->base = device_memory_base;
-- 
2.30.2

