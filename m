Return-Path: <kvm+bounces-23224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E340D947B07
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 14:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 921F81F21794
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 12:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD966158DCC;
	Mon,  5 Aug 2024 12:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0fpOLIf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07000158D87
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 12:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722860874; cv=none; b=c4CYeVoUM8Ot3QM9PJojOpGQ9xlaeudOCWpQUTubqr8UmiCAwX1hCLi0sA8Te6ZiXACWwonAjgNOBLpDtO0N+nfOHnT7UIin2TUlfmy5ZIz5gfcHmmFCynqc6GbZIms9gG2pYlsyesZ5MclhMUkfPMNP2MI75cfLs3DEn6iT5oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722860874; c=relaxed/simple;
	bh=VCuaq9sf38AKRKM32qy4QS9ZAV4K3QqevThGVpr+61M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=on0ch3WUEp49QXBr+lJt9uSVVcq75zU5YdUAFZmBHHLYLFxVOgBfbigN9XomMNlft+V++ZltMQfpPwUEA29LxMJ/9rrwxZTzEAQh4KDhzziRkzIKcgKMfot1s+0M2DvYpkp/bdKWTFrI8d6SabuLQKYrAVeMkv5uh4ay2ruTZiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0fpOLIf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6325C32782;
	Mon,  5 Aug 2024 12:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722860873;
	bh=VCuaq9sf38AKRKM32qy4QS9ZAV4K3QqevThGVpr+61M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o0fpOLIfbd+QZl67uADzHe5a4WVWOs25CMjYuiOGJKZZKoWxC1v89WgVJ/EVHv/V+
	 z6pwQiHrOF1LPYd6sMeZdS76ZJbD+OkbPoRAFFlVv6JHd+QHLkaOaEqKrVT4PLFFHe
	 fqIm4c4TfGBxNVi2XxNu8RrzHTamZQhQf9wisO+0LOWIby2oDJaQeiPIMa394zI3Y4
	 TKWxFq2ZNVKN6rhZlWdfUh+DApXhP/gl7rFLOPku04iQr5Zb+flRN+3lWSWsV84gxR
	 SER1QxXjStGoLxVbTcILsq+1SQXq64eEtFsG+HrqhyYS+iWzfqOOGPCmsJ2RjetZ0G
	 0RvKuS1RyhKRA==
Date: Mon, 5 Aug 2024 13:27:49 +0100
From: Will Deacon <will@kernel.org>
To: leixiang <leixiang@kylinos.cn>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	xieming@kylinos.cn
Subject: Re: [PATCH] kvm tools:Fix memory leakage in open all disks
Message-ID: <20240805122749.GA9326@willie-the-truck>
References: <20240618075247.1394144-1-leixiang@kylinos.cn>
 <1720577870543075.69.seg@mailgw.kylinos.cn>
 <c651de19-4346-4be9-afe5-16427015680f@kylinos.cn>
 <Zo5GDbKDYmY4uPYz@arm.com>
 <bc4212f7-95d8-428a-95fc-f6c8e017cbe5@kylinos.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc4212f7-95d8-428a-95fc-f6c8e017cbe5@kylinos.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Jul 10, 2024 at 06:00:53PM +0800, leixiang wrote:
> From 56b60cf70a0c5f7cdafe6804dabbe7112c10f7a1 Mon Sep 17 00:00:00 2001
> From: leixiang <leixiang@kylinos.cn>
> Date: Wed, 10 Jul 2024 17:45:51 +0800
> Subject: [PATCH v3] kvmtool:disk/core:Fix memory leakage in open all disks
> 
> Fix memory leakage in disk/core disk_image__open_all when malloc disk failed,
> should free the disks that already malloced.
> And to avoid fields not being initialized in struct disk_image,
> replace malloc with calloc.
> 
> Signed-off-by: Lei Xiang <leixiang@kylinos.cn>
> Suggested-by: Xie Ming <xieming@kylinos.cn>
> ---
>  disk/core.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/disk/core.c b/disk/core.c
> index b00b0c0..a084cd4 100644
> --- a/disk/core.c
> +++ b/disk/core.c
> @@ -170,9 +170,11 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>  		wwpn = params[i].wwpn;
>  
>  		if (wwpn) {
> -			disks[i] = malloc(sizeof(struct disk_image));
> -			if (!disks[i])
> -				return ERR_PTR(-ENOMEM);
> +			disks[i] = calloc(1, sizeof(struct disk_image));
> +			if (!disks[i]) {
> +				err = ERR_PTR(-ENOMEM);
> +				goto error;
> +			}
>  			disks[i]->wwpn = wwpn;
>  			continue;

Hmm, I'm still not sure about this. I don't think we should call
disk_image__close() for disks that weren't allocated via
disk_image__open(). Using calloc() might work, but it feels fragile.

Instead, can we change the error handling to do something like below?

Will

--->8

diff --git a/disk/core.c b/disk/core.c
index b00b0c0..b543d44 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -171,8 +171,11 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
 
                if (wwpn) {
                        disks[i] = malloc(sizeof(struct disk_image));
-                       if (!disks[i])
-                               return ERR_PTR(-ENOMEM);
+                       if (!disks[i]) {
+                               err = ERR_PTR(-ENOMEM);
+                               goto error;
+                       }
+
                        disks[i]->wwpn = wwpn;
                        continue;
                }
@@ -191,9 +194,15 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
 
        return disks;
 error:
-       for (i = 0; i < count; i++)
-               if (!IS_ERR_OR_NULL(disks[i]))
+       for (i = 0; i < count; i++) {
+               if (IS_ERR_OR_NULL(disks[i]))
+                       continue;
+
+               if (disks[i]->wwpn)
+                       free(disks[i]);
+               else
                        disk_image__close(disks[i]);
+       }
 
        free(disks);
        return err;


>  		}
> -- 
> 2.34.1
> 


