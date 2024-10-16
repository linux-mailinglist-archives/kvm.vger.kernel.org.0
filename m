Return-Path: <kvm+bounces-29015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA179A10D8
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 19:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B8C2B2141A
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 17:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CF2212EE7;
	Wed, 16 Oct 2024 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V7zICxVe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3DE210C25
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 17:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729100520; cv=none; b=EW/vAayBa21ajUKS9l5v1Jx5tXFwVCHTg45TVMLwbemZrCnFvkIZovekRuOESvp+cGTlQfBMe9UnqfoU4K0gq9leB1osJPv3TslF9bBtZICtT1Z+MX5mQ8uA2e3ZD3N5N2BzpUbT9yXwYzmDoC75g9PNN+8z31uN6Gsea7qsc2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729100520; c=relaxed/simple;
	bh=zZa2DuJtbeZdTDiPg6nHIyegUjLqhs+ELaawfPSdUmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxBD0UD/QkdwkwI7PrHF6UOnp0H8k7SQ6X566DOA14OWLZBAj2awdlfyCZc0IM96t0Xpota4eNiK2MvtIpKRzu7unGLf4twAgQK3A1QvHm21CrtuAP7N+IZmgexC10klqEAGrLJ/rP+1nUKW8ibeB6YuqInFPK9ZbRxgsGq1OBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V7zICxVe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729100518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/q8VB7z/+Dd2yPKgk6uJSd98F7HmQ0TN0/vUj4F4ARY=;
	b=V7zICxVePekiFPcSxm6tLw2sM65lpfzO2t3HDOUXdcCZjt1Ac/Qgo7eerJEcJXWhiqPrkG
	oy1It1iTNNRJCnz34GJyO+gwnkv+cqBGV2CVuid+O5nWMlc/lEFfay/ubzRJvk8JxwWFfC
	8sBaeOXg1DAfgP/MUcQ0QKM9PDAenwQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-qRczUHFkMv-kTjXaRjVEyw-1; Wed, 16 Oct 2024 13:41:57 -0400
X-MC-Unique: qRczUHFkMv-kTjXaRjVEyw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d4854fa0eso11846f8f.2
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 10:41:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729100516; x=1729705316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/q8VB7z/+Dd2yPKgk6uJSd98F7HmQ0TN0/vUj4F4ARY=;
        b=jcLiU42WQa8rKfBiPPpqrnmPHc90My8Z5karJpU54HChbm+Ywp6uXOzBTDbH3qA7QQ
         G1hpbihO+zkC/C6QBatWhlF4SllGix4MiL+rOoAdFmFYcPM3Zebq5k0s6A2DGmhALZqC
         zPH3jEgCqOqlOu2SU/S9e/QrBU1rJgHYhr3+wn2mKlw2v3VupdgjwhvV8ZFx0aDJg4QR
         qIU1ty3oORr+dTV99CcFON8WR3CP0ruDeK3ugHqs5Xmg+dIyadEY8k4PgWrq+eXSG71R
         +R0Bw5jn3tbU4bRtrbysQiV8mzl77G0xCi9rNgJ/6FeDIbiT/UQQU8IIVTLLngMsXW4B
         N6og==
X-Forwarded-Encrypted: i=1; AJvYcCVkWUe5Mtj0U4oHleCaMwoe/NXMxPLMu3qFC26ZYu20EhuBUduCWAIawXo0Q2Uz2xfhqX0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxaee1CD4t8xr1nB8menRZxQUw6mSyP7lAt+N0Ej4VKt9n3nnUq
	9XqlPLssTagAYwCjfX0lEMgpB5wLClSFLK93XK+p3ZmIEd7eKhW2OKDbmjCz1E/h6+lMVvhV2ol
	mZ/1FtLntsl4DVPp/bmJSL8JUMg9Lj94U3zRLxh+UEOvANeazDg==
X-Received: by 2002:a5d:47c2:0:b0:37d:4e03:ff86 with SMTP id ffacd0b85a97d-37d86d698c7mr3670355f8f.49.1729100515990;
        Wed, 16 Oct 2024 10:41:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5LqH4y7mLhg477ilLXLgpjCf7W76dfje6QpYrJUn7Yqcr3EVNRcTIF4VEtU+n8CArG/mOlg==
X-Received: by 2002:a5d:47c2:0:b0:37d:4e03:ff86 with SMTP id ffacd0b85a97d-37d86d698c7mr3670337f8f.49.1729100515493;
        Wed, 16 Oct 2024 10:41:55 -0700 (PDT)
Received: from redhat.com ([2a02:14f:174:b9f1:592:644a:6aa0:615c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fc411fbsm4836012f8f.107.2024.10.16.10.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 10:41:54 -0700 (PDT)
Date: Wed, 16 Oct 2024 13:41:51 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Srujana Challa <schalla@marvell.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <20241016134127-mutt-send-email-mst@kernel.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3mC3Ej7m0KyZVv@infradead.org>

On Mon, Oct 14, 2024 at 08:48:27PM -0700, Christoph Hellwig wrote:
> On Mon, Oct 14, 2024 at 01:18:01PM +0000, Srujana Challa wrote:
> > > On Fri, Sep 20, 2024 at 07:35:28PM +0530, Srujana Challa wrote:
> > > > This patchset introduces support for an UNSAFE, no-IOMMU mode in the
> > > > vhost-vdpa driver. When enabled, this mode provides no device
> > > > isolation, no DMA translation, no host kernel protection, and cannot
> > > > be used for device assignment to virtual machines. It requires RAWIO
> > > > permissions and will taint the kernel.
> > > >
> > > > This mode requires enabling the
> > > "enable_vhost_vdpa_unsafe_noiommu_mode"
> > > > option on the vhost-vdpa driver and also negotiate the feature flag
> > > > VHOST_BACKEND_F_NOIOMMU. This mode would be useful to get better
> > > > performance on specifice low end machines and can be leveraged by
> > > > embedded platforms where applications run in controlled environment.
> > > 
> > > ... and is completely broken and dangerous.
> > Based on the discussions in this thread https://www.spinics.net/lists/kvm/msg357569.html,
> > we have decided to proceed with this implementation. Could you please share any
> > alternative ideas or suggestions you might have?
> 
> Don't do this.  It is inherently unsafe and dangerous and there is not
> valid reason to implement it.
> 
> Double-Nacked-by: Christoph Hellwig <hch@lst.de>

It's basically because vfio does, so we have to follow suit.

-- 
MST


