Return-Path: <kvm+bounces-6493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3F7835734
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 19:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F0C2281FCD
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 18:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0310C381DC;
	Sun, 21 Jan 2024 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYRRY3l+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA32381C6
	for <kvm@vger.kernel.org>; Sun, 21 Jan 2024 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705860617; cv=none; b=BrM94zjKeNs+18XNBFj20UdJptY5R04Y5GdbNki4eHN9UqqVh/fXWA+mnL7uNlxuHADNrH3vNJK11UdYXUCaYnQcXkYtDRSHVB3aM5hFWkFxzZ9q/OiZxyNhEw+si2TQFmh4mZeE3lSmx5ssrSsHpdtdT05EVQtbNnsDgCp5oiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705860617; c=relaxed/simple;
	bh=Rl/v6qrmQdewiBGrXL8EVM0U481qtb9GIY3m4jYIpvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVLVD4ACyGcIyFqrrxg6OWPl2tsFcJzLafNgr9BppwwLXUyeHBshojZL8ykI2Tho2+Tc4XP9hcP2fBNir2NcEGW1mshKqfTedyPUrOyXHDuPG0UTumw+VXSR+cXRaj4omvIPSxF6SWc7EgLexX/BlBYLyDK/YA6m6gH/V4DpVUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYRRY3l+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F66EC433C7;
	Sun, 21 Jan 2024 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705860616;
	bh=Rl/v6qrmQdewiBGrXL8EVM0U481qtb9GIY3m4jYIpvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eYRRY3l+M5kL8+syomvwfSBrYc0/NFWHYsdbeeexl4QKwdhXJYuMvxqJHS2C9Aj5B
	 h6LFLrgwMfAKoVC46zmLDDQGH+VM2iry/k2POnqayiCO3qobdjpQaVchjYSPltew8c
	 dkagHSdXmj1KpztNCW1kfS5zNNoUMnZYn+9Frtr63CLD/xLdBgYpb8nkEyxyrPWIxP
	 SH+YFbAryQ1dI/qWfP91ZQ5RtAO3DxmzIgIhccmr1gvwv4dEBgWWZVhNFLUid1BiA6
	 511sj5khDRML/QDN3GvvMglR+kAt4BQtOsqU+YZyQXJH9j0OEXNJ6oA9P/EJGHveai
	 +kGNLGzkyl4OA==
Date: Sun, 21 Jan 2024 10:10:09 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andy Chiu <andy.chiu@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Nelson Chu <nelson.chu@sifive.com>,
	linux-riscv@lists.infradead.org, anup@brainfault.org,
	atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
	greentime.hu@sifive.com, guoren@linux.alibaba.com,
	Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
	nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com
Subject: Re: [PATCH -next v21 23/27] riscv: detect assembler support for
 .option arch
Message-ID: <20240121181009.GA1469@sol.localdomain>
References: <20240121011341.GA97368@sol.localdomain>
 <mhng-e4b5de69-859d-43ea-b35d-b568e6a621ef@palmer-ri-x1c9>
 <CABgGipW0pZCESu7dyiUdta2JtrpeMsJ3EABNjj_0GO9fbbTwQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgGipW0pZCESu7dyiUdta2JtrpeMsJ3EABNjj_0GO9fbbTwQg@mail.gmail.com>

On Sun, Jan 21, 2024 at 10:32:59PM +0800, Andy Chiu wrote:
> 
> Maybe what we really should do is to upgrade the condition check to a
> one liner shell script and grep if "Warning" is being printed. Sadly
> this warning is not failing the compilation with -Werror.
> 
> I can try forming a patch on this if it feels alright to people.

What about -Wa,--fatal-warnings ?

- Eric

