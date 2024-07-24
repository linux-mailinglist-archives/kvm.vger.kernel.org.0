Return-Path: <kvm+bounces-22147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9185F93AA95
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 03:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53192282975
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 01:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC143BA47;
	Wed, 24 Jul 2024 01:30:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C474A19;
	Wed, 24 Jul 2024 01:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721784616; cv=none; b=fozJD3N8BudPTj/8iB7iDoOAUeU/qePGILuktS42B6vhu/fTS+2EO6gRa3Ph1FcGELZ2wsOqyHNX4Q+HDGvsRIX/l6iS4+Gc7NhLHRYhguSrMfL2JlqkVOgfGqfLq8T/Rkrat8rZV+Mjsr9kQO3BEIoKwbJObOelVz40fvWLneM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721784616; c=relaxed/simple;
	bh=bSV/tn8rgIr3LZKicy7ygBdBwp4x2cZxxscf4ukTabw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jlgZO+hGpAn/1myd1ufrWNDv9wnrVyWSgO64Tq5UkZ+GNoandSl323LfRp9MivvmLKz2P5uL4cjzQbpK5gK+msHK/p5gTSy+poyYyVwKCpVwc0/Xb0c8KmxDdleMHarN+V4bjA93LXwX4NQ0GHvkryz05OKcAdSGMdZc2BJ2q5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxuOkeWaBm18QAAA--.3046S3;
	Wed, 24 Jul 2024 09:30:06 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxhsUXWaBm2ZNWAA--.50225S3;
	Wed, 24 Jul 2024 09:30:01 +0800 (CST)
Subject: Re: [PATCH 2/2] LoongArch: KVM: Add paravirt qspinlock in guest side
To: kernel test robot <lkp@intel.com>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Peter Zijlstra
 <peterz@infradead.org>, Waiman Long <longman@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, WANG Xuerui <kernel@xen0n.name>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev
References: <20240723073825.1811600-3-maobibo@loongson.cn>
 <202407240320.qqd1uWiE-lkp@intel.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <7a145178-633c-afd7-4aba-45546a4c7a75@loongson.cn>
Date: Wed, 24 Jul 2024 09:29:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <202407240320.qqd1uWiE-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxhsUXWaBm2ZNWAA--.50225S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGFW3Zw4UZryruF17KryxXrc_yoW5CFWDpa
	48CF1DJFW8Jr48Z3yUKw15uF1Dtan8W3sIvF9Y9ryxCFW2qFyDWws2krWa9w1jyws29Fyj
	gry7WF1qya4UA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jYpB-UUUUU=



On 2024/7/24 上午3:57, kernel test robot wrote:
> Hi Bibo,
> 
> kernel test robot noticed the following build errors:
yes, forgot to mention, it depends on this patch
https://lore.kernel.org/lkml/20240721164552.50175-1-ubizjak@gmail.com/

Regards
Bibo Mao
> 
> [auto build test ERROR on 7846b618e0a4c3e08888099d1d4512722b39ca99]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Add-paravirt-qspinlock-in-kvm-side/20240723-160536
> base:   7846b618e0a4c3e08888099d1d4512722b39ca99
> patch link:    https://lore.kernel.org/r/20240723073825.1811600-3-maobibo%40loongson.cn
> patch subject: [PATCH 2/2] LoongArch: KVM: Add paravirt qspinlock in guest side
> config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20240724/202407240320.qqd1uWiE-lkp@intel.com/config)
> compiler: loongarch64-linux-gcc (GCC) 14.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240724/202407240320.qqd1uWiE-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202407240320.qqd1uWiE-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>>> arch/loongarch/kernel/paravirt.c:309: warning: expecting prototype for queued_spin_unlock(). Prototype was for native_queued_spin_unlock() instead
> --
>     In file included from include/linux/atomic.h:80,
>                      from include/asm-generic/bitops/atomic.h:5,
>                      from arch/loongarch/include/asm/bitops.h:27,
>                      from include/linux/bitops.h:63,
>                      from include/linux/kernel.h:23,
>                      from include/linux/cpumask.h:11,
>                      from include/linux/smp.h:13,
>                      from kernel/locking/qspinlock.c:16:
>     kernel/locking/qspinlock_paravirt.h: In function 'pv_kick_node':
>>> include/linux/atomic/atomic-arch-fallback.h:242:34: error: initialization of 'u8 *' {aka 'unsigned char *'} from incompatible pointer type 'enum vcpu_state *' [-Wincompatible-pointer-types]
>       242 |         typeof(*(_ptr)) *___op = (_oldp), ___o = *___op, ___r; \
>           |                                  ^
>     include/linux/atomic/atomic-instrumented.h:4908:9: note: in expansion of macro 'raw_try_cmpxchg_relaxed'
>      4908 |         raw_try_cmpxchg_relaxed(__ai_ptr, __ai_oldp, __VA_ARGS__); \
>           |         ^~~~~~~~~~~~~~~~~~~~~~~
>     kernel/locking/qspinlock_paravirt.h:377:14: note: in expansion of macro 'try_cmpxchg_relaxed'
>       377 |         if (!try_cmpxchg_relaxed(&pn->state, &old, vcpu_hashed))
>           |              ^~~~~~~~~~~~~~~~~~~
> 
> 
> vim +309 arch/loongarch/kernel/paravirt.c
> 
>     303	
>     304	/**
>     305	 * queued_spin_unlock - release a queued spinlock
>     306	 * @lock : Pointer to queued spinlock structure
>     307	 */
>     308	static void native_queued_spin_unlock(struct qspinlock *lock)
>   > 309	{
>     310		/*
>     311		 * unlock() needs release semantics:
>     312		 */
>     313		smp_store_release(&lock->locked, 0);
>     314	}
>     315	
> 


