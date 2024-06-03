Return-Path: <kvm+bounces-18655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A258D8496
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8668E1C21DC1
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166D312E1DC;
	Mon,  3 Jun 2024 14:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L79vfNNL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6A912E1C6;
	Mon,  3 Jun 2024 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717423556; cv=none; b=m9IBGQHPtvs8x7B0ifaPJD5fO8UjWW10U48hfptQUCCE2Wh6TH5mMZsoB9V+Q/GOHfthTYuR3+7zVbrSY2Q+vncEtVprI9h4NR2nDeuY7wldpk8CHce85OWO2rX98J5Q+RTUw1pxJMjz4P1uuMrDq9BVNOIb+kMe5DMEGLlzJV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717423556; c=relaxed/simple;
	bh=KxM0sXosvgWOl1B/kl5sfxWaLDGJLnpkM78Dnw3v4yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izXQ+haq2xdSXz/yACaeDN2H19HcRuMIFIy8an4/9vEFV/CDAiY09jk3ipOjKbTNwS/mixpRIT+cxWWMqQbRuyGx6CjT2h5q1hocHBp+RHJzqPKulX6v81IBCRXxTxsHXIGH+U4zrLD7Exr1dwEM62V4y2ZIbqjmc0NdMr8sbd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L79vfNNL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A27C4AF08;
	Mon,  3 Jun 2024 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717423555;
	bh=KxM0sXosvgWOl1B/kl5sfxWaLDGJLnpkM78Dnw3v4yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L79vfNNLB+Ju+kHztpoNSMno4l7UIoZ1Enc1TP9261aKRsdsLbnX5k9lH59Cjrt8N
	 qSz27uwNoOEknVXNRqs2vWE9owU/dwj/aiUkVInQBlck+lsTDY0O3w5MQ7Dst9qv2S
	 wVKtFKGdA4wxO0mE+74PbJbcE4DZbDRB7CgIvx8nZ1AYEJ6uDZ+go31vY7n487NcDk
	 eL9oEhOzwBNsVb9ytRKStOakAAnvDHIHsWM5ugx83XyUMTXdaQtV7yJdCgyUox7a02
	 xDsNp1LMiXXuRblZo2mvm21nUG3OteX/858jfFNmBJUpuQK6eQOWgzmv1+GzEe/rbq
	 JzZGTvDi2WaJQ==
Date: Mon, 3 Jun 2024 15:05:50 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 01/13] KVM: arm64: Fix clobbered ELR in sync
 abort/SError
Message-ID: <20240603140550.GB19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-2-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-2-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:07PM +0100, Pierre-Clément Tosi wrote:
> When the hypervisor receives a SError or synchronous exception (EL2h)
> while running with the __kvm_hyp_vector and if ELR_EL2 doesn't point to
> an extable entry, it panics indirectly by overwriting ELR with the
> address of a panic handler in order for the asm routine it returns to to
> ERET into the handler.
> 
> However, this clobbers ELR_EL2 for the handler itself. As a result,
> hyp_panic(), when retrieving what it believes to be the PC where the
> exception happened, actually ends up reading the address of the panic
> handler that called it! This results in an erroneous and confusing panic
> message where the source of any synchronous exception (e.g. BUG() or
> kCFI) appears to be __guest_exit_panic, making it hard to locate the
> actual BRK instruction.
> 
> Therefore, store the original ELR_EL2 in the per-CPU kvm_hyp_ctxt and
> point the sysreg to a routine that first restores it to its previous
> value before running __guest_exit_panic.
> 
> Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest context")
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kernel/asm-offsets.c         | 1 +
>  arch/arm64/kvm/hyp/entry.S              | 8 ++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
>  3 files changed, 12 insertions(+), 2 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

