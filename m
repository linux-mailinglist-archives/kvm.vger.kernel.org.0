Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0E2165E2F
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgBTNG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:29 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36877 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728171AbgBTNG3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:06:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8pJhUP9usprCLN78RzoD9uhnYc7r5iBRfDww4Tsum+4=;
        b=cBc0TnTuaCg/ANBb9E2ijM4/0ZqY1Xi6v4nDwnHUzJrcOADpjwYjl253ImcVoYqVO3n9iJ
        uFF8d2/5Ekb+BhqoXt8tprd4PN8+NQfBCeClDErJ3PsObbb3c8Hh6gcctxZsAM2m7RFCSy
        3JHAkYytNfS/VUfU1kll+YFJYA/MwjI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-fA_Z9NGHMzaE-SjsF7RuLg-1; Thu, 20 Feb 2020 08:06:26 -0500
X-MC-Unique: fA_Z9NGHMzaE-SjsF7RuLg-1
Received: by mail-wm1-f70.google.com with SMTP id p26so800632wmg.5
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8pJhUP9usprCLN78RzoD9uhnYc7r5iBRfDww4Tsum+4=;
        b=P1VbLZn295Mqvxf8ARWLJNPFr6ay1ecDwLjeKkSVNBVw9AZTX5Sj91EGj0wSrbYPvf
         Khsg+S45TVxb8FMXBRrvkanlqigzap9/ikW8KABOYdJJa9ojBLFKqzmpIeLR1HkwKWsO
         b0K5+Vm/J3ou1P/6TtyRI5xDfKEb8Gnaz1W13Cr2rIywDZmNndT0lGSyRAMBN3/iW69G
         B7ZO8fffOKz0WCGs519jB0DgJ3k1ndLJKI715AcsVt0o7nmrQY/FEXL+1oE3L3N+QO2p
         BBmxQOL7dWIMBeRQq//wZatlwBv9imCmdhcB67Wip/HkC5H9GnBrcMjUKgEepsUQLdue
         +NHg==
X-Gm-Message-State: APjAAAUlzL+epHynn+qtdjisrTVxSrO7qVCFMJu2LCW0tKHPUxblzaj6
        XF8JZCtg6WbH4gOj46rb1G4auzLkwuPXMKtOs5kTQ5W4zIl3QOIp2b80ifGbRISnW8oYwhzkrR+
        AUFgUe+FNv+3o
X-Received: by 2002:a1c:3b09:: with SMTP id i9mr4474201wma.31.1582203984781;
        Thu, 20 Feb 2020 05:06:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqyueDTuvmLdILlFBUAI1KMTYLdx1fyD4hDWZ7aWgHEWsecyRbWCT1Cjdoc3TPZaC5AcngMlzg==
X-Received: by 2002:a1c:3b09:: with SMTP id i9mr4474140wma.31.1582203984067;
        Thu, 20 Feb 2020 05:06:24 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:23 -0800 (PST)
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
Subject: [PATCH v3 08/20] Remove unnecessary cast when using the address_space API
Date:   Thu, 20 Feb 2020 14:05:36 +0100
Message-Id: <20200220130548.29974-9-philmd@redhat.com>
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

This commit was produced with the included Coccinelle script
scripts/coccinelle/exec_rw_const.

Two lines in hw/net/dp8393x.c that Coccinelle produced that
were over 80 characters were re-wrapped by hand.

Suggested-by: Stefan Weil <sw@weilnetz.de>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/coccinelle/exec_rw_const.cocci | 15 +++++++++++++-
 target/i386/hvf/vmx.h                  |  2 +-
 hw/arm/boot.c                          |  6 ++----
 hw/dma/rc4030.c                        |  4 ++--
 hw/dma/xlnx-zdma.c                     |  2 +-
 hw/net/cadence_gem.c                   | 21 +++++++++----------
 hw/net/dp8393x.c                       | 28 +++++++++++++-------------
 hw/s390x/css.c                         |  4 ++--
 qtest.c                                | 12 +++++------
 target/i386/hvf/x86_mmu.c              |  2 +-
 target/i386/whpx-all.c                 |  2 +-
 target/s390x/mmu_helper.c              |  2 +-
 12 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
