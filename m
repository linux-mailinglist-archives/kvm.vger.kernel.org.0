Return-Path: <kvm+bounces-46730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30CE3AB9118
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8A4F1BC17F1
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 21:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A8E296FD7;
	Thu, 15 May 2025 20:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QBcMje+z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D306220CCE4
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747342785; cv=none; b=Bh5oTZWJWBqdu3SdBhuR7ZvMByGqQzI9i6aKWq6BdWG7Zm/MXCKL5+MuHrBO0nlZY4/+7XTI+JggftiL1IIaJer3pc9yvM5qGEkOfGl3oC6r/HBpXH4XjG4X57e0Up56qjTDxxtNC6wBzWh7RlHf/UvmrDtGQSWL5tul83K+UGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747342785; c=relaxed/simple;
	bh=poTNA13RYhsbQ3gSLMEIM6y7nL7u3ZOwz1oBUE84330=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5JTtiOvANQBFXdTKfE0eiSuC43w+UN4Zwjq0KlenQIWmLmG0FG7T4pYMEwrQ7DjL6mZOrMZfqzfgoolfL5ZuEklVw/M9zQORYkMp76KlE4Krq/vIv6lnTN2eZCTc+Xld5vDdgaq8AsuBx3dHAej8oLvX0JuNAVM5HAbLJQmxRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QBcMje+z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747342782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a90HZVhSoRMnYuc4Dwm77y+oh9gSMrFudFO68j2iHBk=;
	b=QBcMje+zfmH/AhfN44kd4chlH4Wzs2DgrDHFAZIkeO6nyvJCnG5XVLwIUJMzB+MwI3jrq0
	1KpZmfrYJ1sw3aCSGiv/JStDvgTPiuCWIl1zcPQUrbLH4mLFfx/ALmC+64cY/q3oABo75L
	6XYZlSp1iG5btDu5sD6V3dsxrMC0h+M=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-QXEn6yinOFqXT4XhBYI_wA-1; Thu, 15 May 2025 16:59:41 -0400
X-MC-Unique: QXEn6yinOFqXT4XhBYI_wA-1
X-Mimecast-MFC-AGG-ID: QXEn6yinOFqXT4XhBYI_wA_1747342780
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-85df98f62d1so28450639f.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 13:59:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747342780; x=1747947580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a90HZVhSoRMnYuc4Dwm77y+oh9gSMrFudFO68j2iHBk=;
        b=RNai4fhuiGiqsDNDB5cVikbMMGsR6EzUfwHlu2xH7C6FcjpcEqG8YgVIgmhUg3XbUj
         +JkTg0RiQtc5lbCrjwnxVttBIgyl6euYD6Mnn2joY2x6fEgOctnRcsAVbsGBV4fUnAQd
         7Oq2nOEBYlZrvXpQqoOLar1LsBTq+FH4z3EdxOBb4IWSVFwEyM2LV0ygIs/REpfzYzzo
         l6QEQdcJ7Oc2D8OODVtbqpOUv16CmeAmRw/mXSuY63p5Mdu96C0oofzwmW2XBFSPjRJI
         8TT3YTdQGkTGFBPXFro57Dx41whIklw1/csRasEI5EMLa24NRYSTimXW/gdMGK90Cji2
         mUAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCHtuuEpIyDA0PD1BTkgn1mM42imwHs5sEl3qzaoECpji43V9ND/I7W+eYC7lc/AzwEJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YySBAIXX3+YNnE3XQ1W4MHmPTc/dhwLdoBPw0n5dK/lms3I4b8Z
	t+tXbxg8cXFvd/NQqmqR5VzYXhRt5D+8TCXrOZIFANoc6nAouQGYzj3ZBa7FHAi7ElUCoRGlA4Q
	Rd1bYKtNvWnEYbM8+dtKGKODbgb7dlGa6Ycaf0XwsYZfV7bFv5xG3Yw==
