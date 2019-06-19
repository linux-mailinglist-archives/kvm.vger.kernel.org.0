Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC5D4AF5D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 03:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbfFSBLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 21:11:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:8904 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbfFSBLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 21:11:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 18:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,391,1557212400"; 
   d="scan'208";a="170412612"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.224]) ([10.239.196.224])
  by orsmga002.jf.intel.com with ESMTP; 18 Jun 2019 18:11:49 -0700
Subject: Re: [PATCH v3 2/2] target/i386: Add support for save/load
 IA32_UMWAIT_CONTROL MSR
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>, pbonzini@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com
Cc:     cohuck@redhat.com, mst@redhat.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, jingqi.liu@intel.com
References: <20190616153525.27072-1-tao3.xu@intel.com>
 <20190616153525.27072-3-tao3.xu@intel.com>
 <94f9e831-38a0-3cc3-f566-6c8e5909d0fd@linux.intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <1bbe0308-6479-2a76-ba4e-f38203c975f7@intel.com>
Date:   Wed, 19 Jun 2019 09:11:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <94f9e831-38a0-3cc3-f566-6c8e5909d0fd@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/2019 11:39 AM, Xiaoyao Li wrote:
> 
> 
> On 6/16/2019 11:35 PM, Tao Xu wrote:
>> UMWAIT and TPAUSE instructions use IA32_UMWAIT_CONTROL at MSR index
>> E1H to determines the maximum time in TSC-quanta that the processor
>> can reside in either C0.1 or C0.2.
>>
>> This patch is to Add support for save/load IA32_UMWAIT_CONTROL MSR in
>> guest.
>>
>> Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
>> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>> ---
>>
>> no changes in v3:
>> ---
>>   target/i386/cpu.h     |  2 ++
>>   target/i386/kvm.c     | 13 +++++++++++++
>>   target/i386/machine.c | 20 ++++++++++++++++++++
>>   3 files changed, 35 insertions(+)
>>
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index 2f7c57a3c2..eb98b2e54a 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -450,6 +450,7 @@ typedef enum X86Seg {
>>   #define MSR_IA32_BNDCFGS                0x00000d90
>>   #define MSR_IA32_XSS                    0x00000da0
>> +#define MSR_IA32_UMWAIT_CONTROL         0xe1
>>   #define XSTATE_FP_BIT                   0
>>   #define XSTATE_SSE_BIT                  1
>> @@ -1348,6 +1349,7 @@ typedef struct CPUX86State {
>>       uint16_t fpregs_format_vmstate;
>>       uint64_t xss;
>> +    uint64_t umwait;
>>       TPRAccess tpr_access_type;
>>   } CPUX86State;
>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>> index 3efdb90f11..506c7cd038 100644
>> --- a/target/i386/kvm.c
>> +++ b/target/i386/kvm.c
>> @@ -91,6 +91,7 @@ static bool has_msr_hv_stimer;
>>   static bool has_msr_hv_frequencies;
>>   static bool has_msr_hv_reenlightenment;
>>   static bool has_msr_xss;
>> +static bool has_msr_umwait;
>>   static bool has_msr_spec_ctrl;
>>   static bool has_msr_virt_ssbd;
>>   static bool has_msr_smi_count;
>> @@ -1486,6 +1487,9 @@ static int kvm_get_supported_msrs(KVMState *s)
>>                   case MSR_IA32_XSS:
>>                       has_msr_xss = true;
>>                       break;
>> +                case MSR_IA32_UMWAIT_CONTROL:
>> +                    has_msr_umwait = true;
>> +                    break;
> 
> Need to add MSR_IA32_UMWAIT_CONTROL into msrs_to_save[] in your kvm 
> patches, otherwise qemu never goes into this case.
> 
OK, thank you for your suggestion. I will add it in the next version.

