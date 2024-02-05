Return-Path: <kvm+bounces-8009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 930F5849A05
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EBEC284057
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D331BC39;
	Mon,  5 Feb 2024 12:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nivcp35n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A5C1B965;
	Mon,  5 Feb 2024 12:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707135732; cv=none; b=SIk3WcKPt+GJYE5uPBs54mzm2fsG+2YGfMHqONoBNNEvrFdfJExAqx5WhdBNHb+st5ezbklaXM8lDAoXxuCtuJZC0GLq+N5hAWgZJVnH9lG+xWzwYi48iYJjOou5/e6siTAoG6wEoZ7zUAzIvjaSbMFKOHGvxwtjFlUuA+YNpis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707135732; c=relaxed/simple;
	bh=XIAPB8q/DK2TzGwBrFZCsv/o8pM8cw6viAqrxp3BUXc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iq+9Lp3dmFIpMFVmrXi4nGDk9lAP6TCWH9xUwcE/eM4amiyFxTqeatWL3e/vRzDXc9ZaDQ3np7yrsx/m5RCTDSqrZJ4mKocLz4iKd726bZYb9kUbTfBz8Yy+NXlAsC1MM2cYou0d8gqaQFmloZThcWiRY2KKb/9GFXMbR6Ueps0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nivcp35n; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-51155f9eff4so32514e87.0;
        Mon, 05 Feb 2024 04:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707135729; x=1707740529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DsTopB40v8e+57R3FP+15KsfdhxipZbBAJNJON7l3mE=;
        b=Nivcp35nKYpNWuYe3eTA6iNpOvmgwoWH9yI02g00P1hf0FUqNRpxCuad08oJlaD/Lc
         iyHWcVE70Tu2t4uD+qVXw0pmMs4Nj+CJXIrHuA5tBWLe7Mg7Zasnvvp5J7VllxHgZUzB
         AgFive3jXkNn5e/buBE25Vhi//t27S2C4lH/3fPvZS13jP/Nlm3EDEZfl3rhF2xYmhnv
         6nf5cDLb/Sm8zmATXmHQaydcklHsYGk7XRbpwxFkGQxK+murogofVgf69CfvjV3TPHoE
         u08uLsddhUDejDXi9O3Wo3MJl5/VtqPmmqhhdl54nftyvps8luMk0taHidXzIShuHtS0
         Steg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707135729; x=1707740529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DsTopB40v8e+57R3FP+15KsfdhxipZbBAJNJON7l3mE=;
        b=CL7iRmDFl46yjUw8vUbUcniNJkz4GEvbGPXFNEEzs6qzDj9Wa/Ub9AtL/Pg59fsDNo
         r1UEmpx9QJeKhYcgUmRjtmSn4UsDNwQsZ7yoBLDJPW7NRxhp4fJQIZy+IzxpXQhHGVEJ
         UcCKlxufV+ggpMxxP+QJj9Opz/ztzV5FCLpJsg+Qb7xs9GhEvE9iPvvKN/3a8lq2qwSy
         md6I/pVfBFb9q8d8IKMWi5qb59guizCDUPcii1CDc2gDJ+WevoQvoiSn68u2yy+NvTIM
         M25yXvkxrxG2kzMgYXOH9/rD/omISQupKym3r8m02khL2SwrTuejVQLJn4R70fFYDgFS
         w3Lw==
X-Gm-Message-State: AOJu0YwG9Bib1q+z6nfoFwKix0leMbkL4dX6ZB3Ow01duiE7oIB9gpvJ
	fm3u0tCnck0HzIMFT5uE/sM23gHQ2A9qW/Lfj2XMf1Vabfav2Q8d
X-Google-Smtp-Source: AGHT+IEOF08DEpMV/aE/bR6THEAkaKyqbsTR+aZvoSd+B423zZBGK06bqHI29Me8zUQgNkJYYs7TIg==
X-Received: by 2002:a05:6512:1055:b0:511:536b:89e with SMTP id c21-20020a056512105500b00511536b089emr1248133lfb.0.1707135728790;
        Mon, 05 Feb 2024 04:22:08 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUhuGx+c5f52OKpYK4sIjM/j/qWUhfNP+BN/x2fhUnmjyAzVzpkMsHvapI0lc9LK4pbGDi3BGiiv1Ui42/31CQYcszxMRDVgM+61GVxVdDlh4vzLszfdlRR7gvACXgCSXb0WU7Ug/ZdPF3oiugFfnbr13PshUReJyFZl7XFrubNFxuT2iPzsm4L1p23j8e16x6ieuHxCeik5Ok2K87jhnv+JehO17/7b04fUeVDyw==
Received: from localhost ([193.209.96.43])
        by smtp.gmail.com with ESMTPSA id w13-20020a05651234cd00b00511560092e3sm27526lfr.298.2024.02.05.04.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 04:22:08 -0800 (PST)
Date: Mon, 5 Feb 2024 14:22:07 +0200
From: Zhi Wang <zhi.wang.linux@gmail.com>
To: Emily Deng <Emily.Deng@amd.com>
Cc: <amd-gfx@lists.freedesktop.org>, <bhelgaas@google.com>,
 <alex.williamson@redhat.com>, <linux-pci@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: Add vf reset notification for pf
Message-ID: <20240205142207.0000685a.zhi.wang.linux@gmail.com>
In-Reply-To: <20240204061257.1408243-1-Emily.Deng@amd.com>
References: <20240204061257.1408243-1-Emily.Deng@amd.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 4 Feb 2024 14:12:57 +0800
Emily Deng <Emily.Deng@amd.com> wrote:

> When a vf has been reset, the pf wants to get notification to remove
> the vf out of schedule.
> 
> Solution:
> Add the callback function in pci_driver sriov_vf_reset_notification.
> When vf reset happens, then call this callback function.
> 
> Signed-off-by: Emily Deng <Emily.Deng@amd.com>
> ---
>  drivers/pci/pci.c   | 8 ++++++++
>  include/linux/pci.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 60230da957e0..aca937b05531 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4780,6 +4780,14 @@ EXPORT_SYMBOL_GPL(pcie_flr);
>   */
>  int pcie_reset_flr(struct pci_dev *dev, bool probe)
>  {
> +	struct pci_dev *pf_dev;
> +
> +	if (dev->is_virtfn) {
> +		pf_dev = dev->physfn;
> +		if (pf_dev->driver->sriov_vf_reset_notification)
> +
> pf_dev->driver->sriov_vf_reset_notification(pf_dev, dev);
> +	}
> +
>  	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
>  		return -ENOTTY;
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index c69a2cc1f412..4fa31d9b0aa7 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -926,6 +926,7 @@ struct pci_driver {
>  	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs);
> /* On PF */ int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int
> msix_vec_count); /* On PF */ u32  (*sriov_get_vf_total_msix)(struct
> pci_dev *pf);
> +	void  (*sriov_vf_reset_notification)(struct pci_dev *pf,
> struct pci_dev *vf); const struct pci_error_handlers *err_handler;
>  	const struct attribute_group **groups;
>  	const struct attribute_group **dev_groups;

Hi:

I would suggest you can provide a cover letter including a complete
picture that tells the background, detailed problem statement, the
solutions and plus the users. As this seems very like a generic change,
it needs a better justification to convince folks why this is the best
solution. Without a complete picture, the solution just looks like a
workaround.

Thanks,
Zhi.

