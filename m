Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC8F4E202D
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 06:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344417AbiCUFjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 01:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbiCUFjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 01:39:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31F0140754
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 22:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647841064; x=1679377064;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GYSqGCaVhZ+z/tBBw/krL6zxCL+qnMdvWRk0OPnpUco=;
  b=geFebT3+J/CGTt/zTzR12U21IqbvCF+T6rFCEZqfEhJtjYkaR27cr/Fh
   VP9QpK1srgmtthqUvaAe16l/6DQXsQdrsUGg5MJmgO0vjdLy4adN+WxLG
   1yiM+tXTrooU5JgUMajpF+WM/5+b9b0i6t70uEhNjI5kqHgbpbA9z+yCq
   QVhpDATrf7l3jCxtpwJkv0RkYNcFAqg/gWu8zPsjvTTopHUIV3p2uWiJt
   Z7OC7s7M8MyTlKGcUXT3eG8Qez+k9rRx9N4FTbBJ9jmeStuOt3WGPGy4b
   Z6sj1PRNymsagMQfhb1hwbTE4R1HiVEkcT3yUDG1yqlyBzFHV8htEegQ1
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="237416071"
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="237416071"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 22:37:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="559709308"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.245]) ([10.249.169.245])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 22:37:05 -0700
Message-ID: <7c92b415-8357-b35d-ac46-299d55989a62@intel.com>
Date:   Mon, 21 Mar 2022 13:37:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 08/36] i386/tdx: Adjust get_supported_cpuid() for
 TDX VM
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-9-xiaoyao.li@intel.com>
 <20220318165529.GA4049379@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220318165529.GA4049379@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/2022 12:55 AM, Isaku Yamahata wrote:
> On Thu, Mar 17, 2022 at 09:58:45PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
...
>> +void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
>> +                             uint32_t *ret)
>> +{
>> +    switch (function) {
>> +    case 1:
>> +        if (reg == R_ECX) {
>> +            *ret &= ~CPUID_EXT_VMX;
>> +        }
>> +        break;
>> +    case 0xd:
>> +        if (index == 0) {
>> +            if (reg == R_EAX) {
>> +                *ret &= (uint32_t)tdx_caps->xfam_fixed0 & XCR0_MASK;
>> +                *ret |= (uint32_t)tdx_caps->xfam_fixed1 & XCR0_MASK;
>> +            } else if (reg == R_EDX) {
>> +                *ret &= (tdx_caps->xfam_fixed0 & XCR0_MASK) >> 32;
>> +                *ret |= (tdx_caps->xfam_fixed1 & XCR0_MASK) >> 32;
>> +            }
>> +        } else if (index == 1) {
>> +            /* TODO: Adjust XSS when it's supported. */
>> +        }
>> +        break;
>> +    case KVM_CPUID_FEATURES:
>> +        if (reg == R_EAX) {
>> +            *ret &= ~((1ULL << KVM_FEATURE_CLOCKSOURCE) |
>> +                      (1ULL << KVM_FEATURE_CLOCKSOURCE2) |
>> +                      (1ULL << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
>> +                      (1ULL << KVM_FEATURE_ASYNC_PF) |
>> +                      (1ULL << KVM_FEATURE_ASYNC_PF_VMEXIT) |
>> +                      (1ULL << KVM_FEATURE_ASYNC_PF_INT));
> 
> Because new feature bit may be introduced in future (it's unlikely though),
> *ret &= (supported_bits) is better than *ret &= ~(unsupported_bits)
> 

Good point, I will introduce supported_kvm_features for it.

