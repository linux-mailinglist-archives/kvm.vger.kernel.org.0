Return-Path: <kvm+bounces-60459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1592BEEC94
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D8571898F94
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6ADB238D52;
	Sun, 19 Oct 2025 21:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jAwKbTk8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447CB23817E
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907820; cv=none; b=NBcCntKL9Cy2G7lmPJ6WnUaKILQz7/RR+Aue0KziJpYyptPrhQUTnR618buxVZ13LkVZxNIqx7vf21Ao5AFWBOPxM0TPBi9KJ1nFAvhDSgvzOt0+pKZbdL4o34kKqEASZQFOkQdA/cTnbrJvBWA8l3SiHrS9yh+qZdz+3pnIJrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907820; c=relaxed/simple;
	bh=IOOMnzzwp3i4tTVSmLMwLE3BmaS/VCL8NO2bzbxFJRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXaj0HzBP5sXlt6e1O/heUin9GcNqlTSoUu0AvTxAXm0JoEvL1Nhw0wOzfbdT931fQaUBD573htNw6+SRqYU2/eFZAmjrjHj7zgp/Y4UaJwZAMoWpns1UjRBYAxWuf1cmYRzYIINPJFZHAeD7FOD436FFVXH/Q38ea0MTvyanSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jAwKbTk8; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63994113841so6291578a12.3
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907817; x=1761512617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BM6QgAOG34zDGb9jZI8DkkbGa1KuVCoA2kRHxsUOX8Q=;
        b=jAwKbTk8/A5x/SWQTdoRnACJfWdp0iQmG0x/MDRDbFQV94A8s2fKatYmBoBEDIQEQI
         Vp7d9iFOnQsdqpQrbWz4WV+nrYYQjW7ntdXh4lIOuhCm77/tHIKSqawZUXfOVBELxIHS
         WDI+wQT/pkMX86Q148FuKdnGLUMZbY97ndtN9nxtKf3yU859zE5UaeSE1yFDHMJUQA+4
         41b4MmuIkB2X3BLehu/E1iXYAGVxYQUg5l10Hq7FkHO8lROfHRDPdlfQV8Nb6+1+pXvj
         6q+8lL4y5n3JlMwtDmtfTNYtKuO7qv75FZu7lYFBBaU8nu30A2qNzBoE5xaK0n1QFyvY
         CdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907817; x=1761512617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BM6QgAOG34zDGb9jZI8DkkbGa1KuVCoA2kRHxsUOX8Q=;
        b=SuoZRKE8naqYNp+lLjd/sfWvXi05IOBZz/Cf6/6qmyDMAKNlpBwRyMGHPE39Z8w6S2
         bjZmWdcpCtCz7kJuSFe9z1zZ/aGD7lXmCIZIXoSnn7SCbiE92mHVSt4vlx0FiICiDNl7
         MHNa2elktlLuVawM/5vw2mbFP8MOpqF2wKCWqB2U7mdQwH/2RMBxxReZ6gAY6QMKC3V6
         H3xeKreCfYZO3s1c78gup5QZPXOKa2vqgunIoVJarw3Q41P7OWbuK/3snmhcFu+RgI84
         FEoANrGxuHkYhYXmOydgbXdJDOVmSPqgAR3cJRvmJF2sZ4BL8JxQmswkyfbctVhBzlr1
         jqug==
X-Forwarded-Encrypted: i=1; AJvYcCX+6/XjUoOKkQ3RUlutsn8c2l8765/EHtceZ4gWamP1g6RxXw/R/hx61zCSlkz0WA5Vx98=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY/HrZk9g4B4lvC8RfQ40fHdW1Zaph/y/f2Khwsj84IPGydTze
	DvGkV/NSUuoTi+FU97vtCiyQAeFM1HZHm47FDjP5vxLEwpzQwD3U/V5N
X-Gm-Gg: ASbGncvjmQ41pZbl4cP1lLWAWOR1jPqT7Bhlob281qgjDW7+ZIPw+MBr3RCXi/+wP8q
	2reHYC+XtSKS0BSN4Bhwk0x69BYdV/LpvrkQ1UL0YLqIjyYgH5wZI0gW0jOAZM1b2j6s3OMb884
	VhW0DUBwclRsXhr4SFKE9zE+XATYNXw47ceizq+EvYhgszhdhLDefNWhmfJVBd6VZYHK683uGF8
	9tKpSbPHUoyhBYPDpoiNdP7sWM7T54JnkZtmXy7tSHS5PGRqGRAZ8FIRZQ2OeYDj1aCFSEoS09Z
	tUFEmlX9EL3XAPxG2kGvdAs2h7ksAzf2X+c+5wx+PcJxyIy8gdU6Xa/IgR6YhZeD/HUYgzW6TJe
	ka+hW9uwur1iFkM63VAL0opAfmTD6QxmU7KEU7y3oJsKWHS7FJCu4D6lHACkCcZsFeZ1DIZLVRl
	w4hc03vTEnXiTJb38sQYnqTBgAhqmgQa/o8x1Z/ZYwZq16zQfDPpIu/DgzhA==
