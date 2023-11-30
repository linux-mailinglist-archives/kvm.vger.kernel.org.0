Return-Path: <kvm+bounces-2883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42FC77FEC7E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 11:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F04DB282022
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BBD73B2A9;
	Thu, 30 Nov 2023 10:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 078E110C2;
	Thu, 30 Nov 2023 02:06:49 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8DxPOu2XmhlHuQ9AA--.52040S3;
	Thu, 30 Nov 2023 18:06:47 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx7y+0XmhlO6pQAA--.47164S3;
	Thu, 30 Nov 2023 18:06:46 +0800 (CST)
Subject: Re: [PATCH v4 0/3] LoongArch: KVM: Remove SW timer switch when vcpu
 is halt polling
From: maobibo <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20231116023036.2324371-1-maobibo@loongson.cn>
Message-ID: <4d9e1a2d-2e37-a82f-7133-2b28b9c980c2@loongson.cn>
Date: Thu, 30 Nov 2023 18:06:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231116023036.2324371-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx7y+0XmhlO6pQAA--.47164S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7KrW5GrWfCr1xXF4rCr1xJFc_yoW8WrW3pr
	ZIk3ZxXr40kr4Fg3ZIqa1DWr9xWw4FgF4IqwnIkFyrArnFyFyYqFW8Kr95ZFy3Xa93AryI
	vryrt3W3ua4UA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07je0PfUUUUU=

slightly ping...

On 2023/11/16 上午10:30, Bibo Mao wrote:
> This patches removes SW timer switch during vcpu block stage. VM uses HW
> timer rather than SW PV timer on LoongArch system, it can check pending
> HW timer interrupt status directly, rather than switch to SW timer and
> check injected SW timer interrupt.
> 
> When SW timer is not used in vcpu halt-polling mode, the relative
> SW timer handling before entering guest can be removed also. Timer
> emulation is simpler than before, SW timer emuation is only used in vcpu
> thread context switch.
> ---
> Changes in v4:
>    If vcpu is scheduled out since there is no pending event, and timer is
> fired during sched-out period. SW hrtimer is used to wake up vcpu thread
> in time, rather than inject pending timer irq.
> 
> Changes in v3:
>    Add kvm_arch_vcpu_runnable checking before kvm_vcpu_halt.
> 
> Changes in v2:
>    Add halt polling support for idle instruction emulation, using api
> kvm_vcpu_halt rather than kvm_vcpu_block in function kvm_emu_idle.
> 
> ---
> Bibo Mao (3):
>    LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
>    LoongArch: KVM: Allow to access HW timer CSR registers always
>    LoongArch: KVM: Remove kvm_acquire_timer before entering guest
> 
>   arch/loongarch/include/asm/kvm_vcpu.h |  1 -
>   arch/loongarch/kvm/exit.c             | 13 +-----
>   arch/loongarch/kvm/main.c             |  1 -
>   arch/loongarch/kvm/timer.c            | 62 ++++++++++-----------------
>   arch/loongarch/kvm/vcpu.c             | 38 ++++------------
>   5 files changed, 32 insertions(+), 83 deletions(-)
> 
> 
> base-commit: c42d9eeef8e5ba9292eda36fd8e3c11f35ee065c
> 


