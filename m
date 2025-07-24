Return-Path: <kvm+bounces-53327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B25B0FE7C
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 03:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EBE8AA4CF3
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 01:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9421991D2;
	Thu, 24 Jul 2025 01:51:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C430B4A28;
	Thu, 24 Jul 2025 01:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753321908; cv=none; b=ucwApIg8bIeXO2WU6X9q3rNv+fB0yv05NMtMq6UnSDFQGBKmI0ffaDsFuw4HjdFZxpsyL629mUkWd9ZZZt2vIWuhoty1ogXU2He/pSQdQXutABT9M4Eb83ky4meD7TiTmru6EezZJgbo4zJKo0t1zNGXsUc8kfZKcotaP6vKiQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753321908; c=relaxed/simple;
	bh=5gFsPbAXW59mepTuWRnPPsjYPaC7EOK30HvNtYThJGM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KvDzN6I3tA/BYily+mNDzHsJHUIfnYsiNlixZYCQIdGXUFbGGfRpwJqWe5B162mVVBUJtbQuRc7xk0epy8YAPPePwKHnT1s0Su7+qRxYKn1K8PdAqunUfmYGgeMH5WgwjjT3ryBJKp+BZF6Q38ijo9AYa/2pNOpNhWlHk/ElHx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxG6yukYFoZMwwAQ--.58090S3;
	Thu, 24 Jul 2025 09:51:42 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxzsGrkYFoSQkkAA--.28881S3;
	Thu, 24 Jul 2025 09:51:41 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of generic
 code
To: Steven Rostedt <rostedt@goodmis.org>, Huacai Chen <chenhuacai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20250722094734.4920545b@gandalf.local.home>
 <2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
 <20250723214659.064b5d4a@gandalf.local.home>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <15e46f69-f270-0520-1ad4-874448439d2b@loongson.cn>
Date: Thu, 24 Jul 2025 09:49:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250723214659.064b5d4a@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxzsGrkYFoSQkkAA--.28881S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29K
	BjDU0xBIdaVrnRJUUUmYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26c
	xKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vE
	j48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
	ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E
	87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
	AS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCF54CYxVAaw2AFwI0_Jrv_JF1l4c8EcI0E
	c7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw
	0_GFylx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjxUcCD7UUUUU



On 2025/7/24 上午9:46, Steven Rostedt wrote:
> On Thu, 24 Jul 2025 09:39:40 +0800
> Bibo Mao <maobibo@loongson.cn> wrote:
> 
>>>    #define kvm_fpu_load_symbol	\
>>>    	{0, "unload"},		\
>>>    	{1, "load"}
>>>    
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> 
> Thanks,
> 
> Should this go through the loongarch tree or should I take it?
Huacai,

What is your point about this?

Regards
Bibo Mao
> 
> Either way works for me.
> 
> -- Steve
> 


