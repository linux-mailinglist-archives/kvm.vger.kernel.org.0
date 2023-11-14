Return-Path: <kvm+bounces-1620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF397EA85F
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 02:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D80F1C209B3
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 01:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3649B79CC;
	Tue, 14 Nov 2023 01:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22DA613E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 01:47:08 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8D04D49;
	Mon, 13 Nov 2023 17:47:06 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Dxg_CX0VJlr8s5AA--.48510S3;
	Tue, 14 Nov 2023 09:47:03 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxbS+U0VJla2hBAA--.12085S3;
	Tue, 14 Nov 2023 09:47:03 +0800 (CST)
Subject: Re: [PATCH v3 0/3] LoongArch: KVM: Remove SW timer switch when vcpu
 is halt polling
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20231110090529.56950-1-maobibo@loongson.cn>
 <CAAhV-H6zH7TwcAokHguy5Wk_z44nu6toZ9uW48TxrgxxRrvuJA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <008ec0db-0c3e-0ed6-3f85-cfc60e5e696a@loongson.cn>
Date: Tue, 14 Nov 2023 09:47:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6zH7TwcAokHguy5Wk_z44nu6toZ9uW48TxrgxxRrvuJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxbS+U0VJla2hBAA--.12085S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tFy3ZryxJrWfuF1kXF1kJFc_yoW8Cw47pF
	ZxCFnFkF40krZ8K3W29a1DGr97t3yxKF1xXrnIkFyrCr1qyw1YqFW8KrZ5ZF9xX3yfAryI
	vr1rta43Za4UA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j0FALU
	UUUU=



On 2023/11/13 下午10:36, Huacai Chen wrote:
> Hi, Bibo,
> 
> Does this series have some relationship with the commit
> "LoongArch:LSVZ: set timer offset at first time once" in our internal
> repo?

No, it is not relative with internal repo. This patch is only 
optimization for timer save and restore. The internal repo is to set 
timestamp offset for VM.

I will post another patch for timestamp offset setting.

Regards
Bibo,

> 
> Huacai
> 
> On Fri, Nov 10, 2023 at 5:07 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> This patches removes SW timer switch during vcpu block stage. VM uses HW
>> timer rather than SW PV timer on LoongArch system, it can check pending
>> HW timer interrupt status directly, rather than switch to SW timer and
>> check injected SW timer interrupt.
>>
>> When SW timer is not used in vcpu halt-polling mode, the relative
>> SW timer handling before entering guest can be removed also. Timer
>> emulation is simpler than before, SW timer emuation is only used in vcpu
>> thread context switch.
>>
>> ---
>>
>> Changes in v3:
>>    Add kvm_arch_vcpu_runnable checking before kvm_vcpu_halt.
>>
>> Changes in v2:
>>    Add halt polling support for idle instruction emulation, using api
>> kvm_vcpu_halt rather than kvm_vcpu_block in function kvm_emu_idle.
>>
>> ---
>>
>> Bibo Mao (3):
>>    LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
>>    LoongArch: KVM: Allow to access HW timer CSR registers always
>>    LoongArch: KVM: Remove kvm_acquire_timer before entering guest
>>
>>   arch/loongarch/include/asm/kvm_vcpu.h |  1 -
>>   arch/loongarch/kvm/exit.c             | 13 ++------
>>   arch/loongarch/kvm/main.c             |  1 -
>>   arch/loongarch/kvm/timer.c            | 47 +++++++--------------------
>>   arch/loongarch/kvm/vcpu.c             | 38 +++++-----------------
>>   5 files changed, 22 insertions(+), 78 deletions(-)
>>
>>
>> base-commit: 305230142ae0637213bf6e04f6d9f10bbcb74af8
>> --
>> 2.39.3
>>


