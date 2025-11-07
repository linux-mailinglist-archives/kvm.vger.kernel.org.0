Return-Path: <kvm+bounces-62365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD623C41CFB
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 23:21:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E776189716A
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 22:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B621E313540;
	Fri,  7 Nov 2025 22:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u+rIdeuB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7542D3101C8
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 22:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762554070; cv=none; b=Rk3CADgXq/3RbQ+w8idpsOzxIHJsb88gJfD5kwzbcXYacbbXfDW4Z13WhlIr/j3DV7dryZ+5H4xjR/P8b4efK4JOntZGwDk3iGW0JGzNk1XP9wxGH/PDr3zcflQoxJWozMC694LrdPG01k5f2+BwZ2RdrEkX3FZOdPXzuQAJaWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762554070; c=relaxed/simple;
	bh=WUqWR70IoFJFm2xG+9BjmEYbjs7hMs0yO7Awp4mKSeg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=I9kzVqtMg1uRX3AGOx7Grjo4q9hD88lpx3GHtmWdlungEfCzxM255CPpTSoxPUg7gWWTg9Z/gDXsV07ZKoE3uZX+jah+qowPHXnBmXPNM/69ii2/WgUg0lrA8qV8GUBXbAypiB778MBeQrVOQyvNEn6qOTgnc0VaVTeo1jr1Mwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u+rIdeuB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b993eb2701bso1124276a12.0
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 14:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762554069; x=1763158869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zuSF9+hfy+NMVL8N7Q7F7ZTFz7YXKcb4ealISCMjhtI=;
        b=u+rIdeuBtiE1GdBQEaII0asi7wkzEvgpXOhJPC7TArJoKAMZILScEXmf7lVw4DrjSC
         YPnZMEWpS+hgxESq1x7GAt/N5w1jrWdrWmIG/rXo3QQ0wnhp+bJgb5z2SefY+/vmI2Zy
         cjcAGDZebWW0SQojJv1t1nF9914326J7ePcXU1h4eFJv02b47se4gOMz1PhWf1tZKKap
         +oMoP6P3kSwy2TAorg1wE1Axn9k42DMVsiSo5MrWniO1ZMHAbCFONMZDXg23djqhIAVf
         tc3eOGj+oTn8UK3FbjJSDI0eudLV7aC1YVo3oT91GrqDMDLm6XFH6ZrgUimIP9fvR+mH
         DvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762554069; x=1763158869;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zuSF9+hfy+NMVL8N7Q7F7ZTFz7YXKcb4ealISCMjhtI=;
        b=AQuRgcrnmc4kOIz4lksV+QAZtaXtQgrPNM241+hUGOe49tePlZnYGmfXspqqXAUXUo
         aMLnmuWYI//WdvrzPbStcQzSTdEsfTuZEt0bRVTFuCgcpk1K+7x5mHT+6ZAEGW6iLCnC
         8/NosECOglpo17olP3M/UdlQRrucAGRV/ihaB3/oDND7f/mWaHJ1IUF93H+PnaJ72+XE
         gxNIv8jrq/womNv9VgOPLCxZj36ESq2/vl9p1RGDr+ioxj5nwq1G+/kUwOeThFyZtPoa
         F9NcNgGmHdGpEx197exsQTYC9GK3MWneWFtIKM93HtasRKO2oagbzluqwgmnQ+5uUeuM
         06Xw==
X-Forwarded-Encrypted: i=1; AJvYcCUM5c870MZaIJCg/Zc1RGCUtTYQQj2GgKrGZb+0DCkDtzzyTtS6BmGa8uXGQzoBY6ZbYKs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTjI4nNXyxWg4w23whYSETUciYCksPXAkuLIrobUZvKhdnwbxI
	erBgjxNGPsw074mdrZEaG6vrv/Sya8QWyx9PnagKifp8D5rRHCVBAdAqbL5QvTRNEWphdOpEtmr
	EHxr8DtU/8/Lp8Q==
X-Google-Smtp-Source: AGHT+IEXQvyuUBBRKN1QeiIACDjnMWHrD1uj7W5TBwePpvwHJac5Du36S2WgUjA6zrrdDIZtsxvqBPbemHNQqA==
X-Received: from pjbqj11.prod.google.com ([2002:a17:90b:28cb:b0:340:cddf:785a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a81:b0:341:c89:73d2 with SMTP id 98e67ed59e1d1-3436cced914mr670238a91.22.1762554068725;
 Fri, 07 Nov 2025 14:21:08 -0800 (PST)
Date: Fri,  7 Nov 2025 22:20:58 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107222058.2009244-1-dmatlack@google.com>
Subject: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if mapping
 returns -EINVAL
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>, 
	David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Skip vfio_dma_map_limit_test.{unmap_range,unmap_all} (instead of
failing) on systems that do not support mapping in the page-sized region
at the top of the u64 address space. Use -EINVAL as the signal for
detecting systems with this limitation, as that is what both VFIO Type1
and iommufd return.

A more robust solution that could be considered in the future would be
to explicitly check the range of supported IOVA regions and key off
that, instead of inferring from -EINVAL.

Fixes: de8d1f2fd5a5 ("vfio: selftests: add end of address space DMA map/unmap tests")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/vfio/vfio_dma_mapping_test.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 4f1ea79a200c..52b49cae58fe 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -249,7 +249,12 @@ TEST_F(vfio_dma_map_limit_test, unmap_range)
 	u64 unmapped;
 	int rc;
 
-	vfio_pci_dma_map(self->device, region);
+	rc = __vfio_pci_dma_map(self->device, region);
+	if (rc == -EINVAL)
+		SKIP(return, "Unable to map at iova 0x%lx\n", region->iova);
+	else
+		ASSERT_EQ(rc, 0);
+
 	ASSERT_EQ(region->iova, to_iova(self->device, region->vaddr));
 
 	rc = __vfio_pci_dma_unmap(self->device, region, &unmapped);
@@ -263,7 +268,12 @@ TEST_F(vfio_dma_map_limit_test, unmap_all)
 	u64 unmapped;
 	int rc;
 
-	vfio_pci_dma_map(self->device, region);
+	rc = __vfio_pci_dma_map(self->device, region);
+	if (rc == -EINVAL)
+		SKIP(return, "Unable to map at iova 0x%lx\n", region->iova);
+	else
+		ASSERT_EQ(rc, 0);
+
 	ASSERT_EQ(region->iova, to_iova(self->device, region->vaddr));
 
 	rc = __vfio_pci_dma_unmap_all(self->device, &unmapped);

base-commit: a1388fcb52fcad3e0b06e2cdd0ed757a82a5be30
-- 
2.51.2.1041.gc1ab5b90ca-goog


