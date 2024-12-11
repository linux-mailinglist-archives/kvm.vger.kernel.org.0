Return-Path: <kvm+bounces-33513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 667D99ED908
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CEC92854F1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 21:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21D21F0E30;
	Wed, 11 Dec 2024 21:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFaITdJI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058721D63CA;
	Wed, 11 Dec 2024 21:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733953790; cv=none; b=CJ2PkjH3TWBJIpIO2rRAgZTxQjIeuubK1ioPwZpV71hi1h3hQCVuo7ZeGJ1sfJqy7RJeO9Ath5m/Xb3JzpuG8JT0mAHXcmnGy9ZUfHxdH2tjgDpBHEDNfNX34ggdZjkpPvuFh6HV6zfgR1nqqpSUYpnj/p7yyyzRi2uSWL2rEaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733953790; c=relaxed/simple;
	bh=9dEs7Uv/W3GFIdvWXNgPv9/RG/WPitz2vsK5/eV8epM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLbsgWcgtnGwhjGAtEurZW7dehbHsyQGd/q9PHXFNqSWbaxE8RJjgQXT1TeYk2170BG2Dl6DOIUn568xGXUIXKPyZfHmSvqD97OeltBD2GNjLNvixwybS0klpr6YHbGXM8FsB5kxV4VGY3Fqi+BRzmRUexWcv8h7ZtmU76bNtrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFaITdJI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35920C4CED2;
	Wed, 11 Dec 2024 21:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733953789;
	bh=9dEs7Uv/W3GFIdvWXNgPv9/RG/WPitz2vsK5/eV8epM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MFaITdJIkZ1IZ7UigB5f9EhJDAqOApX0es7WvCaYIyDxpBqxTVztnpMhTSDhYdiPb
	 257hY2WpAkUzycQO10r8/Juah4PjhQt6ojA1tYClva3aSLV1cs3T9c33RHHemnCeLG
	 4nCMZiKzpKXK9A/lDjeS1hNe3FMwIvwkeLblSVCM0LBMFZ5Na32iXF4BXNO6e0sSrP
	 gqwHbYpID10NcowjpWJQQtu9fsCV+/MbUb/pWJ75dwC+UsqPiCuGljkzXcJK7QuY+P
	 nA1ASb4a6HJcJxjUGb6tz3ue79ctd/UDZJ0VkUZknepBmN5hjzG7ppeQ8vOnHJlsHq
	 dsot4KoUZvQCA==
Date: Wed, 11 Dec 2024 21:49:40 +0000
From: Will Deacon <will@kernel.org>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20241211214939.GD17486@willie-the-truck>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <20241210141334.GD15607@willie-the-truck>
 <SA1PR12MB71991EC85E8EEDD1C5115886B03E2@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB71991EC85E8EEDD1C5115886B03E2@SA1PR12MB7199.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Dec 11, 2024 at 02:58:38AM +0000, Ankit Agrawal wrote:
> Thanks Will for taking a look.
> 
> >> The device memory such as on the Grace Hopper systems is interchangeable
> >> with DDR memory and retains its properties. Allow executable faults
> >> on the memory determined as Normal cacheable.
> >
> > Sorry, but a change this subtle to the arch code is going to need a _much_
> > better explanation than the rambling text above.
> 
> Understood, I'll work on the text and try to make it coherent.

Heh, I thought it was the patch trying to make things coherent :p

Will