X-Gm-Gg: ASbGncubeJvqLux5OcW+gWI8je1nVzzQgkUPNls780MNkYFeKwJ4QnZxe/pAPYgQSZ5
	yhKelUDxrvmVZtUjV5b7bCwIPn5ArZ/3F14vLTUHgLaVbHQ0MZR/a40ptDzainGqJMT+p+sNMuX
	9p6RjnLwzmmdZWTeGpOwg3CdRlWDBIpcyQ/o5ZVOUVYsS4h4PTZAeQatLNFGXlQAiMdQc6RN3++
	zZbKsJK8sSdxzjHOEssEMxiZMw28CiOju7X1a5LQuNUoLCKDCZCNP54n5MXOsGQBBB77PplVLxh
	TnwqmqQssYbG2Jw=
X-Received: by 2002:a05:6602:6d05:b0:864:9c2b:f842 with SMTP id ca18e2360f4ac-86a23078a8amr60003239f.0.1747342780487;
        Thu, 15 May 2025 13:59:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1qEeUg93svB/Ru6DdDnVjbDCJh7uDukOZWSN6Ho9Ib+VBXYxUPNezcGVhpv0vRuCzsPn6sA==
X-Received: by 2002:a05:6602:6d05:b0:864:9c2b:f842 with SMTP id ca18e2360f4ac-86a23078a8amr60002139f.0.1747342780112;
        Thu, 15 May 2025 13:59:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4aa701sm86312173.115.2025.05.15.13.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 13:59:39 -0700 (PDT)
Date: Thu, 15 May 2025 14:59:36 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, kvm@vger.kernel.org, Yishai
 Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
 <kevin.tian@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] Please pull mlx5 VFIO PCI DMA conversion
Message-ID: <20250515145936.11210c0c.alex.williamson@redhat.com>
In-Reply-To: <20250515195116.GP22843@unreal>
References: <20250513104811.265533-1-leon@kernel.org>
	<20250515114715.0f718ce0.alex.williamson@redhat.com>
	<20250515195116.GP22843@unreal>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 May 2025 22:51:16 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Thu, May 15, 2025 at 11:47:15AM -0600, Alex Williamson wrote:
> > On Tue, 13 May 2025 13:48:10 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > Hi Alex,
> > > 
> > > Please accept this pull request, which presents subset of new DMA-API
> > > patchset [1] specific for VFIO subsystem.
> > > 
> > > It is based on Marek's dma-mapping-for-6.16-two-step-api branch, so merging
> > > now will allow us to reduce possible rebase errors in mlx5 vfio code and give
> > > enough time to start to work on second driver conversion. Such conversion will
> > > allow us to generalize the API for VFIO kernel drivers, in similiar way that
> > > was done for RDMA, HMM and block layers.  
> > 
> > Hi Leon,
> > 
> > Pull requests are not my typical workflow.  Are these mlx5-vfio-pci
> > changes intended to enter mainline through the vfio tree or your rdma
> > tree?  
> 
> VFIO changes will come through your tree. DMA patches are the same as in
> Marek's DMA tree and in our RDMA tree.

Ok
 
> I prepared PR to save from your hassle of merging dma/dma-mapping-for-6.16-two-step-api
> topic from Marek and collecting VFIO patches from ML.
> 
> > Why do the commits not include a review/ack from Yishai?  
> 
> They have Jason's review tags and as far as I know Yishai, he trusts
> Jason's judgement.

I don't doubt that, but Yishai is listed as the maintainer, so barring
some special circumstances we should at least have an ack.

> > Typically I'd expect a patch series for the mlx5-vfio-pci changes that
> > I would apply, with Yishai's approval, to a shared branch containing the
> > commits Marek has already accepted.  I'm not sure why we're preempting
> > that process here.  Thanks,  
> 
> This is exactly what is in this PR: reviewed VFIO patches which were
> posted to the ML on top of Marek's shared branch.
> 
> If you prefer, I can repost the VFIO patches.

I appreciate the attempt to streamline things and expect this largely
only affects the chain of sign-off approvals, but at the same time
that's an important aspect.  If the code here is identical to v10, we
could use that with Yishai's ack, but it's probably most direct (irony
vs PR noted) to repost just just the mlx5-vfio-pci changes with a
reference to Marek's shared topic branch.  Thanks,

Alex


