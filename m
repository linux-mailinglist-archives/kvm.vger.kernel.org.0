Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C7A3CB257
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhGPGWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbhGPGWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 02:22:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E19C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=sygsfRFSOk2LlovSizKUNHUqhO0rzTrijIvq7CZ/O0Y=; b=Y4AO3a7NAwcP2J7xizpeyoehdR
        bXS1GzWEFEFs0kiy2Y8Pw0Py13TECeIZLSgUse1Te+QURRBDAjV2AIi5B2Mo0q4unZSLtnwg/oeFn
        AlkDQxI2FiktyzFSC3ycfD6A5XxqDG5I864sfKhGlCvLelJQeaLza0LSrD2BDAvCDtbiy2Of8ZBTt
        oFtRNoZQnGu1vnH0hel8zW+XZRt/RtyQ8XdeJiaXLMvqJTBm6aGhyV6O4AhgyQ5IxjRqzms9wHZKm
        47KzLsAm8W1I/hSKBu0dKaUOz/WPF6m7Dv3T35x3BnBjqhl8l9QKWk6kEgZWWfBREDLBWzpsQFNny
        zIhgoD4g==;
Received: from [2001:4bb8:184:8b7c:6b57:320d:f068:19c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4HAF-004CtO-L7; Fri, 16 Jul 2021 06:17:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        kvm@vger.kernel.org
Subject: [PATCH 2/7] vgaarb: remove vga_conflicts
Date:   Fri, 16 Jul 2021 08:16:29 +0200
Message-Id: <20210716061634.2446357-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210716061634.2446357-1-hch@lst.de>
References: <20210716061634.2446357-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vga_conflicts only has a single caller and none of the arch overrides
mentioned in the comment.  Just remove it and the thus dead check in the
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/vga/vgaarb.c |  6 ------
 include/linux/vgaarb.h   | 12 ------------
 2 files changed, 18 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 949fde433ea2..fccc7ef5153a 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -284,12 +284,6 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 		if (vgadev == conflict)
 			continue;
 
-		/* Check if the architecture allows a conflict between those
-		 * 2 devices or if they are on separate domains
-		 */
-		if (!vga_conflicts(vgadev->pdev, conflict->pdev))
-			continue;
-
 		/* We have a possible conflict. before we go further, we must
 		 * check if we sit on the same bus as the conflicting device.
 		 * if we don't, then we must tie both IO and MEM resources
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 26ec8a057d2a..ca5160218538 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -122,18 +122,6 @@ static inline void vga_set_default_device(struct pci_dev *pdev) { }
 static inline int vga_remove_vgacon(struct pci_dev *pdev) { return 0; }
 #endif
 
-/*
- * Architectures should define this if they have several
- * independent PCI domains that can afford concurrent VGA
- * decoding
- */
-#ifndef __ARCH_HAS_VGA_CONFLICT
-static inline int vga_conflicts(struct pci_dev *p1, struct pci_dev *p2)
-{
-       return 1;
-}
-#endif
-
 #if defined(CONFIG_VGA_ARB)
 int vga_client_register(struct pci_dev *pdev, void *cookie,
 			void (*irq_set_state)(void *cookie, bool state),
-- 
2.30.2

