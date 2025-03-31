Return-Path: <kvm+bounces-42259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E88A76D3F
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 21:06:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90B1F188CF7C
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 19:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FB521A446;
	Mon, 31 Mar 2025 19:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bRXvAGek"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB9B219A97
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 19:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743447961; cv=none; b=Uz8DRNmv8K9ykDsEsa1la+rHKlRtQJnUuAtccny//eXw0b5zsMeRnn6f1+Kepq6HWnX51nsXbQduc92o4jFexzzTYUWC7GxqACDL4XNtKvc9uoztG4H10cZgE6iGVhi25kQWmgvHNhaKPkq8guIeR7pw8gWRazRQGDZnfj6vvZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743447961; c=relaxed/simple;
	bh=ymtz3LKXQelnMrMnB1EtIZhse9Mr3gBZyo+pb7yu+nI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=GCiLMQY/gFUAM5UzbJOyhMzwTZTDHa8MwVk3zzA+wQGq796P3U/Fb2DqEQJMF5iDS1cMET0+Ne/IRPOzUshJhn5EZ1VmW+7vFcxeeBRiFer7oFNwLXheZAPUqfmCeITTsL7vxLdspPD/Sd1nncqI1pMNxjKS5sM48kDUp6W8Tys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bRXvAGek; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743447959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uzKnw77swTeh7HXFgYoBa2NfI5F2/BsDtkjgKan+l0U=;
	b=bRXvAGekhd7fXqhK8wL1dCep70UH9qMYOZYXhruLjfJc/64D8veJ37U63RvgC2YY4LSbLs
	DF2OAkmmmDuE9OqzCySF6mPeKDGCZ6xfNLZq7rNsT46ghiGXY6c7gGEPX6167AfKYW31n5
	dhxb75SLra3sZlRWCuLpE0YEUPkl7hc=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-93dtu5nBNFu8yMU371zeJw-1; Mon, 31 Mar 2025 15:05:57 -0400
X-MC-Unique: 93dtu5nBNFu8yMU371zeJw-1
X-Mimecast-MFC-AGG-ID: 93dtu5nBNFu8yMU371zeJw_1743447957
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-72c40acf311so74567a34.2
        for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 12:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743447956; x=1744052756;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uzKnw77swTeh7HXFgYoBa2NfI5F2/BsDtkjgKan+l0U=;
        b=jXWq3divi50KTCue/QPsmZy98iXN85lKJdtoxDW7es86S2LgwmeU6a87G3tGpKdw5T
         hNgmdQCnJqc85iWm2Hx9CLVsVoQbjfmIWU+sjbMwlHWR9pWggTpxMDcPENUk97GklNF1
         YcdSqleuBGfkxNSiHUGWaljoFyIfQmWVQATI/FXd4vIsOMdQRNNH2Xk0331uEpzaZTGU
         cGkWmolTCt/2bBdkdUwwNUUtl0ZTuWsVsL11KElfSs8FAJ7bbGI/LshItiCAFdO3Lr4V
         pQ2Bz/bRM79LO5xY3KBKvjQT9UnmpqqBe+oUJrr+mTQtfYjx1td8cpJDF61gPwsg9KES
         KSaw==
X-Forwarded-Encrypted: i=1; AJvYcCUNddFTlQ76Xm/7Rr2AxZ/Bx/vjfyF/dxgXSSo8LOBZWWk/yWokbKFsSdcmgHIQwvHXR1U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7CA42LVn3/kSayhsdPHZIO/6T9G9kFqTcWiIxbLhMRXdqqwBQ
	nDmfbXPEaIjh0+F7tiMSioixM4IvJWo0Effv6hGGbKlqkySPpb4j4jnXZXL9bON1428jRKTJ46J
	sxAw3zSQ9H/7DEVfqUT2uahRJJlB0zdVK8t2NUvh8WWvh7G8lC/Fh3e5Kog==
