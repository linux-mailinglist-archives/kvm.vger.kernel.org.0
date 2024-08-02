Return-Path: <kvm+bounces-23048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C344945F79
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 16:33:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0306A1F217E4
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 14:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8743F210194;
	Fri,  2 Aug 2024 14:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TvmP6Q89"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B83210183
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722609229; cv=none; b=OQgC1VZUXhznrjn9WsVIKqjP1i/AAf5l5sIeRahbBjL1uYT0dYQzEW8RY93OA5s9bChJhXbhrHpfQ0UiEaeWfk6+HhCUvJAsFfr52ZjwVDsirL3pZsitX/GQiZ5dOleSNVp9hCOLFQF80xlrkNnMlYXR2XhYx95iTObLmc2V36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722609229; c=relaxed/simple;
	bh=fLYyGpAg5z2pEFUgcCJcCIdOqe8KSGQokEWEe44JteE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNkWCCiIGC+w3+++T/PGczomq+BU2jWRt1gwr8ts9ybtvxP9d3RU4N3Ipv6ZBH9R+3QEd+ZH/0ISaCx/zKUtO9nfYWWNhMfiqIoweinUYQted2duqRArKmljHA43AvQZa1PonGS/4M2yJnDFG8COSX4J/959BZMmodoWMLRQstA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TvmP6Q89; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-70944dc8dc6so4435845a34.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 07:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722609226; x=1723214026; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8+0LCZb62SJcm4AJo4i6+oz94H7jhu4Xatg5nbWNkAo=;
        b=TvmP6Q89dw2ueJCF5WmzjKi4ofp1QY3I1PiCmLjHW5cMP+pZeu4b4/tskzr0hcURKj
         hOIVwvSPgiX12hszW3kR2TDgyVXxa38JEdiBg0CPJlmGVNy0FhXvrKPWl/ir2bjmLIqJ
         iuTdBkk2CKZfY4hkR/9+SB0CRvroC6ujFzBNzhYwH0R1C3O/vH+faVlLXNXtfBD9ZZHJ
         9p0cCcbLkBG9y4pwPDDZOfgULHI29v04AJ1BQViDS2W5kyluTy54kKGikH34Uh4RNCLn
         fyixhRzzZafK3gGaeBlL7HKIOVuYly6bbNEnz/AJy/VAnvLhyn0T9SF6s5SIJLJxaB1u
         lelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722609226; x=1723214026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+0LCZb62SJcm4AJo4i6+oz94H7jhu4Xatg5nbWNkAo=;
        b=CKp04eQLxqC9ZUWK43dv22B6y3X0Uf1Igbaw5NxrncOw+ZXwDmqcoWqEHxcKbJQx4N
         KXWEGtfyXisoLzaO7rfJHVLj5CaD7ESmTj01HObLdQbLhqmUF88tLlQ+ZejG7IgIoyJ5
         zwqSmHaYopVjS8KzRlJSolyqr9yzk8VZ+rP1Z3cYsi/dndGEz15HT+oSXrJHC/k3hWti
         IPTA2xicG0mGNCTzK6rfCxMeKD3EC4k8N3BRZo5iTIFHhLsHDs1nnz5nmvJKEVyip1lp
         JCPtN2AzokSPtqJPpnr+3KpBfzJmaKvGzPk+VFnC+ERSvGgTUuhKHYJQruA2Im3mMEhr
         GnIw==
X-Forwarded-Encrypted: i=1; AJvYcCXS7tYsNqDmze7jejMDD2NoKQpWoXS9uOWhV/y3uRxsLvgxJLS1iYkrLT/onm9eRzwg42/V6VwhJcy8YBk9de9QAWJA
X-Gm-Message-State: AOJu0Yzw39bNmCX6aesCaRzrxOH+Yb5BPWeETSH3PuFvRj+2ectIhp9m
	/1geoC7vC7iAtdRnVSrxRAv5L+b7aZ4Aulfut4vUl+4Nv5KG4FJTfDhlOgooo27wIYbV5HJtT6D
	7
X-Google-Smtp-Source: AGHT+IGa2DWh+CgK9NU/iH34exTcUtNtsWvavMBtrV9+dI+8bdEl40KugSsFUG5Z7nRGAiST7PXG0w==
X-Received: by 2002:a05:6830:6f83:b0:703:5db8:805 with SMTP id 46e09a7af769-709b0bd2a5fmr5346172a34.4.1722609196382;
        Fri, 02 Aug 2024 07:33:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a34f6fb283sm90636485a.60.2024.08.02.07.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 07:33:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sZtLH-003ihs-6Q;
	Fri, 02 Aug 2024 11:33:15 -0300
Date: Fri, 2 Aug 2024 11:33:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Keith Busch <kbusch@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240802143315.GB676757@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
 <ZqzsMcrEg5MCV48t@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqzsMcrEg5MCV48t@kbusch-mbp.dhcp.thefacebook.com>

On Fri, Aug 02, 2024 at 08:24:49AM -0600, Keith Busch wrote:
> On Thu, Aug 01, 2024 at 11:33:44AM -0600, Alex Williamson wrote:
> > On Thu, 1 Aug 2024 14:13:55 -0300
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > > On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:
> >  
> > > > We'd populate these new regions only for BARs that support prefetch and
> > > > mmap   
> > > 
> > > That's not the point, prefetch has nothing to do with write combining.
> > 
> > I was following the original proposal in this thread that added a
> > prefetch flag to REGION_INFO and allowed enabling WC only for
> > IORESOURCE_PREFETCH.
> 
> Which itself follows the existing pattern from
> pci_create_resource_files(), which creates a write combine
> resource<X>_wc file only when IORESOURCE_PREFETCH is set. But yeah,
> prefetch isn't necessary for wc, but it seems to indicate it's safe.

Yes, I know, that code isn't right either... It seems to be the root
of this odd "prefetch and WC are related" idea.

Jason

