Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2159A068A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 17:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfH1PqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 11:46:07 -0400
Received: from foss.arm.com ([217.140.110.172]:33514 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbfH1PqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 11:46:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3365128;
        Wed, 28 Aug 2019 08:46:06 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 213FF3F59C;
        Wed, 28 Aug 2019 08:46:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 10/16] lib: Add UL and ULL definitions
 to linux/const.h
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com, andre.przywara@arm.com
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-11-git-send-email-alexandru.elisei@arm.com>
 <20190828151006.x6bfxlseqp5s55su@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c476a2cc-98d7-6315-a742-df252ff56be5@arm.com>
Date:   Wed, 28 Aug 2019 16:46:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190828151006.x6bfxlseqp5s55su@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/28/19 4:10 PM, Andrew Jones wrote:
> On Wed, Aug 28, 2019 at 02:38:25PM +0100, Alexandru Elisei wrote:
>> The UL macro was previously defined in lib/arm64/asm/pgtable-hwdef.h. Move
>> it to lib/linux/const.h so it can be used in other files. To keep things
>> consistent, also add an ULL macro.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/linux/const.h             | 7 +++++--
>>  lib/arm64/asm/pgtable-hwdef.h | 2 --
>>  2 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/linux/const.h b/lib/linux/const.h
>> index c872bfd25e13..e3c7fec3f4b8 100644
>> --- a/lib/linux/const.h
>> +++ b/lib/linux/const.h
>> @@ -21,7 +21,10 @@
>>  #define _AT(T,X)	((T)(X))
>>  #endif
>>  
>> -#define _BITUL(x)	(_AC(1,UL) << (x))
>> -#define _BITULL(x)	(_AC(1,ULL) << (x))
>> +#define UL(x) 		_AC(x, UL)
>> +#define ULL(x)		_AC(x, ULL)
>> +
>> +#define _BITUL(x)	(UL(1) << (x))
>> +#define _BITULL(x)	(ULL(1) << (x))
> I don't mind this, but if we want to keep this file consistent with
> Linux's include/uapi/linux/const.h, which is actually the goal, then we
> should be adding _UL and _ULL instead. But in that case we'd probably
> want to leave the define below.
>
> Thanks,
> drew

Hm... The next patch needs the UL define. Consistency is good, so if we want to
keep it consistent with include/uapi/linux/const.h, then I will change the
defines (and the uses) to _UL and _ULL, if that's fine with you.

Thanks,
Alex
>
>>  
>>  #endif /* !(_LINUX_CONST_H) */
>> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
>> index 045a3ce12645..e6f02fae4075 100644
>> --- a/lib/arm64/asm/pgtable-hwdef.h
>> +++ b/lib/arm64/asm/pgtable-hwdef.h
>> @@ -9,8 +9,6 @@
>>   * This work is licensed under the terms of the GNU GPL, version 2.
>>   */
>>  
>> -#define UL(x) _AC(x, UL)
>> -
>>  #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
>>  
>>  /*
>> -- 
>> 2.7.4
>>
