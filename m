Return-Path: <kvm+bounces-20071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B65C5910327
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 13:39:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54715B21948
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8A21AC226;
	Thu, 20 Jun 2024 11:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg5ms+NU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9101ABCD5;
	Thu, 20 Jun 2024 11:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718883461; cv=none; b=BoDd5TuqMo7o+6IFtgTkCRf56OGqimlrtwwtRkzEYwkv8NJfQOwcRlK1TA1MCGZzMJd+djxPRJ7h7ueE+azYZJ/jXQGgzbeoJnCma7Zxh7NzMjTsJu0IQzCVUI3eBIQ0k278SSlXE1MKla28YBSbWr5RGL7Zh2XjhxrYOXKT56Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718883461; c=relaxed/simple;
	bh=7Bq8zOBLE3RaLVh77HyqeG7aK9VtXXSgvxiQB9pjHmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJL/ibNP9brCzR/QuCn6V/1cq26anJnuj0NFfxnkCsg4HgkUeejH497f5YuxoZE8Jfb2Wm+LGymBoh+SaqETfB6FuqMmlGOXsXwqy0l5mc31JHU15iDTGBTCuberSnoLDYE0x5QdUi98DSEIfEocto4DM8fQ6cqSOQosp0DTBcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kg5ms+NU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB5BC32781;
	Thu, 20 Jun 2024 11:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718883460;
	bh=7Bq8zOBLE3RaLVh77HyqeG7aK9VtXXSgvxiQB9pjHmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kg5ms+NUfHJmWjOtFBau4YwLhhjITB2a31C9s4oU4VOaIvuOPaeoMqhtOmhBpHzdm
	 zWWy/+RCxVJAy5NviLAtoIFxYlgcSnHxsOenCkivlE2HOsDRPx65NfVqwyCDxVE8vy
	 1dB67DxvP6SoNz8uYsjwYvwqItplx5al8Zt2/oQDiwCyAgpA9xUB+X5aNfze+Mlaxf
	 fF4ZPgBH+in4af75Xp156y2ZWnwRZwokqk+CGW28dMJBZw+nlO8BceCMIva5aeX2Lq
	 jA+jfi/tbcthdXhEWD4xbjj0QPOYIFXqAITX4X/eEuP4hpjBOXlxYML93xLrXAcxDG
	 W48jJFod54E0w==
Date: Thu, 20 Jun 2024 12:37:35 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v5 2/8] KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
Message-ID: <20240620113735.GB4625@willie-the-truck>
References: <20240610063244.2828978-1-ptosi@google.com>
 <20240610063244.2828978-3-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240610063244.2828978-3-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 10, 2024 at 07:32:31AM +0100, Pierre-Clément Tosi wrote:
> Fix the mismatch between the (incorrect) C signature, C call site, and
> asm implementation by aligning all three on an API passing the
> parameters (pgd and SP) separately, instead of as a bundled struct.
> 
> Remove the now unnecessary memory accesses while the MMU is off from the
> asm, which simplifies the C caller (as it does not need to convert a VA
> struct pointer to PA) and makes the code slightly more robust by
> offsetting the struct fields from C and properly expressing the call to
> the C compiler (e.g. type checker and kCFI).
> 
> Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h   |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 24 +++++++++++++-----------
>  arch/arm64/kvm/hyp/nvhe/setup.c    |  4 ++--
>  3 files changed, 17 insertions(+), 15 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

