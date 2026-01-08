Return-Path: <kvm+bounces-67312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE56D007F4
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 01:54:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 60DDE30060E4
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 00:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D2B1F5842;
	Thu,  8 Jan 2026 00:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="l7eBb33+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE6417C77
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 00:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767833649; cv=none; b=qJ61U9xO5sjygznw06X7ML3GxfzO6z77wsA0aYCDMwmtEfFlG6QqGConTsHA+zL4o8GuB769D3OTyL8TeJEwRAJdIpJaWUv6eRB6DaYvVgviLDd2C2wUVZ3bQvLYP2VzKS6EcjGSRMKrhcpEbGda6iwXUH+8CpsC9s3SzzBbud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767833649; c=relaxed/simple;
	bh=qkl7DK3BpNF47DqlUVY8OBjoLVg1f80p3hzeztShHy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPl6aAQst2alQTDw26PLbVOF5kgAjXovSFR7p/l7u8Lb9BuSouwfsiuTSiEPRpHIJgcOigQOd03cS05ZDnLg50ikj9yZKRafCeEX0zbwMfw25+qz2GiQi6IwyyMu5dmebg/ju/ZgUAdUGTDbJrP9zfWewmhVyHhyZ3/GU5iquCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=l7eBb33+; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8888546d570so31714996d6.2
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 16:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767833647; x=1768438447; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zl/wCLSFYxDTasNNIFB7qMIXn4ZfCjA7D6KoNe2mE2Q=;
        b=l7eBb33+ErdcqaeYohuxsJyrZZWB/2cWlSnM4FMY8waLhQukyvymAgVgI21SKtvFEB
         cH7ujbYmBeVbmYG4guQ0+FykwuOX192VG9+YrXo4XWMYPVdVxZ7COS7BNJ/Em9oqT+eT
         JYLA73DI+UDDfeNEIW1j0+MtVTHIh6l95l78qzpGxCpirhzczCQMUk8PRLT70FLLgn2L
         wUUQ13FrV1vliJkqVqkAkPcBLi6btuCWXeqZ+uZdgnvgw0IWPJJjBqwURxEfOD+hiGEf
         GwV2uJGeHhHjf992b6V34cgvpEVJ0NzlJhpWuVegY12RkW74njUvx1M/4V7g9LJMCiUc
         97+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767833647; x=1768438447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zl/wCLSFYxDTasNNIFB7qMIXn4ZfCjA7D6KoNe2mE2Q=;
        b=DeoVJU+etGi+3QghFpoGwtbmbGOQr7v4qeu/H28bxxmO9XlnCuIqp9ne3mB//CTteS
         Vv1+h9nN/bLmkc9gLddSYJECksUzVVDTi4Al6Np2dI06DRpvsRFXpP4fi7nGbodjrJpZ
         LEYupbhzhHF2xYAVGDOlnowq4mpx4IYJJQyVKJNJAGUUrALglh5MI6x8UkhUhAmrhEiL
         rUa8fY7FCLCcTCxZOjqrbM1BtlrTphwpei8RDbwynkqswBqAs/1C768d7QSx4Hdarw0x
         NrylgOvoYZ0m0gWBrT+yaYN+ecagglAwtd4Fzi5DvSEkz/3Cdt4zrcLmijZJSMtZWqk2
         e7jA==
X-Forwarded-Encrypted: i=1; AJvYcCU7Mhj/ND3fhddAaCT/gQDBYQUMKx4OzzQd7O+Sb3UnDsHhNTL6iaA0L143Tng0S5nzsyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YybUFBJ/LGtV02QRkXgcPS7hVdntFFIo0JdIkcm6Jfy0Ae8cwIq
	rP4ZWs0CcNTD7/B1fKjOPZOlDMWAB+AG59Zk6nuxySAcso8OALktH8/ZJr064cHmEmE=
X-Gm-Gg: AY/fxX51l/QQFgyrqp4RUWJVDH8uoLSHhIbiAtAWd/S+bqCnSzhIx1P9qQmI8dHBJf9
	ImBdGWwD4+RpRwNxdWKvggNxJiOFwNsb8tKcuKxBOeSQSHOxFgZWa82BspV+435VILHtwregK2J
	HCYQpr5+E1TNZ+j7vv0fmrqqd5XaDwHPgwm+vKhsrgyCmmITsVvnD5B3Bi4/hiOPsPTaOa8TAs4
	T1CcMkyltwIrdjTADUFeatbNm+A6/56HrgM9+lYF+sLsILe2H9diwslP2mD9WhenU0iXozZlr2v
	zm1Vb8KX/TOTsRr5cpQ5K6/wMiFWmcXncwjQ31GvKJnq5tv7MfQTaqcr7IiwY8NXO9T9sKSgGqF
	reGT8cLrDcOLQaSzWjE1SGKtY8wNfkjUWf/FGMrjKjP6ByLDih9tLkMT4laeaAQnpVo5/e5XZQ9
	PIok1SNdyhIrvNsIQY94vffuqKJAJijsaoPC7ZjlqN3sajateWALgt6LlHQGuxdgPmlRAyC3bH8
	dqrDQ==
X-Google-Smtp-Source: AGHT+IFzwWFM1xm57ldcpfy5lJ/TQeABRvizVWmezixsdp8w652r/WsKLDXS4GvPiS9CZXAymOEobA==
X-Received: by 2002:a05:6214:4a93:b0:88a:7617:6b8c with SMTP id 6a1803df08f44-890842a1684mr68378556d6.48.1767833647102;
        Wed, 07 Jan 2026 16:54:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e217bsm42850346d6.13.2026.01.07.16.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 16:54:06 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vdeHu-00000002Hrc-0KPf;
	Wed, 07 Jan 2026 20:54:06 -0400
Date: Wed, 7 Jan 2026 20:54:06 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Matlack <dmatlack@google.com>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
Message-ID: <20260108005406.GA545276@ziepe.ca>
References: <20260107-scratch-amastro-vfio-dma-mapping-mmio-test-v1-1-0cec5e9ec89b@fb.com>
 <aV7yIchrL3mzNyFO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV7yIchrL3mzNyFO@google.com>

On Wed, Jan 07, 2026 at 11:54:09PM +0000, David Matlack wrote:
> On 2026-01-07 02:13 PM, Alex Mastro wrote:
> > Test MMIO-backed DMA mappings by iommu_map()-ing mmap'ed BAR regions.
> 
> Thanks for adding this!
> 
> > Also update vfio_pci_bar_map() to align BAR mmaps for efficient huge
> > page mappings.
> > 
> > Only vfio_type1 variants are tested; iommufd variants can be added
> > once kernel support lands.
> 
> Are there plans to support mapping BARs via virtual address in iommufd?
> I thought the plan was only to support via dma-bufs. Maybe Jason can
> confirm.

Only dmabuf.

> Assuming not, should we add negative tests here to make sure iommufd
> does not allow mapping BARs?

Yes
 
> And then we can add dma-buf tests in a future commit.

Yes

Jason

