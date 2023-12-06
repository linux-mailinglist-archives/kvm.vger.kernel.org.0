Return-Path: <kvm+bounces-3699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6FF18072FE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:49:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7D4A1C20ED6
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 14:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4AC3EA64;
	Wed,  6 Dec 2023 14:49:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFD2883D;
	Wed,  6 Dec 2023 14:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07D3C433C8;
	Wed,  6 Dec 2023 14:49:04 +0000 (UTC)
Date: Wed, 6 Dec 2023 14:49:02 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, lpieralisi@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZXCJ3pVbKuHJ3LTz@arm.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205194822.GL2692119@nvidia.com>

On Tue, Dec 05, 2023 at 03:48:22PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 07:24:37PM +0000, Catalin Marinas wrote:
> > On Tue, Dec 05, 2023 at 12:43:18PM -0400, Jason Gunthorpe wrote:
> > > What if we change vfio-pci to use pgprot_device() like it already
> > > really should and say the pgprot_noncached() is enforced as
> > > DEVICE_nGnRnE and pgprot_device() may be DEVICE_nGnRE or NORMAL_NC?
> > > Would that be acceptable?
> > 
> > pgprot_device() needs to stay as Device, otherwise you'd get speculative
> > reads with potential side-effects.
> 
> I do not mean to change pgprot_device() I mean to detect the
> difference via pgprot_device() vs pgprot_noncached(). They put a
> different value in the PTE that we can sense. It is very hacky.

Ah, ok, it does look hacky though (as is the alternative of coming up
with a new specific pgprot_*() that KVM can treat differently).

BTW, on those Mellanox devices that require different attributes within
a BAR, do they have a problem with speculative reads causing
side-effects? If not, we might as well map the whole BAR in user as
Normal NC but have the guest use the appropriate attributes within the
BAR. The VMM wouldn't explicitly access the BAR but we'd get the
occasional speculative reads.

-- 
Catalin

