Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E08B46E9FD
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 15:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhLIOfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 09:35:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:56913 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238563AbhLIOfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 09:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639060322; x=1670596322;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2M49wV9agpeIXgunzDrncYD71zahzY9cEiKo8KeHXEw=;
  b=G1l4kXpfhHsFSWannu3QDmD8jcP+ZjD7ALgVpU9uubfSqf0/BaNNLNQA
   c1ipzDGdFVkmLD87sQ8CwQKCKACfAw6gpRz4zLEgmdn1WeYXyGnLnLusr
   r4tnBTC6CkbENLS/gK6/1yap+WYeX0KTzmUftZA0B3gzvaRtn9BYgnBZ1
   vF/PeYIKF2PLw8fmasAutE11ckK6fTG0rrflRxC8tNygzfWAOo9GPaxyv
   qDFkUr0S7WcntJa/rd80apQ7rBpqwJISIrWd4me4nfKrDER0Y5ie2TWRS
   yLTgNxT8wUDgtVYW6ngJG5PJnGD6WsJsHfeJ5KkPZAB3c24bLQlbaSb9e
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="237914568"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="237914568"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 06:31:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="503510703"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.184]) ([10.255.29.184])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 06:31:39 -0800
Message-ID: <eac9c0b1-30c7-04e9-2c89-9047bebf2683@intel.com>
Date:   Thu, 9 Dec 2021 22:31:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v2 32/44] tdx: add kvm_tdx_enabled() accessor for
 later use
Content-Language: en-US
To:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <26d88e7618038c1fed501352a04144745abd12ae.1625704981.git.isaku.yamahata@intel.com>
 <43a81d27-56da-07e8-b3d7-9800b6ed8da1@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <43a81d27-56da-07e8-b3d7-9800b6ed8da1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/23/2021 1:53 AM, Connor Kuehl wrote:
> On 7/7/21 7:55 PM, isaku.yamahata@gmail.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   include/sysemu/tdx.h  | 1 +
>>   target/i386/kvm/kvm.c | 5 +++++
>>   2 files changed, 6 insertions(+)
>>
>> diff --git a/include/sysemu/tdx.h b/include/sysemu/tdx.h
>> index 70eb01348f..f3eced10f9 100644
>> --- a/include/sysemu/tdx.h
>> +++ b/include/sysemu/tdx.h
>> @@ -6,6 +6,7 @@
>>   #include "hw/i386/pc.h"
>>   bool kvm_has_tdx(KVMState *s);
>> +bool kvm_tdx_enabled(void);
>>   int tdx_system_firmware_init(PCMachineState *pcms, MemoryRegion 
>> *rom_memory);
>>   #endif
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index af6b5f350e..76c3ea9fac 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -152,6 +152,11 @@ int kvm_set_vm_type(MachineState *ms, int kvm_type)
>>       return -ENOTSUP;
>>   }
>> +bool kvm_tdx_enabled(void)
>> +{
>> +    return vm_type == KVM_X86_TDX_VM;
>> +}
>> +
> 
> Is this the whole story? Does this guarantee that the VM QEMU is
> responsible to bring up is a successfully initialized TD?

No, it just means a TDX guest is requested.

>  From my reading of the series as it unfolded, this looks like the
> function proves that KVM can support TDs and that the user requested
> a TDX kvm-type, not that we have a fully-formed TD.

yes, you are right. We referenced what sev_eanbled() and sev_es_enabled().

If the name is misleading, does it looks better to name it is_tdx_vm()?

> Is it possible to associate this with a more verifiable metric that
> the TD has been or will be created successfully? I.e., once the VM
> has successfully called the TDX INIT ioctl or has finalized setup?
> 
> My question mainly comes from a later patch in the series, where the
> "query-tdx-capabilities" and "query-tdx" QMP commands are added.
> 
> Forgive me if I am misinterpreting the semantics of each of these
> commands:

what you understood is correct.

> "query-tdx-capabilities" sounds like it answers the question of
> "can it run a TD?"
> 
> and "query-tdx" sounds like it answers the question of "is it a TD?"
> 
> Is the assumption with "query-tdx" that anything that's gone wrong
> with developing a TD will have resulted in the QEMU process exiting
> and therefore if we get to a point where we can run "query-tdx" then
> we know the TD was successfully formed?
> 

