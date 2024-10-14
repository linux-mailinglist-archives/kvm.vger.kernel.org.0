Return-Path: <kvm+bounces-28745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FFE299C8DA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C7101F214CE
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733C619D065;
	Mon, 14 Oct 2024 11:26:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D0933C5;
	Mon, 14 Oct 2024 11:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905172; cv=none; b=UNZzV9+QRnyLNT02B5OdexqWAw3cOr9C7ufrbNQgM2ghiIO3acOaOg09F9aZ3CAPfQ2DNJze8QmJrmSKtGF3Eytpi38kUr8uivs5AmKXb2H2NhugVhYS812m74641GO9iWYdvwqydWXkhapYoYaFzhNMgdOT4UiFBP7/++QLwXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905172; c=relaxed/simple;
	bh=KE+1RV7m2FOGPLNhNSEGqdDGgzbjlAE85XtRMREqhd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jr2XLTVDRnI5X55ZesHN4QRXxZSnkwQTZViei0Mhne1FO+vDYheT99g6yPNWr5tOFVzwA+aaXviHQpMZ7bTPzL2DCeLmSSYxA9CtlID/ysDzP0M6gfpHwTSsvYB0oedW+Nap0OlYw9KXgKaAgoWvdHPSKusY5v3YEJCr/qhkVMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43780 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t0JD8-006HZk-B0; Mon, 14 Oct 2024 13:26:04 +0200
Date: Mon, 14 Oct 2024 13:26:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julia Lawall <Julia.Lawall@inria.fr>
Cc: linux-nfs@vger.kernel.org, kernel-janitors@vger.kernel.org,
	vbabka@suse.cz, paulmck@kernel.org, Tom Talpey <tom@talpey.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>, Neil Brown <neilb@suse.de>,
	linux-can@vger.kernel.org, bridge@lists.linux.dev,
	b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	ecryptfs@vger.kernel.org, linux-block@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 00/17] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <Zwz_yU8PnqU9Ngg5@calendula>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241013201704.49576-1-Julia.Lawall@inria.fr>
X-Spam-Score: -1.9 (-)

On Sun, Oct 13, 2024 at 10:16:47PM +0200, Julia Lawall wrote:
> Since SLOB was removed and since
> commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
> it is not necessary to use call_rcu when the callback only performs
> kmem_cache_free. Use kfree_rcu() directly.

Applied and squashed into single patch for netfilter these patches:

[17/17] netfilter: xt_hashlimit: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
[16/17] netfilter: expect: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
[15/17] netfilter: nf_conncount: replace call_rcu by kfree_rcu for simple kmem_cache_free callback

this update is now flying to net-next.

Thanks