index 4e459d915b..5ed956a834 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -17,10 +17,23 @@ expression E1, E2, E3, E4;
 
 // Remove useless cast
 @@
-expression E1, E2, E3, E4;
+expression E1, E2, E3, E4, E5, E6;
 type T;
 @@
 (
+- address_space_rw(E1, E2, E3, (T *)E4, E5, E6)
++ address_space_rw(E1, E2, E3, E4, E5, E6)
+|
+- address_space_read(E1, E2, E3, (T *)E4, E5)
++ address_space_read(E1, E2, E3, E4, E5)
+|
+- address_space_write(E1, E2, E3, (T *)E4, E5)
++ address_space_write(E1, E2, E3, E4, E5)
+|
+- address_space_write_rom(E1, E2, E3, (T *)E4, E5)
++ address_space_write_rom(E1, E2, E3, E4, E5)
+|
+
 - dma_memory_read(E1, E2, (T *)E3, E4)
 + dma_memory_read(E1, E2, E3, E4)
 |
diff --git a/target/i386/hvf/vmx.h b/target/i386/hvf/vmx.h
index eb8894cd58..a115ca1782 100644
--- a/target/i386/hvf/vmx.h
+++ b/target/i386/hvf/vmx.h
@@ -128,7 +128,7 @@ static inline void macvm_set_cr0(hv_vcpuid_t vcpu, uint64_t cr0)
         address_space_rw(&address_space_memory,
                          rvmcs(vcpu, VMCS_GUEST_CR3) & ~0x1f,
                          MEMTXATTRS_UNSPECIFIED,
-                         (uint8_t *)pdpte, 32, 0);
+                         pdpte, 32, 0);
         /* Only set PDPTE when appropriate. */
         for (i = 0; i < 4; i++) {
             wvmcs(vcpu, VMCS_GUEST_PDPTE0 + i * 2, pdpte[i]);
diff --git a/hw/arm/boot.c b/hw/arm/boot.c
index 0c213ca627..fef4072db1 100644
--- a/hw/arm/boot.c
+++ b/hw/arm/boot.c
@@ -327,8 +327,7 @@ static void set_kernel_args(const struct arm_boot_info *info, AddressSpace *as)
 
         cmdline_size = strlen(info->kernel_cmdline);
         address_space_write(as, p + 8, MEMTXATTRS_UNSPECIFIED,
-                            (const uint8_t *)info->kernel_cmdline,
-                            cmdline_size + 1);
+                            info->kernel_cmdline, cmdline_size + 1);
         cmdline_size = (cmdline_size >> 2) + 1;
         WRITE_WORD(p, cmdline_size + 2);
         WRITE_WORD(p, 0x54410009);
@@ -420,8 +419,7 @@ static void set_kernel_args_old(const struct arm_boot_info *info,
     }
     s = info->kernel_cmdline;
     if (s) {
-        address_space_write(as, p, MEMTXATTRS_UNSPECIFIED,
-                            (const uint8_t *)s, strlen(s) + 1);
+        address_space_write(as, p, MEMTXATTRS_UNSPECIFIED, s, strlen(s) + 1);
     } else {
         WRITE_WORD(p, 0);
     }
