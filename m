Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED5548ED96
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 17:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238931AbiANQAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 11:00:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:56036 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236311AbiANQAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 11:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642176014; x=1673712014;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aj2gJ9xDWwhDAK2L30Eh73Nu5/kH0hbb15rkhPR0Ffo=;
  b=OjAoiZdtOCkTnapR+zGyY/Wb0KA5wDxOcuhAYaFrXE+7ykUoIYQYzXVQ
   uKkeBw5nYSAagHlUNNYOCjvohoW3+XV4HxvruOsemK23QhaDu9pYQX4se
   hvy39DNayp5P7llh3eAsbu2dNff9tfrVpncmqsQJSQ7OHEsFqu2ASdgMw
   6rhIbbdycuy1zXrmi5YrPG5fTL/QvNpkzjg4wQwQleqmVk2DdlXBXIYcF
   JALVY7GHD/e+dq6uvVWM/NmwXIL2z4kyw+J+egkCpgMHt61D2kBuZxXvk
   bFOK37Il9wYIVVrljrTQhvRv3wHiDolxHkSvR+Qd3la1uDeJpomdVnbdY
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244470674"
X-IronPort-AV: E=Sophos;i="5.88,289,1635231600"; 
   d="scan'208";a="244470674"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 08:00:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,289,1635231600"; 
   d="scan'208";a="516439986"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.213.217]) ([10.254.213.217])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 08:00:07 -0800
Message-ID: <43200b86-aa40-f7a3-d571-dc5fc3ebd421@intel.com>
Date:   Fri, 14 Jan 2022 23:59:54 +0800
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
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YeCjHbdAikyIFQc9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/2022 6:09 AM, Sean Christopherson wrote:
> On Fri, Dec 31, 2021, Zeng Guang wrote:
>> +static int vmx_expand_pid_table(struct kvm_vmx *kvm_vmx, int entry_idx)
>> +{
>> +	u64 *last_pid_table;
>> +	int last_table_size, new_order;
>> +
>> +	if (entry_idx <= kvm_vmx->pid_last_index)
>> +		return 0;
>> +
>> +	last_pid_table = kvm_vmx->pid_table;
>> +	last_table_size = table_index_to_size(kvm_vmx->pid_last_index + 1);
>> +	new_order = get_order(table_index_to_size(entry_idx + 1));
>> +
>> +	if (vmx_alloc_pid_table(kvm_vmx, new_order))
>> +		return -ENOMEM;
>> +
>> +	memcpy(kvm_vmx->pid_table, last_pid_table, last_table_size);
>> +	kvm_make_all_cpus_request(&kvm_vmx->kvm, KVM_REQ_PID_TABLE_UPDATE);
>> +
>> +	/* Now old PID table can be freed safely as no vCPU is using it. */
>> +	free_pages((unsigned long)last_pid_table, get_order(last_table_size));
> This is terrifying.  I think it's safe?  But it's still terrifying.

Free old PID table here is safe as kvm making request 
KVM_REQ_PI_TABLE_UPDATE with
KVM_REQUEST_WAIT flag force all vcpus trigger vm-exit to update vmcs 
field to new allocated
PID table. At this time, it makes sure old PID table not referenced by 
any vcpu.
Do you mean it still has potential problem?

> Rather than dynamically react as vCPUs are created, what about we make max_vcpus
> common[*], extend KVM_CAP_MAX_VCPUS to allow userspace to override max_vcpus,
> and then have the IPIv support allocate the PID table on first vCPU creation
> instead of in vmx_vm_init()?
>
> That will give userspace an opportunity to lower max_vcpus to reduce memory
> consumption without needing to dynamically muck with the table in KVM.  Then
> this entire patch goes away.
IIUC, it's risky if relying on userspace . In this way userspace also 
have chance to assign large max_vcpus
but not use them at all. This cannot approach the goal to save memory as 
much as possible just similar
as using KVM_MAX_VCPU_IDS to allocate PID table.

