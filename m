Return-Path: <kvm+bounces-64419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E50C820D9
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5C87734947D
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A633195E7;
	Mon, 24 Nov 2025 18:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bEqXpiFi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1198D27FB1E
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764008209; cv=none; b=MuDnuWy3C5W59knzVyGllVl/g7GdOjGgbgpwKAQgQvEn3xNgd10/0L88a4UGV6xqiTxiKKc9MiPVzLUyGObrz8qwIry6hRmAZR+UhetIfuLQljKF87ugbaVheSw15kAag3W4jcjZNljwl8a4bwrlvHpu/Ke8dnlmAROgBcpHprY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764008209; c=relaxed/simple;
	bh=EN6mEBMLDIt+BsOBxjKCykui4xhXykEjN4GiaDHL0MY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hL1FooXssa5i/sErFwHJ3ZfbaayflGcr0GgxwFrvDFT/MKFkICcwWlJqXxRll2LOv0TrNq48zw8XWHuDsKmjPinHfRKar93TP6XEPka3sdhWngdCscbVhiLzfeKmQwvXuq+WUSn82PyvVeJWjdzYA2+CRsrkhWxZSOZjISpsIVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bEqXpiFi; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4edb7c8232aso58872991cf.3
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 10:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764008206; x=1764613006; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kcfQ/uUm5I+jJsg4nzod0YZtTGCfa1KqgoqMVMTPuBQ=;
        b=bEqXpiFiSTekmXic1VZ1ArTbA7v0G7KHEKMbZICpbTagcv8ipepWk1IDkg6TMQF3KT
         jH1VHnW39nWvpJgAnjfEtAExgn1RHTlvfDa3I4KMOF3K1aECGqgvYSAjL9gJ2yuWOXEt
         WC+1yYjCdlyRM/DyPTVExIo4pfGQtRz3Rl/Ksffdo2wZrklgVSmvLYS+VA6Q1b4NC3X+
         8t4QKQ4j13tm6aeqgcmu3v0dsxUz3rdqns/zOsA65JUUlUSt1WQaJGlSCqKLiKHXxphg
         J8gTY/g5EuS5WrHFYy7+I8kagEcnE8L1AWA46dmtAMI/SSPgh4WmGlKunpbXNyBQlHHj
         StNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764008206; x=1764613006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kcfQ/uUm5I+jJsg4nzod0YZtTGCfa1KqgoqMVMTPuBQ=;
        b=u7JIcsA7VUwdl+cW6x9KxSLReXvbWi7HPUFh/9V13mezWjZpFomNKWMPkJMwbzrc/o
         0X8hXwEyU9QX0YpxPNZckIaEN7a6okJU9rn0UwBfu3KwWkrCrvDclBqn+dnSorXTapHU
         R0epdQR3Pmq66JUgwZR69OrUjMNYXXa2oqUFuOQywm+F6/9IzCDp1g6rqnfTOvHx3Fjq
         maoWGwDZFue/qnxC/iG3QH5LSHdZNnvueL4IWXWV5yhxlQ9UDchI1eX3ZzLy5i6iAHNL
         8rgKgkJNL2gDNTnDxQktEUkiH54vgTFY0tUjQtD9E+tEKZJWAe4Jw31qPMsPhIRcp3Zx
         qlgA==
X-Forwarded-Encrypted: i=1; AJvYcCUlncQqt3nYWha4r3sxFf8Mv1spFbcTWCybAJIW++bJXCiluHm8YjNDDTWgDALStL7nTfs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzEFy1aDFXp9+UJx5gd4W/BEciAgjdLlYf6yoixjy5EKC3n5Et
	qnBq/HBXbloHeSNWwYsV9nVREqNMqJiIOKvyqiPpK1EA8GMKeaoWeo8rGIy6BcipTik=
X-Gm-Gg: ASbGncvp7BC1oD4z/iR0Lo4fSd7c/rs3g/twMdqV8oq75jWLu3t63rC0q9U74piJ3kL
	740LH21OUC7VfkruZVjL/hAs4VygjDa64lflrgruiCPYUrXFv+oVaomKvbqNYhPKqA1NaAEMr1P
	TyKUg+3zlxJvQbna6ZLbLlq83+yThrYIH4leZzrB8nkiuHfFhaifhkjgiEN9mKYnNQKUbdA4pg0
	sXsUgTMTVy5gbQiqGfllc7r+AeOvKrt/v4NEQ8I0lPue6Ml5v6De4u8gm037ESXVZ1ZUdGEWFXz
	74N++kWl9yHSVM6QBhOQiEogOBSO6fmcJKbdqUsC9+uCJl6YFXFJy3ov6l1qWLq6lFk/8jBs+Ao
	f4syGAHAgMVOm2CnDY9UGqkpBhjcYchYRLHKCpFQlZwtBuUoXXFD/TbbvRY1qlP7An+Q6xFenMT
	za2zOlXf7NkNfCHsDJzsbTGh6u8MAzew/T8Db5cLwuxXiBqlyd/tdfSG3i
X-Google-Smtp-Source: AGHT+IEHBHdq1SaZSsgwCfOz2p1nEfP0zpanFJWi7UKdRbU9ApFleKbqwpZgBgUCCXdhRyRXRSl/0Q==
X-Received: by 2002:a05:622a:1207:b0:4ee:1563:2829 with SMTP id d75a77b69052e-4ee58b04a99mr191457071cf.72.1764008205528;
        Mon, 24 Nov 2025 10:16:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48d3bcc4sm89196511cf.6.2025.11.24.10.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 10:16:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vNb7E-00000001xC5-2DQM;
	Mon, 24 Nov 2025 14:16:44 -0400
Date: Mon, 24 Nov 2025 14:16:44 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: ankita@nvidia.com
Cc: yishaih@nvidia.com, skolothumtho@nvidia.com, kevin.tian@intel.com,
	alex@shazbot.org, aniketa@nvidia.com, vsethi@nvidia.com,
	mochs@nvidia.com, Yunxiang.Li@amd.com, yi.l.liu@intel.com,
	zhangdongdong@eswincomputing.com, avihaih@nvidia.com,
	bhelgaas@google.com, peterx@redhat.com, pstanner@redhat.com,
	apopple@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiw@nvidia.com, danw@nvidia.com,
	dnigam@nvidia.com, kjaju@nvidia.com
Subject: Re: [PATCH v5 6/7] vfio/nvgrace-gpu: Inform devmem unmapped after
 reset
Message-ID: <20251124181644.GW233636@ziepe.ca>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-7-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124115926.119027-7-ankita@nvidia.com>

On Mon, Nov 24, 2025 at 11:59:25AM +0000, ankita@nvidia.com wrote:
> @@ -1048,12 +1050,29 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
>  
> +static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +	struct nvgrace_gpu_pci_core_device *nvdev =
> +		container_of(core_device, struct nvgrace_gpu_pci_core_device,
> +			     core_device);
> +
> +	lockdep_assert_held_write(&core_device->memory_lock);
> +
> +	nvdev->reset_done = true;
> +}

Seems surprising/wrong at least needs a comment. What on earth is
ensuring that lockdep within a PCI callback??

>  static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
>  	.name = KBUILD_MODNAME,
>  	.id_table = nvgrace_gpu_vfio_pci_table,
>  	.probe = nvgrace_gpu_probe,
>  	.remove = nvgrace_gpu_remove,
> -	.err_handler = &vfio_pci_core_err_handlers,
> +	.err_handler = &nvgrace_gpu_vfio_pci_err_handlers,

Jason

