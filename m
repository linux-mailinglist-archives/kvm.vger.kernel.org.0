Return-Path: <kvm+bounces-51525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E77E5AF81F3
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 22:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4ED10188B4BD
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 20:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B7D2BD582;
	Thu,  3 Jul 2025 20:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B6sCveO4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EE5291C00
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 20:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751574552; cv=none; b=RpUyuY3wM1lJIT7eX0+oMEMFZWtBC/pcRQ5sLI5geVX8dcQ7QFTi1nnNXH9NcP7zQhCAMRzI2Yc/T76xq9i8hHhyRiLzKx8E43Ec8W047oFJiSVcwyjHY3QIQ2xaUAjkmdTA9E17b1jpuww7LVASmLRt+9lxKXZyZHPU3v3HK9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751574552; c=relaxed/simple;
	bh=VqC8qoN8eizNZXruXxR6loZ1n7rISlO7coQMRQxP+QM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AzyWmST0ogQicqVO7KNEC8KzGPwoxCNkoZ6Et8X2EDXhzl1GDyRN5wGRe9f7UeYulKyRNjBC5RXhr1RgQ+qlexYcdxGlHufwGldWS3L2pjmuULDuSqAi1VYXEXd19Q/FcjLkMzqgAOI4UFWesP/42DnoNd87s5H1Jd4Rl/tjU7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B6sCveO4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751574549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgh3cTB+Oxo7YXBWk917kLC+EWn1Cb9L+WuVCsq0UZg=;
	b=B6sCveO4rxabpy10lO5exmceFa7N/gYwPLy/jTJLgLtCPhLtBc7CLBau1NX42kWZIPT5zj
	Vpdyuy3twfj16TGAIDcMXjus+TpYubAsCAcDdasAgDqm3CvNDqkYew+yWN9WDoA6JmMwI3
	ZYQdclO4sVt7OnBbRzMTHbKT9i0xtXE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-TrHGJraZMcmHqU-DjdIW5A-1; Thu, 03 Jul 2025 16:29:08 -0400
X-MC-Unique: TrHGJraZMcmHqU-DjdIW5A-1
X-Mimecast-MFC-AGG-ID: TrHGJraZMcmHqU-DjdIW5A_1751574548
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-876b6482d29so4142239f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 13:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751574547; x=1752179347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgh3cTB+Oxo7YXBWk917kLC+EWn1Cb9L+WuVCsq0UZg=;
        b=OUxufJu4WJElBXjHaDqQI1DdGD/ZYV1YL7VjvQHutEz8+AqM1S+qjErr/jLQgeRjC6
         00mOKC7FW4A3ZqrqZYZynn8QGZKD5mA1iaabJYGPLhSHMGjILiUjsGEKIHhnPRIxGAoe
         7oNDb3gYrixabUkygAPBcXwrzJbVH/Oyu/S9Nyy0jj4G7Ul4iVKYhnpi84cTDb0kALxp
         MakJ6Rh+7kGyL6uVAER//MhZjH8/qoJPYeXk5BNgLCfaQ9p8iKGZlYGQMp1fHCVJXv4m
         NfDI781GyUA/9OK7MlXSGR3AihO3CLI59ScjyiuvWxp30aCiLEK7jzMUa1LjqgiBVptl
         ZHzw==
X-Forwarded-Encrypted: i=1; AJvYcCU04yonLyBTAM1xA/1wZaKnVEXS0hr+KSgD+Z0AW0RoLAIRABK+o81ZD5NvV9QONuTTkVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMW5vzjZ+Bb4fjOfZ/42iydLFzaGE2ips5roCHPiAWRhqn/kRX
	usIxdIzMmYp4BK6VOAdq+peFx3Fi3203gsHf7hscmN2nh8igIXjG8bDpmXQQ98QbAJyi+/coYLf
	E9VvrwpnBLbVSP+fXOvknlDegG7YtKWojVJO+Z1R+Qq3YlH1qmlAIVw==
