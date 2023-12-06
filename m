Return-Path: <kvm+bounces-3704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 633FB807397
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAF391F21979
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325343FE39;
	Wed,  6 Dec 2023 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbN6B60n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9053FB0A;
	Wed,  6 Dec 2023 15:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4468C433C7;
	Wed,  6 Dec 2023 15:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701875893;
	bh=j+CA2PrRtdABKk9fjTuTndRIHtJrAoLVlG643odbEJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IbN6B60nkT4uB0IC9JH/LsPKbKBOvFjZxllADc63zL0mymf3IT0vRnbRgYU3iO4E1
	 PzXQDILI2V5uGCuSMPHFUjDBONn02bxSvju7B7Q1XOb8lm7fEQbyTKTHt1pX91tsrT
	 THLMWsRgu3sFKO6384v5edb2RRBdLLLYE65Ts/u5KiVRDGrBR5qQ8dh6KPSva+7xt8
	 4WTUIaCN9W7xDbMrL/g1Wgfekc4nQJ84n5T1wI5Yb++gBs1/J4QjndKS+SULvVGTtz
	 e0YqRxLM5Eg1GEAuF02Xc+FYiQbCTso99PkKGwyNLWkYM7ucHqIlY5kRpqb/yht+U/
	 q+k5TLGU7XJlg==
Date: Wed, 6 Dec 2023 16:18:05 +0100
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
Message-ID: <ZXCQrTbf6q0BIhSw@lpieralisi>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
 <ZXCJ3pVbKuHJ3LTz@arm.com>
 <20231206150556.GQ2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206150556.GQ2692119@nvidia.com>

On Wed, Dec 06, 2023 at 11:05:56AM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 06, 2023 at 02:49:02PM +0000, Catalin Marinas wrote:
> > On Tue, Dec 05, 2023 at 03:48:22PM -0400, Jason Gunthorpe wrote:
> > > On Tue, Dec 05, 2023 at 07:24:37PM +0000, Catalin Marinas wrote:
> > > > On Tue, Dec 05, 2023 at 12:43:18PM -0400, Jason Gunthorpe wrote:
> > > > > What if we change vfio-pci to use pgprot_device() like it already
> > > > > really should and say the pgprot_noncached() is enforced as
> > > > > DEVICE_nGnRnE and pgprot_device() may be DEVICE_nGnRE or NORMAL_NC?
> > > > > Would that be acceptable?
> > > > 
> > > > pgprot_device() needs to stay as Device, otherwise you'd get speculative
> > > > reads with potential side-effects.
> > > 
> > > I do not mean to change pgprot_device() I mean to detect the
> > > difference via pgprot_device() vs pgprot_noncached(). They put a
> > > different value in the PTE that we can sense. It is very hacky.
> > 
> > Ah, ok, it does look hacky though (as is the alternative of coming up
> > with a new specific pgprot_*() that KVM can treat differently).
> > 
> > BTW, on those Mellanox devices that require different attributes within
> > a BAR, do they have a problem with speculative reads causing
> > side-effects? 
> 
> Yes. We definitely have had that problem in the past on older
> devices. VFIO must map the BAR using pgprot_device/noncached() into
> the VMM, no other choice is functionally OK.

Were those BARs tagged as prefetchable or non-prefetchable ? I assume the
latter but please let me know if I am guessing wrong.

Thanks,
Lorenzo

