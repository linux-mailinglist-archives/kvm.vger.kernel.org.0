Return-Path: <kvm+bounces-58618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97459B9895A
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 09:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2D9319C71F6
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 07:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C4527FD7D;
	Wed, 24 Sep 2025 07:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eodvDCe3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D807E7262E
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 07:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758699731; cv=none; b=tTN7qlkF4TV2YP75/qo98D0HouQ0YTliMkzz1ebDnsrY3JGMetjMF4OHlUFnXqM1b/iOJBkrpOm6vy+wzi3hkpAH13od3BhTJsYlieB9KNzOVbL2e5YkrzNMdNtmIckDksorxDNxtUtGsmNNRU83uPFZ4jMwRvgCIjcheeQVRB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758699731; c=relaxed/simple;
	bh=s22C2XkvtqXbgWCggQzklD/42otLP53lpOCy5Alg7+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPupipQjjCI3VHsHabR/bvcZLd0u8YgM/1K3XtPkNzdhdMmmv6M0DHAEeogZ7WqpJwE1stj6yEWvFgKTwEbwHN6W0PHqFVo/j50eo1qNW7HoolVYafU+t4xQP0ABvHADw02unFqMzMwivRG69TlebKskw09xzmDeLkjQNUr8i5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eodvDCe3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758699728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8iP4CgsS/C0dxL3gWclMrWG9rP/QiQu1MTT4mBV3Urc=;
	b=eodvDCe3wQLHNVbgp2a0Qm8VGCvVUSto7LSBq3jhrNf5MgvyLnWwAYyNDOdK7SDqRJDqu2
	l1Mku4Jw/L3PMiLqV8xV3etxd5Oti80X1UfIhdQIFLIFBOjUIZ37ePPqGTRn86FnsV83ql
	bKE/+23tAopzBg0RmUVTDjZcq+6ywEY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-lAAqPUn5NBmJytRlig23TA-1; Wed, 24 Sep 2025 03:42:01 -0400
X-MC-Unique: lAAqPUn5NBmJytRlig23TA-1
X-Mimecast-MFC-AGG-ID: lAAqPUn5NBmJytRlig23TA_1758699720
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46dfd711001so19738185e9.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 00:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758699720; x=1759304520;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8iP4CgsS/C0dxL3gWclMrWG9rP/QiQu1MTT4mBV3Urc=;
        b=SPSXT3gOCAjYpMr+FXnm1U1Wk90v4AV2Uz9CDRexCKz/IaLJx9tfFZKv2mZzcrObyl
         gj1sXc0aNdwoGnDiAC78ZiQgbZo8FVIJW+k0E6n0qJThq+PY031R+5ICvNodx3mif3+d
         iq8kwYTBr5YRu8Ji3nRYyrdqaegRuL9Ws3F6TW5g4KPUzXyU8hzVS+a6KD0kPQZQtDce
         5qgb3ZUhJ0mDGFd3/OpTApePCTCuPCDFAIlMk38k/0ZpBbgK9iKp6YtkBtXiuX8nzf6Q
         xeKDdQvJbdnlEKfBSV9uOvO1mVVD3HRZrjNH4e7RoMCupoX6uzghKTOM4JehnOSSi3QW
         kVcw==
X-Forwarded-Encrypted: i=1; AJvYcCXPdmc+YJRr3fJB+b6IrX1/75jFAnXHsXRi87sPw4DRfYoQX1omBqxN5TznKUHOCe6qWwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwquwvGEblqOGtT9eHpmFFKa/8DzrAIj1QgXEKtXSbJq31u/UQH
	EtflCuK3QG5ZElb+y4m/8q0IidLvbACoFXgj/yNpUmf8kZMS3PNZh3V/aCAu5r+4/OLVww6nMnl
	JjCIHLIWVtzRnyqqRXzsBHc92N/Hqw2kvUTX+cQG8sNokt/+iAxh24g==
X-Gm-Gg: ASbGncsiwanAJHuLhRgwxVnz36Jz9CkaNxhz8n7ARSEthv5GROYbbN4JzoReJ1nQa8t
	3LJGGEm4FbwHThCvEljsxK+Hy5GqPSMtOeQu40jQQPV5WpjPPKjJuqCO4UZJo35Szeq1rGDcEpx
	GaLLS3mmBUNmpXmHUteIHYqiUciRT8rUs6SMA64bJU3LSn+fTMfL4PUzemNIVL3+dK55i6bCst8
	sIC6xoV1lj7pOZZl6lileNSp9Wh4trlFepJcfeSvtRHHo8gv5BrTJPg+YMFnqWZfg7LHynFyF3f
	A+IgcGz01KrVhNpGwtCSibsAUdbDRoTh9YU=
X-Received: by 2002:a05:600c:3547:b0:46e:1d8d:cfa2 with SMTP id 5b1f17b1804b1-46e1dacf6edmr50676265e9.20.1758699720372;
        Wed, 24 Sep 2025 00:42:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBaH8Qcz+geVHLVmG1y55L66i7iUAa9TF2rE/T5FQj6JWkFbMfTzOEnJtYBSrJWjTl6QSAhw==
X-Received: by 2002:a05:600c:3547:b0:46e:1d8d:cfa2 with SMTP id 5b1f17b1804b1-46e1dacf6edmr50676015e9.20.1758699719977;
        Wed, 24 Sep 2025 00:41:59 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40bd194c0bdsm1287994f8f.61.2025.09.24.00.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 00:41:59 -0700 (PDT)
Date: Wed, 24 Sep 2025 03:41:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
	willemdebruijn.kernel@gmail.com, eperezma@redhat.com,
	stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
Message-ID: <20250924034112-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250924031105-mutt-send-email-mst@kernel.org>
 <CACGkMEuriTgw4+bFPiPU-1ptipt-WKvHdavM53ANwkr=iSvYYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEuriTgw4+bFPiPU-1ptipt-WKvHdavM53ANwkr=iSvYYg@mail.gmail.com>

On Wed, Sep 24, 2025 at 03:33:08PM +0800, Jason Wang wrote:
> On Wed, Sep 24, 2025 at 3:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
> > > This patch series deals with TUN, TAP and vhost_net which drop incoming
> > > SKBs whenever their internal ptr_ring buffer is full. Instead, with this
> > > patch series, the associated netdev queue is stopped before this happens.
> > > This allows the connected qdisc to function correctly as reported by [1]
> > > and improves application-layer performance, see our paper [2]. Meanwhile
> > > the theoretical performance differs only slightly:
> >
> >
> > About this whole approach.
> > What if userspace is not consuming packets?
> > Won't the watchdog warnings appear?
> > Is it safe to allow userspace to block a tx queue
> > indefinitely?
> 
> I think it's safe as it's a userspace device, there's no way to
> guarantee the userspace can process the packet in time (so no watchdog
> for TUN).
> 
> Thanks

Hmm. Anyway, I guess if we ever want to enable timeout for tun,
we can worry about it then. Does not need to block this patchset.

> >
> > --
> > MST
> >


