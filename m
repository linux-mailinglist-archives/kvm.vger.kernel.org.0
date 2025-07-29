Return-Path: <kvm+bounces-53601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA1DB1477A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 07:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 387E51AA14D4
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 05:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF80223496F;
	Tue, 29 Jul 2025 05:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iuqXQjAz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180BA230D08
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 05:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753766060; cv=none; b=Aelz1rBJxV9jQG5plV277L4Gm9XH3HDR5fZHgBn51jFivAbt5cBzNjd8QXH6so1e2CmWRr9Hdz6YBVj47a013zfiZ06R8sk6vgauuX5wmO5OvsBjS5jiH0PRGvRMFnexvuNjZZb+Sj9ph6qpX6F4MTcbZ4eB5rLLMCrBoHwLtp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753766060; c=relaxed/simple;
	bh=kq8zpc5+mXSokSUjeXoDZEyNtp8semBT1Sp9byP1Ipg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nTWYyeTrh5JuQ1gOx+mOhkjQldPrhZQq6SZ9nF+JPod304361nkVZ+gYjCyPcpBGBG1QliUraN0QNUAlZAOIWT8ztaGX5hXZajSufokzJHDDAjnhl6fjonaDouXG0BpsfJKGYLphkMAn/oq7B5bF2iYweKG4N8w7HEm42Z6gHW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iuqXQjAz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93708C4CEEF;
	Tue, 29 Jul 2025 05:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753766059;
	bh=kq8zpc5+mXSokSUjeXoDZEyNtp8semBT1Sp9byP1Ipg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=iuqXQjAzLUsnzLmTtINahkLbEX3xRcP0X5nSnrN9eKNSvHSJEJprESih7qM7G1tp9
	 oUMlSAvaETkyH23f+d+OzuKHGVajnLFnPPxzRqNuXa8vVfXwK+iqXykeBhbhdKlSyA
	 gWFG/Lk+WpUmTvwDG/CBtV4lL6lvK71OB6FzlVQKUt3WUxoCM0is2p5B/mn97OQg9n
	 ecyFRXPfM/k4g797SgMjhCB4H5vZSAWlNVk4U0QK96jvmspIa4jeRL7QnNtXdZBUQH
	 C1Ztjqco7aOGdiMB27rDNXB55LhHofVmbAIG32JO4gSSeWOrM0zdIwWfxx4wFNwLGm
	 s5BfShb8hqEew==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 08/10] vfio/iommufd: Move the hwpt
 allocation to helper
In-Reply-To: <aIZw0DnAniP5G6KG@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-8-aneesh.kumar@kernel.org>
 <aIZw0DnAniP5G6KG@google.com>
Date: Tue, 29 Jul 2025 10:44:14 +0530
Message-ID: <yq5abjp3bmu1.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mostafa Saleh <smostafa@google.com> writes:

> On Sun, May 25, 2025 at 01:19:14PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> alloc_hwpt.flags =3D 0; implies we prefer stage1 translation. Hence name
>> the helper iommufd_alloc_s2bypass_hwpt().
>
> This patch moves the recently added code into a new function,
> can't this be squashed?
>

Yes. Will update the patch.

> Also, I believe that with =E2=80=9CIOMMU_HWPT_DATA_NONE=E2=80=9D, we shou=
ldn=E2=80=99t make
> any assumptions in userspace about which stage is used.
>
> The only guarantee is that IOMMU_IOAS_MAP/IOMMU_IOAS_UNMAP works.
>
> So, I believe the naming for "s2bypass" is not accurate.
>

Any suggestion w.r.t helper function name?

-aneesh

