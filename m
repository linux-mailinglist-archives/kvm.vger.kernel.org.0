Return-Path: <kvm+bounces-65642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 621D5CB19BC
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 02:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1CED83023143
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2275422A4E9;
	Wed, 10 Dec 2025 01:38:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C861FBC8C;
	Wed, 10 Dec 2025 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765330737; cv=none; b=BVIDtYQJ4Sol5op2JlzORKypMPA3FTPcjcy1atfmSa0CEpwlbNHHksPx1a+o4zY2D+jA9V1ahyusuuCelk8cfFfuWe+MTSqTGfKwUmPo305YH7UXhruW6gM4M7fcIXpsZB5RsYFKJ23c17X+c33IcBHNSE6eG+RIRN4gBkIWNkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765330737; c=relaxed/simple;
	bh=mW/oCegFkS5JO20NVxMb1WA+su3p2YksHjarrgW3EvQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qQuOkNaPGyJj/70qspYVdychXc9R0761w66L3ffR7Y+KIayBBAiAFvwB0e0fleHziGIyQi2edPJOQyBzGE8+XfjmhdSpW1gHUgADK6BN9zqpve/AKAFXbzNb/ki9JNE0+8+QK/13w3D4YQxOVG9urOMkjeJKEQSHIMnmd3KB/rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxqdEpzzhpt90sAA--.31867S3;
	Wed, 10 Dec 2025 09:38:49 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxrcEbzzhpyKJHAQ--.31721S3;
	Wed, 10 Dec 2025 09:38:38 +0800 (CST)
Subject: Re: [PATCH v3 10/10] crypto: virtio: Add ecb aes algo support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?=
 <eperezma@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20251209022258.4183415-1-maobibo@loongson.cn>
 <20251209022258.4183415-11-maobibo@loongson.cn>
 <20251209232524.GE54030@quark>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <4ac7b5b9-d819-62b5-1425-0e0b07762120@loongson.cn>
Date: Wed, 10 Dec 2025 09:36:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251209232524.GE54030@quark>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxrcEbzzhpyKJHAQ--.31721S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7JFyfCw13CrWUGF18tFWrZwc_yoW3GFX_ur
	WkJws8u3yUZw1qqayrtF4FvrZ8Ww1UAF1rJwsrXr47K3ykJFs8XrsxurZ7u3Way3yrCr12
	9rs5XF1Dur1IkosvyTuYvTs0mTUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbDAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
	JVW8Jr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7
	I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07joc_-UUUUU=



On 2025/12/10 上午7:25, Eric Biggers wrote:
> On Tue, Dec 09, 2025 at 10:22:58AM +0800, Bibo Mao wrote:
>> ECB AES also is added here, its ivsize is zero and name is different
>> compared with CBC AES algo.
> 
> What is the use case for this feature?Currently qemu builtin backend and openssl afalg only support CBC AES, 
it depends on modified qemu and openssl to test this.

Maybe this patch adding ECB AES algo can be skipped now, it is just an 
example, the final target is to add SM4 cipher. currently virtio crypto 
has some problems such as:
1. there is RCU timeout issue with multiple AIO openssl processes
2. session number is limited with 256 so it is hard for actual use.

I want to solve these issues one by one.

Regards
Bibo Mao
> 
> - Eric
> 


