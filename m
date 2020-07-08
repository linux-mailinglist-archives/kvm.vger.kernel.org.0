Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4521828F
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 10:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgGHIdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 04:33:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:64457 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgGHIdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 04:33:36 -0400
IronPort-SDR: HoY8vpWQECYOnt/SCqoVPXz22h3k+dpGOFYWviLFrNBUu21c7N+l0uf/JJwiVoEXSOkn7hYwxu
 HpyZwHkBR4YA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="135992104"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="135992104"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 01:33:36 -0700
IronPort-SDR: ww1u6wUho2hrOo6VESFNIqGEjfdxdnumbHu5dNDSFnWsXuxUo/0pTRhBQptcoeRCucYwCiF5R6
 5hcOiswz5ycA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="358040221"
Received: from zhangj4-mobl1.ccr.corp.intel.com (HELO [10.249.171.75]) ([10.249.171.75])
  by orsmga001.jf.intel.com with ESMTP; 08 Jul 2020 01:33:30 -0700
Subject: Re: [PATCH v2 2/4] x86/cpufeatures: Enumerate TSX suspend load
 address tracking instructions
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ricardo.neri-calderon@linux.intel.com,
        kyung.min.park@intel.com, jpoimboe@redhat.com, ak@linux.intel.com,
        dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
 <1594088183-7187-3-git-send-email-cathy.zhang@intel.com>
 <20200707094019.GA2639362@kroah.com>
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
Message-ID: <78a3edfe-0a6b-4b23-f41d-cebe7dce67cf@intel.com>
Date:   Wed, 8 Jul 2020 16:33:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707094019.GA2639362@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/2020 5:40 PM, Greg KH wrote:
> On Tue, Jul 07, 2020 at 10:16:21AM +0800, Cathy Zhang wrote:
>> Intel TSX suspend load tracking instructions aim to give a way to
>> choose which memory accesses do not need to be tracked in the TSX
>> read set. Add TSX suspend load tracking CPUID feature flag TSXLDTRK
>> for enumeration.
>>
>> A processor supports Intel TSX suspend load address tracking if
>> CPUID.0x07.0x0:EDX[16] is present. Two instructions XSUSLDTRK, XRESLDTRK
>> are available when this feature is present.
>>
>> The CPU feature flag is shown as "tsxldtrk" in /proc/cpuinfo.
>>
>> Detailed information on the instructions and CPUID feature flag TSXLDTRK
>> can be found in the latest Intel Architecture Instruction Set Extensions
>> and Future Features Programming Reference and Intel 64 and IA-32
>> Architectures Software Developer's Manual.
>>
>> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
>> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
>> ---
>>   arch/x86/include/asm/cpufeatures.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index adf45cf..34b66d7 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -366,6 +366,7 @@
>>   #define X86_FEATURE_MD_CLEAR		(18*32+10) /* VERW clears CPU buffers */
>>   #define X86_FEATURE_TSX_FORCE_ABORT	(18*32+13) /* "" TSX_FORCE_ABORT */
>>   #define X86_FEATURE_SERIALIZE		(18*32+14) /* SERIALIZE instruction */
>> +#define X86_FEATURE_TSX_LDTRK           (18*32+16) /* TSX Suspend Load Address Tracking */
> No tabs?
>
> :(
Sorry, it's my fault. I wrongly pick up an older kernel patch version, 
the latest one has no such issue. It will be addressed in next version.
