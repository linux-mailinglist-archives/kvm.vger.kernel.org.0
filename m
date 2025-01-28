Return-Path: <kvm+bounces-36807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA9BA2139D
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 22:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAE283A41E0
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C34F1EEA3D;
	Tue, 28 Jan 2025 21:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MLP8StOP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38FA1DF963
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738099487; cv=none; b=rktK6wvAkjJukJeJ2nx+yQ/L5oBkS+0RNA+SlOFAoaY3VVY0xYQivpyncDtpVO6BorSy0YFwtiXw1vtFcTFpQEUE+yy3h6NhqsVXB4h3jyaRnqSSjZX+zhIRlu4zkS5QbYn6fKoyxQHGPV1e/LJ6z2AM8VrTUPGMpOlU4YuhT3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738099487; c=relaxed/simple;
	bh=tycid4LRX36eXoKF4zOSilV20YomgXt1nsASiUTH2N8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=iT4eAKve7OzMumca0c7+/oegR/UXHvO16MNTfDIJKVycXE6J25o+V0No3ONczOCRUwv1VzZWMOEkaALP8i1aceHMn6RMlVBdMjdIUSpdbCZOmX2Ex0MuwFDBo+RZJULFt1Xm0nsRbNE66Nm8T35luObmorUKpjny6TCx+hYUNWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MLP8StOP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738099484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7CZrgIyryoc0JCOxJ5NgFaaoJhN/c/5O9d7nj1y3SgU=;
	b=MLP8StOPK3jvdcnDQL0kZTXuQPTMb1EMzSgnCIeP9/XalASRTLACtZGZ0m/e3CyFO6znvH
	RfZS6pXJt3RQGnRlWQgND6sLj6i5F/N2JlZ9og7eASwzyH78iiXhrcb4RUuMx3WtynIoFF
	DMMLU7z4On5o8PlZvUKBSNl7QYoCW3s=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-vYtCjSEKMsy18kcMoOEflA-1; Tue, 28 Jan 2025 16:24:42 -0500
X-MC-Unique: vYtCjSEKMsy18kcMoOEflA-1
X-Mimecast-MFC-AGG-ID: vYtCjSEKMsy18kcMoOEflA
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ce815cd25bso5011265ab.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 13:24:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738099482; x=1738704282;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7CZrgIyryoc0JCOxJ5NgFaaoJhN/c/5O9d7nj1y3SgU=;
        b=rC66VV7D4abo+2UHa108yRfAkVrHjXLQDb+cBxBOvmblFNU3HjANSN+d1B+cXu3LAU
         JgeetHz48xx/BRpcDggoOwBpX2bk+O39dVAHJDBy+yI1MvaIY53c2mhs/DJcxDmxzGfO
         Hwhq8w0tASTW8Y/pb+PpC19ZQzcTEVKWtO1O5yWYuIqZRwGJSZjIxV4cHxVwevR8oviL
         J6iEUw2c9CYVtw+kl/Eum5DAzGuHjZ6W4LE8WAE1b9rZ6UQVsYpxyBjG2kl4htR2ixff
         BJv4BHB81DJPANH3Sx3U3XGt7knVe4W7p071eJtN/cd5k3zt33VQxNEjZ7DSzRsMcWda
         Qyww==
X-Forwarded-Encrypted: i=1; AJvYcCVCf1qCos9PxWzfZAbHLicM7ozrma2leU6W9yuBZ5e2cBymvuQ2G3IPvtDzhVPCY5P+3uk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2j9L9fvDCXayBT24r/hSbi7InxjF3niRjKHInIBKPod1j12uR
	bD6sv1qCIm/8tV5AUkM2n1jArkR+FxtnAd2Ah193DUBtsr+QfZs02070mT5G1vhUdn40o4g9Gig
	7XvNap7mVyL/S8CYYVgE8SAfWvF3XvtoJ8TNQjQ8SIgjOxaPPeV91b+wWnA==
