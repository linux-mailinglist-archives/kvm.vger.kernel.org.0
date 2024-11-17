Return-Path: <kvm+bounces-31992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 468079D036A
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2024 13:04:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F37931F231EF
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2024 12:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C101D18C939;
	Sun, 17 Nov 2024 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="O/nK4pOx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FD9176ADE;
	Sun, 17 Nov 2024 12:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731845064; cv=none; b=b7ijKeXStfhpsnSCtPu2mnB5ARxMzmByN3xLiWoO3mvIuPmy/k/YyTGDNG6MC7uxcz1Rn+VtfTkfADTG8XsC1+d/x9rOm0mEPxYlKvPxze7XPgsyktgLvrmhAvEfSSVmTIdmCP+8m78eztT3NloLIu5PrsLmAnpd5dRFO0Kp5zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731845064; c=relaxed/simple;
	bh=W/swTHqRJXD1dpeLJ6fRt5WOVlHTTxL3ftX6njve5T0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Xp2a7VymZV9rZZ8ZghbCklOh//tNG/eiJmLawxpaBvbI3fenMLIhNPFHMfwO/3/cM95nwAYU17ZNnckAFkeShks5Y5o/sK9IcQrA9QcY84d+auWs1VKOQYOirgmzh9is1qqpUVTDNNWsjoYJF1+oUjaYI+nlDTVj8y0CCY8HYEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=O/nK4pOx; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1731845056;
	bh=iDLBEcPLnsdBaxtgoBm6ijM1a0dYsIecpZLlCOdfoe4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=O/nK4pOxgHaTKX6JcezklCGDvhMmAeuaeDbUvf9fi+KBI9sq5pP6tYnjGF0D1mpFF
	 3FgbS7McyJIiQpQzeIwi2nMKKRD0WsgySmi4Z5ss6DuxLZxnyBPlde7QxD6yT1Zcxv
	 K2LDbp5mQL+b60gFavsa9qQ5nn1sw5twvwBrY7lOIh84+e1ZQyISAgD54bpaqnWiRI
	 4Qi2KYBKXrEyDLPgPUhEBpylGVixQTb9eSISdosYCk/vVYmOpzJL9SHNb5mpKR2RPB
	 LUkKiVQ+fSj9zAom+RymQ/k84Vx/UnwlaGkwK6iEAEJHq/LBkuU4/RIpiqXlbCI/7s
	 YY+ZiEqsF0BRg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XrqDb6Rh2z4xdT;
	Sun, 17 Nov 2024 23:04:15 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org, maddy@linux.ibm.com, vaibhav@linux.ibm.com, Gautam Menghani <gautam@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20241109063301.105289-1-gautam@linux.ibm.com>
References: <20241109063301.105289-1-gautam@linux.ibm.com>
Subject: Re: [PATCH 0/3] Fix doorbell emulation for nested KVM guests in V1 API
Message-Id: <173184457526.887714.4884403618372389811.b4-ty@ellerman.id.au>
Date: Sun, 17 Nov 2024 22:56:15 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Sat, 09 Nov 2024 12:02:54 +0530, Gautam Menghani wrote:
> Doorbell emulation for nested KVM guests in V1 API is broken because of
> 2 reasons:
> 1. L0 presenting H_EMUL_ASSIST to L1 instead of H_FAC_UNAVAIL
> 2. Broken plumbing for passing around doorbell state.
> 
> Fix the trap passed to L1 and the plumbing for maintaining doorbell
> state.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/3] Revert "KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1"
      https://git.kernel.org/powerpc/c/ed351c57432122c4499be4f4aee8711d6fa93f3b
[2/3] KVM: PPC: Book3S HV: Stop using vc->dpdes for nested KVM guests
      https://git.kernel.org/powerpc/c/0d3c6b28896f9889c8864dab469e0343a0ad1c0c
[3/3] KVM: PPC: Book3S HV: Avoid returning to nested hypervisor on pending doorbells
      https://git.kernel.org/powerpc/c/26686db69917399fa30e3b3135360771e90f83ec

cheers

