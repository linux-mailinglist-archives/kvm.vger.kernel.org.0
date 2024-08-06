Return-Path: <kvm+bounces-23359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E422B948F73
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 221521C20BFE
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04D21C3F3C;
	Tue,  6 Aug 2024 12:48:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9DE1C461B
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 12:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722948524; cv=none; b=SDrNmt1DRvkdVjAG6zB0vOCXMO9Dqk+0XY1yQU38huL7/Nk6tJHlsZ9c5pHXs0nRhWGebxHV2BtO5zpuwqZQQHWe2rf3zfDohdl/K4pOC3rt4mekuh0RN3oDSW7o3dQWj+Md+ddC92/TW6JUQSYL9f1waYLq6O40Qhfbt+wyI10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722948524; c=relaxed/simple;
	bh=Yst/EglKZHmsLVq6dgWrcvhIwaQN+9L1fwnUhCVj81Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0Wx0e9CGgexio0vDDvdU3fnpYokrcXgj+tp3tI1rL7uJba+G7+9hUF6bQTg2W+QghC4WYXO50AhliF6VdMvxIGbeHcYi/PDpRQT38KcK67jEEUScRE/0F0NhQKCtHivpp9uQGJu0mUONZU8zk4+bJ+4b2oxEaQlC66tfU8EpZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 806B7FEC;
	Tue,  6 Aug 2024 05:49:07 -0700 (PDT)
Received: from arm.com (unknown [10.57.79.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D0633F766;
	Tue,  6 Aug 2024 05:48:37 -0700 (PDT)
Date: Tue, 6 Aug 2024 13:48:20 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Cc: leixiang <leixiang@kylinos.cn>, julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org, xieming@kylinos.cn
Subject: Re: [PATCH] kvm tools:Fix memory leakage in open all disks
Message-ID: <ZrIblC5csf73sWvi@arm.com>
References: <20240618075247.1394144-1-leixiang@kylinos.cn>
 <1720577870543075.69.seg@mailgw.kylinos.cn>
 <c651de19-4346-4be9-afe5-16427015680f@kylinos.cn>
 <Zo5GDbKDYmY4uPYz@arm.com>
 <bc4212f7-95d8-428a-95fc-f6c8e017cbe5@kylinos.cn>
 <20240805122749.GA9326@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805122749.GA9326@willie-the-truck>

Hi Will,

On Mon, Aug 05, 2024 at 01:27:49PM +0100, Will Deacon wrote:
> On Wed, Jul 10, 2024 at 06:00:53PM +0800, leixiang wrote:
> > From 56b60cf70a0c5f7cdafe6804dabbe7112c10f7a1 Mon Sep 17 00:00:00 2001
> > From: leixiang <leixiang@kylinos.cn>
> > Date: Wed, 10 Jul 2024 17:45:51 +0800
> > Subject: [PATCH v3] kvmtool:disk/core:Fix memory leakage in open all disks
> > 
> > Fix memory leakage in disk/core disk_image__open_all when malloc disk failed,
> > should free the disks that already malloced.
> > And to avoid fields not being initialized in struct disk_image,
> > replace malloc with calloc.
> > 
> > Signed-off-by: Lei Xiang <leixiang@kylinos.cn>
> > Suggested-by: Xie Ming <xieming@kylinos.cn>
> > ---
> >  disk/core.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/disk/core.c b/disk/core.c
> > index b00b0c0..a084cd4 100644
> > --- a/disk/core.c
> > +++ b/disk/core.c
> > @@ -170,9 +170,11 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
> >  		wwpn = params[i].wwpn;
> >  
> >  		if (wwpn) {
> > -			disks[i] = malloc(sizeof(struct disk_image));
> > -			if (!disks[i])
> > -				return ERR_PTR(-ENOMEM);
> > +			disks[i] = calloc(1, sizeof(struct disk_image));
> > +			if (!disks[i]) {
> > +				err = ERR_PTR(-ENOMEM);
> > +				goto error;
> > +			}
> >  			disks[i]->wwpn = wwpn;
> >  			continue;
> 
> Hmm, I'm still not sure about this. I don't think we should call
> disk_image__close() for disks that weren't allocated via
> disk_image__open(). Using calloc() might work, but it feels fragile.
> 
> Instead, can we change the error handling to do something like below?
> 
> Will
> 
> --->8
> 
> diff --git a/disk/core.c b/disk/core.c
> index b00b0c0..b543d44 100644
> --- a/disk/core.c
> +++ b/disk/core.c
> @@ -171,8 +171,11 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>  
>                 if (wwpn) {
>                         disks[i] = malloc(sizeof(struct disk_image));
> -                       if (!disks[i])
> -                               return ERR_PTR(-ENOMEM);
> +                       if (!disks[i]) {
> +                               err = ERR_PTR(-ENOMEM);
> +                               goto error;
> +                       }
> +
>                         disks[i]->wwpn = wwpn;
>                         continue;
>                 }
> @@ -191,9 +194,15 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
>  
>         return disks;
>  error:
> -       for (i = 0; i < count; i++)
> -               if (!IS_ERR_OR_NULL(disks[i]))
> +       for (i = 0; i < count; i++) {
> +               if (IS_ERR_OR_NULL(disks[i]))
> +                       continue;
> +
> +               if (disks[i]->wwpn)
> +                       free(disks[i]);
> +               else
>                         disk_image__close(disks[i]);
> +       }
>  
>         free(disks);
>         return err;
> 
> 
> >  		}

This looks much better than my suggestion.

Thanks,
Alex

