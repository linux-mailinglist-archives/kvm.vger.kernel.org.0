Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10E44F718E
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbiDGBd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242169AbiDGBcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:32:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8A5C90C2;
        Wed,  6 Apr 2022 18:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649294967; x=1680830967;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UbchNRyikrKBOoyFn1A/AwN0BKR9315IZ5srbQ9nAdg=;
  b=naylskMncjUM1peMN/JvhiQfHi3WaK0IhLMVIQs5KUkDEiAPKKwuZWnD
   NjjRvEo+xmRgBW9LVnsveysQWZ5/wDTu7KLeMFh6AFgQ/lh+pFuNkB6AD
   RiW5e9ie0AcNgTHY3Yy6TjsykThNicfo2eBMDkt5gwV9RtK5JWMIi7wyc
   szh7HCJPytk6ehkOhVPemO0uHz0KJUUkYAhCqZLVEYmgbLmE48OCTIzyE
   8VY1DwA06rep52VZqQ9w8tFMvh/udqJTarAvj4mDYaI0unSoVjIKl2kUV
   7lz/PSNoy6Z/MCTSYspARWxsOwRasXrFpDEJ9M1/V6kDMeqK4keWSvv3c
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="243335027"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="243335027"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:29:27 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="722750496"
Received: from zitianwa-mobl.ccr.corp.intel.com (HELO [10.255.28.125]) ([10.255.28.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:29:25 -0700
Message-ID: <a1052ec0-4ea6-d5db-a729-deec08712683@intel.com>
Date:   Thu, 7 Apr 2022 09:29:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
 <e392b53a-fbaa-4724-07f4-171424144f70@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <e392b53a-fbaa-4724-07f4-171424144f70@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/2022 8:58 PM, Paolo Bonzini wrote:
> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
>> +    td_params->attributes = init_vm->attributes;
>> +    if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
>> +        pr_warn("TD doesn't support perfmon. KVM needs to save/restore "
>> +            "host perf registers properly.\n");
>> +        return -EOPNOTSUPP;
>> +    }
> 
> Why does KVM have to hardcode this (and LBR/AMX below)?  Is the level of 
> hardware support available from tdx_caps, for example through the CPUID 
> configs (0xA for this one, 0xD for LBR and AMX)?

It's wrong code. PMU is allowed.

AMX and LBR are disallowed because and the time we wrote the codes they 
are not supported by KVM. Now AMX should be allowed, but (arch-)LBR 
should be still blocked until KVM merges arch-LBR support.

>> +    /* PT can be exposed to TD guest regardless of KVM's XSS support */
>> +    guest_supported_xss &= (supported_xss | XFEATURE_MASK_PT);
>> +    td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
>> +    if (td_params->xfam & TDX_TD_XFAM_LBR) {
>> +        pr_warn("TD doesn't support LBR. KVM needs to save/restore "
>> +            "IA32_LBR_DEPTH properly.\n");
>> +        return -EOPNOTSUPP;
>> +    }
>> +
>> +    if (td_params->xfam & TDX_TD_XFAM_AMX) {
>> +        pr_warn("TD doesn't support AMX. KVM needs to save/restore "
>> +            "IA32_XFD, IA32_XFD_ERR properly.\n");
>> +        return -EOPNOTSUPP;
>> +    }
> 
>>
>> +    if (init_vm->tsc_khz)
>> +        guest_tsc_khz = init_vm->tsc_khz;
>> +    else
>> +        guest_tsc_khz = max_tsc_khz;
> 
> You can just use kvm->arch.default_tsc_khz in the latest kvm/queue.

yes. will change it.

