Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E904165E39
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgBTNG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55842 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728221AbgBTNG7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOFaN72GDMCW5HO6VjgTUS8UF4EBg1PhikK6Z5qXel0=;
        b=aCxUlqBJB5AV2fdxx8ps6EpBzB7pBogvY/a8tyjK24lqDIsXvSW43d1Yhzue++ZZuyIDJe
        kDD7COzngb6ntwpZ27qgwMLpt4OGN/0PSmYTAtGVaCG9OKoqqUkc+Q01WO9XosBakIPP+K
        LRgo6giFWTS0y9lfDJKgXyefgcNZ3ec=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-PyMwBphRMt6MbE8UKrPkIg-1; Thu, 20 Feb 2020 08:06:56 -0500
X-MC-Unique: PyMwBphRMt6MbE8UKrPkIg-1
Received: by mail-wm1-f71.google.com with SMTP id f66so578357wmf.9
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mOFaN72GDMCW5HO6VjgTUS8UF4EBg1PhikK6Z5qXel0=;
        b=Z8UWSSLRwvmdc0Rijcxm92hIjQT/VQJLNTInb+g90u60ak5IRQlczCX6PpoN6vVcZ/
         jFJfehDXA9F/YpgtMDBgJWbveE1S886QQXtdpG9LmOLKKSrbS8+fEZtAj69J+VJvOYOV
         k6iyJqpTzrIxmUuh4RBn+NPAIOd2duPjhvBSKYIFKvNRMXUKCbUsBpdNsvH6TuN4YUUu
         MLHls8wAVrL4b/g8oUXHmLfvzgkR+0Pw8DzoTFtHf+BF+iQV77aDUIs6N/5HJKVPn6OH
         C8nhUQKhzi4ZDedZNi/PJs9Zav0qd9KiNKgan93m16o4elfw3j864g0Ga7cICVjFiQ/X
         c2lw==
X-Gm-Message-State: APjAAAWcr9nOiX8oyDbwIRSJBLvv8LfwUCVM5IWMXi3OmjAc4nnml4bq
        ukmV5Mur2NO8vTjAYx/jPamYZeQgDXVrC5GdzMO/0nWuDxKfWo0yohWp/419KbsHbaH7fEm6BCm
        JVvAaUVRv2kl0
X-Received: by 2002:a1c:bdc5:: with SMTP id n188mr4525028wmf.124.1582204014475;
        Thu, 20 Feb 2020 05:06:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqxVjczz55ql1rEb/MuCKbM4mbnGg2+QP76S0K4doZSf4ATrQ7PaxLlWrdmPAnroUu1OpiGw2w==
X-Received: by 2002:a1c:bdc5:: with SMTP id n188mr4524974wmf.124.1582204014007;
        Thu, 20 Feb 2020 05:06:54 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:53 -0800 (PST)
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
Subject: [PATCH v3 16/20] Let address_space_rw() calls pass a boolean 'is_write' argument
Date:   Thu, 20 Feb 2020 14:05:44 +0100
Message-Id: <20200220130548.29974-17-philmd@redhat.com>
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

Since its introduction in commit ac1970fbe8, address_space_rw()
takes a boolean 'is_write' argument. Fix the codebase by using
an explicit boolean type.

This commit was produced with the included Coccinelle script
scripts/coccinelle/exec_rw_const.

Inspired-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/coccinelle/exec_rw_const.cocci | 12 ++++++++++++
 target/i386/hvf/vmx.h                  |  2 +-
 exec.c                                 |  4 ++--
 hw/net/dp8393x.c                       | 27 +++++++++++++-------------
 hw/net/i82596.c                        | 11 ++++++-----
 hw/net/lasi_i82596.c                   |  4 ++--
 target/i386/hvf/x86_mmu.c              |  8 ++++----
 7 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
index 70cf52d58e..98cb06f09f 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -1,6 +1,18 @@
 // Usage:
 //  spatch --sp-file scripts/coccinelle/exec_rw_const.cocci --dir . --in-place
 
+// Convert to boolean
+@@
+expression E1, E2, E3, E4, E5;
+@@
+(
+- address_space_rw(E1, E2, E3, E4, E5, 0)
++ address_space_rw(E1, E2, E3, E4, E5, false)
+|
+- address_space_rw(E1, E2, E3, E4, E5, 1)
++ address_space_rw(E1, E2, E3, E4, E5, true)
+)
+
 // Use address_space_write instead of casting to non-const
 @@
 type T;
