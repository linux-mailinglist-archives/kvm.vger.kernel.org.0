Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530E667F792
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 12:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjA1Lb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 06:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjA1Lb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 06:31:58 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DAA222E9
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 03:31:57 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z31so4887400pfw.4
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 03:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nHf385uSwyVKlquW6oI4aHngThobcmKynea2Qy6puhQ=;
        b=bloMt3hbhGHcdLX8xK3ZePop+8JgMwpLaiComx+GMA3RcuPvQwNRKtdvX0lauD3Lwq
         xKoUwWF7biKIy2qLa2SAEo46LUF5kllZh/WtwvG+JKQSl//6VhA7BeGAPPa3XF8Kpf3H
         1+95FOWdVu8dJ59cyM10wDdVL88dS/wZkdn9zJW7l3aVEIdvJLDab1pr+Ve2XcGXRu4r
         /R4lJDMwaoluYzWez+JQmw92/lJFtbos2spYULAlz7E18hSy5yNw4q+RP/xTjhdltwtb
         xkUH60zV1kVS0AP0LQ3fn/LLfvxo0yd0UEqwvFJGXteUcQHbC1HtGLtn/IObesfyLMkZ
         Cv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nHf385uSwyVKlquW6oI4aHngThobcmKynea2Qy6puhQ=;
        b=19przDlcLX1qBtHFG+B7/oQdNGvHk8SSib48GbSpid6QJcjSu2ir2CTC6V5ay+Z37e
         V8zcGQoGrMrT+FlXC5inH8SwI/zjPQbDXYXnDbsTsIahnjlXrEB1bimVb7GpX/nSffJW
         memp5AJfvlYaY8FdGUwqSHVRjlReQhIkPePAIGEt/7k51ybKGyx1LzNJ6lgJc+KoB/rE
         VhGg5fddc9zaAk+b/d5iTRjscwp5CX+WFqFCenjmpus+GP7jlyUf4sM8n1jd1gkdgz94
         o8wLwU+/VzjFs4r5U63paEN1Bf1v+aLNn05qmIGquGVwP2c4O2IRC5LmhQhnzFloBm41
         aeKA==
X-Gm-Message-State: AO0yUKUu6nv5Gr2xi6W/txGO3oc4Etj7e9+JbsDoWf4ouq/6E4YLvh54
        Qbvo+vqVxQ+NNnI42QOXNzzax3tJzVM=
X-Google-Smtp-Source: AK7set/eV3XbjW6n1pYLz5dSqAsorywMR/qJSf9zd3hCn4K3ahNFR+HJTcR8vi+uOiR9bEQM/FkP1A==
X-Received: by 2002:a05:6a00:420f:b0:590:7623:9c6f with SMTP id cd15-20020a056a00420f00b0059076239c6fmr1604635pfb.34.1674905516400;
        Sat, 28 Jan 2023 03:31:56 -0800 (PST)
Received: from localhost.localdomain ([108.61.217.100])
        by smtp.gmail.com with ESMTPSA id x27-20020aa793bb000000b0058bb2f12080sm4149733pff.48.2023.01.28.03.31.54
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 03:31:55 -0800 (PST)
From:   Dongli Si <sidongli1997@gmail.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvmtool 1/1] vfio/pci: Support NVM Express device passthrough
Date:   Sat, 28 Jan 2023 15:35:51 +0800
Message-Id: <20230128073551.47527-1-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dongli Si <sidongli1997@gmail.com>

When passthrough nvme SSD, the guest kernel will report the error:

[   18.339460] nvme nvme0: failed to register the CMB

This is because the mmio data of region 0 of the nvme device is
not mapped, causing the nvme driver to read the wrong cmb size.

Nvme devices have only one region, we need to setup the mmio data
and msix table to this region, and prevent them from overlay.

Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 include/kvm/vfio.h |  1 +
 vfio/pci.c         | 33 +++++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 764ab9b..c30a0d3 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -43,6 +43,7 @@ struct vfio_pci_msi_entry {
 struct vfio_pci_msix_table {
 	size_t				size;
 	unsigned int			bar;
+	u32				bar_offset; /* in the shared BAR */
 	u32				guest_phys_addr;
 };
 
diff --git a/vfio/pci.c b/vfio/pci.c
index 78f5ca5..f38c0b5 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -497,10 +497,31 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
 		region->guest_phys_addr = bar_addr;
 
 	if (has_msix && (u32)bar_num == table->bar) {
-		table->guest_phys_addr = region->guest_phys_addr;
+		table->guest_phys_addr = region->guest_phys_addr + table->bar_offset;
 		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
 					 table->size, false,
 					 vfio_pci_msix_table_access, pdev);
+
+		/*
+		 * This is to support nvme devices, because the msix table
+		 * shares a region with the mmio data, we need to avoid overlay
+		 * the memory of the msix table during the vfio_map_region.
+		 *
+		 * Here let the end address of the vfio_map_region mapped memory
+		 * not exceed the start address of the msix table. In theory,
+		 * we should also map the memory between the end address of the
+		 * msix table to the end address of the region, but the linux
+		 * nvme driver does not use the latter.
+		 *
+		 * Because the linux nvme driver does not use pba, so skip the
+		 * pba simulation directly.
+		 */
+		if (pdev->hdr.class[0] == 2 && pdev->hdr.class[1] == 8
+		    && pdev->hdr.class[2] == 1) {
+			region->info.size = table->bar_offset;
+			goto map;
+		}
+
 		/*
 		 * The MSIX table and the PBA structure can share the same BAR,
 		 * but for convenience we register different regions for mmio
@@ -522,6 +543,7 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
 		goto out;
 	}
 
+map:
 	ret = vfio_map_region(kvm, vdev, region);
 out:
 	return ret;
@@ -548,6 +570,12 @@ static int vfio_pci_bar_deactivate(struct kvm *kvm,
 		success = kvm__deregister_mmio(kvm, table->guest_phys_addr);
 		/* kvm__deregister_mmio fails when the region is not found. */
 		ret = (success ? 0 : -ENOENT);
+
+		/* See vfio_pci_bar_activate(). */
+		if (pdev->hdr.class[0] == 2 && pdev->hdr.class[1] == 8
+		    && pdev->hdr.class[2] == 1)
+			goto unmap;
+
 		/* See vfio_pci_bar_activate(). */
 		if (ret < 0 || table->bar!= pba->bar)
 			goto out;
@@ -559,6 +587,7 @@ static int vfio_pci_bar_deactivate(struct kvm *kvm,
 		goto out;
 	}
 
+unmap:
 	vfio_unmap_region(kvm, region);
 	ret = 0;
 
@@ -832,7 +861,6 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 					   pba_bar_offset;
 
 		/* Tidy up the capability */
-		msix->table_offset &= PCI_MSIX_TABLE_BIR;
 		if (pdev->msix_table.bar == pdev->msix_pba.bar) {
 			/* Keep the same offset as the MSIX cap. */
 			pdev->msix_pba.bar_offset = pba_bar_offset;
@@ -907,6 +935,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 	struct vfio_region_info info;
 
 	table->bar = msix->table_offset & PCI_MSIX_TABLE_BIR;
+	table->bar_offset = msix->table_offset & PCI_MSIX_TABLE_OFFSET;
 	pba->bar = msix->pba_offset & PCI_MSIX_TABLE_BIR;
 
 	nr_entries = (msix->ctrl & PCI_MSIX_FLAGS_QSIZE) + 1;
-- 
2.37.3

