Return-Path: <kvm+bounces-59663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D769BC6DA7
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 66BDB4E6643
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D02B2C08D9;
	Wed,  8 Oct 2025 23:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYAWOtUD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1262C2366
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965963; cv=none; b=DQGYkkoXz02p0nQOyyUYEA0Y5bR9Wnk8Q0g37i8446cNtAR5VTcsyXMP+DOpHtCqRzgqwmLqqPBAZtEITPTV6G/ioiV1NWn6t39li4kEbbJohSI7tIft3b2EOgilHF9AF6HR0A4qLN4QsTilCazZ7Cyng5FWPSY/b6c+A1I18H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965963; c=relaxed/simple;
	bh=j5pQGrxDvae8hZ/dQCAJ40DpKkOZn/O0GewPrJqpxpw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dI6LAPyTfGw4VxXsU+2xzKOFGV1QnuCJcC2N3anjwPMWUKu2tcfNFOaURxV9v4IkzmQ+g6W9yvbG2fcJDR1VUewVbJ2fJtMrHS89gJ7eP1FZeje9Gpyc0Nz6f0/CpfDIgogbPaujsai0JmqDK82bLSYEt8hdWfBkJo7OA2R+GRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tYAWOtUD; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-78105c10afdso444675b3a.1
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965961; x=1760570761; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zCCx4tfrh/D5D+H49ARVGFVUAqz1P7/O8PZ2L1W4930=;
        b=tYAWOtUDjVDuSjS4VinoO3uuFthIAOcer36pdAumdkP3CYJ9vZbi4NcZwx7cHpYXMk
         UqufNQQxf5K0XZNYKu4ih9fW6Wks09DDJh+Kbx/QpUfNAn0zt8k1a1XJjqP9IoAQFEN/
         /vpJWza++s/SjisDzhtbGTeMNo+ehqA1Kd/O3e0Xd3iI3nPcbWiJvvz/q3O287beSlVW
         LPc6F0wWKCB0m8peVFvcSq1Pq9QMZ8jtBHpDWZ5chB+T1cQkgKaAGrT/RpmQ5waMBBoy
         TD+qGWeQK6XrPUD9xwuJPO0G6sxUXAsyCFvpMoopSDpABj1f1xHy2yEZbM3IMiYMzTFw
         QUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965961; x=1760570761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zCCx4tfrh/D5D+H49ARVGFVUAqz1P7/O8PZ2L1W4930=;
        b=KuvHrj65qu7UTF8G4RqHZ8gDCcCLWhLl6AzfzRYOcW5WMlJm9EWrLhS0gFFgQ3Kz3p
         QY4gXxrayRvzB+Hnq/HKUrhqWW+b09wljwJaTYB4SwIJuoJMATEc/1lvWA3P6CNigA4w
         IK7MVnNL0efP5BT/sOuWn22+f0E8Udeq7weZfeoYK6pxYNPMEx7cPvnTg7tFmxcDuEua
         +Ml8YAqbZQ2LEvl6RI7g/B/fngwMNEeJEEZW8r1OfJ4nBmwOEMEN/4EsSpXiLTxkTeH8
         bBPlASwINjENzVBluSk74436ulLwx01Q8YfMb6glwDmjJd7tnc8mXPdfmvsUWzs1IKF7
         8bYg==
X-Forwarded-Encrypted: i=1; AJvYcCULE2KRp7P0/RhCsdDe3KlEPg3gy1Ai9XzwhnIzrSEruqRDpnFjv2uXrA3Rnp/HUTMyxyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgNnel1dgmrgb9HTlFA68XfLXXVRLC+xa2YZoCIrdsUlcRFi7A
	zqanKyuMtvgQh5MExte+TgVs1ZEUIARN4mAUf9ScXOG0Nlq0OwZzxw2EJ+5j/73QsGKUu9LeBs1
	SXJvNSbvgnBOfQg==
X-Google-Smtp-Source: AGHT+IFcBzD/D2WSRx3YB+IC9sHylsSHZuNMb4t3UNzDzkbFBjlCcZrlqUewkFpWf5bRurGFB1zVjjn1kwUj3g==
X-Received: from pfde26.prod.google.com ([2002:aa7:8c5a:0:b0:78a:f444:b123])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2449:b0:32a:c8b8:5610 with SMTP id adf61e73a8af0-32da845ff6cmr7097735637.47.1759965961177;
 Wed, 08 Oct 2025 16:26:01 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:22 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-4-dmatlack@google.com>
Subject: [PATCH 03/12] vfio: selftests: Rename struct vfio_iommu_mode to iommu_mode
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename struct vfio_iommu_mode to struct iommu_mode since the mode can
include iommufd. This also prepares for splitting out all the IOMMU code
into its own structs/helpers/files which are independent from the
vfio_pci_device code.

No function change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/vfio_util.h | 4 ++--
 tools/testing/selftests/vfio/lib/vfio_pci_device.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 2acf119cbedb..5b8d5444f105 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -47,7 +47,7 @@
 	VFIO_LOG_AND_EXIT(_fmt, ##__VA_ARGS__);			\
 } while (0)
 
-struct vfio_iommu_mode {
+struct iommu_mode {
 	const char *name;
 	const char *container_path;
 	unsigned long iommu_type;
@@ -163,7 +163,7 @@ struct vfio_pci_driver {
 struct vfio_pci_device {
 	int fd;
 
-	const struct vfio_iommu_mode *iommu_mode;
+	const struct iommu_mode *iommu_mode;
 	int group_fd;
 	int container_fd;
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index f2fc5a52902b..da8edf297a4d 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -411,7 +411,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 }
 
 /* Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(). */
-static const struct vfio_iommu_mode iommu_modes[] = {
+static const struct iommu_mode iommu_modes[] = {
 	{
 		.name = "vfio_type1_iommu",
 		.container_path = "/dev/vfio/vfio",
@@ -439,7 +439,7 @@ static const struct vfio_iommu_mode iommu_modes[] = {
 
 const char *default_iommu_mode = "iommufd";
 
-static const struct vfio_iommu_mode *lookup_iommu_mode(const char *iommu_mode)
+static const struct iommu_mode *lookup_iommu_mode(const char *iommu_mode)
 {
 	int i;
 
-- 
2.51.0.710.ga91ca5db03-goog