diff --git a/target/i386/hvf/vmx.h b/target/i386/hvf/vmx.h
index a115ca1782..19af029133 100644
--- a/target/i386/hvf/vmx.h
+++ b/target/i386/hvf/vmx.h
@@ -128,7 +128,7 @@ static inline void macvm_set_cr0(hv_vcpuid_t vcpu, uint64_t cr0)
         address_space_rw(&address_space_memory,
                          rvmcs(vcpu, VMCS_GUEST_CR3) & ~0x1f,
                          MEMTXATTRS_UNSPECIFIED,
-                         pdpte, 32, 0);
+                         pdpte, 32, false);
         /* Only set PDPTE when appropriate. */
         for (i = 0; i < 4; i++) {
             wvmcs(vcpu, VMCS_GUEST_PDPTE0 + i * 2, pdpte[i]);
diff --git a/exec.c b/exec.c
index 16974d4f4b..73c3bcfa40 100644
--- a/exec.c
+++ b/exec.c
@@ -3815,8 +3815,8 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
             address_space_write_rom(cpu->cpu_ases[asidx].as, phys_addr,
                                     attrs, buf, l);
         } else {
-            address_space_rw(cpu->cpu_ases[asidx].as, phys_addr,
-                             attrs, buf, l, 0);
+            address_space_rw(cpu->cpu_ases[asidx].as, phys_addr, attrs, buf,
+                             l, false);
         }
         len -= l;
         buf += l;
diff --git a/hw/net/dp8393x.c b/hw/net/dp8393x.c
index b461101ceb..b4363e3186 100644
--- a/hw/net/dp8393x.c
+++ b/hw/net/dp8393x.c
@@ -276,7 +276,7 @@ static void dp8393x_do_load_cam(dp8393xState *s)
     while (s->regs[SONIC_CDC] & 0x1f) {
         /* Fill current entry */
         address_space_rw(&s->as, dp8393x_cdp(s),
-                         MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
+                         MEMTXATTRS_UNSPECIFIED, s->data, size, false);
         s->cam[index][0] = dp8393x_get(s, width, 1) & 0xff;
         s->cam[index][1] = dp8393x_get(s, width, 1) >> 8;
         s->cam[index][2] = dp8393x_get(s, width, 2) & 0xff;
@@ -294,7 +294,7 @@ static void dp8393x_do_load_cam(dp8393xState *s)
 
     /* Read CAM enable */
     address_space_rw(&s->as, dp8393x_cdp(s),
-                     MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
+                     MEMTXATTRS_UNSPECIFIED, s->data, size, false);
     s->regs[SONIC_CE] = dp8393x_get(s, width, 0);
     DPRINTF("load cam done. cam enable mask 0x%04x\n", s->regs[SONIC_CE]);
 
@@ -312,7 +312,7 @@ static void dp8393x_do_read_rra(dp8393xState *s)
     width = (s->regs[SONIC_DCR] & SONIC_DCR_DW) ? 2 : 1;
     size = sizeof(uint16_t) * 4 * width;
     address_space_rw(&s->as, dp8393x_rrp(s),
-                     MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
+                     MEMTXATTRS_UNSPECIFIED, s->data, size, false);
 
     /* Update SONIC registers */
     s->regs[SONIC_CRBA0] = dp8393x_get(s, width, 0);
@@ -427,7 +427,7 @@ static void dp8393x_do_transmit_packets(dp8393xState *s)
         s->regs[SONIC_TTDA] = s->regs[SONIC_CTDA];
         DPRINTF("Transmit packet at %08x\n", dp8393x_ttda(s));
         address_space_rw(&s->as, dp8393x_ttda(s) + sizeof(uint16_t) * width,
-                         MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
+                         MEMTXATTRS_UNSPECIFIED, s->data, size, false);
         tx_len = 0;
 
         /* Update registers */
@@ -452,7 +452,8 @@ static void dp8393x_do_transmit_packets(dp8393xState *s)
                 len = sizeof(s->tx_buffer) - tx_len;
             }
             address_space_rw(&s->as, dp8393x_tsa(s),
-                MEMTXATTRS_UNSPECIFIED, &s->tx_buffer[tx_len], len, 0);
+                             MEMTXATTRS_UNSPECIFIED,
+                             &s->tx_buffer[tx_len], len, false);
             tx_len += len;
 
             i++;
@@ -461,7 +462,7 @@ static void dp8393x_do_transmit_packets(dp8393xState *s)
                 size = sizeof(uint16_t) * 3 * width;
                 address_space_rw(&s->as,
                     dp8393x_ttda(s) + sizeof(uint16_t) * (4 + 3 * i) * width,
-                                 MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
+                                 MEMTXATTRS_UNSPECIFIED, s->data, size, false);
                 s->regs[SONIC_TSA0] = dp8393x_get(s, width, 0);
                 s->regs[SONIC_TSA1] = dp8393x_get(s, width, 1);
                 s->regs[SONIC_TFS] = dp8393x_get(s, width, 2);
