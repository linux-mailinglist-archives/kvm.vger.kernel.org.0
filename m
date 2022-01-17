Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EDE490B14
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240312AbiAQPEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:04:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:59607 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233003AbiAQPEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 10:04:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642431872; x=1673967872;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8hAcDQdsGYS2a64rx034wwDmCqbWr8Zo5bXT7BLZY1w=;
  b=W7qtXRfvFNxSbJ8xjCqDQrUyFp0rH7XA7/NUyGB0pOLFp3x1lSTQAwrr
   Ot9IXUyRDBe7wQhaS7bxirW50EoC9OSF/TUzxGxDhLdnNaCqxrsVm++gu
   g90vqwbpF4g/vjAw8CK6ZqVM631QWAaMpAoItJFqZYoJ1XLA+ESdYz+rI
   V7pI0vZwhNnlq3+9/KmmEXCHW15ATL2OMsiW+BYUPYvbDnhhS/ZQjyJvH
   f3sLmDpWXIzgWYNcWsjmnU9yP64gI9wLNnXBA57V3FXHQP2DtNJlRZJTn
   sA+xQJmFXELfeKxxAGjg/tNYSwlUH920uNPYr5IOETuMjX2sHiZYjoWAx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="244438026"
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="244438026"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 07:04:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="476679426"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.209.10]) ([10.254.209.10])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 07:04:27 -0800
Message-ID: <67262b95-d577-0620-79bf-20fc37906869@intel.com>
Date:   Mon, 17 Jan 2022 23:04:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
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
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YeGiVCn0wNH9eqxX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/2022 12:18 AM, Sean Christopherson wrote:
> On Fri, Jan 14, 2022, Zeng Guang wrote:
>> On 1/14/2022 6:09 AM, Sean Christopherson wrote:
>>> On Fri, Dec 31, 2021, Zeng Guang wrote:
>>>> +static int vmx_expand_pid_table(struct kvm_vmx *kvm_vmx, int entry_idx)
>>>> +{
>>>> +	u64 *last_pid_table;
>>>> +	int last_table_size, new_order;
>>>> +
>>>> +	if (entry_idx <= kvm_vmx->pid_last_index)
>>>> +		return 0;
>>>> +
>>>> +	last_pid_table = kvm_vmx->pid_table;
>>>> +	last_table_size = table_index_to_size(kvm_vmx->pid_last_index + 1);
>>>> +	new_order = get_order(table_index_to_size(entry_idx + 1));
>>>> +
>>>> +	if (vmx_alloc_pid_table(kvm_vmx, new_order))
>>>> +		return -ENOMEM;
>>>> +
>>>> +	memcpy(kvm_vmx->pid_table, last_pid_table, last_table_size);
>>>> +	kvm_make_all_cpus_request(&kvm_vmx->kvm, KVM_REQ_PID_TABLE_UPDATE);
>>>> +
>>>> +	/* Now old PID table can be freed safely as no vCPU is using it. */
>>>> +	free_pages((unsigned long)last_pid_table, get_order(last_table_size));
>>> This is terrifying.  I think it's safe?  But it's still terrifying.
>> Free old PID table here is safe as kvm making request KVM_REQ_PI_TABLE_UPDATE
>> with KVM_REQUEST_WAIT flag force all vcpus trigger vm-exit to update vmcs
>> field to new allocated PID table. At this time, it makes sure old PID table
>> not referenced by any vcpu.
>> Do you mean it still has potential problem?
> No, I do think it's safe, but it is still terrifying :-)
>
>>> Rather than dynamically react as vCPUs are created, what about we make max_vcpus
>>> common[*], extend KVM_CAP_MAX_VCPUS to allow userspace to override max_vcpus,
>>> and then have the IPIv support allocate the PID table on first vCPU creation
>>> instead of in vmx_vm_init()?
>>>
>>> That will give userspace an opportunity to lower max_vcpus to reduce memory
>>> consumption without needing to dynamically muck with the table in KVM.  Then
>>> this entire patch goes away.
>> IIUC, it's risky if relying on userspace .
> That's why we have cgroups, rlimits, etc...
>
>> In this way userspace also have chance to assign large max_vcpus but not use
>> them at all. This cannot approach the goal to save memory as much as possible
>> just similar as using KVM_MAX_VCPU_IDS to allocate PID table.
> Userspace can simply do KVM_CREATE_VCPU until it hits KVM_MAX_VCPU_IDS...
IIUC, what you proposed is to use max_vcpus in kvm for x86 arch 
(currently not present yet) and
provide new api for userspace to notify kvm how many vcpus in current vm 
session prior to vCPU creation.
Thus IPIv can setup PID-table with this information in one shot.
I'm thinking this may have several things uncertain:
1. cannot identify the exact max APIC ID corresponding to max vcpus
APIC ID definition is platform dependent. A large APIC ID could be 
assigned to one vCPU in theory even running with
small max_vcpus. We cannot figure out max APIC ID supported mapping to 
max_vcpus.

2. cannot optimize the memory consumption on PID table to the least at 
run-time
  In case "-smp=small_n,maxcpus=large_N", kvm has to allocate memory to 
accommodate large_N vcpus at the
beginning no matter whether all maxcpus will run.

3. Potential backward-compatible problem
If running with old QEMU version,  kvm cannot get expected information 
so as to make a fallback to use
KVM_MAX_VCPU_IDS by default. It's feasible but not benefit on memory 
optimization for PID table.

What's your opinion ? Thanks.
