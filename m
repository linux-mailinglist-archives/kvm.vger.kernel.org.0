Return-Path: <kvm+bounces-47644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D486EAC2C5A
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F10267BBB4C
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B084D227E9F;
	Fri, 23 May 2025 23:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="THEwdBLV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8976D225A32
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043069; cv=none; b=mFRpIf4y8fybCDrk3C/DBmtDV+IGVkwR+sIFOjNkY61V+AFDaHC8pkKgq+JzXb6GLX8CrwApBp0OWsZbUyMoKHNaSjnOraeryTiFxZnuIy2r5MYdXI/2rIqfKnD6MPdK5N8FgLHFw2Uz7OV5TP9FuN4PBDE7fI4jHtvIy/28/XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043069; c=relaxed/simple;
	bh=PGrPt1gk7QO/nZNg4yZH9qe0Lf8+bFEWzeJhzrdoMOI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mKxXYbf//75bzitAffIBnxSTrRLCAs3Q3KNGt1nWam1c8GTDe/rafcgg1vcnBYLfYtBaX2NvCWl4PRC39VFTEZZj8hnnVLtmu8ZjplF1hrzda3eMVlQ+XdjQ+XUgiTOEC1GCkotYDKvYsuuzgVEBGFXNuO2i3KYOXRI6vTzW4XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=THEwdBLV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e9e81d4b0so555323a91.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748043068; x=1748647868; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8nIBIncr92QRBFJc4uveiRwN6XxEWnD1cmrWaQpbkpM=;
        b=THEwdBLV4SofFZw4G7ntp9lLPqkHXi4zXKF2k8iHZJt21CCtg7v1I6S5GPjrM1Z7CI
         tPWUx5R0XmgNB9ug7BvmhVvYnB6YbHLFdfrP+vN3FG9O5y1rgeWLiJeCNC/UkmDYjGh/
         oCKtCpgy/xVL0Upmw0TE6zkuyDKIC1R3jvYEUT0vjGGovKWd4FAH59y7McheZ6ByfWWN
         ldP1Y+H9RGXi7dnWwGnvzQOH29y+FlhgGeXH5H0e1Ckt29LzPetHj0BaFl26HSqk0LWR
         7L5L9oP4G+fiDzFovgRpKtD+3mge24InXKB9XtI1FbYxiOJPGE3nOC2/ij9FBXUtsWgC
         pUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748043068; x=1748647868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8nIBIncr92QRBFJc4uveiRwN6XxEWnD1cmrWaQpbkpM=;
        b=sOmczaaBvw1MZl9ZSHNrVvCRfOh5PtmvLX+zXXUAh89/ShKrtfzJuTJTpv7h+RCWCe
         FLJo/K8nclWzSVIt1p7O2GBjxDgwBWOJGM0QdCudU55fW1YsOweeY+FuEVdw4JlI+sPI
         vkPD4pAr4J/EUAAA2xM/met//8j/JybpF6dp+fm/sBfzVs5IuKTevVzWu3Gfrjn8gGLn
         m1gu/0FBRh606mo7ss/snnSZC8TKGasv0mxP0Y/GZiAP9pd7E/VCL22LLp282NpYWzgu
         G8Q850q6XZP4NOCNeS9y45XHL+bfbWYkzjaYqHAvFKeGGzrfr4oInQQ+EYw20vzGIP6b
         CJOA==
X-Forwarded-Encrypted: i=1; AJvYcCVnttUZiBpqjF+jn4fBLuOjKoanmKN3mkp2fmzVdOBMvTy0Gy4pJPkQo4Q6kcaJmvUVKXQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlh+oRvIiF2Ld0G0gn7ZJPbX0iIDccnqI+/JHBwizjTRtvwLQQ
	u7zuL4wsqBTwqxeWy/+c+ac3OdybDvFW/ZPumgU0//y6KHXRKDrGJA+CRL5abau5NoqiX/ywo0P
	CQUrtfwR5XG2j1A==
X-Google-Smtp-Source: AGHT+IE5fec+WQbHBoCMa3++Nmm00mA9nDx512f1g565wlYHYNSf+gSbBwJcM9UuSPMmVVMpbBGlduomktU3pw==
X-Received: from pji7.prod.google.com ([2002:a17:90b:3fc7:b0:2fa:a30a:3382])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:164a:b0:2ff:6608:78cd with SMTP id 98e67ed59e1d1-3110f30892fmr1630472a91.9.1748043068001;
 Fri, 23 May 2025 16:31:08 -0700 (PDT)
Date: Fri, 23 May 2025 23:30:12 +0000
In-Reply-To: <20250523233018.1702151-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523233018.1702151-28-dmatlack@google.com>
Subject: [RFC PATCH 27/33] vfio: selftests: Add iommufd_compat_type1{,v2} modes
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add new IOMMU modes for using iommufd in compatibility mode with
VFIO_TYPE1_IOMMU and VFIO_TYPE1v2_IOMMU.

In these modes, VFIO selftests will open /dev/iommu and treats it as a
container FD (as if it had opened /dev/vfio/vfio) and the kernel
translates the container ioctls to iommufd calls transparently.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index b349d901cfdc..205bbfb3d54e 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -371,6 +371,16 @@ static const struct vfio_iommu_mode iommu_modes[] = {
 		.container_path = "/dev/vfio/vfio",
 		.group_iommu_type = VFIO_TYPE1v2_IOMMU,
 	},
+	{
+		.name = "iommufd_compat_type1",
+		.container_path = "/dev/iommu",
+		.group_iommu_type = VFIO_TYPE1_IOMMU,
+	},
+	{
+		.name = "iommufd_compat_type1v2",
+		.container_path = "/dev/iommu",
+		.group_iommu_type = VFIO_TYPE1v2_IOMMU,
+	},
 };
 
 const char *default_iommu_mode = "vfio_type1_iommu";
-- 
2.49.0.1151.ga128411c76-goog