diff --git a/hw/dma/rc4030.c b/hw/dma/rc4030.c
index c4cf8236f4..ca0becd756 100644
--- a/hw/dma/rc4030.c
+++ b/hw/dma/rc4030.c
@@ -513,8 +513,8 @@ static IOMMUTLBEntry rc4030_dma_translate(IOMMUMemoryRegion *iommu, hwaddr addr,
     if (i < s->dma_tl_limit / sizeof(entry)) {
         entry_address = (s->dma_tl_base & 0x7fffffff) + i * sizeof(entry);
         if (address_space_read(ret.target_as, entry_address,
-                               MEMTXATTRS_UNSPECIFIED, (unsigned char *)&entry,
-                               sizeof(entry)) == MEMTX_OK) {
+                               MEMTXATTRS_UNSPECIFIED, &entry, sizeof(entry))
+                == MEMTX_OK) {
             ret.translated_addr = entry.frame & ~(DMA_PAGESIZE - 1);
             ret.perm = IOMMU_RW;
         }
diff --git a/hw/dma/xlnx-zdma.c b/hw/dma/xlnx-zdma.c
index 8fb83f5b07..683abbe53f 100644
--- a/hw/dma/xlnx-zdma.c
+++ b/hw/dma/xlnx-zdma.c
@@ -364,7 +364,7 @@ static uint64_t zdma_update_descr_addr(XlnxZDMA *s, bool type,
     } else {
         addr = zdma_get_regaddr64(s, basereg);
         addr += sizeof(s->dsc_dst);
-        address_space_rw(s->dma_as, addr, s->attr, (void *) &next, 8, false);
+        address_space_rw(s->dma_as, addr, s->attr, &next, 8, false);
         zdma_put_regaddr64(s, basereg, next);
     }
     return next;
diff --git a/hw/net/cadence_gem.c b/hw/net/cadence_gem.c
index 871fcf2031..ddabdb3f90 100644
--- a/hw/net/cadence_gem.c
+++ b/hw/net/cadence_gem.c
@@ -871,7 +871,7 @@ static void gem_get_rx_desc(CadenceGEMState *s, int q)
 
     /* read current descriptor */
     address_space_read(&s->dma_as, desc_addr, MEMTXATTRS_UNSPECIFIED,
-                       (uint8_t *)s->rx_desc[q],
+                       s->rx_desc[q],
                        sizeof(uint32_t) * gem_get_desc_len(s, true));
 
     /* Descriptor owned by software ? */
@@ -1029,9 +1029,8 @@ static ssize_t gem_receive(NetClientState *nc, const uint8_t *buf, size_t size)
 
         /* Descriptor write-back.  */
         desc_addr = gem_get_rx_desc_addr(s, q);
-        address_space_write(&s->dma_as, desc_addr,
-                            MEMTXATTRS_UNSPECIFIED,
-                            (uint8_t *)s->rx_desc[q],
+        address_space_write(&s->dma_as, desc_addr, MEMTXATTRS_UNSPECIFIED,
+                            s->rx_desc[q],
                             sizeof(uint32_t) * gem_get_desc_len(s, true));
 
         /* Next descriptor */
@@ -1137,7 +1136,7 @@ static void gem_transmit(CadenceGEMState *s)
 
         DB_PRINT("read descriptor 0x%" HWADDR_PRIx "\n", packet_desc_addr);
         address_space_read(&s->dma_as, packet_desc_addr,
-                           MEMTXATTRS_UNSPECIFIED, (uint8_t *)desc,
+                           MEMTXATTRS_UNSPECIFIED, desc,
                            sizeof(uint32_t) * gem_get_desc_len(s, false));
         /* Handle all descriptors owned by hardware */
         while (tx_desc_get_used(desc) == 0) {
@@ -1185,14 +1184,12 @@ static void gem_transmit(CadenceGEMState *s)
                  * the processor.
                  */
                 address_space_read(&s->dma_as, desc_addr,
-                                   MEMTXATTRS_UNSPECIFIED,
-                                   (uint8_t *)desc_first,
+                                   MEMTXATTRS_UNSPECIFIED, desc_first,
                                    sizeof(desc_first));
                 tx_desc_set_used(desc_first);
                 address_space_write(&s->dma_as, desc_addr,
-                                  MEMTXATTRS_UNSPECIFIED,
-                                  (uint8_t *)desc_first,
-                                   sizeof(desc_first));
+                                    MEMTXATTRS_UNSPECIFIED, desc_first,
+                                    sizeof(desc_first));
                 /* Advance the hardware current descriptor past this packet */
                 if (tx_desc_get_wrap(desc)) {
                     s->tx_desc_addr[q] = s->regs[GEM_TXQBASE];
@@ -1246,8 +1243,8 @@ static void gem_transmit(CadenceGEMState *s)
             }
             DB_PRINT("read descriptor 0x%" HWADDR_PRIx "\n", packet_desc_addr);
             address_space_read(&s->dma_as, packet_desc_addr,
-                              MEMTXATTRS_UNSPECIFIED, (uint8_t *)desc,
-                              sizeof(uint32_t) * gem_get_desc_len(s, false));
+                               MEMTXATTRS_UNSPECIFIED, desc,
+                               sizeof(uint32_t) * gem_get_desc_len(s, false));
         }
 
         if (tx_desc_get_used(desc)) {
diff --git a/hw/net/dp8393x.c b/hw/net/dp8393x.c
index 580ae4437e..b461101ceb 100644
--- a/hw/net/dp8393x.c
+++ b/hw/net/dp8393x.c
@@ -276,7 +276,7 @@ static void dp8393x_do_load_cam(dp8393xState *s)
     while (s->regs[SONIC_CDC] & 0x1f) {
         /* Fill current entry */
         address_space_rw(&s->as, dp8393x_cdp(s),
-            MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 0);
+                         MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
         s->cam[index][0] = dp8393x_get(s, width, 1) & 0xff;
         s->cam[index][1] = dp8393x_get(s, width, 1) >> 8;
         s->cam[index][2] = dp8393x_get(s, width, 2) & 0xff;
@@ -294,7 +294,7 @@ static void dp8393x_do_load_cam(dp8393xState *s)
 
     /* Read CAM enable */
     address_space_rw(&s->as, dp8393x_cdp(s),
-        MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 0);
+                     MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
     s->regs[SONIC_CE] = dp8393x_get(s, width, 0);
     DPRINTF("load cam done. cam enable mask 0x%04x\n", s->regs[SONIC_CE]);
 
@@ -312,7 +312,7 @@ static void dp8393x_do_read_rra(dp8393xState *s)
     width = (s->regs[SONIC_DCR] & SONIC_DCR_DW) ? 2 : 1;
     size = sizeof(uint16_t) * 4 * width;
     address_space_rw(&s->as, dp8393x_rrp(s),
-        MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 0);
+                     MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
 
     /* Update SONIC registers */
     s->regs[SONIC_CRBA0] = dp8393x_get(s, width, 0);
@@ -427,7 +427,7 @@ static void dp8393x_do_transmit_packets(dp8393xState *s)
         s->regs[SONIC_TTDA] = s->regs[SONIC_CTDA];
         DPRINTF("Transmit packet at %08x\n", dp8393x_ttda(s));
         address_space_rw(&s->as, dp8393x_ttda(s) + sizeof(uint16_t) * width,
-            MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 0);
+                         MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
         tx_len = 0;
 
         /* Update registers */
@@ -461,7 +461,7 @@ static void dp8393x_do_transmit_packets(dp8393xState *s)
                 size = sizeof(uint16_t) * 3 * width;
                 address_space_rw(&s->as,
                     dp8393x_ttda(s) + sizeof(uint16_t) * (4 + 3 * i) * width,
-                    MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 0);
+                                 MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
                 s->regs[SONIC_TSA0] = dp8393x_get(s, width, 0);
                 s->regs[SONIC_TSA1] = dp8393x_get(s, width, 1);
                 s->regs[SONIC_TFS] = dp8393x_get(s, width, 2);
@@ -495,17 +495,17 @@ static void dp8393x_do_transmit_packets(dp8393xState *s)
                     s->regs[SONIC_TCR] & 0x0fff); /* status */
         size = sizeof(uint16_t) * width;
         address_space_rw(&s->as,
-            dp8393x_ttda(s),
-            MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 1);
+                         dp8393x_ttda(s),
+                         MEMTXATTRS_UNSPECIFIED, s->data, size, 1);
 
         if (!(s->regs[SONIC_CR] & SONIC_CR_HTX)) {
             /* Read footer of packet */
             size = sizeof(uint16_t) * width;
             address_space_rw(&s->as,
-                dp8393x_ttda(s) +
+                             dp8393x_ttda(s) +
                              sizeof(uint16_t) *
                              (4 + 3 * s->regs[SONIC_TFC]) * width,
-                MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 0);
+                             MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
             s->regs[SONIC_CTDA] = dp8393x_get(s, width, 0) & ~0x1;
             if (dp8393x_get(s, width, 0) & 0x1) {
                 /* EOL detected */
@@ -768,7 +768,7 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
         size = sizeof(uint16_t) * 1 * width;
         address = dp8393x_crda(s) + sizeof(uint16_t) * 5 * width;
         address_space_rw(&s->as, address, MEMTXATTRS_UNSPECIFIED,
-                         (uint8_t *)s->data, size, 0);
+                         s->data, size, 0);
         if (dp8393x_get(s, width, 0) & 0x1) {
             /* Still EOL ; stop reception */
             return -1;
@@ -790,7 +790,7 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
     address_space_write(&s->as, address, MEMTXATTRS_UNSPECIFIED, buf, rx_len);
     address += rx_len;
     address_space_rw(&s->as, address,
-        MEMTXATTRS_UNSPECIFIED, (uint8_t *)&checksum, 4, 1);
+                     MEMTXATTRS_UNSPECIFIED, &checksum, 4, 1);
     rx_len += 4;
     s->regs[SONIC_CRBA1] = address >> 16;
     s->regs[SONIC_CRBA0] = address & 0xffff;
@@ -819,12 +819,12 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
     dp8393x_put(s, width, 4, s->regs[SONIC_RSC]); /* seq_no */
     size = sizeof(uint16_t) * 5 * width;
     address_space_rw(&s->as, dp8393x_crda(s),
-        MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 1);
+                     MEMTXATTRS_UNSPECIFIED, s->data, size, 1);
 
     /* Move to next descriptor */
     size = sizeof(uint16_t) * width;
     address_space_rw(&s->as, dp8393x_crda(s) + sizeof(uint16_t) * 5 * width,
-        MEMTXATTRS_UNSPECIFIED, (uint8_t *)s->data, size, 0);
+                     MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
     s->regs[SONIC_LLFA] = dp8393x_get(s, width, 0);
     if (s->regs[SONIC_LLFA] & 0x1) {
         /* EOL detected */
@@ -838,7 +838,7 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
         }
         s->data[0] = 0;
         address_space_rw(&s->as, offset, MEMTXATTRS_UNSPECIFIED,
-                         (uint8_t *)s->data, sizeof(uint16_t), 1);
+                         s->data, sizeof(uint16_t), 1);
         s->regs[SONIC_CRDA] = s->regs[SONIC_LLFA];
         s->regs[SONIC_ISR] |= SONIC_ISR_PKTRX;
         s->regs[SONIC_RSC] = (s->regs[SONIC_RSC] & 0xff00) | (((s->regs[SONIC_RSC] & 0x00ff) + 1) & 0x00ff);
