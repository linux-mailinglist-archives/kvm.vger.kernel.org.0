Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53F9B72B5
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 07:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfISFbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 01:31:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:13604 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbfISFbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 01:31:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Sep 2019 22:31:31 -0700
X-IronPort-AV: E=Sophos;i="5.64,522,1559545200"; 
   d="scan'208";a="194279595"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/AES256-SHA; 18 Sep 2019 22:31:30 -0700
Subject: Re: [RFC][PATCH] kvm: x86: Improve emulation of CPUID leaves 0BH and
 1FH
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Steve Rutherford <srutherford@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
References: <20190912232753.85969-1-jmattson@google.com>
 <20190918174308.GC14850@linux.intel.com>
 <CALMp9eQSd8kMKEdLYTF2ugAYjQO-wAR-PoYmf0NgD2Z4ZVr5FA@mail.gmail.com>
 <CALMp9eSJkjO0CX2_s1QpgaYk-pDVCYoof_QVjxf9cpquaMOr1A@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <b3ebf989-8da9-6fa6-9296-ec694988e645@intel.com>
Date:   Thu, 19 Sep 2019 13:31:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSJkjO0CX2_s1QpgaYk-pDVCYoof_QVjxf9cpquaMOr1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/2019 2:41 AM, Jim Mattson wrote:
> On Wed, Sep 18, 2019 at 11:22 AM Jim Mattson <jmattson@google.com> wrote:
[...]>>>
>>> If I'm reading the code correctly, this is fragile and subtle.  The order
>>> of cpuid entries is controlled by userspace, which means that clearing
>>> KVM_CPUID_FLAG_SIGNIFCANT_INDEX depends on this entry being kept after all
>>> other entries for this function.  In practice I'm guessing userspaces
>>> naturally sort entries with the same function by ascending index, but it
>>> seems like avoidable issue.
>>
>> Though not documented, the CPUID leaf matching code has always
>> depended on ordering.
>>
>>> Also, won't matching the last entry generate the wrong values for EAX, EBX
>>> and ECX, i.e. the valid values for the last index instead of zeroes?
>>
>> This entry has CH==0. According to the SDM, "For sub-leaves that
>> return an invalid level-type of 0 in ECX[15:8]; EAX and EBX will
>> return 0."
>> ECX[7:0] will be wrong, but that's fixed up by the flag below.
>> ECX[31:16] are reserved and perhaps should be cleared here, but I'm
>> not sure how I would interpret it if those bits started being non-zero
>> for the first leaf with CH==0.
>>
>>>> +                     entry[i - 1].flags |= KVM_CPUID_FLAG_CL_IS_PASSTHROUGH;
>>>
>>> Lastly, do we actually need to enumerate this silliness to userspace?
>>> What if we handle this as a one-off case in CPUID emulation and avoid the
>>> ABI breakage that way?  E.g.:
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index dd5985eb61b4..aaf5cdcb88c9 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -1001,6 +1001,16 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>>>          }
>>>
>>>   out:
>>> +       if (!best && (function == 0xb || function == 0x1f)) {
>>> +               best = check_cpuid_limit(vcpu, function, 0);
>>> +               if (best) {
>>> +                       *eax = 0;
>>> +                       *ebx = 0;
>>> +                       *ecx &= 0xff;
>>> +                       *edx = *best->edx;
>>> +               }
>>> +       }
>>> +
>>

Hi Sean,
your proposal above seems not work. check_cpuid_limit(vcpu, 0xb/01f, 0) 
always return NULL, if there are valid 0xb/0x1f leaves in 
vcpu->arch.cpuid_entries[] (maxBaiscleaf >= 0xb/0x1f)

>> Aside from the fact that one should never call check_cpuid_limit on
>> AMD systems (they don't do the "last basic leaf" nonsense), an
>> approach like this should work.
> 
> The above proposal doesn't correctly handle a leaf outside of ([0,
> maxBasicLeaf] union [80000000H, maxExtendedLeaf]) , where maxBasicLeaf
> == (0BH or 1FH) on Intel hardware...but it could be fixed up to do so,
> if hard-coding this behavior in kvm_cpuid() is preferable to the API
> breakage.
> 

I vote for Sean's one-off case, how about something like this:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720cd948..6af5febf7b12 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -976,11 +976,23 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, 
u32 *ebx,
                u32 *ecx, u32 *edx, bool check_limit)
  {
         u32 function = *eax, index = *ecx;
-       struct kvm_cpuid_entry2 *best;
+       struct kvm_cpuid_entry2 *best, tmp;
         bool entry_found = true;

         best = kvm_find_cpuid_entry(vcpu, function, index);

+       if (!best && (fuction == 0xb || function == 0x1f) && index > 0) {
+               best = kvm_find_cpuid_entry(vcpu, function, 0);
+               if (best) {
+                       tmp.eax = 0;
+                       tmp.ebx = 0;
+                       tmp.ecx = index & 0xff;
+                       tmp.edx = best->edx;
+                       best = &tmp;
+                       goto out;
+               }
+       }
+
