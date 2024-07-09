Return-Path: <kvm+bounces-21167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8A992B4E1
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 167421C22A31
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 10:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7967D156674;
	Tue,  9 Jul 2024 10:12:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C42156C68
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 10:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720519963; cv=none; b=jY6tCMawwujfJtHR2PELPepLCltNUwICXByITkqqUGGG7VHJxGvN2DywVX4/UoylJKzZv8cQ7CdC9oO1OkVD6IAPV+OQzp3bOONm3O1jMtdG6gfCjcSIqGAjJXddH9XVktFoWiAiNqWdIgA8ejJOyLWEeUNz4ATl0ifx622ioQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720519963; c=relaxed/simple;
	bh=PoR5DI/XzzSgvG5aycSKW+RuhQ4zYs4Fnl5agqgvuCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQwq7Exvle74XwSUGQxVgyy12YkTuUdlQUUw/dJRicLjfIdIAciEMA0LiQKYipXJRPwJnroHfDK4nipPEadYAxh5yoTuC8s8w6lfuM7PtneFez5Vk2tPUQGEtEzP7Bn4z/yyz3abRaW9j9wucONbWaC0DYeyW+lxWUmLKRxkTPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 315D0153B;
	Tue,  9 Jul 2024 03:13:05 -0700 (PDT)
Received: from arm.com (e121798.manchester.arm.com [10.32.101.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E00C43F762;
	Tue,  9 Jul 2024 03:12:38 -0700 (PDT)
Date: Tue, 9 Jul 2024 11:12:35 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: leixiang <leixiang@kylinos.cn>, will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: kvm@vger.kernel.org, xieming@kylinos.cn
Subject: Re: [PATCH] kvm tools:Fix memory leakage in open all disks
Message-ID: <Zo0NE38hE3PAxJrD@arm.com>
References: <20240618075247.1394144-1-leixiang@kylinos.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618075247.1394144-1-leixiang@kylinos.cn>

Hi,

Adding the kvmtool maintainers (you can find them in the README file).

On Tue, Jun 18, 2024 at 03:52:47PM +0800, leixiang wrote:
> Fix memory leakage in disk/core disk_image__open_all when malloc disk failed,
> should free the disks that already malloced.
> 
> Signed-off-by: Lei Xiang <leixiang@kylinos.cn>
> Suggested-by: Xie Ming <xieming@kylinos.cn>
> ---
>  disk/core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/disk/core.c b/disk/core.c
> index dd2f258..affeece 100644
> --- a/disk/core.c
> +++ b/disk/core.c
> @@ -195,8 +195,10 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>  
>  		if (wwpn) {
>  			disks[i] = malloc(sizeof(struct disk_image));
> -			if (!disks[i])
> -				return ERR_PTR(-ENOMEM);
> +			if (!disks[i]) {
> +				err = ERR_PTR(-ENOMEM);
> +				goto error;
> +			}
>  			disks[i]->wwpn = wwpn;
>  			disks[i]->tpgt = tpgt;

Currently, the latest patch on branch master is ca31abf5d9c3 ("arm64: Allow
the user to select the max SVE vector length"), and struct disk_image
doesn't have a tpgt field. Did you write this patch on a local branch?

>  			continue;

This is what the 'error' label does:

error:
        for (i = 0; i < count; i++)
                if (!IS_ERR_OR_NULL(disks[i]))
                        disk_image__close(disks[i]);

        free(disks);
        return err;

And disk_image__close() ends up poking all sort of fields from struct
disk_image, including dereferencing pointers embedded in the struct. If
WWPN is specified for a disk, struct disk_image is allocated using malloc
as above, the field wwwpn is set and the rest of the fields are left
uninitialized. Because of this, calling disk_image__close() on a struct
disk_image with wwpn can lead to all sorts of nasty things happening.

May I suggest allocating disks[i] using calloc in the wwpn case to fix
this? Ideally, you would have two patches:

1. A patch that changes the disk[i] allocation to calloc(), to prevent
disk_image__close() accessing unitialized fields when disk_image__open()
fails after initialized a WWPN disk.

2. This patch.

Thanks,
Alex

> -- 
> 2.34.1
> 
> 

