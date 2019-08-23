Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36C79AF56
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 14:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392324AbfHWM0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 08:26:04 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:35653 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731573AbfHWM0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 08:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566563162; x=1598099162;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=gTCdg8J2VOjRvubNIG/WreNywvWkf7+OZpzbGKuI4Ds=;
  b=JFyoK31KFnHL4Wb4H8wIkDag8zwWZGfji1MRz3wmQgZSAxQvTX7IHgGx
   2Hfmuj03GXxNXohrmo41kIeaBeYIiRecN5ED8kedZun02wWs14jFp25C+
   nqD/DOJ/B2UQuMBWWiQkQ2kz2dyOfIcnSPtVrG2nsR5suLC2yXiyIliJJ
   8=;
X-IronPort-AV: E=Sophos;i="5.64,421,1559520000"; 
   d="scan'208";a="781001403"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Aug 2019 12:26:01 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 65A74A2CD2;
        Fri, 23 Aug 2019 12:25:57 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 12:25:56 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.191) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 12:25:52 +0000
Subject: Re: [PATCH v5 15/20] RISC-V: KVM: Add timer functionality
To:     Anup Patel <anup@brainfault.org>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-16-anup.patel@wdc.com>
 <09d74212-4fa3-d64c-5a63-d556e955b88c@amazon.com>
 <CAAhSdy36q5-x8cXM=M5S3cnE2nvCMhcsfuQayVt7jahd58HWFw@mail.gmail.com>
 <CA3A6A8A-0227-4B92-B892-86A0C7CA369E@amazon.com>
 <CAAhSdy2FFmCZJhNnMojp8QbiD-t6=4XrNtE9KGnCG_-mPb19-A@mail.gmail.com>
 <e369eba6-e659-2892-9cb9-a631dd10153a@amazon.com>
 <CAAhSdy2sknED0W5-SpS4cP46cnS6biHYs_jRDgCj_Ucw5PUYzg@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <655b1724-c3ca-9913-328b-59e434d40d96@amazon.com>
Date:   Fri, 23 Aug 2019 14:25:50 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy2sknED0W5-SpS4cP46cnS6biHYs_jRDgCj_Ucw5PUYzg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.191]
X-ClientProxiedBy: EX13D25UWB003.ant.amazon.com (10.43.161.33) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.08.19 14:11, Anup Patel wrote:
> On Fri, Aug 23, 2019 at 5:19 PM Alexander Graf <graf@amazon.com> wrote:
>>
>>
>>
>> On 23.08.19 13:46, Anup Patel wrote:
>>> On Fri, Aug 23, 2019 at 5:03 PM Graf (AWS), Alexander <graf@amazon.com> wrote:
>>>>
>>>>
>>>>
>>>>> Am 23.08.2019 um 13:05 schrieb Anup Patel <anup@brainfault.org>:
>>>>>
>>>>>> On Fri, Aug 23, 2019 at 1:23 PM Alexander Graf <graf@amazon.com> wrote:
>>>>>>
>>>>>>> On 22.08.19 10:46, Anup Patel wrote:
>>>>>>> From: Atish Patra <atish.patra@wdc.com>
>>>>>>>
>>>>>>> The RISC-V hypervisor specification doesn't have any virtual timer
>>>>>>> feature.
>>>>>>>
>>>>>>> Due to this, the guest VCPU timer will be programmed via SBI calls.
>>>>>>> The host will use a separate hrtimer event for each guest VCPU to
>>>>>>> provide timer functionality. We inject a virtual timer interrupt to
>>>>>>> the guest VCPU whenever the guest VCPU hrtimer event expires.
>>>>>>>
>>>>>>> The following features are not supported yet and will be added in
>>>>>>> future:
>>>>>>> 1. A time offset to adjust guest time from host time
>>>>>>> 2. A saved next event in guest vcpu for vm migration
>>>>>>
>>>>>> Implementing these 2 bits right now should be trivial. Why wait?
>>>>>
>>
>> [...]
>>
>>>>>> ... in fact, I feel like I'm missing something obvious here. How does
>>>>>> the guest trigger the timer event? What is the argument it uses for that
>>>>>> and how does that play with the tbfreq in the earlier patch?
>>>>>
>>>>> We have SBI call inferface between Hypervisor and Guest. One of the
>>>>> SBI call allows Guest to program time event. The next event is specified
>>>>> as absolute cycles. The Guest can read time using TIME CSR which
>>>>> returns system timer value (@ tbfreq freqency).
>>>>>
>>>>> Guest Linux will know the tbfreq from DTB passed by QEMU/KVMTOOL
>>>>> and it has to be same as Host tbfreq.
>>>>>
>>>>> The TBFREQ config register visible to user-space is a read-only CONFIG
>>>>> register which tells user-space tools (QEMU/KVMTOOL) about Host tbfreq.
>>>>
>>>> And it's read-only because you can not trap on TB reads?
>>>
>>> There is no TB registers.
>>>
>>> The tbfreq can only be know through DT/ACPI kind-of HW description
>>> for both Host and Guest.
>>>
>>> The KVM user-space tool needs to know TBFREQ so that it can set correct
>>> value in generated DT for Guest Linux.
>>
>> So what access methods do get influenced by TBFREQ? If it's only the SBI
>> timer, we can control the frequency, which means we can make TBFREQ
>> read/write.
> 
> There are two things influenced by TBFREQ:
> 1. TIME CSR which is a free running counter
> 2. SBI calls for programming next timer event
> 
> The Guest TIME CSR will be at same rate as Host TIME CSR so
> we cannot show different TBFREQ to Guest Linux.
> 
> In future, we will be having a dedicated RISC-V timer extension which
> will have all programming done via CSRs but until then we are stuck
> with TIME CSR + SBI call combination.

Please make sure that in a future revision of the spec either

   a) TIME CSR can be trapped or
   b) TIME CSR can be virtualized (virtual TIME READ has offset and 
multiplier on phys TIME READ applied)

and the same goes for the timer extension - either make it all trappable 
or all propery adjustable. You need to be double cautious there that 
people don't design something that breaks live migration between hosts 
that have a different TBFREQ.


Thanks,

Alex
