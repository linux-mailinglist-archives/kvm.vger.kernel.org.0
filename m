Return-Path: <kvm+bounces-7296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD2583FC1A
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 03:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA79BB22266
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 02:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907FBEECC;
	Mon, 29 Jan 2024 02:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SpFudthm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239ACDF66
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 02:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706494702; cv=none; b=FCeo4H53OESrUgpac75gXtcqd3KXUfv0HbubxDQi6urmUZi6fZIQ0mg/CYzvO4c4HGeVSpb7w1CkOiquQ5TWHmlVfjXJipU9yPu9ZtNcUF2Sr17twuSqxo3y/bkoUuxDIOuryYWT3bYXbjPP8IdBB0IpBnYefTplBnab7an+Uic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706494702; c=relaxed/simple;
	bh=7Ckr2Cq+5wBZxzyfGfy82+8eibA0jeCeuSZAZYN+s44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i/fly17JDc+vtFhu2fItmvhDj7O/vhb3r1R8mYfMAQ6ygeGBI4Ae7xvPqWygy5nqNwe3879gp1iF0Ba1sw4wuUtPpuj1hWNT5MguWq0BcU1uokcR81NPrXTTQ5YDg9bigR5mV/91PrWNs4SOtvr79dPIvWNwQSrqiRMb6yPSzCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SpFudthm; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706494702; x=1738030702;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7Ckr2Cq+5wBZxzyfGfy82+8eibA0jeCeuSZAZYN+s44=;
  b=SpFudthm3jw82Woun9gh/4rim10BeFbdrBa3M3u1Kb7DUSplSFOyR4eC
   rSxyv+t7QJssCAbIrA7CWx6OBTrX/1CqrviUPf8ewPFVJhbd9GkLRcc0x
   lM27H1xlwX+eHyLL7/uPqEM450nHKoFnnI4OaaVCOjo+0B2z0n9SU7FxD
   k0TWqlh8RTFRi8RvtoZpR3KOxLweTPLSzAFrHuMCHCwFhWWwYU8FU4M0i
   Aq5/WA3EpIdo2FQtsFojCrXU9ExeOLLXbJVImeKaWN/z/XdrAEa65p+5W
   l/lHyBZrvP+4dDyUDwjSzl8Tzh/z6I3X6phUwmRCk7oEUtSBQRr2lKuee
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="10216689"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="10216689"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 18:18:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="737241304"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="737241304"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 18:18:14 -0800
Message-ID: <86cda9fa-3921-458f-9930-d73d247ccaa1@intel.com>
Date: Mon, 29 Jan 2024 10:18:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 33/66] i386/tdx: Make memory type private by default
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-34-xiaoyao.li@intel.com>
 <12d89ebd-3497-4e60-8900-7a7a1ffbd6e2@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <12d89ebd-3497-4e60-8900-7a7a1ffbd6e2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/26/2024 10:58 PM, David Hildenbrand wrote:
> On 25.01.24 04:22, Xiaoyao Li wrote:
>> By default (due to the recent UPM change), restricted memory attribute is
>> shared.  Convert the memory region from shared to private at the memory
>> slot creation time.
>>
>> add kvm region registering function to check the flag
>> and convert the region, and add memory listener to TDX guest code to set
>> the flag to the possible memory region.
>>
>> Without this patch
>> - Secure-EPT violation on private area
>> - KVM_MEMORY_FAULT EXIT (kvm -> qemu)
>> - qemu converts the 4K page from shared to private
>> - Resume VCPU execution
>> - Secure-EPT violation again
>> - KVM resolves EPT Violation
>> This also prevents huge page because page conversion is done at 4K
>> granularity.  Although it's possible to merge 4K private mapping into
>> 2M large page, it slows guest boot.
>>
>> With this patch
>> - After memory slot creation, convert the region from private to shared
>> - Secure-EPT violation on private area.
>> - KVM resolves EPT Violation
>>
>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   include/exec/memory.h |  1 +
>>   target/i386/kvm/tdx.c | 20 ++++++++++++++++++++
>>   2 files changed, 21 insertions(+)
>>
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 7229fcc0415f..f25959f6d30f 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -850,6 +850,7 @@ struct IOMMUMemoryRegion {
>>   #define MEMORY_LISTENER_PRIORITY_MIN            0
>>   #define MEMORY_LISTENER_PRIORITY_ACCEL          10
>>   #define MEMORY_LISTENER_PRIORITY_DEV_BACKEND    10
>> +#define MEMORY_LISTENER_PRIORITY_ACCEL_HIGH     20
>>   /**
>>    * struct MemoryListener: callbacks structure for updates to the 
>> physical memory map
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 7b250d80bc1d..f892551821ce 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -19,6 +19,7 @@
>>   #include "standard-headers/asm-x86/kvm_para.h"
>>   #include "sysemu/kvm.h"
>>   #include "sysemu/sysemu.h"
>> +#include "exec/address-spaces.h"
>>   #include "hw/i386/x86.h"
>>   #include "kvm_i386.h"
>> @@ -621,6 +622,19 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>       return 0;
>>   }
>> +static void tdx_guest_region_add(MemoryListener *listener,
>> +                                 MemoryRegionSection *section)
>> +{
>> +    memory_region_set_default_private(section->mr);
>> +}
> 
> That looks fishy. Why is TDX to decide what happens to other memory 
> regions it doesn't own?
> 
> We should define that behavior when creating these memory region, and 
> TDX could sanity check that they have been setup properly.
> 
> Let me ask differently: For which memory region where we have 
> RAM_GUEST_MEMFD set would we *not* want to set private as default right 
> from the start?

All memory regions have RAM_GUEST_MEMFD set will benefit from being 
private as default, for TDX guest.

I will update the implementation to set RAM_DEFAULT_PRIVATE flag when 
guest_memfd is created successfully, like

diff --git a/system/physmem.c b/system/physmem.c
index fc59470191ef..60676689c807 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1850,6 +1850,8 @@ static void ram_block_add(RAMBlock *new_block, 
Error **errp)
              qemu_mutex_unlock_ramlist();
              return;
          }
+
+        new_block->flags |= RAM_DEFAULT_PRIVATE;
      }

then this patch can be dropped, and the calling of 
memory_region_set_default_private(mr) of Patch 45 can be dropped too.

I think this is what you suggested, right?



