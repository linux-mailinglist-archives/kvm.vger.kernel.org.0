Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8945605823
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 09:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiJTHON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 03:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiJTHNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 03:13:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AAB166568;
        Thu, 20 Oct 2022 00:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666250009; x=1697786009;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HDrEXu7wVjtTP7tzYkQO84zEVlSp2zzAHN32ISzcsZ8=;
  b=PoOol96qdV3geEYRy/8pnUACaJHVqfaPdWkEA/bzsRfLIEx4BVcPFDSy
   1nEGXmtDuSoaYh0YNwOG5/cf/7YosfgmjMqh0a078A6IJIwYD2qoUUAIX
   /35gVr1c954QtoTYJkAHK1gptdMWcN5MxGe3ebdDT1mXs06rKv+Q5m+Qf
   HuqNWWcXmuvNaEohdIjo9kJqvhzeISzzzd5ORm+E5X0D96phT5r7asQif
   AdGkjC+EwMLfbrH5M8eht/o6+QBdTIjXzNtmsGyb1yVqAExPaa+uyJzSl
   qyWpS7YmadZOTztvIH8DAp9IwbKkvV2kDZw9bj4eQ/MSe45PnE6Stw+Ts
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="294024256"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="294024256"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 00:13:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="804702698"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="804702698"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 00:13:16 -0700
Message-ID: <83572272-a54a-29c8-ce69-fdcc7497b77a@linux.intel.com>
Date:   Thu, 20 Oct 2022 15:13:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 4/6] x86: KVM: Enable AVX-VNNI-INT8 CPUID and expose it to
 guest
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-5-jiaxi.chen@linux.intel.com>
 <Y0+6tJ7MiZWbYK5l@zn.tnic>
From:   "Chen, Jiaxi" <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y0+6tJ7MiZWbYK5l@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2022/10/19 16:52, Borislav Petkov 写道:
> On Wed, Oct 19, 2022 at 04:47:32PM +0800, Jiaxi Chen wrote:
>> AVX-VNNI-INT8 is a new set of instructions in the latest Intel platform
>> Sierra Forest. It multiplies the individual bytes of two unsigned or
>> unsigned source operands, then add and accumulate the results into the
>> destination dword element size operand. This instruction allows for the
>> platform to have superior AI capabilities.
>>
>> The bit definition:
>> CPUID.(EAX=7,ECX=1):EDX[bit 4]
>>
>> This patch enables this CPUID in the kernel feature bits and expose it to
>> guest OS. Since the CPUID involves a bit of EDX (EAX=7,ECX=1) which has not
>> been enumerated yet, this patch adds CPUID_7_1_EDX to CPUID subleaves. At
>> the same time, word 20 is newly-defined in CPU features for CPUID level
> 
> For all your commit messages:
> 
> Avoid having "This patch" or "This commit" in the commit message. It is
> tautologically useless.

Will follow this in the future. Thanks.
> 
> Also, do
> 
> $ git grep 'This patch' Documentation/process
> 
> for more details.
> 
> For this particular one, use scattered.c instead of adding a new leaf.
> 
> Thx.
> 
