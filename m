Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6AB0165E3A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgBTNHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:07:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27224 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728130AbgBTNHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:07:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3GOpiWMITxx9TtgKrEdUBt5MYBhcyKxmOeh0GtNqL3Q=;
        b=SHvFbKWJkc2EO4i/EDTJtWjzC5yIN52VQV4GOJ+kyD52H1Z3KDPXklx2vV9l7i02pptMk/
        CWJHqS7KuXlbaO7dD/x5S2SlM/LCaG1Ll61RobTuIXNJNxo1gWHSw0giWoWr4ylBsymY3d
        YqLgZGutsMHpaDUr1DVrhEScH69p6yw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-sCR8Z1z9NB2f9tAH9TLmeA-1; Thu, 20 Feb 2020 08:07:03 -0500
X-MC-Unique: sCR8Z1z9NB2f9tAH9TLmeA-1
Received: by mail-wm1-f71.google.com with SMTP id b205so807387wmh.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:07:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3GOpiWMITxx9TtgKrEdUBt5MYBhcyKxmOeh0GtNqL3Q=;
        b=pzIwXNM9Ptt46DTKVM5x/LO3k05/ZsL1wO1q2QoKcp8VcG+035FJlvs5m1gRT6R98J
         5gdyEkuMA+EED+K+QHhlkiS7iVeqAVVBuIa6+SEf4hnJbExvpdiLWNWY97hHdtxFpbWh
         6sb+DTnI4090LO0dZLB7ZolDMV9JYJIGLRJhe7vn2IwwBtteX3tnxcl1u8WZqrEHqZsl
         dQWn4iW1S+UKuadHD1qCRv+JoB34pmRtinSYRzyY7Dt/FR0ZADeiU4VQDMKDAEI2rXr+
         fVmL7DzrdeD2niXun43E7je85bvv/0/Vm1TJyUipMggnw+O866g2qNeaQSUoapd/OFA7
         c/Yw==
X-Gm-Message-State: APjAAAX41s3QB5fpnCv4ur0TGjp+XKfBB/pQq3c0gqRtQCZB7R4ruNAK
        mMk16GwLA3lngcC2RcEX+oHUYhYcX5F6zqbxBd/2gO9fi6X6jSAPHXoKmi2maiLt8adsqHj9B1U
        z6xRqrjfm4T4l
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr4438704wme.28.1582204021862;
        Thu, 20 Feb 2020 05:07:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5fs9il9OncKFrjhrarKjFKFUysaRlKljcdDwQycfDDjjbJaA7nUH+Kd8+rszknwLmOaxWsA==
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr4438660wme.28.1582204021604;
        Thu, 20 Feb 2020 05:07:01 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:07:01 -0800 (PST)
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
Subject: [PATCH v3 18/20] exec: Let cpu_[physical]_memory API use a boolean 'is_write' argument
Date:   Thu, 20 Feb 2020 14:05:46 +0100
Message-Id: <20200220130548.29974-19-philmd@redhat.com>
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

The 'is_write' argument is either 0 or 1.
Convert it to a boolean type.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/exec/cpu-all.h    |  2 +-
 include/exec/cpu-common.h |  6 +++---
 exec.c                    | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 49e96caa3f..49384bb66a 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -388,7 +388,7 @@ void dump_opcount_info(void);
 #endif /* !CONFIG_USER_ONLY */
 
 int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
-                        void *ptr, target_ulong len, int is_write);
+                        void *ptr, target_ulong len, bool is_write);
 
 int cpu_exec(CPUState *cpu);
 
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 165f8fb621..6bfe201779 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -70,7 +70,7 @@ size_t qemu_ram_pagesize(RAMBlock *block);
 size_t qemu_ram_pagesize_largest(void);
 
 void cpu_physical_memory_rw(hwaddr addr, void *buf,
-                            hwaddr len, int is_write);
+                            hwaddr len, bool is_write);
 static inline void cpu_physical_memory_read(hwaddr addr,
                                             void *buf, hwaddr len)
 {
@@ -83,9 +83,9 @@ static inline void cpu_physical_memory_write(hwaddr addr,
 }
 void *cpu_physical_memory_map(hwaddr addr,
                               hwaddr *plen,
-                              int is_write);
+                              bool is_write);
 void cpu_physical_memory_unmap(void *buffer, hwaddr len,
-                               int is_write, hwaddr access_len);
+                               bool is_write, hwaddr access_len);
 void cpu_register_map_client(QEMUBH *bh);
 void cpu_unregister_map_client(QEMUBH *bh);
 
diff --git a/exec.c b/exec.c
index b79919a4f7..6c39b43155 100644
--- a/exec.c
+++ b/exec.c
@@ -3019,7 +3019,7 @@ MemoryRegion *get_system_io(void)
 /* physical memory access (slow version, mainly for debug) */
 #if defined(CONFIG_USER_ONLY)
 int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
-                        void *ptr, target_ulong len, int is_write)
+                        void *ptr, target_ulong len, bool is_write)
 {
     int flags;
     target_ulong l, page;
@@ -3313,7 +3313,7 @@ MemTxResult address_space_rw(AddressSpace *as, hwaddr addr, MemTxAttrs attrs,
 }
 
 void cpu_physical_memory_rw(hwaddr addr, void *buf,
-                            hwaddr len, int is_write)
+                            hwaddr len, bool is_write)
 {
     address_space_rw(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
                      buf, len, is_write);
@@ -3632,14 +3632,14 @@ void address_space_unmap(AddressSpace *as, void *buffer, hwaddr len,
 
 void *cpu_physical_memory_map(hwaddr addr,
                               hwaddr *plen,
-                              int is_write)
+                              bool is_write)
 {
     return address_space_map(&address_space_memory, addr, plen, is_write,
                              MEMTXATTRS_UNSPECIFIED);
 }
 
 void cpu_physical_memory_unmap(void *buffer, hwaddr len,
-                               int is_write, hwaddr access_len)
+                               bool is_write, hwaddr access_len)
 {
     return address_space_unmap(&address_space_memory, buffer, len, is_write, access_len);
 }
@@ -3790,7 +3790,7 @@ address_space_write_cached_slow(MemoryRegionCache *cache, hwaddr addr,
 
 /* virtual memory access for debug (includes writing to ROM) */
 int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
-                        void *ptr, target_ulong len, int is_write)
+                        void *ptr, target_ulong len, bool is_write)
 {
     hwaddr phys_addr;
     target_ulong l, page;
-- 
2.21.1

