Return-Path: <kvm+bounces-31993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C48959D0376
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2024 13:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F7CFB2553A
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2024 12:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB3E192D95;
	Sun, 17 Nov 2024 12:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="bHCwnzmC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE3C1885A5;
	Sun, 17 Nov 2024 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731845066; cv=none; b=E3OUlUdEmIDEBQYnBYNErJoDcOQ/LN7pCV2xioLDnSwdNh/aGYb1Dwjm4fykRt9CT5JXO+hyfn3xi0B0USD97BB0Fxn+sEyuXmFVQFEtdtJ6tX//EjpJKFG5i9TLnRBb0Ul/weencjIKbEfef26z77dHQHRW7cPjRGnLkR4jOGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731845066; c=relaxed/simple;
	bh=H6Q/+kkZnvVk8G0hRNlWD8uGHYHGc/V8PwsN7PfAurg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MhpWE9ng4LFFDiXR/Vmz3mkdbN4ryriW4f33Pnxur91l8rG2j6tiJGZBGjFPi9Ne4+eWX8URrXuVhuNQSABixFpbbXFO3n9tC/0gWmdPJB/v2lgC8grPBjfKm6zuafnN46DXVg8qGtv2rMSZnqKWAV1nPE6VCjxdFhbBie2n5ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=bHCwnzmC; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1731845059;
	bh=tllPr++YWNmN/ICehcrJsGBTpJU5ev+6G1o94E8aVEA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=bHCwnzmC4Wn699TTaIvMmA7oqAQUCB0vBZAcYQFnrPziGiTbunbYU+CXdS38yDvH6
	 YU112WNOjKnnI7JSMJzmw/a0svprG00zS9a6LPP4NJJT/jjzlFbVdAm/RM/h/U+tns
	 TsykHb5IN7FOSJM573KL+qqNfifuTL8r1hG6UNvh5joUZD+KBNkc1Fn7IYJrs5Ptwk
	 QPaqtA4agDbcLESUFhw4fys+mFWvc6kPxuKH/D9lsAIxlZt3ypiZTruEU9Mv61lufm
	 a1hIO9QaUkphJcq/soI8cLFSVRrGlaI+MEFOmOa7tMCM3TlCNsxG9p8p3+SqPMR261
	 Neh+mkXQjvunQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XrqDc2cRjz4xdS;
	Sun, 17 Nov 2024 23:04:16 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linux-nfs@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>
Cc: kernel-janitors@vger.kernel.org, vbabka@suse.cz, paulmck@kernel.org, Tom Talpey <tom@talpey.com>, Dai Ngo <Dai.Ngo@oracle.com>, Olga Kornievskaia <okorniev@redhat.com>, Neil Brown <neilb@suse.de>, linux-can@vger.kernel.org, bridge@lists.linux.dev, b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com, netdev@vger.kernel.org, ecryptfs@vger.kernel.org, linux-block@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
In-Reply-To: <20241013201704.49576-1-Julia.Lawall@inria.fr>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
Subject: Re: (subset) [PATCH 00/17] replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Message-Id: <173184457524.887714.2708612402334434298.b4-ty@ellerman.id.au>
Date: Sun, 17 Nov 2024 22:56:15 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Sun, 13 Oct 2024 22:16:47 +0200, Julia Lawall wrote:
> Since SLOB was removed and since
> commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
> it is not necessary to use call_rcu when the callback only performs
> kmem_cache_free. Use kfree_rcu() directly.
> 
> The changes were done using the following Coccinelle semantic patch.
> This semantic patch is designed to ignore cases where the callback
> function is used in another way.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[13/17] KVM: PPC: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
        https://git.kernel.org/powerpc/c/1db6a4e8a3fc8ccaa4690272935e02831dc6d40d

cheers

