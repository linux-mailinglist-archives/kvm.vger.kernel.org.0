Return-Path: <kvm+bounces-34512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38059A001E0
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 00:50:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C1F018837AB
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 23:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809A31BDA97;
	Thu,  2 Jan 2025 23:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FjAjRvA1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5EE1B6CE9
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 23:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735861813; cv=none; b=lErZG2XBdTAl3F5WtxXMebR33I3acDOVdloqORjHRTvbL2ooeT1Kri33vG9r4EhpMuaCmBMSRRPJ17p5+iYuSgQGgug5deV0OgZ/KO95WHYJ6Be4neOs7bt8GfB6XUwAxzSJeGmqYarMTm/WapnsW+ElyWwZoaFjgM89Wrmktmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735861813; c=relaxed/simple;
	bh=P3f0e0KsZC3uxVFqjTtm1/WBjQsByv+LK7vD91x80rY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrFLVi5oT3XqMMFa4Y5b4jQgBRzUp6AajFQ0eDkYAUwe9ZdPcPuZ3+E6i8WNrdwQtIaOtAGHMKLOW7zexMAoG8xIhfGAg96kM3+D7x/KhAW0aUs4xSqe4bh6eFvux7FkW25aoeHdO5Z2u8BXvDFgoEldm96/OqYfHAVX+CeTP1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FjAjRvA1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735861810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+31JuwM03Y6EdVp3v3LgbQg7ZDKiY/lu+6/XlJPbttk=;
	b=FjAjRvA1Rti2xs3xL5wgM71uEwOe9TKyTRWoWUeSKowi3j/7a4AodxpKT+HBUl9BgwP4fs
	dqXCh31FR5fqimMhW8nKEYWpjws2Kwo94lJFxhjWr9czffryBV/llDTfSNAVJaVHTby3Iz
	dWCnDKMenrjG/ePcLehRH0EwiHS/HUQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-ixDMYjZPPGuhDUvas2NLtA-1; Thu, 02 Jan 2025 18:50:07 -0500
X-MC-Unique: ixDMYjZPPGuhDUvas2NLtA-1
X-Mimecast-MFC-AGG-ID: ixDMYjZPPGuhDUvas2NLtA
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a78fc19e2aso13709495ab.3
        for <kvm@vger.kernel.org>; Thu, 02 Jan 2025 15:50:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735861807; x=1736466607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+31JuwM03Y6EdVp3v3LgbQg7ZDKiY/lu+6/XlJPbttk=;
        b=RtdNY3GM+8BPXmkwphz/d5OIYF5RQNBK0YGfEpwbtWDWkMUyVhE2DRPrQqjdOqOrUG
         +FNlqQUmR0qHg6x94up4P1cwoSyTU9w0wb5pDTEg5dH18bqTSAkCZ+N/AbljNEHy/Weh
         w2bS6MSsvW7Xh8NdpUA2kN2Jsj+Xtdz800pMfK6MyJTKw5psr8SFS4did2ewOczc4sLr
         b7x4jrpnHzjXgVbzhuLccwEtEcqNqyPPTepSABbwp3roIW0FiESrFqQZVhU6Vnid3e0h
         NKDxamf0U8POtt5vjql7tZCYeaBorpE4O1xexdFbdRHgKOdF2bEyHmJVhJSbn00yYYbD
         l62w==
X-Forwarded-Encrypted: i=1; AJvYcCUOd4RVXGCO2t+/HcKwstzFetMRU0lcWy/GCCU1eN+Xm7O/5RGXRGUzhxfr79Vms8JR7oM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN7CWELgyFnmgdHhpsL9phLqH6EiMsoqeo4TIwRdOiBKgegYY8
	AluwGC+CnUAczL3TW3KtwKCOMmmmgrBmp7nKbpmwmZtucA0mFfM7MOZPJ9VQIg1uPvMLPfuQvV8
	og8o8t9xG0xBBhHkq778e2MF+RFnKtA1TSPzw2CNPDmMKEWIhJQ==
