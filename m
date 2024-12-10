Return-Path: <kvm+bounces-33406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57CD09EADEC
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 11:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 990192815BE
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881A01DC9A8;
	Tue, 10 Dec 2024 10:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="samgMV8l"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0F023DE8D;
	Tue, 10 Dec 2024 10:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733826242; cv=none; b=oYMY2RhghoVk0m61/07g5wIunM3jXdKBMvb6ZNwmQD9k7o20Ry0TdOLHmS+TjzzZpRE2P5snIQGNoZehPn/Pn1Om+qyjgr540J9FFbs5MVlWGrEQeEq9onMIRnP5gqX6PLkHbCp2vSvf5k32Nkn/8yyhgkrWR9e6TqfAiuh3FaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733826242; c=relaxed/simple;
	bh=d2qRz96W+zzRUClUbgOOKxJ0mXPbo1fn2u5jwVPZ+Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVyxJ8D2bd5OuVSharr80fwSdeQG21L5jNEkr+gw7Sbic7XPIWALE9U1BdQsHNOgXgCQtqp4fuGZzq70SFzP/vV8lmM1tls9nL2rpYEkPXgQ4b723Ux+SEDPAKqdxXtNPoXhWpCtrpHpgkRQbNe3lZa/UC9Nxi+DPp7lTv2qi2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=samgMV8l; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1127)
	id C5E572047205; Tue, 10 Dec 2024 02:24:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C5E572047205
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1733826240;
	bh=DPYMgWfskJHty1Ll2/CntEup+SB0EH1CejhaB1TeA+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=samgMV8lc+4BKtqrY3MdpjbaMFNj5ASxZsRQomk4bc4rRPkZ+gz11yAVOdGw/Cyjj
	 4n5KRkZhKqZhlUayg6P/hDN6JKhQGNdKxuJEiHxhLjk2GBEGkK7+QNqwlaIqvXHGrv
	 gPIXB3grguiGxZQOKkVG22RZerDPbyuuSbQ+G0ls=
Date: Tue, 10 Dec 2024 02:24:00 -0800
From: Saurabh Singh Sengar <ssengar@linux.microsoft.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>, Long Li <longli@microsoft.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH v2 0/2] MANA: Fix few memory leaks in mana_gd_setup_irqs
Message-ID: <20241210102400.GA2391@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20241209175751.287738-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209175751.287738-1-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Dec 09, 2024 at 12:57:49PM -0500, Maxim Levitsky wrote:
> Fix 2 minor memory leaks in the mana driver,
> introduced by commit
> 
> 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (2):
>   net: mana: Fix memory leak in mana_gd_setup_irqs
>   net: mana: Fix irq_contexts memory leak in mana_gd_setup_irqs
> 
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> -- 
> 2.26.3
> 
> 

Thanks for fixing this, for the series
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>

could have been a single patch, though


