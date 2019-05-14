Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C361C7C4
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 13:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfENLZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 07:25:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55308 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfENLZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 07:25:34 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 381A0BE33AB50F181077;
        Tue, 14 May 2019 19:25:33 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 14 May 2019
 19:25:22 +0800
Subject: Re: [PATCH v16 10/10] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Richard Henderson" <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Zheng Xiang" <zhengxiang9@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>
References: <1557751388-27063-1-git-send-email-gengdongjiu@huawei.com>
 <1557751388-27063-11-git-send-email-gengdongjiu@huawei.com>
 <CAFEAcA81nMkHdCvQTcv2ixNB7sg+3Qx+9mpNgF0XLaBPY7-PNQ@mail.gmail.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <d23719b7-65e4-1136-ffb4-f58de774d8cd@huawei.com>
Date:   Tue, 14 May 2019 19:25:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA81nMkHdCvQTcv2ixNB7sg+3Qx+9mpNgF0XLaBPY7-PNQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
>> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(c);
>> +    CPUARMState *env = &cpu->env;
>> +    ram_addr_t ram_addr;
>> +    hwaddr paddr;
>> +
>> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
>> +
>> +    if (addr) {
>> +        ram_addr = qemu_ram_addr_from_host(addr);
>> +        if (ram_addr != RAM_ADDR_INVALID &&
>> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
>> +            kvm_hwpoison_page_add(ram_addr);
>> +            /* Asynchronous signal will be masked by main thread, so
>> +             * only handle synchronous signal.
>> +             */
>> +            if (code == BUS_MCEERR_AR) {
>> +                kvm_cpu_synchronize_state(c);
>> +                if (GHES_CPER_FAIL != ghes_record_errors(ACPI_HEST_NOTIFY_SEA, paddr)) {
>> +                    kvm_inject_arm_sea(c);
>> +                } else {
>> +                    fprintf(stderr, "failed to record the error\n");
>> +                }
>> +            }
>> +            return;
>> +        }
>> +        fprintf(stderr, "Hardware memory error for memory used by "
>> +                "QEMU itself instead of guest system!\n");
>> +    }
>> +
>> +    if (code == BUS_MCEERR_AR) {
>> +        fprintf(stderr, "Hardware memory error!\n");
>> +        exit(1);
>> +    }
>> +}
> 
> This code appears to still be unconditionally trying to
> notify the guest of the error via the ACPI tables without
> checking whether those ACPI tables even exist. I told you
> about this in a previous round of review :-(

Thanks very much for the comments, and sorry for my forgetting
I added the ACPI checking in the new V17 version.

> 
> thanks
> -- PMM
> .
> 

