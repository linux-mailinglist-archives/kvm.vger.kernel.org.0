Return-Path: <kvm+bounces-15287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A2A8AAF8C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32BDAB2404A
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EFE128806;
	Fri, 19 Apr 2024 13:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fcg9EK0S"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686F1128394
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713533998; cv=none; b=pI06kPOyw6oJbliIHAQG/xdLMdLUaq8J3DSZ2ME6lXhMVKcZA/k0KcZLqkCzTX/5psoJ6W9xiKcZwJieILgawqlGqgeDHZQsSUHFKF69uq7QjDaXNW1rCREggNlrKhEd5aaTWmo83pDiIL8IDwpXqqNYPWbHWar378rmJgHR54g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713533998; c=relaxed/simple;
	bh=QNZ6SrDX1ToDrj2P9pnhyb4PMu3fChzWKSro/K+DLm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjWUnUKaVXfGa0MTGGzsnGD6ibcKTgEZYDPbgkG8FrtSxOuW5urvpGecrafdxyNuZpdeUYj8bRZAxHChptkvXCnqrpm3bnJtFqw/3UBlpRaHnE9uoMztmN4EP+35nGW5VfyUHKSJbYkMf7T0rgiR9SuftyloK8p+IHQQjve6WLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fcg9EK0S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA20C072AA;
	Fri, 19 Apr 2024 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713533997;
	bh=QNZ6SrDX1ToDrj2P9pnhyb4PMu3fChzWKSro/K+DLm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fcg9EK0ShaPrUEtHUVhIDayGa0olxNXqjOEG+bksWde/rv9JV8myfw9PdBtrP22UY
	 7XY+RFYP6hgQPtNx+OjIjG+3Fz/hO3boUvA6gnsxUpvUUpvz1RtTGVrlD4h8J1hBQQ
	 OOUlKWLBNjscQNu4QtyxLgy9Y572uHOMdutNeFbYVNW90ejVQsXcFcztkLb5KNr7zt
	 a5Qc0WYysS+to8vyBROah4039qa0yZw6JGmzc0EgV4bZ0i9bXl5nAq1zefH+oSCgB+
	 LkOpFqS2iJgQGw3KSHuzcSV0QAAmD0ota2dOE45hhBVmhUQViiAe9Kz5LA6uoXyNix
	 a/eZ/p3KcDk+w==
Date: Fri, 19 Apr 2024 14:39:53 +0100
From: Will Deacon <will@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: kvm@vger.kernel.org, Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool] x86: Fix PIT2 init
Message-ID: <20240419133953.GD3148@willie-the-truck>
References: <20240415154244.2840081-1-jackmanb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415154244.2840081-1-jackmanb@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Brendan,

On Mon, Apr 15, 2024 at 03:42:44PM +0000, Brendan Jackman wrote:
> KVM docs[1] for KVM_CREATE_PIT2 say:
> 
> 	This call is only valid after enabling in-kernel irqchip support
> 	via KVM_CREATE_IRQCHIP.
> 
> This was not enforced technically, until kernel commit 9e05d9b06757
> ("KVM: x86: Check irqchip mode before create PIT"). Now I get -ENOENT.
> 
> To fix it I've just reordered the ioctls. Doing this fixes the -ENOENT
> when running a nested VM on VMX.
> 
> [1] https://www.kernel.org/doc/Documentation/virtual/kvm/api.txt
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> To: Will Deacon <will@kernel.org>
> To: Julien Thierry <julien.thierry.kdev@gmail.com>
> To: kvm@vger.kernel.org
> ---
>  x86/kvm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Thanks for the patch, but I think we already fixed this in e73a6b29f1eb
("x86: Enable in-kernel irqchip before creating PIT"). Please can you
check the latest kvmtool works for you?

Cheers,

Will

