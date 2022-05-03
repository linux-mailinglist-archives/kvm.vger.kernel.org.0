Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA63517BF6
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 04:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiECChc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 22:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiECCh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 22:37:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103D135DE4;
        Mon,  2 May 2022 19:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651545237; x=1683081237;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WBUjd94GFESloMTPlC1yOxm2mtL52euUFtKl5bmWLdM=;
  b=BD8ZuEtshTqwIFD3b+ZMmM3kSI8aPZpKaoBeDIjJIg+ZjWxLIAwHGI0B
   qfPA/++ls+PUDMu4VA7ORMimlRvls8CievPCTHaxkjOK9OfNw5Wq/LAMH
   gKRaaawxUbGXIP9rUaZgnOZB2qUlz6E5skXmx4DDtUkv5vLNHXc7mGF2o
   uI4YXsByMxPPkbk1wwe+eo/L7SALbrAjydjMgKjU0khi9w6Pky+Hkajb1
   iTNRrhh9qU6S20iiPn3rJ1Eu5daQC/i6J8YSwaH2URxr1qXbnMww+Ju21
   cVx0Ec2tD2HVjnfgQdODmoTZfbfzdLUyAdUN3KCEEYiyaUmoDZwW38FmJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="249362984"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="249362984"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 19:33:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="584005365"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.252.188.134]) ([10.252.188.134])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 19:33:51 -0700
Message-ID: <da1fc56f-bcfe-cc6e-aff7-0f95a3bc6d20@intel.com>
Date:   Tue, 3 May 2022 10:33:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v9 8/9] KVM: x86: Allow userspace set maximum VCPU id for
 VM
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
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
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20220419154444.11888-1-guang.zeng@intel.com>
 <a06997fe-8dd7-e91a-2017-912827f554e7@redhat.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <a06997fe-8dd7-e91a-2017-912827f554e7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/2022 12:07 AM, Paolo Bonzini wrote:
> On 4/19/22 17:44, Zeng Guang wrote:
>> +Userspace is able to calculate the limit to APIC ID values from designated CPU
>> +topology. This capability allows userspace to specify maximum possible APIC ID
>> +assigned for current VM session prior to the creation of vCPUs. By design, it
>> +can set only once and doesn't accept change any more. KVM will manage memory
>> +allocation of VM-scope structures which depends on the value of APIC ID.
>> +
>> +Calling KVM_CHECK_EXTENSION for this capability returns the value of maximum APIC
>> +ID that KVM supports at runtime. It sets as KVM_MAX_VCPU_IDS by default.
> Better:
>
> This capability allows userspace to specify maximum possible APIC ID
> assigned for current VM session prior to the creation of vCPUs, saving
> memory for data structures indexed by the APIC ID.  Userspace is able
> to calculate the limit to APIC ID values from designated
> CPU topology.
>
> The value can be changed only until KVM_ENABLE_CAP is set to a nonzero
> value or until a vCPU is created.  Upon creation of the first vCPU,
> if the value was set to zero or KVM_ENABLE_CAP was not invoked, KVM
> uses the return value of KVM_CHECK_EXTENSION(KVM_CAP_MAX_VCPU_ID) as
> the maximum APIC ID.
>
>>    	case KVM_CAP_MAX_VCPU_ID:
>> -		r = KVM_MAX_VCPU_IDS;
>> +		if (!kvm->arch.max_vcpu_ids)
>> +			r = KVM_MAX_VCPU_IDS;
>> +		else
>> +			r = kvm->arch.max_vcpu_ids;
> I think returning the constant KVM_CAP_MAX_VCPU_IDS is better.
>
> Paolo
Thanks. I will change as you suggested.
