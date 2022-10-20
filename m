Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A2C605881
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 09:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJTH2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 03:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiJTH2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 03:28:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AECD1633B2;
        Thu, 20 Oct 2022 00:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666250885; x=1697786885;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QewixQfgm3HBp8Zzn7LLgL+CKWo5zXT8KcWLvc3D8hM=;
  b=iYLJgaFAIWs8b9ZNOdgq2gI6gup7OuQC4iGUrN1xZyM9Nq46BtmJST0n
   FvCv4y8GnIY0Dn286RSRscN1vVDscNf301WwCEpZgNqJimpLefDLmRYaT
   Rrjks3iBG/nYRlRR2F2KrGIZrG6wKJ8m2c+xbZ9dpKJ2gnd+JFUMGoi51
   zUKT12NVol8hdYI4OawgM5aehWLiGvVC/xgXMIPISKK633yZhs7aWJ+JO
   h6kxBeuWd9k+4HvifCTYRtt2MfvFBIB4FVTEHl/jidb6Uf2jTGsc3cUUc
   c1Ww8LY1SstR+0VIx5euKOajrnSqiVf1ayvsSfF3GC/BzIC2X5WMfuTDO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286351772"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="286351772"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 00:28:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="629655174"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="629655174"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 00:27:58 -0700
Message-ID: <cd225cb6-9b74-4dca-bb35-6bde5e80701e@linux.intel.com>
Date:   Thu, 20 Oct 2022 15:27:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 1/6] x86: KVM: Enable CMPccXADD CPUID and expose it to
 guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-2-jiaxi.chen@linux.intel.com>
 <Y1AUhlwWjIkKfZHA@google.com>
From:   "Chen, Jiaxi" <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y1AUhlwWjIkKfZHA@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2022/10/19 23:15, Sean Christopherson 写道:
> For all the shortlogs, "expose it to guest" is technically wrong.  Adding
> recognition in kvm/cpuid.c advertises KVM support to host userspace.  Whether or
> not a feature is exposed to the guest is up to the userspace VMM.

Thanks for reminding. How about to change the subject to this:
x86: KVM: Advertise CMPccXADD CPUID to userspace
> 
> On Wed, Oct 19, 2022, Jiaxi Chen wrote:
>> CMPccXADD is a new set of instructions in the latest Intel platform Sierra
>> Forest. It includes a semaphore operation that can compare and add the
> 
> In general, avoid pronouns in changelogs, it's not clear what "it" refers to here.
> 
Will change it to: 'This new instruction set' here and avoid use pronouns in
the future commit message.

> And for all of these changelogs, please explicitly state that there are no VMX
> controls for these instructions, assuming that's actually true.  From a KVM
> perspective, that's far more interesting than the details of the instruction(s).
> 
Yes, thanks for comments. Will change this patch series to: 
This instruction has no other VMX control except for exposed to userspace.

>> operands if condition is met, which can improve database performance.
>>
>> The bit definition:
>> CPUID.(EAX=7,ECX=1):EAX[bit 7]
>>
>> This patch enables this CPUID in the kernel feature bits and expose it to
>> guest OS.
> 
> Same thing here, KVM doesn't decide whether or not to expose the feature to the
> guest.
> 
Applied.Thanks.
>> Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  arch/x86/kvm/cpuid.c               | 2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index ef4775c6db01..445626cb5779 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -308,6 +308,7 @@
>>  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>>  #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
>>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
>> +#define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
> 
> Boris,
> 
> What do you think about moving CPUID_7_1_EAX to be a KVM-only leaf too?  AFAICT,
> KVM passthrough is the only reason the existing features are defined.
