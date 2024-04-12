Return-Path: <kvm+bounces-14477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 841268A2A44
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 11:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24B2C1F233B6
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9448954919;
	Fri, 12 Apr 2024 08:58:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7244A5491B;
	Fri, 12 Apr 2024 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712912297; cv=none; b=CFUkbOKfstp/rLftdcY5LNsRISrwQQmfOBE1gtIZKLI8yPjvfhu2j2zriiNpd9tsfgjsHoSKEXtV881MBKPiAbxC7jYll9EaLjUQr5C6m9mjpBkZoZFAbunCcSQry4wGfuE7+2PzH97kLGc3WHorKvPSgKaGHZgKAPi00/vD1Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712912297; c=relaxed/simple;
	bh=wvTxpBz/xlX0wCAj5ZppzKJswZIdN3eORJa84MXXZYU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gy6SOvmbTS2GQsaaxzbEygpskWnKe6xaYn80LJ6BE6m98mVGE90vhF8T28VBgKM96IkrHnu49KsDiholXd7R/IL9YP5DKlyjRdWDosV0qzlG1Xh3nnyTO3U380pwxK2AvW4/k8nUdPlo+NiTiNwUS8q91L00DwERRZ3q7IFW3j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Axx7mh9xhmN08mAA--.6346S3;
	Fri, 12 Apr 2024 16:58:09 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDBOe9xhmwZx4AA--.34934S3;
	Fri, 12 Apr 2024 16:58:08 +0800 (CST)
Subject: Re: [PATCH] KVM: loongarch: Add vcpu id check before create vcpu
To: Wujie Duan <wjduan@linx-info.com>, zhaotianrui@loongson.cn,
 chenhuacai@kernel.org, kernel@xen0n.name
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240412084703.1407412-1-wjduan@linx-info.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <2b6e60ad-1138-06cf-015a-40d7e6ca7a10@loongson.cn>
Date: Fri, 12 Apr 2024 16:58:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240412084703.1407412-1-wjduan@linx-info.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxDBOe9xhmwZx4AA--.34934S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWrKw1rKF43XF4DAr4fCry7XFc_yoW3CFb_Gr
	1Ikw15KrW8J3Wvq3yqgr1fJryrJw4kJFZ0v3WUZr47J3ZrJr97urWvg3W7Cw4DKrW8Aa15
	Aa90yr9xC34ayosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbI8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7XTm
	DUUUU



On 2024/4/12 下午4:47, Wujie Duan wrote:
> Add a pre-allocation arch condition to checks that vcpu id should
> smaller than max_vcpus
> 
> Signed-off-by: Wujie Duan <wjduan@linx-info.com>
> ---
>   arch/loongarch/kvm/vcpu.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 3a8779065f73..d41cacf39583 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -884,6 +884,9 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>   
>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>   {
> +	if (id >= kvm->max_vcpus)
> +		return -EINVAL;
> +
>   	return 0;
>   }
>   
> 
Good catch, and thanks for your contribution.

Reviewed-by: bibo mao <maobibo@loongson.cn>


