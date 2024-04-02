Return-Path: <kvm+bounces-13320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 41ED58949CE
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:04:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F369B22C3F
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E646D156C2;
	Tue,  2 Apr 2024 03:04:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B872814005;
	Tue,  2 Apr 2024 03:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712027063; cv=none; b=cjG7ZY1qRKlohv6asSAGdhs8DujVYe/FjlUM/I7mAR/ek51de1nG5PObT5hCeWyIuxiEPfxWy6sMfv5aQTz2sSxrIuWSiWFGKxhrMvJZr3uUTKnVG3JPj4Am2Y75I4VGJbSuAJytB700VDTUCkP7LHi5bqkE26XHClrIzODFxRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712027063; c=relaxed/simple;
	bh=PvVrXqrvcv3iZaoE9GUEQP+k7DvSvTH2paZ7ANGjqqc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Xl9R185tRs8NQymzuoA3ukPpwwCv0JcGIlmfzkzWs9I9doZ1WN2YfjZEofMib8FZl5GERgbUdR6HeW8biwryBJhINM3wvQk+qqdWK/YD1q1o/XUP27/1MEkZRBVjt9d8dn8p59sZdMoLY8y+5PdO9+Cx2b1enNK0I48oVmAH03Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8DxmfCxdQtmOC8iAA--.13732S3;
	Tue, 02 Apr 2024 11:04:17 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxdRGudQtm8FtxAA--.12242S3;
	Tue, 02 Apr 2024 11:04:17 +0800 (CST)
Subject: Re: [PATCH v7 3/7] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: Xi Ruoyao <xry111@xry111.site>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240315080710.2812974-1-maobibo@loongson.cn>
 <20240315080710.2812974-4-maobibo@loongson.cn>
 <4668e606-a7b5-49b7-a68d-1c2af86f7d76@xen0n.name>
 <57e66ff5-1cb6-06bd-ee6f-a3c3dadd6aef@loongson.cn>
 <b7d91c1a42470821983a811a16f9fc1c55cfe699.camel@xry111.site>
From: maobibo <maobibo@loongson.cn>
Message-ID: <4d35124d-527d-ec1c-1eb1-2d98e9d0da46@loongson.cn>
Date: Tue, 2 Apr 2024 11:04:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b7d91c1a42470821983a811a16f9fc1c55cfe699.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxdRGudQtm8FtxAA--.12242S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tw4rXry7CF1rGF1UJFy3WrX_yoW8CFWkpa
	yYkasxAF4qqryxZw4kZ3WxXFyIkwn3JF45urnxCF15Z3s8Cryrtw4akFyY9FZ2yr1Ikr1j
	vrs0q395C39rArXCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4SoGDU
	UUU



On 2024/4/2 上午10:49, Xi Ruoyao wrote:
> On Tue, 2024-04-02 at 09:43 +0800, maobibo wrote:
>>> Sorry for the late reply, but I think it may be a bit non-constructive
>>> to repeatedly submit the same code without due explanation in our
>>> previous review threads. Let me try to recollect some of the details
>>> though...
>> Because your review comments about hypercall method is wrong, I need not
>> adopt it.
> 
> Again it's unfair to say so considering the lack of LVZ documentation.
> 
> /* snip */
> 
>>
>> 1. T0-T7 are scratch registers during SYSCALL ABI, this is what you
>> suggest, does there exist information leaking to user space from T0-T7
>> registers?
> 
> It's not a problem.  When syscall returns RESTORE_ALL_AND_RET is invoked
> despite T0-T7 are not saved.  So a "junk" value will be read from the
> leading PT_SIZE bytes of the kernel stack for this thread.
For you it is "junk" value, some guys maybe thinks it is useful.

There is another issue, since kernel restore T0-T7 registers and user 
space save T0-T7. Why T0-T7 is scratch registers rather than preserve 
registers like other architecture? What is the advantage if it is 
scratch registers?

Regards
Bibo Mao
> 
> The leading PT_SIZE bytes of the kernel stack is dedicated for storing
> the struct pt_regs representing the reg file of the thread in the
> userspace.
> 
> Thus we may only read out the userspace T0-T7 value stored when the same
> thread was interrupted or trapped last time, or 0 (if the thread was
> never interrupted or trapped before).
> 
> And it's impossible to read some data used by the kernel internally, or
> some data of another thread.
> 
> But indeed there is some improvement here.  Zeroing these registers
> seems cleaner than reading out the junk values, and also faster (move
> $t0, $r0 is faster than ld.d $t0, $sp, PT_R12).  Not sure if it's worthy
> to violate Huacai's "keep things simple" aspiration though.
> 


