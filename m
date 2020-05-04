Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8511C3059
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 02:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEDAIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 20:08:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:10500 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgEDAIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 May 2020 20:08:47 -0400
IronPort-SDR: a6VygZCOk8UWsUmA2K+Ns1oNeoG0dTttDIPEWruDZYWKOf1BBM/Rc2eVkehXOSdYswmFybJzam
 Z+YNdzePu0uA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 17:08:46 -0700
IronPort-SDR: eFo270FnfgyZorGlGN0o0cRDGN46RxrwhYayzCXbhgtOtxgX4qXzlwFOJI3BueJtgKGLOuWKZY
 hRtP0mFtewHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,349,1583222400"; 
   d="scan'208";a="406315075"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.197.87]) ([10.212.197.87])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2020 17:08:45 -0700
Subject: Re: [PATCH RFC 03/15] drivers/base: Allocate/free platform-msi
 interrupts by group
To:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751204550.36773.459505651659406529.stgit@djiang5-desk3.ch.intel.com>
 <87sggrtg2z.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <b6d3e623-55c3-fac4-96ca-d10c42782794@linux.intel.com>
Date:   Sun, 3 May 2020 17:08:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87sggrtg2z.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 4/25/2020 2:23 PM, Thomas Gleixner wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
>> From: Megha Dey <megha.dey@linux.intel.com>
>> --- a/include/linux/msi.h
>> +++ b/include/linux/msi.h
>> @@ -135,6 +135,12 @@ enum platform_msi_type {
>>   	GEN_PLAT_MSI = 1,
>>   };
>>   
>> +struct platform_msi_group_entry {
>> +	unsigned int group_id;
>> +	struct list_head group_list;
>> +	struct list_head entry_list;
> 
> I surely told you before that struct members want to be written tabular.

yep, you surely did :) I will use tabs henceforth!
> 
>> +};
>> +
>>   /* Helpers to hide struct msi_desc implementation details */
>>   #define msi_desc_to_dev(desc)		((desc)->dev)
>>   #define dev_to_msi_list(dev)		(&(dev)->msi_list)
>> @@ -145,21 +151,31 @@ enum platform_msi_type {
>>   #define for_each_msi_entry_safe(desc, tmp, dev)	\
>>   	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)), list)
>>   
>> -#define dev_to_platform_msi_list(dev)	(&(dev)->platform_msi_list)
>> -#define first_platform_msi_entry(dev)		\
>> -	list_first_entry(dev_to_platform_msi_list((dev)), struct msi_desc, list)
>> -#define for_each_platform_msi_entry(desc, dev)	\
>> -	list_for_each_entry((desc), dev_to_platform_msi_list((dev)), list)
>> -#define for_each_platform_msi_entry_safe(desc, tmp, dev)	\
>> -	list_for_each_entry_safe((desc), (tmp), dev_to_platform_msi_list((dev)), list)
>> +#define dev_to_platform_msi_group_list(dev)    (&(dev)->platform_msi_list)
>> +
>> +#define first_platform_msi_group_entry(dev)				\
>> +	list_first_entry(dev_to_platform_msi_group_list((dev)),		\
>> +			 struct platform_msi_group_entry, group_list)
>>   
>> -#define first_msi_entry_common(dev)	\
>> -	list_first_entry_select((dev)->platform_msi_type, dev_to_platform_msi_list((dev)),	\
>> +#define platform_msi_current_group_entry_list(dev)			\
>> +	(&((list_last_entry(dev_to_platform_msi_group_list((dev)),	\
>> +			    struct platform_msi_group_entry,		\
>> +			    group_list))->entry_list))
>> +
>> +#define first_msi_entry_current_group(dev)				\
>> +	list_first_entry_select((dev)->platform_msi_type,		\
>> +				platform_msi_current_group_entry_list((dev)),	\
>>   				dev_to_msi_list((dev)), struct msi_desc, list)
>>   
>> -#define for_each_msi_entry_common(desc, dev)	\
>> -	list_for_each_entry_select((dev)->platform_msi_type, desc, dev_to_platform_msi_list((dev)), \
>> -				   dev_to_msi_list((dev)), list)	\
>> +#define for_each_msi_entry_current_group(desc, dev)			\
>> +	list_for_each_entry_select((dev)->platform_msi_type, desc,	\
>> +				   platform_msi_current_group_entry_list((dev)),\
>> +				   dev_to_msi_list((dev)), list)
>> +
>> +#define for_each_platform_msi_entry_in_group(desc, platform_msi_group, group, dev)	\
>> +	list_for_each_entry((platform_msi_group), dev_to_platform_msi_group_list((dev)), group_list)	\
>> +		if (((platform_msi_group)->group_id) == (group))			\
>> +			list_for_each_entry((desc), (&(platform_msi_group)->entry_list), list)
> 
> Yet more unreadable macro maze to obfuscate what the code is actually
> doing.

hmm I will i guess add some more documentation either in the commit 
message or somewhere in documentation to make it clearer about the 
purpose of these macros.

> 
>>   /* When an MSI domain is used as an intermediate domain */
>>   int msi_domain_prepare_irqs(struct irq_domain *domain, struct device *dev,
>> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
>> index bc5f9e32387f..899ade394ec8 100644
>> --- a/kernel/irq/msi.c
>> +++ b/kernel/irq/msi.c
>> @@ -320,7 +320,7 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
>>   	struct msi_desc *desc;
>>   	int ret = 0;
>>   
>> -	for_each_msi_entry_common(desc, dev) {
>> +	for_each_msi_entry_current_group(desc, dev) {
> 
> How is anyone supposed to figure out what the heck this means without
> going through several layers of macro maze and some magic type/group
> storage in struct device?
> 

Point noted. I think I am better off committing smaller logical changes 
in each patch.

> Again, function arguments exist for a reason.

ok makes sense, I will do this in the next version.

> 
> Thanks,
> 
>          tglx
> 
