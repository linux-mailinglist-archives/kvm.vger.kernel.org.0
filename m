Return-Path: <kvm+bounces-59718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D9FBC955B
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 15:38:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 387AD3B4DAD
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 13:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A0B2E9EA6;
	Thu,  9 Oct 2025 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIB7EKYe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518A12E973D
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 13:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760017054; cv=none; b=l5m4db0kV9FkMrtx+EAm+8rPvFCld6TlRA4rsQcFw5bkT8E6jhRSjVk1HJYNbp2y5sNYHqE/hRRnapmL21yhNBFyjaVY6vLo8Hs8rGPx7z2sMphYswU3SBN3SkkJUHqGAr6Dyjwu+9YZNYuKyatIYheY2g9eArTszX6eR1//GGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760017054; c=relaxed/simple;
	bh=7NdTvvUFK/WVGSYlLXsbwdrwKPNZwb8MV31/iuYNMko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DWC505BfyUzliUFNPjnYirQ5ZdxaczxU99+XrDfz26EU+Khq7b4e+5PpbYkXt2cIEavIV4Oii3BaWQ2pQHVUoLDpiDLIkNyCqKfMOsi3yP1wBv+iV61Isdx571wj3yw8t/7pM+mW532Zy6ooL6qbMonWGHJRWAY2qR4gpQgPnhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IIB7EKYe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760017052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QSnlK9qf9+QtrbFfXzTXGo8du1cPFojIdvhyIWDFaG4=;
	b=IIB7EKYe3fh+SCHFkVLMTEhNDTodZII9+nrQxfsdtZL5DOXDjKywtyU279AvklTNKRTR1T
	arHh4/pNnZS+ilLcyA7WNiEG73IFUUEiU3+jHYosMEtIMxV9sjW2Xcr8h4yceC1OnPACkB
	+YsT6ETMwGZlrL8u2fDSucO/09dx3H4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-dwq2XUwRPR2sx1QVv8s8aQ-1; Thu, 09 Oct 2025 09:37:28 -0400
X-MC-Unique: dwq2XUwRPR2sx1QVv8s8aQ-1
X-Mimecast-MFC-AGG-ID: dwq2XUwRPR2sx1QVv8s8aQ_1760017047
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ddc5a484c9so35494451cf.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 06:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760017047; x=1760621847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSnlK9qf9+QtrbFfXzTXGo8du1cPFojIdvhyIWDFaG4=;
        b=T2gTbj23jB08ndstxF9Vrod/AWoQtxZwOJCB053LPICZhSZbkAR3sjf2Y9XxaSSUCD
         +1ofS2kOgu1yEeRT7D2r4SFJFLs5CFtyN0Hu81djA4OkgbuMnFb+AS5slH4KJFj4FQux
         0trO4Lanb5wQapoA6BQ9U9+eny9bABB99Y2DfjQQ8/an5QKkZp3AHhYVdKnmcAb6Ypzf
         JOU3Olo2VHoxzqiSu9f8+Ly4u+9/9vu4fvh0pxECsaVssknIL8fYkZ2dP9UFktb+mfjJ
         ZGhS1EOdwKKbgJX03cBL5N5DTy9HcF0/vUnmer8oX0CcMTs8jXaG2R5VqPEuMV+g+Q7E
         9X2w==
X-Forwarded-Encrypted: i=1; AJvYcCUwH4Fxl5STWmStRSIzDPpRY4MpgqRO1GcamX1r4UbNiDULKJ+3ypBHgfikZA6ghuISsvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD0PfSlZ/mpouMBfCBgDwjYo2qQT3aXbl1gp4RZjR7kqEhRwRP
	F96n7yu5himDF1QCdosxNgj0Ne7g8MuG+iZZYdA52sqsV3eYf4WMRBtmsZRdHkhafTtoXJ0hVBW
	+Ll/bkEp17dQXdUp1LX1GPD6wVL7f/zCw9iHoyF4UDlWUgaRahImfZw==
