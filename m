Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AF7650D1F
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiLSOTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 09:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLSOTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 09:19:30 -0500
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DE6B18B
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 06:19:28 -0800 (PST)
HMM_SOURCE_IP: 172.18.0.188:37310.1213041187
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-171.223.98.159 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id BCA772800AF;
        Mon, 19 Dec 2022 22:19:23 +0800 (CST)
X-189-SAVE-TO-SEND: huangy81@chinatelecom.cn
Received: from  ([171.223.98.159])
        by app0023 with ESMTP id 43b6fb6fa2844227ab504fb2b386f141 for shivam.kumar1@nutanix.com;
        Mon, 19 Dec 2022 22:19:26 CST
X-Transaction-ID: 43b6fb6fa2844227ab504fb2b386f141
X-Real-From: huangy81@chinatelecom.cn
X-Receive-IP: 171.223.98.159
X-MEDUSA-Status: 0
Sender: huangy81@chinatelecom.cn
Message-ID: <1e078dfc-a3a4-6968-ae80-8a03a8129a4f@chinatelecom.cn>
Date:   Mon, 19 Dec 2022 22:19:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 0/1] QEMU: Dirty quota-based throttling of vcpus
To:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Peter Xu <peterx@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org
References: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
 <0cde1cb7-7fce-c443-760c-2bb244e813fe@nutanix.com> <Y49nAjrD0uxUp+Ll@x1n>
 <8d245f68-e830-2566-2a33-b99f206c6773@chinatelecom.cn>
 <53735f4b-a2fb-8fd3-3103-e96350867e40@nutanix.com>
From:   Hyman Huang <huangy81@chinatelecom.cn>
In-Reply-To: <53735f4b-a2fb-8fd3-3103-e96350867e40@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2022/12/19 3:12, Shivam Kumar 写道:
> 
> 
> On 06/12/22 10:59 pm, Hyman Huang wrote:
>>
>>
>> 在 2022/12/7 0:00, Peter Xu 写道:
>>> Hi, Shivam,
>>>
>>> On Tue, Dec 06, 2022 at 11:18:52AM +0530, Shivam Kumar wrote:
>>>
>>> [...]
>>>
>>>>> Note
>>>>> ----------
>>>>> ----------
>>>>>
>>>>> We understand that there is a good scope of improvement in the current
>>>>> implementation. Here is a list of things we are working on:
>>>>> 1) Adding dirty quota as a migration capability so that it can be 
>>>>> toggled
>>>>> through QMP command.
>>>>> 2) Adding support for throttling guest DMAs.
>>>>> 3) Not enabling dirty quota for the first migration iteration.
>>>
>>> Agreed.
>>>
>>>>> 4) Falling back to current auto-converge based throttling in cases 
>>>>> where dirty
>>>>> quota throttling can overthrottle.
>>>
>>> If overthrottle happens, would auto-converge always be better?
>>>
>>>>>
>>>>> Please stay tuned for the next patchset.
>>>>>
>>>>> Shivam Kumar (1):
>>>>>     Dirty quota-based throttling of vcpus
>>>>>
>>>>>    accel/kvm/kvm-all.c       | 91 
>>>>> +++++++++++++++++++++++++++++++++++++++
>>>>>    include/exec/memory.h     |  3 ++
>>>>>    include/hw/core/cpu.h     |  5 +++
>>>>>    include/sysemu/kvm_int.h  |  1 +
>>>>>    linux-headers/linux/kvm.h |  9 ++++
>>>>>    migration/migration.c     | 22 ++++++++++
>>>>>    migration/migration.h     | 31 +++++++++++++
>>>>>    softmmu/memory.c          | 64 +++++++++++++++++++++++++++
>>>>>    8 files changed, 226 insertions(+)
>>>>>
>>>>
>>>> It'd be great if I could get some more feedback before I send v2. 
>>>> Thanks.
>>>
>>> Sorry to respond late.
>>>
>>> What's the status of the kernel patchset?
>>>
>>>  From high level the approach looks good at least to me.  It's just 
>>> that (as
>>> I used to mention) we have two similar approaches now on throttling the
>>> guest for precopy.  I'm not sure what's the best way to move forward if
>>> without doing a comparison of the two.
>>>
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_cover.1669047366.git.huangy81-40chinatelecom.cn_&d=DwIDaQ&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=CuJmsk4azThm0mAIiykxHz3F9q4xRCxjXeS5Q00YL6-FSnPF_BKSyW1y8LIiXqRA&s=QjAcViWNO5THFQvljhrWbDX30yTipTb7KEKWKkc2kDU&e=
>>> Sorry to say so, and no intention to create a contention, but merging 
>>> the
>>> two without any thought will definitely confuse everybody.  We need to
>>> figure out a way.
>>>
>>>  From what I can tell..
>>>
>>> One way is we choose one of them which will be superior to the other and
>>> all of us stick with it (for either higher possibility of migrate, less
>>> interference to the workloads, and so on).
>>>
>>> The other way is we take both, when each of them may be suitable for
>>> different scenarios.  However in this latter case, we'd better at 
>>> least be
>>> aware of the differences (which suites what), then that'll be part of
>>> documentation we need for each of the features when the user wants to 
>>> use
>>> them.
>>>
>>> Add Yong into the loop.
>>>
>>> Any thoughts?
>>>
>> This is quite different from "dirtylimit capability of migration". 
>> IMHO, quota-based implementation seems a little complicated, because 
>> it depends on correctness of dirty quota and the measured data, which 
>> involves the patchset both in qemu and kernel. It seems that 
>> dirtylimit and quota-based are not mutually exclusive, at least we can 
>> figure out
>> which suites what firstly depending on the test results as Peter said.
>>
> Thank you for sharing the link to this alternate approach towards 
> throttling - "dirtylimit capability of migration". I am sharing key 
> points from my understanding and some questions below:
> 
> 1) The alternate approach is exclusively for the dirty ring interface. 
> The dirty quota approach is orthogonal to the dirty logging interface. 
> It works both with the dirty ring and the dirty bitmap interface.
> 
> 2) Can we achieve micro-stunning with the alternate approach? Can we say 
> with good confidence that for most of the time, we stun the vcpu only 
> when it is dirtying the memory? Last time when I checked, dirty ring 
> size could be a multiple of 512 which makes it difficult to stun the 
> vcpu in microscopic intervals.
Actually, we implement dirtylimit in two phase, dirtylimit hmp/qmp 
command and dirtylimit migration, dirtylimit hmp/qmp focus on the 
so-called "micro-stunning" only, dirtylimit migration just reusing 
mainly the existing functions qmp_set_vcpu_dirty_limit.
As for the question:

