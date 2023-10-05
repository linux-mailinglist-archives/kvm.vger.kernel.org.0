Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1A47BA703
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjJEQqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbjJEQpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:45:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48F34C33;
        Thu,  5 Oct 2023 09:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696523987; x=1728059987;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hECVpPidxc+xsrBykLjrpIvybiMHyUQOm44BWE7oSQk=;
  b=kqr0IvgAb7JhEjuhbjXFQW1954DFsCDRdL7fiHY0rlA+dGX807tEFgRE
   sjzOOOcCrZek5uAUaeBPBXFvpDRneNmKoXa3JKYZWxBixU/QHnQmD/LcZ
   QN6znlCJQEdiRKtFK8MFuPBzn0cyLhf4ac1VqKu9CMmP7IBSLXZoBnf5C
   X6hzW6ew/cTYYVanqKcx4g8UxE1uWjVwbgVGG1MfZ2JyVjkzSliJbykJo
   oHuomx2JvuSEnmZ6wWoCN0ic9S2qK39HRc6sfo5Ab6H9Q0YELkjS/xHfw
   ZObjc6E4EtWaWJbEwBDs/RHIJS4lGQqLyevZtX3483apeNQCN+1HUPAB1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="2154592"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="2154592"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 09:35:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="925657352"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="925657352"
Received: from emosbarx-mobl2.amr.corp.intel.com (HELO [10.209.23.184]) ([10.209.23.184])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 09:35:40 -0700
Message-ID: <ef665e55-7604-e167-7c49-739c284c248c@intel.com>
Date:   Thu, 5 Oct 2023 09:35:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's
 FsGsKernelGsBaseNonSerializing
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20231004002038.907778-1-jmattson@google.com>
 <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
 <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local>
 <CALMp9eT2qHSig-ptP461GbLSfg86aCRjoxzK9Q7dc6yXSpPn7A@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CALMp9eT2qHSig-ptP461GbLSfg86aCRjoxzK9Q7dc6yXSpPn7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/23 09:22, Jim Mattson wrote:
> On Wed, Oct 4, 2023 at 12:59 AM Borislav Petkov <bp@alien8.de> wrote:
>> On Tue, Oct 03, 2023 at 07:44:51PM -0700, Jim Mattson wrote:
>>> The business of declaring breaking changes to the architectural
>>> specification in a CPUID bit has never made much sense to me.
>> How else should they be expressed then?
>>
>> In some flaky PDF which changes URLs whenever the new corporate CMS gets
>> installed?
>>
>> Or we should do f/m/s matching which doesn't make any sense for VMs?
>>
>> When you think about it, CPUID is the best thing we have.
> Every time a new defeature bit is introduced, it breaks existing
> hypervisors, because no one can predict ahead of time that these bits
> have to be passed through.
> 
> I wonder if we could convince x86 CPU vendors to put all defeature
> bits under a single leaf, so that we can just set the entire leaf to
> all 1's in KVM_GET_SUPPORTED_CPUID.

I hope I'm not throwing stones from a glass house here...

But I'm struggling to think of cases where Intel has read-only
"defeature bits" like this one.  There are certainly things like
MSR_IA32_MISC_ENABLE_FAST_STRING that can be toggled, but read-only
indicators of a departure from established architecture seems ...
suboptimal.

It's arguable that TDX changed a bunch of architecture like causing
exceptions on CPUID and MSRs that never caused exceptions before and
_that_ constitutes a defeature.  But that's the least of the problems
for a TDX VM. :)

(Seriously, I'm not trying to shame Intel's x86 fellow travelers here,
 just trying to make sure I'm not missing something).
