Return-Path: <kvm+bounces-57046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D7ACB4A111
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E33E16402F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 05:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA902EA72A;
	Tue,  9 Sep 2025 05:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fyy2kasE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2BB1D6BB
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394119; cv=none; b=aFnrAbgGX2ErTSSzaRyqyhXAAuwTL1JknnWnRgLH3CyI3y9M5jdboguPngvADxuQ5ppaQ5x4c1iq5liemRdZ5YilaD7kpKuYWy/X6S76DXnUe6Lo86CQbk0dc8psigPWauuJIUshat+y8c1KN2uad1TE4c1DBGBfSaBZZ0Ee9G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394119; c=relaxed/simple;
	bh=NiKPZa3aBzZRfwyLL0FvfveRyRXeMsNqVb7bIOVeJNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O2H320855AuGWSsQZVcf0RgGBaa408bkaYwIL/Qu4gC1xbS0wrMjDz+Mi3j7QIdY1C1zZkyD+JOr5/D15Lr7d7EnvPn55/Pt4GdmdOnlkBfMdWJCevjZd2Oo1jWS856pLEzIPeiIDON80nzUnmUACTBF4Ze6TCyz/vvruHO6wPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fyy2kasE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757394116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+TqcpyoKZ7yURjs6FmHv6hYqw5SgT/JL8ZK31pPvug=;
	b=fyy2kasENmI9bd0jzcHlr3E3YpmJkI53mF+b4O+iPTKQEw90bZF+KbRs8y5JFxk0raOeYJ
	OuiI64tiRcHdEzWjadEsAF8hPm5sxx/hB5jUqS082RYyRZwSnvS2rmbojLHbwXNaBhFJJA
	8OR/elfno9GcH2G+V3+Yl2bm5mh+4Pk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-Nk--b3z8MhOkh1ysTlKnEA-1; Tue, 09 Sep 2025 01:01:54 -0400
X-MC-Unique: Nk--b3z8MhOkh1ysTlKnEA-1
X-Mimecast-MFC-AGG-ID: Nk--b3z8MhOkh1ysTlKnEA_1757394114
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b5f6eeb20eso137936401cf.3
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 22:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757394114; x=1757998914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m+TqcpyoKZ7yURjs6FmHv6hYqw5SgT/JL8ZK31pPvug=;
        b=ECk4H3ZiDGiH6bi+HlW8m1XvYUPtQbrNAjh62ihBsfYWaxePVNqbodNfiREJ9/Owo+
         lYOKyDl4uahCdKp8Z0QcJOA+pLqwFGq2XpnarbvEwzP7KNEYF6BVDBel4sFDamYlW3Pe
         f7upNmN1vCgqoOnUKwslU+n/TsrcdaPDUV4MqaskVezS1vpTIvaTb6hpFGN0SZtbGkEG
         i++7FCl4wI+BN0CRQ342Xf3G4Y3OKCuCD+1zSXLbjgClG1xWM9lNPseJbXQgm0BUOLdW
         dJcapQs2WtYUNB+Sb8qP793P61idjizcT44ij3QXmDv5eUiODfoT7JhqnWWfnLzper++
         XMIw==
X-Forwarded-Encrypted: i=1; AJvYcCWRCLzqBA/souoCZBoUAena1DyTMycGZZXF8QucOiqPQP0KLW8BSHcGJ3UapndX9rAPi3s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3HDd5/azNCnsV7R6uwBcMhAeOfHzNQ6VX0vKvel7eUE2vZODK
	ToaVULJHkPCtmjwOPkZ5W/6HQbVO1aCwF2Rg/prJ5GfemhRy5jKXcKnr8Vq1JDgbfGJ6y149VxJ
	Dsv+E8G/O5CwnVyv4JsfxJST87muqMHxNfSTji2wn5FU7PH4kCukndw==
X-Gm-Gg: ASbGncvlz+UWvRUL0qabFxr1HXcKWWVI6m9O7yFW2vygvfkfgj5EDP9LQCj5WA0JvZu
	pTvIXjM4JcKy+SW+MoPaUa1Qvh2Ul6IPguRM3iAt9xeXdT0S9MTyEZjVE4JnDdalmHriz76Y0xH
	WPBhyaP3/4wMFUToLQYfy5UF0E0VoqJ9aq8FrA8vmIBlGbUsDGyOZX/rphDt0U5MnM5+uvQid7l
	C+47Q4lrPMSNvcBiLiaNVuh1Lq7Wni39RM5YR+XtAxa3Cx2RJzdHG2RbthkYYuBVEgPX5FVTMAw
	MaDBoeL0nt0syfIVnwgHRni5ceKbx3jmgu7spusn
