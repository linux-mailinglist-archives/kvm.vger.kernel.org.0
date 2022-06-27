Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F5555E18D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbiF0QM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbiF0QM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:12:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DFFD186F4
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:12:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E9991758;
        Mon, 27 Jun 2022 09:12:19 -0700 (PDT)
Received: from [10.57.40.121] (unknown [10.57.40.121])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FC083F66F;
        Mon, 27 Jun 2022 09:12:17 -0700 (PDT)
Message-ID: <6dc3d9ab-0802-8a20-5871-b1f4cf7f32c2@arm.com>
Date:   Mon, 27 Jun 2022 17:12:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 11/23] lib/efi: Add support for getting
 the cmdline
Content-Language: en-GB
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-12-nikos.nikoleris@arm.com>
 <YrHy5TLGLHkAYfzy@google.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <YrHy5TLGLHkAYfzy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 21/06/2022 17:33, Ricardo Koller wrote:
> On Fri, May 06, 2022 at 09:55:53PM +0100, Nikos Nikoleris wrote:
>> This change adds support for discovering the command line arguments,
>> as a string. Then, we parse this string to populate __argc and __argv
>> for EFI tests.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/linux/efi.h |  39 +++++++++++++++
>>   lib/stdlib.h    |   1 +
>>   lib/efi.c       | 123 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   lib/string.c    |   2 +-
>>   4 files changed, 164 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
>> index 455625a..e3aba1d 100644
>> --- a/lib/linux/efi.h
>> +++ b/lib/linux/efi.h
>> @@ -60,6 +60,10 @@ typedef guid_t efi_guid_t;
>>   
>>   #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>>   
>> +#define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
>> +
>> +#define efi_table_attr(inst, attr) (inst->attr)
>> +
>>   typedef struct {
>>   	efi_guid_t guid;
>>   	void *table;
>> @@ -416,6 +420,41 @@ struct efi_boot_memmap {
>>   	unsigned long           *buff_size;
>>   };
>>   
>> +#define __aligned_u64 u64 __attribute__((aligned(8)))
>> +
>> +typedef union {
>> +	struct {
>> +		u32			revision;
>> +		efi_handle_t		parent_handle;
>> +		efi_system_table_t	*system_table;
>> +		efi_handle_t		device_handle;
>> +		void			*file_path;
>> +		void			*reserved;
>> +		u32			load_options_size;
>> +		void			*load_options;
>> +		void			*image_base;
>> +		__aligned_u64		image_size;
>> +		unsigned int		image_code_type;
>> +		unsigned int		image_data_type;
>> +		efi_status_t		(__efiapi *unload)(efi_handle_t image_handle);
>> +	};
>> +	struct {
>> +		u32		revision;
>> +		u32		parent_handle;
>> +		u32		system_table;
>> +		u32		device_handle;
>> +		u32		file_path;
>> +		u32		reserved;
>> +		u32		load_options_size;
>> +		u32		load_options;
>> +		u32		image_base;
>> +		__aligned_u64	image_size;
>> +		u32		image_code_type;
>> +		u32		image_data_type;
>> +		u32		unload;
>> +	} mixed_mode;
>> +} efi_loaded_image_t;
> 
> Is the 32-bit mode used (in later commits)? Why not reuse
> efi_loaded_image_64_t only and make sure it's the one expected.
> 

Good point.

I think it's only x86 that might make use of mixed_mode and I am not 
sure there is a use for it in KUT, I will remove it and if anyone ever 
needs it they can add it then.

Thanks,

Nikos


>> +
>>   #define efi_bs_call(func, ...) efi_system_table->boottime->func(__VA_ARGS__)
>>   #define efi_rs_call(func, ...) efi_system_table->runtime->func(__VA_ARGS__)
>>   
>> diff --git a/lib/stdlib.h b/lib/stdlib.h
>> index 28496d7..2c524d7 100644
>> --- a/lib/stdlib.h
>> +++ b/lib/stdlib.h
>> @@ -7,6 +7,7 @@
>>   #ifndef _STDLIB_H_
>>   #define _STDLIB_H_
>>   
>> +int isspace(int c);
>>   long int strtol(const char *nptr, char **endptr, int base);
>>   unsigned long int strtoul(const char *nptr, char **endptr, int base);
>>   long long int strtoll(const char *nptr, char **endptr, int base);
>> diff --git a/lib/efi.c b/lib/efi.c
>> index 64cc978..5341942 100644
>> --- a/lib/efi.c
>> +++ b/lib/efi.c
>> @@ -8,6 +8,7 @@
>>    */
>>   
>>   #include "efi.h"
>> +#include <stdlib.h>
>>   #include <libcflat.h>
>>   #include <asm/setup.h>
>>   
>> @@ -96,6 +97,97 @@ static void efi_exit(efi_status_t code)
>>   	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, code, 0, NULL);
>>   }
>>   
>> +static void efi_cmdline_to_argv(char *cmdline_ptr)
>> +{
>> +	char *c = cmdline_ptr;
>> +	bool narg = true;
>> +	while (*c) {
>> +		if (isspace(*c)) {
>> +			*c = '\0';
>> +			narg = true;
>> +		} else if (narg) {
>> +			__argv[__argc++] = c;
>> +			narg = false;
>> +		}
>> +		c++;
>> +	}
>> +}
>> +
>> +static char *efi_convert_cmdline(efi_loaded_image_t *image, int *cmd_line_len)
> 
> Mention that this was adapted from drivers/firmware/efi/libstub/efi-stub.c.
> 
>> +{
>> +	const u16 *s2;
>> +	unsigned long cmdline_addr = 0;
>> +	int options_chars = efi_table_attr(image, load_options_size) / 2;
>> +	const u16 *options = efi_table_attr(image, load_options);
>> +	int options_bytes = 0, safe_options_bytes = 0;  /* UTF-8 bytes */
>> +	bool in_quote = false;
>> +	efi_status_t status;
>> +	const int COMMAND_LINE_SIZE = 2048;
>> +
>> +	if (options) {
>> +		s2 = options;
>> +		while (options_bytes < COMMAND_LINE_SIZE && options_chars--) {
>> +			u16 c = *s2++;
>> +
>> +			if (c < 0x80) {
>> +				if (c == L'\0' || c == L'\n')
>> +					break;
>> +				if (c == L'"')
>> +					in_quote = !in_quote;
>> +				else if (!in_quote && isspace((char)c))
>> +					safe_options_bytes = options_bytes;
>> +
>> +				options_bytes++;
>> +				continue;
>> +			}
>> +
>> +			/*
>> +			 * Get the number of UTF-8 bytes corresponding to a
>> +			 * UTF-16 character.
>> +			 * The first part handles everything in the BMP.
>> +			 */
>> +			options_bytes += 2 + (c >= 0x800);
>> +			/*
>> +			 * Add one more byte for valid surrogate pairs. Invalid
>> +			 * surrogates will be replaced with 0xfffd and take up
>> +			 * only 3 bytes.
>> +			 */
>> +			if ((c & 0xfc00) == 0xd800) {
>> +				/*
>> +				 * If the very last word is a high surrogate,
>> +				 * we must ignore it since we can't access the
>> +				 * low surrogate.
>> +				 */
>> +				if (!options_chars) {
>> +					options_bytes -= 3;
>> +				} else if ((*s2 & 0xfc00) == 0xdc00) {
>> +					options_bytes++;
>> +					options_chars--;
>> +					s2++;
>> +				}
>> +			}
>> +		}
>> +		if (options_bytes >= COMMAND_LINE_SIZE) {
>> +			options_bytes = safe_options_bytes;
>> +			printf("Command line is too long: truncated to %d bytes\n",
>> +			       options_bytes);
>> +		}
>> +        }
>> +
>> +	options_bytes++;        /* NUL termination */
>> +
>> +	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, options_bytes,
>> +			     (void **)&cmdline_addr);
>> +	if (status != EFI_SUCCESS)
>> +		return NULL;
>> +
>> +	snprintf((char *)cmdline_addr, options_bytes, "%.*ls",
>> +		 options_bytes - 1, options);
>> +
>> +	*cmd_line_len = options_bytes;
>> +	return (char *)cmdline_addr;
>> +}
>> +
>>   efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>>   {
>>   	int ret;
>> @@ -109,6 +201,37 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>>   	unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
>>   	u32 desc_ver;
>>   
>> +	/* Helper variables needed to get the cmdline */
>> +	efi_loaded_image_t *image;
>> +	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
>> +	char *cmdline_ptr = NULL;
>> +	int cmdline_size = 0;
>> +
>> +	/*
>> +	 * Get a handle to the loaded image protocol.  This is used to get
>> +	 * information about the running image, such as size and the command
>> +	 * line.
>> +	 */
>> +	status = efi_bs_call(handle_protocol, handle, &loaded_image_proto,
>> +			     (void *)&image);
>> +	if (status != EFI_SUCCESS) {
>> +		printf("Failed to get loaded image protocol\n");
>> +		goto efi_main_error;
>> +	}
>> +
>> +	/*
>> +	 * Get the command line from EFI, using the LOADED_IMAGE
>> +	 * protocol. We are going to copy the command line into the
>> +	 * device tree, so this can be allocated anywhere.
> 
> Does the "device tree" comment still make sense?
> 
>> +	 */
>> +	cmdline_ptr = efi_convert_cmdline(image, &cmdline_size);
>> +	if (!cmdline_ptr) {
>> +		printf("getting command line via LOADED_IMAGE_PROTOCOL\n");
>> +		status = EFI_OUT_OF_RESOURCES;
>> +		goto efi_main_error;
>> +	}
>> +	efi_cmdline_to_argv(cmdline_ptr);
>> +
>>   	/* Set up efi_bootinfo */
>>   	efi_bootinfo.mem_map.map = &map;
>>   	efi_bootinfo.mem_map.map_size = &map_size;
>> diff --git a/lib/string.c b/lib/string.c
>> index 27106da..b191ab1 100644
>> --- a/lib/string.c
>> +++ b/lib/string.c
>> @@ -163,7 +163,7 @@ void *memchr(const void *s, int c, size_t n)
>>       return NULL;
>>   }
>>   
>> -static int isspace(int c)
>> +int isspace(int c)
>>   {
>>       return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
>>   }
>> -- 
>> 2.25.1
>>
