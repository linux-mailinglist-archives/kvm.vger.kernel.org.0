Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877AD4097B8
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhIMPqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:46:14 -0400
Received: from foss.arm.com ([217.140.110.172]:33200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343504AbhIMPoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:44:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D14281063;
        Mon, 13 Sep 2021 08:42:55 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C93243F719;
        Mon, 13 Sep 2021 08:42:54 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v1 kvmtool 3/7] pci: Fix pci_dev_* print macros
Date:   Mon, 13 Sep 2021 16:44:09 +0100
Message-Id: <20210913154413.14322-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913154413.14322-1-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Evaluate the "pci_hdr" argument before attempting to deference a field.
This fixes cryptic errors like this one, which came about during a
debugging session:

vfio/pci.c: In function 'vfio_pci_bar_activate':
include/kvm/pci.h:18:40: error: invalid type argument of '->' (have 'struct pci_device_header')
  pr_warning("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
                                        ^~
vfio/pci.c:482:3: note: in expansion of macro 'pci_dev_warn'
   pci_dev_warn(&vdev->pci.hdr, "%s: BAR4\n", __func__);

This is caused by the operator precedence rules in C, where pointer
deference via "->" has a higher precedence than taking the address with the
ampersand symbol. When the macro is substituted, it becomes
&vdev->pci.hdr->vendor_id and it dereferences vdev->pci.hdr, which is not a
pointer, instead of dereferencing &vdev->pci.hdr, which is a pointer, and
quite likely what the author intended.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/pci.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index 0f2d5bb..d6eb398 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -13,15 +13,15 @@
 #include "kvm/kvm-arch.h"
 
 #define pci_dev_err(pci_hdr, fmt, ...) \
-	pr_err("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+	pr_err("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
 #define pci_dev_warn(pci_hdr, fmt, ...) \
-	pr_warning("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+	pr_warning("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
 #define pci_dev_info(pci_hdr, fmt, ...) \
-	pr_info("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+	pr_info("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
 #define pci_dev_dbg(pci_hdr, fmt, ...) \
-	pr_debug("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+	pr_debug("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
 #define pci_dev_die(pci_hdr, fmt, ...) \
-	die("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+	die("[%04x:%04x] " fmt, (pci_hdr)->vendor_id, (pci_hdr)->device_id, ##__VA_ARGS__)
 
 /*
  * PCI Configuration Mechanism #1 I/O ports. See Section 3.7.4.1.
-- 
2.20.1

