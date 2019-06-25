Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7146554E77
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 14:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfFYMLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 08:11:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:19108 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726532AbfFYMLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 08:11:24 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AC84597342FD98737BF6;
        Tue, 25 Jun 2019 20:11:20 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Jun 2019
 20:11:13 +0800
Subject: Re: [PATCH v17 05/10] acpi: add build_append_ghes_generic_status()
 helper for Generic Error Status Block
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
 <1557832703-42620-6-git-send-email-gengdongjiu@huawei.com>
 <20190620144257.7400b0a7@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <93dcd75e-77e4-8813-beef-7939cdb75413@huawei.com>
Date:   Tue, 25 Jun 2019 20:11:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190620144257.7400b0a7@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/6/20 20:42, Igor Mammedov wrote:
> On Tue, 14 May 2019 04:18:18 -0700
> Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> 
>> It will help to add Generic Error Status Block to ACPI tables
>> without using packed C structures and avoid endianness
>> issues as API doesn't need explicit conversion.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> ---
>>  hw/acpi/aml-build.c         | 14 ++++++++++++++
>>  include/hw/acpi/aml-build.h |  6 ++++++
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
>> index 102a288..ce90970 100644
>> --- a/hw/acpi/aml-build.c
>> +++ b/hw/acpi/aml-build.c
>> @@ -296,6 +296,20 @@ void build_append_ghes_notify(GArray *table, const uint8_t type,
>>          build_append_int_noprefix(table, error_threshold_window, 4);
>>  }
>>  
>> +/* Generic Error Status Block
>> + * ACPI 4.0: 17.3.2.6.1 Generic Error Data
>> + */
>> +void build_append_ghes_generic_status(GArray *table, uint32_t block_status,
> maybe ..._generic_error_status???
good point, the build_append_ghes_generic_error_status() is better than build_append_ghes_generic_status()

> 
>> +                      uint32_t raw_data_offset, uint32_t raw_data_length,
>> +                      uint32_t data_length, uint32_t error_severity)
> see CODING_STYLE, 1.1 Multiline Indent
> 
>> +{
> when describing filds from spec try to add 'verbatim' copy of the name from spec
> so it would be esy to grep for it. Like:
>        /* Block Status */
>> +    build_append_int_noprefix(table, block_status, 4);
>        /* Raw Data Offset */
> 
> note applies all other places where you compose ACPI tables
ok

> 
>> +    build_append_int_noprefix(table, raw_data_offset, 4);
>> +    build_append_int_noprefix(table, raw_data_length, 4);
>> +    build_append_int_noprefix(table, data_length, 4);
>> +    build_append_int_noprefix(table, error_severity, 4);
>> +}
>> +
>>  /* Generic Error Data Entry
>>   * ACPI 4.0: 17.3.2.6.1 Generic Error Data
>>   */
>> diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
>> index a71db2f..1ec7e1b 100644
>> --- a/include/hw/acpi/aml-build.h
>> +++ b/include/hw/acpi/aml-build.h
>> @@ -425,6 +425,12 @@ void build_append_ghes_generic_data(GArray *table, const char *section_type,
>>                                      uint32_t error_data_length, uint8_t *fru_id,
>>                                      uint8_t *fru_text, uint64_t time_stamp);
>>  
>> +void
>> +build_append_ghes_generic_status(GArray *table, uint32_t block_status,
>> +                                 uint32_t raw_data_offset,
>> +                                 uint32_t raw_data_length,
>> +                                 uint32_t data_length, uint32_t error_severity);
> this and previous patch, it might be better to to move declaration
> to its own header, for example to include/hw/acpi/acpi_ghes.h
> that you are adding later in the series.
> And maybe move helpers to hw/acpi/acpi_ghes.c
> They are not really independent ACPI primitives that are shared
> with other tables, aren't they?
Some ACPI primitives are shared with other table, such as Notification Structure.
we have 10 types of error sources, some error source will share the  Notification Structure primitives.
Now I only implement Generic Hardware Error Source version 2 (GHESv2 - Type 10)

> .
>> +
>>  void build_srat_memory(AcpiSratMemoryAffinity *numamem, uint64_t base,
>>                         uint64_t len, int node, MemoryAffinityFlags flags);
>>  
> 
> .
> 

