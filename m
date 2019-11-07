Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF1BF2BD9
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 11:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387560AbfKGKIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 05:08:50 -0500
Received: from foss.arm.com ([217.140.110.172]:53340 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733205AbfKGKIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 05:08:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A91F246A;
        Thu,  7 Nov 2019 02:08:49 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B80503F71A;
        Thu,  7 Nov 2019 02:08:48 -0800 (PST)
Subject: Re: [PATCH kvmtool 06/16] builtin-run.c: Always use ram_size in bytes
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Julien Grall <julien.grall.oss@gmail.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <1569245722-23375-7-git-send-email-alexandru.elisei@arm.com>
 <20191106164923.1d501e9a@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <684204ae-f229-6a61-63fd-1692b60eaa24@arm.com>
Date:   Thu, 7 Nov 2019 10:08:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106164923.1d501e9a@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/6/19 4:49 PM, Andre Przywara wrote:
> On Mon, 23 Sep 2019 14:35:12 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> The user can specify the virtual machine memory size, in MB, which is saved
>> in cfg->ram_size. kvmtool validates it against the host memory size,
>> converted from bytes to MB. ram_size is aftwerwards converted to bytes, and
>> this is how it is used throughout the rest of the program.
>>
>> Let's avoid any confusion about the unit of measurement and always use
>> cfg->ram_size in bytes.
> ... which also means you can get rid of MIN_RAM_SIZE_MB in include/kvm/kvm-config.h.

I'll do that, thanks for spotting it.

Thanks,
Alex
>
> Otherwise:
>  
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>
> Cheers,
> Andre
>
>> ---
>>  builtin-run.c            | 19 ++++++++++---------
>>  include/kvm/kvm-config.h |  2 +-
>>  include/kvm/kvm.h        |  2 +-
>>  3 files changed, 12 insertions(+), 11 deletions(-)
>>
>> diff --git a/builtin-run.c b/builtin-run.c
>> index cff44047bb1c..4e0c52b3e027 100644
>> --- a/builtin-run.c
>> +++ b/builtin-run.c
>> @@ -262,7 +262,7 @@ static u64 host_ram_size(void)
>>  		return 0;
>>  	}
>>  
>> -	return (nr_pages * page_size) >> MB_SHIFT;
>> +	return nr_pages * page_size;
>>  }
>>  
>>  /*
>> @@ -276,11 +276,11 @@ static u64 get_ram_size(int nr_cpus)
>>  	u64 available;
>>  	u64 ram_size;
>>  
>> -	ram_size	= 64 * (nr_cpus + 3);
>> +	ram_size	= (64 * (nr_cpus + 3)) << MB_SHIFT;
>>  
>>  	available	= host_ram_size() * RAM_SIZE_RATIO;
>>  	if (!available)
>> -		available = MIN_RAM_SIZE_MB;
>> +		available = MIN_RAM_SIZE_BYTE;
>>  
>>  	if (ram_size > available)
>>  		ram_size	= available;
>> @@ -531,13 +531,14 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>>  
>>  	if (!kvm->cfg.ram_size)
>>  		kvm->cfg.ram_size = get_ram_size(kvm->cfg.nrcpus);
>> +	else
>> +		/* The user specifies the memory in MB. */
>> +		kvm->cfg.ram_size <<= MB_SHIFT;
>>  
>>  	if (kvm->cfg.ram_size > host_ram_size())
>>  		pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",
>> -			(unsigned long long)kvm->cfg.ram_size,
>> -			(unsigned long long)host_ram_size());
>> -
>> -	kvm->cfg.ram_size <<= MB_SHIFT;
>> +			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
>> +			(unsigned long long)host_ram_size() >> MB_SHIFT);
>>  
>>  	if (!kvm->cfg.dev)
>>  		kvm->cfg.dev = DEFAULT_KVM_DEV;
>> @@ -647,12 +648,12 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>>  	if (kvm->cfg.kernel_filename) {
>>  		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
>>  		       kvm->cfg.kernel_filename,
>> -		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
>> +		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
>>  		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
>>  	} else if (kvm->cfg.firmware_filename) {
>>  		printf("  # %s run --firmware %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
>>  		       kvm->cfg.firmware_filename,
>> -		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
>> +		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
>>  		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
>>  	}
>>  
>> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
>> index a052b0bc7582..e0c9ee14e103 100644
>> --- a/include/kvm/kvm-config.h
>> +++ b/include/kvm/kvm-config.h
>> @@ -22,7 +22,7 @@ struct kvm_config {
>>  	struct kvm_config_arch arch;
>>  	struct disk_image_params disk_image[MAX_DISK_IMAGES];
>>  	struct vfio_device_params *vfio_devices;
>> -	u64 ram_size;
>> +	u64 ram_size;		/* Guest memory size, in bytes */
>>  	u8  image_count;
>>  	u8 num_net_devices;
>>  	u8 num_vfio_devices;
>> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
>> index 635ce0f40b1e..a866d5a825c4 100644
>> --- a/include/kvm/kvm.h
>> +++ b/include/kvm/kvm.h
>> @@ -68,7 +68,7 @@ struct kvm {
>>  	struct kvm_cpu		**cpus;
>>  
>>  	u32			mem_slots;	/* for KVM_SET_USER_MEMORY_REGION */
>> -	u64			ram_size;
>> +	u64			ram_size;	/* Guest memory size, in bytes */
>>  	void			*ram_start;
>>  	u64			ram_pagesize;
>>  	struct list_head	mem_banks;
