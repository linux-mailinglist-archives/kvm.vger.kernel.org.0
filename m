Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F284146994
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgAWNsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:36 -0500
Received: from foss.arm.com ([217.140.110.172]:39740 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbgAWNsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E970CFEC;
        Thu, 23 Jan 2020 05:48:34 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DE7E23F68E;
        Thu, 23 Jan 2020 05:48:33 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 12/30] vfio/pci: Don't assume that only even numbered BARs are 64bit
Date:   Thu, 23 Jan 2020 13:47:47 +0000
Message-Id: <20200123134805.1993-13-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not all devices have the bottom 32 bits of a 64 bit BAR in an even
numbered BAR. For example, on an NVIDIA Quadro P400, BARs 1 and 3 are
64bit. Remove this assumption.

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

