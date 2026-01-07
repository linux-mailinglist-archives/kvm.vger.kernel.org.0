Return-Path: <kvm+bounces-67264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E3A3CFFF48
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:18:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 60F1D3015025
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7658337BB5;
	Wed,  7 Jan 2026 20:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jvTjNPVM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5321A3179
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817084; cv=none; b=OruGqU4jIf+yZZcFiH0Y6aylSNwn14PTM2pFWyy6G6w8KHcDInp30DB3Hp85wFpfv3Cgn7bTJxn2ZBCUKs3jRo/yysDK6iq4Y/rho/U4p2F1TLfaIba69Abv5KbjmBnisrDhLx2glGyYiB62bJQO5pv268SuWSWWLhmlBKfXMAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817084; c=relaxed/simple;
	bh=TvOkn6u8I9/U/iJG9I9EEu4rPAWu4/Ro3ETE+xAntc0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lVVXetWLb9RHKlwn1KkpgLXL6SjPuCJB4v00wajY8fQR40GdVco+6gEXFrx+gjp7PiAXAE0K2mdsSajdVFNT9euq/fyTNU8F3evc8KqAc+PrapUliZeLw64piGrwMUl1GjipLrmhhpHc/r6qR92ejViLC68aHyew9Fqf3XSAZdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jvTjNPVM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7f21951c317so1892674b3a.2
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767817083; x=1768421883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BRji2ofdtY/PgKBBjoXBJuWSbx9X2KHKEteqA3GTxBo=;
        b=jvTjNPVMxJmjDKAmieHVKoN82boPu8dMM1BI4nKDo6dR83kADqx03a+wF2NvgK0gwu
         kXWHBURxdsmYa0/3w9dmVtc36HuLoqMMcLPCUgUwUHqz0cIrNyO1ezSCLe5Wr2L6SC7e
         dZ75ZxHlhixc6gpCHme5Cyu7add+wbECRa8kQMoiVhFsdq8q4aNV0yW5svxYQWWxT6KX
         0EUHFpulk47ycYo7aaW4ur7KPEJvDBmkVXRzu2nmo+ad3Ud8nWMk8VD3BvftQ/ta1d4T
         c55Pp2DNghxrhH9x0C7AJ+vi9yCKjP9spf7vQU62WcZ9pHba/ws2AoyGhjQYAqhe//E/
         MrBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817083; x=1768421883;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BRji2ofdtY/PgKBBjoXBJuWSbx9X2KHKEteqA3GTxBo=;
        b=Lcq0zsVc/lycAhXk8+25vvRxuS3zKViIpYWdoKk69iUBmZ6jSxmEm5z0z93229dief
         xEjZ15VuZKLBhbggEzwSIk/G4vATFZTjfDQM3k2ZQplR24gLW+lQQnagJceKgstCq39t
         yqvPGVWnKiTGMpox9ZR9R6uyZsb6kHb+JJv2uU2CPo8kAhEw1oEeqSVPIc5WpRw3pzck
         T5BciJTdOg+Ytgqt47Y8x2exAj2oEDpyDotKrX9Lkt6gHlKUyHHCdKhj5KVidhXr+zs0
         txjgeBUaL/tZCMKVdbgD9ZCsD+7YDMYGsAq35/LXxQkX1S7uMsv01QdxufIsQO9PONpD
         kOQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIcJN+IWeYjo7TUdLNFPAEzNTvqoKUPPLH0sByNrnn2tTkppIe9LQjkgeZ7oBFLvsmXQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuzkugYM3238W9vDvk4ug+1/FSaWDTUFeQy/AL+TQGwJfwI+Ib
	WjbKCqhA+7KYYOkamP8t3OFTs/V63xO0O0VFs4uqgdM53OP3AYmwIy2PgZpIjDj43YkmuhyTsVg
	bllmdq7fkpwOyjg==
X-Google-Smtp-Source: AGHT+IHpSjmtFIkns5HQtlhETgrC7VtMTaI0oceBagAYDCz1RUoLr1bA46QQW/+00lvC5tMM37yLiV7a8rdzpg==
X-Received: from pfblp20.prod.google.com ([2002:a05:6a00:3d54:b0:7b8:565a:73bd])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8086:b0:7e8:4471:8c5 with SMTP id d2e1a72fcca58-81b7f101490mr3287211b3a.38.1767817082661;
 Wed, 07 Jan 2026 12:18:02 -0800 (PST)
Date: Wed,  7 Jan 2026 20:17:57 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260107201800.2486137-1-skhawaja@google.com>
Subject: [PATCH 0/3] iommu/vt-d: Add support to hitless replace IOMMU domain
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	David Matlack <dmatlack@google.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Intel IOMMU Driver already supports replacing IOMMU domain hitlessly in
scalable mode. The support is not available in legacy mode and for
NO_PASID in scalable mode. This patch series adds the support for legacy
mode and NO_PASID scalable mode.

This is needed for the Live update IOMMU persistence to hotswap the
iommu domain after liveupdate:
https://lore.kernel.org/all/20251202230303.1017519-1-skhawaja@google.com/

The patch adds the support for scalable mode NO_PASID mode by using the
existing replace semantics. This works since in scalable mode the
context entries are not updated and only the pasid entries are updated.

The patch series also contains a vfio selftests for the iommu domain
replace using iommufd hwpt replace functionality.

Tested on a Host with scalable mode and on Qemu with legacy mode:

tools/testing/selftests/vfio/scripts/setup.sh <dsa_device_bdf>
tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test <dsa_device_bdf>

TAP version 13
1..2
# Starting 2 tests from 2 test cases.
#  RUN           vfio_iommufd_replace_hwpt_test.domain_replace.memcpy ...
#            OK  vfio_iommufd_replace_hwpt_test.domain_replace.memcpy
ok 1 vfio_iommufd_replace_hwpt_test.domain_replace.memcpy
#  RUN           vfio_iommufd_replace_hwpt_test.noreplace.memcpy ...
#            OK  vfio_iommufd_replace_hwpt_test.noreplace.memcpy
ok 2 vfio_iommufd_replace_hwpt_test.noreplace.memcpy
# PASSED: 2 / 2 tests passed.
# Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0

Samiullah Khawaja (3):
  iommu/vt-d: Allow replacing no_pasid iommu_domain
  vfio: selftests: Add support of creating iommus from iommufd
  vfio: selftests: Add iommufd hwpt replace test

 drivers/iommu/intel/iommu.c                   | 107 +++++++++----
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../vfio/lib/include/libvfio/iommu.h          |   2 +
 .../lib/include/libvfio/vfio_pci_device.h     |   2 +
 tools/testing/selftests/vfio/lib/iommu.c      |  60 ++++++-
 .../selftests/vfio/lib/vfio_pci_device.c      |  16 +-
 .../vfio/vfio_iommufd_hwpt_replace_test.c     | 151 ++++++++++++++++++
 7 files changed, 303 insertions(+), 36 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c


base-commit: 6cd6c12031130a349a098dbeb19d8c3070d2dfbe
-- 
2.52.0.351.gbe84eed79e-goog


