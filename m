Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA5D23D56A
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 04:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgHFC03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 22:26:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8771 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbgHFC02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 22:26:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6C8951545C524298B78F;
        Thu,  6 Aug 2020 10:26:26 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.106) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 6 Aug 2020
 10:26:24 +0800
Subject: Re: Patch "KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts" has
 been added to the 4.4-stable tree
To:     <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <james.morse@arm.com>, <maz@kernel.org>, <drjones@redhat.com>,
        <marc.zyngier@arm.com>, <christoffer.dall@linaro.org>
CC:     <stable-commits@vger.kernel.org>, <kvm@vger.kernel.org>
References: <159230500664142@kroah.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <6084bc97-11ea-4b7d-086e-fb98880fca6c@huawei.com>
Date:   Thu, 6 Aug 2020 10:26:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <159230500664142@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.106]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Not familiar with kvm. And I have a question about this patch. Maybe 
backport this patch 3204be4109ad("KVM: arm64: Make vcpu_cp1x() work on 
Big Endian hosts") without 52f6c4f02164 ("KVM: arm64: Change 32-bit 
handling of VM system registers") seems not right?

Thanks,
Kun.

在 2020/6/16 18:56, gregkh@linuxfoundation.org 写道:
> 
> This is a note to let you know that I've just added the patch titled
> 
>      KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
> 
> to the 4.4-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       kvm-arm64-make-vcpu_cp1x-work-on-big-endian-hosts.patch
> and it can be found in the queue-4.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
>>From 3204be4109ad681523e3461ce64454c79278450a Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Tue, 9 Jun 2020 08:40:35 +0100
> Subject: KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
> 
> From: Marc Zyngier <maz@kernel.org>
> 
> commit 3204be4109ad681523e3461ce64454c79278450a upstream.
> 
> AArch32 CP1x registers are overlayed on their AArch64 counterparts
> in the vcpu struct. This leads to an interesting problem as they
> are stored in their CPU-local format, and thus a CP1x register
> doesn't "hit" the lower 32bit portion of the AArch64 register on
> a BE host.
> 
> To workaround this unfortunate situation, introduce a bias trick
> in the vcpu_cp1x() accessors which picks the correct half of the
> 64bit register.
> 
> Cc: stable@vger.kernel.org
> Reported-by: James Morse <james.morse@arm.com>
> Tested-by: James Morse <james.morse@arm.com>
> Acked-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>   arch/arm64/include/asm/kvm_host.h |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -178,8 +178,10 @@ struct kvm_vcpu_arch {
>    * CP14 and CP15 live in the same array, as they are backed by the
>    * same system registers.
>    */
> -#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
> -#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
> +#define CPx_BIAS		IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)
> +
> +#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_BIAS])
> +#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_BIAS])
>   
>   #ifdef CONFIG_CPU_BIG_ENDIAN
>   #define vcpu_cp15_64_high(v,r)	vcpu_cp15((v),(r))
> 
> 
> Patches currently in stable-queue which might be from maz@kernel.org are
> 
> queue-4.4/kvm-arm64-make-vcpu_cp1x-work-on-big-endian-hosts.patch
> 
> .
> 