X-Gm-Gg: ASbGnctJgIjYfr3xWV+0DYNEfYFz+vNF80lH9cuki9A3SiHVoOyz5NJTqzN30tTY/Gv
	n7FSM1oWg8GmkbgY45Zt4ZkUjS6259i6vwRZuo/M1WqaODV0A/divCMTbDrSkrzgbV7SKzVBSCV
	4WrW43rFqgP7mmqZ05kgPQrka68EZF0bZtlfmUYgIwxXAqdwZ7hRJgvna0/XIrOxMMsmE82CqRa
	PKsa7Y5/tMaTYbKdlU1iOSK3odPSqgBNgajjs8GogF36c6iU9lztHgpKRfiNA8RuAEagjWc/7Bf
	YwuKJAEN
X-Received: by 2002:a05:6602:447:b0:83a:a068:75b7 with SMTP id ca18e2360f4ac-85427da8878mr24097139f.1.1738099482094;
        Tue, 28 Jan 2025 13:24:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMGOPp1q1m6P4yCWdt3otIExGkw/i35PpV5qiC9gP5JESUooqfZcoD3QEgB0DgzFLDUXof1w==
X-Received: by 2002:a05:6602:447:b0:83a:a068:75b7 with SMTP id ca18e2360f4ac-85427da8878mr24096539f.1.1738099481759;
        Tue, 28 Jan 2025 13:24:41 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1dbb1650sm3288522173.144.2025.01.28.13.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 13:24:41 -0800 (PST)
Date: Tue, 28 Jan 2025 14:24:39 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.14-rc1
Message-ID: <20250128142439.3f6dd5b7.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 13563da6ffcf49b8b45772e40b35f96926a7ee1e:

  Merge tag 'vfio-v6.13-rc7' of https://github.com/awilliam/linux-vfio (2025-01-06 06:56:23 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.14-rc1

for you to fetch changes up to 2bb447540e71ee530388750c38e1b2c8ea08b4b7:

  vfio/nvgrace-gpu: Add GB200 SKU to the devid table (2025-01-27 09:43:33 -0700)

----------------------------------------------------------------
VFIO updates for v6.14-rc1

 - Extend vfio-pci 8-byte read/write support to include archs defining
   CONFIG_GENERIC_IOMAP, such as x86, and remove now extraneous #ifdefs
   around 64-bit accessors. (Ramesh Thomas)

 - Update vfio-pci shadow ROM handling and allow cached ROM from setup
   data to be exposed as a functional ROM BAR region when available.
   (Yunxiang Li)

 - Update nvgrace-gpu vfio-pci variant driver for new Grace Blackwell
   hardware, conditionalizing the uncached BAR workaround for previous
   generation hardware based on the presence of a flag in a new DVSEC
   capability, and include a delay during probe for link training to
   complete, a new requirement for GB devices. (Ankit Agrawal)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/platform: check the bounds of read/write syscalls

Ankit Agrawal (4):
      vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
      vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
      vfio/nvgrace-gpu: Check the HBM training and C2C link status
      vfio/nvgrace-gpu: Add GB200 SKU to the devid table

Ramesh Thomas (2):
      vfio/pci: Enable iowrite64 and ioread64 for vfio pci
      vfio/pci: Remove #ifdef iowrite64 and #ifdef ioread64

Yunxiang Li (2):
      vfio/pci: Remove shadow ROM specific code paths
      vfio/pci: Expose setup ROM at ROM bar when needed

 drivers/vfio/pci/nvgrace-gpu/main.c          | 169 +++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_config.c           |   8 +-
 drivers/vfio/pci/vfio_pci_core.c             |  40 +++----
 drivers/vfio/pci/vfio_pci_rdwr.c             |  38 +++---
 drivers/vfio/platform/vfio_platform_common.c |  10 ++
 5 files changed, 196 insertions(+), 69 deletions(-)


