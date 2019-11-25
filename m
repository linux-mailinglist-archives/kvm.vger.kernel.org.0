Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E1E108BC5
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfKYKcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:41 -0500
Received: from foss.arm.com ([217.140.110.172]:47760 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbfKYKck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 556F8328;
        Mon, 25 Nov 2019 02:32:40 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 676423F52E;
        Mon, 25 Nov 2019 02:32:39 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 09/16] arm/pci: Do not use first PCI IO space bytes for devices
Date:   Mon, 25 Nov 2019 10:30:26 +0000
Message-Id: <20191125103033.22694-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Linux has this convention that the lower 0x1000 bytes of the IO space
should not be used. (cf PCIBIOS_MIN_IO).

Just allocate those bytes to prevent future allocation assigning it to
devices.

Cc: julien.thierry.kdev@gmail.com
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arm/pci.c b/arm/pci.c
index 1c0949a22408..4e6467357ce8 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -37,6 +37,9 @@ void pci__arm_init(struct kvm *kvm)
 
 	/* Make PCI port allocation start at a properly aligned address */
 	pci_get_io_port_block(align_pad);
+
+	/* Convention, don't allocate first 0x1000 bytes of PCI IO */
+	pci_get_io_port_block(0x1000);
 }
 
 void pci__generate_fdt_nodes(void *fdt)
-- 
2.20.1

