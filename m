Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B736934
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 03:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfFFBag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 21:30:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:62019 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfFFBag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 21:30:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 18:30:34 -0700
X-ExtLoop1: 1
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.163]) ([10.239.196.163])
  by orsmga004.jf.intel.com with ESMTP; 05 Jun 2019 18:30:33 -0700
Subject: Re: [PATCH v2 1/2] x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Jingqi" <jingqi.liu@intel.com>
References: <20190524081839.6228-1-tao3.xu@intel.com>
 <20190524081839.6228-2-tao3.xu@intel.com>
 <20190604163430.0375fe01.cohuck@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <b01f8565-1153-482d-ae03-12cf125ea2ad@intel.com>
Date:   Thu, 6 Jun 2019 09:30:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604163430.0375fe01.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/2019 10:34 PM, Cornelia Huck wrote:
> On Fri, 24 May 2019 16:18:38 +0800
> Tao Xu <tao3.xu@intel.com> wrote:
> 
>> UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
>> Availability of the user wait instructions is indicated by the presence
>> of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].
>>
>> The patch enable the umonitor, umwait and tpause features in KVM.
>> Because umwait and tpause can put a (psysical) CPU into a power saving
>> state, by default we dont't expose it in kvm and provide a capability to
>> enable it. Use kvm capability to enable UMONITOR, UMWAIT and TPAUSE when
>> QEMU use "-overcommit cpu-pm=on, a VM can use UMONITOR, UMWAIT and TPAUSE
>> instructions. If the instruction causes a delay, the amount of time
>> delayed is called here the physical delay. The physical delay is first
>> computed by determining the virtual delay (the time to delay relative to
>> the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT and TPAUSE cause
>> an invalid-opcode exception(#UD).
>>
>> The release document ref below link:
>> https://software.intel.com/sites/default/files/\
>> managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
>>
>> Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
>> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>> ---
>>   linux-headers/linux/kvm.h |  1 +
>>   target/i386/cpu.c         |  3 ++-
>>   target/i386/cpu.h         |  1 +
>>   target/i386/kvm.c         | 13 +++++++++++++
>>   4 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
>> index c8423e760c..86cc2dbdd0 100644
>> --- a/linux-headers/linux/kvm.h
>> +++ b/linux-headers/linux/kvm.h
>> @@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_ARM_SVE 170
>>   #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>>   #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
>> +#define KVM_CAP_ENABLE_USR_WAIT_PAUSE 173
>>   
>>   #ifdef KVM_CAP_IRQ_ROUTING
>>   
> 
> No comment on the actual change, but please split out any linux-header
> changes so they can be replaced with a proper headers update when the
> code is merged.
> 
Thank you for your review, I will update this patch when the kvm patch 
change a lot.
