Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4AB165E3C
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgBTNHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:07:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56495 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728160AbgBTNHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Du/Q9cwkYv23U8HuA6dwHrSvlC9gAA5COcpF1xlZ39I=;
        b=i1HfNEdxdDSmDqCOM5AE3J10BlTGOJTcWeDqQ4cyr+lqavKdS5bcjnfjPZUietvzpQ/k07
        cXOW9J73c2g+cS6WnBEtEVfOnFYRng/Ft7J7rHlJLG1652k+Wa6ecyF+Vt8KiEPPaZb9FP
        GhCLn2fjH4AJVqKm3vOp44zjDEAx9oM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-13IoNbKrMo2F4i7JBZRYnA-1; Thu, 20 Feb 2020 08:07:08 -0500
X-MC-Unique: 13IoNbKrMo2F4i7JBZRYnA-1
Received: by mail-wm1-f70.google.com with SMTP id y7so579645wmd.4
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:07:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Du/Q9cwkYv23U8HuA6dwHrSvlC9gAA5COcpF1xlZ39I=;
        b=SlbEJBu7BL8M/Hd5pPCD9+sXicWbDjhr58tPlfhrvc4ke/vUrrx4IKZDnxj4w7tz5N
         SI7n2QE0/c8Lpnna0F/p5iyWnKAzWMk1hb+khqR0z4cg8rhFdKpomUX+0yDpPwKyOWa5
         Fyy1waBJy0SsiB6eSw/5bI2PKtiSXF/9l/KrfqTazH7In8rfqG55Vu+dDGjQSl+7sW4s
         vRKEz0gh7fr7OKYgIU+0cpNE7cVQ+ECRjbgoa+7j0+gM6oxwjFnV6+SKvFPdTQZ7091t
         T1+xWKozpvQE+5SxRnl1BaTnDc7NEHRZhmIL7/E8O96s2CHo74iDfmh+OtIULyXoBWpu
         6R8g==
X-Gm-Message-State: APjAAAUEvkUd4jX8/kqlGe6S0KpxbZXnlDGLuIv5/6hOhQiKEAxWMSkm
        cUTdZU3kLP11CpamuDzxWnrMJCGAXmTFu6vpHLrLtzCQY4IbaZbuycWBjOfRYgfLyPbyZkZqlo5
        xYDbZiYHLObOE
X-Received: by 2002:a7b:c088:: with SMTP id r8mr4601054wmh.18.1582204025777;
        Thu, 20 Feb 2020 05:07:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqzTc/nRX5CoIhTiVHPwKrtx6YNl9fhALe1YoNj6XyZHwJDsk5yvnlQRclQhspzivJLvmF3dTQ==
X-Received: by 2002:a7b:c088:: with SMTP id r8mr4601010wmh.18.1582204025361;
        Thu, 20 Feb 2020 05:07:05 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:07:04 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v3 19/20] Let cpu_[physical]_memory() calls pass a boolean 'is_write' argument
Date:   Thu, 20 Feb 2020 14:05:47 +0100
Message-Id: <20200220130548.29974-20-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200220130548.29974-1-philmd@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use an explicit boolean type.

This commit was produced with the included Coccinelle script
scripts/coccinelle/exec_rw_const.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/coccinelle/exec_rw_const.cocci | 14 ++++++++++++++
 include/exec/cpu-common.h              |  4 ++--
 hw/display/exynos4210_fimd.c           |  3 ++-
 hw/display/milkymist-tmu2.c            |  8 ++++----
 hw/display/omap_dss.c                  |  2 +-
 hw/display/ramfb.c                     |  2 +-
 hw/misc/pc-testdev.c                   |  2 +-
 hw/nvram/spapr_nvram.c                 |  4 ++--
 hw/ppc/ppc440_uc.c                     |  6 ++++--
 hw/ppc/spapr_hcall.c                   |  4 ++--
 hw/s390x/ipl.c                         |  2 +-
 hw/s390x/s390-pci-bus.c                |  2 +-
 hw/s390x/virtio-ccw.c                  |  2 +-
 hw/xen/xen_pt_graphics.c               |  2 +-
 target/i386/hax-all.c                  |  4 ++--
 target/s390x/excp_helper.c             |  2 +-
 target/s390x/helper.c                  |  6 +++---
 17 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
