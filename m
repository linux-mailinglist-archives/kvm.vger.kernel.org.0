Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D247453B9
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 04:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjGCCDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 22:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjGCCDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 22:03:24 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436971B5
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 19:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688349803; x=1719885803;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=fBvyhvmtXOZ4Tqf7BaX5W0+CCj+IK/xjZXI+1zrI2YA=;
  b=FbzFUPv0eM7YUTsxNW8D2YAVHk4DHmXkTUoQdIOiCMvY0ef0SHYa2gIU
   8NTmce9bYh1aITJFKeWDYMJcVwWlgvghE9qncFiIV0iX1VccU+MvswFjF
   Gkjz8l5kIYE8Uo66sROb98XjxQlnTnxHeKj6QTMR0fawm5Ml/7MtSWThP
   b0lzTojB4D3jRZto4HYFcjCeioUwMrP0anSSGqIqbU9D2FmzG2QCXVR6p
   iXrEGdln+XXNxdviWtFjgOsv2PfhdBzwm3CVTTBW9TxMNS6SS/42RV+0e
   h64h1QnStKS7ih6ggOSdgybUYjy4+S92+/zayj/ddsGB5YnbPv9xdA/7U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="428811951"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="428811951"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2023 19:03:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="831629111"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="831629111"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.168.99]) ([10.249.168.99])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2023 19:03:08 -0700
Message-ID: <c953ab83-13f4-88a6-5dea-980707016119@intel.com>
Date:   Mon, 3 Jul 2023 10:03:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.12.0
Subject: Re: [PATCH v4 0/8] i386: Make Intel PT configurable
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
References: <20230531084311.3807277-1-xiaoyao.li@intel.com>
In-Reply-To: <20230531084311.3807277-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/2023 4:43 PM, Xiaoyao Li wrote:
> Initial virtualization of Intel PT was added by making it as fixed
> feature set of ICX's capabilities. However, it breaks the Intel PT exposure
> on SPR machine because SPR has less PT capabilities of
> CPUID(0x14,1):EBX[15:0].
> 
> This series aims to make Intel PT configurable that named CPU model can
> define its own PT feature set and "-cpu host/max" can use host pass-through
> feature set of Intel PT.
> 
> At the same time, it also ensures existing named CPU model to generate
> the same PT CPUID set as before to not break live migration.

ping for comments.

QEMU maintainers,

It has been nearly two years since the first version. It's very 
appreciated if any of you can express any thought on it. E.g., the basic 
question, whether this is an useful fix? or just a vain work?

> Changes in v4:
> - rebase to 51bdb0b57a2d "Merge tag 'pull-tcg-20230530' of https://gitlab.com/rth7680/qemu into staging"
> - cleanup Patch 6 by updating the commit message and remove unnecessary
>    handlng;
> 
> v3: https://lore.kernel.org/qemu-devel/20221208062513.2589476-1-xiaoyao.li@intel.com/
> - rebase to v7.2.0-rc4
> - Add bit 7 and 8 of FEAT_14_0_EBX in Patch 3
> 
> v2: https://lore.kernel.org/qemu-devel/20220808085834.3227541-1-xiaoyao.li@intel.com/
> Changes in v2:
> - split out 3 patches (per Eduardo's comment)
> - determine if the named cpu model uses default Intel PT capabilities (to
>    be compatible with the old behavior) by condition that all PT feature
>    leaves are all zero.
> 
> v1: https://lore.kernel.org/qemu-devel/20210909144150.1728418-1-xiaoyao.li@intel.com/
> 
> 
> Xiaoyao Li (8):
>    target/i386: Print CPUID subleaf info for unsupported feature
>    target/i386/intel-pt: Fix INTEL_PT_ADDR_RANGES_NUM_MASK
>    target/i386/intel-pt: Introduce FeatureWordInfo for Intel PT CPUID
>      leaf 0x14
>    target/i386/intel-pt: print special message for
>      INTEL_PT_ADDR_RANGES_NUM
>    target/i386/intel-pt: Rework/rename the default INTEL-PT feature set
>    target/i386/intel-pt: Enable host pass through of Intel PT
>    target/i386/intel-pt: Define specific PT feature set for
>      IceLake-server, Snowridge and SapphireRapids
>    target/i386/intel-pt: Access MSR_IA32_RTIT_ADDRn based on guest CPUID
>      configuration
> 
>   target/i386/cpu.c     | 293 +++++++++++++++++++++++++++++++-----------
>   target/i386/cpu.h     |  39 +++++-
>   target/i386/kvm/kvm.c |   8 +-
>   3 files changed, 261 insertions(+), 79 deletions(-)
> 

