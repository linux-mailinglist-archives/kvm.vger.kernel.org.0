Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC194935F0
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 08:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344765AbiASH4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 02:56:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:28552 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235096AbiASH4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 02:56:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642578960; x=1674114960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Os56kLMd0kjXcgux4x7i9dbY012Pv8vPfsbJq5keC/4=;
  b=M/grDbHjzpYn/pO0GX+Cp00Lv9t27OYGlyPcnZbrN/Yus+4FoduMvBT+
   mF3fy6hSfw+NyhSTI4tJrX6BbsToq+UymSAHEK0UbJyCwaPENayLkzALL
   BY0crew1G0M7T/ZEqubSaBds8/gBNre50zHk4IFihj8rnVn9YONke9vLd
   C61/kz6u0eWUBvwxpwzUW4wa2Q5M82eqin2MbYObcG+TP8YoVCPFX63OS
   UErs36Ak3AjCunNYxsfVYFyxwIS+wx0e5c4VKp4i9lJn2n60WYJ8g9Nas
   zPjD0dZk5nSAv9mgc1aVikNKr5Wu4kQgOJ0vHB2LXPJ99KWmdiGD3HaeE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="245205912"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="245205912"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 23:55:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="532162832"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.96]) ([10.238.0.96])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 23:55:54 -0800
Message-ID: <aba84be5-562a-369e-913d-1b834c141cc6@intel.com>
Date:   Wed, 19 Jan 2022 15:55:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH v5 8/8] KVM: VMX: Resize PID-ponter table on demand for
 IPI virtualization
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-9-guang.zeng@intel.com> <YeCjHbdAikyIFQc9@google.com>
 <43200b86-aa40-f7a3-d571-dc5fc3ebd421@intel.com>
 <YeGiVCn0wNH9eqxX@google.com>
 <67262b95-d577-0620-79bf-20fc37906869@intel.com>
 <Yeb1vkEclYzD27R/@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <Yeb1vkEclYzD27R/@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/19/2022 1:15 AM, Sean Christopherson wrote:
> On Mon, Jan 17, 2022, Zeng Guang wrote:
>> On 1/15/2022 12:18 AM, Sean Christopherson wrote:
>>> Userspace can simply do KVM_CREATE_VCPU until it hits KVM_MAX_VCPU_IDS...
>> IIUC, what you proposed is to use max_vcpus in kvm for x86 arch (currently
>> not present yet) and
>> provide new api for userspace to notify kvm how many vcpus in current vm
>> session prior to vCPU creation.
>> Thus IPIv can setup PID-table with this information in one shot.
>> I'm thinking this may have several things uncertain:
>> 1. cannot identify the exact max APIC ID corresponding to max vcpus
>> APIC ID definition is platform dependent. A large APIC ID could be assigned
>> to one vCPU in theory even running with
>> small max_vcpus. We cannot figure out max APIC ID supported mapping to
>> max_vcpus.
> Gah, I conflated KVM_CAP_MAX_VCPUS and KVM_MAX_VCPU_IDS.  But the underlying idea
> still works: extend KVM_MAX_VCPU_IDS to allow userspace to lower the max allowed
> vCPU ID to reduce the memory footprint of densely "packed" and/or small VMs.

Possibly it may not work well as expected. From user's perspective, 
assigning
max apic id requires knowledge of apic id implementation on various 
platform.
It's hard to let user to determine an appropriate value for every vm 
session.
User may know his exact demand on vcpu resource like cpu number of smp ,
max cpus for cpu hotplug etc, but highly possibly not know or care about 
what
the apic id should be. If an improper value is provided, we cannot 
achieve the
goal to reduce the memory footprint, but also may lead to unexpected 
failure on
vcpu creation, e.g. actual vcpu id(=apic id) is larger than max apic id 
assigned.  So
this solution seems still have potential problem existing.
Besides, it also need change user hypervisor(QEMU etc.) and kvm (kvm arch,
vcpu creation policy etc.) which unnecessarily interrelate such modules 
together.
 From these point of view, it's given not much advantage other than 
simplifying IPIv
memory management on PID table.

>> 2. cannot optimize the memory consumption on PID table to the least at
>> run-time
>>   In case "-smp=small_n,maxcpus=large_N", kvm has to allocate memory to
>> accommodate large_N vcpus at the
>> beginning no matter whether all maxcpus will run.
> That's a feature.  E.g. if userspace defines a max vCPU ID that is larger than
> what is required at boot, e.g. to hotplug vCPUs, then consuming a few extra pages
> of memory to ensure that IPIv will be supported for hotplugged vCPUs is very
> desirable behavior.  Observing poor performance on hotplugged vCPUs because the
> host was under memory pressure is far worse.
>
> And the goal isn't to achieve the smallest memory footprint possible, it's to
> avoid allocating 32kb of memory when userspace wants to run a VM with only a
> handful of vCPUs, i.e. when 4kb will suffice.  Consuming 32kb of memory for a VM
> with hundreds of vCPUs is a non-issue, e.g. it's highly unlikely to be running
> multiple such VMs on a single host, and such hosts will likely have hundreds of
> gb of RAM.  Conversely, hosts running run small VMs will likely run tens or hudreds
> of small VMs, e.g. for container scenarios, in which case reducing the per-VM memory
> footprint is much more valuable and also easier to achieve.
Agree. This is the purpose to implement this patch. With current 
solution we proposed,  IPIv just
use memory as less as possible in all kinds of scenarios, and keep 4Kb 
in most cases instead of 32Kb.
It's self-adaptive , standalone function module in kvm, no any extra 
limitation introduced and scalable
even future extension on KVM_MAX_VCPU_IDS or new apic id implementation 
released.
How do you think ? :)
>> 3. Potential backward-compatible problem
>> If running with old QEMU version,  kvm cannot get expected information so as
>> to make a fallback to use
>> KVM_MAX_VCPU_IDS by default. It's feasible but not benefit on memory
>> optimization for PID table.
> That's totally fine.  This is purely a memory optimization, IPIv will still work
> as intended if usersepace doesn't lower the max vCPU ID, it'll just consume a bit
> more memory.

