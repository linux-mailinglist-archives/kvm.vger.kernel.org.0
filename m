Return-Path: <kvm+bounces-67373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 872D0D03167
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 14:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 10A81300A90F
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 13:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5DB39E181;
	Thu,  8 Jan 2026 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VXNJAOji";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gKablw+A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4E346920B
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 11:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767871678; cv=none; b=VPfiXesQ019xu0CK9gei1M03BrV9K5zNjqM8PUY4xxXEj9MK92t5XeO/U4PLiXGgd98sZjshpDlWOpR2N9FMdhhlFMpnTCT55Td8zqcSlnvrLCd5vf+ZKUEXtJnPUldCTh/cQwOnlMVsKZkSLaSGqimgXxs9Z6KOuLI3PIu+exk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767871678; c=relaxed/simple;
	bh=DXVRxgEjQyIFhLiJRSIIYHf6s0Xh3efyK6PB23H68Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXY/rilOBDdsAUSPeGRAwX6gJw3d38GmDM2+W9jdjOXkHqVqExQxjkgYBsoIo2ClN1NpYK5Le97XCT4sj9KSNhYDL0yhv37fAGVBD2aHAk8atVfRPReP3j6v0tF8808FLc2filCDZvXRAbPkvYWsYevRG+b6/N3PGaPoHoFD7lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VXNJAOji; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gKablw+A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767871674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7OLB5of9LH4Xgr0g/cKdpkyNCBxF+ZVgPMqVenfELd8=;
	b=VXNJAOji900LbBB3YipqIIEnHHd09fRytx1wSbSkMJjgNoMIFWPi808TFBWER22JZAyo3h
	zuaOogzChP+mHw5JgkDog7P2ZscdXwkHq4LLU67BT1HHYCDa9jDe6od92w6ofxx/P0be1q
	dxcq+YoQRy6psmsKyiyE0qy5PoN0DDI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29--L8Ws2fiNtyyDs9eW9kOXw-1; Thu, 08 Jan 2026 06:27:53 -0500
X-MC-Unique: -L8Ws2fiNtyyDs9eW9kOXw-1
X-Mimecast-MFC-AGG-ID: -L8Ws2fiNtyyDs9eW9kOXw_1767871672
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775d110fabso29033325e9.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 03:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767871672; x=1768476472; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7OLB5of9LH4Xgr0g/cKdpkyNCBxF+ZVgPMqVenfELd8=;
        b=gKablw+ACVcLJ6DvTE9rQO7V6DTsNNxQw+BMfHf4bN/t/62m81D3wxPKm9zWG/vzUA
         ta7xgfNwl4K+FPLXCwswbzUa+553v+xo1cz9ojeRZBE1E0PGJ1oZkh9GGEuHQgywGjHQ
         PuQ79p8T+X6WR5VOlHIleeMDyPRWjLIcZJ/imT/YOqX2pZSie4wLKS3rlBtLNw1vZ8lh
         rFnumjKGmfjyjL+1N7A6TbyRexqpAugySIJRzpRnl8IKPMqxZtZylmkzxpfa8LoaS7Fw
         bSZrDoQdvLDYaZhp5siaDq7alwWrJat30sSc02G3aTYISGE3YjJrBZbgBsnAUEd2YAAM
         nEnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767871672; x=1768476472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7OLB5of9LH4Xgr0g/cKdpkyNCBxF+ZVgPMqVenfELd8=;
        b=Mt0OaC7LPTHFjHrDwdbHXBNnRSD266Mk62MAv9COqjElSqTjQgsnVkoT9VaOMrXf+9
         P1X+Vkc+TAVibGCOLWnK7qAaBhvBkXwnvevfEVnzZGsD1Nc0b+lPJ6zdJzKjyZeYBpQS
         BiV9SH6m3FiNwIW6S9w1euofO6npqNrJjqK4R5z1fXeICWMlEcrdDDEvmkHK751GKSfi
         P3zL/ka2RHC/u8lYFCddFOH/8NsmFZNgzP30tO7CHycCqcFpKFdz85O6T3VDbP7R04nj
         lG9jlQtSm4qI0JVzjeZ1rLLnqwzBp9xHVHvtiHzeg+lb32/bN3ObkhHLfdz2PljmQDFa
         d3/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHdA4Lhzzidn8xWkwtBy2/FTXJT0RyeeqCD2VCsNzzE9UfMqWsRhaeNHDe2wrOO7/Rtxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzerdpDsDCl+ijKiYKWelSzirwTMvgelc/6zacGSrevQMFPaySX
	FJcF6MHM2QiPPC9/nbjvguzK5HrZRACdWkmDzBhVLtMuumMu1Mq/TBfBDbsKtsoji/WM0HEkU75
	O5jmC5KzVPiGsjCOWK9Zjkhsx4hmGqiNbHfrDQQXyUCgCJbDBYqZUuw==
