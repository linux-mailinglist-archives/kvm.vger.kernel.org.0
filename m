Return-Path: <kvm+bounces-7986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2158498D4
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5203BB248EC
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 11:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DB918E12;
	Mon,  5 Feb 2024 11:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRajZHSR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD2818633;
	Mon,  5 Feb 2024 11:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707132538; cv=none; b=q4rHfm6H1GqGAT6PpZj4Mw8fzWMiUDF0hU3MKNsFQjgQRAU90xZPg8hQgvCEp5Ds5IB9cua4uC4qIZzbHwDYfQP0f1lCDmIXLRgj+8lRnxnM/a9/Cjd0/1nkJo6wnHA8wSwSpsUhKAQhBaREGYIweVj31fv4OSv95RU6rEtsCmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707132538; c=relaxed/simple;
	bh=Iy7qWAcNmkq6knfxBeo+GhtMBZwWjH+8//v2LemNuss=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CWEvho4sN7bDOYbns6fY//Pg6w09h2vtfoTAJrjMT2CtxkOXCG+RpaAR9isXGvKdmHIfPjrrYnMWDBE9klJaZMsky1iKnXAYlWcVGLqwrdBzCD8ergTR7xKeNeAoPRx29gekdNgNT0lGY1ZZmTD99mLe1T+uTSWJcc6DIiTNmj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRajZHSR; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5111e5e4e2bso6630153e87.3;
        Mon, 05 Feb 2024 03:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707132534; x=1707737334; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TcnrZiFoKqoviNxRH/t3HUNFg1NWrZniLXis+Ehl3kQ=;
        b=NRajZHSRMX6yUyusc9qN/PPyLWmixYK7RcADVil/VsBA7MqGOJiIk6dMxIsUcNXdgT
         XTSKjL1knOgrPp4Dh/Zt9AsdVyEauh30aMcttt4a/4mc1KomjXSXZ7E8vbqlK+jymOuS
         zoJC1FoP6npsPM80s3/iQkMIImbZ/UciB6kxTp47TLUbTDCf/ID9tXKakobtC2/+zXL3
         UsiCC/pGihC1aNPCEizeprHIEo462aJIi5X0Eyd0wuU440Tt634LJS4odCidZbSlR+tJ
         dLt7aO9eS99ezc9WPQT/f7G+NQkQPjCeHK5sSPm+2GnwlqgpsRVTHZzdJ5T9muFJqN79
         PHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707132534; x=1707737334;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TcnrZiFoKqoviNxRH/t3HUNFg1NWrZniLXis+Ehl3kQ=;
        b=QZpsO1iz909316k+Z6RiesBDe3mS5HRij78Zda6W17t7X2egmh/z91iTx/YI4sUQTO
         NOrdCi/haEyEBa7b1eBH+EnrbYB7LHtxukzbh+Rpw0dpAgbRYFJuZ5QuYUIGhaT1NX1E
         q5Fhwk/27B1tm1rs94K+H92sf7EpKscc1aAFMk/NCnpOlMlns7ciAgviTuryVOKYxKfL
         vWFFwCd/Riwm0CsgGk9RJmOegKdb+tUZaqpm407D5lTSsNuePkhqrSOKP9+1+jxfE9Hj
         Ghwdz/b7k528zXbEPxlcRiBRkYvofZtFXdL08y2pNlB68Pp+BCeMrS/oo4CCY/26tOhC
         26ng==
X-Gm-Message-State: AOJu0Ywia4qr3dPMeOoLqp/AyIeoyK64BKWABWPRnnv7NMbFcgH8U7Sn
	FstcjSCsbXjAMF/0/MXDsIdufKGECgmKNC5xbn/XyTOh2fBg74v5
X-Google-Smtp-Source: AGHT+IHduzacAbB+gmsJTfUXIU/uuqegqXDQipzDg06tYFlUORm6tm/gFiQIkB2iylDysb5O+TBzgg==
X-Received: by 2002:ac2:5238:0:b0:511:4943:6066 with SMTP id i24-20020ac25238000000b0051149436066mr3046237lfl.25.1707132534315;
        Mon, 05 Feb 2024 03:28:54 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUGg9Ncywyi1UvMZFL0Fsb4Xpf05vHlc2PN+5pEVK5/JEIZ2r/ER06DGI0d4oAKnSSJ45cXkUZcLNmG4OHRHhzjmOu3MgfgRPE1+OHBijH+NXixyZwCaXaZq5XziX9zxSppM9UE1Oqy05yad4OsfJHrtfxYQzPlh4poVjjU96rLVdQ8SuPO2beI2AYW7SjCrau8wb1fF4tFNWNalcO5tPFBmHzLxFEf25RKtZepOYKGHPEheTibxZ7ldG5fzoXZuW2JgowWjYR3dwZfEu8=
Received: from [10.254.108.81] (munvpn.amd.com. [165.204.72.6])
        by smtp.gmail.com with ESMTPSA id bi7-20020a05600c3d8700b0040fdd18f6fasm1448578wmb.39.2024.02.05.03.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 03:28:53 -0800 (PST)
Message-ID: <db589d23-6e15-4b54-845f-fb719e59949d@gmail.com>
Date: Mon, 5 Feb 2024 12:28:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] PCI: Add vf reset notification for pf
Content-Language: en-US
To: Emily Deng <Emily.Deng@amd.com>, amd-gfx@lists.freedesktop.org,
 bhelgaas@google.com, alex.williamson@redhat.com, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240204061257.1408243-1-Emily.Deng@amd.com>
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>
In-Reply-To: <20240204061257.1408243-1-Emily.Deng@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 04.02.24 um 07:12 schrieb Emily Deng:
> When a vf has been reset, the pf wants to get notification to remove the vf
> out of schedule.
>
> Solution:
> Add the callback function in pci_driver sriov_vf_reset_notification. When
> vf reset happens, then call this callback function.

Well that doesn't make much sense. As other already noted as well a VF 
should be an encapsulated representation of a physical devices 
functionality.

AMD implemented that a bit different with a hypervisor to control which 
PF functionality a VF exposes, but that doesn't mean that we can leak 
this AMD specific handling into the common Linux PCI subsystem.

Additional to that a technical blocker is that when a VF is passed into 
a VM you don't have access to the PF any more to make this reset 
notification.

Regards,
Christian.

>
> Signed-off-by: Emily Deng <Emily.Deng@amd.com>
> ---
>   drivers/pci/pci.c   | 8 ++++++++
>   include/linux/pci.h | 1 +
>   2 files changed, 9 insertions(+)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 60230da957e0..aca937b05531 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4780,6 +4780,14 @@ EXPORT_SYMBOL_GPL(pcie_flr);
>    */
>   int pcie_reset_flr(struct pci_dev *dev, bool probe)
>   {
> +	struct pci_dev *pf_dev;
> +
> +	if (dev->is_virtfn) {
> +		pf_dev = dev->physfn;
> +		if (pf_dev->driver->sriov_vf_reset_notification)
> +			pf_dev->driver->sriov_vf_reset_notification(pf_dev, dev);
> +	}
> +
>   	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
>   		return -ENOTTY;
>   
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index c69a2cc1f412..4fa31d9b0aa7 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -926,6 +926,7 @@ struct pci_driver {
>   	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
>   	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
>   	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
> +	void  (*sriov_vf_reset_notification)(struct pci_dev *pf, struct pci_dev *vf);
>   	const struct pci_error_handlers *err_handler;
>   	const struct attribute_group **groups;
>   	const struct attribute_group **dev_groups;


