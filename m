Return-Path: <kvm+bounces-15347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 833F58AB3AF
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 402EC286906
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D04213CFB8;
	Fri, 19 Apr 2024 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BW406ytp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B3D13B5A1
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713545272; cv=none; b=LN+k7GTjARX2Kous8ZaQJXL58g5FmotR2f6K9dAr7DYhlnj2w8ljXSCIvWf0I/Pgy7jTwfVNLfGO53oh30xiY4FPSD/ACOjm3Qoow1N4PA6g2glCk9jzRRUZnTm8wpBGnFfeZAeRoVKn34naBPFk0RM2jiy2orZPBPcvPvZziC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713545272; c=relaxed/simple;
	bh=T02q1rb4rsBReuQXcflU1n69DpjcnWDg8hoiph/WLoA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qb+t4a6AdlHEIAropTO1UlSnOv+BoNDBr1S++tQnPbyNybif2XUpi/RhhuQgx6GyB5UxEG1acfze0I/yAkRr5ZyZuGpEBRiM+3oI/3vhxyhqWKtYn+lREVg6pwF7iJ81E5PiUS+ZNE6Y6atuQZVBmvRuxKHd3OL3SFwRynHi3g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BW406ytp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713545269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RodqwT5IeuGNfIZiWO2QXlPoIuB+k2ixWxyrvN6drLQ=;
	b=BW406ytpQWIYhNpnTJTrRIcTDgzBdUm8U4H2JYGJvznAGmUvWCsFTTrDLwW9LIM5mo1jga
	mKRH2kyM4f3u/trpidjpxaoh78vT7jyFq3g7l5aofO+FhgQF8UZlr6DWOK03gIi4gMfbv6
	x5gBo7zsqRisiffM1bJqlVlf4ow/b3M=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-wQUiQN63NRaxqfrkizVXpA-1; Fri, 19 Apr 2024 12:47:48 -0400
X-MC-Unique: wQUiQN63NRaxqfrkizVXpA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7cc764c885bso305601039f.3
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713545267; x=1714150067;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RodqwT5IeuGNfIZiWO2QXlPoIuB+k2ixWxyrvN6drLQ=;
        b=bH2IGhRQPT/iuFYOF+gzmU/DtplymaVPRLNY0O+pQXGPWKPqzdAGf1n9ff59gR5cBW
         XZkJCOqj9dP1rSuIvP+XNhPpOUiypPrg4hKlEiLcUe3uBTGFVjUt8GTBfBCof/g68nNF
         mlW5Fvyb3+TBajBKpqH1xj/WSvX6fdhzfGny3iPsWbDUR3lZcZ4MbBaCnbsjcQldrb9b
         e7eiDhIdgKuj84NVLdCAfh0cRVUsY8XsZwdl27tj6OFs6Y0IZrSbqyxDbBUCnofZlOq+
         x8JPKj4iS8yJWveHSHbTk1D8DYYbFsT5slwo2Fit6hEfbz8U+xL0hK8MSWrsrJyEO8eJ
         g+eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTLSvEYRnHeNnn0sAGb/Bs6S6j2IaByx75Y1uZn52cd2K2rwuug+0tjTNcjQH6QT5woQ1bEhA3zuqinTewM5zRdzHQ
X-Gm-Message-State: AOJu0YwHaFEI/C37hsotY/h2PmuK90rZTbSNOBLo7R0WglY1kVTqjTuc
	oGEbHUqDBQtWNS2yF1DdkWhUB5dTN/npGrbQ8Aa3udqCRLXrXqSTpdVY5j4+g7EjPBKX2hqOy6L
	l4BZp69Z/vUqK5bHOlOsoV3wdYPoja8pZe5BFsQ7GBF9XVBFbxg==
X-Received: by 2002:a05:6602:4fc1:b0:7da:19a5:625a with SMTP id gs1-20020a0566024fc100b007da19a5625amr2754792iob.21.1713545267431;
        Fri, 19 Apr 2024 09:47:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGghQ9Ch+rGJ+S9P4TDh5J127Ym3OX7IdSCqtYp36nRCCasOaS18mX+MmALWdBucddy6VSbYw==
X-Received: by 2002:a05:6602:4fc1:b0:7da:19a5:625a with SMTP id gs1-20020a0566024fc100b007da19a5625amr2754776iob.21.1713545267098;
        Fri, 19 Apr 2024 09:47:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id fb15-20020a0566023f8f00b007d6905cc017sm997636iob.4.2024.04.19.09.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:47:46 -0700 (PDT)
Date: Fri, 19 Apr 2024 10:47:45 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>, Gerd Bayer
 <gbayer@linux.ibm.com>, Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas
 <yishaih@nvidia.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Halil Pasic <pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>
Subject: Re: [PATCH] vfio/pci: Support 8-byte PCI loads and stores
Message-ID: <20240419104745.01ebb96f.alex.williamson@redhat.com>
In-Reply-To: <20240419161135.GF223006@ziepe.ca>
References: <20240419135323.1282064-1-gbayer@linux.ibm.com>
	<20240419135823.GE223006@ziepe.ca>
	<c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com>
	<20240419161135.GF223006@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 Apr 2024 13:11:35 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Apr 19, 2024 at 05:57:52PM +0200, Niklas Schnelle wrote:
> > On Fri, 2024-04-19 at 10:58 -0300, Jason Gunthorpe wrote:  
> > > On Fri, Apr 19, 2024 at 03:53:23PM +0200, Gerd Bayer wrote:  
> > > > From: Ben Segal <bpsegal@us.ibm.com>
> > > > 
> > > > Many PCI adapters can benefit or even require full 64bit read
> > > > and write access to their registers. In order to enable work on
> > > > user-space drivers for these devices add two new variations
> > > > vfio_pci_core_io{read|write}64 of the existing access methods
> > > > when the architecture supports 64-bit ioreads and iowrites.
> > > > 
> > > > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > > > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > > ---
> > > > 
> > > > Hi all,
> > > > 
> > > > we've successfully used this patch with a user-mode driver for a PCI
> > > > device that requires 64bit register read/writes on s390.  
> > > 
> > > But why? S390 already has a system call for userspace to do the 64 bit
> > > write, and newer S390 has a userspace instruction to do it.
> > > 
> > > Why would you want to use a VFIO system call on the mmio emulation
> > > path?
> > > 
> > > mmap the registers and access them normally?  
> > 
> > It's a very good point and digging into why this wasn't used by
> > Benjamin. It turns out VFIO_PCI_MMAP is disabled for S390 which it
> > really shouldn't be especially now that we have the user-space
> > instructions. Before that though Benjamin turned to this interface
> > which then lead him to this limitation. So yeah we'll definitely verify
> > that it also works via VFIO_PCI_MMAP and send a patch to enable that.  
> 
> Make sense to me!
> 
> > That said I still think it's odd not to have the 8 byte case working
> > here even if it isn't the right approach. Could still be useful for
> > debug/testing without having to add the MIO instructions or the our
> > special syscall.  
> 
> Yes, this also makes sense, but this patch needs some adjusting

Yes, I think so too, falling back to 4-byte accesses of course if
8-byte is not available.  Thanks,

Alex


