Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F04804D1
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 22:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhL0VRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 16:17:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59206 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhL0VRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 16:17:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2D1DB81158
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 21:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5553C36AED;
        Mon, 27 Dec 2021 21:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640639825;
        bh=IHY2+6hBS2o9nbH7P+X3mza23XiKdsCbkiZ64E2sCow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ll0djBguy52iSPcnsf8MC/e8sqKmI9zoHgkxDQf+dlCiMB0RmCRRHYwoaAWJ5tmnO
         GYR+/H+tZpPDwl2chLHs7n3O7m5FfCSZV+oq88b3hT/nVVMVZgPtNNWwS/Kz15L0jZ
         yQZHAPhn8XYLlR7OA7JNXqta2STrYQKHUsFU7aStqCI9ZXWqg/d1uxmGPdnRdHug5D
         DWJDt9mObZMaNKCP3uCK4G9KqKdqdShIh2YBe17yoyAA8XuZDBRYGAevDZnlOvlWX7
         3WZUyoLbRzh5LQjm8e0bkSagPYwinUH2MB97KW9EKe6lNzNsoceQJ/CfqGuKO2kT5h
         125hjUH8pRCYA==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1xMd-00Ed4b-OD; Mon, 27 Dec 2021 21:17:03 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing the memory map
Date:   Mon, 27 Dec 2021 21:16:40 +0000
Message-Id: <20211227211642.994461-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227211642.994461-1-maz@kernel.org>
References: <20211227211642.994461-1-maz@kernel.org>
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

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 8b600d82c1..84dd3b36fb 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1678,6 +1678,11 @@ static void virt_set_memmap(VirtMachineState *vms)
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
@@ -1707,7 +1712,9 @@ static void virt_set_memmap(VirtMachineState *vms)
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

