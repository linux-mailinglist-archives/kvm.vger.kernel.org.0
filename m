Return-Path: <kvm+bounces-57045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0ADB4A10F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5732A4E2161
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 05:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42272EBB89;
	Tue,  9 Sep 2025 05:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a5m0jrqU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D73D221F26
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 05:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394077; cv=none; b=SUY+q2Pb8XoAC1dvZz4IpSbBxfEarh/CxnaWVGT7FGSMyrcuJbHsr3sM2o6faddr/9Y27IgQUiOKWQ6o8EMy0tL5Fisx5tjcd52GcN3ucq7VbvCBpu8tfXw6d5zcSr7v74ulH3w8LGBfJYPnOGiO5/AcvwEpCZrOcODvNs8296g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394077; c=relaxed/simple;
	bh=MyQD77cAjsx3koLkQL4dZ/lIFxkKOLlM485XRyjXANQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4JtmillqyAT+Idw7ZHayqJotE5mWZRiFI7AVGrxjgxFYdHPa8tro34OL0Msm2eoymP2Rar6533R02GFCiNM3sDaVI4LqxgLmmq4TuVHUQPXMnjBjdxrw/OAduPjAwyTJE1GbFIr1fHj9GrqVRyT14PIZIi/hAJbPQKfdPsapfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a5m0jrqU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757394075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wmM7ymHL/oEefvbkHXDJF00eQsWO67ZJ3ZKRSeokg8I=;
	b=a5m0jrqUL4kREIzvi6JJ8vRb11/vyPfedJrgBjglB8RsgtvHjty42Li5El4ZxZbuDJCAh5
	FNkddiv6540CUjbncu7xoBFRS+W/Kxs1/ScSEEq10QgSolekSs4IhcoLThysTsN7Zzh9Xo
	jGIp2/NElkd8xWs3QScedGsmwVGrnKU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-jB_nfX_3N3OQSBXX23ybNQ-1; Tue, 09 Sep 2025 01:01:14 -0400
X-MC-Unique: jB_nfX_3N3OQSBXX23ybNQ-1
X-Mimecast-MFC-AGG-ID: jB_nfX_3N3OQSBXX23ybNQ_1757394074
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-7585b6deccaso1654156d6.0
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 22:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757394073; x=1757998873;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wmM7ymHL/oEefvbkHXDJF00eQsWO67ZJ3ZKRSeokg8I=;
        b=njVp3mWcEwzJQOXjLRCHggAgqJFSnOW24fKFMWVt3DYyXCbAfvg5JAGkiJz7fuKMHW
         +ErXtcxx03J3CmAQlO3tMhaP9hpx1Eh3LKoIf54fKR73Gjk2LHXJQoU24M/mWcTFGTZZ
         eNVnTfP8maCozn3ZKH7yykLTYzsSC4qZ0EnOhQkYk05vUDSc6RYuUxnU/5hivQwFxO2J
         WtBSkkX+7iqaQBO5cGehWKcmGtRgGbtcAj8jPOpG9ewoXweNKplVOTDXrTp7Mi/qG/Eo
         VilZ6ogCrOtH/fy1kfFo5N5K5w5jP+PxK+UdwHJSYQHHJHfbApnpVKhl9KnjWSucl9Fx
         8c3g==
X-Forwarded-Encrypted: i=1; AJvYcCW4W2nGeEujeDwekAM4c036Nk2MZE7H6cbq8GGSqXLKlBA5Xhvstcdba6VvEpTfENrBw14=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1iZ32XJbadeHKqDPr8u+uslDI93LUAlqJrwvuJcepqANxoG6o
	Xb4H34WBQNHNkKSYdaHCmanTFIIBTqbA+JE3uJEzpFy/h+q7vMQCNhN87Bb09xaM8Pc5dU6WMd/
	v9oPcY6V3lu8Z1KuLcaZagQ0D3f2IN+lebRzyKP6sr88wCGH72KsQAA==
X-Gm-Gg: ASbGncsR9xMIV8KZ5maDKRYiCdHtSYm9tEy2y+xehvIJMrssHt+Koc2IlJNG1S5CTap
	kou9jLF4CfYmA09bziHXO/fxESE8prkrywBT6bmQ6LtfrhlWp1yw2NvcVDLdrlzV1oLOsy6VK+H
	kmM+ledG29kzW2ly3lqnUL0ZBI55OY2guEao6YTsktibym0CR8hZNauRTuBJTRz1MvydowflYTK
	gokZW+GxkGyjMqfNDNfyi32ftr0Xf6eQpmUOxeHZD0UNU16OwNl75bU/hgCiGdQiiuIWzmYxRmt
	46HCbp+zufuEfjwlLlKSu72S0iC9BK5EPzn5XZKP
X-Received: by 2002:a05:6214:202e:b0:731:736a:bcd6 with SMTP id 6a1803df08f44-739492cd6a4mr90308106d6.65.1757394073583;
        Mon, 08 Sep 2025 22:01:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6LxTQIHgJ7KqLHWn9G0D2H5GjVpooVfL9ooFPQZ8Rx2Wu55/VAB6FIJdzOrsfvnjVbX7qXg==
X-Received: by 2002:a05:6214:202e:b0:731:736a:bcd6 with SMTP id 6a1803df08f44-739492cd6a4mr90307796d6.65.1757394073070;
        Mon, 08 Sep 2025 22:01:13 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-725dda254d4sm118146646d6.8.2025.09.08.22.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 22:01:12 -0700 (PDT)
Message-ID: <17c3072e-0c9e-48da-b236-2fefe8ebc823@redhat.com>
Date: Tue, 9 Sep 2025 01:01:11 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/11] PCI: Add the ACS Enhanced Capability definitions
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <8-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <8-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> This brings the definitions up to PCI Express revision 5.0:
> 
>   * ACS I/O Request Blocking Enable
>   * ACS DSP Memory Target Access Control
>   * ACS USP Memory Target Access Control
>   * ACS Unclaimed Request Redirect
> 
> Support for this entire grouping is advertised by the ACS Enhanced
> Capability bit.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   include/uapi/linux/pci_regs.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 6095e7d7d4cc48..54621e6e83572e 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -1005,8 +1005,16 @@
>   #define  PCI_ACS_UF		0x0010	/* Upstream Forwarding */
>   #define  PCI_ACS_EC		0x0020	/* P2P Egress Control */
>   #define  PCI_ACS_DT		0x0040	/* Direct Translated P2P */
> +#define  PCI_ACS_ENHANCED	0x0080  /* IORB, DSP_MT_xx, USP_MT_XX. Capability only */
> +#define  PCI_ACS_EGRESS_CTL_SZ	GENMASK(15, 8) /* Egress Control Vector Size */
>   #define PCI_ACS_EGRESS_BITS	0x05	/* ACS Egress Control Vector Size */
>   #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
> +#define  PCI_ACS_IORB		0x0080  /* I/O Request Blocking */
> +#define  PCI_ACS_DSP_MT_RB	0x0100  /* DSP Memory Target Access Control Request Blocking */
> +#define  PCI_ACS_DSP_MT_RR	0x0200  /* DSP Memory Target Access Control Request Redirect */
> +#define  PCI_ACS_USP_MT_RB	0x0400  /* USP Memory Target Access Control Request Blocking */
> +#define  PCI_ACS_USP_MT_RR	0x0800  /* USP Memory Target Access Control Request Redirect */
> +#define  PCI_ACS_UNCLAIMED_RR	0x1000  /* Unclaimed Request Redirect Control */
>   #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
>   
>   /*

Reviewed-by: Donald Dutile <ddutile@redhat.com>


