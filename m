Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD09A4202F3
	for <lists+kvm@lfdr.de>; Sun,  3 Oct 2021 18:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhJCQsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 12:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231215AbhJCQr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 12:47:59 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 389AC61A38;
        Sun,  3 Oct 2021 16:46:12 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mX4cs-00EUhe-LX; Sun, 03 Oct 2021 17:46:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v2 5/5] hw/arm/virt: Disable highmem devices that don't fit in the PA range
Date:   Sun,  3 Oct 2021 17:46:05 +0100
Message-Id: <20211003164605.3116450-6-maz@kernel.org>
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

Make sure both the highmem PCIe and GICv3 regions are disabled when
they don't fully fit in the PA range.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index a572e0c9d9..756f67b6c8 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1673,6 +1673,9 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
     if (base <= BIT_ULL(pa_bits)) {
         vms->highest_gpa = base -1;
     } else {
+        /* Advertise that we have disabled the highmem devices */
+        vms->highmem_ecam = false;
+        vms->highmem_redists = false;
         vms->highest_gpa = memtop - 1;
     }
 
-- 
2.30.2

