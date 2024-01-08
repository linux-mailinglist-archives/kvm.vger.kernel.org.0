Return-Path: <kvm+bounces-5794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2234B826A29
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 10:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5B2D1F22FD2
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 09:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C116B12B87;
	Mon,  8 Jan 2024 09:06:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78907F516;
	Mon,  8 Jan 2024 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4T7p6R3dCJz1Q7tL;
	Mon,  8 Jan 2024 17:04:47 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 0212E1A0172;
	Mon,  8 Jan 2024 17:06:18 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 8 Jan
 2024 17:06:17 +0800
Subject: Re: [PATCH net-next 4/6] vhost/net: remove
 vhost_net_page_frag_refill()
To: Alexander H Duyck <alexander.duyck@gmail.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Jason Wang
	<jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper
 Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<bpf@vger.kernel.org>
References: <20240103095650.25769-1-linyunsheng@huawei.com>
 <20240103095650.25769-5-linyunsheng@huawei.com>
 <1a66f99173de36e1ae639569582feaf76202361d.camel@gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <705e59c2-6f46-5d39-b8da-8e2310904d71@huawei.com>
Date: Mon, 8 Jan 2024 17:06:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1a66f99173de36e1ae639569582feaf76202361d.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)

On 2024/1/6 0:06, Alexander H Duyck wrote:
>>  
>>  static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>> @@ -1353,8 +1318,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>>  			vqs[VHOST_NET_VQ_RX]);
>>  
>>  	f->private_data = n;
>> -	n->page_frag.page = NULL;
>> -	n->refcnt_bias = 0;
>> +	n->pf_cache.va = NULL;
>>  
>>  	return 0;
>>  }
>> @@ -1422,8 +1386,9 @@ static int vhost_net_release(struct inode *inode, struct file *f)
>>  	kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
>>  	kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
>>  	kfree(n->dev.vqs);
>> -	if (n->page_frag.page)
>> -		__page_frag_cache_drain(n->page_frag.page, n->refcnt_bias);
>> +	if (n->pf_cache.va)
>> +		__page_frag_cache_drain(virt_to_head_page(n->pf_cache.va),
>> +					n->pf_cache.pagecnt_bias);
>>  	kvfree(n);
>>  	return 0;
>>  }
> 
> I would recommend reordering this patch with patch 5. Then you could
> remove the block that is setting "n->pf_cache.va = NULL" above and just
> make use of page_frag_cache_drain in the lower block which would also
> return the va to NULL.

I am not sure if we can as there is no zeroing for 'struct vhost_net' in
vhost_net_open().

If we don't have "n->pf_cache.va = NULL", don't we use the uninitialized data
when calling page_frag_alloc_align() for the first time?

> .
> 