X-Received: by 2002:a05:622a:64c:b0:4b4:9813:932 with SMTP id d75a77b69052e-4b5f83b14fbmr113691731cf.31.1757394114287;
        Mon, 08 Sep 2025 22:01:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9lKeUdKCImFfFawS74qNPwOaMOZGonu9+t68RyfZKwbK9+6tmYOsPkeWUWvoy490OBnp4gg==
X-Received: by 2002:a05:622a:64c:b0:4b4:9813:932 with SMTP id d75a77b69052e-4b5f83b14fbmr113691521cf.31.1757394113901;
        Mon, 08 Sep 2025 22:01:53 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-725dda254d4sm118146646d6.8.2025.09.08.22.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 22:01:53 -0700 (PDT)
Message-ID: <7c47fa78-9b0d-4383-817b-01a1a53311d8@redhat.com>
Date: Tue, 9 Sep 2025 01:01:52 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/11] PCI: Enable ACS Enhanced bits for enable_acs and
 config_acs
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
References: <9-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <9-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> The ACS Enhanced bits are intended to address a lack of precision in the
> spec about what ACS P2P Request Redirect is supposed to do. While Linux
> has long assumed that PCI_ACS_RR would cover MMIO BARs located in the root
> port and PCIe Switch ports, the spec took the position that it is
> implementation specific.
> 
> To get the behavior Linux has long assumed it should be setting:
> 
>    PCI_ACS_RR | PCI_ACS_DSP_MT_RR | PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAMED_RR
> 
> Follow this guidance in enable_acs and set the additional bits if ACS
> Enhanced is supported.
> 
> Allow config_acs to control these bits if the device has ACS Enhanced.
> 
> The spec permits the HW to wire the bits, so after setting them
> pci_acs_flags_enabled() does do a pci_read_config_word() to read the
> actual value in effect.
> 
> Note that currently Linux sets these bits to 0, so any new HW that comes
> supporting ACS Enhanced will end up with historical Linux disabling these
> functions. Devices wanting to be compatible with old Linux will need to
> wire the ctrl bits to follow ACS_RR. Devices that implement ACS Enhanced
> and support the ctrl=0 behavior will break PASID SVA support and VFIO
> isolation when ACS_RR is enabled.
> 
> Due to the above I strongly encourage backporting this change otherwise
> old kernels may have issues with new generations of PCI switches.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/pci/pci.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b0f4d98036cddd..983f71211f0055 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -957,6 +957,7 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
>   			     const char *p, const u16 acs_mask, const u16 acs_flags)
>   {
>   	u16 flags = acs_flags;
> +	u16 supported_flags;
>   	u16 mask = acs_mask;
>   	char *delimit;
>   	int ret = 0;
> @@ -1001,8 +1002,14 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
>   			}
>   		}
>   
> -		if (mask & ~(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR | PCI_ACS_CR |
> -			    PCI_ACS_UF | PCI_ACS_EC | PCI_ACS_DT)) {
> +		supported_flags = PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
> +				  PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_EC |
> +				  PCI_ACS_DT;
> +		if (caps->cap & PCI_ACS_ENHANCED)
> +			supported_flags |= PCI_ACS_USP_MT_RR |
> +					   PCI_ACS_DSP_MT_RR |
> +					   PCI_ACS_UNCLAIMED_RR;
> +		if (mask & ~supported_flags) {
>   			pci_err(dev, "Invalid ACS flags specified\n");
>   			return;
>   		}
> @@ -1062,6 +1069,14 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
>   	/* Upstream Forwarding */
>   	caps->ctrl |= (caps->cap & PCI_ACS_UF);
>   
> +	/*
> +	 * USP/DSP Memory Target Access Control and Unclaimed Request Redirect
> +	 */
> +	if (caps->cap & PCI_ACS_ENHANCED) {
> +		caps->ctrl |= PCI_ACS_USP_MT_RR | PCI_ACS_DSP_MT_RR |
> +			      PCI_ACS_UNCLAIMED_RR;
> +	}
> +
>   	/* Enable Translation Blocking for external devices and noats */
>   	if (pci_ats_disabled() || dev->external_facing || dev->untrusted)
>   		caps->ctrl |= (caps->cap & PCI_ACS_TB);

Reviewed-by: Donald Dutile <ddutile@redhat.com>


