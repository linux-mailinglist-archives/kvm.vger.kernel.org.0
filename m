Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAE9176040
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgCBQqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:46:13 -0500
Received: from david.siemens.de ([192.35.17.14]:44372 "EHLO david.siemens.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbgCBQqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 11:46:12 -0500
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by david.siemens.de (8.15.2/8.15.2) with ESMTPS id 022Gk2qU006373
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 17:46:03 +0100
Received: from [139.25.68.37] ([139.25.68.37])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id 022Gk2WN000570;
        Mon, 2 Mar 2020 17:46:02 +0100
Subject: Re: [PATCH] kvm: x86: Make traced and returned value of kvm_cpuid
 consistent again
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>
References: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
 <688edd4d-81ad-bb6b-f166-4fb26a90bb9e@redhat.com>
 <20200302163834.GA6244@linux.intel.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <27b0a092-dae4-157b-7c56-7a757a680217@siemens.com>
Date:   Mon, 2 Mar 2020 17:46:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302163834.GA6244@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.03.20 17:38, Sean Christopherson wrote:
> On Mon, Mar 02, 2020 at 05:11:57PM +0100, Paolo Bonzini wrote:
>> Queued, thanks.
> 
> Too fast, too fast!
> 
> On Sun, Mar 01, 2020 at 11:47:20AM +0100, Jan Kiszka wrote:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> After 43561123ab37, found is not set correctly in case of leaves 0BH,
>> 1FH, or anything out-of-range.
> 
> No, found is set correctly, kvm_cpuid() should return true if and only if
> an exact match for the requested function is found, and that's the original
> tracing behavior of "found" (pre-43561123ab37).
> 
>> This is currently harmless for the return value because the only caller
>> evaluating it passes leaf 0x80000008.
> 
> No, it's 100% correct.  Well, technically it's irrelevant because the only
> caller, check_cr_write(), passes %false for check_limit, i.e. found will be
> true if and only if entry 0x80000008 exists.  But, in a purely hypothetical
> scenario where the emulator passed check_limit=%true, the intent of "found"
> is to report that the exact leaf was found, not if some random entry was
> found.

Nicely non-intuitive semantics. Should definitely be documented.

And then it's questionable to me what value tracing such a return code 
has. At the bare minimum, "found" should be renamed to something like 
"exact_match".

> 
>> However, the trace entry is now misleading due to this inaccuracy. It is
>> furthermore misleading because it reports the effective function, not
>> the originally passed one. Fix that as well.
>>
>> Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index b1c469446b07..79a738f313f8 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1000,13 +1000,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
>>   bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>>               u32 *ecx, u32 *edx, bool check_limit)
>>   {
>> -     u32 function = *eax, index = *ecx;
>> +     u32 orig_function = *eax, function = *eax, index = *ecx;
>>        struct kvm_cpuid_entry2 *entry;
>>        struct kvm_cpuid_entry2 *max;
> 
> Rather than add another variable, this can be cleaned up to remove "max".
> cpuid_function_in_range() also has a bug.  I've got patches, in the process
> of whipping up a unit test.
> 

Fine with me.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
