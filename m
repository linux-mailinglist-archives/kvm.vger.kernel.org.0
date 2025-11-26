Return-Path: <kvm+bounces-64724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BC7EC8B9C5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED71B3B7107
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DD8342C8B;
	Wed, 26 Nov 2025 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dbU6Adrw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6543331A58
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185778; cv=none; b=AEkO1xtMnnp7VNLv66cF+F6+J9H+oJncFhbYpxcJml0X8Hq0WN5rdnGXiI2JRGZQVveSfva+RyPOZSuHu1IjIfwIPQtwW8SBTE5jP9JZFizhSjH904RFRzPEKtgT6HT8WuQKVox2vdPyJqNgmgOA887jP5oJ/v8h0v9K0QrUnlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185778; c=relaxed/simple;
	bh=DgrTkiwsj7G+kzAv5Mmspt4Q8NbY6RXRBJtrpMsEy5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tw52kdUniYNj0BX/FcFVo0BOIcjl9FVnekxUmTEdXPxPBkZdJKWeiVBKz9lXyKDywbaq2OkI9PlNkFm7uYJy+Kbj8v/OboqU9O58hbQtQeBsrdiCWHt9WQPzzuKrNavOVC0GjqCRT/SDUAH0tEnWm9CG2gDP+7gphEmHsqSwTag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dbU6Adrw; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297e1cf9aedso1648045ad.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 11:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764185776; x=1764790576; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G4W8jO8YwRXmYQwem/Oi26baRXbR//DiNTTxQHZyVKU=;
        b=dbU6Adrw/r4HbB2gp1axytAQ3o43CYiIxktTc1NaQUbbgieIqOqSyN5L8pEVth1EjJ
         F3b4+FXxQRnSrd1XwMjcNsmTfIsWkJgUX9+1PJ92FFNhD4SJ3SbeYKpNZXA++d90+Qn8
         pPWLuJE005M8Mcnq/5AJppqd2ZQ8ix0Gj055ltkMvlss3XK+QHflkdaxzbiX1GRJkcBN
         43HUbvtflmJJGE8XyGlFlpcLebVvL1NIhknhVDX0RaSiDIGy1BAeDGNVYh5DuQ9I8S3o
         Y+hYJ7aFFs7hR941kGZxxfOFA4W32vUZtMCkAHOjkAlfO8s+2qTXCQRpmBGjHL5S/06O
         WIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764185776; x=1764790576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G4W8jO8YwRXmYQwem/Oi26baRXbR//DiNTTxQHZyVKU=;
        b=lfxSAoykoaWnufQOQ/tSpGfBo0qJg/9AqXSAqU1aFLkv4uXeG7V4xT+Fo4/DM9Lm99
         LPqJdNrem1MrZ+FEYz2+FG2AnIvy7ml/1Arcx1yCq4Us2al0lDsqhRG8E2tLV5Jsxl9T
         u3rFlsJxkE+frRRly5NqCB3l5od1al1y5Jy5uMfNHl0dCFSLTNQhmlkRpRK3lBtQSS3U
         iKoOxyVUkQyqfkQSSljOY8VR6lAUNABJ/ASTPW3JA8MtDlUJE1H50wQlEcDyp0SwKh+0
         bsQwmSrvhsWQD4iM2g6sjvmN5n4KsF9WWY4fu4bSHGgllU7oi8KrJw8oShx6d+RYFTme
         r0IA==
X-Forwarded-Encrypted: i=1; AJvYcCXudb5E3nJXes3WlN0riv81D5TtDKnH8ZwXjbM26gbXZ8hnlZF3vBlT05bg4bhs2RMVLJY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDkgrmpQTxZi9MHLrgkXbTChezzNb7IfmqNVQCsfTFkGrgP5RD
	4jAip8yhQ0lHr6tMvj6UWY+PiyfLqpSphdk0uqLY/p5sikehkdfd43aJUvG5gj60z1emGkg/nif
	YThiE2dz4/S9UwQ==
X-Google-Smtp-Source: AGHT+IH14W8+tVRPyICSHFhnhdie4VNOZ11aj2/eJVs/11OeDSQhWpHoOWodZE+UlFUV7qImHq1Artm+rlwecg==
X-Received: from plbjn3.prod.google.com ([2002:a17:903:503:b0:293:e00:bb82])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce89:b0:298:485d:556b with SMTP id d9443c01a7336-29b6be8c617mr237546495ad.5.1764185775828;
 Wed, 26 Nov 2025 11:36:15 -0800 (PST)
Date: Wed, 26 Nov 2025 19:35:50 +0000
In-Reply-To: <20251126193608.2678510-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126193608.2678510-4-dmatlack@google.com>
Subject: [PATCH 03/21] PCI: Require driver_override for incoming Live Update
 preserved devices
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Philipp Stanner <pstanner@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Require driver_override to be set to bind an incoming Live Update
preserved device to a driver. Auto-probing could lead to the device
being bound to a different driver than what was bound to the device
prior to Live Update.

Delegate binding preserved devices to the right driver to userspace by
requiring driver_override to be set on the device.

This restriction is relaxed once a driver calls
pci_liveupdate_incoming_finish().

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci-driver.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 302d61783f6c..294ce92331a8 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -420,18 +420,26 @@ static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 }
 
 #ifdef CONFIG_PCI_IOV
-static inline bool pci_device_can_probe(struct pci_dev *pdev)
+static inline bool pci_iov_device_can_probe(struct pci_dev *pdev)
 {
 	return (!pdev->is_virtfn || pdev->physfn->sriov->drivers_autoprobe ||
 		pdev->driver_override);
 }
 #else
-static inline bool pci_device_can_probe(struct pci_dev *pdev)
+static inline bool pci_iov_device_can_probe(struct pci_dev *pdev)
 {
 	return true;
 }
 #endif
 
+static inline bool pci_device_can_probe(struct pci_dev *pdev)
+{
+	if (pci_liveupdate_incoming_is_preserved(pdev))
+		return pdev->driver_override;
+
+	return pci_iov_device_can_probe(pdev);
+}
+
 static int pci_device_probe(struct device *dev)
 {
 	int error;
-- 
2.52.0.487.g5c8c507ade-goog


