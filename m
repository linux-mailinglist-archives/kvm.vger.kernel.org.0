Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D869F165E2E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgBTNGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51339 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728160AbgBTNGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pVKWVWwp9TVJU5qM7Beut+kG2DV5MFLYTF1Kx3cmH3A=;
        b=VOz5yQVt6lLlJ18HbJIoxtfPaQuyZsRZS+Idit5RuiTOIOMQe1muWY6NfGX6SwK3FTXQM0
        PBl9g8NYoMhNdFavxU44/f3trtSAETGjVmTRbOer1/ozgoxSr+OuwAkVSV07sQcZNeTEj3
        I7iYIQHho/vJ87u4vJEf9dWZxsbXJBY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-j_HWigesOYm-9cLnjZwJWg-1; Thu, 20 Feb 2020 08:06:21 -0500
X-MC-Unique: j_HWigesOYm-9cLnjZwJWg-1
Received: by mail-wr1-f72.google.com with SMTP id m15so1683027wrs.22
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pVKWVWwp9TVJU5qM7Beut+kG2DV5MFLYTF1Kx3cmH3A=;
        b=jldAPeJX01RIhmdzF3ktwUBUe45tLYyIAZ23mNTT3nShGZOgpuM2cZGO4CkYTa+TgV
         4bvB96f9op1oalqv6BzcHIr1Q37biXROUmFfk2u7DOE4PSy7uPla9CAf3aEKVFk5JcXl
         OcG/U8yqDskyycwG31IyBSD4h3Y276FKEZxRnE2i3FseJFvS1REun8L2oe5RNuMWmIPS
         kNYT8y0ADatchH9MKRi3AtsyxNiIjQMFcJpyLVew3ZmCetPydNghFLYL0KjoBpcrnygs
         Lvc9RCCrTmbZtza1EDfuUFyBQdeVdIwW9V7aHQ+1ADCw9qv2N0Xh2+uxx9lIy7VHlqYu
         hCHQ==
X-Gm-Message-State: APjAAAW9nj0TA0L9yYZ0v9K3pcZVjBKbUdXDecZcC5dETvnaLUk1GSJn
        F+lX3hBPm1QTET7WObDr0XW6e4aLUA9CYVz4MXlIlNXpP2dgddaxkp8hV8oaGvEQgnB4x00ZJfF
        5jEYqCgtSi7Jv
X-Received: by 2002:a5d:4687:: with SMTP id u7mr40881734wrq.176.1582203980204;
        Thu, 20 Feb 2020 05:06:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwfQdFudKu/IvbI9dQMK95qUdVs2MjCpL2sBTVu5yezv4G1pdvxpKJvTb+aMe+m36JC5h7NRg==
X-Received: by 2002:a5d:4687:: with SMTP id u7mr40881691wrq.176.1582203979939;
        Thu, 20 Feb 2020 05:06:19 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:19 -0800 (PST)
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
Subject: [PATCH v3 07/20] hw/net: Avoid casting non-const pointer, use address_space_write()
Date:   Thu, 20 Feb 2020 14:05:35 +0100
Message-Id: <20200220130548.29974-8-philmd@redhat.com>
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

The NetReceive prototype gets a const buffer:

  typedef ssize_t (NetReceive)(NetClientState *, const uint8_t *, size_t);

We already have the address_space_write() method to write a const
buffer to an address space. Use it to avoid:

  hw/net/i82596.c: In function ‘i82596_receive’:
  hw/net/i82596.c:644:54: error: passing argument 4 of ‘address_space_rw’ discards ‘const’ qualifier from pointer target type [-Werror=discarded-qualifiers]

This commit was produced with the included Coccinelle script
scripts/coccinelle/exec_rw_const.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/coccinelle/exec_rw_const.cocci | 14 ++++++++++++++
 hw/net/dp8393x.c                       |  3 +--
 hw/net/i82596.c                        |  4 ++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
index a0054f009d..4e459d915b 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -1,6 +1,20 @@
 // Usage:
 //  spatch --sp-file scripts/coccinelle/exec_rw_const.cocci --dir . --in-place
 
+// Use address_space_write instead of casting to non-const
+@@
+type T;
+const T *V;
+expression E1, E2, E3, E4;
+@@
+(
+- address_space_rw(E1, E2, E3, (T *)V, E4, 1)
++ address_space_write(E1, E2, E3, V, E4)
+|
+- address_space_rw(E1, E2, E3, (void *)V, E4, 1)
++ address_space_write(E1, E2, E3, V, E4)
+)
+
 // Remove useless cast
 @@
 expression E1, E2, E3, E4;
diff --git a/hw/net/dp8393x.c b/hw/net/dp8393x.c
index a134d431ae..580ae4437e 100644
--- a/hw/net/dp8393x.c
+++ b/hw/net/dp8393x.c
@@ -787,8 +787,7 @@ static ssize_t dp8393x_receive(NetClientState *nc, const uint8_t * buf,
     /* Put packet into RBA */
     DPRINTF("Receive packet at %08x\n", dp8393x_crba(s));
     address = dp8393x_crba(s);
-    address_space_rw(&s->as, address,
-        MEMTXATTRS_UNSPECIFIED, (uint8_t *)buf, rx_len, 1);
+    address_space_write(&s->as, address, MEMTXATTRS_UNSPECIFIED, buf, rx_len);
     address += rx_len;
     address_space_rw(&s->as, address,
         MEMTXATTRS_UNSPECIFIED, (uint8_t *)&checksum, 4, 1);
diff --git a/hw/net/i82596.c b/hw/net/i82596.c
index 3a0e1ec4c0..a292984e06 100644
--- a/hw/net/i82596.c
+++ b/hw/net/i82596.c
@@ -640,8 +640,8 @@ ssize_t i82596_receive(NetClientState *nc, const uint8_t *buf, size_t sz)
             }
             rba = get_uint32(rbd + 8);
             /* printf("rba is 0x%x\n", rba); */
-            address_space_rw(&address_space_memory, rba,
-                MEMTXATTRS_UNSPECIFIED, (void *)buf, num, 1);
+            address_space_write(&address_space_memory, rba,
+                                MEMTXATTRS_UNSPECIFIED, buf, num);
             rba += num;
             buf += num;
             len -= num;
-- 
2.21.1

