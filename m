Return-Path: <kvm+bounces-16414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6259D8B9B2D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 14:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D63B283CEF
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 12:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D23B83CC0;
	Thu,  2 May 2024 12:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGBOF4kk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A366A3E47E;
	Thu,  2 May 2024 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714654648; cv=none; b=KAMZzhfrpPZuR+No2K7U4cO29Rh+5EOKH8lkErI4VPcN+vaorwEsnd9+9qp/og8U7ED2ZiLNyZrgr0+JdI0IR1QqV59cpipNXpeeGmbRfQ3bepnXht68lnkiXBW/dK8LdLqbfk6XFjhIIsUlnTbzZGjgbDkss0p1/ceyzecyNVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714654648; c=relaxed/simple;
	bh=OwqbgGXta9Pf1TpudRH9JFOWS6zl+MgHoogHnhBKWs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJssjpPuqJ91DXUUVzBpzLbRzL84/fjNAF4QfPul7YNhQWs2SMSn6lJlPMB49CrxMpggiHBLqg6YIQi7Yk+MHNel9zEjH4x7Qir96s+/8guplyaxbvW+dJzeu5sFI4cda0BYkvturWJvX7L7an+9PKpCM6hZV6tEstn6Z8iqZV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGBOF4kk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA61C113CC;
	Thu,  2 May 2024 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714654648;
	bh=OwqbgGXta9Pf1TpudRH9JFOWS6zl+MgHoogHnhBKWs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GGBOF4kkklhLBl56r2o43uYC7YyvUQB/QuJJj3UH6bTN7xggBqA5uFxckuBAFvX62
	 5TyyKfoxVDdGJpiOwt2bS2XLT6C9WgrU7DhMs4h1FrKFI6INS/X54sSP+dQYEaTQuq
	 72LvOOKBn9xF07XWJMyPwVC45Rg2QXN2rWb3AbAVfS0PbXugfpIFwyA0nTwZThPYvs
	 L3SJVJPQiMGO/vLJJojAQN6LGBBFMUcy72CiVKtdy9OytnFbUfJOy/iTEsBNlsoC7m
	 XexYPYX1owumny5YzAMlf/+GzbEpjVYxdnMRCQteywaxIaUfeqgLrlL7nORybK4xi8
	 x3G2HzY5yNZ1g==
Date: Thu, 2 May 2024 15:57:24 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 2/2] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20240502125724.GI100414@unreal>
References: <20240422063602.3690124-1-vivek.kasireddy@intel.com>
 <20240422063602.3690124-3-vivek.kasireddy@intel.com>
 <20240430162450.711f4616.alex.williamson@redhat.com>
 <20240501125309.GB941030@nvidia.com>
 <IA0PR11MB718509BB8B56455710DB2033F8182@IA0PR11MB7185.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA0PR11MB718509BB8B56455710DB2033F8182@IA0PR11MB7185.namprd11.prod.outlook.com>

On Thu, May 02, 2024 at 07:50:36AM +0000, Kasireddy, Vivek wrote:
> Hi Jason,

<...>

> > I'd rather we stick with the original design. Leon is working on DMA
> > API changes that should address half the issue.
> Ok, I'll keep an eye out for Leon's work.

The code for v1 is here:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dma-split-v1
It is constantly rebased till we will be ready to submit it.

v0 is here:
https://lore.kernel.org/linux-rdma/cover.1709635535.git.leon@kernel.org/

Thanks

> 
> Thanks,
> Vivek
> 
> > 
> > Jason
> 

