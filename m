Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03D060EDF0
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 04:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiJ0C2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 22:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiJ0C15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 22:27:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B580143A45;
        Wed, 26 Oct 2022 19:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666837673; x=1698373673;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=afo/CE2nmd8ntlb2SDjykBmeyxC2sXyG6CNK+1/fCLE=;
  b=kJ72yHXZBaQRPrBgukF2N3RPqQCkV4Pkq7QdsSMTfs2+d8lFtHR4UiUd
   MpJv95vc/mzrZ9wd5RprxWDOKeHcDEAX7R0l7cx+wqABOomI2u/9uZh1r
   FJtfBTGIlLBOe5l5dBs3ncRzDkEPkgxpRdd7M4RxHQzhDfXsSITd2dulK
   26zYF1Mnbvm0XHRgFhpNJLzoyibtnGNiwq1aQ1lkljCH/KJqDWh66qZUK
   heFExs+sWpYVpfFlXQB5rs7mPoU3cZUdO3Ap2EiGmFs1eotWCmyKCIgMZ
   VGukCoc8nUXmo3Xtyu75JgFPULv2dufeyGy2Gzj81gsmLpwXU3hafqm4G
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="287828482"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="287828482"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 19:27:53 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="634732714"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="634732714"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 19:27:48 -0700
Message-ID: <4b50da57-f4ec-7bd7-b062-b495612868b4@linux.intel.com>
Date:   Thu, 27 Oct 2022 10:27:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH 1/6] x86: KVM: Enable CMPccXADD CPUID and expose it to
 guest
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-2-jiaxi.chen@linux.intel.com>
 <Y1AUhlwWjIkKfZHA@google.com>
 <cce514da-32b4-3b84-cfad-67a05705bc9f@linux.intel.com>
 <Y1lrGgyIcgweVGup@zn.tnic>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y1lrGgyIcgweVGup@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/2022 1:15 AM, Borislav Petkov wrote:
> On Wed, Oct 26, 2022 at 11:40:31AM +0800, Jiaxi Chen wrote:
>>> What do you think about moving CPUID_7_1_EAX to be a KVM-only leaf too?  AFAICT,
>>> KVM passthrough is the only reason the existing features are defined.
> 
> Yap, looking at the patches which added those 2 feature flags upstream,
> they don't look like some particular use was the goal but rather to
> expose it to guests. Besides, AVX512 apps do their own CPUID detection.
> 
>> Since CPUID_7_1_EAX has only 5 features now, it is a big waste,       
>> should we move it to KVM-only leaf as Sean suggested. What's your     
>> opinion about this?                                                   
> 
> Yes, pls do.
> 
> And when you do, make sure to undo what
> 
>   b302e4b176d0 ("x86/cpufeatures: Enumerate the new AVX512 BFLOAT16 instructions")
> 
> added.
> 
> Thx.
> 

Yes, will do this in v2. Thanks for reminding~
-- 
Regards,
Jiaxi
