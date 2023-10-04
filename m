Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CF77B7602
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 02:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjJDA5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 20:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjJDA5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 20:57:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54ACBAB;
        Tue,  3 Oct 2023 17:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696381063; x=1727917063;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=LCk1ZT+KVaE8ubE+mQhyLfx2CPNpr+w2Rf18vpMvauk=;
  b=POhON5Y18CO0zIdCBCpIwxLshgD1MzT7/BEzQzmC0fP/sSkbHBSnfBOK
   xBdONC3zGqhGbNlYkWLIBXLYpX7BzDISpvb1wghvMYjOzTii8ycjSJJVs
   ciTqQLu1ggPKc7KQL7XFlxG8gMhF/TfYXnwsJWrCBSsfwIrefAHYqr11I
   MET+Lm8xzcC0671xqVCyID7bVJpTusLDQqBSMb+QUJGqXmYDElJkdvwFB
   QwQFbNvn/6WjcpUgIBc9lYf435Pwj6IyVKBjq556lkBBX5L8uA5SWVjrE
   ZE5/JYAZ2JDO0Qhl/KVVwzXBq3pYW4JAHH2EgGg7rlm9rOvpcUclilw9A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="449511207"
X-IronPort-AV: E=Sophos;i="6.03,198,1694761200"; 
   d="scan'208";a="449511207"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 17:57:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="816905467"
X-IronPort-AV: E=Sophos;i="6.03,198,1694761200"; 
   d="scan'208";a="816905467"
Received: from ddiaz-mobl4.amr.corp.intel.com (HELO [10.209.57.36]) ([10.209.57.36])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 17:57:24 -0700
Message-ID: <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
Date:   Tue, 3 Oct 2023 17:57:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's
 FsGsKernelGsBaseNonSerializing
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20231004002038.907778-1-jmattson@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20231004002038.907778-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/23 17:20, Jim Mattson wrote:
> Define an X86_FEATURE_* flag for
> CPUID.80000021H:EAX.FsGsKernelGsBaseNonSerializing[bit 1], and
> advertise the feature to userspace via KVM_GET_SUPPORTED_CPUID.
...
> +#define X86_FEATURE_BASES_NON_SERIAL	(20*32+ 1) /* "" FSBASE, GSBASE, and KERNELGSBASE are non-serializing */

This is failing to differentiate two *VERY* different things.

FSBASE, GSBASE, and KERNELGSBASE themselves are registers.  They have
*NOTHING* to do with serialization.  WRFSBASE, for instance is not
serializing.  Reading (with RDMSR) or using any of those three registers
is not serializing.

The *ONLY* thing that relates them to serialization is the WRMSR
instruction which itself is (mostly) architecturally serializing and the
fact that WRMSR has historically been the main way to write those three
registers.

The AMD docs call this out, which helps.  But the changelog, comments
and probably the feature naming need some work.

Why does this matter, btw?  Why do guests need this bit passed through?
