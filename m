Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1945464575E
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 11:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiLGKRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 05:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiLGKRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 05:17:17 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D6D42F55
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 02:17:07 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NRtV90dQZz15MpP;
        Wed,  7 Dec 2022 18:16:17 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 18:16:34 +0800
Subject: Re: [RFC PATCH 0/2] Add vcpu debugfs to record statstical data for
 every single
To:     Marc Zyngier <maz@kernel.org>
References: <1670331508-67322-1-git-send-email-chenxiang66@hisilicon.com>
 <87359rtyhz.wl-maz@kernel.org>
CC:     <pbonzini@redhat.com>, <james.morse@arm.com>,
        <kvm@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <d4d06f9f-34a9-055c-c482-b49ca011db0a@hisilicon.com>
Date:   Wed, 7 Dec 2022 18:16:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <87359rtyhz.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2022/12/7 16:21, Marc Zyngier 写道:
> On Tue, 06 Dec 2022 12:58:26 +0000,
> chenxiang <chenxiang66@hisilicon.com> wrote:
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> Currently it only records statistical data for all vcpus, but we ofen want
>> to know statistical data for a single vcpu, there is no debugfs for that.
>> So add vcpu debugfs to record statstical data for every single vcpu, and
>> also enable vcpu debugfs for arm64.
>>
>> After the change, those vcpu debugfs are as follows (we have 4 vcpu in the
>> vm):
>>
>> [root@centos kvm]# cd 2025-14/
>> [root@centos 2025-14]# ls
>> blocking                halt_wait_hist             vcpu0
>> exits                   halt_wait_ns               vcpu1
>> halt_attempted_poll     halt_wakeup                vcpu2
>> halt_poll_fail_hist     hvc_exit_stat              vcpu3
>> halt_poll_fail_ns       mmio_exit_kernel           vgic-state
>> halt_poll_invalid       mmio_exit_user             wfe_exit_stat
>> halt_poll_success_hist  remote_tlb_flush           wfi_exit_stat
>> halt_poll_success_ns    remote_tlb_flush_requests
>> halt_successful_poll    signal_exits
>> [root@centos 2025-14]# cat exits
>> 124689
>> [root@centos 2025-14]# cat vcpu0/exits
>> 52966
>> [root@centos 2025-14]# cat vcpu1/exits
>> 21549
>> [root@centos 2025-14]# cat vcpu2/exits
>> 43864
>> [root@centos 2025-14]# cat vcpu3/exits
>> 6572
>> [root@centos 2025-14]# ls vcpu0
>> blocking             halt_poll_invalid       halt_wait_ns      pid
>> exits                halt_poll_success_hist  halt_wakeup       signal_exits
>> halt_attempted_poll  halt_poll_success_ns    hvc_exit_stat     wfe_exit_stat
>> halt_poll_fail_hist  halt_successful_poll    mmio_exit_kernel  wfi_exit_stat
>> halt_poll_fail_ns    halt_wait_hist          mmio_exit_user
> This is yet another example of "KVM doesn't give me the stats I want,
> so let's pile more stats on top". This affects every users (counters
> are not free), and hardly benefits anyone.

Currently it already has vcpu debugfs on top, but it only records 
statstical data for total vm
which is helpless for debug, for example, file exists records the number 
of VM exist for all vcpus, before we encountered a
issue that there is something wrong with the thread of a vcpu which 
doesn't VM exit but other vcpus are normal,
we can't get anything useful from current vcpu debugfs as the number of 
exits still increase in current vcpu debugfs.
Compared with current vcpu debugfs, i think it is more useful to know 
the statstical data for every vcpu and it benefits more.

>
> How about you instead add trace hooks that allows you to plumb your
> own counters using BPF or another kernel module? This is what is stuff
> is for, and we really don't need to create more ABI around that. At
> least, the other stat-hungry folks out there would also be able to get
> their own stuff, and normal users wouldn't be affected by it.
>
> Thanks,
>
> 	M.
>

