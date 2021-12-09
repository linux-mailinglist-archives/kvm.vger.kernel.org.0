Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC93646E14C
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 04:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhLIDfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 22:35:33 -0500
Received: from out28-98.mail.aliyun.com ([115.124.28.98]:57121 "EHLO
        out28-98.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhLIDfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 22:35:33 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07488251|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00366075-0.000202572-0.996137;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047211;MF=haibiao.xiao@zstack.io;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.M6qcIvG_1639020718;
Received: from 172.21.0.111(mailfrom:haibiao.xiao@zstack.io fp:SMTPD_---.M6qcIvG_1639020718)
          by smtp.aliyun-inc.com(10.147.41.231);
          Thu, 09 Dec 2021 11:31:58 +0800
Message-ID: <a6810407-e9b5-e377-a0bf-ee137d7e5638@zstack.io>
Date:   Thu, 9 Dec 2021 11:31:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH kvmtool] Makefile: 'lvm version' works incorrect. Because
 CFLAGS can not get sub-make variable $(KVMTOOLS_VERSION)
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com,
        "haibiao.xiao" <xiaohaibiao331@outlook.com>
References: <20211204061436.36642-1-haibiao.xiao@zstack.io>
 <YbDfecTFlOfPIUs4@monolith.localdoman>
From:   "haibiao.xiao" <haibiao.xiao@zstack.io>
In-Reply-To: <YbDfecTFlOfPIUs4@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Thanks for your reply. I'd like to changed the subject line 
as you suggested. But I don't know how to deal with it, 
should I send another patch mail?

Thanks,
haibiao.xiao

On Wed, 8 Dec 2021 16:38:17 +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Sat, Dec 04, 2021 at 02:14:36PM +0800, haibiao.xiao wrote:
>> From: "haibiao.xiao" <xiaohaibiao331@outlook.com>
> 
> The subject line should be a summary of what the patch does (and perhaps
> why it does it), not a description of what is broken. How about this:
> 
> Makefile: Calculate the correct kvmtool version
> 
> or something else that you prefer. Tested the patch and it works as
> advertised:
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Thanks,
> Alex
> 
>>
>> Command 'lvm version' works incorrect.
>> It is expected to print:
>>
>>     # ./lvm version
>>     # kvm tool [KVMTOOLS_VERSION]
>>
>> but the KVMTOOLS_VERSION is missed:
>>
>>     # ./lvm version
>>     # kvm tool
>>
>> The KVMTOOLS_VERSION is defined in the KVMTOOLS-VERSION-FILE file which
>> is included at the end of Makefile. Since the CFLAGS is a 'Simply
>> expanded variables' which means CFLAGS is only scanned once. So the
>> definetion of KVMTOOLS_VERSION at the end of Makefile would not scanned
>> by CFLAGS. So the '-DKVMTOOLS_VERSION=' remains empty.
>>
>> I fixed the bug by moving the '-include $(OUTPUT)KVMTOOLS-VERSION-FILE'
>> before the CFLAGS.
>>
>> Signed-off-by: haibiao.xiao <xiaohaibiao331@outlook.com>
>> ---
>>  Makefile | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index bb7ad3e..9afb5e3 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -17,6 +17,7 @@ export E Q
>>  
>>  include config/utilities.mak
>>  include config/feature-tests.mak
>> +-include $(OUTPUT)KVMTOOLS-VERSION-FILE
>>  
>>  CC	:= $(CROSS_COMPILE)gcc
>>  CFLAGS	:=
>> @@ -559,5 +560,4 @@ ifneq ($(MAKECMDGOALS),clean)
>>  
>>  KVMTOOLS-VERSION-FILE:
>>  	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
>> --include $(OUTPUT)KVMTOOLS-VERSION-FILE
>> -endif
>> +endif
>> \ No newline at end of file
>> -- 
>> 2.32.0
>>
