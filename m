Return-Path: <kvm+bounces-3580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 515D2805773
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0F4C1C21007
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C9965EAB;
	Tue,  5 Dec 2023 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGoYessH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF9E65ECF;
	Tue,  5 Dec 2023 14:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A7EC433C8;
	Tue,  5 Dec 2023 14:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701787042;
	bh=G92HElO7wu4W9h4mKuFM3rR7BN9XZu1dQCy7HpY/B+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UGoYessHIwz2m7jHfu2pPKOnbp9BDf8Bh8Z/Z+tn0XDdCxB5WTkX9KuivDGbOLx+O
	 bDqEuv7A39oidE257H8+FHh6T7HyMTiDfVCU6qXUuj2rFZ5dnFTBnB836wlgmSw+Qf
	 LzhaToDjYucI2vhVp8LEhLa/ukuT/nm1kD7lDvRSscgskjqdK2MlGc4/LhMb7Zdoql
	 acy4h9yeo1EdoXdy2xaQ86/uMaOEn+UmBtWWJbg+w/moLmPC5NrQDdu8PvU/Ilu58t
	 RBgbTXVzu9uKRMxFPzvXgPUGciFA5D2IWUBAp3bWKKAF+2artu7Pqqu5Kx/l8X9uqo
	 UGLVoFzH+77sQ==
Date: Tue, 5 Dec 2023 15:37:13 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZW81mT4WqKqtLnid@lpieralisi>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205130517.GD2692119@nvidia.com>

On Tue, Dec 05, 2023 at 09:05:17AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 11:40:47AM +0000, Catalin Marinas wrote:
> > > - Will had unanswered questions in another part of the thread:
> > > 
> > >   https://lore.kernel.org/all/20231013092954.GB13524@willie-the-truck/
> > > 
> > >   Can someone please help concluding it?
> > 
> > Is this about reclaiming the device? I think we concluded that we can't
> > generalise this beyond PCIe, though not sure there was any formal
> > statement to that thread. The other point Will had was around stating
> > in the commit message why we only relax this to Normal NC. I haven't
> > checked the commit message yet, it needs careful reading ;).
> 
> Not quite, we said reclaiming is VFIO's problem and if VFIO can't
> reliably reclaim a device it shouldn't create it in the first place.

I think that as far as device reclaiming was concerned the question
posed was related to memory attributes of transactions for guest
mappings and the related grouping/ordering with device reset MMIO
transactions - it was not (or wasn't only) about error containment.

Thanks,
Lorenzo

