Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0917302852
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 17:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbhAYQ7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 11:59:20 -0500
Received: from foss.arm.com ([217.140.110.172]:51818 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbhAYQ5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 11:57:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFA5511FB;
        Mon, 25 Jan 2021 08:57:01 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAB733F68F;
        Mon, 25 Jan 2021 08:57:00 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 10/12] arm64: gic: its-trigger: Don't
 trigger the LPI while it is pending
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     eric.auger@redhat.com, yuzenghui@huawei.com
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-11-alexandru.elisei@arm.com>
 <d24f7bf4-2a38-22f8-68e6-98940c61c65a@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3bc9e5ce-345b-505a-ffd3-a96b531124d6@arm.com>
Date:   Mon, 25 Jan 2021 16:57:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <d24f7bf4-2a38-22f8-68e6-98940c61c65a@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/18/20 6:15 PM, André Przywara wrote:
> On 17/12/2020 14:13, Alexandru Elisei wrote:
>> The its-trigger test checks that LPI 8195 is not delivered to the CPU while
>> it is disabled at the ITS level. After that it is re-enabled and the test
>> checks that the interrupt is properly asserted. After it's re-enabled and
>> before the stats are examined, the test triggers the interrupt again, which
>> can lead to the same interrupt being delivered twice: once after the
>> configuration invalidation and before the INT command, and once after the
>> INT command.
>>
>> Get rid of the INT command after the interrupt is re-enabled to prevent the
> This is confusing to read, since you don't remove anything in the patch.
> Can you reword this? Something like "Before explicitly triggering the
> interrupt, check that the unmasking worked, ..."

That's a good point, I'll reword it.

>
>> LPI from being asserted twice and add a separate check to test that the INT
>> command still works for the now re-enabled LPI 8195.
>>
>> CC: Auger Eric <eric.auger@redhat.com>
>> Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Otherwise this looks fine, but I think there is another flaw: There is
> no requirement that an INV(ALL) is *needed* to update the status, it
> could also update anytime (think: "cache invalidate").
>
> The KVM ITS emulation *only* bothers to read the memory on an INV(ALL)
> command, so that matches the test. But that's not how unit-tests should
> work ;-)
>
> But that's a separate issue, just mentioning this to not forget about it.

That's a good point, I must admit that I didn't check how caching is defined by
the architecture. I would prefer creating a patch independent of this series to
change what test_its_trigger() checks for, to get input from Eric just for that
particular change.

Thanks,
Alex
>
> For this patch, with the message fixed:
>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>
> Cheers,
> Andre
>
>> ---
>>  arm/gic.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index fb91861900b7..aa3aa1763984 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -805,6 +805,9 @@ static void test_its_trigger(void)
>>  
>>  	/* Now call the invall and check the LPI hits */
>>  	its_send_invall(col3);
>> +	lpi_stats_expect(3, 8195);
>> +	check_lpi_stats("dev2/eventid=20 pending LPI is received");
>> +
>>  	lpi_stats_expect(3, 8195);
>>  	its_send_int(dev2, 20);
>>  	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
>>
