Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B61165E2A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgBTNGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55176 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728114AbgBTNGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:06:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8odk76d2z3izhK+yPuh+zYi/Cj4FHaZPMzDDqjJ0XeE=;
        b=YCpCq2pXOtLFGTShEFq0RZZ/S/ZfrjkulMnvcAIoja0IOzePIQgQe9AzgjTqHBKS31FcGm
        gHXPabK6oCBvXW4+1wKKfui7wVOIQFi2ruhvrQum0lZ0mpaWbMkbfvtL5L7n0OQwpLukMY
        Ag/0fap2q/Uuaugx0SAQo+zN5mdXVf0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56--YlLcAl2PfOvzevvfk78rQ-1; Thu, 20 Feb 2020 08:06:06 -0500
X-MC-Unique: -YlLcAl2PfOvzevvfk78rQ-1
Received: by mail-wm1-f72.google.com with SMTP id u11so802782wmb.4
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8odk76d2z3izhK+yPuh+zYi/Cj4FHaZPMzDDqjJ0XeE=;
        b=Zgzq2TB4G4Qeg1IwTvW9gQPrpZT5Q658d81+qKgC+AwWrAo2+uYxFcFGsS8MBHCWVf
         QT/A6uJlxTjbjgGC2AtOcGoanukgmJrHyBa1DXFOhArDEBjjEyWGfYRxzTjnEqIdw9po
         j0cB0QWzEeZPMXd1CR1uuTptvq4yp0bqbNNvc0c3NiHgd+lOJm1Ku+bvhe7QyP1WSkLB
         7F50ZOF3CAa3ih5uzVSiWACOGWFiygVVN2Sa0vlimGuSMyOtNrpqbgn9mPmferdshmIg
         APynmWcNFIpqNIDW2ptEWkE2E5ezYJHRcA/UB1xZ9rN2Az/1SwsFi2AHJ3gEG2/+24BX
         7cUg==
X-Gm-Message-State: APjAAAXfDcMVjANF2qOIvYGCGQvxJ6t5yZtVuZq5BYQaN9+NOVCtK22n
        0WcHqQVIeyChpCWwSkv0eFfbR6rirUTMYhJNqWXK+DZTE2i1fyYiRcAV90aMfvzkvoCbQjZbVn1
        HarVOE1Tshz5C
X-Received: by 2002:a5d:4e91:: with SMTP id e17mr40459252wru.233.1582203965282;
        Thu, 20 Feb 2020 05:06:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYyC0rm9Zmq8Udvt5K4WfGoUA6AsKImvpwZLE6azxpWra0StVD53WtA0C45GVywJSMzTwuwQ==
X-Received: by 2002:a5d:4e91:: with SMTP id e17mr40459189wru.233.1582203964946;
        Thu, 20 Feb 2020 05:06:04 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:04 -0800 (PST)
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
Subject: [PATCH v3 03/20] exec: Let qemu_ram_*() functions take a const pointer argument
Date:   Thu, 20 Feb 2020 14:05:31 +0100
Message-Id: <20200220130548.29974-4-philmd@redhat.com>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/exec/cpu-common.h     | 6 +++---
 include/sysemu/xen-mapcache.h | 4 ++--
 exec.c                        | 8 ++++----
 hw/i386/xen/xen-mapcache.c    | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 81753bbb34..05ac1a5d69 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -48,11 +48,11 @@ typedef uint32_t CPUReadMemoryFunc(void *opaque, hwaddr addr);
 
 void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
 /* This should not be used by devices.  */
-ram_addr_t qemu_ram_addr_from_host(void *ptr);
+ram_addr_t qemu_ram_addr_from_host(const void *ptr);
 RAMBlock *qemu_ram_block_by_name(const char *name);
-RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
+RAMBlock *qemu_ram_block_from_host(const void *ptr, bool round_offset,
                                    ram_addr_t *offset);
-ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host);
+ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, const void *host);
 void qemu_ram_set_idstr(RAMBlock *block, const char *name, DeviceState *dev);
 void qemu_ram_unset_idstr(RAMBlock *block);
 const char *qemu_ram_get_idstr(RAMBlock *rb);
diff --git a/include/sysemu/xen-mapcache.h b/include/sysemu/xen-mapcache.h
index c8e7c2f6cf..81e9aa2fa6 100644
--- a/include/sysemu/xen-mapcache.h
+++ b/include/sysemu/xen-mapcache.h
@@ -19,7 +19,7 @@ void xen_map_cache_init(phys_offset_to_gaddr_t f,
                         void *opaque);
 uint8_t *xen_map_cache(hwaddr phys_addr, hwaddr size,
                        uint8_t lock, bool dma);
-ram_addr_t xen_ram_addr_from_mapcache(void *ptr);
+ram_addr_t xen_ram_addr_from_mapcache(const void *ptr);
 void xen_invalidate_map_cache_entry(uint8_t *buffer);
 void xen_invalidate_map_cache(void);
 uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
@@ -40,7 +40,7 @@ static inline uint8_t *xen_map_cache(hwaddr phys_addr,
     abort();
 }
 
-static inline ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
+static inline ram_addr_t xen_ram_addr_from_mapcache(const void *ptr)
 {
     abort();
 }
diff --git a/exec.c b/exec.c
index 8e9cc3b47c..02b4e6ea41 100644
--- a/exec.c
+++ b/exec.c
@@ -2614,7 +2614,7 @@ static void *qemu_ram_ptr_length(RAMBlock *ram_block, ram_addr_t addr,
 }
 
 /* Return the offset of a hostpointer within a ramblock */
-ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host)
+ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, const void *host)
 {
     ram_addr_t res = (uint8_t *)host - (uint8_t *)rb->host;
     assert((uintptr_t)host >= (uintptr_t)rb->host);
@@ -2640,11 +2640,11 @@ ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host)
  * pointer, such as a reference to the region that includes the incoming
  * ram_addr_t.
  */
-RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
+RAMBlock *qemu_ram_block_from_host(const void *ptr, bool round_offset,
                                    ram_addr_t *offset)
 {
     RAMBlock *block;
-    uint8_t *host = ptr;
+    const uint8_t *host = ptr;
 
     if (xen_enabled()) {
         ram_addr_t ram_addr;
@@ -2705,7 +2705,7 @@ RAMBlock *qemu_ram_block_by_name(const char *name)
 
 /* Some of the softmmu routines need to translate from a host pointer
    (typically a TLB entry) back to a ram offset.  */
-ram_addr_t qemu_ram_addr_from_host(void *ptr)
+ram_addr_t qemu_ram_addr_from_host(const void *ptr)
 {
     RAMBlock *block;
     ram_addr_t offset;
diff --git a/hw/i386/xen/xen-mapcache.c b/hw/i386/xen/xen-mapcache.c
index 5b120ed44b..432ad3354d 100644
--- a/hw/i386/xen/xen-mapcache.c
+++ b/hw/i386/xen/xen-mapcache.c
@@ -363,7 +363,7 @@ uint8_t *xen_map_cache(hwaddr phys_addr, hwaddr size,
     return p;
 }
 
-ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
+ram_addr_t xen_ram_addr_from_mapcache(const void *ptr)
 {
     MapCacheEntry *entry = NULL;
     MapCacheRev *reventry;
-- 
2.21.1