Can we achieve micro-stunning with the alternate approach?
Yes, since migration iterate in milliseconds for most scenarios, and 
dirtylimit can satisfy it with appropriate ring size, from the test 
result, setting dirty ring size as 2048 is enough,(which can make
migration convergent, but auto-converge can not, in the same condition)

we stun the vcpu only when it is dirtying the memory?
Yes. dirty-ring in kvm is basing on intel PML, which can ensure this.
> 
> 3) Also, are we relying on the system administrator to select a limit on 
> the dirty rate for "dirtylimit capability of migration"?
> 
Not really, this is optional, dirtylimit migration set the 1MB/s as the
default dirtylimit minimum value, which make the value decreasing step 
by step and try the best to make migration convergent, in this way, 
dirtylimit can stop in time once migration reach the convergence criterion.
> 4) Also, does "dirtylimit capability of migration" play with the dirty 
> ring size in a way that it uses a larger ring size for higher dirty rate 
> limits and smaller ring size for smaller dirty rate limits? I think the 
> dirty rate limit is good information to choose a good-enough dirty ring 
> size.
> 
Actually we productize dirtylimit migration in a different way, we set 
the dirty ring size as 2048 by default once enabled, which ensure the 
"micro-stunning" in migraion phase and prove to be a good choice from 
the test result. We think dirty-ring size is "good-enough" if migration 
performance(migration total time, cpu/memory performance in vm during 
live migration) improved hugely.

As for dirtylimit itself, we leave the choice to upper apps, we assume 
that if upper apps are professional to decide the dirtylimit value,dirty 
ring size will also be considered.

Thanks.
> 
> Thanks,
> Shivam

-- 
Best regard

Hyman Huang(黄勇)
