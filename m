Return-Path: <kvm+bounces-22672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A90A99412DC
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 15:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 238F1B251BD
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 13:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFC719EEBA;
	Tue, 30 Jul 2024 13:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Qw7Az58T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E39919754A
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 13:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722345251; cv=none; b=roWRhuYpXyP7LUUCzXyDHZV1F6bNfl8xEZFUwgtm3BN8o5LaHbwI9+a7WJVQS81qQacIqFOt5XV2yT8W1lQECapLtGyaCK+5/3SqOMkRtckhUZki8lDp7dtdxjrytsM0Avthh19v6ISG74R/49JxsbG9cQiDmR1o0nDsTWrQyAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722345251; c=relaxed/simple;
	bh=7nmLyiiZmSqCQ/CKXCfqPn5m6vkHCPvfU0etj1salOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buHZFLrF9RK7Bf4jsPT786NcKgMWIGIxcRqtW3+1RiSDIrBPUgVZBc3/qZpbxsYr4sucOtOr83tlRj9c7zWwGS3aUxGaxBHaocPVxHDmHEWCK2ZOt9zLJPALbrmFt/N1bOQq1DLYwhMWI87MlNUJqCoRJERGzSPEy+M1vJuNl48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Qw7Az58T; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3db12a2f530so2869393b6e.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 06:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722345248; x=1722950048; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3BdzZ42XevRdgs1HlIK+v9ADIdsvkrZfCAlsfSAxkNE=;
        b=Qw7Az58Tvg6LZrBBm3C1UA1A3QzPXlo2TpmK4o6kNzrwYvpViz3pe3DGbayW6X09Uk
         imeg/AiX6JD864pTfhU93MRhGxvXtIHwYGoCT/CcVcV2HZk2hScMYZn/n/nWqnzceSaz
         4nWaoofYPhyniTGqbjqeRwInL/EinPJ3FjC8/YXNNBdkolbNudAKfPJc/nCcyuoeLoDg
         ZzcsNRlOGPvv4dqR0ygFqbRZrvHfAg9bw0+Dn3Fk5tw7ZKbX5MqD7fX126gLbRvAAX4Y
         ZcFQ3bjcg0jeCNCdsKEYNVMvnNYFcN9xxEYMJyeL/BBqgrv91ZU+XL8RAatLWlTvOhJc
         RzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722345248; x=1722950048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BdzZ42XevRdgs1HlIK+v9ADIdsvkrZfCAlsfSAxkNE=;
        b=PGl43jl2tU50/EiXXsLthYGn8GFua7g19Eg8XAa3jd435SOxtiFxKzG+LwvY5PKgpl
         WN1FU21XYIVSmsv+F/vcDl7sCz9u3A2dpTwKJn7gq1+t6Enx5UZ1zPiTaJYEtCPnyH7m
         BgSmoa3g73eHbwl1x4GFpe6L94O2XKjp8p95d8AUzQ8YaLnVES3cujN9NUIgx4CCiChk
         qv44YrlL6uC+DaEHUf0D6STln3GAtgD9/DW8z8lsaqMfZB7SBy+iOVmuZAWciMP2qpS5
         PBqPuPTAH+pCmpWtjmf6u90OXEqtAHY4u1cJLj/dcL0dD6pywqcUe+pUpsAd1HzT/tJE
         qCnA==
X-Forwarded-Encrypted: i=1; AJvYcCXs2gKSP4Wz9eN3byZbewM24r35fqnK+6E5JQ3lvTn4b4ZG4p9NcwGeL1XPhMmJ8tvbywk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfqwpN+na1Fy90CKoGns5pWOD/aRdm3s1Uol6epHGaRgGz32Ur
	NSkY7HLsDPR3eFbtzLBv1u0/J5xcQRPWjOK4VRAzLvZnTBGTeKy9ZxBPYBAgZGU=
X-Google-Smtp-Source: AGHT+IF2b9X0EqP9ZetfyjkLgGCQCByPlxOTBVJOvusfPUfRQURMoMpWLfBuLqGVsMLijBvxX8UbwQ==
X-Received: by 2002:a05:6808:1495:b0:3da:bc74:e9d3 with SMTP id 5614622812f47-3db23a89bc1mr15982671b6e.17.1722345248318;
        Tue, 30 Jul 2024 06:14:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb3f943a30sm62633986d6.74.2024.07.30.06.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 06:14:07 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sYmg2-002OHg-P2;
	Tue, 30 Jul 2024 10:14:06 -0300
Date: Tue, 30 Jul 2024 10:14:06 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: linux@treblig.org
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Remove unused struct 'vfio_pci_mmap_vma'
Message-ID: <20240730131406.GB3030761@ziepe.ca>
References: <20240727160307.1000476-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240727160307.1000476-1-linux@treblig.org>

On Sat, Jul 27, 2024 at 05:03:06PM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'vfio_pci_mmap_vma' has been unused since
> commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()")
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 5 -----
>  1 file changed, 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

