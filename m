Return-Path: <kvm+bounces-49753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BEEADDBAF
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DA681940398
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EB72EAB65;
	Tue, 17 Jun 2025 18:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BZxCee7J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206FA2E06E9
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 18:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750186367; cv=none; b=K6xCXeFnGPbwPvP65DW/aMhaPK0h7Mksv/tghOHWFyx3p6qsqmFhteWtZ7c91OY6qc/EshuXTx1JH5GPXfPNUB73/Fya5q6vajE3DBG04SQTlSbJMb/fK37+6zSWHMUJkebbKx6PzsRETO5pxOXqXfd5nRKXylyFlbQ4VhTUHd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750186367; c=relaxed/simple;
	bh=+toRoMC/6o3ABSZSoj6kwUB+0AHRoQQb9StmVaDTJuU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cthL9NTac1wjE8/GBYmXAmvS/68EadjgOIc3yI3Mp9W/mmM6uec2QPqNcEo3HakNNAdyBqkYNR0O7upX3nw/fKCk7Y4hFi4I4so896vJUhVhyYMCZiRRbL9cFvinsT02aNR33JeEkm71fvMiDI9m8BRjsmKk7lNRMc61X1NYprw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BZxCee7J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750186365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7GR8b6oq+VKsS7zEblPcoLobXIu9Z0EZdf91JZ1evE=;
	b=BZxCee7J+REm65pWAt4vMMk2MBzboHYoIB0bB892iLKG4lnGvI6zzk147A3OeKwF05lR2r
	h7PkqaLGAgxZXlmVPvQO8+51UH2bwSDAL7tziFFsoWIf52SVVble+BxvlTJAlBePDqTSfF
	4ZOfr5BfB52B3rqrk3Sv1cgxDeis4jU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-bZB890qGOFi5yLQoEXT_1w-1; Tue, 17 Jun 2025 14:52:43 -0400
X-MC-Unique: bZB890qGOFi5yLQoEXT_1w-1
X-Mimecast-MFC-AGG-ID: bZB890qGOFi5yLQoEXT_1w_1750186363
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-87333a93bd9so50996539f.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 11:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750186362; x=1750791162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7GR8b6oq+VKsS7zEblPcoLobXIu9Z0EZdf91JZ1evE=;
        b=DHz9mcikK0XudHJ0Q2VyjeblAV0onuqNQRsI95jkzAd537ZC3ylFJkJbJ61D/1Z0jv
         Hc+Exo5iXNV9yIlHI7Be/d06H8vG+mtEBzLPVeL/5lKoA+c5L2j3AR4rTfOPL4BYIYF8
         J8oKoIauXMPx6HbjsXxaxO66jhab3CfhXiC2Q/nCBzxbO2HvrxAFcoaM8UGcv+AsOSFj
         ANdq86uu9z7qvYOaDLGofNgMGnFEN5bc5HweYnmdSBu9xWqdS50w7SDQopKwdwq9CM9v
         ZaoMbbWji368hFbWbOJbu+j/Msa3/v1ir+BRMEKaMR/2gVfDJWvrUDzjPccDQxN8BEV0
         yJZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWezvr8ag5EkhN1D6V+CL4wDhzxAbZU3xTZKuonOlYVDjEto/QbkvwHIwyseHNyuclBp7g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUQtUTtPfmPD25B7dQ7eQS1txilvtsTmTdeiZFVz8B200dH5Bq
	OJaRmv3II97dIrH3ieYYUUAKeM/zGo6g5Xh0Zlb/2okheJttpzHCwbgtLnnpVBCf0KMJmw+uulP
	DB9+qhagsEUPmDXHOJMKpP4akH2NJ2qbxPgHX5bd6Ud4uDFvcGNimaA==
X-Gm-Gg: ASbGncuOUEsZyUkandC3Bra4quaT2COtPCdcAvM6ZdhpEbUnCY39/nj4jwCzQrzzIOK
	PxKvBc2XFPZf53tduteZtLCAbqN7us0fFr+ws5aJkwJCbSKuTm7p6nBb2wwkrJPMCQtFH/lbrYq
	aP4uUtaHd22iu10hWIO4W6PWgSsweualJEiL1pP7fl72NgWTX5s7XdjIOV+19CJioRNv533Z/zZ
	gWHw8llj0VCMlY4ZECyLvNFM8g3V/chIC3Lkwn9cIUMaMkx2VvGT956DUbKB5xMVtnQqDerREsu
	IqO6SJUrqv7Y6liBhC4fe/iKVw==
X-Received: by 2002:a05:6602:3414:b0:86a:24c0:8829 with SMTP id ca18e2360f4ac-87601391479mr183501639f.0.1750186362585;
        Tue, 17 Jun 2025 11:52:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKthDmryWBtQYhqN8X3vXXpFX6gedZAuw/STdWF8X1NR60JiUUJho0FZmRHCrhQiS9JYovUQ==
X-Received: by 2002:a05:6602:3414:b0:86a:24c0:8829 with SMTP id ca18e2360f4ac-87601391479mr183500639f.0.1750186362211;
        Tue, 17 Jun 2025 11:52:42 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875d5842a19sm225353839f.44.2025.06.17.11.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 11:52:40 -0700 (PDT)
Date: Tue, 17 Jun 2025 12:52:35 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Mario Limonciello <superm1@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Lukas Wunner <lukas@wunner.de>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Woodhouse
 <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel
 <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy
 <robin.murphy@arm.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
 linux-kernel@vger.kernel.org (open list), iommu@lists.linux.dev (open
 list:INTEL IOMMU (VT-d)), linux-pci@vger.kernel.org (open list:PCI
 SUBSYSTEM), kvm@vger.kernel.org (open list:VFIO DRIVER),
 linux-sound@vger.kernel.org (open list:SOUND), Daniel Dadap
 <ddadap@nvidia.com>, Mario Limonciello <mario.limonciello@amd.com>, Bjorn
 Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2 2/6] vfio/pci: Use pci_is_display()
Message-ID: <20250617125235.13017540.alex.williamson@redhat.com>
In-Reply-To: <20250617175910.1640546-3-superm1@kernel.org>
References: <20250617175910.1640546-1-superm1@kernel.org>
	<20250617175910.1640546-3-superm1@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Jun 2025 12:59:06 -0500
Mario Limonciello <superm1@kernel.org> wrote:

> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> The inline pci_is_display() helper does the same thing.  Use it.
> 
> Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index ef490a4545f48..988b6919c2c31 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -437,8 +437,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
>  
>  bool vfio_pci_is_intel_display(struct pci_dev *pdev)
>  {
> -	return (pdev->vendor == PCI_VENDOR_ID_INTEL) &&
> -	       ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY);
> +	return (pdev->vendor == PCI_VENDOR_ID_INTEL) && pci_is_display(pdev);
>  }
>  
>  int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)

Acked-by: Alex Williamson <alex.williamson@redhat.com>