X-Gm-Gg: ASbGncvwHnci6Nfcx4kE5+E5TzAdFhtWZXq3Tn/afdeZ7iKcKrE96Z0xLYEVaVsXx48
	KfrdLxMP65eJqfh5iSL5yXG1ULy2fo1nYhn2hXjeYjd0fAcV6O5XsJOogAXpFAkEICJyxv28FW+
	haMm9bH3egfvIRItkahCyyk6NvoP20Af9oMwDb8FX81nQdWTfF8GAHYmX8aeFSCh3EPxi7Pg1sM
	DElCisgQVwtFAcwTH0eBQxAg7M2Wvf2yMjCiEDxZl2tkxImPcJ0C5T31sTia6+caULGdFPjHkiN
	bIjG9/H30cRwPcb65i5/dZszRA==
X-Received: by 2002:a05:6e02:1905:b0:3dd:d03a:bf75 with SMTP id e9e14a558f8ab-3e05dc7c518mr10493515ab.3.1751574547560;
        Thu, 03 Jul 2025 13:29:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7w4H/L7KpTrLtWNxJbl/f+Z4Ah0hNuKrrs7iFFK1kgkSwXW4tt6SCUByjO+LQTsCx9rPgdA==
X-Received: by 2002:a05:6e02:1905:b0:3dd:d03a:bf75 with SMTP id e9e14a558f8ab-3e05dc7c518mr10493435ab.3.1751574547167;
        Thu, 03 Jul 2025 13:29:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e0f9b8daecsm1717925ab.20.2025.07.03.13.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 13:29:06 -0700 (PDT)
Date: Thu, 3 Jul 2025 14:29:04 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "aaronlewis@google.com" <aaronlewis@google.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>, "dmatlack@google.com"
 <dmatlack@google.com>, "vipinsh@google.com" <vipinsh@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "jrhilke@google.com"
 <jrhilke@google.com>
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250703142904.56924edf.alex.williamson@redhat.com>
In-Reply-To: <20250703132350.GC1209783@nvidia.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
	<20250702160031.GB1139770@nvidia.com>
	<20250702115032.243d194a.alex.williamson@redhat.com>
	<20250702175556.GC1139770@nvidia.com>
	<BN9PR11MB52760707F9A737186D818D1F8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20250703132350.GC1209783@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Jul 2025 10:23:50 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jul 03, 2025 at 06:10:19AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, July 3, 2025 1:56 AM
> > > 
> > > On Wed, Jul 02, 2025 at 11:50:32AM -0600, Alex Williamson wrote:  
> > > > I haven't tried it, but it may be possible to trigger a hot reset
> > > > on a user owned PF while there are open VFs.  If that is possible, I
> > > > wonder if it isn't just a userspace problem though, it doesn't seem
> > > > there's anything fundamentally wrong with it from a vfio perspective.
> > > > The vf-token already indicates at the kernel level that there is
> > > > collaboration between PF and VF userspace drivers.  
> > > 
> > > I think it will disable SRIOV and that will leave something of a
> > > mess. Arguably we should be blocking resets that disable SRIOV inside
> > > vfio?
> > >   
> > 
> > Is there any reset which doesn't disable SRIOV? According to PCIe
> > spec both conventional reset and FLR targeting a PF clears the
> > VF enable bit.  
> 
> This is my understanding, I think there might be a little hole here in
> the vfio SRIOV support?

I wrote a test case and we don't prevent a vfio-pci userspace driver
from resetting the PF while also having open a VF, but I'm also not
sure what problem that causes.

pci_restore_state() calls pci_restore_iov_state(), so VF Enable does get
cleared by the reset (we don't actively tear down SR-IOV before reset),
but it's restored.  VFs are not technically on a subordinate bus, so
none of those check prevent a bus reset.  I think this is why we have
the VF token, we cannot guarantee that a userspace owner of the PF
doesn't do something stupid while the VF is in use.

Also, PF->bus != VF->bus, so VFs don't get added to the PF dev_set.
The PF will do a hot reset with just the PF group fd and of course FLR
doesn't require proof of ownership of other devices.  Again, I don't
think giving each VF its own dev_set changes anything in this respect.

Should we do more here?  What problem are we solving?  Thanks,

Alex