diff --git a/hw/s390x/css.c b/hw/s390x/css.c
index 844caab408..f27f8c45a5 100644
--- a/hw/s390x/css.c
+++ b/hw/s390x/css.c
@@ -875,7 +875,7 @@ static inline int ida_read_next_idaw(CcwDataStream *cds)
             return -EINVAL; /* channel program check */
         }
         ret = address_space_rw(&address_space_memory, idaw_addr,
-                               MEMTXATTRS_UNSPECIFIED, (void *) &idaw.fmt2,
+                               MEMTXATTRS_UNSPECIFIED, &idaw.fmt2,
                                sizeof(idaw.fmt2), false);
         cds->cda = be64_to_cpu(idaw.fmt2);
     } else {
@@ -884,7 +884,7 @@ static inline int ida_read_next_idaw(CcwDataStream *cds)
             return -EINVAL; /* channel program check */
         }
         ret = address_space_rw(&address_space_memory, idaw_addr,
-                               MEMTXATTRS_UNSPECIFIED, (void *) &idaw.fmt1,
+                               MEMTXATTRS_UNSPECIFIED, &idaw.fmt1,
                                sizeof(idaw.fmt1), false);
         cds->cda = be64_to_cpu(idaw.fmt1);
         if (cds->cda & 0x80000000) {
diff --git a/qtest.c b/qtest.c
index 12432f99cf..65e33b80e3 100644
--- a/qtest.c
+++ b/qtest.c
@@ -435,17 +435,17 @@ static void qtest_process_command(CharBackend *chr, gchar **words)
             uint16_t data = value;
             tswap16s(&data);
             address_space_rw(first_cpu->as, addr, MEMTXATTRS_UNSPECIFIED,
-                             (uint8_t *) &data, 2, true);
+                             &data, 2, true);
         } else if (words[0][5] == 'l') {
             uint32_t data = value;
             tswap32s(&data);
             address_space_rw(first_cpu->as, addr, MEMTXATTRS_UNSPECIFIED,
-                             (uint8_t *) &data, 4, true);
+                             &data, 4, true);
         } else if (words[0][5] == 'q') {
             uint64_t data = value;
             tswap64s(&data);
             address_space_rw(first_cpu->as, addr, MEMTXATTRS_UNSPECIFIED,
-                             (uint8_t *) &data, 8, true);
+                             &data, 8, true);
         }
         qtest_send_prefix(chr);
         qtest_send(chr, "OK\n");
