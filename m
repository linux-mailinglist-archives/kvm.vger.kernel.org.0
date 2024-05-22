Return-Path: <kvm+bounces-17977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C022D8CC63F
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 20:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F19BA1C20C13
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 18:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5326314600C;
	Wed, 22 May 2024 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXU/Y7nb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E7D145FF6
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 18:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716402170; cv=none; b=qBZcyRP4K1G/2opI9ftRI9UVzpo/wIc/RrBYzIEWUuGU5uFWTjoVMdeptmwt3HSPTjMUezL9S6U41rc5yIB0Z6qepq/DpJgodWmETrJBG2CH03GaSf3odnr9jiP6kKEW650dMH6qj7teLhCS28HuxLc+B/H2mcGREaerUdGnK/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716402170; c=relaxed/simple;
	bh=Iq6KaucHUeO7d2vhmsu3CWa10QOWWbSDbQyQJO4o9+8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FixE4tYrAeY1YfV2MPS6dv/E9vB1AQGp9QUTKQOYaHGoRelFB9M6IuhrVPrsXNuPD3omU+ONdLJ574ngEp1NcN2iL3YXAye/4XYSE0xVP3MALhmUoHNKKLD0BWLwnER5rYRMtZirG6nUk/dE+FyBGM2e+bmVRndQw+gAEmHt9xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iXU/Y7nb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716402167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLatQqZlGNky/Pj/2JrwlT+MuEkPUVh+4wXLBcmTFkA=;
	b=iXU/Y7nbjK/boGFHTsFVUa7FfvnLdCt8bWahNaw26BlXInxZUtkmAcJq3BUgOE4pAge4xU
	NMtjSilA0k0MrTBx8QDacOtMUNgBsOPYA60pA75m0IfmUZ9nuMVzQjPC38cGQ+StOMWScT
	I9q0tCsMAujSvqW9gf33II11oaPpXPk=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-jbMcy26iPtmsLtOK-As7xQ-1; Wed, 22 May 2024 14:22:46 -0400
X-MC-Unique: jbMcy26iPtmsLtOK-As7xQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3c9abbb9f02so491290b6e.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 11:22:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716402166; x=1717006966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLatQqZlGNky/Pj/2JrwlT+MuEkPUVh+4wXLBcmTFkA=;
        b=IGj1vAWou758EE5DEfl89mDijxN75e6EzlkZ1tc4POb7mxjSQ2JMAbhaqZRGCv/kDd
         Ji3gEgSmiDEiugtQf9ltSqUiAsE0mbaao4bkYGCw7jYolql46AFqCIU6W9zu7y8r8UyZ
         d53Yko3aKVNhvQJl8HNFtvpaO7voMnJP56SofRIHK+qHa5DPzTsybzA95xvY+mmsQKVM
         Uq0itW//2Ath8HgJgBrm4Mv30Ix5qsfBhrbIJMb43db/jmUX4lYwXXJKfHDSN2qC+mY0
         WL+mhhHohcbDjKPPkNUQquIRzormp03P/i/cnmW0qh0iDXwpMnqG8HxfrDl+KkoNKeaj
         FJ9w==
X-Forwarded-Encrypted: i=1; AJvYcCWF1bRJ0D942xcMyUCzB/MCI20xcVvQWogY99fdPfqrul7VulOjToydD+SSbcYLbsoAGcjiHtOQWLicZb18Pi0K5s2M
X-Gm-Message-State: AOJu0YyF8g2qxMbCfjYD0G7O2HtIMoPrJZODe7SXdW4JvZJK5O3Ajst8
	jZVTOqkrO2dsO2qDHEYN3QIQqJmxnE+GvdHfWNmiKGPmbR8eopyCMVYCjnTrGgE/2LSpyloEM4F
	K/tXC0DLev5CxfFlXE0SyBU1FRiGjimrfKp9OXmNLybyH74572A==
X-Received: by 2002:a05:6808:241:b0:3c9:c755:a194 with SMTP id 5614622812f47-3cdbc568b62mr2527028b6e.59.1716402165271;
        Wed, 22 May 2024 11:22:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5vZvG6tsDWXDP5VEip3wRFTIGOmtPrEdCqdECt3XJLP2LbA45K02hd5EjKoficyR2hUPYOg==
X-Received: by 2002:a05:6808:241:b0:3c9:c755:a194 with SMTP id 5614622812f47-3cdbc568b62mr2526898b6e.59.1716402160051;
        Wed, 22 May 2024 11:22:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3c99308f4f3sm4570470b6e.13.2024.05.22.11.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 11:22:39 -0700 (PDT)
Date: Wed, 22 May 2024 12:22:37 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Vetter, Daniel"
 <daniel.vetter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
 <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
 "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240522122237.1b4bf782.alex.williamson@redhat.com>
In-Reply-To: <20240522165221.GC20229@nvidia.com>
References: <20240517171117.GB20229@nvidia.com>
	<BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240521160714.GJ20229@nvidia.com>
	<20240521102123.7baaf85a.alex.williamson@redhat.com>
	<20240521163400.GK20229@nvidia.com>
	<20240521121945.7f144230.alex.williamson@redhat.com>
	<20240521183745.GP20229@nvidia.com>
	<BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240522122939.GT20229@nvidia.com>
	<20240522084318.43e0dbb1.alex.williamson@redhat.com>
	<20240522165221.GC20229@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 13:52:21 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, May 22, 2024 at 08:43:18AM -0600, Alex Williamson wrote:
> 
> > But I think this also means that regardless of virtualizing
> > PCI_EXP_DEVCTL_NOSNOOP_EN, there will be momentary gaps around device
> > resets where a device could legitimately perform no-snoop
> > transactions.  
> 
> Isn't memory enable turned off after FLR? If not do we have to make it
> off before doing FLR?
> 
> I'm not sure how a no-snoop could leak out around FLR?

Good point, modulo s/memory/bus master/.  Yes, we'd likely need to make
sure we enter pci_reset_function() with BM disabled so that we don't
have an ordering issue between restoring the PCIe capability and the
command register.  Likewise no-snoop handling would need to avoid gaps
around backdoor resets like we try to do when we're masking INTx
support on the device (vfio_bar_restore).  Thanks,

Alex


