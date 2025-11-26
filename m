Return-Path: <kvm+bounces-64742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB237C8BADC
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DCA73BA1E0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC6634DCC9;
	Wed, 26 Nov 2025 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mk7cMxbX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3255134D3B5
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 19:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185805; cv=none; b=nYcIR0UDLeMJd4REIz8CIQlIfM8iqy3VNfC13kxAk4H75nE/egeZF6pxBEafgbOklerHvy2iifOcaL+56jXQA7QDWtqHm6d090sl6KxcTiv26hOjLLgoAJwGNeRM76xBnrpERrYaZCKF7HkP3+hWEmsV8HNuVGxzQzsfSqq8o2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185805; c=relaxed/simple;
	bh=AKg0E0qnouOBnaL90KIbwoCnCOQpIGGOxs9nH2+RlA4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dgbxkS88WLZ/ZIMzJ4BRLloCVk1RdnFuGY7efpkF6bXmIAAWF8gUTxOT49MgIUKQ+0m1aAf4bAnyjjOrT1m0MuWuKR0oqThjEZuXmfoElkEExSadqAKmfFv3DR7C9PlC14IaFxv9ED/ZEsUG3rJhAgvcrSZ3ntDauOcHcRSDVn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mk7cMxbX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7c7957d978aso62291b3a.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 11:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764185803; x=1764790603; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2mMhadFzAEncdROdPe4thGWEZeQry8cuGMCxEDY4Otw=;
        b=Mk7cMxbXLvjHycUbk+yGO+lx4g0Rp90S77qZcZed7HSDZVtbNy+Bg6WbU3PrT7Et3+
         /sl2RqW9TDxBvcqUGvqA2aa1ZzgPZKh8QoVbop0w6i0nWEcuu0emi1+fViNhaQKT+vNz
         2XZl/42BBvSoCrSY8FK2NDGKAhlDfet0SCQs9p9CXthktdSy4xHa5VHVwvi1dEvE2Nxy
         99t0wEaEQya1qQBhU5LT5RRYOeOLhWfRyy9GjecfuvDKSXL3MDMO68TH8YTELD/6/FgL
         Rg13Pj0nrYKOZEDsBwOrdQeg0BxPJUViz1EtrpLbfa0o2xVwDkSPERny40htaNYMeogA
         dkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764185803; x=1764790603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mMhadFzAEncdROdPe4thGWEZeQry8cuGMCxEDY4Otw=;
        b=uiW5Zz7UPWuwcvT+0FdvC2QdeimTXjGQex6CNySg3xBLtWVT8YcaA0K07vSow5N/je
         2+q6/RfHUh2ekVdRJnMyTErxC98Q2xQCzvlneFo2BlIxPTRjLiMK7TZLpxQ1pgNHzC9A
         UkWgxRB4P4WbbdyrJYC0+Tpke+ZqbPHCwA8ZZZICmq7eMUkmx0r1zHVCHL8qf6BaJsaU
         xcKw87+P2lY1R2Dgh8H6jJXiNQercl+57rp2BeYHZSWKlZyGSHVbqeLKjE0R+pmWyqz7
         UCrjVLkFbvIumCX4VStuZxJ0Rvtnorh0yTW3ephvNGoUG95RnBq9/r/VNnhaRURIvdKd
         b7zg==
X-Forwarded-Encrypted: i=1; AJvYcCU2ZB89OZ2zNTOsukTUkllDbOLmunJUzqgzky1754OcXsSnRpBsXF7e/t++1aA57gswl6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7vfQHskz38SAwVVSu7Ktp7Hku3mfD/CILcDh+GB0R9bobKlCc
	1ifvLQ9F8nQnXPTlK7RPsjsD0TRk+XVls5gXXHQU3eUjneDRBL3xolrFQjqQbCMghf0sheeUKA0
	dkekDoopQYNH0Dw==
X-Google-Smtp-Source: AGHT+IG0nWsINIf/GruvQ2HPIp2jBBinQeZ2Mfu1D9y30mRN7EoyzQVebfADvYhxmegugqK6CpozEorpQsDNYQ==
X-Received: from pfbcw14.prod.google.com ([2002:a05:6a00:450e:b0:7ba:8e7:5499])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:32a2:b0:340:db9b:cfe8 with SMTP id adf61e73a8af0-36150e1fc11mr23324744637.12.1764185802504;
 Wed, 26 Nov 2025 11:36:42 -0800 (PST)
Date: Wed, 26 Nov 2025 19:36:07 +0000
In-Reply-To: <20251126193608.2678510-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126193608.2678510-21-dmatlack@google.com>
Subject: [PATCH 20/21] vfio: selftests: Verify that opening VFIO device fails
 during Live Update
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

Verify that opening a VFIO device through its cdev file and via
VFIO_GROUP_GET_DEVICE_FD both fail with -EBUSY if the device was
preserved across a Live Update. When a device file is preserve across a
Live Update, the file must be retrieved from /dev/liveupdate, not from
VFIO directly.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
index 95644c3bd2d3..925c5fc30d56 100644
--- a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -36,6 +36,42 @@ static void before_kexec(int luo_fd)
 	daemonize_and_wait();
 }
 
+static void check_open_vfio_device_fails(void)
+{
+	const char *cdev_path = vfio_pci_get_cdev_path(device_bdf);
+	struct vfio_pci_device *device;
+	struct iommu *iommu;
+	int ret, i;
+
+	printf("Checking open(%s) fails\n", cdev_path);
+	ret = open(cdev_path, O_RDWR);
+	VFIO_ASSERT_EQ(ret, -1);
+	VFIO_ASSERT_EQ(errno, EBUSY);
+	free((void *)cdev_path);
+
+	for (i = 0; i < nr_iommu_modes; i++) {
+		if (!iommu_modes[i].container_path)
+			continue;
+
+		iommu = iommu_init(iommu_modes[i].name);
+
+		device = vfio_pci_device_alloc(device_bdf, iommu);
+		vfio_pci_group_setup(device);
+		vfio_pci_iommu_setup(device);
+
+		printf("Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, \"%s\") fails (%s)\n",
+		       device_bdf, iommu_modes[i].name);
+
+		ret = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, device->bdf);
+		VFIO_ASSERT_EQ(ret, -1);
+		VFIO_ASSERT_EQ(errno, EBUSY);
+
+		close(device->group_fd);
+		free(device);
+		iommu_cleanup(iommu);
+	}
+}
+
 static void after_kexec(int luo_fd, int state_session_fd)
 {
 	struct vfio_pci_device *device;
@@ -44,6 +80,8 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	int device_fd;
 	int stage;
 
+	check_open_vfio_device_fails();
+
 	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
 	VFIO_ASSERT_EQ(stage, 2);
 
-- 
2.52.0.487.g5c8c507ade-goog


