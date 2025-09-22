Return-Path: <kvm+bounces-58373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E282DB8FB4B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 11:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA65C16B9FE
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B5228725A;
	Mon, 22 Sep 2025 09:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1ZpdRARG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D65264FB5
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758532472; cv=none; b=k6h3WPphbY4mHOP2AsBCA57pJUdyp1dAknR1htcfJ8PAOZB6MYvd2dubyanDEPjSM1IIiaPHTYx6FeDeB/g9xS9Ha42WPkzPNOsDz5lzX9vuREsvkTDjY5eeJ4uEN9mTmFru3Uz+vBidjKL3SZZNyOtmYkXS7WS0X9g2uradE7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758532472; c=relaxed/simple;
	bh=PWZIHxNO9F6b5mRaqczR3GeKYl1D6LdC4n5HIjFGDFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTRHVcWlrNym6oGeVpsuwjgf+Y9qv0DAaQyEOUY5n3LW0L3+JwIEKVQfioV8qHFtI/8EuTNIRkc6ZnSrE+zRoWBX0aiPnIzlixuu5DK8o+3M4H8HYzSt/0gU73Q66+TPIzviC4oHgHhA03SLmrBXaJ7Y1+2+Ifksi9t/aXar5VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1ZpdRARG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46d72711971so30855e9.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 02:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758532469; x=1759137269; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wgArYQu+cHNbaIGGgNnr3ySxE/Az/B6v/bHyH6zdSV4=;
        b=1ZpdRARGYER41O1923opmMPvG9X5f/TwG3kjJGNY8/Qm/ndvfUEjo4wnbDuVy84c2x
         JMq6kyVCpj2t/3munw/mJB5EW+jZMXpmwh6YjMb8LofcbHqe2hsyRdI1RExhC+I/vZOT
         EIzpMLj4WOQEMBTa0wu6vd3jGn+Viw6NMmP9yTXJubfHtCMXGScyEQtX7sqqbflLO87d
         1UqKL9zBAdlbmeexqy6kBnQRMCGelsoi6+R0wFtgEHdFH/CBdKekkgWrhTSaodjyI+EK
         NLBbCNECv7g6QhauxhXuHGb2ogeu/2KbqG91ZYHpr00nQo9tA31+I/cJcGs57lalW6nj
         Wlhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758532469; x=1759137269;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgArYQu+cHNbaIGGgNnr3ySxE/Az/B6v/bHyH6zdSV4=;
        b=LXVApmkIjkWObuTuVFLRan3Krwx+GR0xN9mYL6Rzh1xpzhsQKYprBLnslEFT+Ozhr4
         /jVugW8bmSkf/Q8zOuVtNCSyNDFO00+o+j6ckvomGzw/oPqmnVmvTNU+C5KTLeGLxIcJ
         wosRKzzISgxpx+WKrtfeFoJu+FjEcGnVwZFPJ0XzfbuiHYdzI55bfZ+ZXEXX0kigR60U
         TJR015TEIkP/fiMppaE50jrGiTLzIF+20TX6MJ8iMzaXWDgoCykiXcvvKt1dGBtOwV/w
         qWYd58Bkf8muuAvMyjoDVP8S1XaEu+T8ecdvQ8r70bxbE9gVznAPt0R+revRmfpJaYpK
         cgsg==
X-Forwarded-Encrypted: i=1; AJvYcCVPXYqG+td/3smGE0kz8Yxx7QMKS5sHUarjh2NYlRyg8kdJ1mSaMNyFH06UQzWBXzOFwCs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbEuafc+THSJ85W+HMsC80TgnwmnY/LGa4qeWVnJe2qv2lW5+e
	NWUD23xpZqJfbT64TxlpZdKrJqJfc82p6/n0l/t/9WNuPTM895NnT20fjsD37IHfBQ==
