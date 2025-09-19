Return-Path: <kvm+bounces-58145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF32B89545
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 13:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B58BD567634
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 11:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58DC730DEC6;
	Fri, 19 Sep 2025 11:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="YtXz7lXE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18B530CB48
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 11:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758283014; cv=none; b=R4V4zqXtM6/eSIExVeSPsvfeLwsvQenooABMdaC2E56Tx4Z/yQPf9y0pCh680uEX15q7XqCYyy0B8Ka3CRHUtMGJheSb7YQdjbz06FK4hOiH+sTjrXBSYQiH+HbQxtRYfUaCNzQzzhlgc6QDExIGTf/sroVNqZmCJGwtPnl3jtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758283014; c=relaxed/simple;
	bh=nVhwZwqjhePDpn3hIqHifRon6Z2bn7ZMu+Qm0ssc/jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhrsjWPRWnioH3tojGq0fo3MbTsbcEVNTM9ioBxZtpzgohaVo6Dks3t8F9JPQMND6E+KN1h+MhyRMh3iSlIbD3uO40FIac8UPTxHmnGwrGWzWw98SaWXvARFpRTlYz0tH24RnVrpiyHG/QMx8VupAVX9C+7Lz8YGJvdq6tu2+CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=YtXz7lXE; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-79390b83c7dso16757106d6.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 04:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1758283012; x=1758887812; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VuUmQ3adky/B0QCA1sMQ2Ao6Tuz3Fbnr+xuaWjpQ1Bo=;
        b=YtXz7lXErKOixL9lZnfianefYxnRSYSkpF4dAeSgXlSS/jhyjIk2SY4yYbcezDyQ3x
         FwDO8MgSmR+bNeyO2t0xfXauSkND/yoIk21FcQSfWajlAwinkLAjno/DMMZg6FKEHf4b
         pW5tofpw/3giwRZ79QAU7PmwfgTlbfjLb2jTF46seWUaHdVmkjDRAbwkeA0XjoE5i+D4
         ludgQpc65SUVUG6BbN9vee/kZy3c0/Lq0oIf99SbYF8FPT+bOzj5V3eHWzpL9XHFZj5h
         vzfpZ+lc0zDS2QzixsUoFIj6IUhaO1vzi8+Yz2PtJ0XxEZ1OV22spRLFbbvzzY05nurM
         mEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758283012; x=1758887812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VuUmQ3adky/B0QCA1sMQ2Ao6Tuz3Fbnr+xuaWjpQ1Bo=;
        b=jUl8XNUZJt90qB3d8aDdGfJsHbPqZ8gX7xubTV0fys87g1PbbiJ4Mxn4CiK1uNix08
         2BFWE2ufW3XCvrAxWtJxYaz5BNV0deIrycTLtlHjf08D0wr21tKdl8ZurpQ7OZ4/2yyB
         W55QBXOh489KFJXIHfSo3soBE6xm9p0+eeVXvY1VrUxjbEXFx1uTd3HxOE76/LtwXlOU
         kQEEmvgiFxIdw3Ir57AXGD/WnWrnFL4U+HNwDEzwdQ8Pd80mlIIH/dR6MYWlqE+BspNn
         wvVfnU5LyBa2FH+7MXtT8Uw/hRypDl5IJ3KJlRGu85tLCNV1j+AZ0pJG24NL+urfWqMR
         yTnw==
X-Forwarded-Encrypted: i=1; AJvYcCUhBGkKyRN+/ohyUVdKBNJ+Gy+KhQprenfeeQDUlxh69DO6aD0rLjE92ydlJLvKseWA7NA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK1IPTnf+/szU1bcWcC4lVI3c9FIF5yvke2JxY693Mk1F48Pa0
	kVkc/tuzFBYfMNFFChNMnqlGVOGkJWikmUCeveNKayxGbqqC1vtoTVx7SzoWm9pHpkc=
X-Gm-Gg: ASbGncujUAqtK8rush9HsHhz6uAmup6OkKrmV9RgIH42TzSFkIKu23/N12NxHAx7pOR
	0b0qpmJmNEpDSbzxPD/zp4tWRMq8cnxFck+NZb30fMD1aR+Xv6Q9gZFAhizboOWmNhCuOlkpYq5
	dmaY6A9z8Kn1YvGzx5cGY6wAZalhjffKBqkSsa3g0bVFbibCmXjed8HSC/KFJ9t7EkC8Fzt6zZb
	V5CcdAMg6RawneOXKl+cl1v47zAWY4kunwG6MT3I7E+KfL4/C2LK7t80wEbhmQ7dFR2A/d8Zc/i
	kl8hWbUcjGw/RPEJYaTYXQPoP9d/ldistY+J9hMCN0kvoN84PqtE8lpYI+O5ucli+bbP5IO5
X-Google-Smtp-Source: AGHT+IEoljyrBkccAFYLb8MBbUlKdAn3Qg4zbFh0M7v+yWUepkG0OFhXgg8yQQRY7r/ed8cRG3kFFg==
X-Received: by 2002:a05:6214:dac:b0:719:50da:4a08 with SMTP id 6a1803df08f44-7991cbb2d82mr33802106d6.45.1758283011689;
        Fri, 19 Sep 2025 04:56:51 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-793516d729csm28635246d6.43.2025.09.19.04.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 04:56:51 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uzZjO-000000097bU-19eX;
	Fri, 19 Sep 2025 08:56:50 -0300
Date: Fri, 19 Sep 2025 08:56:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Keith Busch <kbusch@kernel.org>
Cc: Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>, David Reiss <dreiss@meta.com>,
	Joerg Roedel <joro@8bytes.org>, Leon Romanovsky <leon@kernel.org>,
	Li Zhe <lizhe.67@bytedance.com>, Mahmoud Adam <mngyadam@amazon.de>,
	Philipp Stanner <pstanner@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend
 more granular access to client processes
Message-ID: <20250919115650.GT1326709@ziepe.ca>
References: <20250918214425.2677057-1-amastro@fb.com>
 <20250918225739.GS1326709@ziepe.ca>
 <aMyUxqSEBHeHAPIn@kbusch-mbp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMyUxqSEBHeHAPIn@kbusch-mbp>

On Thu, Sep 18, 2025 at 05:24:54PM -0600, Keith Busch wrote:
> I read this as more about having the granularity to automatically
> release resources associated with a client process when it dies (as
> mentioned below) rather than relying on the bootstrapping process to
> manage it all. Not really about hostile ioctls, but that an ungraceful
> ending of some client workload doesn't even send them.

You could achieve this between co-operating processes by monitoring
the child with a pidfd, or handing it a pipe and watching for the pipe
to close..

> > > - It would be nice if mappings created with the restricted IOMMU fd were
> > >   automatically freed when the underlying kernel object was freed (if the client
> > >   process were to exit ungracefully without explicitly performing unmap cleanup
> > >   after itself).
> > 
> > Maybe the BPF could trigger an eventfd or something when the FD closes?
> 
> I wouldn't have considered a BPF dependency for this. I'll need to think
> about that one for a moment.

Well, if you are going to be using BPF for policy then may as well use
it for all policy. It would not be hard to also invoke the BPF duing
the file descriptor close and presumably it can somehow to signal the
vendor process in some easy BPF way?

Jason

