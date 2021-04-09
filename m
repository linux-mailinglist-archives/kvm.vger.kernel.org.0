Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C54359869
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 10:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhDII7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 04:59:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3081 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhDII7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 04:59:23 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FGsRF3G8zzWV6R;
        Fri,  9 Apr 2021 16:55:37 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 9 Apr 2021 16:59:09 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 16:59:08 +0800
Subject: Re: [PATCH v4 1/2] KVM: arm64: Move CMOs from user_mem_abort to the
 fault handlers
To:     Quentin Perret <qperret@google.com>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>
References: <20210409033652.28316-1-wangyanan55@huawei.com>
 <20210409033652.28316-2-wangyanan55@huawei.com> <YHALa38PPQBceqF9@google.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <67c497cc-5a74-e431-a9bc-d05582998bbe@huawei.com>
Date:   Fri, 9 Apr 2021 16:59:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YHALa38PPQBceqF9@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Quentin,

On 2021/4/9 16:08, Quentin Perret wrote:
> Hi Yanan,
>
> On Friday 09 Apr 2021 at 11:36:51 (+0800), Yanan Wang wrote:
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> +static void stage2_invalidate_icache(void *addr, u64 size)
>> +{
>> +	if (icache_is_aliasing()) {
>> +		/* Flush any kind of VIPT icache */
>> +		__flush_icache_all();
>> +	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
>> +		/* PIPT or VPIPT at EL2 */
>> +		invalidate_icache_range((unsigned long)addr,
>> +					(unsigned long)addr + size);
>> +	}
>> +}
>> +
> I would recommend to try and rebase this patch on kvmarm/next because
> we've made a few changes in pgtable.c recently. It is now linked into
> the EL2 NVHE code which means there are constraints on what can be used
> from there -- you'll need a bit of extra work to make some of these
> functions available to EL2.
I see, thanks for reminding me this.
I will work on kvmarm/next and send a new version later.

Thanks,
Yanan
>
> Thanks,
> Quentin
> .
