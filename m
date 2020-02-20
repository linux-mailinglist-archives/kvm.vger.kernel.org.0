Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D74165E30
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgBTNGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728169AbgBTNGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijbOoyrS9Jz9oM+Px+EP5Y3MCyoKyJq//TyCsQeLfQM=;
        b=cC3F0XSL7+pfUaUaH8110zN4knVnHqJdyLf1OizFtCqnLbjr2K9DdhLy4+Gpdj/5iwv+kK
        oHn5H60fBp43el5fGYezoK7ccAgVj5GEMytctYGEh03WP9phvYZyNwVRDqiC7w4gO+lq+7
        GaRDoSiK+X2X4wrqPa34rt/AXuIJqgQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-d0d0nP4sP_yCeiHcAhQdnA-1; Thu, 20 Feb 2020 08:06:29 -0500
X-MC-Unique: d0d0nP4sP_yCeiHcAhQdnA-1
Received: by mail-wm1-f72.google.com with SMTP id q125so582423wme.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ijbOoyrS9Jz9oM+Px+EP5Y3MCyoKyJq//TyCsQeLfQM=;
        b=nQmJLLm/1+Vj115MjddvCIeLhyl67eUbi+5TxCKSeMRdP0hOvx1/jvAGLQrS60R08y
         Qo/Q3Tjkv60+eHKw2rebwZxysPSBkaZNUqNoA1WZLcqrq/VVFSZ4VrjDLgGp1sennFlL
         8B2OB/HYsL/lS+Jwls9zE0GfO5eTk5UzpnV7vM9stAZ/Ig+ySSlQEWWqMJPUgRF9/2Eh
         iX6zKHCyuWIFt4bE1sJh7tm9BRa26cfJ5cY1UTRX0Df+AQcu3NMaDCSpzz/I/FVQUAFR
         0z02WV6d8iy2yGYfrbDFOWKlz1QPblkpVc0EMjTM2EMsaE0//rJP51hqiQs2IcP6T0on
         53xw==
X-Gm-Message-State: APjAAAW49+ycLBdMHZMOmvtu5935PM5QeHamzAZ/uBlQhsES0Y7L7yTC
        GN1nOyC7wmHoWEBS3e6LLv9IgQcOGBoz03ZjwNphDidtnCL4hv0DY4GuERIn4jV4hq6FFbNZgNE
        qnKgeSMNiPJ+e
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr4786399wmi.152.1582203988197;
        Thu, 20 Feb 2020 05:06:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqyZ6/a+oKytvIxV32J43VlbJoelLuLW+rm04bNrtIDR5Tp2LK/nrGilhR3sl09VB9q8vLJTrw==
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr4786351wmi.152.1582203987812;
        Thu, 20 Feb 2020 05:06:27 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:27 -0800 (PST)
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
Subject: [PATCH v3 09/20] exec: Let the cpu_[physical]_memory API use void pointer arguments
Date:   Thu, 20 Feb 2020 14:05:37 +0100
Message-Id: <20200220130548.29974-10-philmd@redhat.com>
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

As we are only dealing with a blob buffer, use a void pointer
argument. This will let us simplify other APIs.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/exec/cpu-all.h    | 2 +-
 include/exec/cpu-common.h | 2 +-
 exec.c                    | 8 +++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index e96781a455..49e96caa3f 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -388,7 +388,7 @@ void dump_opcount_info(void);
 #endif /* !CONFIG_USER_ONLY */
 
 int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
-                        uint8_t *buf, target_ulong len, int is_write);
+                        void *ptr, target_ulong len, int is_write);
 
 int cpu_exec(CPUState *cpu);
 
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 05ac1a5d69..165f8fb621 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -69,7 +69,7 @@ void qemu_ram_unset_migratable(RAMBlock *rb);
 size_t qemu_ram_pagesize(RAMBlock *block);
 size_t qemu_ram_pagesize_largest(void);
 
-void cpu_physical_memory_rw(hwaddr addr, uint8_t *buf,
+void cpu_physical_memory_rw(hwaddr addr, void *buf,
                             hwaddr len, int is_write);
 static inline void cpu_physical_memory_read(hwaddr addr,
                                             void *buf, hwaddr len)
diff --git a/exec.c b/exec.c
index 1a80159996..01437be691 100644
--- a/exec.c
+++ b/exec.c
@@ -3019,11 +3019,12 @@ MemoryRegion *get_system_io(void)
 /* physical memory access (slow version, mainly for debug) */
 #if defined(CONFIG_USER_ONLY)
 int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
-                        uint8_t *buf, target_ulong len, int is_write)
+                        void *ptr, target_ulong len, int is_write)
 {
     int flags;
     target_ulong l, page;
     void * p;
+    uint8_t *buf = ptr;
 
     while (len > 0) {
         page = addr & TARGET_PAGE_MASK;
@@ -3311,7 +3312,7 @@ MemTxResult address_space_rw(AddressSpace *as, hwaddr addr, MemTxAttrs attrs,
     }
 }
 
-void cpu_physical_memory_rw(hwaddr addr, uint8_t *buf,
+void cpu_physical_memory_rw(hwaddr addr, void *buf,
                             hwaddr len, int is_write)
 {
     address_space_rw(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
@@ -3789,10 +3790,11 @@ address_space_write_cached_slow(MemoryRegionCache *cache, hwaddr addr,
 
 /* virtual memory access for debug (includes writing to ROM) */
 int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
-                        uint8_t *buf, target_ulong len, int is_write)
+                        void *ptr, target_ulong len, int is_write)
 {
     hwaddr phys_addr;
     target_ulong l, page;
+    uint8_t *buf = ptr;
 
     cpu_synchronize_state(cpu);
     while (len > 0) {
-- 
2.21.1

