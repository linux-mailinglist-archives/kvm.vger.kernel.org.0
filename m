Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBB1165E35
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgBTNGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25997 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728183AbgBTNGn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:06:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afmBLGH/B/Ms0UWZ94UmoIT7hbpf9let5QJOgK6MO7U=;
        b=Yg7aTLmh5YEeYhixivAegQA52T19jAXtnRscDvq7xxLfkZcqRGj4W7Z039pRcuHsp7DlnL
        1euyAIFQ8PouAS/gHL6MVoxHY75Py9M3/qmTQmX3pcTr14mrsmubURmwqoD70ASeBCBlfH
        W0v6qD/NuVdUNIOZhifDqrRnBiPthjE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-XK0m2gWDNyqxXoUKhRgZtQ-1; Thu, 20 Feb 2020 08:06:40 -0500
X-MC-Unique: XK0m2gWDNyqxXoUKhRgZtQ-1
Received: by mail-wr1-f69.google.com with SMTP id r1so1700327wrc.15
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afmBLGH/B/Ms0UWZ94UmoIT7hbpf9let5QJOgK6MO7U=;
        b=e4gn/+0nnZ0HJ0VcnO3jbsLcT9GJ6hMsZoI5QNNAUeDSCpI0kZ8vBEgcCpa1l6GL1v
         EbQA67N13XtBSYlgVNwqMZM0oe2jjJNauTmpMdK0RZ35UGkCYJGLSn6AtsZ0KkYK5hRc
         itqxnnP042FEuTNEWibbn2bF1AjJ/cLkcqqBv2dGY8ZdIvYZ4TOdSeGQ2i7wfW+rO22n
         vu9uefnLY0QJHMwzeJvZz72kn5Yrx3HuO8uDFJFdzOcddxYPSS55gdgG2Mu8k2+haCp/
         GowofxYo85Ow+xZnBy/EXjuPb9lZd43dHxUKxSwZ1zst2JpNdnY61xXJWYCzqIiq62kL
         ElxQ==
X-Gm-Message-State: APjAAAVCunoqvWMihZ/9Bvw5frpQBxZ5Dw9gaW96dn6Os5z69kdMJX0h
        Z4JeYnaArHMr1urpTRS2i6cVigHkRcN/7G/n3yAtAs/4blSLdjetCPpslzWGZTOTULtdZ5frOtw
        3QKWi3aG/QHM2
X-Received: by 2002:adf:82ce:: with SMTP id 72mr42311835wrc.14.1582203999000;
        Thu, 20 Feb 2020 05:06:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqw/3uQMphtI1ikMZVT/CqYmBN8hXBmJPGI/dMUcHwpK44vfqMtR6BuBqN22Zj6SP9un5Qj48Q==
X-Received: by 2002:adf:82ce:: with SMTP id 72mr42311818wrc.14.1582203998804;
        Thu, 20 Feb 2020 05:06:38 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:38 -0800 (PST)
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
Subject: [PATCH v3 12/20] hw/ide: Let the DMAIntFunc prototype use a boolean 'is_write' argument
Date:   Thu, 20 Feb 2020 14:05:40 +0100
Message-Id: <20200220130548.29974-13-philmd@redhat.com>
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
 include/hw/ide/internal.h | 2 +-
 hw/dma/rc4030.c           | 6 +++---
 hw/ide/ahci.c             | 2 +-
 hw/ide/core.c             | 2 +-
 hw/ide/macio.c            | 2 +-
 hw/ide/pci.c              | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/hw/ide/internal.h b/include/hw/ide/internal.h
index ce766ac485..1bc1fc73e5 100644
--- a/include/hw/ide/internal.h
+++ b/include/hw/ide/internal.h
@@ -322,7 +322,7 @@ typedef void EndTransferFunc(IDEState *);
 
 typedef void DMAStartFunc(IDEDMA *, IDEState *, BlockCompletionFunc *);
 typedef void DMAVoidFunc(IDEDMA *);
