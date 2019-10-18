Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8490EDBB2C
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 03:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441895AbfJRBBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 21:01:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:34670 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441878AbfJRBBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 21:01:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 18:00:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,309,1566889200"; 
   d="scan'208";a="347933114"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.130]) ([10.239.196.130])
  by orsmga004.jf.intel.com with ESMTP; 17 Oct 2019 18:00:09 -0700
Subject: Re: [PATCH RESEND v6 1/2] x86/cpu: Add support for
 UMONITOR/UMWAIT/TPAUSE
From:   Tao Xu <tao3.xu@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Jingqi" <jingqi.liu@intel.com>
References: <20191011074103.30393-1-tao3.xu@intel.com>
 <20191011074103.30393-2-tao3.xu@intel.com>
 <1731d87f-f07a-916f-90a7-346b593d821e@intel.com>
Message-ID: <60857ac6-ec04-2197-235c-d20600001a02@intel.com>
Date:   Fri, 18 Oct 2019 09:00:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1731d87f-f07a-916f-90a7-346b593d821e@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,
Ping :)
On 10/11/2019 3:49 PM, Tao Xu wrote:
> On 10/11/2019 3:41 PM, Xu, Tao3 wrote:
> [...]
>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>> index 11b9c854b5..a465c893b5 100644
>> --- a/target/i386/kvm.c
>> +++ b/target/i386/kvm.c
>> @@ -401,6 +401,12 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState 
>> *s, uint32_t function,
>>           if (host_tsx_blacklisted()) {
>>               ret &= ~(CPUID_7_0_EBX_RTM | CPUID_7_0_EBX_HLE);
>>           }
>> +    } else if (function == 7 && index == 0 && reg == R_ECX) {
>> +        if (enable_cpu_pm) {
>> +            ret |= CPUID_7_0_ECX_WAITPKG;
>> +        } else {
>> +            ret &= ~CPUID_7_0_ECX_WAITPKG;
>> +        }
> 
> Hi Paolo,
> 
> I am sorry because I realize in KVM side, I keep cpuid mask WAITPKG as 0:
> 
> F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
> 
> Therefore in QEMU side, we need to add CPUID_7_0_ECX_WAITPKG when 
> enable_cpu_pm is on. Otherwise, QEMU can't get this CPUID.
> 
> Could you review this part again? Thank you very much!
> 
> Tao

