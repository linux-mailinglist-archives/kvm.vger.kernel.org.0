Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B162413F5
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 01:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgHJXum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 19:50:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:27710 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgHJXum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 19:50:42 -0400
IronPort-SDR: tx1ywy8nT1Yrkz20UFB5LSgjyMApr5mMMPVq6emU3v+YhnkIl48gN3GW58nq7XKz8+lGZevhtc
 VQPUFs1nry7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="152858418"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="152858418"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 16:50:42 -0700
IronPort-SDR: Y2pPC4qJbAiiOxD1cy+sIfpsDauasB7V3WzgaLYzFTFPpIha+K/PrlSrro13YxMlQebkBPWxZZ
 sgQv6Ih2ePhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="494968925"
Received: from ziranzha-mobl.ccr.corp.intel.com (HELO [10.255.28.102]) ([10.255.28.102])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2020 16:50:36 -0700
Subject: Re: [PATCH v3 2/2] x86/kvm: Expose new features for supported cpuid
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     sean.j.christopherson@intel.com, gregkh@linuxfoundation.org,
        tglx@linutronix.de, tony.luck@intel.com, dave.hansen@intel.com,
        kyung.min.park@intel.com, ricardo.neri-calderon@linux.intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        jpoimboe@redhat.com, ak@linux.intel.com, ravi.v.shankar@intel.com
References: <1596959242-2372-1-git-send-email-cathy.zhang@intel.com>
 <1596959242-2372-3-git-send-email-cathy.zhang@intel.com>
 <d7e9fb9a-e392-73b1-5fc8-3876cb30665c@redhat.com>
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
Message-ID: <27965021-2ec7-aa30-5526-5a6b293b2066@intel.com>
Date:   Tue, 11 Aug 2020 07:50:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <d7e9fb9a-e392-73b1-5fc8-3876cb30665c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/2020 1:14 AM, Paolo Bonzini wrote:
> On 09/08/20 09:47, Cathy Zhang wrote:
>> Expose the SERIALIZE and TSX Suspend Load Address Tracking
>> features in KVM CPUID, so when running on processors which
>> support them, KVM could pass this information to guests and
>> they can make use of these features accordingly.
>>
>> SERIALIZE is a faster serializing instruction which does not modify
>> registers, arithmetic flags or memory, will not cause VM exit. It's
>> availability is indicated by CPUID.(EAX=7,ECX=0):ECX[bit 14].
>>
>> TSX suspend load tracking instruction aims to give a way to choose
>> which memory accesses do not need to be tracked in the TSX read set.
>> It's availability is indicated as CPUID.(EAX=7,ECX=0):EDX[bit 16].
>>
>> Those instructions are currently documented in the the latest "extensions"
>> manual (ISE). It will appear in the "main" manual (SDM) in the future.
>>
>> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
>> Reviewed-by: Tony Luck <tony.luck@intel.com>
>> ---
>> Changes since v2:
>>   * Merge two patches into a single one. (Luck, Tony)
>>   * Add overview introduction for features. (Sean Christopherson)
>>   * Refactor commit message to explain why expose feature bits. (Luck, Tony)
>> ---
>>   arch/x86/kvm/cpuid.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 8a294f9..dcf48cc 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -341,7 +341,8 @@ void kvm_set_cpu_caps(void)
>>   	kvm_cpu_cap_mask(CPUID_7_EDX,
>>   		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>>   		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>> -		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
>> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>> +		F(SERIALIZE) | F(TSXLDTRK)
>>   	);
>>   
>>   	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
>>
> TSXLDTRK is not going to be in 5.9 as far as I can see, so I split back
> again the patches (this is why I prefer them to be split, sorry Tony :))
> and committed the SERIALIZE part.
>
> Paolo

Hello Paolo,

As you suggest, I will split the kvm patch into two parts, SERIALIZE and 
TSXLDTRK, and this series will include three patches then, 2 kvm patches 
and 1 kernel patch. SERIALIZE could get merged into 5.9, but TSXLDTRK 
should wait for the next release. I just want to double confirm with 
you, please help correct me if I'm wrong.

