Return-Path: <kvm+bounces-47643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16ED2AC2C63
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16F8AA45309
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4206C226CF6;
	Fri, 23 May 2025 23:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mkCS3SeV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013B0224B1A
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043068; cv=none; b=jFtFL/j9pi/HJY5io9P9MCZDCVv4V8xydled7dyzRYGEeTuUkOnOItnBrXNUZU6f6/Hsgk637ZJqE/lRV+e4wbpQry09liGbdYX6eDmXaC644OVypAw1jVRsmJQIcLqDSCkoLCJr+FYw8czBtiHdQioV9i2UiFdEh54eIBWs0X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043068; c=relaxed/simple;
	bh=X+euZdZoZpddWqZMzeoy3FLjnq7jbQo8WKIoHBdC7qg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UbiSfYYXR6wqRBVkEOEE2Y/CEeTHrkJgUydINvpTg8GZGRYf65pSZ/Lapo/LOlwPS3mCVxHvYKognFlOggpPFV7Z133qiDkHckKwO+YDWFDGskxi4J0c1THA/xul+SbH/v+k2QGx4fwUfjhFMv/7GIDJwvyV2LakJqiA4yjm2j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mkCS3SeV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9659a391so350952a91.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748043066; x=1748647866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g0YXEfxWTnZg/xvLPHoE8E2iQx+MqJKABRgYpFk1dMc=;
        b=mkCS3SeV9LW3EbWBjE8TTjFZPMtPzy6IAcZUtdKrrpusJt/C5WcDcZZobDxAsRwymg
         /dBGpNPwWH5m9QU9J3IerkVTw53qQNI9orkBmdt6hHhM9NYtyiGaDZyELx9rmuo9YnxR
         ScaDqyVgJ9ZTv2DqZHOlSSLcVYL9k508KYLZ8YE+4cB6Xz8MaCYB3CL0XYoVJ5Ilb1MH
         TIDRdwgjqICLyRH1VaCOMrpzuv+zSNjfDsks0cDx09tfmfD8A+Dv6KbspTDNSbGML7PO
         RnDmNYgwWj1+UyFiQzglyg10snhydybkJ+Yvk4J+LofTFAfN6Zt4U1RdA8yhD6pr0ZH2
         awig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748043066; x=1748647866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0YXEfxWTnZg/xvLPHoE8E2iQx+MqJKABRgYpFk1dMc=;
        b=g2Ame8ImEkNDmUFozIPm6sSY9f7hgAeUpGusn+A1iguBICPaC9G2XyqCNs3oAnksoH
         OyQEssyE/Q3jL/YTCtO/cW6prMWCOlHy2+Tbyyzdzw/d7L0Yv+C0+HKQ1IolSwTvOisV
         akNv6RW1P8FcSwB1pdSl91N9ez/D6rv6PsswCZXjriZaWiYzTXpacr3JumiWQU730CI9
         8MDiU/o2vhlq0DflLHEb/4IVOsqZEOXt6G1ixJ2V3guxtluLwAnAR+dQpvTw8XW4tyYK
         f6halIC40LtQDCFwd5cog3pN7kwx0zcq8pDbSdBrPryOQyhIS+yYVo1WAy0JHRsVK06U
         ppIg==
X-Forwarded-Encrypted: i=1; AJvYcCXINCBwx7Afn7QL9zgZYFQchm8Sr2GXraj0H76OcVE7AVj6yqf2FkKbBvr68PDCFJxQKOY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb4G/B7oUrLtM+PdPzCylkYzfwQJqTOjv5nqGmQroENnGZlSpw
	M2o4FkQ+MhaSYt7fW4anyFAcQxjKpBHCNCQ7+POMAw2Cmhwi4WrS/YuxLCF50ek+Rw4FYe6wfVe
	rEU2qUbb4R0v+WA==
X-Google-Smtp-Source: AGHT+IH/PmKCTZtTNzGHHx43+ALl5MN4ZC9cGFSlKZ3t4SSiNhO3X7qXiDNh+cBlSEiLI1IsugWOX59jAem5FA==
X-Received: from pjbqd3.prod.google.com ([2002:a17:90b:3cc3:b0:30a:a05c:6e7d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:55c3:b0:30a:4ce4:5287 with SMTP id 98e67ed59e1d1-3110efc8a0bmr2112243a91.0.1748043066494;
 Fri, 23 May 2025 16:31:06 -0700 (PDT)
Date: Fri, 23 May 2025 23:30:11 +0000
In-Reply-To: <20250523233018.1702151-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523233018.1702151-27-dmatlack@google.com>
Subject: [RFC PATCH 26/33] vfio: selftests: Add vfio_type1v2_mode
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

Add a new IOMMU mode for using VFIO_TYPE1v2_IOMMU.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 950c83fee3ed..b349d901cfdc 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -366,6 +366,11 @@ static const struct vfio_iommu_mode iommu_modes[] = {
 		.container_path = "/dev/vfio/vfio",
 		.group_iommu_type = VFIO_TYPE1_IOMMU,
 	},
+	{
+		.name = "vfio_type1v2_iommu",
+		.container_path = "/dev/vfio/vfio",
+		.group_iommu_type = VFIO_TYPE1v2_IOMMU,
+	},
 };
 
 const char *default_iommu_mode = "vfio_type1_iommu";
-- 
2.49.0.1151.ga128411c76-goog


