Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131BF1ED613
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 20:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgFCSX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 14:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCSX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 14:23:29 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF038C08C5C0
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 11:23:28 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b5so2136631pfp.9
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 11:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o5S6fyUbLIDuPbHNPZR7LOS6R6WKVZw2Eb/ppL2+52M=;
        b=VqtkFJxaARo/j8Dc8tf4Luc3uieZXcJEFPt2wt9DJQHEu+BE5Q5jFJQG1jixUpPTkW
         Y0xQBWMMb7Av2PTuis7de+N3BnpPUZisdjJPKZZZlfw3kB1/Ms+RwlfC56mF949V7D00
         BP2tkqcHhQwHy236D5xKndZam4RhDlEJEuzLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o5S6fyUbLIDuPbHNPZR7LOS6R6WKVZw2Eb/ppL2+52M=;
        b=XxK+xmLNXu9WkSs2urpB3ACN61loGYSHprxcFHkd/UIecjUKv/TBGZmapTcqrrt3Tm
         HMICI7dmLSxGChe7YlepKy21cgB3GfNJbVUhUH2K/iu3xMaXgvA31mO0T55sC4WkFnrL
         gad2nWeEyH57o/WY6kV2MsBv2Q/bStiYbvs/Vn0CxoJvVVuawHoCIeTby7lA+tjzWFTb
         22jAoCBnkQleXttCV52w8O3l8OAQyZW4Em1Ao+2Nt4bJMW6wDuRlpACuc9LijZPqTGAK
         dljW7MfV7zHJwH3B85lh/w60moBifccm6bdlVrE37JzT6cXu/IwkBgtwUlO8UjTJYogD
         OfgA==
X-Gm-Message-State: AOAM530hAd0BulZioTReJLcNuAT6yrVfySB/cTCL63zvkc7RRJf7u6qU
        Cu5D8l/FmVVYzSXrNCb/1UR0Ew==
X-Google-Smtp-Source: ABdhPJx9oziG+zSZdHGK29rbCsZbexUoJXrDCX81CchzaXiRDSaeS4QPXJs1p3lBpdlEADzMRYnb8g==
X-Received: by 2002:a17:90a:2070:: with SMTP id n103mr1312834pjc.109.1591208608330;
        Wed, 03 Jun 2020 11:23:28 -0700 (PDT)
Received: from localhost ([2620:15c:202:200:c921:befc:7379:cdab])
        by smtp.gmail.com with ESMTPSA id x191sm2457788pfd.37.2020.06.03.11.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 11:23:27 -0700 (PDT)
From:   Micah Morton <mortonm@chromium.org>
To:     alex.williamson@redhat.com
Cc:     pbonzini@redhat.com, eric.auger@redhat.com, kvm@vger.kernel.org,
        Micah Morton <mortonm@chromium.org>
Subject: [PATCH] vfio: PoC patch for printing IRQs used by i2c devices
Date:   Wed,  3 Jun 2020 11:23:22 -0700
Message-Id: <20200603182322.196940-1-mortonm@chromium.org>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
In-Reply-To: <CAJ-EccPU8KpU96PM2PtroLjdNVDbvnxwKwWJr2B+RBKuXEr7Vw@mail.gmail.com>
References: <CAJ-EccPU8KpU96PM2PtroLjdNVDbvnxwKwWJr2B+RBKuXEr7Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch accesses the ACPI system from vfio_pci_probe to print out
info if the PCI device being attached to vfio_pci is an i2c adapter with
associated i2c client devices that use platform IRQs. The info printed
out is the IRQ numbers that are associated with the given i2c client
devices. This patch doesn't attempt to forward any additional IRQs into
the guest, but shows how it could be possible.

Signed-off-by: Micah Morton <mortonm@chromium.org>

Change-Id: I5c77d35f246781a4a80703820860631e2c2091cf
---
What do you guys think about having code like this somewhere in
vfio_pci? There would have to be some logic added in vfio_pci to forward
these IRQs when they are found. For reference, below is what is printed
out during vfio_pci_probe on my development machine when I attach some
I2C adapter PCI devices to vfio_pci:

[   48.742699] ACPI i2c client device WCOM50C1:00 uses irq 31
[   53.913295] ACPI i2c client device GOOG0005:00 uses irq 24
[   58.040076] ACPI i2c client device ACPI0C50:00 uses irq 51

Ideally we could add code like this for other bus types (e.g. SPI).

NOTE: developed on v5.4

 drivers/vfio/pci/vfio_pci.c | 158 ++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 02206162eaa9..9ce3f34aa548 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -28,6 +28,10 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 
+#include <linux/acpi.h>
+#include <acpi/actypes.h>
+#include <linux/i2c.h>
+
 #include "vfio_pci_private.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -1289,12 +1293,166 @@ static const struct vfio_device_ops vfio_pci_ops = {
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
 
