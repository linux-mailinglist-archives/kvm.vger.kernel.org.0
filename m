Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF366F6475
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 07:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjEDFgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 01:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEDFgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 01:36:19 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035A11BEB;
        Wed,  3 May 2023 22:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683178578; x=1714714578;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OpD4WDKVyxmQ7ATyftsmtpyxguEvBj18au7Zgp4gCYY=;
  b=d984VwDJ6HtXMWWLolcPOnUrbxHKpVZ4JALn2qU8UeX1hLvK4eqK+3cE
   NwcQK4qdRJ65Chlrs1Lr+WeqabE5dm9Whp+Rey/7uFUMHfcuWjsVygdMB
   N6ClvBM0kPuYnOCm3VHOvGtMewH2jkZ47yKPSewX/zROf/hV0mQOapFZn
   1A/LBt1h6wnSB6e+UaKXXP/7dXCdE5C9Bgs3egI6ncvJ58ozgBrQMHAZA
   pk6zxU3xKs4Y88pESeE0Ac50uhS9NdFqZ5M0FpeY+crJ+gwAJh9WnVqpE
   HKEXspjmJ98NMSwpa6EghZbd8dp8W/DuamYYFsmfDMYaNALa8h53igm2g
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="333206922"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="333206922"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 22:36:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="786382868"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="786382868"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.1.46]) ([10.238.1.46])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 22:36:15 -0700
Message-ID: <a11560cd-d6ad-ddb9-24ce-b45cd879227d@linux.intel.com>
Date:   Thu, 4 May 2023 13:36:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 10/21] KVM:x86: Add #CP support in guest exception
 classification
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     rick.p.edgecombe@intel.com, seanjc@google.com, pbonzini@redhat.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-11-weijiang.yang@intel.com>
 <d923f839-7505-21fc-2976-673c9e698b6f@linux.intel.com>
 <7bf51510-ca6e-d4b2-31bf-405258fd08e7@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <7bf51510-ca6e-d4b2-31bf-405258fd08e7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/4/2023 11:41 AM, Yang, Weijiang wrote:
>
> On 4/28/2023 2:09 PM, Binbin Wu wrote:
>>
>>
>> On 4/21/2023 9:46 PM, Yang Weijiang wrote:
>>> Add handling for Control Protection (#CP) exceptions(vector 21).
>>> The new vector is introduced for Intel's Control-Flow Enforcement
>>> Technology (CET) relevant violation cases.
>>> See Intel's SDM for details.
>>>
> [...]
>>>   -static int exception_class(int vector)
>>> +static int exception_class(struct kvm_vcpu *vcpu, int vector)
>>>   {
>>>       switch (vector) {
>>>       case PF_VECTOR:
>>>           return EXCPT_PF;
>>> +    case CP_VECTOR:
>>> +        if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
>>> +            return EXCPT_BENIGN;
>>> +        return EXCPT_CONTRIBUTORY;
>> By definition, #CP is Contributory.
>> Can you explain more about this change here which treats #CP as 
>> EXCPT_BENIGN when CET is not enabled in guest?
>
> I check the history of this patch, found maintainer modified the patch 
> due to some unit test issue in L1. You can check the
>
> details here:
>
> Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception 
> dispatch - Sean Christopherson (kernel.org) 
> <https://lore.kernel.org/all/YBsZwvwhshw+s7yQ@google.com/>
>
OK, is it better to add the reason in changelog?

IIUC, a new contributory exception vector (if any) should be handled 
similarly (i.e., treated as contributory conditionally) in the future, 
right?


>
>>
>> In current KVM code, there is suppose no #CP triggered in guest if 
>> CET is not enalbed in guest, right?
>
> Yes.
>
>>>       case DE_VECTOR:
>>>       case TS_VECTOR:
>>>       case NP_VECTOR:
>
>
> [...]
>

