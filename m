Return-Path: <kvm+bounces-66623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F276CDAC9E
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 24AEF300CCE9
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84975213E89;
	Tue, 23 Dec 2025 23:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yu+SA2iq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2757F19309C
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766530861; cv=none; b=pEG8xuGAY7O2KAaR0Vouf0ZuhIL3q26ZZBaeKUWH/M3sbvLwJIpJgEmc7jawtA5Au6jNNFXPmtJ/hqFFsp7hibfhl7OmW2y3cfd/BTVdPDkC824diD1aOvQbZhfKM55/VlZKY3imtz35WqC8qujnoYpljtBcxr5irl5tYvHnx2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766530861; c=relaxed/simple;
	bh=AcyzLXHOlyEh2eTJThjUtfUNi/cdLQw4nxXq3JCV/Gc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aDz3K03b8RyxrBh10R4mN4WN3dDfy94afwfiX0enm048WIDQ4LR3HD1tUm+qIYghOMIUP0XmwmJDd2PV6pCcOkMFov2gungj45aPYF0FCk8ebp38hcVCeir0sIV0hs5Lf4F2KbogBLl6IzUX3KtOvMjn9R1YkQ0KnPktIGs2SbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yu+SA2iq; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so142298275ad.1
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 15:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766530859; x=1767135659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yWtlv9wKHU4mMU0rwsebBytNAAqoSWRSyobs+OYIPUo=;
        b=yu+SA2iq5MZ0Ba9z7uRIJfGR30GOkolwMq0mni5iUU6HDOphHf+oUOmTbq7eRf16ue
         Wr8De6UlvBKTmSdzdRd/gYsF+cObj0v5ugfVpLBfgidImbtdMLJypYj9Ks/5XN2u8zQF
         uhOeJ9R/G7VDNt5ru25tVsE3Khjqjh42RJChIpKkv4EqFBlSjfbRd6KOIp5N9+RBahds
         W5E8UJLejP5KsNd9eIVjvWW5/Bqpw3/CFNj0MGcNCu09wBqv862w8WtFnSZCBMiXhTaK
         7yG9ToCUyaIkF2aaNoJR+xsKNNoqW7Wj18hvkvpAL+iczQDcRUzbC4tCsG3lAm85mRSs
         rhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766530859; x=1767135659;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yWtlv9wKHU4mMU0rwsebBytNAAqoSWRSyobs+OYIPUo=;
        b=rrVECj1N5vPT89EGKuZioyzyzU8UE4S6B5SdOQxRioFhUCAOZd6RiE44t6LAATJ1O4
         ssK/4ui63xGen7/k2H1s3/cdv9dAWqEKvULCMPab2gpFOL+4jU2eZ2vcUPDuTTmcNyrE
         YqnKCACTyb/hKfH7vxfKIH7jEe6uqCLLyjomNAmG0QAZ1pxKMkX7C9i+kgPoiiRArM4M
         5DbGEhmi4B/Vsaq8zCTTJdTcLnlOBtjgvJpeFgQRD+xcaVQJoFS0CLo7hb017x8qPOM6
         6kpzSrMGpnzXQpuo4DLtoa2pdmQw/raj93AZpO1K342O4FhDNe14ahbAhfb+PTTYKz+4
         Vu7w==
X-Gm-Message-State: AOJu0YxUjSISkJKXxGxKKE8w3lTRGKb5TzLq7Bagp+0ZNFTG70KDMXJg
	N4KqgY/J/goEC8EB7N3PJ62pyyZgjnG/kVXzucq/SD9rCoaOzWcWuAlvXqwE7ViPMvha2IV4L3T
	96LVjk/SXgwnYnO1T7Ru/aw==
X-Google-Smtp-Source: AGHT+IH6C5fYKUqHVv6mDli+XJOu5wo4zi2zoEUL7xcEVt9VC/I/E2532A4J8x48rQ0oFk0PHeKmMYsQ+6bVj4NU
X-Received: from dlaj6.prod.google.com ([2002:a05:701b:2806:b0:11b:90ac:f6fc])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:270e:b0:119:e569:f260 with SMTP id a92af1059eb24-121721acfc0mr11920679c88.9.1766530859198;
 Tue, 23 Dec 2025 15:00:59 -0800 (PST)
Date: Tue, 23 Dec 2025 23:00:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251223230044.2617028-1-aaronlewis@google.com>
Subject: [RFC PATCH 0/2] vfio: Improve DMA mapping performance for huge pages
From: Aaron Lewis <aaronlewis@google.com>
To: alex.williamson@redhat.com, jgg@nvidia.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This RFC explores the current state of DMA mapping performance across
vfio, and proposes an implementation to improve the performance
for "vfio_type1_iommu" for huge pages.

In putting this together the IOMMU modes: vfio_type1_iommu,
iommufd_compat_type1, and iommufd were used to get performance metrics
using the selftest, "vfio_dma_mapping_perf_test" (included in this
series).

These changes were developed on the branch "vfio/next" in the repro:
 - https://github.com/awilliam/linux-vfio

The optimization demonstrated in patch 1/2 shows a >300x speed up when
pinning gigantic pages in "vfio_type1_iommu".  More work will be needed to
improve iommufd's mapping performance for gigantic pages, but a
callstack showing the slow path is included in that patch to help drive
the conversation forward.

The iommu mode "iommufd_compat_type1" lags much farther behind the other
two.  If the intention is to have it perform on par (or near par) I can
attach a callstack in a follow up to see if there is any low hanging
fruit to be had.  But as it sits right now the performance of this iommu
mode is an order of magnitude slower than the others.

This is being sent as an RFC because while there is a proposed solution
for "vfio_type1_iommu", there are no solutions for the other two iommu
modes.  Attached is a callstack in patch 1/2 showing where the latency
issues are for iommufd, however, I haven't posted one
for "iommufd_compat_type1". I'm also not clear on what the intention is
for "iommufd_compat_type1" w.r.t. this issue.  Especially given it is so
much slower than the others.

Aaron Lewis (2):
  vfio: Improve DMA mapping performance for huge pages
  vfio: selftest: Add vfio_dma_mapping_perf_test

 drivers/vfio/vfio_iommu_type1.c               |  37 ++-
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../vfio/vfio_dma_mapping_perf_test.c         | 247 ++++++++++++++++++
 3 files changed, 277 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/vfio_dma_mapping_perf_test.c

-- 
2.52.0.351.gbe84eed79e-goog


