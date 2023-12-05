Return-Path: <kvm+bounces-3613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 938DA805B27
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C47EF1C20FB8
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E8268EB6;
	Tue,  5 Dec 2023 17:33:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8559225AC;
	Tue,  5 Dec 2023 17:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC45C433C8;
	Tue,  5 Dec 2023 17:33:03 +0000 (UTC)
Date: Tue, 5 Dec 2023 17:33:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, ankita@nvidia.com,
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
Message-ID: <ZW9ezSGSDIvv5MsQ@arm.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <86bkb4bn2v.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bkb4bn2v.wl-maz@kernel.org>

On Tue, Dec 05, 2023 at 05:01:28PM +0000, Marc Zyngier wrote:
> On Tue, 05 Dec 2023 16:43:18 +0000,
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > On Tue, Dec 05, 2023 at 04:22:33PM +0000, Catalin Marinas wrote:
> > > That's an argument to restrict this feature to PCIe. It's really about
> > > fewer arguments on the behaviour of other devices. Marc did raise
> > > another issue with the GIC VCPU interface (does this even have a vma in
> > > the host VMM?). That's a class of devices where the mapping is
> > > context-switched, so the TLBI+DSB rules don't help.
> 
> There is no vma. The CPU interface is entirely under control of KVM.
> Userspace only provides the IPA for the mapping.

That's good to know. We can solve the GIC issue by limiting the
relaxation to those mappings that have a user vma. Ideally we should do
this for vfio only but we don't have an easy way to convey this to KVM.

-- 
Catalin

