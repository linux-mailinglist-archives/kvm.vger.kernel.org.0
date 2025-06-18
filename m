Return-Path: <kvm+bounces-49880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 234BCADEEF5
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 16:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C76E9189D530
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E912EACFC;
	Wed, 18 Jun 2025 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="Qtap48RD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A183A2EAB8E
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750256050; cv=none; b=uQEM5rQCMhpW3RqdvgbiG0O0jtN0u1DnL22b5rRM41zlI97P5Za3d3LV1K8FKuqeHNJGp6a+w8OUmHn1SxGTVhGPwLIJh5OdmcNGe1Lsy0UfLUCg6dwkUXeXYpv2pns5pbsJt6nD5NrSDwVxYJnZM64zcqNXqyRffc2w203gZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750256050; c=relaxed/simple;
	bh=YgtPxwKPTeZEZYoIXt8HkosylZM3S9CVqdbZuAkboEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxVkL2Wxmb3+41cq9VTmlOTVM32m/zd+qjfBQkCo/bqJX9tbnBTAkAuuqXJ42d0i9zl9BbIkOdKgGU+x3kmZmPXET2syPas9uDZj9vks6gw8Y0pNoeknnrfrat+XuaxPXZfojlHPI7VNdZniKOR1dIjLgccHWWnmwGNl8QqtHUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=Qtap48RD; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-607cf70b00aso13703091a12.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 07:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1750256047; x=1750860847; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JWbyA4a1n1aVjvP6ctgBaCKRdhrm2Tmki3ui2GQz4OQ=;
        b=Qtap48RDtlou7u57wrEbxaKIQaHVB850hPqUAlo0J22KUrSipuKf0kySHhniNMicHl
         5QjwC8KBWNIBl75ECRIpIpZbEHrrZ7sZOOrasSCicxabzTnFfeIPjjm16SEkwuIWpFO2
         1pqVtk1juSAPxDcVNqz/C8ZPHLDxiN533HWLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750256047; x=1750860847;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JWbyA4a1n1aVjvP6ctgBaCKRdhrm2Tmki3ui2GQz4OQ=;
        b=n/tduyA4il4xA6Wmqek8NRIXLmGznNDbgeJCYn0dwX8Tqmrxe2M/TmCMbjMie+TPf/
         TCwysz0cmzBZuybXTKQ+jtSexthaSJAIRLRpSJrChLEU+pP3r8qVQAhK3uEuXLrlHtb+
         rCJtUgD7EB49oMjc4JtV19pwUZiOqr9rgDSXZtqQkR/wFjv/Vo6FqJryQ+8R9AA6KzsU
         LekxPjWeeKyxmA/mnixydRmT1NNrxmeD6swFquPHnZ7FFeJNgm3v4Ei9E/8/a+/hh06V
         kXLkm5rHUYqAqmfr+g3yI+qEPfiKe3Yr420V3+zCqvzIN998zZ0alFbWH5Om7kIitFy/
         LlkA==
X-Forwarded-Encrypted: i=1; AJvYcCXZLXev5zl51CWH68v+gcYoaqKXHSYsHsb7ezveG8ClY0g8v2WxJ5cUDFeQYYb0VaQ0Gc4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yycz+elOT9jEUTLe647YVscwwUo+gqX2ufKXIF36wEwgMq/Vdia
	Ks+dzqYnhwXHhcBM1/+bJfutUYVGX/aPe0j/0y10xabp9ybSYqrsa4nSDCGZxUNDoFI=
X-Gm-Gg: ASbGncueVT5QIBTuvBQ/MeyD4N44duf9442b1pgj3gs6Jj61Dym4bkSKO+mNwBTgBt6
	GV4PSEsQyr9nMuSSoGHVlhYbqwhkAUTdI2ep2wcU94/yzPpIFUervFaG+JD0puXfQOVLTWgBCnH
	l/NL5TaDh6/8tNd3udy7yUEzopQH9dkLcaIvn+sk6kC2Y2YoIalaMPWW54ywXlZpjfzNPAYzNku
	Sa+CGBYbe8ZSw0k7IicNvUFmoxZltisZmysbHOc3ryvDYdLa9FMTAbnHoDc5NgkaEdnDTsOgc1R
	ZjKlJnSgVWvqfI3u53abxptNRpOqwaz64JG+A6fZJ+38o4s/ALupah2zvjRG2DIGm3WsPQymCA=
	=
