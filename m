Return-Path: <kvm+bounces-33421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4469EB2BE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0E47188E3CD
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525501AAA32;
	Tue, 10 Dec 2024 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avoEUmP1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9B023DEB6;
	Tue, 10 Dec 2024 14:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733839670; cv=none; b=ipfsKbqxJjInaVfpqYueqhe7R+7mMwqttDAh+HxRzrVI91xwloOLcI12UzygHEDGb4SdaP31AA/nHzX9NooM4O9L4wKGWjXFKZ+B3pwe23xRu0ITv+O9KWuzEcwEz6O/LaA4LW0TUaB7UWvjMPgtsWWm3CTZWf3IwlpTvoR2o5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733839670; c=relaxed/simple;
	bh=hEUtZzuBGTA2NOGk9ts8sazRmir1XBBr6jwB7hoMZlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0ncDqNW61erdybnloWrKrmqqe+AMsXaLh/zOZIN3rSDDG6GDZU3c0V6Tm1RbFnbsupgD3/OagO2DSzC3+uBraZRwzrgaOnEu0G3isjkkzYQCYiQLOucQBxEtqw5Ngm40JQpZASZjtllS+APbUhP/uCPWg6FEkQenkR37wkKGww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avoEUmP1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C73C4CED6;
	Tue, 10 Dec 2024 14:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733839669;
	bh=hEUtZzuBGTA2NOGk9ts8sazRmir1XBBr6jwB7hoMZlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=avoEUmP1d9QdOaaXSiVgk6gC/OtmdYD96h4aD1/i0n1hksL6RqcyxtUApsBkJ5JYS
	 Urna5iTGqdKjzfW2PJPIZ3NjTei6K3Z+Z4EFbejBnOhJxEvUF5ZVUdAumLpk3uolqX
	 j5MwOyag1LeUKWgGlKxTknXH7zfto8kVef/uXuqs8oFurGsx49ugNXV1AVQy7SsgqI
	 +JqZMkepFbwmr51yoOOitu+kyqBGgeEMmvU68j9B6ljmZK4OjIj29wePjEErWpf0vy
	 qfXgHDZtFknnb90gAqURUgSVmoXqAwVn4fRAkX+RRxvcKwiS/K+041IbGMprBfqlfA
	 qtJbfIspuwQ1w==
Date: Tue, 10 Dec 2024 14:07:40 +0000
From: Will Deacon <will@kernel.org>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Message-ID: <20241210140739.GC15607@willie-the-truck>
References: <20241118131958.4609-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118131958.4609-1-ankita@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Nov 18, 2024 at 01:19:57PM +0000, ankita@nvidia.com wrote:
> The changes are heavily influenced by the insightful discussions between
> Catalin Marinas and Jason Gunthorpe [1] on v1. Many thanks for their
> valuable suggestions.
> 
> Link: https://lore.kernel.org/lkml/20230907181459.18145-2-ankita@nvidia.com [1]

That's a different series, no? It got merged at v9:

https://lore.kernel.org/all/20240224150546.368-1-ankita@nvidia.com/

Will

