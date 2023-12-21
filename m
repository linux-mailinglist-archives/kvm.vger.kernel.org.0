Return-Path: <kvm+bounces-5095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B17CA81BCDC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 18:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E33C287C16
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 17:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29F46280D;
	Thu, 21 Dec 2023 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNV7lZS0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14D559918;
	Thu, 21 Dec 2023 17:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D50C433C8;
	Thu, 21 Dec 2023 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703179018;
	bh=bDav0XbsAfuTS75hQIrAGbf6XOHLOBml3F4jrPJKbRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sNV7lZS04yNfQwBOYBAjWpKOF+0V2PPVAW68IkXvXWxedJEnFFhibjmEp3yYsxluM
	 QZv5qNHowjdEWDoJwnYNeOtH0vBKQJ+lsgvXKSpoX1NXUWE+maLerg1iZ/5KQFAebZ
	 n7QFC8A2JK4Fbe+cnDjhHmYJWUBm1RiBW2Us0yy2U/u93Zvbl93f8Ohs72AzTpmBmP
	 ufO+nqrK3HupBJMJ2oXHpxdvbWGZWoNZu1GZZ7s2B2K07g3cJL7UUBhkuFlTki609y
	 EngdiAURpPL2ToYxfKp72oEKGnwF64ErvAMSS6TfTlc1S5ulyHFmI+SNGregsIPAmi
	 zfO8K47XcAEyA==
Date: Thu, 21 Dec 2023 18:16:48 +0100
From: Simon Horman <horms@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Shakeel Butt <shakeelb@google.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: add netmem_ref to skb_frag_t
Message-ID: <20231221171648.GC1056991@kernel.org>
References: <20231220214505.2303297-1-almasrymina@google.com>
 <20231220214505.2303297-4-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220214505.2303297-4-almasrymina@google.com>

On Wed, Dec 20, 2023 at 01:45:02PM -0800, Mina Almasry wrote:
> Use netmem_ref instead of page in skb_frag_t. Currently netmem_ref
> is always a struct page underneath, but the abstraction allows efforts
> to add support for skb frags not backed by pages.
> 
> There is unfortunately 1 instance where the skb_frag_t is assumed to be
> a bio_vec in kcm. For this case, add a debug assert that the skb frag is
> indeed backed by a page, and do a cast.
> 
> Add skb[_frag]_fill_netmem_*() and skb_add_rx_frag_netmem() helpers so
> that the API can be used to create netmem skbs.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>

...

> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 65d1f6755f98..3180a54b2c68 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -636,9 +636,15 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
>  		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
>  			msize += skb_shinfo(skb)->frags[i].bv_len;
>  
> +		/* The cast to struct bio_vec* here assumes the frags are
> +		 * struct page based. WARN if there is no page in this skb.
> +		 */
> +		DEBUG_NET_WARN_ON_ONCE(
> +			!skb_frag_page(&skb_shinfo(skb)->frags[0]));
> +
>  		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE,
> -			      skb_shinfo(skb)->frags, skb_shinfo(skb)->nr_frags,
> -			      msize);
> +			      (const struct bio_vec *)skb_shinfo(skb)->frags,
> +			      skb_shinfo(skb)->nr_frags, msize);
>  		iov_iter_advance(&msg.msg_iter, txm->frag_offset);
>  
>  		do {

Hi Mina,

something isn't quite right here.

  ...//kcmsock.c:637:39: error: no member named 'bv_len' in 'struct skb_frag'
  637 |                         msize += skb_shinfo(skb)->frags[i].bv_len;
      |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~ ^

-- 
pw-bot: changes-requested

