Return-Path: <kvm+bounces-46493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE94AB6B91
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 14:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0F4F3BF080
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C92277819;
	Wed, 14 May 2025 12:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i9t8gw9/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB1A275866
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747226436; cv=none; b=oAjoaUF3ZEn0BdOQb4FPvjCUmqUIWAlcajQPrVQTm8/lCgoki7NefumKXJ3W2fq8JDRqx+qmikD1AmnwrqfsTBEkr7fxqiGXWo94Uw0VBBT8AdSdDh79vaxXXbFdsmLse3tabElxwMsxhWU+MOD28UWZp0y/2vZOYI77iEP6vS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747226436; c=relaxed/simple;
	bh=l4VZADMEVJnFAQXvFf7wgOzQJUelFDiQAhhzyWvjj6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QobLiJhllrPTS0i6EzdAlZJYb0KNs/fu+NmEe07ReqsN6W3TgZ5FFdYk/IrVqw/GcWSf9AyTZJQ1FIJwjDu+YuwqPhm0flOpIoBDFYUZEzwn+TnSLA6HknlmZ3WE5GRUvTdjzDo3iNQ+SManVFrNEvyRvwBTXsGfCOcak/GuE/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i9t8gw9/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747226432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fw0llZnGO4F7e+OkKHs7xd6962MpvChnUrZgYDDb9I0=;
	b=i9t8gw9/jRIxZUg5E8dQEBfurTXN+hd/ga6gWOO+djgPKwPgiE4MMemQYjXRkoad+dHC3r
	T0uvteG2WjF3OOBmQhYtd6725T+eYviiQoDEFZEBhqZ0ugqMq6RN0EOYrPG5P6ASRIVWcg
	muXr2QYLG8PtQJHo+lLQKtBj2uP7IGQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-a4O7_49OMT2shv-drN94rw-1; Wed, 14 May 2025 08:40:31 -0400
X-MC-Unique: a4O7_49OMT2shv-drN94rw-1
X-Mimecast-MFC-AGG-ID: a4O7_49OMT2shv-drN94rw_1747226430
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a0b394504cso419479f8f.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 05:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747226430; x=1747831230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fw0llZnGO4F7e+OkKHs7xd6962MpvChnUrZgYDDb9I0=;
        b=Dvz9JpmeETITe8GqLGUgKv6YInp7OQlUVI2j8KVyh6V71qaJDVbM5vnunSheCcr6/f
         46wIBMC7/U+FLWJaPxtt6/f05nhUQTAhzTDgwBZNZ5QrVw6jHhs4FTEzTM+pfMSeMFvL
         Bx+aQXWh0Pk1RKPy4R3pJtgCFv3WDa2+VddQUWKCVGrRdkwgW6+yVRKjSyOP8gjp9K75
         j3/q4++1FjJExCu/sdt23+d5+DoGuaycLjz8meLL4bLaBJDY8VVpxIr0Ab27qzvRSllj
         oTmhHiUpPD/XyLYveF+oIeDg8zEzyY0Axgy7c+geteKFe3kWR6i0Pbd4To8Kl+A97RJr
         ZpmQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4SGGJ+1rVpMQ55uZr05JvT3f1DMTL8b85SRXckHkSfLY06hpWUAv0Ht9KIh1ity2dAb8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp4t5dILclrai18jacZukcCedlNcJtb5EpafLLYzoiNbog6ZPM
	V9FAaa8xUJwh1P/TUrVB2LUSHs5u/gjOS2/TGKt8MNMRLYr7/L+WeeqN9GSYd56y5LVU3b2pEUk
	KaqvCovSRu7TtDu/9L/mWqmBWQTg5tyZB7iNavybpnkuolOPzvg==
X-Gm-Gg: ASbGncuBZhCWQ3D+dvOzRMgEYPG8VMJ94ZMZ6xEgdULgK7KGp00OhqEFdVxduryN3qc
	DOLIyDx/gn2yv0zQfZ66poz0ofaRfvNqMjNevs4u3b2N17hPcv6u8IMtHNqA5TYRws6e8iGU/DY
	dQ/3pSvXKO3zPl+yC+o+5KzVNLUWuw0RY8/rbkHENlyh4KYc0lW7M/lwNp7itMjNxGyWuXFWmqx
	NYk9YAqIMRfQSh4xMUj9ynX5h+4NrXmRIulJdpEprQUDpC60v/TvH3NzQtQgWGIeTW+TDlxrrba
	U3Fe6A==