X-Gm-Gg: ASbGnctkcjFH+EpDdDNT4ktbKJ1OW0+MT2dG3IMo42/a89ws77xBGp4UMd0ji96mjou
	VxKPenpc6iyUVNy8MQvwY7URB239Ul4jCqPFwRxPfpp9aOVRz59QuO/s+a9yy4W+bDsrsYCDmKm
	kDR1fgkxw1U/gByW9ZDk5yp++EmL4jkq3zsuiYjrHA7sXKf3Wa6u64MOQ0z1jDghscwDkaJfFda
	uW85n9m4buM4LD3/LRrDlg7dq2TdHS4XXZb/0CuT9TIAOgIfOkahc+5YAL7hZ7C+1gyPbr0xNqh
	K4ukCFG4HdtOfUiznps=
X-Received: by 2002:a05:6871:4f12:b0:2cc:36b1:8c19 with SMTP id 586e51a60fabf-2cc36b1dd66mr41788fac.0.1743447955852;
        Mon, 31 Mar 2025 12:05:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGI7UGahoFOzLlam2TphSYmw3If0g3Dxd3FZsZxKkq/Qcp8nUCuQBdZUJ41G/+wxHja5olD4Q==
X-Received: by 2002:a05:6871:4f12:b0:2cc:36b1:8c19 with SMTP id 586e51a60fabf-2cc36b1dd66mr41781fac.0.1743447955518;
        Mon, 31 Mar 2025 12:05:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2c86a90e132sm1970717fac.45.2025.03.31.12.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 12:05:54 -0700 (PDT)
Date: Mon, 31 Mar 2025 13:05:50 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.15-rc1
Message-ID: <20250331130550.2f9ba79e.alex.williamson@redhat.com>
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

The following changes since commit d082ecbc71e9e0bf49883ee4afd435a77a5101b6:

  Linux 6.14-rc4 (2025-02-23 12:32:57 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc1

for you to fetch changes up to 860be250fc32de9cb24154bf21b4e36f40925707:

  vfio/pci: Handle INTx IRQ_NOTCONNECTED (2025-03-17 15:15:17 -0600)

----------------------------------------------------------------
VFIO updates for v6.15-rc1

 - Relax IGD support code to match display class device rather than
   specifically requiring a VGA device. (Tomita Moeko)

 - Accelerate DMA mapping of device MMIO by iterating at PMD and PUD
   levels to take advantage of huge pfnmap support added in v6.12.
   (Alex Williamson)

 - Extend virtio vfio-pci variant driver to include migration support
   for block devices where enabled by the PF. (Yishai Hadas)

 - Virtualize INTx PIN register for devices where the platform does
   not route legacy PCI interrupts for the device and the interrupt
   is reported as IRQ_NOTCONNECTED. (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (7):
      vfio/type1: Catch zero from pin_user_pages_remote()
      vfio/type1: Convert all vaddr_get_pfns() callers to use vfio_batch
      vfio/type1: Use vfio_batch for vaddr_get_pfns()
      vfio/type1: Use consistent types for page counts
      mm: Provide address mask in struct follow_pfnmap_args
      vfio/type1: Use mapping page mask for pfnmaps
      vfio/pci: Handle INTx IRQ_NOTCONNECTED

Tomita Moeko (1):
      vfio/pci: match IGD devices in display controller class

Yishai Hadas (1):
      vfio/virtio: Enable support for virtio-block live migration

 drivers/vfio/pci/vfio_pci.c         |   4 +-
 drivers/vfio/pci/vfio_pci_config.c  |   3 +-
 drivers/vfio/pci/vfio_pci_core.c    |  10 +--
 drivers/vfio/pci/vfio_pci_igd.c     |   6 ++
 drivers/vfio/pci/vfio_pci_intrs.c   |   2 +-
 drivers/vfio/pci/vfio_pci_priv.h    |   6 ++
 drivers/vfio/pci/virtio/Kconfig     |   6 +-
 drivers/vfio/pci/virtio/legacy_io.c |   4 +-
 drivers/vfio/pci/virtio/main.c      |   5 +-
 drivers/vfio/vfio_iommu_type1.c     | 123 ++++++++++++++++++++++--------------
 include/linux/mm.h                  |   2 +
 mm/memory.c                         |   1 +
 12 files changed, 106 insertions(+), 66 deletions(-)


