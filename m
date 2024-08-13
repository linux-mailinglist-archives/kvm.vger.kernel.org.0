Return-Path: <kvm+bounces-24071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CFEE9510A8
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:37:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00560284A9C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DEFA1AC424;
	Tue, 13 Aug 2024 23:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="frpQlRlu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F071E1AD3E6
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723592248; cv=none; b=aGZX8FPvGFAm0WAi5vg2b+oddRmK7czw3WNSEoDvnY3HroAifXdlw1wqfEcvWcgfkPW3UJ2aG0KfLgac+9n8PGRIf3LYWLZoPz20HCbGeVTblrWKJsm6BjcpnHlboJ04BzsgXYRn+a6VNG/+UH5km7aOx93IGhxDEMW9HVQcWwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723592248; c=relaxed/simple;
	bh=ZaeeD6EHcHKSJQeyzOBz7k5esMCWQ6i3pjcNxU7SD5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUFdQL1n3esSCNNr/cA3PUSHsaJ4dhGAqV7nRlAt3picsqqWzp+MksXtklkdLAPWLRHPrtiKVIliYo9FiWDYZa9TQcMMvX3978Dx76+Wg6Ww5YoNFFulchMiLC1y1HxxZXBjWR2IRE8NSLiK0XIWxlqDulFzSxDfSlQ2xslUVFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=frpQlRlu; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-44ff132ff9cso33531031cf.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1723592246; x=1724197046; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5VO2vOXTYUzHNGoqXkty4CZXSIWZNXE+mZa+Oe/5P5M=;
        b=frpQlRluD6M7SWOXhqDDbMBr4rmvIwz90ULhYPjFWNZTOwm8G3rgeQzcKKkctnjRXC
         KNKRQ5Glq6tlCAOMWbdSq3qMji6rKKHN0ZwDWSjwzsUsONQFCwCQCykgvck+dyOglKA1
         SfQYrG1nRkpKWUH8ZiXoSf+4nzvi2ij/A5Q9rhqF+gZPkSoVSnpZHTKx6Kjcu6spx3Kk
         APRrFjuM9M1dhfY1IlKs/+blbdsit2xgMnekoNgL/+PSLHZM6+VeqVvSNcaJpZVu0MAg
         gUfNLrQBLCQswsovvoEDzHNk86Y09Db9yk2nhC5lS3avloZNr2o6p0ADEkZlv7rsk28c
         jrkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723592246; x=1724197046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VO2vOXTYUzHNGoqXkty4CZXSIWZNXE+mZa+Oe/5P5M=;
        b=esnIWR3knR4fwkkF+eN9vRZBfAjKBU3dsSubcHIVsPBEAWwS5cSBoK4Sf/gxlJHh4C
         yjsyBW5YMoSuokwVwtuXVYd1iO4B5gU4ta05hLMKEtWzX0A+Mj2ZjvKA0mAC1EIclBAh
         DwNcGFqqNxgBEuGy+Uc49xcpoXx3ps9rGTESsmNPwOOrGMDTNac+FT1jvvdSyxVXQan7
         GDEe6IsqPO83WuI3LLZQViOeMV1VRaaK/GdymLPQnGxSLsiT8po+Pnd0MLFppaoQpfxH
         Z68NoralYnuC0PAElrXLN5K4TxC1Ap9Dwep7XS2/fAC0PjQiKDwl6qTMWVKEhQyu50uO
         G//w==
X-Forwarded-Encrypted: i=1; AJvYcCUBDTcPjFCd6iVSu8ZBY0SfMq8J76CPg5K/I04YllZNMz1YD/RelVfLh+mOwWXRvrugd4xRYyS+VmDQ2SA6yWFE5Elk
X-Gm-Message-State: AOJu0YwyLTCeF7WOs7FySJcUZX8tKH0yAY+KTXl6/JywxyBCqUM4ahJr
	/VSE7/s1FHA6ggH0JGJ5/H3ekrPAPCLu6tgQS/a0FZcYklVXYcDsFt9WEgCnyHo=
X-Google-Smtp-Source: AGHT+IFbm4qDYxgXzWa97F1Ax4tIokMkCTO/HLZVYUI3NA9l3rLq2ilxoJLGeZFzAszYUnI+b4y72g==
X-Received: by 2002:a05:622a:5c17:b0:446:5c31:f268 with SMTP id d75a77b69052e-4535bb0821dmr11613701cf.30.1723592245902;
        Tue, 13 Aug 2024 16:37:25 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4531c26d30esm36041161cf.64.2024.08.13.16.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 16:37:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1se14u-00AOBJ-NG;
	Tue, 13 Aug 2024 20:37:24 -0300
Date: Tue, 13 Aug 2024 20:37:24 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, quic_bqiang@quicinc.com,
	kvalo@kernel.org, prestwoj@gmail.com,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	dwmw2@infradead.org, iommu@lists.linux.dev, kernel@quicinc.com,
	johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci-quirks: Quirk for ath wireless
Message-ID: <20240813233724.GS1985367@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
 <20240812170045.1584000-1-alex.williamson@redhat.com>
 <20240813164341.GL1985367@ziepe.ca>
 <20240813150320.73df43d7.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813150320.73df43d7.alex.williamson@redhat.com>

On Tue, Aug 13, 2024 at 03:03:20PM -0600, Alex Williamson wrote:

> How does the guest know to write a remappable vector format?  How does
> the guest know the host interrupt architecture?  For example why would
> an aarch64 guest program an MSI vector of 0xfee... if the host is x86?

All excellent questions.

Emulating real interrupt controllers in the VM is probably impossible
in every scenario. But certainly x86 emulating x86 and ARM emulating
ARM would be usefully achievable.

hyperv did a neat thing where their remapping driver seems to make VMM
traps and looks kind of like the VMM gives it the platform specific
addr/data pair.

It is a big ugly problem for sure, and we definately have painted
ourselves into a corner where the OS has no idea if IMS techniques
work properly or it is broken. :( :(

But I think there may not be a terribly impossible path where at least
the guest could be offered a, say, virtio-irq in addition to the
existing platform controllers that would process IMS for it.

> The idea of guest owning the physical MSI address space sounds great,
> but is it practical?  

In many cases yes, it is, but more importantly it is the only sane way
to support these IMS like techniques broadly since IMS is by
definition not generally trappable.

> Is it something that would be accomplished while
> this device is still relevant?

I don't know, I fear not. But it keeps coming up. Too many things
don't work right with the trapping approach, including this.

> The Windows driver is just programming the MSI capability to use 16
> vectors.  We configure those vectors on the host at the time the
> capability is written.  Whereas the Linux driver is only using a single
> vector and therefore writing the same MSI address and data at the
> locations noted in the trace, the Windows driver is writing different
> data values at different locations to make use of those vectors.  This
> note is simply describing that we can't directly write the physical
> data value into the device, we need to determine which vector offset
> the guest is using and provide the same offset from the host data
> register value.

I see, it seems to be assuming also that these extra interrupt sources
are generating the same MSI message as the main MSI, not something
else. That is more a SW quirk of Windows, I expect. I don't think
Linux would do that..

This is probably the only way to approach this, trap and emulate the
places in the device that program additional interrupt sources and do
a full MSI-like flow to set them up in the kernel.

Jason

