Return-Path: <kvm+bounces-18669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F57F8D8538
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD91428BF5F
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B4E12F59B;
	Mon,  3 Jun 2024 14:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5/N3SaZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9330B12BEBE;
	Mon,  3 Jun 2024 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425398; cv=none; b=B7aQiEE3/ctS9rJtDXLLAaMfn08QEUzYhcv5ZjD03lGB0fud8IJZ6HKKFXDp3TKHEvbboVY72vdl3nC05tGxTEyKAKlW4K2ilYlUFduCr58NPuJm+Nq7xkvh5Z0AeDnqvgTzzJH6EhRm4rtOiiNLalvZytqDCpn4wHSUxcvzxnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425398; c=relaxed/simple;
	bh=VN1EYdGVzI7eQ6kuG8aaxlVtbs8gCuLJmQ+6hwUZTqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTSVITE0QptrzB+AYRlYE0a7O9pMDcLzRR4+F5nyatR7c7jsPRpktDqDT53t+xoDjR7qi86W4GJxRMPA1b2WTESXvA5PAHj1laJ49sXqD6h4WQXtm7NY4BKubctk57OALAqnYuG63UI81UfcXkLpe/sbcmAT7iL35X8ZBmYx1GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5/N3SaZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7237C2BD10;
	Mon,  3 Jun 2024 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425398;
	bh=VN1EYdGVzI7eQ6kuG8aaxlVtbs8gCuLJmQ+6hwUZTqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a5/N3SaZ1xQJpwu1keep5mNipu9SzLPbGjWZixe76J3Pv0Qqf/mEkB5Xvfyzy82HT
	 e4EeC02dxSUx7ClRsHwA/pKl6mDuSaRYA1l6Eu4V/Kuaj35a1BDkDs49euXzXgYBO4
	 LFdqnL7uPRvm7EJdr2RrUMtMniyk+w5GNzdYLoPCS0ng+vHYEUZg8/kinzGarGw+cy
	 fuLqqheolutfuLxOuUMqYqCx+YsZS+grrYP2q5HEevqzCcv4CurH6GVFmmhCJxC6zm
	 WgteKIZF/SJ23ZoaMGudn3613OUJLw9eQ/9D6mm2dcrvFbSuSWPpN7PAPQLkelBp2k
	 PtewUbM3z307A==
Date: Mon, 3 Jun 2024 15:36:33 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 07/13] KVM: arm64: VHE: Mark __hyp_call_panic
 __noreturn
Message-ID: <20240603143633.GH19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-8-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-8-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:13PM +0100, Pierre-Clément Tosi wrote:
> Given that the sole purpose of __hyp_call_panic() is to call panic(), a
> __noreturn function, give it the __noreturn attribute, removing the need
> for its caller to use unreachable().
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

I acked this before. Please can you preserve the tags when a patch is
reposted without any changes?

Acked-by: Will Deacon <will@kernel.org>

Will

