Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7B487A78
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 17:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348298AbiAGQeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 11:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348292AbiAGQeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 11:34:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAACC06173E
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 08:34:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 741D0B8265C
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 16:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DB7C36AE0;
        Fri,  7 Jan 2022 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641573240;
        bh=3L/9tPruGiz7h73xzwH+NCKLF8ym5mrinTHffjc2kFg=;
        h=From:To:Cc:Subject:Date:From;
        b=oVXlzK1D01nQc1pBIq5O6nlDeAJEJg0wp1al2nRGBhEv3ORCuQn3wIimT1tGAu+/J
         /CFHr4knaIHMOyIQGRwyVbMMfXhPqyY6bc3BGL9T6wDTxKNprVHZYDg7WlmYzw7amK
         8Yl6oTRXmtFslym/4o0aFFrEB0vaAJBUaa2mvQk9YCChFjD4YeCGcDNO3bEKplkiXE
         gEMGOApOp/V1Rdhg6Eist8WCmJ63JQKOycQb/CZQr9fcQulfp0BKdTsLCxspLXV+39
         X2tA0CWdiEu9qJoeFtdIzNRWPa+iCnsRZ3VuM55sxNjVBjsOqKX00vGXnwfHhgnjzE
         BuWI1sO0SDoAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n5sBi-00GbiJ-0T; Fri, 07 Jan 2022 16:33:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v4 0/6] target/arm: Reduced-IPA space and highmem fixes
Date:   Fri,  7 Jan 2022 16:33:18 +0000
Message-Id: <20220107163324.2491209-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's another stab at enabling QEMU on systems with pathologically
reduced IPA ranges such as the Apple M1 (previous version at [1]).
Eventually, we're able to run a KVM guest with more than just 3GB of
RAM on a system with a 36bit IPA space, and at most 123 vCPUs.

This also addresses some pathological QEMU behaviours, where the
highmem property is used as a flag allowing exposure of devices that
can't possibly fit in the PA space of the VM, resulting in a guest
failure.

In the end, we generalise the notion of PA space when exposing
individual devices in the expanded memory map, and treat highmem as
another flavour or PA space restriction.

This series does a few things:

- introduce new attributes to control the enabling of the highmem
  GICv3 redistributors and the highmem PCIe MMIO range

- correctly cap the PA range with highmem is off

- generalise the highmem behaviour to any PA range

- disable each highmem device region that doesn't fit in the PA range

- cleanup uses of highmem outside of virt_set_memmap()

This has been tested on an M1-based Mac-mini running Linux v5.16-rc6
with both KVM and TCG.

* From v3 [1]:

  - Introduced highmem_mmio as the MMIO pendant to highmem_ecam after
    Eric made it plain that I was misguided in using highmem_ecam to
    gate the MMIO region.

  - Fixed the way the top of RAM is enforced (using the device memory
    size, rounded up to the nearest GB). I long debated *not* using
    the rounded up version, but finally decided that it would be the
    least surprising, given that each slot is supposed to hold a full
    GB.

  - Now allowing some of the highmem devices to be individually
    enabled if they fit in the PA range. For example, a system with a
    39bit PA range and at most 255GB of RAM can use the highmem redist
    and PCIe ECAM ranges, but not the high PCIe range.

  - Dropped some of Andrew's RBs, as the code significantly changed.

[1] https://lore.kernel.org/r/20211227211642.994461-1-maz@kernel.org

Marc Zyngier (6):
  hw/arm/virt: Add a control for the the highmem PCIe MMIO
  hw/arm/virt: Add a control for the the highmem redistributors
  hw/arm/virt: Honor highmem setting when computing the memory map
  hw/arm/virt: Use the PA range to compute the memory map
  hw/arm/virt: Disable highmem devices that don't fit in the PA range
  hw/arm/virt: Drop superfluous checks against highmem

 hw/arm/virt-acpi-build.c | 10 ++---
 hw/arm/virt.c            | 87 +++++++++++++++++++++++++++++++++++-----
 include/hw/arm/virt.h    |  5 ++-
 3 files changed, 85 insertions(+), 17 deletions(-)

-- 
2.30.2

