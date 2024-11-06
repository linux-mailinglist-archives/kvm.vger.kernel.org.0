Return-Path: <kvm+bounces-31019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC499BF4F7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:15:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16ED91F2118F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFC8208204;
	Wed,  6 Nov 2024 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hCljLs9y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51D1205E2C
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730916893; cv=none; b=eouo35D2UKVUlZIWSoJ0q+31AK9L8Ol/cEsnxFpuOlKABho5D8PLPYx1IyclTnMGN5QNao5u0x9Lkfpqv63PtW6P089YH5qpSVrpeaX6v109N4YyFo+guP+ths3uqDXO9I4lsnvqafetfsZKdcIYa/L6qFOcbgAdUFx57XA/JS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730916893; c=relaxed/simple;
	bh=4J3FXXfZ6nQRphlmnavG6lROM8RB4aH97LZS7b1szkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZS97m95XDSR/2hEDXeE5eeZSVPFNljA5eW1b8AHnyvzxYVC1HuKF7Vygp8LCS8slboE2n9CQ6mFIrMhD2k5iAk3WtnSdficmpafngcd1CyxxQ8z0MlkFUk5HVZG02++fx7DKCCsCmbutaaHySOp3FfgMJAogLBkrX/s5zwQ88eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hCljLs9y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730916890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7pozyU9gF5mzD8wf/N0qDNO8ekR6qCHOutnWukzEkFk=;
	b=hCljLs9yazJ+DNQOdx5VwWBrcRzMVRgoT0KDGfdjlAVtSSXcObhc0yXap6obFLE9vj8bO1
	wXSE7PbTFUMzs56c10nFWefK2HjnP0gCc2/ZszefJ6TlkWiGGd2qtqbIW7tLJUXUthKMg3
	SSHshpUkRRwxU3pPt72MDL3e8KZJvq4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-ltjb-Uy1OMmaTwbwnyGUOQ-1; Wed, 06 Nov 2024 13:14:49 -0500
X-MC-Unique: ltjb-Uy1OMmaTwbwnyGUOQ-1
X-Mimecast-MFC-AGG-ID: ltjb-Uy1OMmaTwbwnyGUOQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d432f9f5eso22112f8f.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 10:14:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730916888; x=1731521688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pozyU9gF5mzD8wf/N0qDNO8ekR6qCHOutnWukzEkFk=;
        b=XrzwYqQRy48xgIF5b1Ael5wQwgSWmEpJ/SEATGIUVrkMdasgbAReWuJaNaTJIDo+IQ
         z4d/I1n+lemcM4VbAtfmtCCRr9HH7kNAfpY1QaFvLaXshz0x6wwrKQGfVGr0GhH8odDs
         5SXHmymSBPKWzy3nkndNvcT/7Atwzs4TF6cWCLKue50rqSR1P0Lo354MFzCjH05cX/S4
         zB+EcabPguYULJDq13LwWRfNLhQYSilvf+B19C8DJiLh3bY3Qm9HnNZbJCFpA9jrhL5s
         YrYmUbbbgb7QymfE3t2GRlmXJU/6LHS8zTah7mAJGLStCBuM81ZG7GKga1D1JZLynb8S
         fYrg==
X-Forwarded-Encrypted: i=1; AJvYcCX3RNh5AC6GdONF7jsefCCq40BH81h1yTyedo12ylb5VV4sA/RhKeRfSz2q3DPhu+PG9+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBnTgV82QDU6SjT0C6vBmsl2P05Hyp0Iv8n0m+kp2znp91AZ+o
	oJlVjPcp7zFkcJPlPqjaqX97oPwG8GaIgZHj7weFdjqGd5Owf9R9APCT1VDO4Klf9KdqBK7I6Pz
	HZwbElCyPFe3FbvUIjXLRbc3xGHkbYKdEisBQOsjPp0CvTaisMg==
X-Received: by 2002:a05:6000:d0f:b0:378:e8a9:98c5 with SMTP id ffacd0b85a97d-381b708b566mr19045065f8f.34.1730916888024;
        Wed, 06 Nov 2024 10:14:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJ+fzLkoD9tpZWIBitUfh2EDEyD/DqLzoVcDBBUPvDl4NX6tSaiyBPx7Xn713AJSHDZNXOUg==
X-Received: by 2002:a05:6000:d0f:b0:378:e8a9:98c5 with SMTP id ffacd0b85a97d-381b708b566mr19045048f8f.34.1730916887666;
        Wed, 06 Nov 2024 10:14:47 -0800 (PST)
Received: from redhat.com ([2a02:14f:179:39a6:9751:f8aa:307a:2952])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c113e6b5sm20135841f8f.88.2024.11.06.10.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 10:14:46 -0800 (PST)
Date: Wed, 6 Nov 2024 13:14:41 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Srujana Challa <schalla@marvell.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <20241106131351-mutt-send-email-mst@kernel.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
 <ZxCrqPPbidzZb6w1@infradead.org>
 <20241019201059-mutt-send-email-mst@kernel.org>
 <ZxieizC7zeS7zyrd@infradead.org>
 <20241023041739-mutt-send-email-mst@kernel.org>
 <ZxoN57kleWecXejY@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxoN57kleWecXejY@infradead.org>

On Thu, Oct 24, 2024 at 02:05:43AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 23, 2024 at 04:19:02AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Oct 22, 2024 at 11:58:19PM -0700, Christoph Hellwig wrote:
> > > On Sat, Oct 19, 2024 at 08:16:44PM -0400, Michael S. Tsirkin wrote:
> > > > Because people want to move from some vendor specific solution with vfio
> > > > to a standard vdpa compatible one with vdpa.
> > > 
> > > So now you have a want for new use cases and you turn that into a must
> > > for supporting completely insecure and dangerous crap.
> > 
> > Nope.
> > 
> > kernel is tainted -> unsupported
> > 
> > whoever supports tainted kernels is already in dangerous waters.
> 
> That's not a carte blanche for doing whatever crazy stuff you
> want.
> 
> And if you don't trust me I'll add Greg who has a very clear opinion
> on IOMMU-bypassing user I/O hooks in the style of the uio driver as
> well I think :)

As a supporter of one of uio drivers, I agree with him.

-- 
MST


