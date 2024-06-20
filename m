Return-Path: <kvm+bounces-20070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D05991031E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 13:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EA0F1C2207D
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804231AC249;
	Thu, 20 Jun 2024 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dG40Erzq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34BC39FD7;
	Thu, 20 Jun 2024 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718883355; cv=none; b=NA1c/z6SFpW+klYwpB0+FF6fYgZbwYul3CBAsPh9EQfbDG3EuO6ATsQDF8A+jPVsfzbk2uX+I4LLbH39+4CMiz3hheNDsw/Sc/NMmBLg+NH01iHmDvcA8dzaBJk3ahswuhtExFhLRME4qwQB8UVmYxoLIaiNJni5bClJ9aVGBjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718883355; c=relaxed/simple;
	bh=CminykxElvtsp9RCbjQJrrHIs3yDI3EQY6fMsH1tv5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOOLjmEzs9N0cxvMGsgtwdBe4r1tdjsNfipkgQwNJ//2HaDwobzzRYTUxmmCcpf1OeQSfTr5Yu/VXqf/NZaYv4ldmFiXMbpVDiJfONVTaGqxGQNpAmo3yACbTu0i+bycFlSJ5rkjzJJPKg26HFlYnDjm/iUkTHVTYAyNARAKEfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dG40Erzq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A706FC32781;
	Thu, 20 Jun 2024 11:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718883355;
	bh=CminykxElvtsp9RCbjQJrrHIs3yDI3EQY6fMsH1tv5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dG40ErzqREfWw7nrKr8404DUT0lFh0zQKO5tloS7o1cLwUUgr2N5UPgSthw8d7pKB
	 yFyUf9gVwsDUuitZrz3o4dVHRFRRWd2Vffqc/x91gdVpAIZ6mPA3atbkkCQEFMJVSX
	 M3tqIYvU0A/ULdiuvTEdY68BItt0WsF3ECpY8g4NE6hz8ad3ZLCf6d84s6PS/9VZH6
	 wOoVChiyMllEh8XM6em6/9j61/WKneO5B1SSerBslYZkf00uXIaNWdT3ZEJOeVhMZf
	 Rx80rjxl+NII9R6yeeciaFDDxWKV24PnqMsHTO8/608h0lGwCoCGPOMf3nDI8RpyT5
	 x6/C48Onk9dmQ==
Date: Thu, 20 Jun 2024 12:35:50 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v5 3/8] KVM: arm64: nVHE: Simplify invalid_host_el2_vect
Message-ID: <20240620113549.GA4625@willie-the-truck>
References: <20240610063244.2828978-1-ptosi@google.com>
 <20240610063244.2828978-4-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240610063244.2828978-4-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 10, 2024 at 07:32:32AM +0100, Pierre-Clément Tosi wrote:
> The invalid_host_el2_vect macro is used by EL2{t,h} handlers in nVHE
> *host* context, which should never run with a guest context loaded.
> Therefore, remove the superfluous vCPU context check and branch
> unconditionally to hyp_panic.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/host.S | 6 ------
>  1 file changed, 6 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

