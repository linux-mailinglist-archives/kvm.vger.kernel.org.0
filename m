Return-Path: <kvm+bounces-10009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 170B68684BD
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 00:47:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4931C1C22A4E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 23:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8951384A6;
	Mon, 26 Feb 2024 23:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NaKGaBHZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5691384A1
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 23:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708991158; cv=none; b=sHTkBAmUT6cmKNYG5DNEbBYMN8zN45agnvzuNmy8xl55PJz+xE0v0+f9nxvW11Ryf7Pw7SBIOpTgz+sZOX0LTGO0kuskXzeCkDTDrXzcq7mPKZTd6vN7g6He5hzjqFlS067HAluejq6daPIsJ7KhMols+XlLQIgml6bHrnzLEqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708991158; c=relaxed/simple;
	bh=XiKSjMhN4uvH//I4mBDWEe5PcL0ksfxy4L615WOR3f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bGI+KfxEYQC067yh5dcpI1NNZCJKI918dyRuHtIw8Re7XpsNpMMM+D8qiqE1Ilxg5xxkxByoM2jWyNrasvR995qjzo5VFjD551+P7B2U/9pPa5OiRkNU7ef4uPNQIpIL0Doa2HZxRsYpij3HpBx96wJRC4IP3mJEbqW5D0ESc40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NaKGaBHZ; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708991153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EdH1du0G5wZD6cUdSfsT1MbgK9PvHKwZ7muuiMKD95w=;
	b=NaKGaBHZCLVlpYSRjVgXamnaISV5l68zDvg3ykwj2P7sG5JFqwTKKJPKbQUQAAvHNExRkq
	/KACdnHBqpI3skPgVo2vn3IxvfvqSLRY2PcRImxTBSdVM5ZudrJdUs2cdWAxg3HoxWp7zD
	Q0H7mX3cq0nHnXgBMFatJXL1ou1tDF8=
From: Oliver Upton <oliver.upton@linux.dev>
To: wangjinchao@xfusion.com,
	shahuang@redhat.com,
	catalin.marinas@arm.com,
	ryan.roberts@arm.com,
	stefanha@redhat.com,
	yi.l.liu@intel.com,
	david@redhat.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	lpieralisi@kernel.org,
	gshan@redhat.com,
	brauner@kernel.org,
	rananta@google.com,
	alex.williamson@redhat.com,
	suzuki.poulose@arm.com,
	kevin.tian@intel.com,
	surenb@google.com,
	ricarkol@google.com,
	linus.walleij@linaro.org,
	james.morse@arm.com,
	ankita@nvidia.com,
	ardb@kernel.org,
	will@kernel.org,
	akpm@linux-foundation.org,
	maz@kernel.org,
	bhe@redhat.com,
	reinette.chatre@intel.com,
	yuzenghui@huawei.com,
	andreyknvl@gmail.com,
	linux-mm@kvack.org,
	mark.rutland@arm.com
Cc: Oliver Upton <oliver.upton@linux.dev>,
	danw@nvidia.com,
	acurrid@nvidia.com,
	apopple@nvidia.com,
	mochs@nvidia.com,
	linux-kernel@vger.kernel.org,
	aniketa@nvidia.com,
	cjia@nvidia.com,
	kvm@vger.kernel.org,
	jhubbard@nvidia.com,
	kvmarm@lists.linux.dev,
	zhiw@nvidia.com,
	kwankhede@nvidia.com,
	vsethi@nvidia.com,
	linux-arm-kernel@lists.infradead.org,
	targupta@nvidia.com
Subject: Re: [PATCH v9 0/4] KVM: arm64: Allow the VM to select DEVICE_* and NORMAL_NC for IO memory
Date: Mon, 26 Feb 2024 23:45:30 +0000
Message-ID: <170899100569.1405597.5047894183843333522.b4-ty@linux.dev>
In-Reply-To: <20240224150546.368-1-ankita@nvidia.com>
References: <20240224150546.368-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sat, 24 Feb 2024 20:35:42 +0530, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Currently, KVM for ARM64 maps at stage 2 memory that is considered device
> with DEVICE_nGnRE memory attributes; this setting overrides (per
> ARM architecture [1]) any device MMIO mapping present at stage 1,
> resulting in a set-up whereby a guest operating system cannot
> determine device MMIO mapping memory attributes on its own but
> it is always overridden by the KVM stage 2 default.
> 
> [...]

High time to get this cooking in -next. Looks like there aren't any
conflicts w/ VFIO, but if that changes I've pushed a topic branch to:

  https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/log/?h=kvm-arm64/vfio-normal-nc

Applied to kvmarm/next, thanks!

[1/4] KVM: arm64: Introduce new flag for non-cacheable IO memory
      https://git.kernel.org/kvmarm/kvmarm/c/c034ec84e879
[2/4] mm: Introduce new flag to indicate wc safe
      https://git.kernel.org/kvmarm/kvmarm/c/5c656fcdd6c6
[3/4] KVM: arm64: Set io memory s2 pte as normalnc for vfio pci device
      https://git.kernel.org/kvmarm/kvmarm/c/8c47ce3e1d2c
[4/4] vfio: Convey kvm that the vfio-pci device is wc safe
      https://git.kernel.org/kvmarm/kvmarm/c/a39d3a966a09

--
Best,
Oliver

