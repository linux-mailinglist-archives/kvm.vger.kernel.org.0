Return-Path: <kvm+bounces-18666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2AA98D8513
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:32:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20FFAB2639A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ACEB12F386;
	Mon,  3 Jun 2024 14:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjtmHgMR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58AF57C9A;
	Mon,  3 Jun 2024 14:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425128; cv=none; b=AnU1+IAXuasVtMD+mXDB8EOQq/tFEjTdk00kSGFckmNiydMCyrSCY3QokG7UL0HQrjkDd0SRugYt1/mdUNGkc+AjCnSHs0bubOcncZKkqSLvFppvrh1hG+CKlanOhocYznb7FP3QQfdEdOyLe5E6vO4kKvR/ExLPXVC9ASUvgew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425128; c=relaxed/simple;
	bh=GNNOWqdkaJW9/A6JU7rKt1d6Jui12hkP5DFzTX8l+EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h7zvLsF3xSj1980LNgCNlu+AWCaYaro8w+LRzYTsWTssccxJUaJSBGrD6+V2iZNLGReoKLsXrA8l87vblv9jW0ZgxwwUDU4sWuufPI/ZYQOHforpfwe+PzzWuid2FFJaj211hiXti+LunxomFOrXAjA3jGROlKZi/zhMMDbU6b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjtmHgMR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62A7C2BD10;
	Mon,  3 Jun 2024 14:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425128;
	bh=GNNOWqdkaJW9/A6JU7rKt1d6Jui12hkP5DFzTX8l+EE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hjtmHgMRiCv5yA+YuNxrLlFlE7J3eZMUAR1/E8xa7QEW/ZYVl+ed3o9PX61dW/Mu8
	 rVdxt1JzuypLVSFgG0f9Rb0ao6Bvu4EXs0ZP8nDUP2OesDBylhu+phYGy++lKu+gVT
	 PTmIN2IMIYaYu732MpczC4hoEbD/bv5hZXR9BOd4vGB/cdqsCpdOwQm5YLR5cQzbDy
	 QXtnkHWvNvzRszg4YrLIGhGLkiN89/JmO6YPPxTJMC56ymN04kMTOrSB1+37msK2G1
	 5ANnhm8Uuj+pzV/W4XjDeriy4giRpbgplKwfjKUgoJjcro4frpj+sHPDrK6/OYpsQm
	 8AKw2YwoKQhVQ==
Date: Mon, 3 Jun 2024 15:32:03 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 04/13] KVM: arm64: nVHE: Add EL2h sync exception
 handler
Message-ID: <20240603143203.GE19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-5-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-5-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:10PM +0100, Pierre-Clément Tosi wrote:
> Introduce a handler for EL2h synchronous exceptions distinct from
> handlers for other "invalid" exceptions when running with the nVHE host
> vector. This will allow a future patch to handle kCFI (synchronous)
> errors without affecting other classes of exceptions.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/host.S | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

