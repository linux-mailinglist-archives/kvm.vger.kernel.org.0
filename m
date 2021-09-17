Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF28E40FD95
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 18:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbhIQQLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 12:11:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:9698 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242637AbhIQQLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 12:11:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="245224085"
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="245224085"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:10:13 -0700
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="546477010"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.208.219]) ([10.254.208.219])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:10:08 -0700
Subject: Re: [PATCH v4 6/6] KVM: VMX: enable IPI virtualization
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
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-7-guang.zeng@intel.com> <YTvttCcfqF7D/CXt@google.com>
 <YTvwbUhofR3Fv7bV@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <c13b1ad7-f250-1f7f-4f6c-886b81b06517@intel.com>
Date:   Sat, 18 Sep 2021 00:10:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTvwbUhofR3Fv7bV@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/2021 7:55 AM, Sean Christopherson wrote:
> On Fri, Sep 10, 2021, Sean Christopherson wrote:
>> On Mon, Aug 09, 2021, Zeng Guang wrote:
>>> +		if (!pages)
>>> +			return -ENOMEM;
>>> +
>>> +		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
>>> +		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_ID;
>> I don't see the point of pid_last_index if we're hardcoding it to KVM_MAX_VCPU_ID.
>> If I understand the ucode pseudocode, there's no performance hit in the happy
>> case, i.e. it only guards against out-of-bounds accesses.
>>
>> And I wonder if we want to fail the build if this grows beyond an order-1
>> allocation, e.g.
>>
>> 		BUILD_BUG_ON(PID_TABLE_ORDER > 1);
>>
>> Allocating two pages per VM isn't terrible, but 4+ starts to get painful when
>> considering the fact that most VMs aren't going to need more than one page.  For
>> now I agree the simplicity of not dynamically growing the table is worth burning
>> a page.
> Ugh, Paolo has queued a series which bumps KVM_MAX_VCPU_ID to 4096[*].  That makes
> this an order-3 allocation, which is quite painful.  One thought would be to let
> userspace declare the max vCPU it wants to create, not sure if that would work for
> xAPIC though.
>
> [*] https://lkml.kernel.org/r/1111efc8-b32f-bd50-2c0f-4c6f506b544b@redhat.com
Thus we keep current design as no change.