@@ -469,16 +469,16 @@ static void qtest_process_command(CharBackend *chr, gchar **words)
         } else if (words[0][4] == 'w') {
             uint16_t data;
             address_space_rw(first_cpu->as, addr, MEMTXATTRS_UNSPECIFIED,
-                             (uint8_t *) &data, 2, false);
+                             &data, 2, false);
             value = tswap16(data);
         } else if (words[0][4] == 'l') {
             uint32_t data;
             address_space_rw(first_cpu->as, addr, MEMTXATTRS_UNSPECIFIED,
-                             (uint8_t *) &data, 4, false);
+                             &data, 4, false);
             value = tswap32(data);
         } else if (words[0][4] == 'q') {
             address_space_rw(first_cpu->as, addr, MEMTXATTRS_UNSPECIFIED,
-                             (uint8_t *) &value, 8, false);
+                             &value, 8, false);
             tswap64s(&value);
         }
         qtest_send_prefix(chr);
diff --git a/target/i386/hvf/x86_mmu.c b/target/i386/hvf/x86_mmu.c
index d5a0efe718..6a620643c1 100644
--- a/target/i386/hvf/x86_mmu.c
+++ b/target/i386/hvf/x86_mmu.c
@@ -89,7 +89,7 @@ static bool get_pt_entry(struct CPUState *cpu, struct gpt_translation *pt,
 
     index = gpt_entry(pt->gva, level, pae);
     address_space_rw(&address_space_memory, gpa + index * pte_size(pae),
-                     MEMTXATTRS_UNSPECIFIED, (uint8_t *)&pte, pte_size(pae), 0);
+                     MEMTXATTRS_UNSPECIFIED, &pte, pte_size(pae), 0);
 
     pt->pte[level - 1] = pte;
 