X-Gm-Gg: ASbGncs2mAnSuINWh+e58I5UDK9FyHVsEb/1qTp1+1Q0gMrDeUartSgcA/9UnX/NPH6
	kAVLWHpcyBvldISj7J9os85VhvjRxWsoQ0LBdw/ZE2iELBvH/jXPiG1RELNwCdspzUUzNr9Ey63
	Sak6Jb4EdjQk60u80zl5nkIAv6km0TP8jzhV7oMvb3AVgZOsze4aYVpj+rEwTeq+vregNvta1kh
	YRiubVle+0hXejZNttd9ADse5VEIqLWlMz1qaP6/WKx4Co8DIlbWGLBbx8f39TDtM1LSYgFl98B
	gPzE/oybR6rZOibk0hDf1kjHIhIUhkIbjFFPqrVwg4TtLG6nQTzSFqrIT4PYE6o24MRD/oIFLqj
	OA11Cwg8au0tHbNTSlJwZ1PQ2OIUEvCkUPj8Avmx0YH3VBQmlFj+kKBW+vaF+JxU=
X-Google-Smtp-Source: AGHT+IHzWY/BU+tZg/uSMYwHsohYz2u6un9Jyb5wJfEWQ7iDRJk2kEB7VjW0B+HU5Afwed6ytoIPQw==
X-Received: by 2002:a05:600c:190e:b0:45f:2e6d:ca01 with SMTP id 5b1f17b1804b1-46154878d4bmr11295375e9.4.1758532468571;
        Mon, 22 Sep 2025 02:14:28 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f829e01a15sm7769744f8f.57.2025.09.22.02.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 02:14:28 -0700 (PDT)
Date: Mon, 22 Sep 2025 09:14:24 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>, David Reiss <dreiss@meta.com>,
	Joerg Roedel <joro@8bytes.org>, Leon Romanovsky <leon@kernel.org>,
	Li Zhe <lizhe.67@bytedance.com>, Mahmoud Adam <mngyadam@amazon.de>,
	Philipp Stanner <pstanner@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend
 more granular access to client processes
Message-ID: <aNETcPELm72zlkwR@google.com>
References: <20250918214425.2677057-1-amastro@fb.com>
 <20250918225739.GS1326709@ziepe.ca>
 <aMyUxqSEBHeHAPIn@kbusch-mbp>
 <BN9PR11MB5276D7D2BF13374EEA2C788F8C11A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB5276D7D2BF13374EEA2C788F8C11A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Fri, Sep 19, 2025 at 07:00:04AM +0000, Tian, Kevin wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > Sent: Friday, September 19, 2025 7:25 AM
> > 
> > On Thu, Sep 18, 2025 at 07:57:39PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 18, 2025 at 02:44:07PM -0700, Alex Mastro wrote:
> > >
> > > > We anticipate a growing need to provide more granular access to device
> > resources
> > > > beyond what the kernel currently affords to user space drivers similar to
> > our
> > > > model.
> > >
> > > I'm having a somewhat hard time wrapping my head around the security
> > > model that says your trust your related processes not use DMA in a way
> > > that is hostile their peers, but you don't trust them not to issue
> > > hostile ioctls..
> > 
> > I read this as more about having the granularity to automatically
> > release resources associated with a client process when it dies (as
> > mentioned below) rather than relying on the bootstrapping process to
> > manage it all. Not really about hostile ioctls, but that an ungraceful
> > ending of some client workload doesn't even send them.
> > 
> 
> the proposal includes two parts: BAR access and IOMMU mapping. For
> the latter looks the intention is more around releasing resource. But
> the former sounds more like a security enhancement - instead of
> granting the client full access to the entire device it aims to expose
> only a region of BAR resource necessary into guest. Then as Jason
> questioned what is the value of doing so when one client can program
> arbitrary DMA address into the exposed BAR region to attack mapped
> memory of other clients and the USD... there is no hw isolation 
> within a partitioned IOAS unless the device supports PASID then 
> each client can be associated to its own IOAS space.

That’s also my opinion, it seems that PASIDs are not supported in
that case, that’s why the clients share the same IOVA address space,
instead of each one having their own.
In that case I think as all of this is cooperative and can’t be enforced,
one process can corrupt another process memory that is mapped the IOMMU.

It seems to me that any memory mapped in the IOMMU is that situation
has to be explicitly shared between processes first through the kernel,
so such memory can be accessed both by CPU and DMA by both processes.

Thanks,
Mostafa

