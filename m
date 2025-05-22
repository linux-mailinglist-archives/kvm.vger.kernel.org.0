Return-Path: <kvm+bounces-47393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 021AEAC12AD
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99EF416BF11
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892091991BF;
	Thu, 22 May 2025 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKVqY05x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B7C1EA84
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747936360; cv=none; b=pCTLZiZIuLswH5RwZty5UXtfyTYU19YvTXdBwcaJgok6Wf6NEFWIBzRC+KjpoA3iw0+wRtlKJ2sxI7VWMmCwJUaUZsiv6l1TcPTo6v5RS1yAAY89Wmoa+MoLsVWmbClikZrkBWD9MrI9as8xUC7DqOuBw3gl68IsF2YANIJcb34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747936360; c=relaxed/simple;
	bh=33shT5yeyG4GlN8jGmN8cxW02rgQnzlcfRYf0PWvCkY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5VR2ehsSV9/cIDCBOwWH570y5QXd9r9a1CY6Ho+3a81nzLnG95S6rmkV19/4OIVUpiFbG1gqlbovlXLFuEhxZVXueYgxYUEXdRXYA7yMLbhyd4aF1jRUYPsAWVzjmhaR9Y0yHI3z0sJ+DyN1A3lMgmsXsxktCAtp8pYpiWG5gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKVqY05x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747936357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qCFC7svM4JZpb/vXhsBX/8srNOTogK7PWQN0WLRIUJo=;
	b=PKVqY05x9DEwwEgtfUifnwdZpltqC5ZX83TI9u0eH8DY4nvLFvBbIf9mx3hPKm6cxICp8r
	knxbIcy6HZsBSQawNbKlOP97D5wrdc841dtXcgggkXg8bxXdObIPdKXBzbaapRn0J39guB
	54Zz80l/f/d7ajNJQRRJ7cbVRFtu1Xw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-7-15UOdZPVaj6JWdlWcuVw-1; Thu, 22 May 2025 13:52:36 -0400
X-MC-Unique: 7-15UOdZPVaj6JWdlWcuVw-1
X-Mimecast-MFC-AGG-ID: 7-15UOdZPVaj6JWdlWcuVw_1747936355
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-86cab5d8ccaso10159739f.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 10:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747936355; x=1748541155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qCFC7svM4JZpb/vXhsBX/8srNOTogK7PWQN0WLRIUJo=;
        b=ku81cHynQWZSGPPQUdiLPonaxNJ++eu98Lc/vgdZpjS7fzyZdrzICzzun8jyk26/+C
         6TpKy4ban03yvYZyzMT0CTtj279GBxtDXjplVVxe7ZAuAyUIAo4IcW7/fcU07lsPQGQA
         7uSQ+GsnceSmEYkRgK4hrMUKhbAD/11wpkZSW1lXejH9PCzbHJYTLqYgjfihJJoAvjJR
         7YUjcpFcTON51CcALagrRLQM6E4mfMFTIPdOD28eeseSI6QFltJ0ju/84NcahTSSt24f
         NiOQzZs65el6AkA7lfjtPRT/pPRIMIUm4wPYchnNoKIXOH04lI1dIeh8vIVeZ78NVMLd
         srDw==
X-Forwarded-Encrypted: i=1; AJvYcCUy0CH7FEev8RK4VnmtT7LgHtUTDHs+9QNS/klTtN3/Q2R4mp+//gbW137TOXOx+Zr2AK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxriHsCbrxC4G9tyKPmES1zXZ+7dTOftYQiEJZ4lx3S1tHbUZT9
	imt91XNcCYLLs9NuDbmauCvWUegrR/063dBtymI9fdoIbWrxGnY7e1wzJh0Kdm0MsHpz3lHCUfB
	6vPdoZ/x2T4ibTdEUvc65S5nRMjJvK5V8VZgDAbk9xzoMiLkM1rvDCw==
X-Gm-Gg: ASbGncvZEhuzjiYd+2nBlHsoUL4fQDxQcd2uPhf8C3oFMXBRkVIKRoIQpAj+iiYLMgT
	6Uz5D2GqwwUIPIzBWXllQdrj4wVSrAdq7cJypTifJXXvW9EkZoq/nM9y41xRGPHAO+IcjMCOLJ+
	H71NPMKpu3vu8+S1jLG7VWb33vHEuCesIl1IxbjtZZoFcSDgmWv9rJQAbvMcvOq6ylBe4zRMGLY
	GUTQ252zad0GOrcDDhTIRhKZN+1G+MJWh/SbU1YmUfGZVwwEr8pVjKcuMGAIGuQMq6iw4rh+BNI
	cL785ObAXwS5j0Y=
X-Received: by 2002:a05:6e02:4901:b0:3dc:8075:ccc4 with SMTP id e9e14a558f8ab-3dc8085148cmr26949195ab.3.1747936355326;
        Thu, 22 May 2025 10:52:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXoXfZvws0L1W7xZChiVtBXB0ueiTvpjJifRiy6I6C2ZywtlKUHJyc9rf8zT1q87w+pM5CSw==
X-Received: by 2002:a05:6e02:4901:b0:3dc:8075:ccc4 with SMTP id e9e14a558f8ab-3dc8085148cmr26949045ab.3.1747936354959;
        Thu, 22 May 2025 10:52:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc89bfeebfsm7228115ab.68.2025.05.22.10.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 10:52:33 -0700 (PDT)
Date: Thu, 22 May 2025 11:52:31 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: "kwankhede@nvidia.com" <kwankhede@nvidia.com>, "yan.y.zhao@intel.com"
 <yan.y.zhao@intel.com>, "cjia@nvidia.com" <cjia@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [????] Re: [PATCH] vfio/type1: fixed rollback in
 vfio_dma_bitmap_alloc_all()
Message-ID: <20250522115231.729dad0c.alex.williamson@redhat.com>
In-Reply-To: <64e1bbd6b7e94aa0b5bc4556d5d335a6@baidu.com>
References: <20250521034647.2877-1-lirongqing@baidu.com>
	<20250521140034.35648fde.alex.williamson@redhat.com>
	<64e1bbd6b7e94aa0b5bc4556d5d335a6@baidu.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 May 2025 01:53:48 +0000
"Li,Rongqing" <lirongqing@baidu.com> wrote:

> >     vfio/type1: Fix error unwind in migration dirty bitmap allocation
> > 
> >     When setting up dirty page tracking at the vfio IOMMU backend for
> >     device migration, if an error is encountered allocating a tracking
> >     bitmap, the unwind loop fails to free previously allocated tracking
> >     bitmaps.  This occurs because the wrong loop index is used to
> >     generate the tracking object.  This results in unintended memory
> >     usage for the life of the current DMA mappings where bitmaps were
> >     successfully allocated.
> > 
> >     Use the correct loop index to derive the tracking object for
> >     freeing during unwind.
> >   
> 
> Your changelog is extremely detailed and highly accurate.
> 
> Please directly incorporate this patch with your changelog

Applied to vfio next branch for v6.16 with updated changelog.  Thanks,

Alex


