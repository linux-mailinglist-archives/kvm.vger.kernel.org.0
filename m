Return-Path: <kvm+bounces-66728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C3772CE5842
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D7E64300ACFE
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 22:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A280229AAFD;
	Sun, 28 Dec 2025 22:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nPetPV5i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5637A3A1E6F
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 22:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962147; cv=none; b=KsoCXn+MAdctOgh8Ctobg7urNFvixetcy829/FHPiMAcLS6WSvbcaHB/snbXanL88ew/IvpKD3yG0QkOSPexsh/DsuNO5wmszKdHR3YHkHSI4KtKFqkMrmQzigDBN97noLw9IXQECjh9onGPc/zJnFAqd7ASBq0WMOmOC9daek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962147; c=relaxed/simple;
	bh=7xs7rBHCkEu0qSnjRBBkrDuWcff1dR9koDAyagfZn70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQpGIa5N/lueDD/XBYEyZXkk1PB5+w7vsKCjDNMy5/57xfqDVd3b24oTb58PstDN/W3/I7L86BlbSJBtNbObD/uGSCslT3mNjE6LBs5ypwbcy0HyjalumbgJgNN4y6vliPm5y9dorjrb9G3e6nsKnJQkc7vK55XnnGnuo8ChDX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nPetPV5i; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a12ebe4b74so154940115ad.0
        for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 14:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766962145; x=1767566945; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BnVxB8hHP+UEx+EyrlcIpTFAKkUEwNTCu8Of5uWFpkg=;
        b=nPetPV5iEOKTg1X99grd64geyoYpeN4Aexbgs6Ab9dSP8ku/hSCne77nN4ic/KtHRe
         QeF1BxOq+zpVNa2hBhjMcTITqfxM2j5YLOqjp6vH4Scp5HIheECDkIxseNuIm6q88mYT
         5zfL8LAEMuihdNDx9B4KvoZb3yjGgnxApFfOxPfh+Q9KuWncQDcYv8MQ9Ct6cOCzC+Pu
         3HZjGlpZlLVZ7rZGQ3FYefIwvYTa+1D8y9Cp2d62mqDY1qxN670qHTEyhdA7kfklSyTg
         wr7bxMvXOAUeXPnS/N5fUg1zIEFh3EY81RoXkJwdDrUgI1H4J8UYxFbg8iLF9vohSa0M
         KNDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766962145; x=1767566945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BnVxB8hHP+UEx+EyrlcIpTFAKkUEwNTCu8Of5uWFpkg=;
        b=jEu9ulwE1O7SThJpICSvX5JPW2rO+1uI51oZaZpU23qoFQdO+2YGX27DPlKQWH2/fx
         sq83szjNr/i4FB3fKkN+O8bHSTgJxsD1RLWPlq36TJ5l/j+fbJLLO4Pm6+8QtFMMwjr3
         so8qc5qNKN0Ye1HvXx/DLuMA+Lx+ZtQ4G6+jGYTyKOrvsvTC7oanhwtinpfl8HnmWc+y
         qX8Y/sSuZkCQKku7xEYldXGFckapKQ0uBCAjVVUutYSJJkL1atLk+t92oqfWParDZ53e
         nf1FXuHestIZHfkeZTQVCDODRP91He1SBDiXV/6M5UexLqC157WShEunFqzZ5lv9I1bz
         fmsg==
X-Forwarded-Encrypted: i=1; AJvYcCXpEU+EudlVV3noiaSKlE8WeW7Ewo0eTTqqadeJjm5eRGshBws873hb9pZObWirV/ddhgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBmwBF9GqBXQdwqXrsXlZZsyFThjo8r/X7mJniG8bEYTKVKRwt
	BqgWtAGEvhwMl3ne5i9SX/NWmEulkF5ibmrbAI3ioODmVBXFkULgGTpk