X-Gm-Gg: AY/fxX5rcaiBZYrdIgCPBVizLSgJTAfoc7ikW+wXrzaB9W7aT1jKu1wHwt4FUEBW6b6
	br2zIE6mRN59duV6d4uqpsqnJA6yfwaUXA+PrT4y3mdr2SmZLNS79Lb/BvogQbCLdMjN+9TXmS1
	XfWT8tcXLiJNHgGZF6T+L9/Tv1RypMvsj5jOAbRoLeNUeGDd8paVFHchfeuNirj/pUMqYri2sUQ
	/3oc40GdKdk8c9hdrj+mo2ej2zmdzUiZdYKPRg5BCL8s+fvMMjbJpgJ1m+5WuMgR01Z+IABCowc
	jmWvyIvDvSeycq/AxDJShH22GA2G9Olk49+BK+BoF9K6r96Hnb5SdwpNZwpIkclcgyoPukfWilU
	f1OwbXG0RO57/2iRp
X-Received: by 2002:a05:600c:648a:b0:47a:9560:ec22 with SMTP id 5b1f17b1804b1-47d84b17ae4mr64276155e9.14.1767871672372;
        Thu, 08 Jan 2026 03:27:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHCrhVJUOXGI01OCCuWHNzKXAge7t6WHbeU8FiHMv65fBH2sXqaXVpMSUa0Er0tnD1FeKLcmw==
X-Received: by 2002:a05:600c:648a:b0:47a:9560:ec22 with SMTP id 5b1f17b1804b1-47d84b17ae4mr64275905e9.14.1767871671965;
        Thu, 08 Jan 2026 03:27:51 -0800 (PST)
Received: from sgarzare-redhat ([193.207.178.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f668e03sm154398805e9.14.2026.01.08.03.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 03:27:51 -0800 (PST)
Date: Thu, 8 Jan 2026 12:27:41 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Subject: Re: [PATCH net v4 0/4] vsock/virtio: fix TX credit handling
Message-ID: <aV-UZ9IhrXW2hsOn@sgarzare-redhat>
References: <20251217181206.3681159-1-mlbnkm1@gmail.com>
 <xwnhhms5divyalikrekxxfkz7xaeqwuyfzvro72v5b4davo6hc@kii7js242jbc>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <xwnhhms5divyalikrekxxfkz7xaeqwuyfzvro72v5b4davo6hc@kii7js242jbc>

Hi Melbin and happy new year!

On Thu, Dec 18, 2025 at 10:18:03AM +0100, Stefano Garzarella wrote:
>On Wed, Dec 17, 2025 at 07:12:02PM +0100, Melbin K Mathew wrote:
>>This series fixes TX credit handling in virtio-vsock:
>>
>>Patch 1: Fix potential underflow in get_credit() using s64 arithmetic
>>Patch 2: Cap TX credit to local buffer size (security hardening)
>>Patch 3: Fix vsock_test seqpacket bounds test
>>Patch 4: Add stream TX credit bounds regression test
>
>Again, this series doesn't apply both on my local env but also on 
>patchwork:
>https://patchwork.kernel.org/project/netdevbpf/list/?series=1034314
>
>Please, can you fix your env?
>
>Let me know if you need any help.

Any update on this?
If you have trouble, please let me know.
I can repost fixing the latest stuff.

Thanks,
Stefano


