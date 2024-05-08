Return-Path: <kvm+bounces-17028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 114A48C0136
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 17:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 397731C22166
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CC412836A;
	Wed,  8 May 2024 15:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftVtQqPX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1B4127E2A;
	Wed,  8 May 2024 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715183043; cv=none; b=lLWmHi5VTqW/2Fsk9ZT3jzwdhqIaTU53WIF1udPuUNm/8AzioNVwpg4MWljXTTAXVT51j//S+zOmE9njsYFS4dwcm6iENy7pfYFvrbMuuzGcwHozIIfof9WSV0lAs/BvvmpXpWA8cE3AiS6NlcbFemPuSI8MXhjH/XFg3fT8YxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715183043; c=relaxed/simple;
	bh=QIhZChes+QmKJcXg0J9sxZnDzvdbnUmSur0I0uSWFOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ah7ZOkH1in3PTRAow8PWUGoKQWREHJu+Ho08ooPZYH8szsAk/BFEjMvhQP42y/8ymZARpqimt8ulJCSuGwolCiM0wYmYIL9rGYm7fls9ra7PLfKES8N5sv18mk4Hkqu/Nnqj0otSIa/s57vnp2JDAwVjD1E++nSoABuSlqMbeng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftVtQqPX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCA6C113CC;
	Wed,  8 May 2024 15:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715183042;
	bh=QIhZChes+QmKJcXg0J9sxZnDzvdbnUmSur0I0uSWFOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftVtQqPX1vfnQHzDlNucZTgq4Eet6GFVBOx/m+tGcdEMQNdp5On/RksT8FWmF7p5+
	 5taxqbU8MjPGOFnjB0vIz8ch7xEDmPzK0uso2rjBFqHGe8+ASKmY/uKsbUrPAVskhr
	 JNqjhDYnXYt+uUX9zYWKmMIYwkuMvvNCMBB509lsHubcLOin3H8TuPTw0/VrHIABut
	 W2X1YqgLxFjm0PPCgnHiW6MLkzbjHpqfUlIP1/pcFWJFz1txYIfsCXDSyEpfbk1zJw
	 Mujb/w3vEP31S21ew82YjXSa10R8jPf/DzzAd4/HPTxH+IYuifp+Ln8Gui7lowdYPt
	 EO4EraczRAXRg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s4jSZ-00BgUI-RY;
	Wed, 08 May 2024 16:43:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Destroy mpidr_data for 'late' vCPU creation
Date: Wed,  8 May 2024 16:43:55 +0100
Message-Id: <171518298640.3700029.3551920564178293489.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240508071952.2035422-1-oliver.upton@linux.dev>
References: <20240508071952.2035422-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 08 May 2024 07:19:52 +0000, Oliver Upton wrote:
> A particularly annoying userspace could create a vCPU after KVM has
> computed mpidr_data for the VM, either by racing against VGIC
> initialization or having a userspace irqchip.
> 
> In any case, this means mpidr_data no longer fully describes the VM, and
> attempts to find the new vCPU with kvm_mpidr_to_vcpu() will fail. The
> fix is to discard mpidr_data altogether, as it is only a performance
> optimization and not required for correctness. In all likelihood KVM
> will recompute the mappings when KVM_RUN is called on the new vCPU.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Destroy mpidr_data for 'late' vCPU creation
      commit: ce5d2448eb8fe83aed331db53a08612286a137dd

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