index ee98ce988e..54b1cab8cd 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -11,6 +11,20 @@ expression E1, E2, E3, E4, E5;
 |
 - address_space_rw(E1, E2, E3, E4, E5, 1)
 + address_space_rw(E1, E2, E3, E4, E5, true)
+|
+
+- cpu_physical_memory_rw(E1, E2, E3, 0)
++ cpu_physical_memory_rw(E1, E2, E3, false)
+|
+- cpu_physical_memory_rw(E1, E2, E3, 1)
++ cpu_physical_memory_rw(E1, E2, E3, true)
+|
+
+- cpu_physical_memory_map(E1, E2, 0)
++ cpu_physical_memory_map(E1, E2, false)
+|
+- cpu_physical_memory_map(E1, E2, 1)
++ cpu_physical_memory_map(E1, E2, true)
 )
 
 // Use address_space_write instead of casting to non-const
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 6bfe201779..e7fd5781ea 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -74,12 +74,12 @@ void cpu_physical_memory_rw(hwaddr addr, void *buf,
 static inline void cpu_physical_memory_read(hwaddr addr,
                                             void *buf, hwaddr len)
 {
-    cpu_physical_memory_rw(addr, buf, len, 0);
+    cpu_physical_memory_rw(addr, buf, len, false);
 }
 static inline void cpu_physical_memory_write(hwaddr addr,
                                              const void *buf, hwaddr len)
 {
-    cpu_physical_memory_rw(addr, (void *)buf, len, 1);
+    cpu_physical_memory_rw(addr, (void *)buf, len, true);
 }
 void *cpu_physical_memory_map(hwaddr addr,
                               hwaddr *plen,
diff --git a/hw/display/exynos4210_fimd.c b/hw/display/exynos4210_fimd.c
index c1071ecd46..ec6776680e 100644
--- a/hw/display/exynos4210_fimd.c
+++ b/hw/display/exynos4210_fimd.c
@@ -1164,7 +1164,8 @@ static void fimd_update_memory_section(Exynos4210fimdState *s, unsigned win)
         goto error_return;
     }
 
-    w->host_fb_addr = cpu_physical_memory_map(fb_start_addr, &fb_mapped_len, 0);
+    w->host_fb_addr = cpu_physical_memory_map(fb_start_addr, &fb_mapped_len,
+                                              false);
     if (!w->host_fb_addr) {
         DPRINT_ERROR("Failed to map window %u framebuffer\n", win);
         goto error_return;
diff --git a/hw/display/milkymist-tmu2.c b/hw/display/milkymist-tmu2.c
index 199f1227e7..513c0d5bab 100644
--- a/hw/display/milkymist-tmu2.c
+++ b/hw/display/milkymist-tmu2.c
@@ -218,7 +218,7 @@ static void tmu2_start(MilkymistTMU2State *s)
     glGenTextures(1, &texture);
     glBindTexture(GL_TEXTURE_2D, texture);
     fb_len = 2ULL * s->regs[R_TEXHRES] * s->regs[R_TEXVRES];
-    fb = cpu_physical_memory_map(s->regs[R_TEXFBUF], &fb_len, 0);
+    fb = cpu_physical_memory_map(s->regs[R_TEXFBUF], &fb_len, false);
     if (fb == NULL) {
         glDeleteTextures(1, &texture);
         glXMakeContextCurrent(s->dpy, None, None, NULL);
@@ -262,7 +262,7 @@ static void tmu2_start(MilkymistTMU2State *s)
 
     /* Read the QEMU dest. framebuffer into the OpenGL framebuffer */
     fb_len = 2ULL * s->regs[R_DSTHRES] * s->regs[R_DSTVRES];
-    fb = cpu_physical_memory_map(s->regs[R_DSTFBUF], &fb_len, 0);
+    fb = cpu_physical_memory_map(s->regs[R_DSTFBUF], &fb_len, false);
     if (fb == NULL) {
         glDeleteTextures(1, &texture);
         glXMakeContextCurrent(s->dpy, None, None, NULL);
@@ -281,7 +281,7 @@ static void tmu2_start(MilkymistTMU2State *s)
 
     /* Map the texture */
     mesh_len = MESH_MAXSIZE*MESH_MAXSIZE*sizeof(struct vertex);
-    mesh = cpu_physical_memory_map(s->regs[R_VERTICESADDR], &mesh_len, 0);
+    mesh = cpu_physical_memory_map(s->regs[R_VERTICESADDR], &mesh_len, false);
     if (mesh == NULL) {
         glDeleteTextures(1, &texture);
         glXMakeContextCurrent(s->dpy, None, None, NULL);
@@ -298,7 +298,7 @@ static void tmu2_start(MilkymistTMU2State *s)
 
     /* Write back the OpenGL framebuffer to the QEMU framebuffer */
     fb_len = 2ULL * s->regs[R_DSTHRES] * s->regs[R_DSTVRES];
-    fb = cpu_physical_memory_map(s->regs[R_DSTFBUF], &fb_len, 1);
+    fb = cpu_physical_memory_map(s->regs[R_DSTFBUF], &fb_len, true);
     if (fb == NULL) {
         glDeleteTextures(1, &texture);
         glXMakeContextCurrent(s->dpy, None, None, NULL);
diff --git a/hw/display/omap_dss.c b/hw/display/omap_dss.c
index 637aae8d39..32dc0d6aa7 100644
--- a/hw/display/omap_dss.c
+++ b/hw/display/omap_dss.c
@@ -632,7 +632,7 @@ static void omap_rfbi_transfer_start(struct omap_dss_s *s)
     len = s->rfbi.pixels * 2;
 
     data_addr = s->dispc.l[0].addr[0];
-    data = cpu_physical_memory_map(data_addr, &len, 0);
+    data = cpu_physical_memory_map(data_addr, &len, false);
     if (data && len != s->rfbi.pixels * 2) {
         cpu_physical_memory_unmap(data, len, 0, 0);
         data = NULL;
diff --git a/hw/display/ramfb.c b/hw/display/ramfb.c
index cd94940223..7ba07c80f6 100644
--- a/hw/display/ramfb.c
+++ b/hw/display/ramfb.c
@@ -57,7 +57,7 @@ static DisplaySurface *ramfb_create_display_surface(int width, int height,
     }
 
     size = (hwaddr)linesize * height;
-    data = cpu_physical_memory_map(addr, &size, 0);
+    data = cpu_physical_memory_map(addr, &size, false);
     if (size != (hwaddr)linesize * height) {
         cpu_physical_memory_unmap(data, size, 0, 0);
         return NULL;
diff --git a/hw/misc/pc-testdev.c b/hw/misc/pc-testdev.c
index 0fb84ddc6b..8aa8e6549f 100644
--- a/hw/misc/pc-testdev.c
+++ b/hw/misc/pc-testdev.c
@@ -125,7 +125,7 @@ static void test_flush_page_write(void *opaque, hwaddr addr, uint64_t data,
                             unsigned len)
 {
     hwaddr page = 4096;
-    void *a = cpu_physical_memory_map(data & ~0xffful, &page, 0);
+    void *a = cpu_physical_memory_map(data & ~0xffful, &page, false);
 
     /* We might not be able to get the full page, only mprotect what we actually
        have mapped */
diff --git a/hw/nvram/spapr_nvram.c b/hw/nvram/spapr_nvram.c
index 877ddef7b9..15d08281d4 100644
--- a/hw/nvram/spapr_nvram.c
+++ b/hw/nvram/spapr_nvram.c
@@ -89,7 +89,7 @@ static void rtas_nvram_fetch(PowerPCCPU *cpu, SpaprMachineState *spapr,
 
     assert(nvram->buf);
 
-    membuf = cpu_physical_memory_map(buffer, &len, 1);
+    membuf = cpu_physical_memory_map(buffer, &len, true);
     memcpy(membuf, nvram->buf + offset, len);
     cpu_physical_memory_unmap(membuf, len, 1, len);
 
@@ -127,7 +127,7 @@ static void rtas_nvram_store(PowerPCCPU *cpu, SpaprMachineState *spapr,
         return;
     }
 
-    membuf = cpu_physical_memory_map(buffer, &len, 0);
+    membuf = cpu_physical_memory_map(buffer, &len, false);
 
     alen = len;
     if (nvram->blk) {
diff --git a/hw/ppc/ppc440_uc.c b/hw/ppc/ppc440_uc.c
index 1a6a8fac22..d5ea962249 100644
--- a/hw/ppc/ppc440_uc.c
+++ b/hw/ppc/ppc440_uc.c
@@ -909,8 +909,10 @@ static void dcr_write_dma(void *opaque, int dcrn, uint32_t val)
 
                     sidx = didx = 0;
                     width = 1 << ((val & DMA0_CR_PW) >> 25);
-                    rptr = cpu_physical_memory_map(dma->ch[chnl].sa, &rlen, 0);
-                    wptr = cpu_physical_memory_map(dma->ch[chnl].da, &wlen, 1);
+                    rptr = cpu_physical_memory_map(dma->ch[chnl].sa, &rlen,
+                                                   false);
+                    wptr = cpu_physical_memory_map(dma->ch[chnl].da, &wlen,
+                                                   true);
                     if (rptr && wptr) {
                         if (!(val & DMA0_CR_DEC) &&
                             val & DMA0_CR_SAI && val & DMA0_CR_DAI) {
diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index b8bb66b5c0..caf55ab044 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -832,7 +832,7 @@ static target_ulong h_page_init(PowerPCCPU *cpu, SpaprMachineState *spapr,
     if (!is_ram_address(spapr, dst) || (dst & ~TARGET_PAGE_MASK) != 0) {
         return H_PARAMETER;
     }
-    pdst = cpu_physical_memory_map(dst, &len, 1);
+    pdst = cpu_physical_memory_map(dst, &len, true);
     if (!pdst || len != TARGET_PAGE_SIZE) {
         return H_PARAMETER;
     }
@@ -843,7 +843,7 @@ static target_ulong h_page_init(PowerPCCPU *cpu, SpaprMachineState *spapr,
             ret = H_PARAMETER;
             goto unmap_out;
         }
-        psrc = cpu_physical_memory_map(src, &len, 0);
+        psrc = cpu_physical_memory_map(src, &len, false);
         if (!psrc || len != TARGET_PAGE_SIZE) {
             ret = H_PARAMETER;
             goto unmap_out;
diff --git a/hw/s390x/ipl.c b/hw/s390x/ipl.c
index 7773499d7f..0817874b48 100644
--- a/hw/s390x/ipl.c
+++ b/hw/s390x/ipl.c
@@ -626,7 +626,7 @@ static void s390_ipl_prepare_qipl(S390CPU *cpu)
     uint8_t *addr;
     uint64_t len = 4096;
 
-    addr = cpu_physical_memory_map(cpu->env.psa, &len, 1);
+    addr = cpu_physical_memory_map(cpu->env.psa, &len, true);
     if (!addr || len < QIPL_ADDRESS + sizeof(QemuIplParameters)) {
         error_report("Cannot set QEMU IPL parameters");
         return;
diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 7c6a2b3c63..ed8be124da 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -641,7 +641,7 @@ static uint8_t set_ind_atomic(uint64_t ind_loc, uint8_t to_be_set)
     hwaddr len = 1;
     uint8_t *ind_addr;
 
-    ind_addr = cpu_physical_memory_map(ind_loc, &len, 1);
+    ind_addr = cpu_physical_memory_map(ind_loc, &len, true);
     if (!ind_addr) {
         s390_pci_generate_error_event(ERR_EVENT_AIRERR, 0, 0, 0, 0);
         return -1;
diff --git a/hw/s390x/virtio-ccw.c b/hw/s390x/virtio-ccw.c
index 13f57e7b67..50cf95b781 100644
--- a/hw/s390x/virtio-ccw.c
+++ b/hw/s390x/virtio-ccw.c
@@ -790,7 +790,7 @@ static uint8_t virtio_set_ind_atomic(SubchDev *sch, uint64_t ind_loc,
     hwaddr len = 1;
     uint8_t *ind_addr;
 
-    ind_addr = cpu_physical_memory_map(ind_loc, &len, 1);
+    ind_addr = cpu_physical_memory_map(ind_loc, &len, true);
     if (!ind_addr) {
         error_report("%s(%x.%x.%04x): unable to access indicator",
                      __func__, sch->cssid, sch->ssid, sch->schid);
diff --git a/hw/xen/xen_pt_graphics.c b/hw/xen/xen_pt_graphics.c
index b69732729b..b11e4e0546 100644
--- a/hw/xen/xen_pt_graphics.c
+++ b/hw/xen/xen_pt_graphics.c
@@ -222,7 +222,7 @@ void xen_pt_setup_vga(XenPCIPassthroughState *s, XenHostPCIDevice *dev,
     }
 
     /* Currently we fixed this address as a primary for legacy BIOS. */
-    cpu_physical_memory_rw(0xc0000, bios, bios_size, 1);
+    cpu_physical_memory_rw(0xc0000, bios, bios_size, true);
 }
 
 uint32_t igd_read_opregion(XenPCIPassthroughState *s)
diff --git a/target/i386/hax-all.c b/target/i386/hax-all.c
index a9cc51e6ce..38936d7af6 100644
--- a/target/i386/hax-all.c
+++ b/target/i386/hax-all.c
@@ -376,8 +376,8 @@ static int hax_handle_fastmmio(CPUArchState *env, struct hax_fastmmio *hft)
          *  hft->direction == 2: gpa ==> gpa2
          */
         uint64_t value;
-        cpu_physical_memory_rw(hft->gpa, &value, hft->size, 0);
-        cpu_physical_memory_rw(hft->gpa2, &value, hft->size, 1);
+        cpu_physical_memory_rw(hft->gpa, &value, hft->size, false);
+        cpu_physical_memory_rw(hft->gpa2, &value, hft->size, true);
     }
 
     return 0;
diff --git a/target/s390x/excp_helper.c b/target/s390x/excp_helper.c
index 1e9d6f20c1..3b58d10df3 100644
--- a/target/s390x/excp_helper.c
+++ b/target/s390x/excp_helper.c
@@ -393,7 +393,7 @@ static int mchk_store_vregs(CPUS390XState *env, uint64_t mcesao)
     MchkExtSaveArea *sa;
     int i;
 
-    sa = cpu_physical_memory_map(mcesao, &len, 1);
+    sa = cpu_physical_memory_map(mcesao, &len, true);
     if (!sa) {
         return -EFAULT;
     }
diff --git a/target/s390x/helper.c b/target/s390x/helper.c
index a3a49164e4..b810ad431e 100644
--- a/target/s390x/helper.c
+++ b/target/s390x/helper.c
@@ -151,7 +151,7 @@ LowCore *cpu_map_lowcore(CPUS390XState *env)
     LowCore *lowcore;
     hwaddr len = sizeof(LowCore);
 
-    lowcore = cpu_physical_memory_map(env->psa, &len, 1);
+    lowcore = cpu_physical_memory_map(env->psa, &len, true);
 
     if (len < sizeof(LowCore)) {
         cpu_abort(env_cpu(env), "Could not map lowcore\n");
@@ -246,7 +246,7 @@ int s390_store_status(S390CPU *cpu, hwaddr addr, bool store_arch)
     hwaddr len = sizeof(*sa);
     int i;
 
-    sa = cpu_physical_memory_map(addr, &len, 1);
+    sa = cpu_physical_memory_map(addr, &len, true);
     if (!sa) {
         return -EFAULT;
     }
@@ -298,7 +298,7 @@ int s390_store_adtl_status(S390CPU *cpu, hwaddr addr, hwaddr len)
     hwaddr save = len;
     int i;
 
-    sa = cpu_physical_memory_map(addr, &save, 1);
+    sa = cpu_physical_memory_map(addr, &save, true);
     if (!sa) {
         return -EFAULT;
     }
-- 
2.21.1

