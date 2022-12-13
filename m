Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6FC64B4D7
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbiLMMJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiLMMJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:09:40 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8304014D2B
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670933379; x=1702469379;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Dyv1R/6BTE9iFQ4ldpV49Tph9Ev3OBjeZLlpinLC6Yg=;
  b=Pk/K3xNU8LUCTOM/c+6wxxXblAozKyi4Zl/vETZTPBH3VDroXiDsAOqg
   C7nwka72hJR77RmlBpJgBRnQb9SKstZuBRgMbMr2v1KGQk9/9B7jOtg5N
   ihgyDy+aQzTtthYiIL8zmODuw2cnZNcrPovvHVb/GhTG1GklL0GmKt4A5
   AeMMGAS91pHh/k2lLVPfX8cyNrsNgV0NMQ5G/w/uU11s++hvfMs9UZtsk
   QFtCutxWVKlX8AkDGUJh+pfahCTdaekCLOFwEOxuougn1sohWoa7tnGB4
   XI6V3OweSKS99I79rA4E/mR59JeXRm2ggXRcMW6voq2vh94/0kGv5/uCE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="315752882"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="315752882"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 04:09:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="648537021"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="648537021"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.20]) ([10.255.31.20])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 04:09:35 -0800
Message-ID: <cc6304b1-fe60-565c-f561-541ec1c8b479@intel.com>
Date:   Tue, 13 Dec 2022 20:09:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v3 4/8] target/i386/intel-pt: print special message for
 INTEL_PT_ADDR_RANGES_NUM
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
 <20221208062513.2589476-5-xiaoyao.li@intel.com>
 <c920ff81-0231-b70f-5ede-b1085c583086@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <c920ff81-0231-b70f-5ede-b1085c583086@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/2022 2:43 PM, Chenyi Qiang wrote:
> 
> 
> On 12/8/2022 2:25 PM, Xiaoyao Li wrote:
>> Bit[2:0] of CPUID.14H_01H:EAX stands as a whole for the number of INTEL
>> PT ADDR RANGES. For unsupported value that exceeds what KVM reports,
>> report it as a whole in mark_unavailable_features() as well.
>>
> 
> Maybe this patch can be put before 3/8.

patch 3 introduces the logic to check bit 2:0 of CPUID leaf 14_1 as 
whole. So it's better to be after patch 3.

+            /* Bits 2:0 are as a whole to represent INTEL_PT_ADDR_RANGES */
+            if ((requested_features & INTEL_PT_ADDR_RANGES_NUM_MASK) >
+                (host_feat & INTEL_PT_ADDR_RANGES_NUM_MASK)) {
+                unavailable_features |= requested_features &
+                                        INTEL_PT_ADDR_RANGES_NUM_MASK;

>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/cpu.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 65c6f8ae771a..4d7beccc0af7 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -4387,7 +4387,14 @@ static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
>>           return;
>>       }
>>   
>> -    for (i = 0; i < 64; ++i) {
>> +    if ((w == FEAT_14_1_EAX) && (mask & INTEL_PT_ADDR_RANGES_NUM_MASK)) {
>> +        warn_report("%s: CPUID.14H_01H:EAX [bit 2:0]", verbose_prefix);
>> +        i = 3;
>> +    } else {
>> +        i = 0;
>> +    }
>> +
>> +    for (; i < 64; ++i) {
>>           if ((1ULL << i) & mask) {
>>               g_autofree char *feat_word_str = feature_word_description(f, i);
>>               warn_report("%s: %s%s%s [bit %d]",

