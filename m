Return-Path: <kvm+bounces-41922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DBEA6EA5C
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 08:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 725057A30DB
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 07:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6232254AF2;
	Tue, 25 Mar 2025 07:20:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7A520E6F7;
	Tue, 25 Mar 2025 07:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742887223; cv=none; b=o2A4pBz9ZFFpoI7QD8GnfS9k6n/EcVRTmED1KyF3rky2gMo2Xa7DAoJQMxhtVArR28MfTOaW1Uc/siFCNkeD6Pjdko42eGVJUYTehMHFG6pQk/Me5pJ8MfLX+7mykYGLUMpmur2x7lZnqQ8BjfsFY/BmNovifTuy7uMCR3qT4i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742887223; c=relaxed/simple;
	bh=kHHaPODkvtdGvxf9qarpBVrrEOuOfLu3WIWAlckAWtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jpL0/YxwuJXcuHey0/s2zIDM5I9WkHXoDMG+Mdmju49Is9Uu8X8wUbP8+hAI/qt7XFGyRkafjNIFb1vA7hDE0AxLbubx2QSoUVg9VZFEGMtD+M8/xhkJGgR2EHeAx6RR94Ff5A+FLF7wJMQEUaKKUKs12AlWNDoJFHd5xUOUrbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4ZMLk83dyNz9sSm;
	Tue, 25 Mar 2025 08:13:36 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w1R402GlpRmr; Tue, 25 Mar 2025 08:13:36 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4ZMLk82p2tz9sSj;
	Tue, 25 Mar 2025 08:13:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 4A99B8B765;
	Tue, 25 Mar 2025 08:13:36 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id Q_Gt9WeIslhN; Tue, 25 Mar 2025 08:13:36 +0100 (CET)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id BC7668B763;
	Tue, 25 Mar 2025 08:13:35 +0100 (CET)
Message-ID: <b192632a-7b30-4227-96b8-84a587c45fa2@csgroup.eu>
Date: Tue, 25 Mar 2025 08:13:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: pci: Advertise INTx only if LINE is connected
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, alex.williamson@redhat.com,
 jgg@ziepe.ca, kevin.tian@intel.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, yi.l.liu@intel.com,
 Yunxiang.Li@amd.com, pstanner@redhat.com, maddy@linux.ibm.com,
 linuxppc-dev@lists.ozlabs.org
References: <174231895238.2295.12586708771396482526.stgit@linux.ibm.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <174231895238.2295.12586708771396482526.stgit@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 18/03/2025 à 18:29, Shivaprasad G Bhat a écrit :
> On POWER systems, when the device is behind the io expander,
> not all PCI slots would have the PCI_INTERRUPT_LINE connected.
> The firmware assigns a valid PCI_INTERRUPT_PIN though. In such
> configuration, the irq_info ioctl currently advertizes the
> irq count as 1 as the PCI_INTERRUPT_PIN is valid.
> 
> The patch adds the additional check[1] if the irq is assigned
> for the PIN which is done iff the LINE is connected.
> 
> [1]: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fqemu-devel%2F20250131150201.048aa3bf.alex.williamson%40redhat.com%2F&data=05%7C02%7Cchristophe.leroy2%40cs-soprasteria.com%7Ce0fb1d4bf2064e115ce408dd6642796b%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638779157886704638%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=egZuT5CZsC6S%2Bd7bZTuO4RcKL8IJREPbxIMGZZkZeMQ%3D&reserved=0
> 
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Suggested-By: Alex Williamson <alex.williamson@redhat.com>
> ---
>   drivers/vfio/pci/vfio_pci_core.c |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 586e49efb81b..4ce70f05b4a8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -734,6 +734,10 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>   			return 0;
>   
>   		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
> +#if IS_ENABLED(CONFIG_PPC64)
> +		if (!vdev->pdev->irq)
> +			pin = 0;
> +#endif

I see no reason for #ifdef here, please instead do:

	if (IS_ENABLED(CONFIG_PPC64) && !vdev->pdev->irq)

See 
https://docs.kernel.org/process/coding-style.html#conditional-compilation

>   
>   		return pin ? 1 : 0;
>   	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
> 
> 
> 


