Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F2164B4F9
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiLMMRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235572AbiLMMQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:16:32 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1943F6271
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670933715; x=1702469715;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tsxThtPRlNwB3axmd7mnhr1gEw5wKcTXGj/7Ul85Ke0=;
  b=QcoaGYQ3QRhp4jG2DKh0n+khxAYhcuWX/oGJN1WBYkR2JxDMMhbge9+d
   7DE+mwPf8qiXOjOI7uH4jKQpvWkQIZlXbhorHUlBJM25T0lA01/fLKWse
   UelkuNoNuH90M3jChIC9NUaYU0pm2n8UuWVI8TnMvILksTuRj6Dc7D1F5
   QTJvos+SdaGPpWGUBbOgOkveyf1IgcYNiv3DE495aUFcSmkPBRECAwmAg
   qrg7XfdyEwZP6Ybi19xVPAhoYC72RllIrBmheVSqMiHkJ2dZVDef7RBXe
   4DbO6R0jLsKHZln1b4PvBHLEqC3D58SqN8wZVY7NyY8Ne5qtacTW8smJ6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="319261714"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="319261714"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 04:15:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="642087091"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="642087091"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.20]) ([10.255.31.20])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 04:15:12 -0800
Message-ID: <514d47b2-ec42-8e8f-6215-7c0df611c2d1@intel.com>
Date:   Tue, 13 Dec 2022 20:15:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v3 6/8] target/i386/intel-pt: Enable host pass through of
 Intel PT
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
 <20221208062513.2589476-7-xiaoyao.li@intel.com>
 <79e68a2b-ba65-98bb-a175-68605303d2e5@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <79e68a2b-ba65-98bb-a175-68605303d2e5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/2022 2:55 PM, Chenyi Qiang wrote:
> 
> 
> On 12/8/2022 2:25 PM, Xiaoyao Li wrote:
>> commit e37a5c7fa459 ("i386: Add Intel Processor Trace feature support")
>> added the support of Intel PT by making CPUID[14] of PT as fixed feature
>> set (from ICX) for any CPU model on any host. This truly breaks the PT
>> exposure on Intel SPR platform because SPR has less supported bitmap of
>> CPUID(0x14,1):EBX[15:0] than ICX.
>>
>> To fix the problem, enable pass through of host's PT capabilities for
>> the cases "-cpu host/max" that it won't use default fixed PT feature set
>> of ICX but expand automatically based on get_supported_cpuid reported by
>> host. Meanwhile, it needs to ensure named CPU model still has the fixed
>> PT feature set to not break the live migration case of
>> "-cpu named_cpu_model,+intel-pt"
>>
>> Introduces env->use_default_intel_pt flag.
>>   - True means it's old CPU model that uses fixed PT feature set of ICX.
>>   - False means the named CPU model has its own PT feature set.
>>
>> Besides, to keep the same behavior for old CPU models that validate PT
>> feature set against default fixed PT feature set of ICX in addition to
>> validate from host's capabilities (via get_supported_cpuid) in
>> x86_cpu_filter_features().
>>
>> In the future, new named CPU model, e.g., Sapphire Rapids, can define
>> its own PT feature set by setting @has_specific_intel_pt_feature_set to
> 
> 
> It seems @has_specific_intel_pt_feature_set is not introduced in this
> series. Then don't need to mention the specific flag name here.

Thanks for catching it.

It's leftover of previous version. I'll update the commit log for next 
version.

>> true and defines it's own FEAT_14_0_EBX, FEAT_14_0_ECX, FEAT_14_1_EAX
>> and FEAT_14_1_EBX.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---

