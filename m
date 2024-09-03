Return-Path: <kvm+bounces-25794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E12796AA0A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0063B20E9B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552B21EC019;
	Tue,  3 Sep 2024 21:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYM9NJUL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833F01EC002
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 21:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398744; cv=none; b=T+Tyf2QvEgHTUIRMs8RzPDFyS8x5vHD/jpAgQlUOUZTdgu8RDXux9TIBTVPwUStWg+SPz5QwK9fqYbTccrrkwp/8y0cSOq3QnwFmu5+7V0eKYYGqVhPBLiSn4NjTzKrGaWqgRG70R31XdJInP3Ju87m/F6zYUxTqg+HaYAsfJwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398744; c=relaxed/simple;
	bh=AasIpws/ux+0oeANMHnesUahVdaXmpvjGKvMxPfVk4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLlEy2557rFHSnnEcMv7Kl/XU6AIQ++X2akeYGH0uttabfmFUv7z3XoFdEOPBrUh5m5mNBBxOjxY4imbBUJmpVJQ4g+LWz1B0B8qkQWQlYK/w6IjypdZmn9GUVaJhJ/yZuhpmMC3OIp+dC2ccE2BmeVm7KbCi1RcuYgdMOosHoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYM9NJUL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B33AC4CEC4;
	Tue,  3 Sep 2024 21:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725398744;
	bh=AasIpws/ux+0oeANMHnesUahVdaXmpvjGKvMxPfVk4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LYM9NJULdZravvDFN55W2xUUVA5gyjTM3a6k6rOv3y+hSG0F09bnOprBrDHvODiER
	 7cQnjl0aKNxhYZAMH6B0y8r76J9aYS+QyONznF0q2Ug8SZE8OzhbUw7QmBJbgcXv9c
	 RXRjsAiepiLtWBmYjftN7chtAbyST2BYWsH5mbbafG14I1agl8KocFtTBbow93VdZO
	 WKtJ1xOZL20CRz682RdD47vWebZtCuLnQHYu8VGnJy5sLwd/4hPO73KEdsD/XefEqm
	 qefyogjFfXIHDSqLYhBEAj1p97aefbfHMJPNkcyJ5KbTw1uM/waoJK2eOqjlTdUC9q
	 ufzYTw0GoNX7A==
Date: Tue, 3 Sep 2024 15:25:41 -0600
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: kvm@vger.kernel.org, x86@kernel.org,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Xu Liu <liuxu@meta.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
Message-ID: <Ztd-1QlU5FlUVb38@kbusch-mbp>
References: <20240820230431.3850991-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820230431.3850991-1-kbusch@meta.com>

On Tue, Aug 20, 2024 at 04:04:31PM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Because people would like to use this (see "Link"), interpret the VEX
> prefix and emulate mov instrutions accordingly. The only avx
> instructions emulated here are the aligned and unaligned mov.
> Everything else will fail as before.

Hey, checking back in on this since it's been a couple weeks. The only
feedback so far are either commit-log changes or cosmetic code fixes.
I'm happy to provide more details or test cases if needed. I'll also be
at LPC if in-preson discussions might be useful.

