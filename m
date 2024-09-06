Return-Path: <kvm+bounces-26005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A00096F3DD
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 13:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBB2AB24D39
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 11:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BCB81CBEB5;
	Fri,  6 Sep 2024 11:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="P/6kSFOx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AFE17C9B;
	Fri,  6 Sep 2024 11:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725623931; cv=none; b=IIkEoQXkTxJptk+XW2LUCGQXVMbAAvCwLbZb4PH50LgkFg3fjqGe4TxwLClQv7JeH5aQ/X/5FVx4pVHjNrCqGhfvFUmvX9Qg/8GCh9D8lWV+OrdqSmELA47Cw3vynNtRm3iChMxNDCw4cshEt3qC7WgpwHUirMdBI02NyVzl9/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725623931; c=relaxed/simple;
	bh=yLH1OR3R1sBYlXWRHCNPz0EZ7/VENmYENOXEWC90UZ0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YEncQ8NNkNIz8ZVaDH7wqEZNQUU2g2VAltQecfypniyxpyL/v+lI5FQ3AQWxxlefRdpYivYcIOdk+QMH2Fv+oIS2YTFgJEETIyOCMQmFEbOQa06KAsJ+8njytIxe3DWPH/exTGV/6dYny5krD4eEqqln38dv5OMxRcOJbA407r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=P/6kSFOx; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1725623928;
	bh=cldesPwGA3cZ3Mnb0PpJcexZU9oMOQA4ghaP4EakUWc=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=P/6kSFOxg8uOxdsmJiaEGAZdb8+7xUaZaff7jG8LaOCfEShMfx61tEPKXmGKT+sJv
	 CSoz+p1ARNsn0FExzPC27np14MKQvqyDxJOoMVgIeKw1ag6BHz3fMIuRYAG8BfP0Gt
	 HhMOTL5Va2sAxdz6ns2Gpe81rWuAgmdgIOK+KfZ3D942BmR3/zV5K/lxDr4hVzuB1E
	 h+vheTexdhgX235LsYLkZC4MuvONyZaGhmE6LYsVYKx/RmKqvMXERolo7xU4vDKNww
	 Vg3NRmzZOf+CdSsjyDDtAt82yz6Bb5stZm793QW0TqN9A39iDGqLwFwlOLjBt2+kyB
	 PGUkOndvlm+Ig==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4X0ZWX48DNz4wy9;
	Fri,  6 Sep 2024 21:58:48 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, alexs@kernel.org
In-Reply-To: <20240816093313.327268-1-alexs@kernel.org>
References: <20240816093313.327268-1-alexs@kernel.org>
Subject: Re: [PATCH] KVM: PPC: remove unused varible
Message-Id: <172562385033.469466.5795969470712332228.b4-ty@ellerman.id.au>
Date: Fri, 06 Sep 2024 21:57:30 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Fri, 16 Aug 2024 17:33:12 +0800, alexs@kernel.org wrote:
> During build testing, we found a error:
> /arch/powerpc/kvm/book3s_hv.c:4052:17: error: variable 'loops' set but not used [-Werror,-Wunused-but-set-variable]
>                 unsigned long loops = 0;
> 1 error generated.
> 
> Remove the unused variable could fix this.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: remove unused varible
      https://git.kernel.org/powerpc/c/46765aaec4d78b9fef59e647ab228283991de075

cheers

