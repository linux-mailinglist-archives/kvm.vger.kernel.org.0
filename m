Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB0E1A8009
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403853AbgDNOnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:43:02 -0400
Received: from foss.arm.com ([217.140.110.172]:57174 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391063AbgDNOkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:40:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6652EC14;
        Tue, 14 Apr 2020 07:40:10 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 784863F73D;
        Tue, 14 Apr 2020 07:40:09 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 11/18] vfio/pci: Don't assume that only even numbered BARs are 64bit
Date:   Tue, 14 Apr 2020 15:39:39 +0100
Message-Id: <20200414143946.1521-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not all devices have the bottom 32 bits of a 64 bit BAR in an even
numbered BAR. For example, on an NVIDIA Quadro P400, BARs 1 and 3 are
64bit. Remove this assumption.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index bbb8469c8d93..1bdc20038411 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -920,8 +920,10 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
 
 	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
 		/* Ignore top half of 64-bit BAR */
-		if (i % 2 && is_64bit)
+		if (is_64bit) {
+			is_64bit = false;
 			continue;
+		}
 
 		ret = vfio_pci_configure_bar(kvm, vdev, i);
 		if (ret)
-- 
2.20.1

