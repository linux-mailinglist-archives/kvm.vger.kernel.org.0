Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9988A14084E
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 11:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgAQKsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 05:48:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9649 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726553AbgAQKsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 05:48:13 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 01F3682DCE72C510EE0B;
        Fri, 17 Jan 2020 18:48:07 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 18:47:56 +0800
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block
 address
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>
CC:     <zhengxiang9@huawei.com>, <linuxarm@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
 <11c62b51-7a94-5e34-39c6-60c5e989a63b@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <de0dbaaa-01aa-aba7-df9a-ddfb9a2164b0@huawei.com>
Date:   Fri, 17 Jan 2020 18:47:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <11c62b51-7a94-5e34-39c6-60c5e989a63b@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/1/17 15:39, Philippe Mathieu-Daudé wrote:
>>         table_offsets = g_array_new(false, true /* clear */,
>>                                           sizeof(uint32_t));
>> @@ -831,7 +832,9 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>>       acpi_add_table(table_offsets, tables_blob);
>>       build_spcr(tables_blob, tables->linker, vms);
>>   -    if (vms->ras) {
>> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
>> +                                                       NULL));
> 
> Testing vms->ras first is cheaper than calling object_resolve_path_type(). Since some people are spending lot of time to reduce VM boot time, it might be worth considering.
Thanks Philippe's comments.

Do you think it should be written to below[1]? right?

[1]:
if (vms->ras && acpi_ged_state)


> 
>> +    if (acpi_ged_state &&  vms->ras) {
>>           acpi_add_table(table_offsets, tables_blob);
>>           build_ghes_error_table(tables->hardware_errors, tables->linker);
>>           acpi_build_hest(tables_blob, tables->hardware_errors,
>> @@ -925,6 +928,7 @@ void virt_acpi_setup(VirtMachineState *vms)
>>   { 

