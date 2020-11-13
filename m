Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3422B16BF
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 08:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgKMHyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 02:54:54 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7893 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKMHyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 02:54:54 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CXW2m6vhYz76kc;
        Fri, 13 Nov 2020 15:54:40 +0800 (CST)
Received: from [10.174.187.69] (10.174.187.69) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 13 Nov 2020 15:54:44 +0800
Subject: Re: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
To:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <will@kernel.org>, <catalin.marinas@arm.com>, <maz@kernel.org>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>,
        <yezengruan@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <fanhenglong@huawei.com>, <prime.zeng@hisilicon.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <9d341a2d-19f8-400c-6674-ef991ab78f62@huawei.com>
Date:   Fri, 13 Nov 2020 15:54:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200929091727.8692-1-wangjingyi11@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all，

Sorry for the delay. I have been testing the TWED feature performance
lately. We select unixbench as the benchmark for some items of it is 
lock-intensive(fstime/fsbuffer/fsdisk). We run unixbench on a 4-VCPU
VM, and bind every two VCPUs on one PCPU. Fixed TWED value is used and 
here is the result.

      twed_value   | fstime        | fsbuffer   | fsdisk
     --------------+---------------+------------+------------
      disable      | 16.0          | 14.1       | 18.0
      0            | 16.3          | 13.5       | 17.2
      1            | 17.5          | 14.7       | 17.4
      2            | 17.3          | 15.3       | 18.0
      3            | 17.7          | 15.2       | 18.9
      4            | 17.9          | 14.3       | 18.2
      5            | 17.2          | 14.1       | 19.0
      6            | 5.8           | 4.2        | 5.7
      7            | 6.2           | 5.6        | 12.8

Note:
fstime: File Copy 1024 bufsize 2000 maxblocks
fsbuffer: File Copy 256 bufsize 500 maxblocks
fsdisk: File Copy 4096 bufsize 8000 maxblocks
The index of unixbench, higher is better.

It is shown that, compared to the circumstance that TWED is disabled,
lock-intensive testing items have better performance if an appropriate
TWED value is set(up to 5.6%~11.9%). Meanwhile, the complete unixbench
test is run to prove that other testing items are not sensitive to this
parameter.

Thanks
Jingyi

On 9/29/2020 5:17 PM, Jingyi Wang wrote:
> TWE Delay is an optional feature in ARMv8.6 Extentions. There is a
> performance benefit in waiting for a period of time for an event to
> arrive before taking the trap as it is common that event will arrive
> “quite soon” after executing the WFE instruction.
> 
> This series adds support for TWED feature and implements TWE delay
> value dynamic adjustment.
> 
> Thanks for Shameer's advice on this series. The function of this patch
> has been tested on TWED supported hardware and the performance of it is
> still on test, any advice will be welcomed.
> 
> Jingyi Wang (2):
>    KVM: arm64: Make use of TWED feature
>    KVM: arm64: Use dynamic TWE Delay value
> 
> Zengruan Ye (2):
>    arm64: cpufeature: TWED support detection
>    KVM: arm64: Add trace for TWED update
> 
>   arch/arm64/Kconfig                   | 10 +++++
>   arch/arm64/include/asm/cpucaps.h     |  3 +-
>   arch/arm64/include/asm/kvm_arm.h     |  5 +++
>   arch/arm64/include/asm/kvm_emulate.h | 38 ++++++++++++++++++
>   arch/arm64/include/asm/kvm_host.h    | 19 ++++++++-
>   arch/arm64/include/asm/virt.h        |  8 ++++
>   arch/arm64/kernel/cpufeature.c       | 12 ++++++
>   arch/arm64/kvm/arm.c                 | 58 ++++++++++++++++++++++++++++
>   arch/arm64/kvm/handle_exit.c         |  2 +
>   arch/arm64/kvm/trace_arm.h           | 21 ++++++++++
>   10 files changed, 174 insertions(+), 2 deletions(-)
> 
