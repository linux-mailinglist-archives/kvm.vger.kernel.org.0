Return-Path: <kvm+bounces-61927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B7557C2EA5D
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 01:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 47EB14F825D
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 00:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8481FE45D;
	Tue,  4 Nov 2025 00:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S5wb4QYX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693CD1367
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 00:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762216549; cv=none; b=t0Ef2FY6BiaZ2UsCRWrvTMnwTQxC55aYVSwNvrS37C4+JTMu9bS/7o9DAKuSQ9L8uX8Sb3HlsIlXKHcuC7vzQOcbou3WpUZ63AbcClpDXVn+tOxCHOZ/kQDrWedHJd2HFuqunCAnIfSqdSwF+asNhr+ht9NulvlctSckmLYI4N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762216549; c=relaxed/simple;
	bh=J12sf3Gup8VxAlVwcUlGGSJgcvZXPv3vNw1w5YwsnkQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=W2SJhJib0Qiar4+wseDtYeUOWhBKKL20WqOF7a3YRntKzCQZ9BJkOR0DAYbyci3czbaO7fisSO3wY+DojKWKwh3zs+qZtSMs8O4TGtF7gKPpGXzNSx8uTGirsHlpkkQ029vKrKTIc5mnF+chD+Cq40SS/XqREMip1KJhbKheZLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S5wb4QYX; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-948177ed467so1404771539f.0
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 16:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762216546; x=1762821346; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vSVW06+pVd4pDgbHyrlMsErdqN3jivDXBVW0U437gUE=;
        b=S5wb4QYXO1cDY2aZYzX7piQY7pQ+3h6Ib47xTElSuAK9SY8YqPBj0UY8RheYOf4EHJ
         Qlp3MFwZL4NxiRDuvsikAj2VX3O4j7ttsb3Np1sfRTtBPJCT81lXquY7eSs6KBUke98z
         HWE51kpOeURAewV0B16qkk6omSzliTpUgvbVqToOeEY23emCnB4lAttbxXUGsCd53eZy
         eAUT9JLA5pxeUPQcVoY4eUBagq1c1kK2W+J1gRJ6oAnSU3eTBjoC0qtj6YGN24GpLGwQ
         J8mWpvZ73ImclAarNe6F+lTpg1d8/1GPvRNn6/bYiHkhc3FV6+Z8FXwYX244WTALqirJ
         AmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762216546; x=1762821346;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vSVW06+pVd4pDgbHyrlMsErdqN3jivDXBVW0U437gUE=;
        b=Hri80fuF+P52lj7I81LZ5rk1DoEfddWc2S3mTkW9pgOsVVmgFjf5vceagpU3IGmj9c
         jnWYTIgSIdHt8uHxuFqvQy3xUH7OrmR5X06LsurpPg7W5sE4rTQ+iU0c5GbVAmgkzbPx
         fGAdVMZrhaGbH+e32h2mjkVyE6s/gfRGT7xO/qWiavCPcmb2gbkclj7oZYKsXKJaMBsM
         iHIFWtWY5i1Y4fZRHE4Uy5/nDDPedQOHnmC+/SYmq2GPNNygC4JOBp0fWO9ctoiDq39v
         JKG2+LKXY9+3N1kLYwu04j83IKQ6TuEbMBaX32LdjGFlNKywKqs8NbV11Ytm+9WxN90D
         3E2g==
X-Forwarded-Encrypted: i=1; AJvYcCWZwCzq4Qxq+govcEfHqRkCYViHScES+V/c3VJD+bCYgbs/RK7GOD3Zb4gdVj7gDwezOto=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAtJFET8P0QinwlUI0/yPlAg/QgbxTOZs+t4O1BZb5mjaBQF+j
	ZXjcfFkhooDSrrz4Lm1D9byNkyBcVMeNxLU9bz8um/YMpVRay5rCiEmUmi/34ymccYDZQUPeXTK
	Q86OzMPyemw==
X-Google-Smtp-Source: AGHT+IFgXMlYo/O1xEmEJqlDiThcXEzV/Ub9UekrIDm60ecPn9RhpOr1DGHBEfBnEsjKKU8tOpheJohOlBqb
X-Received: from iobfp4.prod.google.com ([2002:a05:6602:c84:b0:945:abfb:6eb0])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:1694:b0:93e:7883:89a6
 with SMTP id ca18e2360f4ac-94822a5275emr2188205639f.16.1762216546593; Mon, 03
 Nov 2025 16:35:46 -0800 (PST)
Date: Tue,  4 Nov 2025 00:35:32 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104003536.3601931-1-rananta@google.com>
Subject: [PATCH 0/4] vfio: selftest: Add SR-IOV UAPI test
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This series adds a vfio selftest, vfio_pci_sriov_uapi_test.c, to get some
coverage on SR-IOV UAPI handling. Specifically, it includes the
following cases that iterates over all the iommu modes:
 - Setting correct/incorrect/NULL tokens during device init.
 - Close the PF device immediately after setting the token.
 - Change/override the PF's token after device init.

The test takes care of creating/setting up the VF device, and hence, it
can be executed like any other test, simply by passing the PF's BDF to
run.sh. For example,

./run.sh -d 0000:16:00.1 -- ./vfio_pci_sriov_uapi_test
+ echo "0" > /sys/bus/pci/devices/0000:16:00.1/sriov_numvfsdddd
+ echo "vfio-pci" > /sys/bus/pci/devices/0000:16:00.1/driver_override
+ echo "0000:16:00.1" > /sys/bus/pci/drivers/vfio-pci/bind

TAP version 13
1..45
Starting 45 tests from 15 test cases.
  RUN  vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
    OK vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
ok 1 vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
  RUN vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
   OK vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
ok 2 vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
  RUN vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.override_token
   OK vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.override_token
[...]
  RUN vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token ...
   OK vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token
ok 45 vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token
PASSED: 45 / 45 tests passed.

The series this dependent on another series that provides fixes in the
IOMMUFD's vf_token handling [1].

Thank you.
Raghavendra

[1]: https://lore.kernel.org/all/20251031170603.2260022-1-rananta@google.com/

Raghavendra Rao Ananta (4):
  vfio: selftests: Add support for passing vf_token in device init
  vfio: selftests: Export vfio_pci_device functions
  vfio: selftests: Add helper to set/override a vf_token
  vfio: selftests: Add tests to validate SR-IOV UAPI

 tools/testing/selftests/vfio/Makefile         |   1 +
 .../selftests/vfio/lib/include/vfio_util.h    |  19 +-
 tools/testing/selftests/vfio/lib/libvfio.mk   |   4 +-
 .../selftests/vfio/lib/vfio_pci_device.c      | 151 ++++++++++--
 .../selftests/vfio/vfio_dma_mapping_test.c    |   2 +-
 .../selftests/vfio/vfio_pci_device_test.c     |   4 +-
 .../selftests/vfio/vfio_pci_driver_test.c     |   4 +-
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 220 ++++++++++++++++++
 8 files changed, 377 insertions(+), 28 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c


base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada
-- 
2.51.2.997.g839fc31de9-goog


