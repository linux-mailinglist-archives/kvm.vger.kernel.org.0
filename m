Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75607752FC4
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 05:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbjGNDNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 23:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbjGNDNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 23:13:47 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5DD2D72
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 20:13:46 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4R2Gkq14Lwz18M7y;
        Fri, 14 Jul 2023 11:13:07 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 11:13:43 +0800
Subject: Re: [PATCH] KVM: arm64: Fix the name of sys_reg_desc related to PMU
To:     Marc Zyngier <maz@kernel.org>
References: <1689148505-13914-1-git-send-email-chenxiang66@hisilicon.com>
 <868rblwmpn.wl-maz@kernel.org>
 <5c513a72-9ae9-22ca-a9a6-8b3c481e0921@hisilicon.com>
 <87bkgg9u54.wl-maz@kernel.org>
 <4cbcc10d-6cd2-d88e-b15d-bd4f1a229251@hisilicon.com>
 <86wmz4up2z.wl-maz@kernel.org>
CC:     <oliver.upton@linux.dev>, <james.morse@arm.com>,
        <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <04ff4473-0d01-8054-8381-d11b6ecd68ad@hisilicon.com>
Date:   Fri, 14 Jul 2023 11:13:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <86wmz4up2z.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,


在 2023/7/13 星期四 17:40, Marc Zyngier 写道:
> On Thu, 13 Jul 2023 10:10:01 +0100,
> "chenxiang (M)" <chenxiang66@hisilicon.com> wrote:
>> Hi Marc,
>>
>>
>> 在 2023/7/13 星期四 14:56, Marc Zyngier 写道:
>>> On Thu, 13 Jul 2023 03:35:39 +0100,
>>> "chenxiang (M)" <chenxiang66@hisilicon.com> wrote:
>>>> Hi Marc,
>>>>
>>>>
>>>> 在 2023/7/12 星期三 16:36, Marc Zyngier 写道:
>>>>> On Wed, 12 Jul 2023 08:55:05 +0100,
>>>>> chenxiang <chenxiang66@hisilicon.com> wrote:
>>>>>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>>>>>
>>>>>> For those PMU system registers defined in sys_reg_descs[], use macro
>>>>>> PMU_SYS_REG() / PMU_PMEVCNTR_EL0 / PMU_PMEVTYPER_EL0 to define them, and
>>>>>> later two macros call macro PMU_SYS_REG() actually.
>>>>>> Currently the input parameter of PMU_SYS_REG() is other macro which is
>>>>>> calculation formula of the value of system registers, so for example, if
>>>>>> we want to "SYS_PMINTENSET_EL1" as the name of sys register, actually
>>>>>> the name will be as following:
>>>>>> (((3) << 19) | ((0) << 16) | ((9) << 12) | ((14) << 8) | ((1) << 5))
>>>>>>
>>>>>> To fix the issue, use the name as a input parameter of PMU_SYS_REG like
>>>>>> MTE_REG or EL2_REG.
>>>>> Why is the name relevant? Is this related to tracing?
>>>> I think It is not related to tracing. I find the issue when i want to
>>>> know which system reigsters are set
>>>> when on live migration and printk the name of sys_reg_desc in function
>>>> kvm_sys_reg_set_user,
>>>> find the name of some registers are abnormal as followings:
>>>>
>>>> [  227.145540] kvm_sys_reg_set_user 3427:SYS_FAR_EL1
>>>> [  227.158057] kvm_sys_reg_set_user 3427:SYS_PAR_EL1
>>>> [  227.170574] kvm_sys_reg_set_user 3427:(((3) << 19) | ((0) << 16) |
>>>> ((9) << 12) | ((14) << 8) | ((1) << 5))
>>>> [  227.188037] kvm_sys_reg_set_user 3427:(((3) << 19) | ((0) << 16) |
>>>> ((9) << 12) | ((14) << 8) | ((2) << 5))
>>>> [  227.205511] kvm_sys_reg_set_user 3427:SYS_MAIR_EL1
>>>> [  227.218117] kvm_sys_reg_set_user 3427:SYS_PIRE0_EL1
>>> So what is this if not some form of tracing?
>> Ah, i was misunderstood your question. I thought you aksed whether
>> it is related to kernel tracing (which is already existed in kernel)
>> such as tracepoint or debugfs.
> But that's my point: tracepoints such as kvm_sys_access already output
> the name (as well as the encoding), and are likely to be affected by
> this problem.
>
> And that's a much more interesting justification for this change.

Got it. Thanks.

>
> Thanks,
>
> 	M.
>

