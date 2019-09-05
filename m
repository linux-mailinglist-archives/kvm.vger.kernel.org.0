Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E426A97D8
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 03:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfIEBL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 21:11:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:56241 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbfIEBL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 21:11:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 18:11:57 -0700
X-IronPort-AV: E=Sophos;i="5.64,468,1559545200"; 
   d="scan'208";a="173767401"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 04 Sep 2019 18:11:55 -0700
Subject: Re: [PATCH v2] doc: kvm: Fix return description of KVM_SET_MSRS
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190904060118.43851-1-xiaoyao.li@intel.com>
 <20190904174122.GK24079@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <5e61463e-b389-4393-81f9-a154ee4688be@intel.com>
Date:   Thu, 5 Sep 2019 09:11:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904174122.GK24079@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/5/2019 1:41 AM, Sean Christopherson wrote:
> On Wed, Sep 04, 2019 at 02:01:18PM +0800, Xiaoyao Li wrote:
>> Userspace can use ioctl KVM_SET_MSRS to update a set of MSRs of guest.
>> This ioctl sets specified MSRs one by one. Once it fails to set an MSR
>> due to setting reserved bits, the MSR is not supported/emulated by kvm,
>> or violating other restrictions, it stops further processing and returns
>> the number of MSRs have been set successfully.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> v2:
>>    elaborate the changelog and description of ioctl KVM_SET_MSRS based on
>>    Sean's comments.
>>
>> ---
>>   Documentation/virt/kvm/api.txt | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
>> index 2d067767b617..4638e893dec0 100644
>> --- a/Documentation/virt/kvm/api.txt
>> +++ b/Documentation/virt/kvm/api.txt
>> @@ -586,7 +586,7 @@ Capability: basic
>>   Architectures: x86
>>   Type: vcpu ioctl
>>   Parameters: struct kvm_msrs (in)
>> -Returns: 0 on success, -1 on error
>> +Returns: number of msrs successfully set (see below), -1 on error
>>   
>>   Writes model-specific registers to the vcpu.  See KVM_GET_MSRS for the
>>   data structures.
>> @@ -595,6 +595,11 @@ Application code should set the 'nmsrs' member (which indicates the
>>   size of the entries array), and the 'index' and 'data' members of each
>>   array entry.
>>   
>> +It tries to set the MSRs in array entries[] one by one. Once failing to
> 
> Probably better to say 'If' as opposed to 'Once', don't want to imply that
> userspace is incompetent :)
> 
>> +set an MSR (due to setting reserved bits, the MSR is not supported/emulated
>> +by kvm, or violating other restrctions),
> 
> Make it clear the list is not exhaustive, e.g.:
> 
> It tries to set the MSRs in array entries[] one by one.  If setting an MSR
> fails, e.g. due to setting reserved bits, the MSR isn't supported/emulated by
> KVM, etc..., it stops processing the MSR list and returns the number of MSRs
> that have been set successfully.
>

Refine it as you commented and send out v3, thanks.

>> it stops setting following MSRs
>> +and returns the number of MSRs have been set successfully.
>> +
>>   
>>   4.20 KVM_SET_CPUID
>>   
>> -- 
>> 2.19.1
>>