-typedef int DMAIntFunc(IDEDMA *, int);
+typedef int DMAIntFunc(IDEDMA *, bool);
 typedef int32_t DMAInt32Func(IDEDMA *, int32_t len);
 typedef void DMAu32Func(IDEDMA *, uint32_t);
 typedef void DMAStopFunc(IDEDMA *, bool);
diff --git a/hw/dma/rc4030.c b/hw/dma/rc4030.c
index ca0becd756..21e2c360ac 100644
--- a/hw/dma/rc4030.c
+++ b/hw/dma/rc4030.c
@@ -590,7 +590,7 @@ static const VMStateDescription vmstate_rc4030 = {
 };
 
 static void rc4030_do_dma(void *opaque, int n, uint8_t *buf,
-                          int len, int is_write)
+                          int len, bool is_write)
 {
     rc4030State *s = opaque;
     hwaddr dma_addr;
@@ -630,13 +630,13 @@ struct rc4030DMAState {
 void rc4030_dma_read(void *dma, uint8_t *buf, int len)
 {
     rc4030_dma s = dma;
-    rc4030_do_dma(s->opaque, s->n, buf, len, 0);
+    rc4030_do_dma(s->opaque, s->n, buf, len, false);
 }
 
 void rc4030_dma_write(void *dma, uint8_t *buf, int len)
 {
     rc4030_dma s = dma;
-    rc4030_do_dma(s->opaque, s->n, buf, len, 1);
+    rc4030_do_dma(s->opaque, s->n, buf, len, true);
 }
 
 static rc4030_dma *rc4030_allocate_dmas(void *opaque, int n)
diff --git a/hw/ide/ahci.c b/hw/ide/ahci.c
index 68264a22e8..13d91e109a 100644
--- a/hw/ide/ahci.c
+++ b/hw/ide/ahci.c
@@ -1461,7 +1461,7 @@ static void ahci_commit_buf(IDEDMA *dma, uint32_t tx_bytes)
     ad->cur_cmd->status = cpu_to_le32(tx_bytes);
 }
 
-static int ahci_dma_rw_buf(IDEDMA *dma, int is_write)
+static int ahci_dma_rw_buf(IDEDMA *dma, bool is_write)
 {
     AHCIDevice *ad = DO_UPCAST(AHCIDevice, dma, dma);
     IDEState *s = &ad->port.ifs[0];
diff --git a/hw/ide/core.c b/hw/ide/core.c
index 80000eb766..689bb36409 100644
--- a/hw/ide/core.c
+++ b/hw/ide/core.c
@@ -2570,7 +2570,7 @@ static void ide_init1(IDEBus *bus, int unit)
                                            ide_sector_write_timer_cb, s);
 }
 
-static int ide_nop_int(IDEDMA *dma, int x)
+static int ide_nop_int(IDEDMA *dma, bool is_write)
 {
     return 0;
 }
diff --git a/hw/ide/macio.c b/hw/ide/macio.c
index 7a8470e921..a9f25e5d02 100644
--- a/hw/ide/macio.c
+++ b/hw/ide/macio.c
@@ -376,7 +376,7 @@ static void macio_ide_reset(DeviceState *dev)
     ide_bus_reset(&d->bus);
 }
 
-static int ide_nop_int(IDEDMA *dma, int x)
+static int ide_nop_int(IDEDMA *dma, bool is_write)
 {
     return 0;
 }
diff --git a/hw/ide/pci.c b/hw/ide/pci.c
index cce1da804d..1a6a287e76 100644
--- a/hw/ide/pci.c
+++ b/hw/ide/pci.c
@@ -181,7 +181,7 @@ static int32_t bmdma_prepare_buf(IDEDMA *dma, int32_t limit)
 }
 
 /* return 0 if buffer completed */
-static int bmdma_rw_buf(IDEDMA *dma, int is_write)
+static int bmdma_rw_buf(IDEDMA *dma, bool is_write)
 {
     BMDMAState *bm = DO_UPCAST(BMDMAState, dma, dma);
     IDEState *s = bmdma_active_if(bm);
-- 
2.21.1

