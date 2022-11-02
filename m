Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8769B616C02
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiKBSWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiKBSWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:22:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B6D2F3AD;
        Wed,  2 Nov 2022 11:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667413320; x=1698949320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z9l8jwKdDf6PvBLsMZ21P6AwjLuvcYcBe3LWv5VFQhg=;
  b=HtGtxjXLa/5iU2w054stw/sGDNo9wgZtIhZX5h7GrOF7qjcUnpvkCz7s
   q6hCFq9l879/McYCE7aWfXrhwdYfpA26NgRsqieH/85/v1GzrMyRW62F+
   mI4TB7pZRKf+c+v7LmnQGi4KssyM+zGVLFVUGBQt7fZN471GIe64bh2/f
   f0XAaN+Z1lFRxL9G/mHB+czCagoI27stzqMt9iziIjoIFOkwyWfv1fAPn
   BF6Kl6MEWjqkmukLji4Pd1SN0a96EjSxIq5nVV0WgpDrNjX65V/ZxFX8z
   nE1rUv0RShcP2yOOGWRssl9/jGz0IO4vT+1lEvw2PZ2fbpGHap6kKLy6O
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="395797744"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="395797744"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 11:22:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="723659074"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="723659074"
Received: from malhotra-mobl.amr.corp.intel.com (HELO [10.212.194.120]) ([10.212.194.120])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 11:21:58 -0700
Message-ID: <c00a4715-94f7-2d4a-02b3-533bb309c130@intel.com>
Date:   Wed, 2 Nov 2022 11:21:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/6] x86: KVM: Enable AMX-FP16 CPUID and expose it to
 guest
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-3-jiaxi.chen@linux.intel.com>
 <639c22a1-b0b0-9fb0-2a9a-060c53f9f540@intel.com>
 <aa7f6efc-de4c-c5f6-fb5f-ef514e4513a3@redhat.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <aa7f6efc-de4c-c5f6-fb5f-ef514e4513a3@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/22 11:16, Paolo Bonzini wrote:
> On 11/2/22 19:14, Dave Hansen wrote:
>>>         kvm_cpu_cap_mask(CPUID_7_1_EAX,
>>> -        F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD)
>>> +        F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
>>>       );
>>>         kvm_cpu_cap_mask(CPUID_D_1_EAX,
>>
>> KVM folks, is the idea that every feature that is enumerated to a guest
>> needs to be in one of these masks?  Or is there something special about
>> the features in these masks?
> 
> Yes, all features are vetted manually to see whether they require new
> MSRs and the like.  Therefore, anything that userspace can set in the
> guest's CPUID must be in the list.

Makes sense.

Intel folks, when you add these bits, can you please include information
about the "vetting" that you performed?

For example, it would be handy to say:

	AMX_FP16 is just a new instruction that operates on existing AMX
	tile registers.  It needs no additional enabling on top of the
	existing kernel AMX enabling.
