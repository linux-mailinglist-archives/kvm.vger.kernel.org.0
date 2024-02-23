Return-Path: <kvm+bounces-9555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9CFC8618AC
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB8861C25549
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11EB312B168;
	Fri, 23 Feb 2024 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kE6gJjYI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DFD1292C6;
	Fri, 23 Feb 2024 17:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708707732; cv=none; b=hJ7Xwan9vi8gOtjExLPs19fxSqVRJP1qALjFlKb/y8zh5LYGvFJRABBDwcQuRD+obTarUyCdtuwcx5LFpWtK15O//ZehRvjzvZ+nZAeg50EbizIj9sULr6Rw2g90TvWDYrCp9nsFdfmtr8eXHBtQwwIcuv49EkkPx/VP1MkcZ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708707732; c=relaxed/simple;
	bh=bK6MUj0ihY6O0q0AWMV5Wk/jMqKJGmt8hsDBwlu4A6Y=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rXqje48o10psr6h76ylqXEcU41z4HZ1coIR31xo0l8SFH2jrNEwDOg6KDGJdky41V+xKSHCVbbFy9MyX/iEVa8vIIhmLRtfVCxV5k4vFlEfenkP8naPbXPg2Go/qokxgH+/n8jehLtYduCfa/+YXDDfbwfTTgjYa7XonTdMwHMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kE6gJjYI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDAAC433C7;
	Fri, 23 Feb 2024 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708707731;
	bh=bK6MUj0ihY6O0q0AWMV5Wk/jMqKJGmt8hsDBwlu4A6Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kE6gJjYIsGH8AsPpO83eJ+g/DPLuomiNo+JyVL51HgR+r0a2J8av5JA+Yg2fJkl8M
	 QfVisl5FK+CadKD8UhtrEm/6qymZvkFLRE5zBr3RQ8BAVpeo7OJ+pkhIetLorVaorB
	 VtV6WgIc+DVZd/Jv2jlUFRRyze2X+GMgeIVC4V0I91zcFHHWwVfXhnL+P1UgZqO6Zv
	 4L192KNlIg0rc1cE9kxCkw1EG5RJupdIe98kG4YzOG/hQuz21XtAs0YVLKM2XdxIk2
	 g+M0X15L6NZnVaRixdvEBj8GudTieYGEf46FdKdS1TD39uq/W36ZkWwir918d56WFo
	 +E5swKTwgmj8g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rdYw5-006A9I-0t;
	Fri, 23 Feb 2024 17:02:09 +0000
Date: Fri, 23 Feb 2024 17:02:08 +0000
Message-ID: <86jzmv2jxr.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>,
	<oliver.upton@linux.dev>,
	<james.morse@arm.com>,
	<suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>,
	<reinette.chatre@intel.com>,
	<surenb@google.com>,
	<stefanha@redhat.com>,
	<brauner@kernel.org>,
	<catalin.marinas@arm.com>,
	<will@kernel.org>,
	<mark.rutland@arm.com>,
	<alex.williamson@redhat.com>,
	<kevin.tian@intel.com>,
	<yi.l.liu@intel.com>,
	<ardb@kernel.org>,
	<akpm@linux-foundation.org>,
	<andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>,
	<gshan@redhat.com>,
	<shahuang@redhat.com>,
	<ricarkol@google.com>,
	<linux-mm@kvack.org>,
	<lpieralisi@kernel.org>,
	<rananta@google.com>,
	<ryan.roberts@arm.com>,
	<david@redhat.com>,
	<linus.walleij@linaro.org>,
	<bhe@redhat.com>,
	<aniketa@nvidia.com>,
	<cjia@nvidia.com>,
	<kwankhede@nvidia.com>,
	<targupta@nvidia.com>,
	<vsethi@nvidia.com>,
	<acurrid@nvidia.com>,
	<apopple@nvidia.com>,
	<jhubbard@nvidia.com>,
	<danw@nvidia.com>,
	<kvmarm@lists.linux.dev>,
	<mochs@nvidia.com>,
	<zhiw@nvidia.com>,
	<kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/4] kvm: arm64: allow the VM to select DEVICE_* and NORMAL_NC for IO memory
In-Reply-To: <20240220072926.6466-1-ankita@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ankita@nvidia.com, jgg@nvidia.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com, brauner@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, alex.williamson@redhat.com, kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org, andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com, shahuang@redhat.com, ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org, rananta@google.com, ryan.roberts@arm.com, david@redhat.com, linus.walleij@linaro.org, bhe@redhat.com, aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev, mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 20 Feb 2024 07:29:22 +0000,
<ankita@nvidia.com> wrote:
> 
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Currently, KVM for ARM64 maps at stage 2 memory that is considered device
> with DEVICE_nGnRE memory attributes; this setting overrides (per
> ARM architecture [1]) any device MMIO mapping present at stage 1,
> resulting in a set-up whereby a guest operating system cannot
> determine device MMIO mapping memory attributes on its own but
> it is always overridden by the KVM stage 2 default.
> 
> This set-up does not allow guest operating systems to select device
> memory attributes independently from KVM stage-2 mappings
> (refer to [1], "Combining stage 1 and stage 2 memory type attributes"),
> which turns out to be an issue in that guest operating systems
> (e.g. Linux) may request to map devices MMIO regions with memory
> attributes that guarantee better performance (e.g. gathering
> attribute - that for some devices can generate larger PCIe memory
> writes TLPs) and specific operations (e.g. unaligned transactions)
> such as the NormalNC memory type.
> 
> The default device stage 2 mapping was chosen in KVM for ARM64 since
> it was considered safer (i.e. it would not allow guests to trigger
> uncontained failures ultimately crashing the machine) but this
> turned out to be asynchronous (SError) defeating the purpose.
> 
> For these reasons, relax the KVM stage 2 device memory attributes
> from DEVICE_nGnRE to Normal-NC.
> 
> Generalizing to other devices may be problematic, however. E.g.
> GICv2 VCPU interface, which is effectively a shared peripheral, can
> allow a guest to affect another guest's interrupt distribution. Hence
> limit the change to VFIO PCI as caution. This is achieved by
> making the VFIO PCI core module set a flag that is tested by KVM
> to activate the code. This could be extended to other devices in
> the future once that is deemed safe.
> 
> [1] section D8.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
> 
> Applied over v6.8-rc5.

For the series,

Reviewed-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Without deviation from the norm, progress is not possible.

