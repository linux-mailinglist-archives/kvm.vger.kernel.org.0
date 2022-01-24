Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C324984FC
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 17:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbiAXQkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 11:40:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:13016 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236102AbiAXQkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 11:40:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643042414; x=1674578414;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MrgQitvtOWVHTnHUojQtooTuvQQ5xWumXXPm8dAS4EE=;
  b=U1PlyMPtvSocnwvufDqVPYmKjSPaSkEycWhNT55j73zul6pqY9xhHq/O
   tpbrjwQspJ3Nv31iV7+/eNcZ6Yan9AQZbwwbRHp8GqC7oBoTpx+vxjh4i
   21INqSi7U2gbs2AB3zbumYj9JippzwT6WpYyWRUWzpvhJlO+sICtcvJPm
   7Udzz0YuQ9n0YXtLAG8P3PSpoRNr93lGEi4pXyoU8GyB1DAOD/HZI3+0B
   tNQbbWql6rcdBC7jKtuvlcFli61Ho5/fi3b0zz1Bl8p0jQYS3pz90WQho
   rrzyT19r8tIUjwD4r4goBU+XLAno/mLcaSijzkvD904uUcdtGgYvvkx7Q
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="246033249"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="246033249"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 08:40:13 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="534306104"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.213.37]) ([10.254.213.37])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 08:40:09 -0800
Message-ID: <2207797e-6441-8abc-9ffc-d231fa4ca3fc@intel.com>
Date:   Tue, 25 Jan 2022 00:40:01 +0800
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
 <aba84be5-562a-369e-913d-1b834c141cc6@intel.com>
 <Yei0d0KVnNphPrP3@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <Yei0d0KVnNphPrP3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/2022 9:01 AM, Sean Christopherson wrote:
> On Wed, Jan 19, 2022, Zeng Guang wrote:
>> It's self-adaptive , standalone function module in kvm, no any extra
>> limitation introduced
> I disagree.  Its failure mode on OOM is to degrade guest performance, _that_ is
> a limitation.  OOM is absolutely something that should be immediately communicated
> to userspace in a way that userspace can take action.
If memory allocation fails, PID-pointer table stop updating and keep using
the old one.  All IPIs from other vcpus will go through APIC-Write VM-exits
and won't get performance improvement from IPI virtualization to this new
created vcpu. Right, it's a limitation though it doesn't impact the 
effectiveness
of IPI virtualization among existing vcpus.
>> and scalable even future extension on KVM_MAX_VCPU_IDS or new apic id
>> implementation released.
>>
>> How do you think ? :)
> Heh, I think I've made it quite clear that I think it's unnecesary complexity in
> KVM.  It's not a hill I'll die on, e.g. if Paolo and others feel it's the right
> approach then so be it, but I really, really dislike the idea of dynamically
> changing the table, KVM has a long and sordid history of botching those types
> of flows/features.

To follow your proposal, we think about the feasible implementation as 
follows:
1. Define new parameter apic_id_limit in struct kvm_arch and initialized
as KVM_MAX_VCPU_IDS by default.

2. New vm ioclt KVM_SET_APICID_LIMIT to allow user space set the possible
max apic id required in the vm session before vcpu creation. Currently
QEMU calculates the limit to CPU APIC ID up to max cpus assigned for
hotpluggable cpu. It simply uses package/die/core/smt model to get bit
width of id field on each level (not totally comply with CPUID 1f/0b) and
make apic id for specific vcpu index. We can notify kvm this apic id limit
to ensure memory enough for PID-table.

3. Need check whether id is less than min(apic_id_limit, KVM_MAX_VCPU_IDS)
in vcpu creation. Otherwise return error.

4. Allocate memory covering vcpus with the id up to apic_id_limit for PID
table during the first vcpu creation. Proper lock still needed to 
protect PID
table setup from race condition. If OOM happens, current vcpu creation
fails either and return error back to user space.

Plz let us know whether we can go for this solution further. Thanks.

