Return-Path: <kvm+bounces-20676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F3E91C0F5
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 16:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B08F5B25622
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 14:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C66F1C0046;
	Fri, 28 Jun 2024 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2QxQOJQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316F11BE843;
	Fri, 28 Jun 2024 14:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719584982; cv=none; b=kBnEBvxOS1IKJvx7vLil7XQ6XC64wXjTRA1uWWtCbqK1k1KHQiuNI7cedztUpU2iK1+HgdXeEfjXO3HTM8uGcID3bhdhrOTVIA7CeUJRmk7pqhroAgbt7NxgUG8AGienc728nJ3QR4pIeeBT4Nvt3JyWg/2DRMoBK3TiB5jyta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719584982; c=relaxed/simple;
	bh=kL2tETLKqVwjJYlaNcjDteqOWD5Jwtaof/gDNuH6kGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJO4xW/fnMpA/s1XpRtoI+wmL1ypi5hRvOiEGR3CEY2YUxJO+jxfGga1agKg+syBx+CQP18F7V9ZieJVZ8QUtVa0vQ2HrvgEdttiuaBpGnWfGF1yiHIzXkgoP65Oqx9mOj8J4K6tqAQbsjWgbnJnFhOhqAquqR2NoU1BA5FRq+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2QxQOJQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB426C116B1;
	Fri, 28 Jun 2024 14:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719584981;
	bh=kL2tETLKqVwjJYlaNcjDteqOWD5Jwtaof/gDNuH6kGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a2QxQOJQyiXjljP25DKWOu9KP3a0BdNyi92/nJyUyCRfueo0an168oQTibnWq74EJ
	 EABYn40fg1u0GnZ9Z7I7m7bRuxFhQGNhX9alAZesPa0UCBglnQU5bXtBgcHrtjniCP
	 qGxFYZ7lfkh6BQO74YXihP6Aa0PQaxMN83Mu6LoI=
Date: Fri, 28 Jun 2024 10:29:37 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Conor Dooley <conor@kernel.org>
Cc: Atish Kumar Patra <atishp@rivosinc.com>, 
	Samuel Holland <samuel.holland@sifive.com>, linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Conor Dooley <conor.dooley@microchip.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] drivers/perf: riscv: Reset the counter to
 hpmevent mapping while starting cpus
Message-ID: <20240628-quantum-sophisticated-ferret-5eaec4@lemur>
References: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
 <20240626-misc_perf_fixes-v3-2-de3f8ed88dab@rivosinc.com>
 <96ff4dd2-db66-4653-80e9-97d4f1381581@sifive.com>
 <CAHBxVyHx9hTRPosizV_yn6DUZi-MTNTrAbJdkV3049D-qsDHcw@mail.gmail.com>
 <20240626-eraser-unselect-99e68a1f5a3e@spud>
 <20240626-spyglass-clutter-4ff4d7b26dd4@spud>
 <CAHBxVyEg2uKKdikXib77JDmCKs8qDGJHvj3stsFgCgO0U9omRg@mail.gmail.com>
 <20240626-pedigree-retype-dd7f1e54ac2b@spud>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240626-pedigree-retype-dd7f1e54ac2b@spud>

On Wed, Jun 26, 2024 at 11:11:54PM GMT, Conor Dooley wrote:
> > Strange. I modified and sent the patch using b4 as well. It's missing
> > my sign off too.
> 
> `b4 shazam` should pick up trailers provided on the list, signoffs
> included. `b4 shazam -s` will add yours. TBH, I am not sure why that is
> not the default behaviour.

Some projects don't use the DCO model, so they don't require Signed-off-by
trailers.

-K