X-Google-Smtp-Source: AGHT+IHfMh7JlGToGTRe8mHgwHLoF57dHW5JvMJP8/YOMdu/h8U6uYCeh50ZViHOCSNzKzge6vlIQg==
X-Received: by 2002:aa7:df90:0:b0:631:bb4e:111a with SMTP id 4fb4d7f45d1cf-63c1f6dbea3mr8083588a12.34.1760907816588;
        Sun, 19 Oct 2025 14:03:36 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:36 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	Michael Tokarev <mjt@tls.msk.ru>,
	Cameron Esfahani <dirty@apple.com>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-trivial@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v3 06/10] hw/ide/ide-internal: Move dma_buf_commit() into ide "namespace"
Date: Sun, 19 Oct 2025 23:02:59 +0200
Message-ID: <20251019210303.104718-7-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251019210303.104718-1-shentey@gmail.com>
References: <20251019210303.104718-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The identifier suggests that it is a generic DMA function while it is tied
to IDE. Fix this by adding an "ide_" prefix.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/ide/ide-internal.h |  2 +-
 hw/ide/ahci.c         |  8 ++++----
 hw/ide/core.c         | 10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/hw/ide/ide-internal.h b/hw/ide/ide-internal.h
index 0d64805da2..281d07c9d5 100644
--- a/hw/ide/ide-internal.h
+++ b/hw/ide/ide-internal.h
@@ -398,7 +398,7 @@ int64_t ide_get_sector(IDEState *s);
 void ide_set_sector(IDEState *s, int64_t sector_num);
 
 void ide_start_dma(IDEState *s, BlockCompletionFunc *cb);
-void dma_buf_commit(IDEState *s, uint32_t tx_bytes);
+void ide_dma_buf_commit(IDEState *s, uint32_t tx_bytes);
 void ide_dma_error(IDEState *s);
 void ide_abort_command(IDEState *s);
 
diff --git a/hw/ide/ahci.c b/hw/ide/ahci.c
index 1303c21cb7..14bc66fb7f 100644
--- a/hw/ide/ahci.c
+++ b/hw/ide/ahci.c
@@ -1417,7 +1417,7 @@ static void ahci_pio_transfer(const IDEDMA *dma)
     }
 
     /* Update number of transferred bytes, destroy sglist */
-    dma_buf_commit(s, size);
+    ide_dma_buf_commit(s, size);
 
 out:
     /* declare that we processed everything */
@@ -1482,8 +1482,8 @@ static int32_t ahci_dma_prepare_buf(const IDEDMA *dma, int32_t limit)
 
 /**
  * Updates the command header with a bytes-read value.
- * Called via dma_buf_commit, for both DMA and PIO paths.
- * sglist destruction is handled within dma_buf_commit.
+ * Called via ide_dma_buf_commit, for both DMA and PIO paths.
+ * sglist destruction is handled within ide_dma_buf_commit.
  */
 static void ahci_commit_buf(const IDEDMA *dma, uint32_t tx_bytes)
 {
@@ -1511,7 +1511,7 @@ static int ahci_dma_rw_buf(const IDEDMA *dma, bool is_write)
     }
 
     /* free sglist, update byte count */
-    dma_buf_commit(s, l);
+    ide_dma_buf_commit(s, l);
     s->io_buffer_index += l;
 
     trace_ahci_dma_rw_buf(ad->hba, ad->port_no, l);
diff --git a/hw/ide/core.c b/hw/ide/core.c
index b14983ec54..8c380abf7c 100644
--- a/hw/ide/core.c
+++ b/hw/ide/core.c
@@ -827,7 +827,7 @@ static void ide_sector_read(IDEState *s)
                                       ide_sector_read_cb, s);
 }
 
-void dma_buf_commit(IDEState *s, uint32_t tx_bytes)
+void ide_dma_buf_commit(IDEState *s, uint32_t tx_bytes)
 {
     if (s->bus->dma->ops->commit_buf) {
         s->bus->dma->ops->commit_buf(s->bus->dma, tx_bytes);
@@ -848,7 +848,7 @@ void ide_set_inactive(IDEState *s, bool more)
 
 void ide_dma_error(IDEState *s)
 {
-    dma_buf_commit(s, 0);
+    ide_dma_buf_commit(s, 0);
     ide_abort_command(s);
     ide_set_inactive(s, false);
     ide_bus_set_irq(s->bus);
@@ -893,7 +893,7 @@ static void ide_dma_cb(void *opaque, int ret)
     if (ret < 0) {
         if (ide_handle_rw_error(s, -ret, ide_dma_cmd_to_retry(s->dma_cmd))) {
             s->bus->dma->aiocb = NULL;
-            dma_buf_commit(s, 0);
+            ide_dma_buf_commit(s, 0);
             return;
         }
     }
@@ -912,7 +912,7 @@ static void ide_dma_cb(void *opaque, int ret)
     sector_num = ide_get_sector(s);
     if (n > 0) {
         assert(n * 512 == s->sg.size);
-        dma_buf_commit(s, s->sg.size);
+        ide_dma_buf_commit(s, s->sg.size);
         sector_num += n;
         ide_set_sector(s, sector_num);
         s->nsector -= n;
@@ -944,7 +944,7 @@ static void ide_dma_cb(void *opaque, int ret)
          * Reset the Active bit and don't raise the interrupt.
          */
         s->status = READY_STAT | SEEK_STAT;
-        dma_buf_commit(s, 0);
+        ide_dma_buf_commit(s, 0);
         goto eot;
     }
 
-- 
2.51.1.dirty


