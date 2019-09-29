Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4770FC12C4
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 04:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfI2CFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 22:05:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37866 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728569AbfI2CFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 22:05:23 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A16FD56EE928CBC06232;
        Sun, 29 Sep 2019 10:05:21 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sun, 29 Sep 2019
 10:04:52 +0800
Subject: Re: [PATCH v18 1/6] hw/arm/virt: Introduce RAS platform version and
 RAS machine option
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        "QEMU Developers" <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20190906083152.25716-1-zhengxiang9@huawei.com>
 <20190906083152.25716-2-zhengxiang9@huawei.com>
 <CAFEAcA9cQwAJfPBC9fRcxLZVzZqag0Si62nTBNwDPyQiPVwPcg@mail.gmail.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <3d335a56-b90b-f8bb-cb05-95bf52ddade5@huawei.com>
Date:   Sun, 29 Sep 2019 10:04:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9cQwAJfPBC9fRcxLZVzZqag0Si62nTBNwDPyQiPVwPcg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/9/27 22:02, Peter Maydell wrote:
> On Fri, 6 Sep 2019 at 09:33, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>>
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> Support RAS Virtualization feature since version 4.2, disable it by
>> default in the old versions. Also add a machine option which allows user
>> to enable it explicitly.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>> ---
>>  hw/arm/virt.c         | 33 +++++++++++++++++++++++++++++++++
>>  include/hw/arm/virt.h |  2 ++
>>  2 files changed, 35 insertions(+)
>>
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index d74538b021..e0451433c8 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -1783,6 +1783,20 @@ static void virt_set_its(Object *obj, bool value, Error **errp)
>>      vms->its = value;
>>  }
>>
>> +static bool virt_get_ras(Object *obj, Error **errp)
>> +{
>> +    VirtMachineState *vms = VIRT_MACHINE(obj);
>> +
>> +    return vms->ras;
>> +}
>> +
>> +static void virt_set_ras(Object *obj, bool value, Error **errp)
>> +{
>> +    VirtMachineState *vms = VIRT_MACHINE(obj);
>> +
>> +    vms->ras = value;
>> +}
>> +
>>  static char *virt_get_gic_version(Object *obj, Error **errp)
>>  {
>>      VirtMachineState *vms = VIRT_MACHINE(obj);
>> @@ -2026,6 +2040,19 @@ static void virt_instance_init(Object *obj)
>>                                      "Valid values are none and smmuv3",
>>                                      NULL);
>>
>> +    if (vmc->no_ras) {
>> +        vms->ras = false;
>> +    } else {
>> +        /* Default disallows RAS instantiation */
>> +        vms->ras = false;
>> +        object_property_add_bool(obj, "ras", virt_get_ras,
>> +                                 virt_set_ras, NULL);
>> +        object_property_set_description(obj, "ras",
>> +                                        "Set on/off to enable/disable "
>> +                                        "RAS instantiation",
>> +                                        NULL);
>> +    }
> 
> For a property which is disabled by default, you don't need
> to have a separate flag in the VirtMachineClass struct.
> Those are only needed for properties where we need the old machine
> types to have the property be 'off' but new machine types
> need to default to it be 'on'. Since vms->ras is false
> by default anyway, you can just have this part:
> 
>> +        /* Default disallows RAS instantiation */
>> +        vms->ras = false;
>> +        object_property_add_bool(obj, "ras", virt_get_ras,
>> +                                 virt_set_ras, NULL);
>> +        object_property_set_description(obj, "ras",
>> +                                        "Set on/off to enable/disable "
>> +                                        "RAS instantiation",
>> +                                        NULL);
> 
> Compare the 'vms->secure' flag and associated property
> for an example of this.

Thanks for pointing it out, I will remove the no_ras in the VirtMachineClass struct.

> 
>>      vms->irqmap = a15irqmap;
>>
>>      virt_flash_create(vms);
>> @@ -2058,8 +2085,14 @@ DEFINE_VIRT_MACHINE_AS_LATEST(4, 2)
>>
>>  static void virt_machine_4_1_options(MachineClass *mc)
>>  {
>> +    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
>> +
>>      virt_machine_4_2_options(mc);
>>      compat_props_add(mc->compat_props, hw_compat_4_1, hw_compat_4_1_len);
>> +    /* Disable memory recovery feature for 4.1 as RAS support was
>> +     * introduced with 4.2.
>> +     */
>> +    vmc->no_ras = true;
>>  }
>>  DEFINE_VIRT_MACHINE(4, 1)
> 
> thanks
> -- PMM
> 
> .
> 

-- 

Thanks,
Xiang

