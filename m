Return-Path: <kvm+bounces-9367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F26D285F54B
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9300EB26434
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625D139FE1;
	Thu, 22 Feb 2024 10:06:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192F439875;
	Thu, 22 Feb 2024 10:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596371; cv=none; b=L1iV842SbOxXXx5NL5CmPOcMcNNFT5x61kUkwGAL9S9S3dZ8JUwL5AuFGBEpMk5gcfAz1hxBw31D5gSC2s269izQa4Rn0tR5z+IIpfCVH2SDumWa/ISkoATj5WuGyIjKSf0+KBLDzLcUGQRAASDuEkhpk/JpFYg4MWEwlJ3sWZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596371; c=relaxed/simple;
	bh=72HRlj4wNG+uTgP9OOegzPNQJN5da4Rz0slrIrJJ5N8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rGcMIkptk50PkqAQmH+wFhkLJm4hT9BQI4T9GBB0r9sa0K4OhLE9LyNuzg4PzUCQ4zHlYYmVH3OyXSFk16/6aXh+R/xROZ3US0OFVhpQhOM7/IYnJeLyiRnqLB6F82910QkbX0yzXjFCZTWwOq+Gb/4OjBABNIUrnP5fPKZ+mC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxnuuKHNdlNSkQAA--.41380S3;
	Thu, 22 Feb 2024 18:06:02 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxf8+HHNdlC7I+AA--.31618S3;
	Thu, 22 Feb 2024 18:06:01 +0800 (CST)
Subject: Re: [PATCH v4 0/6] LoongArch: Add pv ipi support on LoongArch VM
To: WANG Xuerui <kernel@xen0n.name>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240201031950.3225626-1-maobibo@loongson.cn>
 <0f4d83e2-bff9-49d9-8066-9f194ce96306@xen0n.name>
 <447f4279-aea9-4f35-b87e-a3fc8c6c20ac@xen0n.name>
 <4a6e25ec-cdb6-887a-2c64-3df12d30c89a@loongson.cn>
 <7867d9c8-22fb-4bfc-92dc-c782d29c56f9@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <542a8f4e-cec3-92d0-1cdd-43d112eec605@loongson.cn>
Date: Thu, 22 Feb 2024 18:06:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <7867d9c8-22fb-4bfc-92dc-c782d29c56f9@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cxf8+HHNdlC7I+AA--.31618S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7urW5JFykZw15AFy3GrWUKFX_yoW8WFy3pF
	WS9a4UKF4vyry0y392kw40gryYyr4xJr1SqrnYkryqk3y5XryavrsFqr9YgF9xu34fJw1Y
	q3yUtayxXFWUZacCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2MKZDUUUU



On 2024/2/22 下午5:34, WANG Xuerui wrote:
> On 2/17/24 11:15, maobibo wrote:
>> On 2024/2/15 下午6:25, WANG Xuerui wrote:
>>> On 2/15/24 18:11, WANG Xuerui wrote:
>>>> Sorry for the late reply (and Happy Chinese New Year), and thanks 
>>>> for providing microbenchmark numbers! But it seems the more 
>>>> comprehensive CoreMark results were omitted (that's also absent in 
>>>> v3)? While the 
>>>
>>> Of course the benchmark suite should be UnixBench instead of 
>>> CoreMark. Lesson: don't multi-task code reviews, especially not after 
>>> consuming beer -- a cup of coffee won't fully cancel the influence. ;-)
>>>
>> Where is rule about benchmark choices like UnixBench/Coremark for ipi 
>> improvement?
> 
> Sorry for the late reply. The rules are mostly unwritten, but in general 
> you can think of the preference of benchmark suites as a matter of 
> "effectiveness" -- the closer it's to some real workload in the wild, 
> the better. Micro-benchmarks is okay for illustrating the points, but 
> without demonstrating the impact on realistic workloads, a change could 
> be "useless" in practice or even decrease various performance metrics 
> (be that throughput or latency or anything that matters in the certain 
> case), but get accepted without notice.
yes, micro-benchmark cannot represent the real world, however it does 
not mean that UnixBench/Coremark should be run. You need to point out 
what is the negative effective from code, or what is the possible real 
scenario which may benefit. And points out the reasonable benchmark 
sensitive for IPIs rather than blindly saying UnixBench/Coremark.

Regards
Bibo Mao

> 


