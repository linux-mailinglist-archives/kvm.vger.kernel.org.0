Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4F563B6D2
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 02:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiK2BBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 20:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiK2BBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 20:01:31 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3F24046A
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 17:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669683687; x=1701219687;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SLu8CSOIMOS++31wKSyqjg7xQmzzt49jOP3ktnyJIaQ=;
  b=GTZKkXAcmnwMemkrC+y4/6aB07Fn/ny36HFfBtgvNI8zRwOFcpfqnUk/
   OLmhUVHvJQa4HO3z7x8GAwsLHyXoIjlnQ97vnkD4oGnoQcMA8r0n3lLZh
   tUd89/uwkwbd4KdxtwAiaERZ/UPe+4WSWVnHRfCB+A9DOx1bOOt9YwRtf
   5N9/XG3ZRBE5Pseb+BfdpGTOEm6CmWXyWZkpZ3P5MVG/8TCHoGROKmWzR
   Lwgl+ENI8aRIrYMrFtPU0BMei1kbGQ2bJ8OOWiQi62bQKJAk0cM7xpzK4
   3M3wY6GjUS4Iv/AuVRwRepVNkgdJFghQQza7+zECyEI0d6vnY8uaNAiXp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="401274187"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="401274187"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 17:01:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785849964"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="785849964"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.213]) ([10.254.211.213])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 17:01:25 -0800
Message-ID: <ec70a16b-f85f-8fca-1a0b-2cddc44014ab@intel.com>
Date:   Tue, 29 Nov 2022 09:01:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: selftest: Move XFD CPUID checking out of
 __vm_xsave_require_permission()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        yang.zhong@linux.intel.com
References: <20221125023839.315207-1-lei4.wang@intel.com>
 <Y4Tp9YO0vgsaJeyd@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <Y4Tp9YO0vgsaJeyd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/2022 1:03 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Wang, Lei wrote:
>> kvm_cpu_has(X86_FEATURE_XFD) will call kvm_get_supported_cpuid() which will
>> cache the cpuid information when it is firstly called. Move this line out
>> of __vm_xsave_require_permission() and check it afterwards so that the
>> CPUID change will not be veiled by the cached CPUID information.
> 
> Please call out exactly what CPUID change is being referred to.  Someone that
> doesn't already know about ARCH_REQ_XCOMP_GUEST_PERM and it's interaction with
> KVM_GET_SUPPORTED_CPUID will have zero clue what this fixes.
> 
> E.g.
> 
> Move the kvm_cpu_has() check on X86_FEATURE_XFD out of the helper to
> enable off-by-default XSAVE-managed features and into the one test that
> currenty requires XFD (XFeature Disable) support.   kvm_cpu_has() uses
> kvm_get_supported_cpuid() and thus caches KVM_GET_SUPPORTED_CPUID, and so
> using kvm_cpu_has() before ARCH_REQ_XCOMP_GUEST_PERM effectively results
> in the test caching stale values, e.g. subsequent checks on AMX_TILE will
> get false negatives.
> 
> Although off-by-default features are nonsensical without XFD, checking
> for XFD virtualization prior to enabling such features isn't strictly
> required.
> 
> Fixes: 7fbb653e01fd ("KVM: selftests: Check KVM's supported CPUID, not host CPUID, for XFD")

Makes sense.

>> Signed-off-by: Wang, Lei <lei4.wang@intel.com>
>> ---
>>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 --
>>  tools/testing/selftests/kvm/x86_64/amx_test.c      | 1 +
>>  2 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> index 39c4409ef56a..5686eacd4700 100644
>> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> @@ -616,8 +616,6 @@ void __vm_xsave_require_permission(int bit, const char *name)
>>  		.addr = (unsigned long) &bitmask
>>  	};
>>  
>> -	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
>> -
>>  	kvm_fd = open_kvm_dev_path_or_exit();
>>  	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
>>  	close(kvm_fd);
>> diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
>> index dadcbad10a1d..1e3457ff304b 100644
>> --- a/tools/testing/selftests/kvm/x86_64/amx_test.c
>> +++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
>> @@ -312,6 +312,7 @@ int main(int argc, char *argv[])
>>  	/* Create VM */
>>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>>  
>> +	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
> 
> I think we should disallow kvm_get_supported_cpuid() before
> __vm_xsave_require_permission(), otherwise we'll reintroduce a similar bug in the
> future.

Agree.

>>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
>>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_AMX_TILE));
>>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILECFG));
> 
> And then as a follow-up, we should move these above vm_create_with_one_vcpu(),
> checking them after vm_create_with_one_vcpu() is odd.
> 
> I'll send a v2 with the reworded changelog and additional patches to assert that
> __vm_xsave_require_permission() isn't used after kvm_get_supported_cpuid().

Already seen your patches, thanks Sean!
