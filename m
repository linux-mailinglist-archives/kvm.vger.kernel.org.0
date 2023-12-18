Return-Path: <kvm+bounces-4720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E90816E0D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 13:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 399381C2354D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 12:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896D97EFAF;
	Mon, 18 Dec 2023 12:39:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648697D615;
	Mon, 18 Dec 2023 12:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Stzt04K2xz1Q6vn;
	Mon, 18 Dec 2023 20:39:36 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id EFB141800B9;
	Mon, 18 Dec 2023 20:39:50 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 18 Dec
 2023 20:39:50 +0800
Subject: Re: [PATCH net-next v2 3/3] net: add netmem_t to skb_frag_t
To: Mina Almasry <almasrymina@google.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Stefano
 Garzarella <sgarzare@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	=?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Shakeel Butt
	<shakeelb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <20231217080913.2025973-1-almasrymina@google.com>
 <20231217080913.2025973-4-almasrymina@google.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1195676f-59a4-40d8-b459-d2668eb8c5fe@huawei.com>
Date: Mon, 18 Dec 2023 20:39:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231217080913.2025973-4-almasrymina@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)

On 2023/12/17 16:09, Mina Almasry wrote:
> Use netmem_t instead of page directly in skb_frag_t. Currently netmem_t
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
> 

...

>  
> -typedef struct bio_vec skb_frag_t;
> +typedef struct skb_frag {
> +	struct netmem *bv_page;

bv_page -> bv_netmem?

> +	unsigned int bv_len;
> +	unsigned int bv_offset;
> +} skb_frag_t;
>  
>  /**
>   * skb_frag_size() - Returns the size of a skb fragment
> @@ -2431,22 +2436,37 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
>  	return skb_headlen(skb) + __skb_pagelen(skb);
>  }
>  

...

>  /**
> @@ -2462,10 +2482,10 @@ static inline void skb_len_add(struct sk_buff *skb, int delta)
>  }
>  
>  /**
> - * __skb_fill_page_desc - initialise a paged fragment in an skb
> + * __skb_fill_netmem_desc - initialise a paged fragment in an skb
>   * @skb: buffer containing fragment to be initialised
>   * @i: paged fragment index to initialise
> - * @page: the page to use for this fragment
> + * @netmem: the netmem to use for this fragment
>   * @off: the offset to the data with @page
>   * @size: the length of the data
>   *
> @@ -2474,10 +2494,13 @@ static inline void skb_len_add(struct sk_buff *skb, int delta)
>   *
>   * Does not take any additional reference on the fragment.
>   */
> -static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
> -					struct page *page, int off, int size)
> +static inline void __skb_fill_netmem_desc(struct sk_buff *skb, int i,
> +					  struct netmem *netmem, int off,
> +					  int size)
>  {
> -	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
> +	struct page *page = netmem_to_page(netmem);
> +
> +	__skb_fill_netmem_desc_noacc(skb_shinfo(skb), i, netmem, off, size);
>  
>  	/* Propagate page pfmemalloc to the skb if we can. The problem is
>  	 * that not all callers have unique ownership of the page but rely
> @@ -2485,7 +2508,21 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
>  	 */
>  	page = compound_head(page);
>  	if (page_is_pfmemalloc(page))
> -		skb->pfmemalloc	= true;
> +		skb->pfmemalloc = true;

Is it possible to introduce netmem_is_pfmemalloc() and netmem_compound_head()
for netmem, and have some built-time testing to ensure the implementation
is the same between page_is_pfmemalloc()/compound_head() and
netmem_is_pfmemalloc()/netmem_compound_head()? So that we can avoid the
netmem_to_page() as much as possible, especially in the driver.


> +}
> +
> +static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
> +					struct page *page, int off, int size)
> +{
> +	__skb_fill_netmem_desc(skb, i, page_to_netmem(page), off, size);
> +}
> +

...

>   */
>  static inline struct page *skb_frag_page(const skb_frag_t *frag)
>  {
> -	return frag->bv_page;
> +	return netmem_to_page(frag->bv_page);

It seems we are not able to have a safe type protection for the above
function, as the driver may be able to pass a devmem frag as a param here,
and pass the returned page into the mm subsystem, and compiler is not able
to catch it when compiling.

>  }
>  
>  /**
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 83af8aaeb893..053d220aa2f2 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -845,16 +845,24 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>  }
>  EXPORT_SYMBOL(__napi_alloc_skb);
>  

...

> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 65d1f6755f98..5c46db045f4c 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -636,9 +636,15 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
>  		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
>  			msize += skb_shinfo(skb)->frags[i].bv_len;
>  
> +		/* The cast to struct bio_vec* here assumes the frags are
> +		 * struct page based.
> +		 */
> +		DEBUG_NET_WARN_ON_ONCE(
> +			!skb_frag_page(&skb_shinfo(skb)->frags[0]));

It seems skb_frag_page() always return non-NULL in this patch, the above
checking seems unnecessary?

