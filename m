Return-Path: <kvm+bounces-6480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80127835411
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 02:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 234261F22941
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 01:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D1028372;
	Sun, 21 Jan 2024 01:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXsNvtAZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4380328365
	for <kvm@vger.kernel.org>; Sun, 21 Jan 2024 01:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705799624; cv=none; b=Q9OJ5UDx9bj1FJjDteTvFWTpONY7vfejVV1ezjXKHIRjOMeF3lwXtkMJWBxhy/eFUSUCc/V1RRw5G2TidM9RVhwV7NZGjoc+08fnHFJQy26wuXFX5H8lfD5acFq2kpEUEc7kJxcx2H+8or34wel7wjW2uKy1kMKYHLMs9YQKV3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705799624; c=relaxed/simple;
	bh=BxWcz+0bN+GA9nXwcpJAF3xX62AbrnrZ8mAw5Ld/0lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4vfsjRV7rBiqP8BlGXEO6RxYCPsU5q7JkyJAXnHhxMPS24DkmhGgx3f+11QRP9RJGxhx9nBusvY61pXAQqXc0SnWt4FkM8UjE9ioe3E8Gl+OQhojqMqhnXH7lSvelNO4ecwlWzoMql3tSYJJg69WnjKGk36vYJgBMw9o21SsZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXsNvtAZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8646CC43390;
	Sun, 21 Jan 2024 01:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705799624;
	bh=BxWcz+0bN+GA9nXwcpJAF3xX62AbrnrZ8mAw5Ld/0lI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RXsNvtAZRtYNGIab1LSdVVsXOIOnE9ovOgZTAP/4kQdpKRBb4dPt8tayNSU5niiec
	 Oeru4K31pWnAhKC/r0NqfrN/w6ciKLUzFyOdhTGukZO6eLdLcWzUaOND0r5SqlXFv0
	 x55faG5DgFXd14Asw5gx5jL1ovcuc2Gd/ea3n+zbMifJzC1unGTaO/zL+gLgUCIBGQ
	 DxfSRvoY5K6ar/7W3DukZmxWONTgBVDpUs7s+b6lWvAXOadzqAj4AYJVSJGXGyyMRh
	 Kxp1z/YK7GIR/g4ccyvPcm5/foc1HJmSiTrSjlLMZNiWdg4cDdwwdPJGFmMCDS2aK4
	 VyWbs/pBEhmMg==
Date: Sat, 20 Jan 2024 17:13:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andy Chiu <andy.chiu@sifive.com>
Cc: linux-riscv@lists.infradead.org, palmer@dabbelt.com,
	anup@brainfault.org, atishp@atishpatra.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	vineetg@rivosinc.com, greentime.hu@sifive.com,
	guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>
Subject: Re: [PATCH -next v21 23/27] riscv: detect assembler support for
 .option arch
Message-ID: <20240121011341.GA97368@sol.localdomain>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
 <20230605110724.21391-24-andy.chiu@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605110724.21391-24-andy.chiu@sifive.com>

Hi Andy,

On Mon, Jun 05, 2023 at 11:07:20AM +0000, Andy Chiu wrote:
> +config AS_HAS_OPTION_ARCH
> +	# https://reviews.llvm.org/D123515
> +	def_bool y
> +	depends on $(as-instr, .option arch$(comma) +m)
> +	depends on !$(as-instr, .option arch$(comma) -i)

With tip-of-tree clang (llvm-project commit 85a8e5c3e0586e85), I'm seeing
AS_HAS_OPTION_ARCH be set to n.  It's the second "depends on" that makes it be
set to n, so apparently clang started accepting ".option arch -i".  What was
your intent here for checking that ".option arch -i" is not supported?  I'd
think that just the first "depends on" would be sufficient.

- Eric

