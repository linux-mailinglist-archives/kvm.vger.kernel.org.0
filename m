Return-Path: <kvm+bounces-66759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08802CE5BAC
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 03:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1E8D43014586
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 02:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B3D224B1B;
	Mon, 29 Dec 2025 02:11:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C72A199237;
	Mon, 29 Dec 2025 02:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766974317; cv=none; b=D/3bRioKCJUQlyQf99vdiZud/KXMrsYA3qCdYb1HVsSBqy+V/pZWWfkLLnOKzv2/8KcUcZzUEkS77HBGF2jKKyphVz1U7cc1uAmT/r+DwcD4hwpDTHjALb/FWMnk6XNFmQs12HoqUw3RuQuOXTFYbCco3dndjR0GUqSg0d8X+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766974317; c=relaxed/simple;
	bh=Q9aVLo3e1IvFQCGDV4P+l27KBvVPVbPaYfVufsCCI7c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FbKunRTue/llqanmPgyLNsTm//q0FYfoEILXPJ/0eSVbjjGTl3Hizn5Lbmh9BR7uioQ+E0uRwqvPjUrGBtCtdr5fWrGQYrXFsTynYeR6VyRnu11DjMO3em26ZC9tEr1lEhJyvQwoVqob9cBzVNeXKF8B0P0636A5dMSJPCjagIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Axz8Ne41Fp1fYDAA--.12814S3;
	Mon, 29 Dec 2025 10:11:42 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxD8Na41FpbAQGAA--.16832S3;
	Mon, 29 Dec 2025 10:11:40 +0800 (CST)
Subject: Re: [PATCH v4 0/9] crypto: virtio: Some bugfix and enhancement
To: "Michael S. Tsirkin" <mst@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20251218034846.948860-1-maobibo@loongson.cn>
 <20251226094413-mutt-send-email-mst@kernel.org>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <6bf766f5-1f77-0d71-2970-46cbe5512233@loongson.cn>
Date: Mon, 29 Dec 2025 10:09:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251226094413-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxD8Na41FpbAQGAA--.16832S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxWw4UZF47uFWUuw1UGw4kAFc_yoW5Jw4UpF
	W5tFsayrWUGr17WFyfXa48Kry5Ca9xCryagr4fXr1Fkrn0qr97Xr12yw48uFy7JF1rJ3sr
	JrW8Xryj9F1DuFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcpBTUUUUU



On 2025/12/26 下午10:45, Michael S. Tsirkin wrote:
> On Thu, Dec 18, 2025 at 11:48:37AM +0800, Bibo Mao wrote:
>> There is problem when multiple processes add encrypt/decrypt requests
>> with virtio crypto device and spinlock is missing with command response
>> handling. Also there is duplicated virtqueue_kick() without lock hold.
>>
>> Here these two issues are fixed and the others are code clean up, such as
>> use common APIs for block size and iv size etc.
> 
> series:
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> but you did not CC maintainers, you really should if you want this
> applied.
Oh, sorry, it is the first time I send patch relative with crypto 
subsystem.

Add Herbert and David, need I send a fresh version?

Regards
Bibo Mao
> 
>> ---
>> v3 ... v4:
>>    1. Remove patch 10 which adds ECB AES algo, since application and qemu
>>       backend emulation is not ready for ECB AES algo.
>>    2. Add Cc stable tag with patch 2 which removes duplicated
>>       virtqueue_kick() without lock hold.
>>
>> v2 ... v3:
>>    1. Remove NULL checking with req_data where kfree() is called, since
>>       NULL pointer is workable with kfree() API.
>>    2. In patch 7 and patch 8, req_data and IV buffer which are preallocated
>>       are sensitive data, memzero_explicit() is used even on error path
>>       handling.
>>    3. Remove duplicated virtqueue_kick() in new patch 2, since it is
>>       already called in previous __virtio_crypto_skcipher_do_req().
>>
>> v1 ... v2:
>>    1. Add Fixes tag with patch 1.
>>    2. Add new patch 2 - patch 9 to add ecb aes algo support.
>> ---
>> Bibo Mao (9):
>>    crypto: virtio: Add spinlock protection with virtqueue notification
>>    crypto: virtio: Remove duplicated virtqueue_kick in
>>      virtio_crypto_skcipher_crypt_req
>>    crypto: virtio: Replace package id with numa node id
>>    crypto: virtio: Add algo pointer in virtio_crypto_skcipher_ctx
>>    crypto: virtio: Use generic API aes_check_keylen()
>>    crypto: virtio: Remove AES specified marcro AES_BLOCK_SIZE
>>    crypto: virtio: Add req_data with structure virtio_crypto_sym_request
>>    crypto: virtio: Add IV buffer in structure virtio_crypto_sym_request
>>    crypto: virtio: Add skcipher support without IV
>>
>>   drivers/crypto/virtio/virtio_crypto_common.h  |   2 +-
>>   drivers/crypto/virtio/virtio_crypto_core.c    |   5 +
>>   .../virtio/virtio_crypto_skcipher_algs.c      | 113 +++++++++---------
>>   3 files changed, 62 insertions(+), 58 deletions(-)
>>
>>
>> base-commit: ea1013c1539270e372fc99854bc6e4d94eaeff66
>> -- 
>> 2.39.3