diff --git a/target/i386/whpx-all.c b/target/i386/whpx-all.c
index 3ed2aa1892..0a1f244751 100644
--- a/target/i386/whpx-all.c
+++ b/target/i386/whpx-all.c
@@ -540,7 +540,7 @@ static HRESULT CALLBACK whpx_emu_ioport_callback(
 {
     MemTxAttrs attrs = { 0 };
     address_space_rw(&address_space_io, IoAccess->Port, attrs,
-                     (uint8_t *)&IoAccess->Data, IoAccess->AccessSize,
+                     &IoAccess->Data, IoAccess->AccessSize,
                      IoAccess->Direction);
     return S_OK;
 }
diff --git a/target/s390x/mmu_helper.c b/target/s390x/mmu_helper.c
index c9f3f34750..0be2f300bb 100644
--- a/target/s390x/mmu_helper.c
+++ b/target/s390x/mmu_helper.c
@@ -106,7 +106,7 @@ static inline bool read_table_entry(CPUS390XState *env, hwaddr gaddr,
      * We treat them as absolute addresses and don't wrap them.
      */
     if (unlikely(address_space_read(cs->as, gaddr, MEMTXATTRS_UNSPECIFIED,
-                                    (uint8_t *)entry, sizeof(*entry)) !=
+                                    entry, sizeof(*entry)) !=
                  MEMTX_OK)) {
         return false;
     }
-- 
2.21.1

