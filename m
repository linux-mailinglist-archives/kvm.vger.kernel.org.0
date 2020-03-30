Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A78197CAB
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 15:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgC3NR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 09:17:58 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12653 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730015AbgC3NR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 09:17:58 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6D6481EB6A23AB42A64A;
        Mon, 30 Mar 2020 21:17:54 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 21:17:48 +0800
Subject: Re: [kvm-unit-tests PATCH v7 13/13] arm/arm64: ITS: pending table
 migration test
To:     Auger Eric <eric.auger@redhat.com>
CC:     <peter.maydell@linaro.org>, <drjones@redhat.com>,
        <kvm@vger.kernel.org>, <maz@kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <andre.przywara@arm.com>,
        <thuth@redhat.com>, <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>, <eric.auger.pro@gmail.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-14-eric.auger@redhat.com>
 <296c574b-810c-9c90-a613-df732a9ac193@huawei.com>
 <ea74559c-2ab4-752c-e587-2bf40eab14b0@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <0e73fd13-ca18-2d17-2267-fd5d852e3ac8@huawei.com>
Date:   Mon, 30 Mar 2020 21:17:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <ea74559c-2ab4-752c-e587-2bf40eab14b0@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/30 20:38, Auger Eric wrote:
> Hi Zenghui,

[...]

>>> +
>>> +    ptr = gicv3_data.redist_base[pe0] + GICR_PENDBASER;
>>> +    pendbaser = readq(ptr);
>>> +    writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>>> +
>>> +    ptr = gicv3_data.redist_base[pe1] + GICR_PENDBASER;
>>> +    pendbaser = readq(ptr);
>>> +    writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>>> +
>>> +    gicv3_lpi_rdist_enable(pe0);
>>> +    gicv3_lpi_rdist_enable(pe1);
>>
>> I don't know how the migration gets implemented in kvm-unit-tests.
>> But is there any guarantee that the LPIs will only be triggered on the
>> destination side? As once the EnableLPIs bit becomes 1, VGIC will start
>> reading the pending bit in guest memory and potentially injecting LPIs
>> into the target vcpu (in the source side).
> 
> I expect some LPIs to hit on source and some others to hit on the
> destination. To me, this does not really matter as long as the handlers
> gets called and accumulate the stats. Given the number of LPIs, we will
> at least test the migration of some of the pending bits and especially
> adjacent ones. It does work as it allows to test your fix:
> 
> ca185b260951  KVM: arm/arm64: vgic: Don't rely on the wrong pending table

Fair enough. Thanks for your explanation!


Zenghui

