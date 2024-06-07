Return-Path: <kvm+bounces-19078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05428900AA6
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 18:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A031E28818B
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 16:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148F3134B2;
	Fri,  7 Jun 2024 16:46:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A81974F7;
	Fri,  7 Jun 2024 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717778808; cv=none; b=PqJVueYseoPOlrKLZ9C3DGOVXKSbk95nR8zm3aiP4FQSzffIAtRrrS8qbB53/Ukuuty54Rf5aDm38HmrNxU3k3iDZofP8ciWXWxsiEmk/laIultEm6aF+sASPkepWUwQBvWs4BD2c8N9WGUu8jvLWKu3UxZtAlsQlPGIWTUCSVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717778808; c=relaxed/simple;
	bh=/dDdFNzBjblJbkHspj7AhEQS924zK1q7V7UuQ5JIdrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUsqq0/MPcTputxMKaENcnnpHstUe9qfE7B1JTLTw1AtoKQ7aAVIEYeU8tuMfH+OP/AUXwMvbDv/UikYOFaoMVAlxNEVBvaU+yWBq+jUNz3kSVLyedQiecsqY1quTT0zefSrkvaw+sJvQL9MeVwPEukWXbgiNXcM99J+IbMh8Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216AEC2BBFC;
	Fri,  7 Jun 2024 16:46:44 +0000 (UTC)
Date: Fri, 7 Jun 2024 17:46:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Message-ID: <ZmM5cpLRbxhE_bBo@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-13-steven.price@arm.com>
 <86a5jzld9g.wl-maz@kernel.org>
 <4c363476-e5b5-42ff-9f30-a02a92b6751b@arm.com>
 <867cf2l6in.wl-maz@kernel.org>
 <ZmICEN8JvWM7M9Ch@arm.com>
 <0ea597d3-6520-4ab3-8050-d967c173bc23@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ea597d3-6520-4ab3-8050-d967c173bc23@arm.com>

On Fri, Jun 07, 2024 at 04:45:14PM +0100, Steven Price wrote:
> On 06/06/2024 19:38, Catalin Marinas wrote:
> > Anyway, we could do some hacking around gen_pool as a temporary solution
> > (maybe as a set of patches on top of this series to be easier to revert)
> > and start investigating a proper decrypted page allocator in parallel.
> > We just need to find a victim that has the page allocator fresh in mind
> > (Ryan or Alexandru ;)).
> 
> Thanks for the suggestions Catalin. I had a go at implementing something
> with gen_pool - the below (very lightly tested) hack seems to work. This
> is on top of the current series.
> 
> I *think* it should also be safe to drop the whole alignment part with
> this custom allocator, which could actually save memory. But I haven't
> quite got my head around that yet.

Thanks Steven. It doesn't look too complex and it solves the memory
wasting. We don't actually free the pages from gen_pool but I don't
think it matters much, the memory would get reused if devices are
removed and re-added.

-- 
Catalin

