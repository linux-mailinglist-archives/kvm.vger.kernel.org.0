Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB5119C146
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgDBMkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 08:40:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12608 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388164AbgDBMkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 08:40:51 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D905A6F00FF2ADCB7EC9;
        Thu,  2 Apr 2020 20:40:49 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 20:40:43 +0800
Subject: Re: [kvm-unit-tests PATCH v7 10/13] arm/arm64: ITS: INT functional
 tests
To:     Auger Eric <eric.auger@redhat.com>
CC:     <eric.auger.pro@gmail.com>, <maz@kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <drjones@redhat.com>, <andre.przywara@arm.com>,
        <peter.maydell@linaro.org>, <alexandru.elisei@arm.com>,
        <thuth@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-11-eric.auger@redhat.com>
 <f7f1d7c4-2321-9123-2394-528af737bfa7@huawei.com>
 <fa4e14f6-20ee-982f-0eda-74b101cddf7a@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <114f8bba-a1e0-0367-a1b4-e875718d8dba@huawei.com>
Date:   Thu, 2 Apr 2020 20:40:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <fa4e14f6-20ee-982f-0eda-74b101cddf7a@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/4/2 16:50, Auger Eric wrote:
> Hi Zenghui,
> 
> On 3/30/20 12:43 PM, Zenghui Yu wrote:
>> Hi Eric,
>>
>> On 2020/3/20 17:24, Eric Auger wrote:
>>> Triggers LPIs through the INT command.
>>>
>>> the test checks the LPI hits the right CPU and triggers
>>> the right LPI intid, ie. the translation is correct.
>>>
>>> Updates to the config table also are tested, along with inv
>>> and invall commands.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> [...]
>>
>> So I've tested this series and found that the "INT" test will sometimes
>> fail.
>>
>> "not ok 12 - gicv3: its-migration: dev2/eventid=20 triggers LPI 8195 en
>> PE #3 after migration
>> not ok 13 - gicv3: its-migration: dev7/eventid=255 triggers LPI 8196 on
>> PE #2 after migration"
>>
>>  From logs:
>> "INFO: gicv3: its-migration: Migration complete
>> INT dev_id=2 event_id=20
>> INFO: gicv3: its-migration: No LPI received whereas (cpuid=3,
>> intid=8195) was expected
>> FAIL: gicv3: its-migration: dev2/eventid=20 triggers LPI 8195 en PE #3
>> after migration
>> INT dev_id=7 event_id=255
>> INFO: gicv3: its-migration: No LPI received whereas (cpuid=2,
>> intid=8196) was expected
>> FAIL: gicv3: its-migration: dev7/eventid=255 triggers LPI 8196 on PE #2
>> after migration"
>>
>>> +static void check_lpi_stats(const char *msg)
>>> +{
>>> +    bool pass = false;
>>> +
>>> +    mdelay(100);
>>
>> After changing this to 'mdelay(1000)', the above error doesn't show up
>> anymore. But it sounds strange that 100ms is not enough to deliver a
>> single LPI. I haven't dig it further but will get back here later.
> 
> Did you find some time to investigate this issue. Changing 100 to 1000
> has a huge impact on the overall test duration and I don't think it is
> sensible. Could you see what is your minimal value that pass the tests?

I can reproduce this issue with a very *low* probability so I failed
to investigate it :-(.  (It might because the LPI was delivered to a
busy vcpu...)

You can leave it as it is until someone else complain about it again.
Or take the similar approach as check_acked() - wait up to 5s for the
interrupt to be delivered, and bail out as soon as we see it.


Thanks,
Zenghui

