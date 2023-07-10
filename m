Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95AE74C9CA
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 04:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjGJCEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jul 2023 22:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjGJCEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jul 2023 22:04:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA36101
        for <kvm@vger.kernel.org>; Sun,  9 Jul 2023 19:04:39 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QznN41q1JzTmQZ;
        Mon, 10 Jul 2023 10:03:16 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 10:04:25 +0800
Subject: Re: [PATCH] KVM: arm64: Keep need_db always true in vgic_v4_put()
 when emulating WFI
To:     Oliver Upton <oliver.upton@linux.dev>
References: <1688720145-37923-1-git-send-email-chenxiang66@hisilicon.com>
 <ZKhIXFlPykpvI8MG@linux.dev>
CC:     <maz@kernel.org>, <james.morse@arm.com>, <kvmarm@lists.linux.dev>,
        <kvm@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <24c130cd-b4ac-de18-770e-8495acd41114@hisilicon.com>
Date:   Mon, 10 Jul 2023 10:04:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <ZKhIXFlPykpvI8MG@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,


在 2023/7/8 星期六 1:16, Oliver Upton 写道:
> Hi Xiang,
>
> Thanks for reporting this.
>
> On Fri, Jul 07, 2023 at 04:55:45PM +0800, chenxiang wrote:
>> When enabled GICv4.1 on Kunpeng 920 platform with 6.4 kernel (preemptible
>> kernel), running a vm with 128 vcpus on 64 pcpu, sometimes vm is not booted
>> successfully, and we find there is a situation that doorbell interrupt will
>> not occur event if there is a pending interrupt.
> Oh, that's no good.
>
>> ---
>>   arch/arm64/kvm/vgic/vgic-v4.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index c1c28fe..37152cf8 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -343,6 +343,9 @@ int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
>>   	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
>>   		return 0;
>>   
>> +	if (vcpu->stat.generic.blocking == 1)
>> +		need_db = true;
>> +
> As I understand it, the issue really comes from the fact that @need_db
> is always false when called from vgic_v3_put(). I'd rather we not
> override the argument, as that could have unintended consequences in the
> future.
>
> You could also use the helper we already have for determining if a vCPU
> is blocking, which we could use as a hint for requesting a doorbell
> interrupt on sched out.
>
> Putting the two comments together, I arrived at the following (untested)
> diff. I don't have a GICv4 system on hand, sadly. Mind taking it for a
> spin?

Right, it is more suitable to use the helper we already have for 
determining if a vCPU is blocking.
We have tested the following diff you provide, and it solves the issue, 
so please feel free to add for the change:
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>


>
> --
> Thanks,
> Oliver
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 93a47a515c13..8c743643b122 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -756,7 +756,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
>   {
>   	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>   
> -	WARN_ON(vgic_v4_put(vcpu, false));
> +	WARN_ON(vgic_v4_put(vcpu, kvm_vcpu_is_blocking(vcpu)));
>   
>   	vgic_v3_vmcr_sync(vcpu);
>   
> .
>

