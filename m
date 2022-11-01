Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1D3614645
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 10:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKAJHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 05:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKAJHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 05:07:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C464F18B09;
        Tue,  1 Nov 2022 02:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667293659; x=1698829659;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U5H8Zelx5ugEIaSXGsCTFGIW0cdkr61olry0Ir0BReA=;
  b=fbS4CF7ERZmX1OAwFmE38emj9+MEX3XynkaohQvtk0ot75VvsM8lXm9b
   B0ROdVqp0tUrOEpjHy3vcxEU1dohyE9S9GWCCkqYYOFR+xTGZevaCPDHC
   f+uKDuHX5JtVkgrAAL/KLd3oBan0qyQUIgF87BmQtfFwEyFRX71rD32bI
   ww5mQIcmBCXRjveBT08d8CJSzn+Q/SVOnSiz2N8H0sgYC6xfFxGpneip7
   o9lmD+XTwcR+Ap+mdXdLLJnxWH6V5f+W25RPpi2OuM4eFZgHZYhJNigbj
   1fsr7OOMax5bE8UIUKS7Nz32jo96lz8abJuV3ZQc+Gei6aREII9Eh6onS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="371179750"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="371179750"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 02:07:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="584951562"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="584951562"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 02:07:34 -0700
Message-ID: <ad24c33d-8f07-4d73-136f-ad16bb2b1981@linux.intel.com>
Date:   Tue, 1 Nov 2022 17:07:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH 1/6] x86: KVM: Enable CMPccXADD CPUID and expose it to
 guest
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-2-jiaxi.chen@linux.intel.com>
 <Y1AUhlwWjIkKfZHA@google.com>
 <cce514da-32b4-3b84-cfad-67a05705bc9f@linux.intel.com>
 <Y1lrGgyIcgweVGup@zn.tnic>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y1lrGgyIcgweVGup@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
Hi Sean and Boris,

Just realized moving CPUID_7_1_EAX to kvm-only leaf will not save space
in enum cpuid_leafs[]. CPUID_7_1_EAX is indeed removed, but someone
else, ie. CPUID_DUMMY needs to take the place, otherwise the cpuid_leafs
array would be deranged. Therefore, the length of x86 cpuid leaves is
not decreased.

Wonder if the intention of moving this leaf to kvm-only is for saving
space in x86_capability[], or just because there's no other use case in
the host kernel side and the cpuflags of this features can be removed.

Hope for your suggestions.

-- 
Regards,
Jiaxi
