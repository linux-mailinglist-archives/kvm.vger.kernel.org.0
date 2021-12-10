Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DB346F967
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 03:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhLJC7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 21:59:18 -0500
Received: from out28-100.mail.aliyun.com ([115.124.28.100]:37580 "EHLO
        out28-100.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhLJC7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 21:59:17 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07455772|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00302495-0.000273766-0.996701;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=haibiao.xiao@zstack.io;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.M8-.uzC_1639104940;
Received: from 172.21.0.111(mailfrom:haibiao.xiao@zstack.io fp:SMTPD_---.M8-.uzC_1639104940)
          by smtp.aliyun-inc.com(10.147.44.118);
          Fri, 10 Dec 2021 10:55:40 +0800
Message-ID: <28ff4bb3-851a-e287-b008-c2a91370c90d@zstack.io>
Date:   Fri, 10 Dec 2021 10:55:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH kvmtool] Makefile: 'lvm version' works incorrect. Because
 CFLAGS can not get sub-make variable $(KVMTOOLS_VERSION)
Content-Language: en-US
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com,
        "haibiao.xiao" <xiaohaibiao331@outlook.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
References: <20211204061436.36642-1-haibiao.xiao@zstack.io>
 <20211209155746.3f6bd016@donnerap.cambridge.arm.com>
From:   "haibiao.xiao" <haibiao.xiao@zstack.io>
In-Reply-To: <20211209155746.3f6bd016@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, 9 Dec 2021 15:57:46 +0000, Andre Przywara wrote:
> On Sat,  4 Dec 2021 14:14:36 +0800
> "haibiao.xiao" <haibiao.xiao@zstack.io> wrote:
> 
> Hi,
> 
>> From: "haibiao.xiao" <xiaohaibiao331@outlook.com>
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
> 
> While this is indeed a bug that this patch fixes, I wonder if we should
> actually get rid of this whole versioning attempt altogether at this
> point. Originally this was following the containing kernel version, but
> it is stuck ever since at v3.18, without any change.
> 
> So either we introduce proper versioning (not sure it's worth it?), or we
> just remove all code that pretends to print a version number? Or just
> hardcode v3.18 into the printf, at least for now? At the very least I
> think we don't need a KVMTOOLS-VERSION-FILE anymore.
> 

Thanks for your reply. 

The reason I look at this project is tend to learn something about kvm. 
With the version number I can tell which kernel(kvm) is compatible.
 
Although it is stuck at v3.18, there still some commits in recent 
months, which means the kvmtool still changing according to the kvm 
features. So I think what's kvmtool need is a version control, but not 
remove/hardcode.

Thanks,
haibiao.xiao
> Cheers,
> Andre
> 
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