X-Gm-Gg: AY/fxX6sJ+/ar7YtQfmb9ekmXS4sgCGSWdbsa5hAHrelvciQjNMhfrPcIm7m4rCXb8C
	tADpqmF9o2Gs3g1zs/YJTVkKX5g0nDTaN6yRjadiPpG2QzXJJyQUvxhcZ6/ccYs2XUtp1KoADoq
	DgIMjJK3hOrZ6bJxhtU1FgIT3FoCcRxGIhj66RI7gEHvynhLuIk5Ghhk1qI8OrUcAAvRFprJ3dY
	/yj7vpnzkB4eSR+hKnSHgAMegK8S0hpRjYJUH58qtlSkXtBCpPQrzsxwlSS6uGOqQ//RNKl2E4t
	VSWkv/vnhLHQVlGbBt54hC6lHxvu9g2wvQeUANcIeoTYVWc7gKl37gk12fpXRNGMGSXfXpG8kE7
	R4eOfrkUi1xJJn6dsEC4S2Gt9ipjqUGHDLPeiY3JMrzSL2iWnB4w972PGPxNVYezls/GqVxpBWy
	XfIu++PGMiN5vkRMgR
X-Google-Smtp-Source: AGHT+IFrZ0jqqyfa4w9leqRMWpvEB4wvR96T1u2WwgRjWIQZDJOokmhOcBM1uE4s/VnzQJrZGEFtuA==
X-Received: by 2002:a05:7022:4284:b0:11b:9386:7ed3 with SMTP id a92af1059eb24-1217230b84amr31429073c88.48.1766962145520;
        Sun, 28 Dec 2025 14:49:05 -0800 (PST)
Received: from localhost ([2601:647:6802:dbc0:79af:1f76:2f9:193d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217253bfe2sm83886095c88.10.2025.12.28.14.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 14:49:04 -0800 (PST)
Date: Sun, 28 Dec 2025 14:49:03 -0800
From: Cong Wang <xiyou.wangcong@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Cong Wang <cwang@multikernel.io>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [Patch net] vsock: fix DMA cacheline overlap warning using
 coherent memory
Message-ID: <aVGz39EoF5ScJfIP@pop-os.localdomain>
References: <20251228015451.1253271-1-xiyou.wangcong@gmail.com>
 <20251228104521-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251228104521-mutt-send-email-mst@kernel.org>

On Sun, Dec 28, 2025 at 02:31:36PM -0500, Michael S. Tsirkin wrote:
> On Sat, Dec 27, 2025 at 05:54:51PM -0800, Cong Wang wrote:
> > From: Cong Wang <cwang@multikernel.io>
> > 
> > The virtio-vsock driver triggers a DMA debug warning during probe:
> > 
[...]
> > This occurs because event_list[8] contains 8 struct virtio_vsock_event
> > entries, each only 4 bytes (__le32 id). When virtio_vsock_event_fill()
> > creates DMA mappings for all 8 events via virtqueue_add_inbuf(), these
> > 32 bytes all fit within a single 64-byte cacheline.
> > 
> > The DMA debug subsystem warns about this because multiple DMA_FROM_DEVICE
> > mappings within the same cacheline can cause data corruption: if the CPU
> > writes to one event while the device is writing another event in the same
> > cacheline, the CPU cache writeback could overwrite device data.
> 
> But the CPU never writes into one of these, or did I miss anything?
> 
> The real issue is other data in the same cache line?

You are right, it is misleading.

The CPU never writes to the event buffers themselves, it only reads them
after the device writes. The problem is other struct fields in the same
cacheline.

I will update the commit message.

> 
> You want virtqueue_map_alloc_coherent/virtqueue_map_free_coherent
> methinks.
> 
> Then you can use normal inbuf/outbut and not muck around with premapped.
> 
> 
> I prefer keeping fancy premapped APIs for perf sensitive code,
> let virtio manage DMA API otherwise.

Yes, I was not aware of these API's, they are indeed better than using
DMA API's directly.

Thanks!
Cong