X-Received: by 2002:a5d:5888:0:b0:3a1:f70a:1f65 with SMTP id ffacd0b85a97d-3a348ac78demr3422306f8f.0.1747226430090;
        Wed, 14 May 2025 05:40:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/IcHyOtPZThhQmfsHZwZgx5RVpTsWbFQFnsQ1d9kN5ycuPeVc3HAClS1rLwLne8I1m0Er5A==
X-Received: by 2002:a5d:5888:0:b0:3a1:f70a:1f65 with SMTP id ffacd0b85a97d-3a348ac78demr3422283f8f.0.1747226429725;
        Wed, 14 May 2025 05:40:29 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ebd6asm19922424f8f.35.2025.05.14.05.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 05:40:28 -0700 (PDT)
Date: Wed, 14 May 2025 08:40:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, israelr@nvidia.com,
	virtualization@lists.linux.dev, linux-block@vger.kernel.org,
	oren@nvidia.com, nitzanc@nvidia.com, dbenbasat@nvidia.com,
	smalin@nvidia.com, larora@nvidia.com, izach@nvidia.com,
	aaptel@nvidia.com, parav@nvidia.com, kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/2] virtio: Add length checks for device writable
 portions
Message-ID: <20250514083313-mutt-send-email-mst@kernel.org>
References: <20250224233106.8519-1-mgurtovoy@nvidia.com>
 <20250227081747.GE85709@fedora>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227081747.GE85709@fedora>

On Thu, Feb 27, 2025 at 04:17:47PM +0800, Stefan Hajnoczi wrote:
> On Tue, Feb 25, 2025 at 01:31:04AM +0200, Max Gurtovoy wrote:
> > Hi,
> > 
> > This patch series introduces safety checks in virtio-blk and virtio-fs
> > drivers to ensure proper handling of device-writable buffer lengths as
> > specified by the virtio specification.
> > 
> > The virtio specification states:
> > "The driver MUST NOT make assumptions about data in device-writable
> > buffers beyond the first len bytes, and SHOULD ignore this data."
> > 
> > To align with this requirement, we introduce checks in both drivers to
> > verify that the length of data written by the device is at least as
> > large as the expected/needed payload.
> > 
> > If this condition is not met, we set an I/O error status to prevent
> > processing of potentially invalid or incomplete data.
> > 
> > These changes improve the robustness of the drivers and ensure better
> > compliance with the virtio specification.
> > 
> > Max Gurtovoy (2):
> >   virtio_blk: add length check for device writable portion
> >   virtio_fs: add length check for device writable portion
> > 
> >  drivers/block/virtio_blk.c | 20 ++++++++++++++++++++
> >  fs/fuse/virtio_fs.c        |  9 +++++++++
> >  2 files changed, 29 insertions(+)
> > 
> > -- 
> > 2.18.1
> > 
> 
> There are 3 cases:
> 1. The device reports len correctly.
> 2. The device reports len incorrectly, but the in buffers contain valid
>    data.
> 3. The device reports len incorrectly and the in buffers contain invalid
>    data.
> 
> Case 1 does not change behavior.
> 
> Case 3 never worked in the first place. This patch might produce an
> error now where garbage was returned in the past.
> 
> It's case 2 that I'm worried about: users won't be happy if the driver
> stops working with a device that previously worked.

Interestingly, when virtio core unmaps buffers, it always syncronizes
the whole range.
virtio net jumps through hoops to only sync a part.

So Max, my suggestion is to maybe try a combination of dma sync +
unmap, and then this becomes an optimization.

It might be worth it, for when using swiotlb - but the gain will
have to be measured.





> Should we really risk breakage for little benefit?
> 
> I remember there were cases of invalid len values reported by devices in
> the past. Michael might have thoughts about this.
> 
> Stefan



