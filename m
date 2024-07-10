Return-Path: <kvm+bounces-21299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8160292CEC4
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 12:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D00328A3E2
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71AC18FA2C;
	Wed, 10 Jul 2024 10:03:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0681C1B86F3
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 10:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720605805; cv=none; b=BtAEUQ2pPzjGR4XaWpSjtQ2IYfMVCf52MOa/0MMfhTS8IaQBfsMMTYkOFipuK5dvVx8c1la3s0Iv50YtXNpLdIv3aTDu7RDwjgqGfvCJOkxZ9j8axtXAvsR2YI9Z5QhI7QkneedBjGgu890Eh5oNj/59lApZCgCCTb7f79Kx6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720605805; c=relaxed/simple;
	bh=nIT+15KolhN25FJludlfUIU4OFZgBNyHRtf2cl2yjVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHBHHD9WgN9dJKy+PzpBPJN/mIWKOvPiR5xHqDm8c6zzJhatbKQtalh6nHSBkqHOBqSM8DBgHxqhdVsPoYPeLiPiQrLiwjwH371SHkwIoEO/kQAHJsNGIUR3xPLN9mw6gmi+V6gOvpKzLupKB6pOkAGpxHRaz4noyijXVk/5FCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F80B106F;
	Wed, 10 Jul 2024 03:03:47 -0700 (PDT)
Received: from arm.com (e121798.manchester.arm.com [10.32.101.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 323B23F762;
	Wed, 10 Jul 2024 03:03:21 -0700 (PDT)
Date: Wed, 10 Jul 2024 11:03:17 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: leixiang <leixiang@kylinos.cn>
Cc: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	xieming@kylinos.cn
Subject: Re: [PATCH] kvm tools:Fix memory leakage in open all disks
Message-ID: <Zo5cZdi6pF4XQYFj@arm.com>
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

Hi,

On Wed, Jul 10, 2024 at 06:00:53PM +0800, leixiang wrote:
> Dear Alex,
> Thanks for your reply.
> 
> On 2024/7/10 16:27, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Wed, Jul 10, 2024 at 04:12:37PM +0800, leixiang wrote:
> >> Dear Alex,
> >> Thank you for your reply and suggestions.
> >>
> >> On 2024/7/9 18:12, Alexandru Elisei wrote:
> >>> Hi,
> >>>
> >>> Adding the kvmtool maintainers (you can find them in the README file).
> >>>
> >>> On Tue, Jun 18, 2024 at 03:52:47PM +0800, leixiang wrote:
> >>>> Fix memory leakage in disk/core disk_image__open_all when malloc disk failed,
> >>>> should free the disks that already malloced.
> >>>>
> >>>> Signed-off-by: Lei Xiang <leixiang@kylinos.cn>
> >>>> Suggested-by: Xie Ming <xieming@kylinos.cn>
> >>>> ---
> >>>>  disk/core.c | 6 ++++--
> >>>>  1 file changed, 4 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/disk/core.c b/disk/core.c
> >>>> index dd2f258..affeece 100644
> >>>> --- a/disk/core.c
> >>>> +++ b/disk/core.c
> >>>> @@ -195,8 +195,10 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
> >>>>  
> >>>>  		if (wwpn) {
> >>>>  			disks[i] = malloc(sizeof(struct disk_image));
> >>>> -			if (!disks[i])
> >>>> -				return ERR_PTR(-ENOMEM);
> >>>> +			if (!disks[i]) {
> >>>> +				err = ERR_PTR(-ENOMEM);
> >>>> +				goto error;
> >>>> +			}
> >>>>  			disks[i]->wwpn = wwpn;
> >>>>  			disks[i]->tpgt = tpgt;
> >>>
> >>> Currently, the latest patch on branch master is ca31abf5d9c3 ("arm64: Allow
> >>> the user to select the max SVE vector length"), and struct disk_image
> >>> doesn't have a tpgt field. Did you write this patch on a local branch?
> >>>
> >>>>  			continue;
> >>>
> >> There is no doubt that you are correct, I had realize that I git clone a wrong repo.
> >>> This is what the 'error' label does:
> >>>
> >>> error:
> >>>         for (i = 0; i < count; i++)
> >>>                 if (!IS_ERR_OR_NULL(disks[i]))
> >>>                         disk_image__close(disks[i]);
> >>>
> >>>         free(disks);
> >>>         return err;
> >>>
> >>> And disk_image__close() ends up poking all sort of fields from struct
> >>> disk_image, including dereferencing pointers embedded in the struct. If
> >>> WWPN is specified for a disk, struct disk_image is allocated using malloc
> >>> as above, the field wwwpn is set and the rest of the fields are left
> >>> uninitialized. Because of this, calling disk_image__close() on a struct
> >>> disk_image with wwpn can lead to all sorts of nasty things happening.
> >>>
> >>> May I suggest allocating disks[i] using calloc in the wwpn case to fix
> >>> this? Ideally, you would have two patches:
> >>>
> >>> 1. A patch that changes the disk[i] allocation to calloc(), to prevent
> >>> disk_image__close() accessing unitialized fields when disk_image__open()
> >>> fails after initialized a WWPN disk.
> >>>
> >>> 2. This patch.
> >>>
> > 
> >> When the new disk_image is allocated successfully, 
> >> the fields will eventually be initialized by disk_image__new().
> >> And disk_image__close() accessing fields also checked before use.
> >> So I don't think it's necessary to replace malloc with calloc.
> > 
> > When and where is disk_image__new() called?
> >
> Sorry, I was ignored the 'continue' in the code flow.
> There is no doubt that your suggestions are forward-looking, 
> and I have made changes to the patch according to your suggestions. 

Great, thanks for checking, I was worried that there was something that I
missed.

Thanks,
Alex

