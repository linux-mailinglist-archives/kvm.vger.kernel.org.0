Return-Path: <kvm+bounces-33986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B3B89F55A5
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 19:08:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEAE71777C3
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 18:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78401F9A86;
	Tue, 17 Dec 2024 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o1alYDL5"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEFB1F8F03
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458466; cv=none; b=ZZwQRLqmE1aevy6gpgR6Nb7KocbCDq+Q6LhvvEEQ0U4Urq/ny2r7ch6K0MBkfbvIHVoUZCY0vlQXOTY3u/COsYgQL3Mt6MvmtkoPeevh5twWzf1ZaIdYbUWW9Qnx2Z47a5D2JXLjNl2H6nYjm6bzOwg39FSl54Rc7wIJ07Qb51k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458466; c=relaxed/simple;
	bh=jqkqto/wE4TTKCgi/7/Xdmt2B/vG2gmyRNK4LWWebrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGaxbDPrFzMYXyialwdyaPBeuv5DLcrDGYSHTTE2F1wc6o0U4s3sXPNiSfP+HBUa7Si5ryzzAWQ7c0Mm13K1NXwvtHwalg7R073QQyoS2wbBpFCrTvOtVPpz5I6zcukTQ7UIorxKg48YhYXBIftmpohADAc4DxajXXiIqRt+w6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o1alYDL5; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 17 Dec 2024 10:00:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734458457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PkRrOqmYm8mFGf6ZziFnsHC8gAVb4/Jvhm1aIGMdXpg=;
	b=o1alYDL5oQ4U8aVIN4LJhtvgi4JR5Ey49e8Jt93GpKesUTx0JkYkIFh8FnbUMROwIWNZg6
	lZMsN6urvrxNfEWq3T+ly+eCv55DhHRMSKihuA66VsYN0xym5XSDu1/PWs39zrbZDmKbEN
	P8Tu9j/uueBx7LvvaEsb2L1rCH8Fhq0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix set_id_regs selftest for ASIDBITS
 becoming unwritable
Message-ID: <Z2G8TFw4wg7bnwzB@linux.dev>
References: <20241216-kvm-arm64-fix-set-id-asidbits-v1-1-8b105b888fc3@kernel.org>
 <875xnisocy.wl-maz@kernel.org>
 <53b40aa8-f51c-4c4e-a4ad-e6a9512e5197@sirena.org.uk>
 <86v7viqusg.wl-maz@kernel.org>
 <b13b14df-00ee-4bee-8f65-d2cb7a9bfa6b@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b13b14df-00ee-4bee-8f65-d2cb7a9bfa6b@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 17, 2024 at 03:10:28PM +0000, Mark Brown wrote:
> On Tue, Dec 17, 2024 at 01:54:39PM +0000, Marc Zyngier wrote:
> > Mark Brown <broonie@kernel.org> wrote:
> 
> > > The selftests are shipped as part of the kernel source and frequently
> > > used for testing the kernel, it's all one source base and we want to
> > > ensure that for example the test fix gets backported if the relevant
> > > kernel patch does.
> 
> > That's not what Fixes: describes. If you want to invent a new tag that
> > expresses a dependency, do that. Don't use these tags to misrepresent
> > what the patches does.
> 
> No, this isn't a new use - a Fixes: tag indicates that the referenced
> commit introduced the problem being fixed and that is exactly what's
> going on here.  Like I say the selftests are not a completely separate
> project, they are a part of the same source release as the rest of the
> kernel and it is helpful to track information like this.

A Fixes tag suggests a bug in the referenced commit, which isn't the
case here.

I agree that having some relation between the two is useful for
determining the scope of a backport, but conveniently in this case the
test failure was introduced in 6.13.

I've taken the fix for 6.13, w/ the tag dropped.

-- 
Thanks,
Oliver

