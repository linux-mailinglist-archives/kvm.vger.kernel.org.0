Return-Path: <kvm+bounces-62377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7B4C422A7
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 01:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27452427769
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 00:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A5B287508;
	Sat,  8 Nov 2025 00:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="HOr39PH/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A712727ED
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 00:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762562879; cv=none; b=kIxbbeS+Izs0YDpktzPFqX4KlQvMkqUkr5w3wfeK06ZqMUi3xmvsvW9wAqL8m9ogYTCQDDaV3D+WfTL4ARveN3pL+ZLaJw/r55GZKkyOgheJ6riU1D3Y51J6jJagZcgBwZ+i0kSfF1P1lR0CzFvrrGfxpdGRCDamO6ZS+6V8b6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762562879; c=relaxed/simple;
	bh=/hmyZSHeuXe883AY8RZleUWbPkiy6fF/KxVQz8mwSfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fnxZj/p/Np6jxuDY4NIJ0kswpTlqU4zwZ7/Jv+/o4q8r4JY55flCg0gTfqs6JHmLoVUPkhGMOI9Ib+YZOxZpRRl04mMC9ood6cQGeSvjqAhSvfAxSnnV58QPZNL9vK+Z/iuE2NNfbOVSmexICavX5q8JDKWQDfvZAXFC7NKujQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=HOr39PH/; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b21fc25ae1so130773385a.1
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 16:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762562876; x=1763167676; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pfSbx8L4nPanVGMRr479mHYfADbovNNtvZzV7lTcOv8=;
        b=HOr39PH/ycfa+WIhEcpwn8iiDgeyZUOmSeNi0s9oWfdxQxA8CYL54Hi39lu2+SbkmB
         r5/AT+fLZBjAk/7G4OuFlDsV0gGaaiNDlHI2LdtYxoTp8R1ETFPw12pi/n6JS2im0tl+
         ARdkQ2B5TbNNrxxWZqHOWw77OyWCPkqJYLOHfnP4+YwC2q++l9aEzfNHGC03ojkxOmaQ
         eFeiu6n0tYLpJC4nezMyAiLcW++id4gwVrOPQydR3/Ri8+Wvi2EPvuBRmPWIbjEOXCGa
         cctjh+vU80Lf66C4HnQPUIlweINwcQj1M//gvRAkQddNHpjBWfUzwQf2j+tygJG3vGcC
         jk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762562876; x=1763167676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfSbx8L4nPanVGMRr479mHYfADbovNNtvZzV7lTcOv8=;
        b=mz1zZn/nmk6yRdxjAasQhyHKob61OBUQ9nubb6SYWwyL2zjY/PzlqKWQfcF0Wi+8MV
         4pfDO7WKx/0v335uOy1WhBHKXX8xbSDESQm9tKOaUAAQ+xI9qyTY1lWQhtcWUmLaVByq
         Ay/DL1vCR8/J4blkTbabzfCL6PAvqNph04X3CNLOfB1kq4VpdqmCeIPEFAO1ws8zealu
         u8mfJ2gZH7m1aTOvjZXrybtJiGRjLswVqr3uCuGp/YZea7IEDSIflWyaopWTe1P4xUzN
         yijLpYUh3+4RJ272ZTRCAJ0KEOqkRI7OGHxa64GZ3ZYxj3j6Ad6C7jL8QQV8EDYkyD6V
         xdLA==
X-Forwarded-Encrypted: i=1; AJvYcCVBwEiXM6dxQv7b29Q1up/GgH0fI0LZZy9VoLoi6rwY1ANnXjc1hsjMQ7PVsr1SfmEJxFU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKVUfNJOE95B/SJ9dZwlbXZhXuSLxqVpUI4pbhjM9Fgz2ummIR
	H+OYK/C7+uhx00VZJVwfC71qwz0TO/1FhMk/Ya0xysvXOVg39RuNVi0zqHyAKppYGIk=
X-Gm-Gg: ASbGncvZD4OFuqhmIzUMiC69Ek28+PeYYBLrPLDNfy+d3zq2hZZlSTda7ZFH3CsuLbt
	YhKrvfTvuII6sPdXbONl9C4ebVV4U9DHUyelRvx4qhSmlxYbqQbpjgDU+/tg9j2swfXJbcDrGjq
	qhvA0TfufRfTGSAj40l1Zaz4nBgEnAOhJI19uiBmlyy1xzfjDExpHvFN33e4+msNtfpbOiy/y7Q
	TGP0c/V+NLjewJkqeJ4wBVNl+qz4TfVzsKnXjc2ftkYLpauP07r1L9YH+ussHl0lNcp9o2YND3j
	HxmqLYE08VaDEVUEV8FE3xm2TBWkvqRNst73Az3proY6Z24whqYZzKj0QvVBs5Bs9UKOiGj0t4G
	/LkgTj4qq5ZSdwwYG7t6T2LfvtsnsUTse0swo8Lb0HTX40B7LvtLF30CZoLKkEJFSBSFzaNz/uj
	oewFPeQb+XfuFaYCmaLmSQM+g3zGHdXMul2RsA9tEUkov5MMIAgjWY/Ir2
X-Google-Smtp-Source: AGHT+IGDHhTWDSUeTerMAq7I/MD+3vriezautMa1TSo1oodrv/Bub4/+qoCC1k7wUOs9qzstWCl4pQ==
X-Received: by 2002:a05:620a:1a85:b0:8ab:5912:45c with SMTP id af79cd13be357-8b257f3d84dmr149741985a.47.1762562875697;
        Fri, 07 Nov 2025 16:47:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2357dbebasm525663585a.31.2025.11.07.16.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 16:47:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vHX7S-00000008NOZ-0EnE;
	Fri, 07 Nov 2025 20:47:54 -0400
Date: Fri, 7 Nov 2025 20:47:54 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Winiarski, Michal" <michal.winiarski@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	"De Marchi, Lucas" <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Brost, Matthew" <matthew.brost@intel.com>,
	"Wajdeczko, Michal" <Michal.Wajdeczko@intel.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	"Laguna, Lukasz" <lukasz.laguna@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	Brett Creeley <brett.creeley@amd.com>
Subject: Re: [PATCH v4 28/28] vfio/xe: Add device specific vfio_pci driver
 variant for Intel graphics
Message-ID: <20251108004754.GD1859178@ziepe.ca>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
 <20251105151027.540712-29-michal.winiarski@intel.com>
 <BN9PR11MB52766F70E2D8FD19C154CE958CC2A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7dtl5qum4mfgjosj2mkfqu5u5tu7p2roi2et3env4lhrccmiqi@asemffaeeflr>
 <BN9PR11MB52768763573DF22AB978C8228CC3A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52768763573DF22AB978C8228CC3A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Fri, Nov 07, 2025 at 03:10:33AM +0000, Tian, Kevin wrote:
> > To me, it looks like something generic, that will have impact on any
> > device specific driver variant.
> > What am I missing?
> > 
> > I wonder if drivers that don't implement the deferred reset trick were
> > ever executed with lockdep enabled.
> > 
> 
> @Jason, @Yishai, @Shameer, @Giovanni, @Brett:
> 
> Sounds it's a right thing to pull back the deferred reset trick into
> every driver. anything overlooked?

It does seem like we should probably do something in the core code to
help this and remove the duplication.

I guess it makes sense the read/write lock would become entangled too.

Jason

