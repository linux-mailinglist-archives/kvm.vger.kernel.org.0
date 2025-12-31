Return-Path: <kvm+bounces-66899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC130CEB5AE
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 07:35:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EF6FF3009F1B
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 06:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF813112A5;
	Wed, 31 Dec 2025 06:35:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C67524728E;
	Wed, 31 Dec 2025 06:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767162928; cv=none; b=WAMTe/CLCyZru7yUIwePYiXpaFUJOJjuYDqq5dAGKf26ueQ2Lbx/GzTBsG0ZN+uTOm4wl03nb6Kh+telSbF72lynIVJss7dUWAjvaG2KuhlFF2UoPtuxP7zBNNhadnYUkzkLfDXBdq3y4e4ZL0JS8UVahf/dP0TV7DAz/MbdhT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767162928; c=relaxed/simple;
	bh=bxw4Aj30meQU68rcCriF9pGZTUcJEVG7IgcnyMcUF98=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mgOHhCcB0Y0IQwxkmKw1lcup/L92DMQ0hFb0HqPsB2EIVNzysPM3bxJqUc4AlV5EyHLotewdDh/h2+UEFo/y9c2BIL2jCru+ib+BhuS0jgxST3Jb3DACaozwocohTwPAsLic4qIGg7HpgPkthnwaCXHLHga+iRT1Nx6tYUrOrRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxisInxFRp05kEAA--.14119S3;
	Wed, 31 Dec 2025 14:35:19 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAx28EkxFRp3qYHAA--.16941S3;
	Wed, 31 Dec 2025 14:35:18 +0800 (CST)
Subject: Re: [PATCH 0/3] LoongArch: KVM: Fix kvm_device leak in
 kvm_{pch_pic|ipi|eiointc}_destroy
To: Qiang Ma <maqianga@uniontech.com>, zhaotianrui@loongson.cn,
 chenhuacai@kernel.org, kernel@xen0n.name
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20251226150706.2511127-1-maqianga@uniontech.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <99826cf9-356d-235b-9c7c-9d51d36e53c3@loongson.cn>
Date: Wed, 31 Dec 2025 14:32:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251226150706.2511127-1-maqianga@uniontech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx28EkxFRp3qYHAA--.16941S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7Jr4rXFy3KFy5Gr48AryxJFc_yoW3trb_XF
	1Iyrn7ZrWkW3W8Gr1Yvr1rJwnIkF4FqFZ5tr93Zry8W34YqrWDZrW5W3s2vF1Igw4UZrZ8
	AFZ2yr9Yyr1jkosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbI8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7_Ma
	UUUUU

Hi qiang,

Thanks for the patch, it looks good to me.

For the whole series.
Reviewed-by: Bibo Mao <maobibo@loongson.cn>

Regards
Bibo Mao

On 2025/12/26 下午11:07, Qiang Ma wrote:
> In kvm_ioctl_create_device(), kvm_device has allocated memory,
> kvm_device->destroy() seems to be supposed to free its kvm_device
> struct, but kvm_pch_pic_destroy() is not currently doing this,
> that would lead to a memory leak.
> 
> So, fix it.
> 
> Qiang Ma (3):
>    LoongArch: KVM: Fix kvm_device leak in kvm_pch_pic_destroy
>    LoongArch: KVM: Fix kvm_device leak in kvm_ipi_destroy
>    LoongArch: KVM: Fix kvm_device leak in kvm_eiointc_destroy
> 
>   arch/loongarch/kvm/intc/eiointc.c | 2 ++
>   arch/loongarch/kvm/intc/ipi.c     | 2 ++
>   arch/loongarch/kvm/intc/pch_pic.c | 2 ++
>   3 files changed, 6 insertions(+)
> 


