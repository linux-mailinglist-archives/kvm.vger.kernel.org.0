Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598574804D3
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 22:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhL0VRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 16:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbhL0VRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 16:17:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA403C06173E
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 13:17:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92B5BB81154
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 21:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229E9C36AEA;
        Mon, 27 Dec 2021 21:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640639825;
        bh=iVCmmeeO13JoomogqvcGNrgq4nDJ+FZNDPXN9KsDdHw=;
        h=From:To:Cc:Subject:Date:From;
        b=alQ3nfWkYPPngjyPmoIaTwKsZk/INt338gLXMlUHNVbYetsfpmNrq1bZH1zoJ/Z95
         7/2GRDPAt8PSk1PRuLI0u0m2KXvTkgguVSCosihvZ83HpC2838ZPwe1zI7OfdYKvvA
         VuBdzPLkIaE392EqljeOdh5XDP6eNNa3Po2Sey1NwnpUMN2woMYBr1HzVX0sDNKgIu
         gw1GT8V8eDlzppzrllvlDAjWMXdqqJ1Et5K1MuDdPBT424Wo83pJkEu8TK2O75oXk6
         A+EMBHnhRNgerydZDa+85HmLuK3AZgpqvpBtFoSQPQdtGOPKbrPp5l+WWYLhHnHXUZ
         wHFKEuIdyKERw==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1xMd-00Ed4b-6N; Mon, 27 Dec 2021 21:17:03 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: [PATCH v3 0/5] target/arm: Reduced-IPA space and highmem=off fixes
Date:   Mon, 27 Dec 2021 21:16:37 +0000
Message-Id: <20211227211642.994461-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's another stab at enabling QEMU on systems with pathologically
reduced IPA ranges such as the Apple M1 (previous version at [1]).
Eventually, we're able to run a KVM guest with more than just 3GB of
RAM on a system with a 36bit IPA space, and at most 123 vCPUs.

This series does a few things:
- decouple the enabling of the highmem PCIe region from the highmem
  attribute
- introduce a new attribute to control the enabling of the highmem
  GICv3 redistributors
- correctly cap the PA range with highmem is off
- generalise the highmem behaviour to any PA range
- disable both highmem PCIe and GICv3 RDs when they are outside of the
  PA range

This has been tested on an M1-based Mac-mini running Linux v5.16-rc6
with both KVM and TCG.

* From v2:
  - Fixed checking of the maximum memory against the IPA space
  - Fixed TCG memory map creation
  - Rebased on top of QEMU's 89f3bfa326
  - Collected Andrew's RBs, with thanks

[1] https://lore.kernel.org/r/20211003164605.3116450-1-maz@kernel.org

Marc Zyngier (5):
  hw/arm/virt: Key enablement of highmem PCIe on highmem_ecam
  hw/arm/virt: Add a control for the the highmem redistributors
  hw/arm/virt: Honor highmem setting when computing the memory map
  hw/arm/virt: Use the PA range to compute the memory map
  hw/arm/virt: Disable highmem devices that don't fit in the PA range

 hw/arm/virt-acpi-build.c | 12 +++----
 hw/arm/virt.c            | 67 ++++++++++++++++++++++++++++++++++------
 include/hw/arm/virt.h    |  4 ++-
 3 files changed, 67 insertions(+), 16 deletions(-)

-- 
2.30.2

