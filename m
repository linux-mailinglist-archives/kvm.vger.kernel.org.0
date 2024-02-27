Return-Path: <kvm+bounces-10033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEAC868B36
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:49:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B17821C223D1
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D43130E44;
	Tue, 27 Feb 2024 08:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="co+35iFF"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899F112FF96
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 08:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709023770; cv=none; b=Cbeh0WzKk4aXtNGoFJMz8jpYq8tlPbWS1fbJ2RePThURTjC9f8IJp1IIXVRvK9mcKzNN02rEeHfI5kJQBcsV6/6TKKsVd8GKwjYVsTxkgC9U5MO1tx61O0FhChVJeN5TeeSArg3Qgc2nwHi4sJl8f176Wlz79ndoX8tHI+RBdRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709023770; c=relaxed/simple;
	bh=c2aw4Hw3anU8sRB0mw812/BpQbNSsLNusQqyDnPMQ+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQg5TQzy4pn72Z5bvabcUPJw+yUVPI11vRyqSe4VprUU2QcUj5nPhCIzCx6gO3L2NBStzC+pddZ+LADu2PU7TQivNFfx82cPi+6gGJegMCawnSf1h6yjrWl0PtO1H4i8XvteqKyEPPN74T2/fcXEwlxk3saPAa5eKdOCBn1KOEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=co+35iFF; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 27 Feb 2024 08:49:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709023766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B88acvmk3x+zIRZR32kMKESL53/0EUlRhoWm47p8/0I=;
	b=co+35iFFA/D2wKUXn7nYHD6NVdDySS+UuNx5G2ngPxXIyl0msY/tX6gEHpymCPeo+6sFQo
	WesPXGCplfJLDUVn6T0s2Fbj7Vi/qFridYIFJGgAwfFFvVX5IA3TIXXjnTHJB9qOTOkwB9
	OZ6IXWi9a57oPkJFIWNi73/h0BPEt2Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: "wangjinchao@xfusion.com" <wangjinchao@xfusion.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"david@redhat.com" <david@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"rananta@google.com" <rananta@google.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"surenb@google.com" <surenb@google.com>,
	"ricarkol@google.com" <ricarkol@google.com>,
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"bhe@redhat.com" <bhe@redhat.com>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	Dan Williams <danw@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Zhi Wang <zhiw@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>
Subject: Re: [PATCH v9 0/4] KVM: arm64: Allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <Zd2iCg5A0Zg_EyCm@linux.dev>
References: <20240224150546.368-1-ankita@nvidia.com>
 <170899100569.1405597.5047894183843333522.b4-ty@linux.dev>
 <SA1PR12MB71992A7E86741878935DC385B0592@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR12MB71992A7E86741878935DC385B0592@SA1PR12MB7199.namprd12.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 27, 2024 at 08:45:38AM +0000, Ankit Agrawal wrote:
> >>
> >> Currently, KVM for ARM64 maps at stage 2 memory that is considered device
> >> with DEVICE_nGnRE memory attributes; this setting overrides (per
> >> ARM architecture [1]) any device MMIO mapping present at stage 1,
> >> resulting in a set-up whereby a guest operating system cannot
> >> determine device MMIO mapping memory attributes on its own but
> >> it is always overridden by the KVM stage 2 default.
> >>
> >> [...]
> >
> > High time to get this cooking in -next. Looks like there aren't any
> > conflicts w/ VFIO, but if that changes I've pushed a topic branch to:
> >
> >  https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/log/?h=kvm-arm64/vfio-normal-nc
> >
> > Applied to kvmarm/next, thanks!
> 
> Thanks Oliver for your efforts. Pardon my naivety, but what would the
> sequence of steps that this series go through next before landing in an
> rc branch? Also, what is the earliest branch this is supposed to land
> assuming all goes well?

We should see this showing up in linux-next imminently. Assuming there
are no issues there, your changes will be sent out as part of the kvmarm
pull request for 6.9.

At least in kvmarm, /next is used for patches that'll land in the next
merge window and /fixes is for bugfixes that need to go in the current
release cycle.

-- 
Thanks,
Oliver

