Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852DD4804CC
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 22:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhL0VRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 16:17:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48266 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbhL0VRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 16:17:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 946FF61173
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 21:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099C7C36AEF;
        Mon, 27 Dec 2021 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640639826;
        bh=8jnTIlm8Zob2Jvux6Qz42yjEvf+iD+5kMVUVUXnj1ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q56PjvJIBDPFg9k+R/s7jSrr+hm/vcoXAPHyqveK2tK+tOZF4My4oU+D3fGM2JOxU
         jUyQuacheThXBYwn3eKWIod4ntDY14Wqy54ieL8EK13vzrkXe9cxeVE+3iqJ6wlF+P
         MCr6gHk23XNFjs9wBL2Dv4S3Q3SEivjB8rhtlQDulEstMsWTBCbMLP2ioAn+KVO/M2
         MYkOkzZD9ErsRWPfHGTPf8XcjoN/ogqYYUn/1x5TC0ekcNH/+6pPNrfl7X1dfCkS5o
         pDjuRmdzJpo27+OhxuYyYIFX/QTh+2+A5kVU+c+xJvX3CY8acZwo3iMSStu7WlhKgZ
         zPRSTJhcPlu0Q==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1xMe-00Ed4b-4O; Mon, 27 Dec 2021 21:17:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v3 5/5] hw/arm/virt: Disable highmem devices that don't fit in the PA range
Date:   Mon, 27 Dec 2021 21:16:42 +0000
Message-Id: <20211227211642.994461-6-maz@kernel.org>
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

Make sure both the highmem PCIe and GICv3 regions are disabled when
they don't fully fit in the PA range.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 212079e7a6..18e615070f 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1723,6 +1723,9 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
     if (base <= BIT_ULL(pa_bits)) {
         vms->highest_gpa = base - 1;
     } else {
+        /* Advertise that we have disabled the highmem devices */
+        vms->highmem_ecam = false;
+        vms->highmem_redists = false;
         vms->highest_gpa = memtop - 1;
     }
 
-- 
2.30.2

