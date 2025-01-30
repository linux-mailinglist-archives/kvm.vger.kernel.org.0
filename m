Return-Path: <kvm+bounces-36928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 751A8A23145
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 16:57:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01A187A19A5
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 15:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D179F1EBFE0;
	Thu, 30 Jan 2025 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgiVo4+e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA791E1C22
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738252654; cv=none; b=bGkyQsGa8oO6wROj146+cmKe9uYbmCSP2NhTWt8Pq9zK2rC40Z1IBiEVG9npgwCzb/qmzxHq+ueA0EO4rJvoHtIcjG/WV17cLpYlhJm3QAdBVDuhQJUFTqN2SXiaRHVmh5HGcIhAOHqNZrl0vZAn6AeKPT1YJ5QFwLjpRuQPvw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738252654; c=relaxed/simple;
	bh=G2KWCKxGBBnMxM2TX/y2N4+aloxOeEzYQkrSkO2/u8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kF0B3x503qUUrsdYoIz7hNNujy/6ZpTUfUetyIySgphQH2iuyCwNSa61yMytNgEucbWnXRCJuu9f2YcL3OAgcdTXc0lnrwfIrYWckoid84a6bjKO/YjsD4dzS9rvqR+AcDkWOBek9kypIwQkpCYIeFia+9qdkFicbBCBcEHb90Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HgiVo4+e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738252651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OfIfoDV3TmglxAm7xSDzWNpXN75A+eqXicgT0bWuM1E=;
	b=HgiVo4+ekz5zONbWgIGDT2vWAV7mH9kly2Agsa/PneyHRxZhZXSrVOecYnU0dJSgpeV/7c
	oAwXtwEQ+hpZJ/sOqoJwnkroWyLe1pnE79xT9Rfous26R9qxbjSnEpvvD2j3C3tD/MIWO3
	rf5EZURVRco1iReSY+Ndi+UeuToMC5E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-5S4PlXh3N5aVvzbi1kAsyg-1; Thu, 30 Jan 2025 10:57:29 -0500
X-MC-Unique: 5S4PlXh3N5aVvzbi1kAsyg-1
X-Mimecast-MFC-AGG-ID: 5S4PlXh3N5aVvzbi1kAsyg
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4362153dcd6so4940705e9.2
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 07:57:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738252648; x=1738857448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfIfoDV3TmglxAm7xSDzWNpXN75A+eqXicgT0bWuM1E=;
        b=vmlyYblw0F+vOtZ2TwGt8Y1tbtZukp+Gwhj63R+SK0ddkm7BZcbkDdAtALNzL/1gJb
         r2x3bw7urWc44uLn8K2/G/8GlI5tfZMR/ucWwN34JLbr0DqVjaskGFY6o3F/uaGwIlYF
         zt193OxTqexpo9t4adZEOCizxuVLlq1oZhYvKHKFA8e2m1fNIevtSREWhLsFID8vTh3s
         8HVWCfAt2FFv1HaO6N9Pe9IZzasuies+m4uMhfx20ZWR7JVabzpdh2Rf1PIMhxoUfEwr
         haO6BpAkW6jrw1n983teicPDlsQ5LKwfiz8EdWKftcSYazcJn9nh/Chu+s//C8WYlD1i
         owbQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4ik4tVDCRr/JPQxfVOTRnjg/nX7t2NMFMp8JKBF/Ri/zIcu+r1BfElnnL/FOFt5G4aKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpNAtsESfRRljhX4VZEWmmRvn1aqo8O+pQvhTgI1vLWckzp0kA
	Ay6lnVO6ijKX7pocV2o2SzrVZlpyIQ5aXo30u/YVW+bNmsEG3lhR6HpB0WshhL0/60ctH7Ktbld
	CIblcsUQQ7dTckWcVJn5RK+z8HILXGZS0iseH0qG1fI7ezE4UIw==
X-Gm-Gg: ASbGncvH8M9uKg47znIR/3zLzqQFV/GOSmfTM4HY6CMlk73VAyPmg2+vdiMla/p8chA
	8jNWD5WzgkMP7mim3gpYVxMRWIIJfcg76z/OBdjbm2KMkrqUSmRBP01k/iwypcqaXHLeCTuL4/9
	+zApDBP8CK1CqFnm58ihP5o5tR44NzFgahhSBfI2ON8IHiFcuKwACBAwA0gnzffRdnvuxWbbKMF
	Mpk+ahDuA/8JDn2F5kl1VYrMV7aGd0bAdrAyyrdGyB2h7DGOLN916zVGsPcQ9f2QAN9i4dBJTB2
X-Received: by 2002:a05:600c:198b:b0:434:a468:4a57 with SMTP id 5b1f17b1804b1-438dc428740mr61154875e9.26.1738252648697;
        Thu, 30 Jan 2025 07:57:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpsduzY13GpiVBA+ILTsmN21ZsHEQqq7w157Dzff267xbbLPcjTMCqC0hm/7ck3TRq9eaZoA==
X-Received: by 2002:a05:600c:198b:b0:434:a468:4a57 with SMTP id 5b1f17b1804b1-438dc428740mr61154675e9.26.1738252648348;
        Thu, 30 Jan 2025 07:57:28 -0800 (PST)
Received: from redhat.com ([2a0d:6fc7:25e:64cf:ae20:59ee:ed31:b415])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e244ef41sm27952285e9.32.2025.01.30.07.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2025 07:57:27 -0800 (PST)
Date: Thu, 30 Jan 2025 10:57:19 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Israel Rukshin <israelr@nvidia.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Parav Pandit <parav@nvidia.com>,
	virtualization@lists.linux.dev,
	Linux-block <linux-block@vger.kernel.org>,
	Nitzan Carmi <nitzanc@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_blk: Add support for transport error recovery
Message-ID: <20250130105700-mutt-send-email-mst@kernel.org>
References: <1732690652-3065-1-git-send-email-israelr@nvidia.com>
 <1732690652-3065-3-git-send-email-israelr@nvidia.com>
 <20250130154837.GB223554@fedora>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250130154837.GB223554@fedora>

On Thu, Jan 30, 2025 at 10:48:37AM -0500, Stefan Hajnoczi wrote:
> On Wed, Nov 27, 2024 at 08:57:32AM +0200, Israel Rukshin wrote:
> > Add support for proper cleanup and re-initialization of virtio-blk devices
> > during transport reset error recovery flow.
> > This enhancement includes:
> > - Pre-reset handler (reset_prepare) to perform device-specific cleanup
> > - Post-reset handler (reset_done) to re-initialize the device
> > 
> > These changes allow the device to recover from various reset scenarios,
> > ensuring proper functionality after a reset event occurs.
> > Without this implementation, the device cannot properly recover from
> > resets, potentially leading to undefined behavior or device malfunction.
> > 
> > This feature has been tested using PCI transport with Function Level
> > Reset (FLR) as an example reset mechanism. The reset can be triggered
> > manually via sysfs (echo 1 > /sys/bus/pci/devices/$PCI_ADDR/reset).
> > 
> > Signed-off-by: Israel Rukshin <israelr@nvidia.com>
> > Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > ---
> >  drivers/block/virtio_blk.c | 28 +++++++++++++++++++++++++---
> >  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

Sorry this is in Linus' tree, I can not attach your ack.



