Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871EB3754E2
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhEFNjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234397AbhEFNjP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cm48fhhROvZKoiSjxSIRZaypJ/0uOwpu6MiKB+h4o3c=;
        b=QwOA8MGZw5yNjkGiNvOVTG0Lpo2g98zw8x09pI9+On/34si0dFXy1vTya420EDtwUtDbtY
        TTrEJEzW0ASra1HCajfWzJDejZwHuFQe+1QMk64mQ9dQGrwRp+rGdnIaoVdU/szlDviHop
        oXiFPoz7rb0Viz+3T4oFMl4QPfxfHrs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374--U6R7aSvMLqqAmp5pTL9Fw-1; Thu, 06 May 2021 09:38:11 -0400
X-MC-Unique: -U6R7aSvMLqqAmp5pTL9Fw-1
Received: by mail-wr1-f70.google.com with SMTP id p19-20020adfc3930000b029010e10128a04so2206105wrf.3
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cm48fhhROvZKoiSjxSIRZaypJ/0uOwpu6MiKB+h4o3c=;
        b=E8MbD9gumLgvAswOEXtI23M2TNYWb4PwfbxQ8ONdbtvdjnZsGDing4DRPtYeWcAtta
         QVPN36jxIW7D8oeW612sWuKnrCfQqsy0/tdaTi0mj7I8z2NJL5RxW7x9+ijqJbFJmf2E
         Rt2E84ifHFmoaKkjDIR9Zdpu00h2pYT5Z/+MPHzqV564OCedlA1mr8oqZE8Jr9hNa9za
         4yRU8YLKmzRwelbV6pQtKMx5fqmRW6bANE4aLA/wEajKmPMTFmtKqqcB08qRIfAWk92n
         G6gnBw4y3RW5oMhxY+9PSLAKAoGZ8R3W8OjVqVbhf60eXZ30wq5DJ4SuGk/zL8T8uIbJ
         oaFw==
X-Gm-Message-State: AOAM5327cKg5GzOag836dPNsy6czaDdzLvRKHVz6+NKwOYPCPYIdP5wO
        iMEwYFuqhRTLhuikWYdydN6Qx0lgN7dfprlNZnI3nj+1GjzoNPbylY4euwtF8dJzZFZ1dBYgIjS
        L93ggpWjAORb0
X-Received: by 2002:a5d:64c4:: with SMTP id f4mr5076470wri.178.1620308289927;
        Thu, 06 May 2021 06:38:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1qLH+TeCACwmkPszo5iNqlWWZLZHj+h1hLu6j1DGNALRbLHKlnd4elCwd5Ol0yGq3nkA99w==
X-Received: by 2002:a5d:64c4:: with SMTP id f4mr5076448wri.178.1620308289821;
        Thu, 06 May 2021 06:38:09 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id j18sm3230757wmq.27.2021.05.06.06.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:38:09 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v2 2/9] backends/tpm: Replace qemu_mutex_lock calls with QEMU_LOCK_GUARD
Date:   Thu,  6 May 2021 15:37:51 +0200
Message-Id: <20210506133758.1749233-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210506133758.1749233-1-philmd@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify the tpm_emulator_ctrlcmd() handler by replacing a pair of
qemu_mutex_lock/qemu_mutex_unlock calls by the WITH_QEMU_LOCK_GUARD
macro.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 backends/tpm/tpm_emulator.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/backends/tpm/tpm_emulator.c b/backends/tpm/tpm_emulator.c
index a012adc1934..e5f1063ab6c 100644
--- a/backends/tpm/tpm_emulator.c
+++ b/backends/tpm/tpm_emulator.c
@@ -30,6 +30,7 @@
 #include "qemu/error-report.h"
 #include "qemu/module.h"
 #include "qemu/sockets.h"
+#include "qemu/lockable.h"
 #include "io/channel-socket.h"
 #include "sysemu/tpm_backend.h"
 #include "sysemu/tpm_util.h"
@@ -124,31 +125,26 @@ static int tpm_emulator_ctrlcmd(TPMEmulator *tpm, unsigned long cmd, void *msg,
     uint32_t cmd_no = cpu_to_be32(cmd);
     ssize_t n = sizeof(uint32_t) + msg_len_in;
     uint8_t *buf = NULL;
-    int ret = -1;
 
-    qemu_mutex_lock(&tpm->mutex);
+    WITH_QEMU_LOCK_GUARD(&tpm->mutex) {
+        buf = g_alloca(n);
+        memcpy(buf, &cmd_no, sizeof(cmd_no));
+        memcpy(buf + sizeof(cmd_no), msg, msg_len_in);
 
-    buf = g_alloca(n);
-    memcpy(buf, &cmd_no, sizeof(cmd_no));
-    memcpy(buf + sizeof(cmd_no), msg, msg_len_in);
-
-    n = qemu_chr_fe_write_all(dev, buf, n);
-    if (n <= 0) {
-        goto end;
-    }
-
-    if (msg_len_out != 0) {
-        n = qemu_chr_fe_read_all(dev, msg, msg_len_out);
+        n = qemu_chr_fe_write_all(dev, buf, n);
         if (n <= 0) {
-            goto end;
+            return -1;
+        }
+
+        if (msg_len_out != 0) {
+            n = qemu_chr_fe_read_all(dev, msg, msg_len_out);
+            if (n <= 0) {
+                return -1;
+            }
         }
     }
 
-    ret = 0;
-
-end:
-    qemu_mutex_unlock(&tpm->mutex);
-    return ret;
+    return 0;
 }
 
 static int tpm_emulator_unix_tx_bufs(TPMEmulator *tpm_emu,
-- 
2.26.3

