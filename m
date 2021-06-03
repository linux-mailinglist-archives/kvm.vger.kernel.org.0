Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D7439A12C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhFCMhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:37:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7093 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhFCMhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:37:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fwlg32jSmzYqSD;
        Thu,  3 Jun 2021 20:33:19 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:36:04 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:36:02 +0800
Subject: Re: [PATCH v5 1/6] KVM: arm64: Introduce KVM_PGTABLE_S2_GUEST stage-2
 flag
To:     Quentin Perret <qperret@google.com>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-2-wangyanan55@huawei.com> <YLdg3K6m0P+cis2P@google.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <2d5ed3b0-5e8f-572e-cee9-84d6c9d2410c@huawei.com>
Date:   Thu, 3 Jun 2021 20:36:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YLdg3K6m0P+cis2P@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Quentin,

On 2021/6/2 18:43, Quentin Perret wrote:
> Hi Yanan,
>
> On Thursday 15 Apr 2021 at 19:50:27 (+0800), Yanan Wang wrote:
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index c3674c47d48c..a43cbe697b37 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -61,10 +61,12 @@ struct kvm_pgtable_mm_ops {
>>    * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
>>    *				ARM64_HAS_STAGE2_FWB.
>>    * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
>> + * @KVM_PGTABLE_S2_GUEST:	Whether the page-tables are guest stage-2.
>>    */
>>   enum kvm_pgtable_stage2_flags {
>>   	KVM_PGTABLE_S2_NOFWB			= BIT(0),
>>   	KVM_PGTABLE_S2_IDMAP			= BIT(1),
>> +	KVM_PGTABLE_S2_GUEST			= BIT(2),
> Assuming that we need this flag (maybe not given Marc's suggestion on
> another patch), I'd recommend re-naming it to explain _what_ it does,
> rather than _who_ is using it.
I agree with this.
> That's the principle we followed for e.g. KVM_PGTABLE_S2_IDMAP, so we
> should be consistent here as well.
But I think maybe we don't need the new flag anymore with Marc's suggestion.
Currently the CMOs right before installation or update of a PTE are 
guest-specific.
So if we also take the new optional callbacks as guest specific, then a 
new flag is
not necessary because we can check whether the callbacks have been 
initialized
to determine if we are managing a guest S2 PTE.

Thanks,
Yanan
> Thanks,
> Quentin
> .