@@ -496,7 +497,7 @@ static void dp8393x_do_transmit_packets(dp8393xState *s)
         size = sizeof(uint16_t) * width;
         address_space_rw(&s->as,
                          dp8393x_ttda(s),
-                         MEMTXATTRS_UNSPECIFIED, s->data, size, 1);
+                         MEMTXATTRS_UNSPECIFIED, s->data, size, true);
 
         if (!(s->regs[SONIC_CR] & SONIC_CR_HTX)) {
             /* Read footer of packet */
@@ -505,7 +506,7 @@ static void dp8393x_do_transmit_packets(dp8393xState *s)
                              dp8393x_ttda(s) +
                              sizeof(uint16_t) *
                              (4 + 3 * s->regs[SONIC_TFC]) * width,
-                             MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
+                             MEMTXATTRS_UNSPECIFIED, s->data, size, false);
             s->regs[SONIC_CTDA] = dp8393x_get(s, width, 0) & ~0x1;
             if (dp8393x_get(s, width, 0) & 0x1) {
                 /* EOL detected */
@@ -768,7 +769,7 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
         size = sizeof(uint16_t) * 1 * width;
         address = dp8393x_crda(s) + sizeof(uint16_t) * 5 * width;
         address_space_rw(&s->as, address, MEMTXATTRS_UNSPECIFIED,
-                         s->data, size, 0);
+                         s->data, size, false);
         if (dp8393x_get(s, width, 0) & 0x1) {
             /* Still EOL ; stop reception */
             return -1;
@@ -790,7 +791,7 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
     address_space_write(&s->as, address, MEMTXATTRS_UNSPECIFIED, buf, rx_len);
     address += rx_len;
     address_space_rw(&s->as, address,
-                     MEMTXATTRS_UNSPECIFIED, &checksum, 4, 1);
+                     MEMTXATTRS_UNSPECIFIED, &checksum, 4, true);
     rx_len += 4;
     s->regs[SONIC_CRBA1] = address >> 16;
     s->regs[SONIC_CRBA0] = address & 0xffff;
@@ -819,12 +820,12 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
     dp8393x_put(s, width, 4, s->regs[SONIC_RSC]); /* seq_no */
     size = sizeof(uint16_t) * 5 * width;
     address_space_rw(&s->as, dp8393x_crda(s),
-                     MEMTXATTRS_UNSPECIFIED, s->data, size, 1);
+                     MEMTXATTRS_UNSPECIFIED, s->data, size, true);
 
     /* Move to next descriptor */
     size = sizeof(uint16_t) * width;
     address_space_rw(&s->as, dp8393x_crda(s) + sizeof(uint16_t) * 5 * width,
-                     MEMTXATTRS_UNSPECIFIED, s->data, size, 0);
+                     MEMTXATTRS_UNSPECIFIED, s->data, size, false);
     s->regs[SONIC_LLFA] = dp8393x_get(s, width, 0);
     if (s->regs[SONIC_LLFA] & 0x1) {
         /* EOL detected */
@@ -838,7 +839,7 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
         }
         s->data[0] = 0;
         address_space_rw(&s->as, offset, MEMTXATTRS_UNSPECIFIED,
-                         s->data, sizeof(uint16_t), 1);
+                         s->data, sizeof(uint16_t), true);
         s->regs[SONIC_CRDA] = s->regs[SONIC_LLFA];
         s->regs[SONIC_ISR] |= SONIC_ISR_PKTRX;
         s->regs[SONIC_RSC] = (s->regs[SONIC_RSC] & 0xff00) | (((s->regs[SONIC_RSC] & 0x00ff) + 1) & 0x00ff);
diff --git a/hw/net/i82596.c b/hw/net/i82596.c
index a292984e06..11537f72d1 100644
--- a/hw/net/i82596.c
+++ b/hw/net/i82596.c
@@ -149,7 +149,7 @@ static void i82596_transmit(I82596State *s, uint32_t addr)
         if (s->nic && len) {
             assert(len <= sizeof(s->tx_buffer));
             address_space_rw(&address_space_memory, tba,
-                MEMTXATTRS_UNSPECIFIED, s->tx_buffer, len, 0);
+                             MEMTXATTRS_UNSPECIFIED, s->tx_buffer, len, false);
             DBG(PRINT_PKTHDR("Send", &s->tx_buffer));
             DBG(printf("Sending %d bytes\n", len));
             qemu_send_packet(qemu_get_queue(s->nic), s->tx_buffer, len);
@@ -173,7 +173,7 @@ static void set_individual_address(I82596State *s, uint32_t addr)
     nc = qemu_get_queue(s->nic);
     m = s->conf.macaddr.a;
     address_space_rw(&address_space_memory, addr + 8,
-        MEMTXATTRS_UNSPECIFIED, m, ETH_ALEN, 0);
+                     MEMTXATTRS_UNSPECIFIED, m, ETH_ALEN, false);
     qemu_format_nic_info_str(nc, m);
     trace_i82596_new_mac(nc->info_str);
 }
