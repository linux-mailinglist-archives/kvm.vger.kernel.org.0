Return-Path: <kvm+bounces-36560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 465E0A1BB09
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA69F3ADC8C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5FD194A64;
	Fri, 24 Jan 2025 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJHY9u7H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3161ADC94
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737737697; cv=none; b=XcwTS60ub3buXrA6KepYa/YPceXcB4C7sLvjDBtil4tysdgGtd5bv0N1CCHDRBwcbU72uRyYKcfgyu/9Y4PZQvy20r/jXxTQp2dTN3LC/amSTzl5r3RGzOj9atVHkG06DuU+qQhV2/HWP80+JZLqgLd8v3Al8JSNfdz5v2AoSr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737737697; c=relaxed/simple;
	bh=faMqG8W7sDvWfdUjhDJE24ZbccPcmL0uqWNgDGDoIsI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uBJxJ37gWZ95UCM6szXf8ztuiA3ODjBgX9xqjSU079Qaly2DS2nwjo5eiKzFVYqZ836WDa8yrEATL7TUrswAvcO19DYFpUT7FdIJutR+AAXlZr87FUTi66v/zQTVRr3L9f5cFlR4B4qpqXxkeoba2wTvZZHgITeWV1GeP7eDxlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XJHY9u7H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737737695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2i4/gk73/TMO7i3h7AhXDPAHWPVRvzPe+eifTfFqaA=;
	b=XJHY9u7HfF+72+EKNfcEV2QxPUmZAkPi0UesbDnV3ATSHXcrrzEn/WUha+Vfh44CWOczhr
	z9Gv/ATHXdu+rxUY49UxnyxuX/3SwdyTXnOUNofFj4k800hw2Iproa9pDobBJQO7RvMBbe
	0qgTof5sHgN2a8Gs6iRLc9Up8j6wbU4=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-26BoGfxxM5CMKGKqXeGCXg-1; Fri, 24 Jan 2025 11:54:53 -0500
X-MC-Unique: 26BoGfxxM5CMKGKqXeGCXg-1
X-Mimecast-MFC-AGG-ID: 26BoGfxxM5CMKGKqXeGCXg
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-71e2b058f00so468780a34.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 08:54:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737737693; x=1738342493;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q2i4/gk73/TMO7i3h7AhXDPAHWPVRvzPe+eifTfFqaA=;
        b=JxUaG9CG591zTNPBFLwfgyXljbqAyDzVV4moKnXvxekx7k8OcaU74pLtzONlhG32ZN
         VKGBWO2lZW7NzTaTSOI0B8hcbszJBekjcubAvQYqiV1nMHc304XGAJGhXfPLSnrhoE76
         Ks9mI7rH6ah0lef8bU5anye7jq+0sY6cNQ2U3k6aHNyIYyHxJPm8K8PvNCm5nokn9d89
         jHcRz4Vm7YNu8KIu4hI+kJs+U68ejwIzRcvQuhrSmFA5MM1ph62G8zfiK1+/XA3ZPgoT
         +lq0KilzcwiWN1kDXc9LBztDvS2qFjB5+DwvpXtwG/RFdqmZ5U7hEOB/MrCojRMFd5FN
         HhwA==
X-Gm-Message-State: AOJu0YynfF/QP1Y6e/UtjWZ4BlFRa3EZT8VXdHWya2d6VUhi/nBwGIvm
	wzyGy3PsmBpt4aNSxdhWSGnKxSN1qp8PZLn0B30cXed8cxQkTPDlD6cQV3QkhVi8Qm2T3gBLbnX
	VXMTmJyeIxtHcEi+A7Vo/a2AEBNfDouxqjKTwMDnoX9y0uhEi3iPWyKyUUA==
X-Gm-Gg: ASbGnctH6XGU5sNWhZ8Pp2PuL/RMfrZW79fu2tzKL98af0iA+u+v5QxY4kzeQsVDvby
	S6otEiLIZF6REKNJNclMNwd+YAi0Lhbp5AbuegCop1Xq0IuVCCdsHatBUBhC4arfT4EU9LvtKMR
	EaNnJTc/M4WF6AbTsg3abhahwIQzAf/jTZR++RXEQfzDnydFCeINCQ25Y5c0ywZvjt2dIhxZTmm
	WihNCdNVLF1yKk/vXrgSixaZYY33Dt7lXabFujPECpUEPadBP/q9GL9Xhgq5vCaP1saLiYOog==
