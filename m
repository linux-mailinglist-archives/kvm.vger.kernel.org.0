Return-Path: <kvm+bounces-13315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BF589498F
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 04:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A45E2864A5
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 02:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B5A1401C;
	Tue,  2 Apr 2024 02:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="lLlPDxOM"
X-Original-To: kvm@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D814B1118D;
	Tue,  2 Apr 2024 02:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712026204; cv=none; b=nRR2AGkzKWW4J+JbsjXdpJrJvdgIiKmAwOVidEOzi7xdhL5WCrMuIKP6/v2UkwKwBEeDNTabrHF3vvGa0xXyUGYibQ4WLtYwUrYs+PqIzWt0CyXnYRt/keFEk+9KzS7MZcajJMyZq/2tmXmyuExQ7yie/v87F1zpsZi7teEuhF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712026204; c=relaxed/simple;
	bh=ZejHzgaX0y9u6TAm0+5L3D9OCdZlYx5y2FcAPrC4nok=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P2FIH5J4EBBgFj1bB70vpg2iPqaQQn6gRmjjOZtAWIsla4Qy80xl3DBAbGGVN1Y/vsI9KYzyGvKxKjHjZe59TwFSe/G07HFpLxtJ2Ii4zahti6XFRZHsUKgxB4lpy5N2oU2U7rias2EaX2MPvhzfEX9rF6ar6pxVkm9KrAO6Uno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=lLlPDxOM; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1712026200;
	bh=ZejHzgaX0y9u6TAm0+5L3D9OCdZlYx5y2FcAPrC4nok=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=lLlPDxOMOC6VQRM1fE3em7ahxkIummKiqw+wGHNL3WufO7u5Q9LulnvhdZAUxCmXG
	 IROYSwo5hQ8ir8nKtBWBrZYC0VJgi3YoYQ+QK804ty1uiyveGVNjvPbDwMTy68pZ+m
	 algdOPnQ62WvPLLIW6ID9YBdSsstgZ1WbpfcLuD4=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 8B63666E6D;
	Mon,  1 Apr 2024 22:49:57 -0400 (EDT)
Message-ID: <b7d91c1a42470821983a811a16f9fc1c55cfe699.camel@xry111.site>
Subject: Re: [PATCH v7 3/7] LoongArch: KVM: Add cpucfg area for kvm
 hypervisor
From: Xi Ruoyao <xry111@xry111.site>
To: maobibo <maobibo@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, Huacai
 Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Date: Tue, 02 Apr 2024 10:49:55 +0800
In-Reply-To: <57e66ff5-1cb6-06bd-ee6f-a3c3dadd6aef@loongson.cn>
References: <20240315080710.2812974-1-maobibo@loongson.cn>
	 <20240315080710.2812974-4-maobibo@loongson.cn>
	 <4668e606-a7b5-49b7-a68d-1c2af86f7d76@xen0n.name>
	 <57e66ff5-1cb6-06bd-ee6f-a3c3dadd6aef@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-04-02 at 09:43 +0800, maobibo wrote:
> > Sorry for the late reply, but I think it may be a bit non-constructive=
=20
> > to repeatedly submit the same code without due explanation in our=20
> > previous review threads. Let me try to recollect some of the details
> > though...
> Because your review comments about hypercall method is wrong, I need not=
=20
> adopt it.

Again it's unfair to say so considering the lack of LVZ documentation.

/* snip */

>=20
> 1. T0-T7 are scratch registers during SYSCALL ABI, this is what you=20
> suggest, does there exist information leaking to user space from T0-T7
> registers?

It's not a problem.  When syscall returns RESTORE_ALL_AND_RET is invoked
despite T0-T7 are not saved.  So a "junk" value will be read from the
leading PT_SIZE bytes of the kernel stack for this thread.

The leading PT_SIZE bytes of the kernel stack is dedicated for storing
the struct pt_regs representing the reg file of the thread in the
userspace.

Thus we may only read out the userspace T0-T7 value stored when the same
thread was interrupted or trapped last time, or 0 (if the thread was
never interrupted or trapped before).

And it's impossible to read some data used by the kernel internally, or
some data of another thread.

But indeed there is some improvement here.  Zeroing these registers
seems cleaner than reading out the junk values, and also faster (move
$t0, $r0 is faster than ld.d $t0, $sp, PT_R12).  Not sure if it's worthy
to violate Huacai's "keep things simple" aspiration though.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

