Return-Path: <kvm+bounces-24153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D242951DD1
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5E432845C1
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209481B4C21;
	Wed, 14 Aug 2024 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJ8xBrik"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D735C1B3F02
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723647312; cv=none; b=igO25Z5an9YSEI0I22cYu7WP23nryygj41f5l0r2gRSqRuX7fJqwYFzNHQzsEweQXZhFeJqwrEMT/fLanLHJNFuGd8Orsew1w3lWICOos5RP/RvHxtAVWVwknxLDGBo++NvuOQNcGacZcpZ0m3T7R18kHtrn5UVeu6vtvugVG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723647312; c=relaxed/simple;
	bh=WoccYl5tJ4uS73R5zSqJbENwLN3ciC51K4xWuQmtihA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dCQF+sFYN8Nmahyfe3l5fc6hhEGsPw5xDNN03HxQH8XxznTBjHAygjfHc7eVUSXhafkvsfrYPGfp5gYGE4FzQn8AYuHmi22cI8oR+3PqzQNvkr36e06i2FKOSCUcW98LhZkKLIvab9v8Vcnv78vR1IfjYWgUnHNhJdBvZYuJBGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJ8xBrik; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723647309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oPm3R6PblHeNKQdvTaJGKrEzfWm2oR4v27v3xkNgebw=;
	b=aJ8xBrikto+YSH+2J5Sb/9wMQ/74XEcwJk1JW1Ogb2864/1M7TuQqkJ2L9mjuQleMO66BE
	1FDwPQ5It0voQVd6CGPUw3zBMHqLeSQhZmcv3Cipi4qEe+llh1sdWg91eR/IW9Xu89WVrE
	ZKOo6xWegCSTbkTkrwGR33hFLS9A1qI=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-HSEm8Q_MNXG5xpdmKi814g-1; Wed, 14 Aug 2024 10:55:08 -0400
X-MC-Unique: HSEm8Q_MNXG5xpdmKi814g-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81fb21a0e41so759339f.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723647308; x=1724252108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPm3R6PblHeNKQdvTaJGKrEzfWm2oR4v27v3xkNgebw=;
        b=ojNm3MzaxdqTo/vkLV8ouE7XIdsZnyKfB8b5jUkK++TpNUplDcgNJ0VPfzDPeiD7xf
         rOYplP1j56gJf9mIOvbFo+VHr7e9f7IQntsUU4cY6czJbtT6kIbbAqezTTX/ZdET6O4L
         bmekJj5y2HeH+Knv0hzgBFXY3wWlhiSWPplZiyWsUbOQujt7rs4PkVqb570cJgHGij8Y
         BmC9znbW8At7hYMoyWKXMpGnM9oxGSxPPEQvTboiJZ0rWGxLNjPyXcLWD6+okt4Y7ACi
         XKUgaLhvg3BZX6WfBk1TJVJ5S1/dLXkiw5ybcazArFHqA4fZVhfno0FvFy33oEr4yYu0
         CLIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBcsVV74PicO7VMglkF6lTjHd/TsTB19swOdhiDaeXo+Aurk/sStSkkyUioJ9pIDCFJJ5jbt5mmxxoH9YTtRLct3Cf
X-Gm-Message-State: AOJu0YwpttExAv7mQYOVT52qAZF9s0dtBRlLqsg67GFjLcl2+uROOZIO
	bkXrC1oI37KjWD0+4aAuK04pZS2SxUVLGX6dQ5Dtz2ppj/exrkJCy7ptvG6KkV08xWu8orSdURI
	RFwUNBlBPLS9ouvg9YcQkJhb6MgXHiuvacZtquPIR8GozkZcGFw==
X-Received: by 2002:a05:6602:4c8a:b0:7f9:b435:4f5 with SMTP id ca18e2360f4ac-824dae79033mr337940939f.11.1723647307733;
        Wed, 14 Aug 2024 07:55:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKOB2u3ExmlngG/ZGX6m16GkR9QFQMCyYiDK1GqVIcqqNhWRQ6U/pFLSxgUSO2c6mZ3lkevw==
X-Received: by 2002:a05:6602:4c8a:b0:7f9:b435:4f5 with SMTP id ca18e2360f4ac-824dae79033mr337937239f.11.1723647307328;
        Wed, 14 Aug 2024 07:55:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ca769102a4sm3274045173.18.2024.08.14.07.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 07:55:06 -0700 (PDT)
Date: Wed, 14 Aug 2024 08:55:05 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
 quic_bqiang@quicinc.com, kvalo@kernel.org, prestwoj@gmail.com,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 dwmw2@infradead.org, iommu@lists.linux.dev, kernel@quicinc.com,
 johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci: Create feature to disable MSI
 virtualization
Message-ID: <20240814085505.60819623.alex.williamson@redhat.com>
In-Reply-To: <20240813231642.GR1985367@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
	<20240812170014.1583783-1-alex.williamson@redhat.com>
	<20240813163053.GK1985367@ziepe.ca>
	<20240813151401.789c578f.alex.williamson@redhat.com>
	<20240813231642.GR1985367@ziepe.ca>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Aug 2024 20:16:42 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Aug 13, 2024 at 03:14:01PM -0600, Alex Williamson wrote:
> 
> > > Personally, I very much dislike this. Encouraging such hacky driver
> > > use of the interrupt subsystem is not a good direction. Enabling this
> > > in VMs will further complicate fixing the IRQ usages in these drivers
> > > over the long run.  
> > 
> > Clearly these _guest_ drivers are doing this regardless of the
> > interfaces provided by vfio, so I don't see how we're encouraging hacky
> > driver behavior, especially when it comes to Windows guest drivers.  
> 
> Because people will then say the Linux driver can't be fixed to
> properly use an irq_domain/etc as the only option that works in VMs
> will be the hacky copy from MSI-X approach :\

Ironically QEMU already has direct access to the MSI-X vector table in
MMIO space and could implement this type of quirk with no kernel
changes.  It's MSI that is now blocked by virtualization of the address
and data registers.  Note also that QEMU is still virtualizing these
registers, the values seen in the guest are unchanged.  It's only the
VMM that can bypass that virtualization to see the host values.

Let's imagine the guest driver does change to implement an irq_domain.
How does that fundamentally change the problem for the VMM that guest
MSI values are being written to other portions of the device?  The
guest driver can have whatever architecture it wants (we don't know
the architecture of the Windows driver) but we still need to trap
writes of the guest MSI address/data and replace it with host values.

> > > Thomas Gleixner has done alot of great work recently to clean this up.
> > > 
> > > So if you imagine the driver is fixed, then this is not necessary.  
> > 
> > How so?   
> 
> Because if the driver is properly using the new irq_domain/etc
> infrastructure to model its additional interrupt source then this
> patch won't make it work in the VM anyhow, so it is not necessary..
> 
> Your other patch would be the only short term answer.

The QEMU patch relies on this kernel patch in order to be able to
access the host physical MSI address and data values through the vfio
interface.  Otherwise QEMU has no host values with which to patch-up
guest values.  As noted above, this does not provide any visible change
to a QEMU guest, it only enables QEMU to implement the quirk in the
other patch.  Thanks,

Alex


