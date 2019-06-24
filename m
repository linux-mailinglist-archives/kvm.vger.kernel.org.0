Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C26350A95
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 14:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbfFXMTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 08:19:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43308 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbfFXMTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 08:19:33 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2BC7AF8DB1BAB1C616A2;
        Mon, 24 Jun 2019 20:19:28 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 24 Jun 2019
 20:19:21 +0800
Subject: Re: [PATCH v17 01/10] hw/arm/virt: Add RAS platform version for
 migration
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
 <1557832703-42620-2-git-send-email-gengdongjiu@huawei.com>
 <20190620140409.3c713760@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <fbd558d5-03b7-df5c-e781-549261207221@huawei.com>
Date:   Mon, 24 Jun 2019 20:19:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190620140409.3c713760@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/6/20 20:04, Igor Mammedov wrote:
> On Tue, 14 May 2019 04:18:14 -0700
> Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> 
>> Support this feature since version 4.1, disable it by
>> default in the old version.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> ---
>>  hw/arm/virt.c         | 6 ++++++
>>  include/hw/arm/virt.h | 1 +
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index 5331ab7..7bdd41b 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -2043,8 +2043,14 @@ DEFINE_VIRT_MACHINE_AS_LATEST(4, 1)
>>  
>>  static void virt_machine_4_0_options(MachineClass *mc)
>>  {
>> +    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
>> +
>>      virt_machine_4_1_options(mc);
>>      compat_props_add(mc->compat_props, hw_compat_4_0, hw_compat_4_0_len);
>> +    /* Disable memory recovery feature for 4.0 as RAS support was
>> +     * introduced with 4.1.
>> +     */
>> +    vmc->no_ras = true;
> 
> So it would mean that the feature is enabled unconditionally for
> new machine types and consumes resources whether user needs it or not.
> 
> In light of the race for leaner QEMU and faster startup times,
> it might be better to make RAS optional and make user explicitly
> enable it using a machine option.

I will add a machine option to make RAS optional, do you think we should enable or disable it by default? I think it is better if we enable it by default.

> 
> 
>>  }
>>  DEFINE_VIRT_MACHINE(4, 0)
>>  
>> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
>> index 4240709..7f1a033 100644
>> --- a/include/hw/arm/virt.h
>> +++ b/include/hw/arm/virt.h
>> @@ -104,6 +104,7 @@ typedef struct {
>>      bool disallow_affinity_adjustment;
>>      bool no_its;
>>      bool no_pmu;
>> +    bool no_ras;
>>      bool claim_edge_triggered_timers;
>>      bool smbios_old_sys_ver;
>>      bool no_highmem_ecam;
> 
> .
> 

