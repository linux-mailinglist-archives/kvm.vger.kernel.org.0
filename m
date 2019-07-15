Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8568253
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 04:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfGOCqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jul 2019 22:46:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:8339 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfGOCqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Jul 2019 22:46:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jul 2019 19:46:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,492,1557212400"; 
   d="scan'208";a="160960032"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.128.226]) ([10.238.128.226])
  by orsmga008.jf.intel.com with ESMTP; 14 Jul 2019 19:46:33 -0700
Subject: Re: [PATCH v1] KVM: x86: expose AVX512_BF16 feature to guest
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <1562824197-13658-1-git-send-email-jing2.liu@linux.intel.com>
 <305e2a40-93a3-23ed-71a2-d3f2541e837a@redhat.com>
From:   Jing Liu <jing2.liu@linux.intel.com>
Message-ID: <9a9226bb-8050-e650-a8e5-0030cdd6862d@linux.intel.com>
Date:   Mon, 15 Jul 2019 10:46:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <305e2a40-93a3-23ed-71a2-d3f2541e837a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,
Thanks for your reviewing! There also has Qemu patch sent here,
https://www.mail-archive.com/qemu-devel@nongnu.org/msg630359.html

Could you please review that? Thanks very much!

Jing


On 7/13/2019 6:37 PM, Paolo Bonzini wrote:
> On 11/07/19 07:49, Jing Liu wrote:
>> AVX512 BFLOAT16 instructions support 16-bit BFLOAT16 floating-point
>> format (BF16) for deep learning optimization.
>>
>> Intel adds AVX512 BFLOAT16 feature in CooperLake, which is CPUID.7.1.EAX[5].
>>
>> Detailed information of the CPUID bit can be found here,
>> https://software.intel.com/sites/default/files/managed/c5/15/\
>> architecture-instruction-set-extensions-programming-reference.pdf.
>>
>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>> ---
>>
>> This patch depends on kernel patch https://lkml.org/lkml/2019/6/19/912
>> and Paolo's patch set https://lkml.org/lkml/2019/7/4/468.
>>
>>   arch/x86/kvm/cpuid.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 8fc6039..0c125dd 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -358,9 +358,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>>   		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>>   		F(MD_CLEAR);
>>   
>> +	/* cpuid 7.1.eax */
>> +	const u32 kvm_cpuid_7_1_eax_x86_features =
>> +		F(AVX512_BF16);
>> +
>>   	switch (index) {
>>   	case 0:
>> -		entry->eax = 0;
>> +		entry->eax = min(entry->eax, 1);
>>   		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
>>   		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
>>   		/* TSC_ADJUST is emulated */
>> @@ -384,6 +388,12 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>>   		 */
>>   		entry->edx |= F(ARCH_CAPABILITIES);
>>   		break;
>> +	case 1:
>> +		entry->eax &= kvm_cpuid_7_1_eax_x86_features;
>> +		entry->ebx = 0;
>> +		entry->ecx = 0;
>> +		entry->edx = 0;
>> +		break;
>>   	default:
>>   		WARN_ON_ONCE(1);
>>   		entry->eax = 0;
>>
> 
> Queued, thanks.
> 
> Paolo
> 