X-Gm-Gg: ASbGncvSgq4o/VkofZWs9H63sc2OvKTtJAuj/MrF7Pjo/yG9puHx/Mq7MQ0VDnKFFbc
	Hoeif/aPBhONpFy+coQdb2ZBWilVJnqL1u/Qblzm/piHfpnM8cqUwrqlaAKFcRGwXJknft7byVq
	Y3eC+UkLuwPwjf+X70Fjji4BfYBNBhry41XIGz6S0k+ZW59+lDymEtPnUQPSRcJS/95nzdEqcDL
	OihJ6qhfio4t6BOiiFjwsfUladUytI+RD1jWzovaR3JhboYBeD2YLUOHSU7DouSLn5j3zuUFWal
	LPn+VFXLMUeD/iiQ0Oazqz2DSqB55FuLfi4=
X-Received: by 2002:a05:622a:552:b0:4d3:1b4f:dda1 with SMTP id d75a77b69052e-4e6ead5b74fmr99238161cf.61.1760017046384;
        Thu, 09 Oct 2025 06:37:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkkkln0wvJVfA+/SQdl7KyNaqeghASgRMRgQSZA/6yVrMeWhD/2djQvFf88sK4uQV3LAnLRw==
X-Received: by 2002:a05:622a:552:b0:4d3:1b4f:dda1 with SMTP id d75a77b69052e-4e6ead5b74fmr99237541cf.61.1760017045789;
        Thu, 09 Oct 2025 06:37:25 -0700 (PDT)
Received: from redhat.com ([138.199.52.81])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a2369b3fsm191330185a.51.2025.10.09.06.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 06:37:25 -0700 (PDT)
Date: Thu, 9 Oct 2025 09:37:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: dwords->qwords
Message-ID: <20251009093127-mutt-send-email-mst@kernel.org>
References: <cover.1760008797.git.mst@redhat.com>
 <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>
 <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>

On Thu, Oct 09, 2025 at 02:31:04PM +0200, Andrew Lunn wrote:
> On Thu, Oct 09, 2025 at 07:24:08AM -0400, Michael S. Tsirkin wrote:
> > A "word" is 16 bit. 64 bit integers like virtio uses are not dwords,
> > they are actually qwords.
> 
> I'm having trouble with this....
> 
> This bit makes sense. 4x 16bits = 64 bits.
> 
> > -static const u64 vhost_net_features[VIRTIO_FEATURES_DWORDS] = {
> > +static const u64 vhost_net_features[VIRTIO_FEATURES_QWORDS] = {
> 
> If this was u16, and VIRTIO_FEATURES_QWORDS was 4, which the Q would
> imply, than i would agree with what you are saying. But this is a u64
> type.  It is already a QWORD, and this is an array of two of them.

I don't get what you are saying here.
It's an array of qwords and VIRTIO_FEATURES_QWORDS tells you
how many QWORDS are needed to fit all of them.

This is how C arrays are declared.


> I think the real issue here is not D vs Q, but WORD. We have a default
> meaning of a u16 for a word, especially in C. But that is not the
> actual definition of a word a computer scientist would use. Wikipedia
> has:
> 
>   In computing, a word is any processor design's natural unit of
>   data. A word is a fixed-sized datum handled as a unit by the
>   instruction set or the hardware of the processor.
> 
> A word can be any size. In this context, virtio is not referring to
> the instruction set, but a protocol. Are all fields in this protocol
> u64? Hence word is u64? And this is an array of two words? That would
> make DWORD correct, it is two words.
> 
> If you want to change anything here, i would actually change WORD to
> something else, maybe FIELD?
> 
> And i could be wrong here, i've not looked at the actual protocol, so
> i've no idea if all fields in the protocol are u64. There are
> protocols like this, IPv6 uses u32, not octets, and the length field
> in the headers refer to the number of u32s in the header.
> 
> 	Andrew


Virtio uses "dword" to mean "32 bits" in several places:



device-types/i2c/description.tex:The \field{padding} is used to pad to full dword.

pads to 32 bit


transport-pci.tex:        u8 padding[2];  /* Pad to full dword. */

same




Under pci, the meaning is also generally as I use it here.
E.g.:

Documentation/PCI/pci.rst:You can use `pci_(read|write)_config_(byte|word|dword)` to access the config






-- 
MST