X-Google-Smtp-Source: AGHT+IGsqCmrJXzMwPM+oH1kv5sMlk4UVUkN2dXKJGBUjRXie2yVHLpK2+aze7LyMOOgssnqt0k33w==
X-Received: by 2002:a05:6402:274c:b0:607:f63b:aa31 with SMTP id 4fb4d7f45d1cf-608d0853447mr14785409a12.6.1750256046873;
        Wed, 18 Jun 2025 07:14:06 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:5485:d4b2:c087:b497])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4ae68a2sm9640327a12.79.2025.06.18.07.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 07:14:06 -0700 (PDT)
Date: Wed, 18 Jun 2025 16:14:04 +0200
From: Simona Vetter <simona.vetter@ffwll.ch>
To: Mario Limonciello <superm1@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukas Wunner <lukas@wunner.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	"open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:INTEL IOMMU (VT-d)" <iommu@lists.linux.dev>,
	"open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
	"open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	"open list:SOUND" <linux-sound@vger.kernel.org>,
	Daniel Dadap <ddadap@nvidia.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2 5/6] ALSA: hda: Use pci_is_display()
Message-ID: <aFLJrHdfrTmoyhin@phenom.ffwll.local>
Mail-Followup-To: Mario Limonciello <superm1@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukas Wunner <lukas@wunner.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	"open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:INTEL IOMMU (VT-d)" <iommu@lists.linux.dev>,
	"open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
	"open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	"open list:SOUND" <linux-sound@vger.kernel.org>,
	Daniel Dadap <ddadap@nvidia.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <helgaas@kernel.org>
References: <20250617175910.1640546-1-superm1@kernel.org>
 <20250617175910.1640546-6-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617175910.1640546-6-superm1@kernel.org>
X-Operating-System: Linux phenom 6.12.30-amd64 

On Tue, Jun 17, 2025 at 12:59:09PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> The inline pci_is_display() helper does the same thing.  Use it.
> 
> Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

I think the helper here is still neat, so for patches 1-5:

Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>

And a-b for the vgaswitcheroo patch for merging through the pci tree or a
dedicated pr to Linus, since I guess that's the simplest way to get that
done.

Cheers, Sima
> ---
>  sound/hda/hdac_i915.c     | 2 +-
>  sound/pci/hda/hda_intel.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/hda/hdac_i915.c b/sound/hda/hdac_i915.c
> index e9425213320ea..44438c799f957 100644
> --- a/sound/hda/hdac_i915.c
> +++ b/sound/hda/hdac_i915.c
> @@ -155,7 +155,7 @@ static int i915_gfx_present(struct pci_dev *hdac_pci)
>  
>  	for_each_pci_dev(display_dev) {
>  		if (display_dev->vendor != PCI_VENDOR_ID_INTEL ||
> -		    (display_dev->class >> 16) != PCI_BASE_CLASS_DISPLAY)
> +		    !pci_is_display(display_dev))
>  			continue;
>  
>  		if (pci_match_id(denylist, display_dev))
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index e5210ed48ddf1..a165c44b43940 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -1465,7 +1465,7 @@ static struct pci_dev *get_bound_vga(struct pci_dev *pci)
>  				 * the dGPU is the one who is involved in
>  				 * vgaswitcheroo.
>  				 */
> -				if (((p->class >> 16) == PCI_BASE_CLASS_DISPLAY) &&
> +				if (pci_is_display(p) &&
>  				    (atpx_present() || apple_gmux_detect(NULL, NULL)))
>  					return p;
>  				pci_dev_put(p);
> @@ -1477,7 +1477,7 @@ static struct pci_dev *get_bound_vga(struct pci_dev *pci)
>  			p = pci_get_domain_bus_and_slot(pci_domain_nr(pci->bus),
>  							pci->bus->number, 0);
>  			if (p) {
> -				if ((p->class >> 16) == PCI_BASE_CLASS_DISPLAY)
> +				if (pci_is_display(p))
>  					return p;
>  				pci_dev_put(p);
>  			}
> -- 
> 2.43.0
> 

-- 
Simona Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

