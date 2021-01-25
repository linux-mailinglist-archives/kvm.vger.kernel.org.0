Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2C4302736
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 16:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbhAYPtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 10:49:05 -0500
Received: from foss.arm.com ([217.140.110.172]:49812 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730511AbhAYPsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 10:48:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 906B81042;
        Mon, 25 Jan 2021 07:17:08 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBF5E3F68F;
        Mon, 25 Jan 2021 07:17:07 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 11/12] lib: arm64: gic-v3-its: Add wmb()
 barrier before INT command
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     eric.auger@redhat.com, yuzenghui@huawei.com
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-12-alexandru.elisei@arm.com>
 <bb0faa84-d12f-05b7-9913-155ebfcb3073@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <91d1faad-684b-174c-8e08-1920a5eff08b@arm.com>
Date:   Mon, 25 Jan 2021 15:16:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <bb0faa84-d12f-05b7-9913-155ebfcb3073@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/18/20 6:36 PM, André Przywara wrote:
> On 17/12/2020 14:13, Alexandru Elisei wrote:
>> The ITS tests use the INT command like an SGI. The its_send_int() function
>> kicks a CPU and then the test checks that the interrupt was observed as
>> expected in check_lpi_stats(). This is done by using lpi_stats.observed and
>> lpi_stats.expected, where the target CPU only writes to lpi_stats.observed,
>> and the source CPU reads it and compares the values with
>> lpi_stats.expected.
>>
>> The fact that the target CPU doesn't read data written by the source CPU
>> means that we don't need to do inter-processor memory synchronization
>> for that between the two at the moment.
>>
>> The acked array is used by its-pending-migration test, but the reset value
>> for acked (zero) is the same as the initialization value for static
>> variables, so memory synchronization is again not needed.
>>
>> However, that is all about to change when we modify all ITS tests to use
>> the same functions as the IPI tests. Add a write memory barrier to
>> its_send_int(), similar to the gicv3_ipi_send_mask(), which has similar
>> semantics.
> I agree to the requirement for having the barrier, but am not sure this
> is the right place. Wouldn't it be better to have the barrier in the
> callers?
>
> Besides: This command is written to the command queue (in normal
> memory), then we notify the ITS via an MMIO writeq. And this one has a
> "wmb" barrier already (though for other reasons).

Had another look, and you're totally right: its_post_commands() already has a
wmb() in writeq(), thank you for pointing it out. This makes the wmb() which I've
added pointless, I'll drop the patch since it doesn't add useful.

Thanks,
Alex
>
> Cheers,
> Andre
>
>
>> Suggested-by: Auger Eric <eric.auger@redhat.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm64/gic-v3-its-cmd.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/lib/arm64/gic-v3-its-cmd.c b/lib/arm64/gic-v3-its-cmd.c
>> index 34574f71d171..32703147ee85 100644
>> --- a/lib/arm64/gic-v3-its-cmd.c
>> +++ b/lib/arm64/gic-v3-its-cmd.c
>> @@ -385,6 +385,12 @@ void __its_send_int(struct its_device *dev, u32 event_id, bool verbose)
>>  {
>>  	struct its_cmd_desc desc;
>>  
>> +	/*
>> +	 * The INT command is used by tests as an IPI. Ensure stores to Normal
>> +	 * memory are visible to other CPUs before sending the LPI.
>> +	 */
>> +	wmb();
>> +
>>  	desc.its_int_cmd.dev = dev;
>>  	desc.its_int_cmd.event_id = event_id;
>>  	desc.verbose = verbose;
>>
