Return-Path: <kvm+bounces-29354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7619A9F7C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46DBAB214AF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9811119993A;
	Tue, 22 Oct 2024 10:01:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA3D196C7B;
	Tue, 22 Oct 2024 10:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729591318; cv=none; b=nvi+lO9BK4K3Z2HyK6OIdEPoCmg06Nhjk7dwsgjEDFluupRpU6INaTfi3EYh5S34CNMhZL9BEwkYbL7vET9uLMagNcSEeyFIjxXOSUyj5e+5EOUrDcllAHxjZ1ODk+sE9PmPd0FjIPKSIjG0c8wAzcykimUwU6HRNgdoWMD9kVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729591318; c=relaxed/simple;
	bh=aMHdY6O6EDnpUnBTDu6QR/VsigEjeyLZRSt0+vfKLKs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=A8QN8QChgtTuy4whUCHNKIWGg7yZDEj12UFymN9b2HKv5hlQNWFh6lbGeas6ImMctkM483sDNeLSjJ8Pc0uF6hRgbN9fcFvMdYDmeIiU3cVumdCtqBy564AY5ht9R1/GTMgf/Bzt7lwhDxDUu++NhwIgZYXFWUIOL58PNxKAUVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxeeEReBdn+t4EAA--.11279S3;
	Tue, 22 Oct 2024 18:01:53 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBx_uAPeBdnmlkHAA--.43333S3;
	Tue, 22 Oct 2024 18:01:52 +0800 (CST)
Subject: Re: [PATCH v8 3/3] irqchip/loongson-eiointc: Add extioi virt
 extension support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 x86@kernel.org, Song Gao <gaosong@loongson.cn>
References: <20240830093229.4088354-1-maobibo@loongson.cn>
 <20240830093229.4088354-4-maobibo@loongson.cn>
 <CAAhV-H4W4LwL3U2HT+-r+6nH5ZSBBbPYL2wdZJqQF7WNkhOgMw@mail.gmail.com>
 <878qv6y631.ffs@tglx> <2fb27579-5a4d-8bcc-db08-8942960dc07e@loongson.cn>
 <CAAhV-H52kC_-ehzxmT5ye+XVNm5Lm=psSfAv6xqnQpkOHTMFdA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <10de3f46-3f68-d2e6-4b18-fd098b6fec9d@loongson.cn>
Date: Tue, 22 Oct 2024 18:01:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H52kC_-ehzxmT5ye+XVNm5Lm=psSfAv6xqnQpkOHTMFdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBx_uAPeBdnmlkHAA--.43333S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Zw4ftry8CFWUJw1UGryrKrX_yoW8GrWxpa
	ySkFn8tF4kJrWayan7t3Z5XF4YvrnxJFsFg3Z5Jr18A3sIvF1Fqr4xJFWUCFZ3W34rGa4j
	vry0ga47XFyUWrXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E
	14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU8yrW7UUUUU==


Got it, thanks.

Regards
Bibo Mao

On 2024/10/22 下午5:45, Huacai Chen wrote:
> On Tue, Oct 22, 2024 at 5:17 PM maobibo <maobibo@loongson.cn> wrote:
>>
>> Hi Huacai/Thomas,
>>
>> Sorry for the ping message :(
>>
>> Can this patch be applied int next RC version?
> Queued for the next release.
> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>
>> On 2024/10/2 下午9:42, Thomas Gleixner wrote:
>>> On Wed, Sep 11 2024 at 17:11, Huacai Chen wrote:
>>>> Hi, Thomas,
>>>>
>>>> On Fri, Aug 30, 2024 at 5:32 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>
>>>>> Interrupts can be routed to maximal four virtual CPUs with one HW
>>>>> EIOINTC interrupt controller model, since interrupt routing is encoded with
>>>>> CPU bitmap and EIOINTC node combined method. Here add the EIOINTC virt
>>>>> extension support so that interrupts can be routed to 256 vCPUs on
>>>>> hypervisor mode. CPU bitmap is replaced with normal encoding and EIOINTC
>>>>> node type is removed, so there are 8 bits for cpu selection, at most 256
>>>>> vCPUs are supported for interrupt routing.
>>>> This patch is OK for me now, but seems it depends on the first two,
>>>> and the first two will get upstream via loongarch-kvm tree. So is that
>>>> possible to also apply this one to loongarch-kvm with your Acked-by?
>>>
>>> Go ahead.
>>>
>>> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>>>
>>


