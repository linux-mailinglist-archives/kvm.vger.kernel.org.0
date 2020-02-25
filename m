Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE51216BD41
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 10:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgBYJ0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 04:26:12 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:33164 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729024AbgBYJ0L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 04:26:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=herongguang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0TqtE5-e_1582622765;
Received: from 30.39.240.211(mailfrom:herongguang@linux.alibaba.com fp:SMTPD_---0TqtE5-e_1582622765)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 Feb 2020 17:26:05 +0800
Subject: Re: [RFC] Question about async TLB flush and KVM pv tlb improvements
To:     Wanpeng Li <kernellwp@gmail.com>,
        =?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?= <bangcai.hrg@alibaba-inc.com>
Cc:     namit <namit@vmware.com>, peterz <peterz@infradead.org>,
        pbonzini <pbonzini@redhat.com>,
        "dave.hansen" <dave.hansen@intel.com>, mingo <mingo@redhat.com>,
        tglx <tglx@linutronix.de>, x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dave.hansen" <dave.hansen@linux.intel.com>, bp <bp@alien8.de>,
        luto <luto@kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?5p6X5rC45ZCsKOa1t+aeqyk=?= <yongting.lyt@alibaba-inc.com>,
        =?UTF-8?B?5ZC05ZCv57++KOWQr+e/vik=?= <qixuan.wqx@alibaba-inc.com>
References: <07348bb2-c8a5-41d0-afca-26c1056570a5.bangcai.hrg@alibaba-inc.com>
 <CANRm+CwZq=FbCwRcyO=C7YinLevmMuVVu9auwPqyho3o-4Y-wQ@mail.gmail.com>
 <660daad7-afb0-496d-9f40-a1162d5451e2.bangcai.hrg@alibaba-inc.com>
 <CANRm+Cw08uxwW8iUi96CJjmvfbtSd6ePXpAPPScByhoNLCrAWQ@mail.gmail.com>
From:   He Rongguang <herongguang@linux.alibaba.com>
Message-ID: <336cd7de-d4a9-29dd-1150-4f793a03cfa0@linux.alibaba.com>
Date:   Tue, 25 Feb 2020 17:26:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cw08uxwW8iUi96CJjmvfbtSd6ePXpAPPScByhoNLCrAWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2020/2/25 16:41, Wanpeng Li 写道:
> On Tue, 25 Feb 2020 at 15:53, 何容光(邦采) <bangcai.hrg@alibaba-inc.com> wrote:
>>> On Tue, 25 Feb 2020 at 12:12, 何容光(邦采) <bangcai.hrg@alibaba-inc.com> wrote:
>>>> Hi there,
>>>>
>>>> I saw this async TLB flush patch at https://lore.kernel.org/patchwork/patch/1082481/ , and I am wondering after one year, do you think if this patch is practical or there are functional flaws?
>>>>  From my POV, Nadav's patch seems has no obvious flaw. But I am not familiar about the relationship between CPU's speculation exec and stale TLB, since it's usually transparent from programing. In which condition would machine check occurs? Is there some reference I can learn?
>>>> BTW, I am trying to improve kvm pv tlb flush that if a vCPU is preempted, as initiating CPU is not sending IPI to and waiting for the preempted vCPU, when the preempted vCPU is resuming, I want the VMM to inject an interrupt, perhaps NMI, to the vCPU and letting vCPU flush TLB instead of flush TLB for the vCPU, in case the vCPU is not in kernel mode or disabled interrupt, otherwise stick to VMM flush. Since VMM flush using INVVPID would flush all TLB of all PCID thus has some negative performance impacting on the preempted vCPU. So is there same problem as the async TLB flush patch?
>>> PV TLB Shootdown is disabled in dedicated scenario, I believe there
>>> are already heavy tlb misses in overcommit scenarios before this
>>> feature, so flush all TLB associated with one specific VPID will not
>>> worse that much.
>> If vcpus running on one pcpu is limited to a few, from my test, there
>> can still be some beneficial. Especially if we can move all the logic to
> Unless the vCPU is preempted.

Correct, in fact I am using a no-IPI-in-VM approch, that's why I am 
asking about the

async approch.

>> VMM eliminating waiting of IPI, however correctness of functionally
>> is a concern. This is also why I found Nadav's patch, do you have
>> any advice on this?
