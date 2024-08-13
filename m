Return-Path: <kvm+bounces-24063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C31B6950F08
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:19:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BA97281B21
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 21:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949681B32D0;
	Tue, 13 Aug 2024 21:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZnIOvir"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451CD1A76C4
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583647; cv=none; b=uDkh3bgncqBJQOQB5HSZ6Q22VAHdYENU7wy1JY1KXNL2T5+Fl2LQlxAZGOWEPyQEzRnYPF1d7cJ3OsCxRGYSTRu/dOU7XMN0HVpx+vQLCLbThb17KCnpP0NMzBK1bfgsq6b+05MwgnSNQ1i/nGt4Q/HeAVHhPR75lXUBozNQhg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583647; c=relaxed/simple;
	bh=3gSe/cVBbpVPgF+9SDAdjXm4H1D+qaetKJRmI3rmOnM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g9w5Iou5YIpi+6rJotsf8Fi6rYiKW8JLjDiQOB80FC/NzZoeIeL0VTcsTCVJi34TbBh7pSm/2Q83YKMEpEe7eMP13klLQHtPP65Ug3QDSM8IrjytPnlF8DLcGpZPy94MrMyiCOBznpUbcI5I4VjoNr0Ue6EpMlAEmknk60v0PuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cZnIOvir; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723583645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RLndxOVhMGnGk0ZQ33snLsOErJZzv8Txl/Ym94gCWEQ=;
	b=cZnIOvirxhfADjqx3lB2xCkA5PYNgM8hWW4AR4ME7J9PJPQVHbyo96E8Qvkz3zo6GVTbiG
	soVVW2W5pLB7/7L5C0XXih2c4a+aaqmnRyk5GkCbkPkzTnOOPlggbyaeeWLhDvg5LeiFEs
	U++0aLk8+NMvGRTpTuC4OuuJJTHznng=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-7O0W41wpP6OEuuLYM7wWTg-1; Tue, 13 Aug 2024 17:14:04 -0400
X-MC-Unique: 7O0W41wpP6OEuuLYM7wWTg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-39b391cf336so2701075ab.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 14:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723583643; x=1724188443;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RLndxOVhMGnGk0ZQ33snLsOErJZzv8Txl/Ym94gCWEQ=;
        b=tybUxjVhMqxYEmaB6/9neBPPamhTC4qORKUoe+EUMwGEy+BuNmeOhTdDuYNMi958X4
         2DgKpJ62guB95iJU0Sp6f2+ID8JDYa2hzuI4wnZl3L0c5qSt5LvxoxassStW01ZnME/c
         7H2A4iwxMB6wwqTgKMV+7WqpsX2ERXzdiFqW5awNCfj0DPlJBr20cB9Fh8mX5PUaGtgE
         iEM4Zau/aB/XKAFn/toD9hKUJXQK3EPGgJqQQB8hOfCk+DvOjdOa0UDiNbHQNZZhIJPT
         Dwu+t2kmv35SkVK0/7FWdN/RSCGgOLxmcD4D0TgB48F0tBZoy7zWE//11rPoQJ7nF9BC
         PO7g==
X-Forwarded-Encrypted: i=1; AJvYcCXlLUDKANONg2UjLmECnyg1gsEwi9e4k3iHYLB6IGkDkiFlSRYOGm32avpuVBR7gdL784woOY5KTFLNkp71abS560f4
X-Gm-Message-State: AOJu0Yx1jUmYr7jSWPhJ39E++3tYlFrxGFpg2ZFGQrrTsiP0tNtq/daA
	vmJIw+rEMLbmeaWyyA+bJGCanhJSQLz5m4to4njMc0G/WdyRh9aG3+1sWPEGpQYz8wMmS8v6awU
	eIVxq5xmPP199yb0eBWAizygMQDthy39TqhZEDtqGVj5h2t5abw==
X-Received: by 2002:a05:6e02:1c48:b0:399:4525:c2bc with SMTP id e9e14a558f8ab-39c48dccd95mr35434775ab.10.1723583643362;
        Tue, 13 Aug 2024 14:14:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG80cLRVSOvRn9w9qz+VrLxVLNgcf2C34EALlspiOzLOxMt0M7/SH6xPKbhukHFZiTHKZOB1A==
X-Received: by 2002:a05:6e02:1c48:b0:399:4525:c2bc with SMTP id e9e14a558f8ab-39c48dccd95mr35434605ab.10.1723583642975;
        Tue, 13 Aug 2024 14:14:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ca769102d4sm2731540173.36.2024.08.13.14.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 14:14:02 -0700 (PDT)
Date: Tue, 13 Aug 2024 15:14:01 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
 quic_bqiang@quicinc.com, kvalo@kernel.org, prestwoj@gmail.com,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 dwmw2@infradead.org, iommu@lists.linux.dev, kernel@quicinc.com,
 johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci: Create feature to disable MSI
 virtualization
Message-ID: <20240813151401.789c578f.alex.williamson@redhat.com>
In-Reply-To: <20240813163053.GK1985367@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
	<20240812170014.1583783-1-alex.williamson@redhat.com>
	<20240813163053.GK1985367@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Aug 2024 13:30:53 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, Aug 12, 2024 at 10:59:12AM -0600, Alex Williamson wrote:
> > vfio-pci has always virtualized the MSI address and data registers as
> > MSI programming is performed through the SET_IRQS ioctl.  Often this
> > virtualization is not used, and in specific cases can be unhelpful.
> > 
> > One such case where the virtualization is a hinderance is when the
> > device contains an onboard interrupt controller programmed by the guest
> > driver.  Userspace VMMs have a chance to quirk this programming,
> > injecting the host physical MSI information, but only if the userspace
> > driver can get access to the host physical address and data registers.
> > 
> > This introduces a device feature which allows the userspace driver to
> > disable virtualization of the MSI capability address and data registers
> > in order to provide read-only access the the physical values.  
> 
> Personally, I very much dislike this. Encouraging such hacky driver
> use of the interrupt subsystem is not a good direction. Enabling this
> in VMs will further complicate fixing the IRQ usages in these drivers
> over the long run.

Clearly these _guest_ drivers are doing this regardless of the
interfaces provided by vfio, so I don't see how we're encouraging hacky
driver behavior, especially when it comes to Windows guest drivers.

> If the device has it's own interrupt sources then the device needs to
> create an irq_chip and related and hook them up properly. Not hackily
> read the MSI-X registers and write them someplace else.

This is how the hardware works, regardless of whether the guest driver
represents the hardware using an irq_chip.

> Thomas Gleixner has done alot of great work recently to clean this up.
> 
> So if you imagine the driver is fixed, then this is not necessary.

How so?  Regardless of the guest driver structure, something is writing
the MSI address and data values elsewhere in the device.  AFAICT the
only way to avoid needing to fixup those values is to give the guest
ownership of the address space as you suggested in the other patch.
That also seems to have a pile of issues though.

> Howver, it will still not work in a VM. Making IMS and non-MSI
> interrupt controlers work within VMs is still something that needs to
> be done.

Making it work in a VM is sort of the point here.  Thanks,

Alex