X-Gm-Gg: ASbGncvDkDzrbzx+9Lvu3OtAjfCng34y5uG8Oc3g385Dyt3Eeh07mRDd82TS+gk45iw
	m8wDYzDeeQfwzDGKILwE4vR7G4K9tkiBXVO/iEN4QhFs6EnF1shIc2lZFYJhvvfEUvPHHrwL4dv
	BEKorihHIJzqt7e10pn11wGcvyS23cKj79pwhIuLdiXZQTr8h8fIMlsXgrnWZnnegtMBcENLxNY
	GTNCKE5eOcUmmgy4yjgi5mVaNyBBibDt7Kmy25P/4YyAydisZ5xpcGvQapV
X-Received: by 2002:a05:6e02:2198:b0:3a7:bc95:bae5 with SMTP id e9e14a558f8ab-3c2d5247952mr101091285ab.5.1735861806804;
        Thu, 02 Jan 2025 15:50:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPdiuvD3nbQOVUd7KLLxbQIFjMW4WTn8Dgh4Oc4yWHhIFUQMePiqwfOYLyExiaxztN6ea8Zg==
X-Received: by 2002:a05:6e02:2198:b0:3a7:bc95:bae5 with SMTP id e9e14a558f8ab-3c2d5247952mr101091245ab.5.1735861806487;
        Thu, 02 Jan 2025 15:50:06 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf4f405sm7075401173.6.2025.01.02.15.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 15:50:05 -0800 (PST)
Date: Thu, 2 Jan 2025 16:50:04 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: zhangdongdong@eswincomputing.com
Cc: bhelgaas@google.com, yishaih@nvidia.com, avihaih@nvidia.com,
 yi.l.liu@intel.com, ankita@nvidia.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Remove redundant macro
Message-ID: <20250102165004.2470fbb0.alex.williamson@redhat.com>
In-Reply-To: <20241216013536.4487-1-zhangdongdong@eswincomputing.com>
References: <20241216013536.4487-1-zhangdongdong@eswincomputing.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 16 Dec 2024 09:35:36 +0800
zhangdongdong@eswincomputing.com wrote:

> From: Dongdong Zhang <zhangdongdong@eswincomputing.com>
> 
> Removed the duplicate macro `PCI_VSEC_HDR` and its related macro
> `PCI_VSEC_HDR_LEN_SHIFT` from `pci_regs.h` to avoid redundancy and
> inconsistencies. Updated VFIO PCI code to use `PCI_VNDR_HEADER` and
> `PCI_VNDR_HEADER_LEN()` for consistent naming and functionality.
> 
> These changes aim to streamline header handling while minimizing
> impact, given the niche usage of these macros in userspace.
> 
> Signed-off-by: Dongdong Zhang <zhangdongdong@eswincomputing.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 5 +++--

Acked-by: Alex Williamson <alex.williamson@redhat.com>

Let me know if this is expected to go through the vfio tree.  Given
that vfio is just collateral to a PCI change and it's touching PCI
uapi, I'm assuming it'll go through the PCI tree.  Thanks,

Alex

>  include/uapi/linux/pci_regs.h      | 3 ---
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index ea2745c1ac5e..5572fd99b921 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1389,11 +1389,12 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
>  
>  	switch (ecap) {
>  	case PCI_EXT_CAP_ID_VNDR:
> -		ret = pci_read_config_dword(pdev, epos + PCI_VSEC_HDR, &dword);
> +		ret = pci_read_config_dword(pdev, epos + PCI_VNDR_HEADER,
> +					    &dword);
>  		if (ret)
>  			return pcibios_err_to_errno(ret);
>  
> -		return dword >> PCI_VSEC_HDR_LEN_SHIFT;
> +		return PCI_VNDR_HEADER_LEN(dword);
>  	case PCI_EXT_CAP_ID_VC:
>  	case PCI_EXT_CAP_ID_VC9:
>  	case PCI_EXT_CAP_ID_MFVC:
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 1601c7ed5fab..bcd44c7ca048 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -1001,9 +1001,6 @@
>  #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
>  #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
>  
> -#define PCI_VSEC_HDR		4	/* extended cap - vendor-specific */
> -#define  PCI_VSEC_HDR_LEN_SHIFT	20	/* shift for length field */
> -
>  /* SATA capability */
>  #define PCI_SATA_REGS		4	/* SATA REGs specifier */
>  #define  PCI_SATA_REGS_MASK	0xF	/* location - BAR#/inline */


