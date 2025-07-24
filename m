Return-Path: <kvm+bounces-53389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7C7B110FB
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 20:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61ABB3A4FAB
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 18:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1D724113D;
	Thu, 24 Jul 2025 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipO7Xmum"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7C2046A9
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753382199; cv=none; b=Abwgv7H4ulvZutAn/pgAIISYqCY8L0AHqWblOXLY62yGIEbea5s651+7wuzIqq5Hm9hwy08xpWqXadiM/IzU4WTm7C6qDKxojjSzP/eNSZtnmYDYxINvyawug4dEF+PMJdOziJyZW7Gn6TLQFsFwuirGDNZfgUjkssCw6/PqTVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753382199; c=relaxed/simple;
	bh=fgo5MUxlvuPmAO2sr1NbfM8LiIWsjsSkkFSP+u8/kKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3m41NDAubxvej5FvMoze1/ObQIPF8YKcVJRGn545shvM03kNGXDtOeFOGMstJlWqUTSM7TR5Pm+jCazUWX7SL79NbugbtbTx7pinaMN8xpvb6m1hVp3orxAiAahyPbE0GKdEZJjDkB2wKzQG82Y9CrkAe97fnw5W6MLkWO1dlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipO7Xmum; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5E4C4CEED;
	Thu, 24 Jul 2025 18:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753382198;
	bh=fgo5MUxlvuPmAO2sr1NbfM8LiIWsjsSkkFSP+u8/kKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ipO7Xmum/kXpXyeiTe2nNyfIcymBLcqXaLkSC1GwQIu9amY82GzLG7pIYH7/yRBEk
	 CyDEUN0dIw0nyHlfYDOBewO7zMV0PPnKqExjuiPnAgvqhyw4y0OlleGgr8qHcdXZAe
	 ME1QJoPBmfL8mc+WrBCMgRXxARogC3HJElhrO88w=
Date: Thu, 24 Jul 2025 20:36:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thijs Raymakers <thijs@raymakers.nl>
Cc: seanjc@google.com, kvm@vger.kernel.org, stable <stable@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: use array_index_nospec with indices that
 come from guest
Message-ID: <2025072441-degrease-skipping-bbc8@gregkh>
References: <aII3WuhvJb3sY8HG@google.com>
 <20250724142227.61337-1-thijs@raymakers.nl>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724142227.61337-1-thijs@raymakers.nl>

On Thu, Jul 24, 2025 at 04:22:27PM +0200, Thijs Raymakers wrote:
> min and dest_id are guest-controlled indices. Using array_index_nospec()
> after the bounds checks clamps these values to mitigate speculative execution
> side-channels.
> 
> Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
> Cc: stable <stable@kernel.org>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Nit, you shouldn't have added my signed off on a new version, but that's
ok, I'm fine with it.

> ---
>  arch/x86/kvm/lapic.c | 2 ++
>  arch/x86/kvm/x86.c   | 7 +++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)

You also forgot to say what changed down here.

Don't know how strict the KVM maintainers are, I know I require these
things fixed up...

thanks,

greg k-h

