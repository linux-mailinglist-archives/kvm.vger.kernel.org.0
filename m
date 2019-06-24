Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B9250012
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 05:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfFXDKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jun 2019 23:10:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:47896 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfFXDKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jun 2019 23:10:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jun 2019 20:10:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,410,1557212400"; 
   d="scan'208";a="312566017"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.129.47]) ([10.238.129.47])
  by orsmga004.jf.intel.com with ESMTP; 23 Jun 2019 20:10:04 -0700
Subject: Re: [PATCH RFC] kvm: x86: Expose AVX512_BF16 feature to guest
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <1561029712-11848-1-git-send-email-jing2.liu@linux.intel.com>
 <1561029712-11848-2-git-send-email-jing2.liu@linux.intel.com>
 <fd861e94-3ea5-3976-9855-05375f869f00@redhat.com>
 <384bc07d-6105-d380-cd44-4518870c15f1@linux.intel.com>
Message-ID: <fb749626-1d9e-138f-c673-14b52fe7170c@linux.intel.com>
Date:   Mon, 24 Jun 2019 11:10:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <384bc07d-6105-d380-cd44-4518870c15f1@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

After thinking more, I found way to satisfy all cases in a easy way.
How about things like this?

@@ -507,12 +510,26 @@ static inline int __do_cpuid_ent(struct 
kvm_cpuid_entry2 *entry, u32 fu
                          * if the host doesn't support it.
                          */
                         entry->edx |= F(ARCH_CAPABILITIES);
+               } else if (index == 1) {
+                       entry->eax &= kvm_cpuid_7_1_eax_x86_features;
+                       entry->ebx = 0;
+                       entry->ecx = 0;
+                       entry->edx = 0;
                 } else {
+                       entry->eax = 0;
                         entry->ebx = 0;
                         entry->ecx = 0;
                         entry->edx = 0;
                 }
-               entry->eax = 0;
+
+               if (index == 0 && entry->eax >= 1) {
+                       entry[1].eax &= kvm_cpuid_7_1_eax_x86_features;
+                       entry[1].ebx = 0;
+                       entry[1].ecx = 0;
+                       entry[1].edx = 0;
+                       entry[1].flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+                       ++*nent;
+               }
                 break;
         }


Or you prefer that I update this into another version later?

Thanks!
Jing

On 6/20/2019 11:09 PM, Liu, Jing2 wrote:
> Hi Paolo,
> 
> On 6/20/2019 8:16 PM, Paolo Bonzini wrote:
>> On 20/06/19 13:21, Jing Liu wrote:
>>> +        for (i = 1; i <= times; i++) {
>>> +            if (*nent >= maxnent)
>>> +                goto out;
>>> +            do_cpuid_1_ent(&entry[i], function, i);
>>> +            entry[i].eax &= F(AVX512_BF16);
>>> +            entry[i].ebx = 0;
>>> +            entry[i].ecx = 0;
>>> +            entry[i].edx = 0;
>>> +            entry[i].flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>>> +            ++*nent;
>>
>> This woud be wrong for i > 1, so instead make this
>>
>>     if (entry->eax >= 1)
>>
> 
> I am confused about the @index parameter. @index seems not used for
> every case except 0x07. Since the caller function only has @index=0, so
> all other cases except 0x07 put cpuid info from subleaf=0 to max subleaf.
> 
> What do you think about @index in current function? Does it mean, we
> need put cpuid from index to max subleaf to @entry[i]? If so, the logic
> seems as follows,
> 
> if (index == 0) {
>      // Put subleaf 0 into @entry
>      // Put subleaf 1 into @entry[1]
> } else if (index < entry->eax) {
>      // Put subleaf 1 into @entry
> } else {
>      // Put all zero into @entry
> }
> 
> But this seems not identical with other cases, for current caller
> function. Or we can simply ignore @index in 0x07 and just put all possible
> subleaf info back?
> 
>> and define F(AVX512_BF16) as a new constant kvm_cpuid_7_1_eax_features.
>>
> Got it.
> 
> 
> Thanks,
> Jing
> 
>> Paolo
>>
