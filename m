Return-Path: <kvm+bounces-11379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3744687694F
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 695331C226ED
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D5C6210E1;
	Fri,  8 Mar 2024 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ckNoJxHE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639E6210E0
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709917593; cv=none; b=qzh/YPDHEqC1paeAQp4Xartl1HpmAGNWts1qqP8l7eVihZT1qbNhkSV65GzQB6xclyBIx5enCu5C/a2D3AVw75wk09q2HBY3bSGvCiUtAQSTHf2B9fj2l/GByZyuGCDz+cEgtHM65HrZUSnz9C47vmjZCv1a1e6sDvIlqGsDtLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709917593; c=relaxed/simple;
	bh=ycDNvoPf7HTtmMBY6rzREelMeQ/eLfxpIBsPOnHGzds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJbzWWlcgJS2ZxNUx+0xGmWK0/CedX5pGL7d9dnWWAVg/LzSUOR378S9F0rQ8TLzy6uOgEyfZQrN/RxF71+cmerqKEWlF00V3wD9bwVYcv1/dcr88h71sy6kQ2A+QRJjHJulze5J15/gZT8T50ro1JXyAEsj62Z6ERt0tojn9aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ckNoJxHE; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5a0e5f083f1so1178746eaf.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 09:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1709917589; x=1710522389; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Zzt4lSMf6WU/vkTwpgEbPV3NrupJsLwViy3ujE89gPY=;
        b=ckNoJxHE057v658LgF/W9stzxcdN4kfctG14zsF2AJWHhPjjFoyvsFd7cnYclnER6T
         c0vTJ6cYfUlEKpQ1b78dh/zFNHpa2dZ9E2UT63Z/Hd2sa5VJMA3LyuTZ66CNV+Uzsghe
         rD0CBWqtzFZH0sG7z7vxKuBYojVJEl6nhLh9z/AaLW5QEqQCcoPapELLSevZ5g7H08w3
         bFD3WP+cQkIjrZEPruS9DxkKhLDlFR5QjuVo3Xe8pw9verkdM0IspLniDCRvBjHnF7ar
         DCHoZ4Jh77nxJVOUu2VXjH0+TFJv37F+J6Ff1y9WA1Au2phjwTd/WTXuhL6gu5q0fSDj
         9GhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709917589; x=1710522389;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zzt4lSMf6WU/vkTwpgEbPV3NrupJsLwViy3ujE89gPY=;
        b=GN1+afD+q/mcFugvqIqgMaHXdcmSWslsKCK1bQ/cksVUwaLFPvM4d9wh0jUZc6EfoS
         22A1VZVIhTe7eYBCbdtuwog+W8Fc69COJP02uRZOSShY+xW8FX9L/gLFdyCvq5BScmmW
         8i3SvWqCZ1CISNv+CHn+yZz2krF+70tzQP/NJAXKmE7ALP1YxthkBYjTYSN1O+/nSFMx
         GwFnVkidW78BmZRwT1IuQFRxWUbnDn6ayRsr9d7Qa8UceWQMtlnhGq5dswKcZ2hwAXuZ
         EQ2blQ/kDqHDaReXHkPVPpRiNBWafMNlBpBeRTFeaEiPD3OkFdH27AuahA6Bkp0Mf8J9
         bCdw==
X-Forwarded-Encrypted: i=1; AJvYcCX6jpxDfmhcaKT1T/gerhY5bZfP0SCn0MyiY4GV5KyTTZ1Y7yQYINfoVOBa1F/5GCzcB/9KYlcrtBr9ZFTDUsxgp4ds
X-Gm-Message-State: AOJu0YxYJVkAOVBEhKwYYAR7eObJJmuuYYizIYX6kpDPz8Bwr8qnvIJb
	OHMUlTdmoyhjX01aDYTJHj3vAraWgdSmf4u4US/FgPeL/8MF+NwmoPV194zKnVg=
X-Google-Smtp-Source: AGHT+IGoG4+alMlUFUlvU1vO+5C5PftldFZMSqbBNF+jkGAAm5kC+I/IY5zMI1r1iOMx7SPWlC5TTQ==
X-Received: by 2002:a4a:8516:0:b0:5a1:a4a0:3e9a with SMTP id k22-20020a4a8516000000b005a1a4a03e9amr6463034ooh.0.1709917589521;
        Fri, 08 Mar 2024 09:06:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id b19-20020a4a9bd3000000b005a0a55ba943sm3899247ook.35.2024.03.08.09.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 09:06:29 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1ridfw-007SRL-CF;
	Fri, 08 Mar 2024 13:06:28 -0400
Date: Fri, 8 Mar 2024 13:06:28 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] vfio/platform: Convert to platform remove callback
 returning void
Message-ID: <20240308170628.GT9225@ziepe.ca>
References: <79d3df42fe5b359a05b8061631e72e5ed249b234.1709886922.git.u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79d3df42fe5b359a05b8061631e72e5ed249b234.1709886922.git.u.kleine-koenig@pengutronix.de>

On Fri, Mar 08, 2024 at 09:51:19AM +0100, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/vfio/platform/vfio_platform.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

