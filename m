Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03475A3E2
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 03:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjGTBZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 21:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjGTBZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 21:25:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DE82103
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 18:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689816322; x=1721352322;
  h=message-id:date:mime-version:subject:to:references:cc:
   from:in-reply-to:content-transfer-encoding;
  bh=qtyB5FWWgjJe+BstO6BqushuEHdhnWeesk3dJhk8/4g=;
  b=ibegDybYQdLOSJDFWy2RHhaUBN5FpwRfFxRzgl1i5zxt8o5zAq8I2ZGf
   B96OHzVkCnf/Bax+4wkzPqPrkk70ChuphlP0a8wS/2tOIla816BffgTcp
   mfj75KeHClaRBb12BTNEaJLiCGj0hMV5PNBy5nbuJDRSklFFDdLnw+iXk
   W2zKFO/V63C5u8eK1y2rYoayIN7FtSvDBKO68PoF2i8ddKM5/3YXEMSd4
   lM87Yiwx9v25sF6BEAn5XaOk+i0FBCfJIN5NEpv+sf+Gy7sC0eDRWM7cp
   jLH/XPgvNg+iwieCoaI2hVzwsQY8D+WDXLr9TgY62WvsXxUKbHpmPx6gZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346202248"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346202248"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 18:25:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="753892814"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="753892814"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 18:25:18 -0700
Message-ID: <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
Date:   Thu, 20 Jul 2023 09:25:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
Cc:     "Gao, Chao" <chao.gao@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/2023 2:08 AM, Jim Mattson wrote:
> Normally, we would restrict guest MSR writes based on guest CPU
> features. However, with IA32_SPEC_CTRL and IA32_PRED_CMD, this is not
> the case.
> 
> For the first non-zero write to IA32_SPEC_CTRL, we check to see that
> the host supports the value written. We don't care whether or not the
> guest supports the value written (as long as it supports the MSR).
> After the first non-zero write, we stop intercepting writes to
> IA32_SPEC_CTRL, so the guest can write any value supported by the
> hardware. This could be problematic in heterogeneous migration pools.
> For instance, a VM that starts on a Cascade Lake host may set
> IA32_SPEC_CTRL.PSFD[bit 7], even if the guest
> CPUID.(EAX=07H,ECX=02H):EDX.PSFD[bit 0] is clear. Then, if that VM is
> migrated to a Skylake host, KVM_SET_MSRS will refuse to set
> IA32_SPEC_CTRL to its current value, because Skylake doesn't support
> PSFD.
> 
> We disable write intercepts IA32_PRED_CMD as long as the guest
> supports the MSR. That's fine for now, since only one bit of PRED_CMD
> has been defined. Hence, guest support and host support are
> equivalent...today. But, are we really comfortable with letting the
> guest set any IA32_PRED_CMD bit that may be defined in the future?
 >
> The same question applies to IA32_SPEC_CTRL. Are we comfortable with
> letting the guest write to any bit that may be defined in the future?

My point is we need to fix it, though Chao has different point that 
sometimes performance may be more important[*]

[*] https://lore.kernel.org/all/ZGdE3jNS11wV+V2w@chao-email/

> At least the AMD approach with V_SPEC_CTRL prevents the guest from
> clearing any bits set by the host, but on Intel, it's a total
> free-for-all. What happens when a new bit is defined that absolutely
> must be set to 1 all of the time?