+
+struct i2c_acpi_lookup {
+	struct i2c_board_info *info;
+	acpi_handle adapter_handle;
+	acpi_handle device_handle;
+	acpi_handle search_handle;
+	int n;
+	int index;
+	u32 speed;
+	u32 min_speed;
+	u32 force_speed;
+};
+
+static const struct acpi_device_id i2c_acpi_ignored_device_ids[] = { 
+        /*  
+         * ACPI video acpi_devices, which are handled by the acpi-video driver
+         * sometimes contain a SERIAL_TYPE_I2C ACPI resource, ignore these.
+         */
+        { ACPI_VIDEO_HID, 0 },
+        {}  
+};
+
+static int i2c_acpi_get_info_for_node(struct acpi_resource *ares, void *data)
+{
+        struct i2c_acpi_lookup *lookup = data;
+        struct i2c_board_info *info = lookup->info;
+        struct acpi_resource_i2c_serialbus *sb;
+        acpi_status status;
+
+        if (info->addr || !i2c_acpi_get_i2c_resource(ares, &sb))
+                return 1;
+
+        if (lookup->index != -1 && lookup->n++ != lookup->index)
+                return 1;
+
+        status = acpi_get_handle(lookup->device_handle,
+                                 sb->resource_source.string_ptr,
+                                 &lookup->adapter_handle);
+        if (ACPI_FAILURE(status))
+                return 1;
+
+        info->addr = sb->slave_address;
+
+        return 1;
+}
+
+static int print_irq_info_if_i2c_slave(struct acpi_device *adev,
+                              struct i2c_acpi_lookup *lookup, acpi_handle adapter)
+{
+        struct i2c_board_info *info = lookup->info;
+        struct list_head resource_list, resource_list2;
+	struct resource_entry *entry;
+        int ret;
+
+        if (acpi_bus_get_status(adev) || !adev->status.present)
+                return -EINVAL;
+
+        if (acpi_match_device_ids(adev, i2c_acpi_ignored_device_ids) == 0)
+                return -ENODEV;
+
+        memset(info, 0, sizeof(*info));
+        lookup->device_handle = acpi_device_handle(adev);
+
+        /* Look up for I2cSerialBus resource */
+        INIT_LIST_HEAD(&resource_list);
+        ret = acpi_dev_get_resources(adev, &resource_list,
+                                     i2c_acpi_get_info_for_node, lookup);
+
+
+	if (ret < 0 || !info->addr) {
+		acpi_dev_free_resource_list(&resource_list);
+                return -EINVAL;
+	}
+
+        if (adapter) {
+                /* The adapter must match the one in I2cSerialBus() connector */
+                if (adapter != lookup->adapter_handle)
+                        return -ENODEV;
+	}
+
+        INIT_LIST_HEAD(&resource_list2);
+	ret = acpi_dev_get_resources(adev, &resource_list2, NULL, NULL);
+	if (ret < 0)
+		return -EINVAL;
+
+        resource_list_for_each_entry(entry, &resource_list2) {
+                if (resource_type(entry->res) == IORESOURCE_IRQ) {
+                        printk(KERN_EMERG "ACPI i2c client device %s uses irq %d\n",
+						dev_name(&adev->dev), entry->res->start);
+                        break;
+                }
+        }
+
+        acpi_dev_free_resource_list(&resource_list2);
+
+        return 0;
+}
+
+static int i2c_acpi_get_info(struct acpi_device *adev,
+                             struct i2c_board_info *info,
+                             acpi_handle adapter,
+                             acpi_handle *adapter_handle)
+{
+        struct i2c_acpi_lookup lookup;
+
+
+        memset(&lookup, 0, sizeof(lookup));
+        lookup.info = info;
+        lookup.index = -1;
+
+        if (acpi_device_enumerated(adev))
+                return -EINVAL;
+
+        return print_irq_info_if_i2c_slave(adev, &lookup, adapter);
+}
+
+static acpi_status process_acpi_node(acpi_handle handle, u32 level,
+                                       void *data, void **return_value)
+{
+        acpi_handle adapter = data;
+        struct acpi_device *adev;
+        struct i2c_board_info info;
+
+        if (acpi_bus_get_device(handle, &adev))
+                return AE_OK;
+
+        if (i2c_acpi_get_info(adev, &info, adapter, NULL))
+                return AE_OK;
+
+        return AE_OK;
+}
+
+#define MAX_SCAN_DEPTH 32
+
+void acpi_print_irqs_if_i2c(acpi_handle handle)
+{
+        acpi_status status;
+
+        status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
+                                     MAX_SCAN_DEPTH,
+                                     process_acpi_node, NULL,
+                                     handle, NULL);
+        if (ACPI_FAILURE(status))
+                printk(KERN_EMERG "failed to enumerate ACPI devices\n");
+}
+
+static void print_irqs_if_i2c_adapter(struct device *dev) {
+	acpi_handle handle = ACPI_HANDLE(dev);
+	acpi_print_irqs_if_i2c(handle);
+}
+
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
 	struct iommu_group *group;
 	int ret;
 
+        if (has_acpi_companion(&pdev->dev))
+		print_irqs_if_i2c_adapter(&pdev->dev);
+
 	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
-- 
2.26.2

