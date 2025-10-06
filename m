Return-Path: <kvm+bounces-59552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EAC4BBFB9A
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 00:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 670BC189E158
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 22:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00751DB958;
	Mon,  6 Oct 2025 22:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BDZ4EHSg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FB24A00
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 22:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759791044; cv=none; b=K68s53uyeakBO+rwsoeUgN6ICh3l5xLGQmEVdNZRYaYX3u2Zu2porqJ45TAiAH3HYUSfTus4u4fGfRpMgDjtdW44aGNr122mkjfbfSDKX0B/Xkz29Wvv77JfpqCrdvHFar/LhEjj6acxZ5iB5HJ+l19AyrXBaeelZUIi8pXaEag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759791044; c=relaxed/simple;
	bh=j8RVgIHcecZ6vNuLBZhQD8XDmrwSGnwngJoxF/6sqdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJahZEeRbTwmCZi+OplCAJbhsUPrxhz0XxVbkbT23WiK6LwZ9HyvYjPC+tThd7L5zxW5tg3w06zTihtxChh7cLv3aedza94srCDg3yP8CZRVYKMEokFn4DgavNf8yjo8ygXp8bYKLDVDGUYtHHVLc6I0NEBtybKAtwiCqF/kF+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BDZ4EHSg; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7960d69f14bso35138286d6.2
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 15:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1759791042; x=1760395842; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t1+dP9kjoBak9iuGOU/j3R1WyEWlKUJiQn+oDzUnB/s=;
        b=BDZ4EHSg5GzH1tetl7kQ3cZaQ9mXyBtsvsfVggmMC/04tf4tc/XZJERblzAqc78Pne
         DWmmdgmk1FnkYJfO1YUeva8PSaIANVvDo70lXc0kmw68k9Qrb48kBasy93mRY+8Mn+JC
         Cyu7R94047P4d6/2v3WKNNRFFNjEEqvJcRk0KKFjtLMwcvhSvtjEwhuIgcV/6qHXtJb6
         BLoAP0hFAoa1FFtk/BOUfPy6T3JXGA0kdbPBpiJ/OxYvUu38HXb+0tj0PWcvEdVtoMb+
         RPV27txRDPJGu6qvaxjCnSLu5bjZaFQjtnGPlRMfYTj5k5hSE6ZxZsQCDxF8efP/7T3b
         iM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759791042; x=1760395842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t1+dP9kjoBak9iuGOU/j3R1WyEWlKUJiQn+oDzUnB/s=;
        b=c4AEdho5TaIMPypdqvnt5gzQ2SoSVuFf/6y67/PgDKIscLgnGaCVHon8TP/QN+zQ48
         yKPVyH6x2ESUvQtjJ9ExmXZIlKJpICfM/BOPQVTsD1GSikTJcrUBDhSFct3dqUYUX2SF
         RDVJBRe8gGRl9k9DkL5umwGXHhu0LqmNiv12HIUUc6FbDcaffO7lqVbxw0bVJAXxv5ZL
         piyy/CT3Xy0AWzKDKmvia32IGbNvsscpQZRT+TpwuSKQ5fRK226olPYdi14ZeQLXqqzU
         LOdvTurboBog+9t9dhTlfLMOuIX+sDcKO0Axvua7bj2RWZaD3dANC9Yq5n1iRDdv78Hd
         Rl2w==
X-Forwarded-Encrypted: i=1; AJvYcCXVDwJELyrIkspmzh3K2YyXXe1apJQofOe92600eMyjG3JwUtYX12VASyHSjzPr72h7n3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFp0LO+XoU6dAVcs5uEh5hgW8tkB5gzhW1Lsp9L/UGuLZ4hK5I
	Jj63htzn+IquHoTrYgpvOVFmKF/gzFxQhPkMpwh1QY1NiWZ13xM9yqgE2u1tJwxApno=
X-Gm-Gg: ASbGnctL5eQ02hWuih3ev4sYhM9U7cN7DfYUpyMYA0tGDF8FaZmY+s9Plaw6ASU5FYp
	4P80s4LCJtvqisTnoXd5ZjVPNTI1onY6yL8HxHy2eQL5w4mAvItvJBFc1PfsBj/y0SYHq1UVaYw
	toM9SXTLc1EEnUmfFH4DyW/kpSIK0+jNFVrFk7tyUayABi6Af2Zc0HOy5xRGENone8yWNzQrj3h
	q38Sga58KUDmEX2QlwHDoQ0Zze+D63PffRTs2DIZuyHTFjgxrUpvTbjenwF61HeFirid7WGK912
	NfwljTBctDMDKYhYLzNZSBcy9HxDN9GxTUW01qlCRnfQvYnNWe0Jii6DxHHnDT4d5KsSeJ6E684
	/TwzKTG8fRtTn+ns2fIDS
X-Google-Smtp-Source: AGHT+IHzlobXG0MjkPJh2nGePMJSByfyR0QwUZj8yqsAUFGxRY2aOWeCzXWMnbZWCqE5GDBOCCvduQ==
X-Received: by 2002:ad4:4ee4:0:b0:863:5c7a:728a with SMTP id 6a1803df08f44-879dc869b21mr181258646d6.37.1759791041935;
        Mon, 06 Oct 2025 15:50:41 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878be61f6bcsm130119516d6.65.2025.10.06.15.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 15:50:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v5u2R-0000000EUgB-3p8Y;
	Mon, 06 Oct 2025 19:50:39 -0300
Date: Mon, 6 Oct 2025 19:50:39 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
Message-ID: <20251006225039.GA3441843@ziepe.ca>
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
 <20251006121618.GA3365647@ziepe.ca>
 <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>

On Mon, Oct 06, 2025 at 09:29:07AM -0700, Alex Mastro wrote:
> On Mon, Oct 06, 2025 at 09:16:18AM -0300, Jason Gunthorpe wrote:
> > This doesn't seem complete though, if the range ends at the ULONG_MAX
> > then these are not working either:
> > 
> > 		if (start < dma->iova + dma->size) {
> > 
> > ?
> > 
> > And I see a few more instances like that eg in
> > vfio_iova_dirty_bitmap(), vfio_dma_do_unmap(), vfio_iommu_replay()
> 
> You are right. There are several places which would need to be fixed to handle
> mappings which lie against the end of the addressable range. At least these
> would need to be vetted:

Could we block right at the ioctl inputs that end at ULONG_MAX? Maybe
that is a good enough fix?

Jason