@@ -192,7 +192,7 @@ static void set_multicast_list(I82596State *s, uint32_t addr)
         uint8_t multicast_addr[ETH_ALEN];
         address_space_rw(&address_space_memory,
             addr + i * ETH_ALEN, MEMTXATTRS_UNSPECIFIED,
-            multicast_addr, ETH_ALEN, 0);
+                         multicast_addr, ETH_ALEN, false);
         DBG(printf("Add multicast entry " MAC_FMT "\n",
                     MAC_ARG(multicast_addr)));
         unsigned mcast_idx = (net_crc32(multicast_addr, ETH_ALEN) &
@@ -261,7 +261,8 @@ static void command_loop(I82596State *s)
             byte_cnt = MIN(byte_cnt, sizeof(s->config));
             /* copy byte_cnt max. */
             address_space_rw(&address_space_memory, s->cmd_p + 8,
-                MEMTXATTRS_UNSPECIFIED, s->config, byte_cnt, 0);
+                             MEMTXATTRS_UNSPECIFIED, s->config, byte_cnt,
+                             false);
             /* config byte according to page 35ff */
             s->config[2] &= 0x82; /* mask valid bits */
             s->config[2] |= 0x40;
@@ -647,7 +648,7 @@ ssize_t i82596_receive(NetClientState *nc, const uint8_t *buf, size_t sz)
             len -= num;
             if (len == 0) { /* copy crc */
                 address_space_rw(&address_space_memory, rba - 4,
-                    MEMTXATTRS_UNSPECIFIED, crc_ptr, 4, 1);
+                                 MEMTXATTRS_UNSPECIFIED, crc_ptr, 4, true);
             }
 
             num |= 0x4000; /* set F BIT */
diff --git a/hw/net/lasi_i82596.c b/hw/net/lasi_i82596.c
index 427b3fbf70..8bff419378 100644
--- a/hw/net/lasi_i82596.c
+++ b/hw/net/lasi_i82596.c
@@ -55,8 +55,8 @@ static void lasi_82596_mem_write(void *opaque, hwaddr addr,
          * Provided for SeaBIOS only. Write MAC of Network card to addr @val.
          * Needed for the PDC_LAN_STATION_ID_READ PDC call.
          */
-        address_space_rw(&address_space_memory, val,
-            MEMTXATTRS_UNSPECIFIED, d->state.conf.macaddr.a, ETH_ALEN, 1);
+        address_space_rw(&address_space_memory, val, MEMTXATTRS_UNSPECIFIED,
+                         d->state.conf.macaddr.a, ETH_ALEN, true);
         break;
     }
 }
diff --git a/target/i386/hvf/x86_mmu.c b/target/i386/hvf/x86_mmu.c
index 6a620643c1..451dcc983a 100644
--- a/target/i386/hvf/x86_mmu.c
+++ b/target/i386/hvf/x86_mmu.c
@@ -89,7 +89,7 @@ static bool get_pt_entry(struct CPUState *cpu, struct gpt_translation *pt,
 
     index = gpt_entry(pt->gva, level, pae);
     address_space_rw(&address_space_memory, gpa + index * pte_size(pae),
-                     MEMTXATTRS_UNSPECIFIED, &pte, pte_size(pae), 0);
+                     MEMTXATTRS_UNSPECIFIED, &pte, pte_size(pae), false);
 
     pt->pte[level - 1] = pte;
 
@@ -238,8 +238,8 @@ void vmx_write_mem(struct CPUState *cpu, target_ulong gva, void *data, int bytes
         if (!mmu_gva_to_gpa(cpu, gva, &gpa)) {
             VM_PANIC_EX("%s: mmu_gva_to_gpa %llx failed\n", __func__, gva);
         } else {
-            address_space_rw(&address_space_memory, gpa, MEMTXATTRS_UNSPECIFIED,
-                             data, copy, 1);
+            address_space_rw(&address_space_memory, gpa,
+                             MEMTXATTRS_UNSPECIFIED, data, copy, true);
         }
 
         bytes -= copy;
@@ -260,7 +260,7 @@ void vmx_read_mem(struct CPUState *cpu, void *data, target_ulong gva, int bytes)
             VM_PANIC_EX("%s: mmu_gva_to_gpa %llx failed\n", __func__, gva);
         }
         address_space_rw(&address_space_memory, gpa, MEMTXATTRS_UNSPECIFIED,
-                         data, copy, 0);
+                         data, copy, false);
 
         bytes -= copy;
         gva += copy;
-- 
2.21.1

