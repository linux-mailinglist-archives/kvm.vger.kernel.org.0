Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122CA3CB263
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhGPGY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhGPGY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 02:24:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F711C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aSVhkxQ4oZroaS//zkndjisEcrFxS9kKgiUt3PZVNe8=; b=Q4U9970CPbVXAIeJ6cHePLZPfQ
        GTuuZa0Gg/5LRptQ+TwUQSKqatmLUVS2udxmulOOiu0kz20ecxvg25NURwP89Ay4hFxiE6dy84wCJ
        0Dn8I5R4v7ruZOegkbnxejDmjX53UFiQs3Y3tXytEDbXyUFAxT6wKYWq1FwfFVQYxDRSpFx8Rcxit
        cczj6lvyajlwh+ugYEbuTCBh9uid1zqfkDNGLBiaYfEeN+b3kvr13DorMmUxLgUWOE4HBG3AesDnQ
        AAPQp13tSkvbm8frYYNpUgSh+CrmOOuRCycpiBM6R25r5hFolqrqyWanUFSAtANufxrEcmerJn/Yy
        nQblM3uw==;
Received: from [2001:4bb8:184:8b7c:6b57:320d:f068:19c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4HBc-004CyC-Gy; Fri, 16 Jul 2021 06:19:17 +0000
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
Subject: [PATCH 4/7] vgaarb: cleanup vgaarb.h
Date:   Fri, 16 Jul 2021 08:16:31 +0200
Message-Id: <20210716061634.2446357-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210716061634.2446357-1-hch@lst.de>
References: <20210716061634.2446357-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Merge the different CONFIG_VGA_ARB ifdef blocks, remove superflous
externs, and regularize the stubs for !CONFIG_VGA_ARB.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/vgaarb.h | 90 ++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 48 deletions(-)

diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index fdce9007d57e..05171fc7e26a 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -33,6 +33,8 @@
 
 #include <video/vga.h>
 
+struct pci_dev;
+
 /* Legacy VGA regions */
 #define VGA_RSRC_NONE	       0x00
 #define VGA_RSRC_LEGACY_IO     0x01
@@ -42,23 +44,47 @@
 #define VGA_RSRC_NORMAL_IO     0x04
 #define VGA_RSRC_NORMAL_MEM    0x08
 
-struct pci_dev;
-
-/* For use by clients */
-
-#if defined(CONFIG_VGA_ARB)
-extern void vga_set_legacy_decoding(struct pci_dev *pdev,
-				    unsigned int decodes);
-#else
+#ifdef CONFIG_VGA_ARB
+void vga_set_legacy_decoding(struct pci_dev *pdev, unsigned int decodes);
+int vga_get(struct pci_dev *pdev, unsigned int rsrc, int interruptible);
+void vga_put(struct pci_dev *pdev, unsigned int rsrc);
+struct pci_dev *vga_default_device(void);
+void vga_set_default_device(struct pci_dev *pdev);
+int vga_remove_vgacon(struct pci_dev *pdev);
+int vga_client_register(struct pci_dev *pdev, void *cookie,
+			void (*irq_set_state)(void *cookie, bool state),
+			unsigned int (*set_vga_decode)(void *cookie, bool state));
+#else /* CONFIG_VGA_ARB */
 static inline void vga_set_legacy_decoding(struct pci_dev *pdev,
-					   unsigned int decodes) { };
-#endif
-
-#if defined(CONFIG_VGA_ARB)
-extern int vga_get(struct pci_dev *pdev, unsigned int rsrc, int interruptible);
-#else
-static inline int vga_get(struct pci_dev *pdev, unsigned int rsrc, int interruptible) { return 0; }
-#endif
+		unsigned int decodes)
+{
+};
+static inline int vga_get(struct pci_dev *pdev, unsigned int rsrc,
+		int interruptible)
+{
+	return 0;
+}
+static inline void vga_put(struct pci_dev *pdev, unsigned int rsrc)
+{
+}
+static inline struct pci_dev *vga_default_device(void)
+{
+	return NULL;
+}
+static inline void vga_set_default_device(struct pci_dev *pdev)
+{
+}
+static inline int vga_remove_vgacon(struct pci_dev *pdev)
+{
+	return 0;
+}
+static inline int vga_client_register(struct pci_dev *pdev, void *cookie,
+				      void (*irq_set_state)(void *cookie, bool state),
+				      unsigned int (*set_vga_decode)(void *cookie, bool state))
+{
+	return 0;
+}
+#endif /* CONFIG_VGA_ARB */
 
 /**
  * vga_get_interruptible
@@ -90,36 +116,4 @@ static inline int vga_get_uninterruptible(struct pci_dev *pdev,
        return vga_get(pdev, rsrc, 0);
 }
 
-#if defined(CONFIG_VGA_ARB)
-extern void vga_put(struct pci_dev *pdev, unsigned int rsrc);
-#else
-static inline void vga_put(struct pci_dev *pdev, unsigned int rsrc)
-{
-}
-#endif
-
-
-#ifdef CONFIG_VGA_ARB
-extern struct pci_dev *vga_default_device(void);
-extern void vga_set_default_device(struct pci_dev *pdev);
-extern int vga_remove_vgacon(struct pci_dev *pdev);
-#else
-static inline struct pci_dev *vga_default_device(void) { return NULL; }
-static inline void vga_set_default_device(struct pci_dev *pdev) { }
-static inline int vga_remove_vgacon(struct pci_dev *pdev) { return 0; }
-#endif
-
-#if defined(CONFIG_VGA_ARB)
-int vga_client_register(struct pci_dev *pdev, void *cookie,
-			void (*irq_set_state)(void *cookie, bool state),
-			unsigned int (*set_vga_decode)(void *cookie, bool state));
-#else
-static inline int vga_client_register(struct pci_dev *pdev, void *cookie,
-				      void (*irq_set_state)(void *cookie, bool state),
-				      unsigned int (*set_vga_decode)(void *cookie, bool state))
-{
-	return 0;
-}
-#endif
-
 #endif /* LINUX_VGA_H */
-- 
2.30.2

