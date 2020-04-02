Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21DFE19C086
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 13:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388070AbgDBLxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 07:53:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48284 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387963AbgDBLxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 07:53:15 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 39F40EDE49B3907DBDD7;
        Thu,  2 Apr 2020 19:52:54 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 19:52:44 +0800
Subject: Re: [kvm-unit-tests PATCH 0/2] arm/arm64: Add IPI/vtimer latency
To:     Andrew Jones <drjones@redhat.com>,
        Jingyi Wang <wangjingyi11@huawei.com>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <wanghaibin.wang@huawei.com>
References: <20200401100812.27616-1-wangjingyi11@huawei.com>
 <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <bbcd3dc4-79c1-7ba2-ea54-96d083dfcef9@huawei.com>
Date:   Thu, 2 Apr 2020 19:52:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew, Jingyi,

On 2020/4/1 20:24, Andrew Jones wrote:
> On Wed, Apr 01, 2020 at 06:08:10PM +0800, Jingyi Wang wrote:
>> With the development of arm gic architecture, we think it will be useful
>> to add some simple performance test in kut to measure the cost of
>> interrupts. X86 arch has implemented similar test.
>>
>> Jingyi Wang (2):
>>    arm/arm64: gic: Add IPI latency test
>>    arm/arm64: Add vtimer latency test
>>
>>   arm/gic.c   | 27 +++++++++++++++++++++++++++
>>   arm/timer.c | 11 +++++++++++
>>   2 files changed, 38 insertions(+)
>>
>> -- 
>> 2.19.1
>>
>>
> 
> Hi Jingyi,
> 
> We already have an IPI latency test in arm/micro-bench.c I'd prefer that
> one be used, if possible, rather than conflating the gic functional tests
> with latency tests. Can you take a look at it and see if it satisfies
> your needs, extending it if necessary?

I think it'd be good to have these interrupt latency measurements in
kvm-unit-tests, and we can take the following interrupt types into
account:

- IPI
   As Drew pointed out, we already have one in the micro-bench group.
   But what I'm actually interested in is the latency of the new GICv4.1
   vSGIs (which will be directly injected through ITS).  To measure it,
   we should first make KUT be GICv4.1-awareness, see [1] for details.
   (This way, we can even have a look at the interrupt latency in HW
   level. Is it possible to have this in kvm-unit-tests, Drew?)

- PPI
   Like what has been done in patch #2, you can choose the vtimer
   interrupt as an example.

- LPI
   I think we can easily build a LPI latency test based on Eric's "ITS
   tests" series [2], which should be upstreamed soon.

- if you want to add more...

What do you think? I'd like to see a V2 of this series :-).


[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0b04758b002bde9434053be2fff8064ac3d9d8bb
[2] 
https://lore.kernel.org/kvm/20200320092428.20880-1-eric.auger@redhat.com/


Thanks,
Zenghui

