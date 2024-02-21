Return-Path: <kvm+bounces-9293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF6C85D4F8
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 11:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E802C1F22EE5
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 10:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A78E3F9E5;
	Wed, 21 Feb 2024 09:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HIqycl3r"
X-Original-To: kvm@vger.kernel.org
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BBD3D0DB;
	Wed, 21 Feb 2024 09:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708509236; cv=none; b=HZTIVxJlO1hPazhTJxFyJWUlBlkPHjp8GO42NMY93hM3txVKhKLDvoT9Q0wUlOGQ2q8ho2wpGF2gkwPM1roiQVhopF6H3nvUzNqKrvsIBQZoxbsc0o0zqG7gKiAkTOUR961BeaJg2muzde0d2AGCoubMDOViytfldsds8DxSZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708509236; c=relaxed/simple;
	bh=9rQKbf/XB71bS0VjPXbpawybpWP+a4gMQOoTUb1QXKM=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=X8bAumJGJhBBEbtKlG1628AP7KCs+cb98/cowTmCeWjfXQHPpfFouaaIv2creALy/X7W7rZDy3z6C0x4pe5sel8Qhvw9OPXXmfXBTZ+Ccjolu1XqUr7mAVjgTG4pWYMyZpGucSwc0EoQtCeO3HWxgod7U/C3go/38htvYFha/F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HIqycl3r; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708509230; h=Message-ID:Subject:Date:From:To;
	bh=iMfzMLI+K5kpzH+OCBW/f2plocUmWvxeNdyqymsPQs0=;
	b=HIqycl3r251f7rLtINT+YGG/9HaU2hZFuMUVmGmFV0Gf1ObUT7eTO5fMdraWUKUMdB45Hqe1Jr6xzvlz6RvKQ0siXSQ2M+YQ7LO5GJkCRLobBUC7sSjbpOl2bAhrus3cY3/+2KLTIwyiFTLaWdwJxVuWTe9j7+w5yQjBLV7DFpE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0W0zZSyp_1708509229;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W0zZSyp_1708509229)
          by smtp.aliyun-inc.com;
          Wed, 21 Feb 2024 17:53:49 +0800
Message-ID: <1708509152.9501102-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 1/2] xsk: Remove non-zero 'dma_page' check in xp_assign_dev
Date: Wed, 21 Feb 2024 17:52:32 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Yunjian Wang <wangyunjian@huawei.com>
Cc: <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>,
 <virtualization@lists.linux.dev>,
 <xudingke@huawei.com>,
 Yunjian Wang <wangyunjian@huawei.com>,
 <mst@redhat.com>,
 <willemdebruijn.kernel@gmail.com>,
 <jasowang@redhat.com>,
 <kuba@kernel.org>,
 <davem@davemloft.net>,
 <magnus.karlsson@intel.com>
References: <1706089058-1364-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1706089058-1364-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Wed, 24 Jan 2024 17:37:38 +0800, Yunjian Wang <wangyunjian@huawei.com> wrote:
> Now dma mappings are used by the physical NICs. However the vNIC
> maybe do not need them. So remove non-zero 'dma_page' check in
> xp_assign_dev.

Could you tell me which one nic can work with AF_XDP without DMA?

Thanks.


>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  net/xdp/xsk_buff_pool.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 28711cc44ced..939b6e7b59ff 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -219,16 +219,9 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>  	if (err)
>  		goto err_unreg_pool;
>
> -	if (!pool->dma_pages) {
> -		WARN(1, "Driver did not DMA map zero-copy buffers");
> -		err = -EINVAL;
> -		goto err_unreg_xsk;
> -	}
>  	pool->umem->zc = true;
>  	return 0;
>
> -err_unreg_xsk:
> -	xp_disable_drv_zc(pool);
>  err_unreg_pool:
>  	if (!force_zc)
>  		err = 0; /* fallback to copy mode */
> --
> 2.33.0
>
>

