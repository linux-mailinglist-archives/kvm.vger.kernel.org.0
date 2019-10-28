Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D994E6BAB
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 05:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfJ1EB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 00:01:57 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbfJ1EB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 00:01:57 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 738F6C0E751972DE4A66;
        Mon, 28 Oct 2019 12:01:54 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 28 Oct 2019
 12:01:42 +0800
Subject: Re: [PATCH v20 0/5] Add ARMv8 RAS virtualization support in QEMU
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xiang Zheng <zhengxiang9@huawei.com>
CC:     <pbonzini@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191026032447.20088-1-zhengxiang9@huawei.com>
 <20191027061450-mutt-send-email-mst@kernel.org>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <6c44268a-2676-3fa1-226d-29877b21dbea@huawei.com>
Date:   Mon, 28 Oct 2019 12:01:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20191027061450-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael/All

On 2019/10/27 18:17, Michael S. Tsirkin wrote:
> On Sat, Oct 26, 2019 at 11:24:42AM +0800, Xiang Zheng wrote:
>> In the ARMv8 platform, the CPU error types are synchronous external abort(SEA)
>> and SError Interrupt (SEI). If exception happens in guest, sometimes it's better
>> for guest to perform the recovery, because host does not know the detailed
>> information of guest. For example, if an exception happens in a user-space
>> application within guest, host does not know which application encounters
>> errors.
>>
>> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
>> After user space gets the notification, it will record the CPER into guest GHES
>> buffer and inject an exception or IRQ into guest.
>>
>> In the current implementation, if the type of SIGBUS is BUS_MCEERR_AR, we will
>> treat it as a synchronous exception, and notify guest with ARMv8 SEA
>> notification type after recording CPER into guest.
>>
>> This series of patches are based on Qemu 4.1, which include two parts:
>> 1. Generate APEI/GHES table.
>> 2. Handle the SIGBUS signal, record the CPER in runtime and fill it into guest
>>    memory, then notify guest according to the type of SIGBUS.
>>
>> The whole solution was suggested by James(james.morse@arm.com); The solution of
>> APEI section was suggested by Laszlo(lersek@redhat.com).
>> Show some discussions in [1].
>>
>> This series of patches have already been tested on ARM64 platform with RAS
>> feature enabled:
>> Show the APEI part verification result in [2].
>> Show the BUS_MCEERR_AR SIGBUS handling verification result in [3].
> 
> This looks mostly OK to me.  I sent some minor style comments but they
> can be addressed by follow up patches.
> 
> Maybe it's a good idea to merge this before soft freeze to make sure it
> gets some testing.  I'll leave this decision to the ARM maintainer.  For
> ACPI parts:
> 
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

Got it, Thanks for the Reviewed-by from Michael.

Hi Michael,
  According to discussion with QEMU community, I finished and developed the whole ARM RAS virtualization solution, and introduce the ARM APEI table in the first time.
For the newly created files, which are mainly about ARM APEI/GHES part,I would like to maintain them. If you agree it, whether I can add new maintainers[1]? thanks a lot.


[1]:
+ARM APEI Subsystem
+M: Dongjiu Geng <gengdongjiu@huawei.com>
+M: Xiang zheng <zhengxiang9@huawei.com>
+L: qemu-arm@nongnu.org
+S: Maintained
+F: hw/acpi/acpi_ghes.c
+F: include/hw/acpi/acpi_ghes.h
+F: docs/specs/acpi_hest_ghes.rst


> 
> 
>> ---

