Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66302E6B5F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 04:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfJ1DRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 23:17:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44018 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726711AbfJ1DRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 23:17:03 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 732D27EEE96640117F5;
        Mon, 28 Oct 2019 11:17:00 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 28 Oct 2019
 11:16:53 +0800
Subject: Re: [PATCH v20 0/5] Add ARMv8 RAS virtualization support in QEMU
To:     "Michael S. Tsirkin" <mst@redhat.com>, <peter.maydell@linaro.org>
CC:     <pbonzini@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <lersek@redhat.com>,
        <james.morse@arm.com>, <gengdongjiu@huawei.com>,
        <mtosatti@redhat.com>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191026032447.20088-1-zhengxiang9@huawei.com>
 <20191027061450-mutt-send-email-mst@kernel.org>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <b4cba864-6689-a425-af8e-4fb4a95d4482@huawei.com>
Date:   Mon, 28 Oct 2019 11:16:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191027061450-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



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
> 
> This looks mostly OK to me.  I sent some minor style comments but they
> can be addressed by follow up patches.
> 
> Maybe it's a good idea to merge this before soft freeze to make sure it
> gets some testing.  I'll leave this decision to the ARM maintainer.  For
> ACPI parts:
> 
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> 

Hi Peter,

I can address the style comments and send the series of patches before soft
freeze if needed. And if there is no window before soft freeze, I can also
address them by follow up patches. :)

-- 

Thanks,
Xiang

