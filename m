Return-Path: <kvm+bounces-9592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67215861F47
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 22:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 995821C22579
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0F714CAAA;
	Fri, 23 Feb 2024 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gTIP7f6q"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895E31DDC3
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708725145; cv=none; b=pUk3wpNx9FDdet5zHYD/2sVpFC7/h0zRJ5twfJuCYe3r90jHLD/R1Ja7TUTgk8muPKZZTuIdnQ2HxkahTpL2C+42nvBLvHQ5kDOvHlUrtPHgLZLsudMhMPAvycPbFnHj6ARZR5zsTGT2INxfYHqavv56J4rzU8dhWS5pi0uEwd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708725145; c=relaxed/simple;
	bh=WghNiSEcslFUkasOpQxww+LCo1yWX13E/n+PrcQm1Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NruTnlob7f7nTO1tZr1n4iMoAmoXJQ0ch06jAwsE1HwoU/1rcjryyqXkDjsWZCDtfSFnawZepWt+2CdGKpoTu9jp/Z+Ak4f7gFXDS0EpUQdVf7/7FOdvioPqgSROt61llqAbnkjHBlC6hmUaDefGvzDbV9gukwc6Nr8v65sA/9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gTIP7f6q; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708725141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4hHqqqhFF3Gydbv6RBgXfAetBdxsg+N/xk7e231yih0=;
	b=gTIP7f6qjnayXOiMlXoD5jndqDv+4vM5rGrfvTzaU+1V9n9NzxjM+y5y1jn14ayzr0Alup
	gihCIRbnJOZmif+3rwG+dZ7aLlx/+jEluaXwtVcIJ26VjUfv/8+DzrCiF8dAC/Ei9CfmRb
	z+ouNR/5CcNUqGmcFIFNhsQB6qkfET8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 00/10] KVM: arm64: Avoid serializing LPI get() / put()
Date: Fri, 23 Feb 2024 21:52:09 +0000
Message-ID: <170872506306.206263.12047189993769691373.b4-ty@linux.dev>
In-Reply-To: <20240221054253.3848076-1-oliver.upton@linux.dev>
References: <20240221054253.3848076-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 21 Feb 2024 05:42:43 +0000, Oliver Upton wrote:
> Addressing a few more goofs that Zenghui was kind enough to point out.
> Clearly all of the bugs have been found and addressed at this point.
> 
> v2: https://lore.kernel.org/kvmarm/20240213093250.3960069-1-oliver.upton@linux.dev/
> v3: https://lore.kernel.org/kvmarm/20240216184153.2714504-1-oliver.upton@linux.dev/
> 
> v3 -> v4:
>  - Actually walk the LPI INTID range in vgic_copy_lpi_list() (Zenghui)
>  - Ensure xa_lock is taken w/ IRQs disabled, even after purging usage of
>    the lpi_list_lock (Zenghui)
>  - Document the lock ordering (Marc)
> 
> [...]

Applied to kvmarm/next, thanks!

[01/10] KVM: arm64: vgic: Store LPIs in an xarray
        https://git.kernel.org/kvmarm/kvmarm/c/1d6f83f60f79
[02/10] KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
        https://git.kernel.org/kvmarm/kvmarm/c/5a021df71916
[03/10] KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
        https://git.kernel.org/kvmarm/kvmarm/c/49f0a468a158
[04/10] KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
        https://git.kernel.org/kvmarm/kvmarm/c/2798683b8c80
[05/10] KVM: arm64: vgic: Get rid of the LPI linked-list
        https://git.kernel.org/kvmarm/kvmarm/c/9880835af78e
[06/10] KVM: arm64: vgic: Use atomics to count LPIs
        https://git.kernel.org/kvmarm/kvmarm/c/05f4d4f5d462
[07/10] KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
        https://git.kernel.org/kvmarm/kvmarm/c/a5c7f011cb58
[08/10] KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
        https://git.kernel.org/kvmarm/kvmarm/c/864d4304ec1e
[09/10] KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
        https://git.kernel.org/kvmarm/kvmarm/c/50ac89bb7092
[10/10] KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()
        https://git.kernel.org/kvmarm/kvmarm/c/e27f2d561fee

--
Best,
Oliver

