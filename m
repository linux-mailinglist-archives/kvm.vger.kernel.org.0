Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34E024430B
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 04:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgHNCeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 22:34:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:23203 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgHNCeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 22:34:10 -0400
IronPort-SDR: s9edopWJtEwbSWPxKhescR3UxUeDqtbKe0ArYLuR6gMZvxdiBXsU1iRaS0M3ia12d//dSrvqjj
 Uf7NJg37+fRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="141974250"
X-IronPort-AV: E=Sophos;i="5.76,310,1592895600"; 
   d="scan'208";a="141974250"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 19:34:09 -0700
IronPort-SDR: 4x3/4P/u0xjbCeCodErI8a0w4AFEf7lBlU2baOIMDWcZ5ijkfhArb0MfI1VRiV6EN8ryzIBps4
 6Iq/kQAa4FLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,310,1592895600"; 
   d="scan'208";a="325595790"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.2.93]) ([10.238.2.93])
  by orsmga008.jf.intel.com with ESMTP; 13 Aug 2020 19:34:07 -0700
Subject: Re: [RFC 6/7] KVM: X86: Expose PKS to guest and userspace
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-7-chenyi.qiang@intel.com>
 <CALMp9eQ=QUZ04_26eXBGHqvQYnsN6JEgiV=ZSSrE395KLX-atA@mail.gmail.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <66cc68ea-a599-ffd5-9fc9-dd9c0749e3c8@intel.com>
Date:   Fri, 14 Aug 2020 10:33:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ=QUZ04_26eXBGHqvQYnsN6JEgiV=ZSSrE395KLX-atA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/14/2020 3:04 AM, Jim Mattson wrote:
> On Fri, Aug 7, 2020 at 1:47 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>>
>> Existence of PKS is enumerated via CPUID.(EAX=7H,ECX=0):ECX[31]. It is
>> enabled by setting CR4.PKS when long mode is active. PKS is only
>> implemented when EPT is enabled and requires the support of VM_{ENTRY,
>> EXIT}_LOAD_IA32_PKRS currently.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> 
>> @@ -967,7 +969,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>>   {
>>          unsigned long old_cr4 = kvm_read_cr4(vcpu);
>>          unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
>> -                                  X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
>> +                                  X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE |
>> +                                  X86_CR4_PKS;
> 
> This list already seems overly long, but I don't think CR4.PKS belongs
> here. In volume 3 of the SDM, section 4.4.1, it says:
> 
> - If PAE paging would be in use following an execution of MOV to CR0
> or MOV to CR4 (see Section 4.1.1) and the instruction is modifying any
> of CR0.CD, CR0.NW, CR0.PG, CR4.PAE, CR4.PGE, CR4.PSE, or CR4.SMEP;
> then the PDPTEs are loaded from the address in CR3.
> 
> CR4.PKS is not in the list of CR4 bits that result in a PDPTE load.
> Since it has no effect on PAE paging, I would be surprised if it did
> result in a PDPTE load.
> 

Oh, My mistake.

>>          if (kvm_valid_cr4(vcpu, cr4))
>>                  return 1;
>> @@ -1202,7 +1205,7 @@ static const u32 msrs_to_save_all[] = {
>>          MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>>          MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>>          MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
>> -       MSR_IA32_UMWAIT_CONTROL,
>> +       MSR_IA32_UMWAIT_CONTROL, MSR_IA32_PKRS,
> 
> Should MSR_IA32_PKRS be added to the switch statement in
> kvm_init_msr_list()? Something like...
> 
> case MSR_IA32_PKRS:
>          if (!kvm_cpu_cap_has(X86_FEATURE_PKRS))
>                  continue;
>          break;
> 

Yes, this should be added.
