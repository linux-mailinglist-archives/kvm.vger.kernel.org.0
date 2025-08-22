Return-Path: <kvm+bounces-55541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DA25B3245A
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4B111CE5919
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD23A338F32;
	Fri, 22 Aug 2025 21:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="clrbh3aS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D2234A312
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897986; cv=none; b=t9EpcLjMXe/gvK1o2egqfWUqWjdiovzKasFPEHRg/ZC/7Zvo5QQ8fluG2eChWligRkkEfMHuZ800V+znaQnJc+9YB/O1Ecbr2CZT0RdNYyFY0xRhVpX5YXsyzq9wgamO1rjANEVkYtBWAPYw1LZeZj7M+1g1SAAtFA795XA+hfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897986; c=relaxed/simple;
	bh=TQ1KjdwjO73wEviQRyY9T1nIZ8oPzyzQhoXUyBRVcN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fMBHteSS1lUl0sI9+q7p/cGUGsAAPLnWsSwB21YGlnWADJLn6vAT+0JhSU89m8REhySn/nW/cH2UumpCSrlhTM9eOxzjOP5pTpkN4qayZvm4KnQOat/Yf+eRVeGJxmhfvv0Ww9oHYTUPNp3jpLNezQxJ/MrREH1Z6Izv5FTf3Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=clrbh3aS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32505dbe21cso1536144a91.1
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755897985; x=1756502785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxgjnR/mmZ3HsP9pSRnYFNy1E6x4AZLI9uHNS2mBsBw=;
        b=clrbh3aSCZzm4fNx3aI98NGWhRcNkAjjHo9JZQCFg1eUvjoyG+hwQJaXS8UbAZHVuJ
         7jMum73LmXhRl9V32By3QZqOYTRxTZAirvYuRlFKJvk5Gm0hlhgzwupq/4nUmNOplB6n
         Fhtu1vZ0QbqeAoU4x3KtO28w277G/WI3+gBdDUPVgm7oULA83YSyO9IfrUrkeJPTu9ll
         cHobknqNjfFjubYIZIlT+36LNfChcmTn09RAJL8odU/dj4yxUN5MHWT4cRMGre0Z62uQ
         ByfxpaTep+wsRn2u8W5xrZOHfjAdxYxQEPzo0BqIY/X1InU8u45f9KhnCXUxTX5F6NDV
         bfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755897985; x=1756502785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fxgjnR/mmZ3HsP9pSRnYFNy1E6x4AZLI9uHNS2mBsBw=;
        b=LBTTKBBQHoPhFM6puzp6rphTTz5ulf0S9DeoPnn4UxtyPLqKxblu0d8RUEI4oKYgCy
         noCviIoNOrORri4zj7XRDRt9QVMdXcDAOVGHDcXOJV/M9s5pNLvJABbvNIeucKooU49H
         44aHeNAnjs5jqgSNy4OjFDKx4FD2ml8B9Dy/7EdZ2whIVZSNF5WzBd/8LwFbqTCYmng3
         xTo/j44sy0EaQeKB1dB65cmNasPhnCPMFG3qnmOXyfCCNNk2i2yRbpLz/oLq4zR4+s9q
         +fG/3jhBXYiFTcZ7P/qY4VrMC/vZ9OJqntoAug+UvMWrJWU3hRLizNuLLTSSudqA9RsC
         +29w==
X-Forwarded-Encrypted: i=1; AJvYcCUw/l+XL/olXSij3ZjMATqoBx+ihP7I2ckZ0TFX7xlWMogG0OLOM9/AueXQskfWlLVYwbc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyey+Jh142ldSPweIH227ZD+5l6xk+CQPY4g8CowFLuZCXaE1//
	GZkZbWMinGHT7KGWnXruKq89mFbTYGxsxaNthJj9muaUIUwFODHflDw5WOfDcAvVjL4FtLoZ+ca
	7AX30fMobgtM6Vg==
X-Google-Smtp-Source: AGHT+IF7yhhlyVuariIcDyAcZdKcG11P/OaxWFAOXJ+dEJjnCfNOz/CtvNlx69DjI4NQ5GkMZIgqV9vhzaPWxw==
X-Received: from pjbqo15.prod.google.com ([2002:a17:90b:3dcf:b0:321:76a2:947c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5547:b0:31f:4272:c30a with SMTP id 98e67ed59e1d1-32515ebffcfmr5741867a91.30.1755897984730;
 Fri, 22 Aug 2025 14:26:24 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:24:58 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-12-dmatlack@google.com>
Subject: [PATCH v2 11/30] vfio: selftests: Add a helper for matching
 vendor+device IDs
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

Add a helper function for matching a device against a given vendor and
device ID. This will be used in a subsequent commit to match devices
against drivers.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/vfio_util.h | 7 +++++++
 tools/testing/selftests/vfio/vfio_pci_device_test.c  | 4 +---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 9c928fcc00e2..a51c971004cd 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -167,4 +167,11 @@ static inline void vfio_pci_msix_disable(struct vfio_pci_device *device)
 iova_t __to_iova(struct vfio_pci_device *device, void *vaddr);
 iova_t to_iova(struct vfio_pci_device *device, void *vaddr);
 
+static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
+					 u16 vendor_id, u16 device_id)
+{
+	return (vendor_id == vfio_pci_config_readw(device, PCI_VENDOR_ID)) &&
+		(device_id == vfio_pci_config_readw(device, PCI_DEVICE_ID));
+}
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_VFIO_UTIL_H */
diff --git a/tools/testing/selftests/vfio/vfio_pci_device_test.c b/tools/testing/selftests/vfio/vfio_pci_device_test.c
index 1b5c2ff77e3f..8856205d52a6 100644
--- a/tools/testing/selftests/vfio/vfio_pci_device_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_device_test.c
@@ -56,9 +56,7 @@ TEST_F(vfio_pci_device_test, config_space_read_write)
 	/* Check that Vendor and Device match what the kernel reports. */
 	vendor = read_pci_id_from_sysfs("vendor");
 	device = read_pci_id_from_sysfs("device");
-
-	ASSERT_EQ(vendor, vfio_pci_config_readw(self->device, PCI_VENDOR_ID));
-	ASSERT_EQ(device, vfio_pci_config_readw(self->device, PCI_DEVICE_ID));
+	ASSERT_TRUE(vfio_pci_device_match(self->device, vendor, device));
 
 	printf("Vendor: %04x, Device: %04x\n", vendor, device);
 
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


