Return-Path: <kvm+bounces-21174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E7E92B8FC
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD862285274
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB79715886D;
	Tue,  9 Jul 2024 12:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UoZFPiWI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83CB12DDAE;
	Tue,  9 Jul 2024 12:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720526660; cv=none; b=V6P4cn7g1sFMBq1zZr419GoaJ5dnENxFBveUyaC0TXEO0OUBAdnJolkJNvZwvFHOzy9P1aN9Xv3mnXwy49Vx1U1jc0IZ9VKvtfUMRj4Sk4Lb0WnrabeCPtInsKkf8mUQw3TcFpuQSDG86eITW8fJVpKcR9lKcXBuVgyY3h/CEqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720526660; c=relaxed/simple;
	bh=SrhoJeKBbAEYzxdE1V+GdZPDntsSpImr4rqlfBA4UyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXqHwJ+Nj+9BxXye5E+8zi582BatdplC1yRZyrG0p3QZZluSAfA2/tD6sqyXaNDqD0cKO+7YaqOsZViFMR01Jiv9Bp89631CluizlxLqBBKYqmaIhMjfVeZgxcG9sutin3trgGPaTxkZRbQsSvxGDySSKxBhQxuHWQh+C5caV/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UoZFPiWI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96878C3277B;
	Tue,  9 Jul 2024 12:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720526659;
	bh=SrhoJeKBbAEYzxdE1V+GdZPDntsSpImr4rqlfBA4UyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UoZFPiWIQppoyym1oPlAXiIL3Yh/A68blo9/dr4qFRjqIg8EYAsS9dInpbuvzJddz
	 6L6zwOvxFjTJAJF/LPajTp32MdzifK0G5z6uy4MQifS0pHfKk5RcmsGMXfnwYJmK1A
	 PUC1t4vI4V6WUm+8xwXtbdKdhozP0AcyT6boR4bmOapfI6ssuO9lohsu8xMg1tVmje
	 5PuOUMiItONrexD8xXShpaM+Q76dp6qIxKHt9CKu9/x/Ur2jNN/21pCbLv1oS+jJye
	 HtwYmA0g8onmTz8Qz55CJzaFi7YBmLdlRmJ0rWLXSmJ7HHWgLjLRKgIn3aqkXvypeW
	 Mtk0Cxf2msmZg==
Date: Tue, 9 Jul 2024 13:04:13 +0100
From: Will Deacon <will@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v4 00/15] arm64: Support for running as a guest in Arm CCA
Message-ID: <20240709120412.GE13242@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-1-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Steven,

On Mon, Jul 01, 2024 at 10:54:50AM +0100, Steven Price wrote:
> This series adds support for running Linux in a protected VM under the
> Arm Confidential Compute Architecture (CCA). This has been updated
> following the feedback from the v3 posting[1]. Thanks for the feedback!
> Individual patches have a change log. But things to highlight:

Hold onto your hat, I'm going to dust off our pKVM protected guest
changes and see what we can share here! I've left a few comments on the
series, but the main differences seem to be:

  - You try to probe really early
  - You have that horrible split IPA space thing from the RSI spec

but some of the mechanisms are broadly similar (e.g. implementing the
set_memory_*crypted() API).

Hopefully I can give your GIC changes a spin, too.

Just one minor (but probably annoying) comment:

>  arch/arm64/Kconfig                            |   3 +
>  arch/arm64/include/asm/fixmap.h               |   2 +-
>  arch/arm64/include/asm/io.h                   |   8 +-
>  arch/arm64/include/asm/mem_encrypt.h          |  17 ++
>  arch/arm64/include/asm/pgtable-hwdef.h        |   6 -
>  arch/arm64/include/asm/pgtable-prot.h         |   3 +
>  arch/arm64/include/asm/pgtable.h              |  13 +-
>  arch/arm64/include/asm/rsi.h                  |  64 ++++++
>  arch/arm64/include/asm/rsi_cmds.h             | 134 +++++++++++
>  arch/arm64/include/asm/rsi_smc.h              | 142 ++++++++++++
>  arch/arm64/include/asm/set_memory.h           |   3 +
>  arch/arm64/kernel/Makefile                    |   3 +-
>  arch/arm64/kernel/efi.c                       |   2 +-
>  arch/arm64/kernel/rsi.c                       | 104 +++++++++
>  arch/arm64/kernel/setup.c                     |   8 +
>  arch/arm64/mm/init.c                          |  10 +-
>  arch/arm64/mm/pageattr.c                      |  76 ++++++-
>  drivers/firmware/psci/psci.c                  |  25 +++
>  drivers/irqchip/irq-gic-v3-its.c              | 142 +++++++++---
>  drivers/virt/coco/Kconfig                     |   2 +
>  drivers/virt/coco/Makefile                    |   1 +
>  drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>  drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>  .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
>  include/linux/psci.h                          |   5 +
>  25 files changed, 953 insertions(+), 44 deletions(-)
>  create mode 100644 arch/arm64/include/asm/mem_encrypt.h
>  create mode 100644 arch/arm64/include/asm/rsi.h
>  create mode 100644 arch/arm64/include/asm/rsi_cmds.h
>  create mode 100644 arch/arm64/include/asm/rsi_smc.h
>  create mode 100644 arch/arm64/kernel/rsi.c
>  create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>  create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>  create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

Any chance of some documentation, please?

Cheers,

Will

