Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1D727BDD
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 11:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbjFHJsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 05:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjFHJsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 05:48:45 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 700EC26AC
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 02:48:44 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E95AAB6;
        Thu,  8 Jun 2023 02:49:29 -0700 (PDT)
Received: from [192.168.5.30] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4766B3F71E;
        Thu,  8 Jun 2023 02:48:43 -0700 (PDT)
Message-ID: <cfff1069-3668-1c8d-e842-c4c19632447c@arm.com>
Date:   Thu, 8 Jun 2023 10:48:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [kvm-unit-tests PATCH v6 19/32] lib/efi: Add support for reading
 an FDT
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-20-nikos.nikoleris@arm.com>
 <20230607-3bd9b31f3687e53e944e69d3@orel>
 <20230608-315a460eea93647e2514114c@orel>
Content-Language: en-GB
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230608-315a460eea93647e2514114c@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2023 07:55, Andrew Jones wrote:
> On Wed, Jun 07, 2023 at 06:58:22PM +0200, Andrew Jones wrote:
>> On Tue, May 30, 2023 at 05:09:11PM +0100, Nikos Nikoleris wrote:
>> ...
>>> +static void* efi_get_var(efi_handle_t handle, struct efi_loaded_image_64 *image, efi_char16_t *var)
>>> +{
>>> +	efi_status_t status = EFI_SUCCESS;
>>> +	void *val = NULL;
>>> +	uint64_t val_size = 100;
>>> +	efi_guid_t efi_var_guid = EFI_VAR_GUID;
>>> +
>>> +	while (efi_grow_buffer(&status, &val, val_size))
>>> +		status = efi_rs_call(get_variable, var, &efi_var_guid, NULL, &val_size, val);
>>> +
>>> +	return val;
>>> +}
>>
>> I made the following changes to the above function
>>
>>      @@ lib/efi.c: static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, i
>>       +  uint64_t val_size = 100;
>>       +  efi_guid_t efi_var_guid = EFI_VAR_GUID;
>>       +
>>      -+  while (efi_grow_buffer(&status, &val, val_size))
>>      ++  while (efi_grow_buffer(&status, &val, val_size + 1))
> 
> I just fixed this fix by changing the '+ 1' to '+ sizeof(efi_char16_t)'
> and then force pushed arm/queue.
> 
> Thanks,
> drew
> 

Thanks Drew, I missed this.

Thanks,

Nikos

>>       +          status = efi_rs_call(get_variable, var, &efi_var_guid, NULL, &val_size, val);
>>       +
>>      ++  if (val)
>>      ++          ((efi_char16_t *)val)[val_size / sizeof(efi_char16_t)] = L'\0';
>>      ++
>>       +  return val;
>>       +}
>>       +
>>
>> Before ensuring the dtb pathname was nul-terminated efi_load_image()
>> was reading garbage and unable to find the dtb file.
>>
>> Thanks,
>> drew
>>
>>
>>> +
>>> +static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>>> +{
>>> +	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
>>> +	efi_char16_t *val;
>>> +	void *fdt = NULL;
>>> +	int fdtsize;
>>> +
>>> +	val = efi_get_var(handle, image, var);
>>> +	if (val)
>>> +		efi_load_image(handle, image, &fdt, &fdtsize, val);
>>> +
>>> +	return fdt;
>>> +}
>>> +
>>>   efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>>>   {
>>>   	int ret;
>>> @@ -211,6 +330,7 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>>>   	}
>>>   	setup_args(cmdline_ptr);
>>>   
>>> +	efi_bootinfo.fdt = efi_get_fdt(handle, image);
>>>   	/* Set up efi_bootinfo */
>>>   	efi_bootinfo.mem_map.map = &map;
>>>   	efi_bootinfo.mem_map.map_size = &map_size;
>>> -- 
>>> 2.25.1
>>>
