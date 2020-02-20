Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8264A165E2B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgBTNGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48108 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728115AbgBTNGN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQu7r5A36ZEekF4m32GxNBlLjnOkqxofIVmsz5VZ5cY=;
        b=VYOjczAhoyfjENpnkFRJX5Wml7hoySmxVXQpEBqnaGRHBTBY30Y70LJYlGg7jU/yr2aRki
        XqedvkvPUejJc4ViFA7OzjeMJ84NzhbfiPLLeDrkM/R0tvh3RASyvgmBR/qAQYCxH6aet4
        80fKU1wGeb/fG5DsmNyPmjSGUtmhqXE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-9MFw2SXjNISwkSxPnlzfKg-1; Thu, 20 Feb 2020 08:06:10 -0500
X-MC-Unique: 9MFw2SXjNISwkSxPnlzfKg-1
Received: by mail-wr1-f72.google.com with SMTP id m15so1682861wrs.22
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uQu7r5A36ZEekF4m32GxNBlLjnOkqxofIVmsz5VZ5cY=;
        b=mFuYZta4I19T1rqF4EJzt3Bn+3Hc8i+4bV/Lx7Zi/yHO+/o+cWoYL+/bE9KOyVR72Q
         m5qWCaaPv7VYow1ZgpOl5wmxDG1NQErr3KmKHidTtiYLvzHpeE53k82X8EvhUBeuD+uo
         0C84JHkhHhIJgmyzcParEsi/mecPzBcn4+IcSkn7oLpDTekMv3U0+VEGieCkH8ccO9w0
         Grn2mFaAEw/xzMUsUMeUViuG6n1YHsM/y5ElJdALfMsrQZMRfVQKekxKH5nkFGNXfJ8T
         7fSfDGq6oF+qg2VwC666oL3Rb9wUkPMjb5NmJlK8T9lvVMNpLGUoLT29PEdw1645HW+X
         f9pQ==
X-Gm-Message-State: APjAAAUS+otV6lqm86lGI+AYkWKMyQdY6PIw/5PjDOzCyouQUiLjyes1
        UukJUQ4WRPG6X+px76WPALIc6424OXVawgyneXEDHD9BdchfTh5Ry+Z7Nf9FYtUGyQKVrveBZRB
        gYBxeXf5CPeIH
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr4784707wmi.152.1582203968766;
        Thu, 20 Feb 2020 05:06:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqyE66uIDK1qcY0whocMHGuc5UiGXXzMSpfPUxCMQ6ki2ViRoHWEoIvgwkFHTsmW7YQNGkg7QA==
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr4784676wmi.152.1582203968575;
        Thu, 20 Feb 2020 05:06:08 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:08 -0800 (PST)
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
Subject: [PATCH v3 04/20] exec: Rename ram_ptr variable
Date:   Thu, 20 Feb 2020 14:05:32 +0100
Message-Id: <20200220130548.29974-5-philmd@redhat.com>
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

As we are going to use a different 'ptr' variable, rename the 'ram
pointer' variable.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 exec.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/exec.c b/exec.c
index 02b4e6ea41..06e386dc72 100644
--- a/exec.c
+++ b/exec.c
@@ -3151,7 +3151,7 @@ static MemTxResult flatview_write_continue(FlatView *fv, hwaddr addr,
                                            hwaddr len, hwaddr addr1,
                                            hwaddr l, MemoryRegion *mr)
 {
-    uint8_t *ptr;
+    uint8_t *ram_ptr;
     uint64_t val;
     MemTxResult result = MEMTX_OK;
     bool release_lock = false;
@@ -3167,8 +3167,8 @@ static MemTxResult flatview_write_continue(FlatView *fv, hwaddr addr,
                                                    size_memop(l), attrs);
         } else {
             /* RAM case */
-            ptr = qemu_ram_ptr_length(mr->ram_block, addr1, &l, false);
-            memcpy(ptr, buf, l);
+            ram_ptr = qemu_ram_ptr_length(mr->ram_block, addr1, &l, false);
+            memcpy(ram_ptr, buf, l);
             invalidate_and_set_dirty(mr, addr1, l);
         }
 
@@ -3215,7 +3215,7 @@ MemTxResult flatview_read_continue(FlatView *fv, hwaddr addr,
                                    hwaddr len, hwaddr addr1, hwaddr l,
                                    MemoryRegion *mr)
 {
-    uint8_t *ptr;
+    uint8_t *ram_ptr;
     uint64_t val;
     MemTxResult result = MEMTX_OK;
     bool release_lock = false;
@@ -3230,8 +3230,8 @@ MemTxResult flatview_read_continue(FlatView *fv, hwaddr addr,
             stn_he_p(buf, l, val);
         } else {
             /* RAM case */
-            ptr = qemu_ram_ptr_length(mr->ram_block, addr1, &l, false);
-            memcpy(buf, ptr, l);
+            ram_ptr = qemu_ram_ptr_length(mr->ram_block, addr1, &l, false);
+            memcpy(buf, ram_ptr, l);
         }
 
         if (release_lock) {
@@ -3329,7 +3329,7 @@ static inline MemTxResult address_space_write_rom_internal(AddressSpace *as,
                                                            enum write_rom_type type)
 {
     hwaddr l;
-    uint8_t *ptr;
+    uint8_t *ram_ptr;
     hwaddr addr1;
     MemoryRegion *mr;
 
@@ -3343,14 +3343,14 @@ static inline MemTxResult address_space_write_rom_internal(AddressSpace *as,
             l = memory_access_size(mr, l, addr1);
         } else {
             /* ROM/RAM case */
-            ptr = qemu_map_ram_ptr(mr->ram_block, addr1);
+            ram_ptr = qemu_map_ram_ptr(mr->ram_block, addr1);
             switch (type) {
             case WRITE_DATA:
-                memcpy(ptr, buf, l);
+                memcpy(ram_ptr, buf, l);
                 invalidate_and_set_dirty(mr, addr1, l);
                 break;
             case FLUSH_CACHE:
-                flush_icache_range((uintptr_t)ptr, (uintptr_t)ptr + l);
+                flush_icache_range((uintptr_t)ram_ptr, (uintptr_t)ram_ptr + l);
                 break;
             }
         }
-- 
2.21.1

