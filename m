Return-Path: <kvm+bounces-60306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D32FBE8694
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 740BC3430E1
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4035F34AAFD;
	Fri, 17 Oct 2025 11:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXWSFVca"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D4C34AAE2
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700848; cv=none; b=HvqIezoESEkxTkNHBa9b4Q8+lOLJOVoFPdRIVYY2Wq4+blPaFNvn2PLkYjbMuBj3ILdBP+vTdduJEKk3aSSsZ/299lBo+PF21bJ8OFCn2LUQErMmkPSAqmhr1tXXtcAM3spr2RmRy+EZm/1KbNBaTS3PN67CkA5HSlmcdJwwbn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700848; c=relaxed/simple;
	bh=IOOMnzzwp3i4tTVSmLMwLE3BmaS/VCL8NO2bzbxFJRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFXfyeJxaWLyqV7DU4PtzhsvSqVyJOFVbLHWUMxQu1HStlKF9x4Q6DUgzBZpiQJBRSeGkODH00if13amLxRfFiGivKBnh/5O+jD4+9UpdIUy+OQnGT4L6oyM29PA+2cHZ89eK92NFkw4uNhkOngCcIy17LCZU53z7426xe1xAPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXWSFVca; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47103b6058fso13580085e9.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700845; x=1761305645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BM6QgAOG34zDGb9jZI8DkkbGa1KuVCoA2kRHxsUOX8Q=;
        b=iXWSFVca2mS/COuj6BZQ9ubqaF0JG10XnBj3OQYD+6kuKzeZy2oOntbloAbf74BygD
         E/XZ3iOrfyep3DzQUoLqWfdJIFyrQmoOsogqeOpIu/yItSSzBe0fMat9sv/Ov8d7TCAZ
         vUmvrdy5z4TPrD350UCiyslbOGzf4eICvxzHwYbnWltj2aF3yGgkHDlHKg9GFQiVlFcP
         lWWmmUngaZWQok5LaeNwlwoCbP5UYg14aBcMqiIi0u5QcRRfEWoN1+wgi3jQ9ASsYeTg
         20yscu+d0zn2wlXKAGuatndfh2BjjSmkiCk0+SCjiYFWqvTggAGhshv+Vacd0AxADTqt
         AOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700845; x=1761305645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BM6QgAOG34zDGb9jZI8DkkbGa1KuVCoA2kRHxsUOX8Q=;
        b=ip+9vS4Geb/o/3av2v+spjtfdpXyOMdP4xPSzsqcT4JUS2imMpu/kbt0/dLYzRtxNv
         N+IyncQ9Y/31L4Ix8bFbZ3iVLv7m6f/Ym7tiVJeAQswyiT4L2XZZ6zl1Adjil+40Cw2r
         2+Secp4r7E9wsMLxDjAZN3L6M+ufpSnwC67mAAXklxHLyxGKm0XO+LGhbOt6bkBMC3GP
         0gi1E1uzRANss41hliGGB5JHQXLEja8PeHnowMS+d4T+7JxStj8qdeMq6hH0V0iMkowy
         t7AiFFzL2iBOg92FKwOoZbMEFG3ACYdOF41g39IqH+BR1Gt+ak/bS1s/sGjFvyUinLb1
         k1/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX/ohPof7jbjqDzqo9f7ZImeiF/SPCSxnM6eTS/mkL4KhGJ2Ej9kH8aciAEEU0FE+7oons=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvxgGHXT1vPRBFCyyAKa4KSJznNOG7BbIY9IIVUxzO1hUz9pR7
	oTtWbDT5cBop2+Y7kxYLktFHFr1ClHE0EVWQtwr4xXAVLNl9/ZOwkyZq
X-Gm-Gg: ASbGncsCpzIs97cuRiOmnkIN6AgJ0W8Sr7nMwzJ0/DmEpDS+TDh1C/SgJ6F3D/4WjGp
	e8izGsZMEnh3UC98olXwY0LZxydRT/19SzezigAFC+8iUSZrFJ3s0DlfAter43tUxLppKjj56uM
	Uk6lwihXJjT5+WpQcL+7DxGoOQy8I/719wPk6EmYnPL6qZf7TqAmBoVEvo2ty0i7u5/QKHzxM2/
	c6/jkafFjm/rySTNYRj7yAEfei+uUW+8qHdXiebaj6uxWZRtOSe6nJOk8M852oEEZ1KsAZscGNf
	CiuCeCfi0XyOGwK4shRTY4Rlz00wWjvDnR/oJ+TeHRz0pYk+EylOSa0+1gU65neZnLwIHCJQjtv
	T8L6QuxFoIm+AR/QMcjnXITt3BInVIR70W7VRCmh48yRUuEmTG8ZmjEuX3QirirwNVEeHGYvq6W
	EiEZBt3rKHQq0VoN28VqR0ohUk0bnxTt/1
X-Google-Smtp-Source: AGHT+IGLsMwNa24SVKElCrTuDly2JhrkRR3DVkahMshWsaOruLCSdJ+4rhKxrSHRXVTtx+GQp2kERQ==
X-Received: by 2002:a05:600c:364d:b0:471:6a1:26e7 with SMTP id 5b1f17b1804b1-47109b4f8bemr37360005e9.12.1760700844745;
        Fri, 17 Oct 2025 04:34:04 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:34:04 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <laurent@vivier.eu>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-trivial@nongnu.org,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 7/8] hw/ide/ide-internal: Move dma_buf_commit() into ide "namespace"
Date: Fri, 17 Oct 2025 13:33:37 +0200
Message-ID: <20251017113338.7953-8-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017113338.7953-1-shentey@gmail.com>
References: <20251017113338.7953-1-shentey@gmail.com>
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