X-Received: by 2002:a05:6e02:1a62:b0:3ce:8036:9ccd with SMTP id e9e14a558f8ab-3cf744dbd3emr82582315ab.7.1737734300590;
        Fri, 24 Jan 2025 07:58:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLgyT7swcZSmurx7XeuIxpVgyjL9z7o6UTWRZZr1Mw+SED2N463RL5QyO+/1j9DxcAQ9L5cw==
X-Received: by 2002:a05:6e02:1a62:b0:3ce:8036:9ccd with SMTP id e9e14a558f8ab-3cf744dbd3emr82582285ab.7.1737734300253;
        Fri, 24 Jan 2025 07:58:20 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cfc740f5dcsm7206405ab.3.2025.01.24.07.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 07:58:19 -0800 (PST)
Date: Fri, 24 Jan 2025 08:58:18 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Tomita Moeko <tomitamoeko@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfio/pci: match IGD devices in display controller
 class
Message-ID: <20250124085818.32930104.alex.williamson@redhat.com>
In-Reply-To: <20250123163416.7653-1-tomitamoeko@gmail.com>
References: <20250123163416.7653-1-tomitamoeko@gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jan 2025 00:34:15 +0800
Tomita Moeko <tomitamoeko@gmail.com> wrote:

> IGD device can either expose as a VGA controller or display controller
> depending on whether it is configured as the primary display device in
> BIOS. In both cases, the OpRegion may be present. A new helper function
> vfio_pci_is_intel_display() is introduced to check if the device might
> be an IGD device.
> 
> Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
> ---
> Changelog:
> v3:
> * Removed BDF condition as Intel discrete GPUs does not have OpRegion
> * Added a helper function to match all possible devices with base class
> * Renamed from "vfio/pci: update igd matching conditions"
> Link: https://lore.kernel.org/lkml/20241230161054.3674-2-tomitamoeko@gmail.com/
> 
> v2:
> Fix misuse of pci_get_domain_bus_and_slot(), now only compares bdf
> without touching device reference count.
> Link: https://lore.kernel.org/all/20241229155140.7434-1-tomitamoeko@gmail.com/
> 
>  drivers/vfio/pci/vfio_pci.c      | 4 +---
>  drivers/vfio/pci/vfio_pci_igd.c  | 6 ++++++
>  drivers/vfio/pci/vfio_pci_priv.h | 6 ++++++
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index e727941f589d..5f169496376a 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -111,9 +111,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
>  	if (ret)
>  		return ret;
>  
> -	if (vfio_pci_is_vga(pdev) &&
> -	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
> +	if (vfio_pci_is_intel_display(pdev)) {

I'd slightly prefer to keep:

    if (vfio_pci_is_intel_display(pdev) &&
        IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {

as otherwise the helper function isn't entirely honest in the implied
test.  Not a huge deal though, so

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

>  		ret = vfio_pci_igd_init(vdev);
>  		if (ret && ret != -ENODEV) {
>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index dd70e2431bd7..ef490a4545f4 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -435,6 +435,12 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
>  	return 0;
>  }
>  
> +bool vfio_pci_is_intel_display(struct pci_dev *pdev)
> +{
> +	return (pdev->vendor == PCI_VENDOR_ID_INTEL) &&
> +	       ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY);
> +}
> +
>  int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>  {
>  	int ret;
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index 5e4fa69aee16..a9972eacb293 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -67,8 +67,14 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
>  					u16 cmd);
>  
>  #ifdef CONFIG_VFIO_PCI_IGD
> +bool vfio_pci_is_intel_display(struct pci_dev *pdev);
>  int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
>  #else
> +static inline bool vfio_pci_is_intel_display(struct pci_dev *pdev)
> +{
> +	return false;
> +}
> +
>  static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>  {
>  	return -ENODEV;


