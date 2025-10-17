Return-Path: <kvm+bounces-60322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4862BE91D2
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FB6D622538
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F314836CDEB;
	Fri, 17 Oct 2025 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZlVrL2ZK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656F036999B
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710375; cv=none; b=LAes7eDohj6MgSFu+T8/naLBCXjHL3fSEgc8xVgNkcSKlsP+iTXRmbauW6KQBPWzk1sqx/gRquRS1JafXT0iOf3nWjHIpVeZ0vXotxc8s7cEQeWzFPxr0gzk/WZkw45r/VYfiPsHBhsk3P3DQ7ZwMSKagHZKqR/tQzChFzxz8sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710375; c=relaxed/simple;
	bh=IOOMnzzwp3i4tTVSmLMwLE3BmaS/VCL8NO2bzbxFJRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuqVXvbD8FIMDik16TX1RDMvdO0Owp99apPbAlK4pQKOt/wEwhA2jMEgDMx1f/jfKhOL9NPRyPyRzlE6RIhLNY76iMQYUSF8yQtzMYE0uuUPokjhJ85IKT+meoytnzTXIpKJn7+JjbY6tOcJMLuMJ9M539OlNm3nMH0PthpUr0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZlVrL2ZK; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e6ba26c50so14748345e9.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710372; x=1761315172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BM6QgAOG34zDGb9jZI8DkkbGa1KuVCoA2kRHxsUOX8Q=;
        b=ZlVrL2ZKi+ReAitgLbAHk+DPIfXk6M3bN/CBn7h2mcswbjuSNkFkGhzMUMTZAdv4vU
         7nM3hR5TMeNfsNCgVUoftqk6tAQiDOFUx8R+dkI7r1qAqyvXjLkNt+Ur3H1Zig4btR/M
         SYwvmZqZhIQeK35uNq5EUoFimDhKdvUXquVRRvrFOrtjIZkylRXj1K6AFh9y9lU9U7DH
         0q1/RplsYLhLb4w5/ih9dq7ttTorqbbQL5yxFzsszocc4sLiHYYGoAN/BR5lpIovrt+6
         fHJSVF/CPgaS/8LQKfx26vqpusnPJY0rvg9SvXywuqnkX0PPXnIqdFbfxTZ0Yq51YB7u
         SPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710372; x=1761315172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BM6QgAOG34zDGb9jZI8DkkbGa1KuVCoA2kRHxsUOX8Q=;
        b=l+UcKN48ZhfKU584ZR1bviUtv/r1eD6ZLwW1eTyBTOwbt+0JxTqJc/kM3X+qionTfV
         xkWWxgOYkIWx9GuAftPNsuJ73PljEV7fLm6xVENgmUa9amGDHCn2woiqHvbKF2nomjvM
         F1setmXEUbEbDslFmAe1dBa6WCpraSGD/cvOYqUSAG1Acp13+mIVRglb0qQqWrMfg2Ng
         y3GoCWAKGjqxd0GB56jEx/Hh4S/uzGC+pl8iYJaTRWBdSgMbVvG6gKH6qXSUyDBm+Maj
         h+pxoWTgzP5xteQzzm/ZO3F+53WRlHj1J97XrSdRwH4aUIuw1NsRoTcCoMcgk53qHsiy
         KVQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBryRSxCf4cQqlZmKN0nqYTNshsh1xh7ZvTIKISs1aWAUvHflv6OSEakTNuPs5gczj1lM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeMygOrvwUVc8UQPw1QvitsRFWS5Ep4L3c+y07UWecHj/0746G
	eACprcg19FJ9ylOMr6+S3r+GrSR5O6rJ/sTMGFzKpRL+gbcYGlASmmSi
X-Gm-Gg: ASbGnculnBZ0mGcSym1Q+S1XqvFsuMdRWLn1FUpiP4SRAk4OOi7W5klb51xJUdCbFba
	5JOOrNTgCM36h8KeErnpbAOkEN+M1p/wyffokrcV8UeFtqgsvaz2On2iJALbqAIsMKMl8rqE4+n
	Ak9jtIww9EdzjCEEJnZzI2Bg++xUZiEnuXn/xxym5GA2T+OP9yxbbA+SW+F5tVw+q9Ce9lUo8vf
	NfEhqWFy7Ob1guAhvYxmO5vvCmELKHMbGEgT4ZI4v+y/QoCAwKSx8Agn6A2K8C9DiyxBVHMTA9V
	ZRa491ndLyR0aUao5mykGELUcr8S2eRGwuroGEvcTd7UGgJLg0qtF0o6C/UMenJJxar7Cb1U2Ig
	ahT9eB3+yx0etkBErJrKjEwjAOE94LQeQfFSlwaHiEmrBp9xC/Qis6V3y/9qk7rIVcn6TxPAptN
	2R1BPGO+YVFH3ai4rmuEqzNQE4kQ6trPVN+E5X7gW8yB4=
X-Google-Smtp-Source: AGHT+IG5nxpyCZb86JulC3CK6XBAxAajZvuOX8OdfguJ75zkQr/jxOZUNh4OU/knYFxHTDCsaxeKIg==
X-Received: by 2002:a05:600c:34c7:b0:46f:b42e:e360 with SMTP id 5b1f17b1804b1-47117931edcmr33177805e9.40.1760710371445;
        Fri, 17 Oct 2025 07:12:51 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:51 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Eduardo Habkost <eduardo@habkost.net>,
	Cameron Esfahani <dirty@apple.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-trivial@nongnu.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	qemu-block@nongnu.org,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	John Snow <jsnow@redhat.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v2 06/11] hw/ide/ide-internal: Move dma_buf_commit() into ide "namespace"
Date: Fri, 17 Oct 2025 16:11:12 +0200
Message-ID: <20251017141117.105944-7-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017141117.105944-1-shentey@gmail.com>
References: <20251017141117.105944-1-shentey@gmail.com>
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


