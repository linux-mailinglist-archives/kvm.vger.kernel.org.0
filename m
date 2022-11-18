Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C8062FABC
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 17:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbiKRQsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 11:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242334AbiKRQr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 11:47:58 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB8E93739;
        Fri, 18 Nov 2022 08:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668790077; x=1700326077;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xCb8sKcKoq4VtLr+lQLlizbUgM3fsLee1wQ+Q8lDqpE=;
  b=WRBnY1Bz2U0vL0vr6G7UEhw0atmxWLSbZNuDCoI5xJrEVBc3zlEjl3kE
   xBGlRaRabnk2rwomvAbbylf52IWHdtVzii+5/pwfhMTILuEZRl+TpfBn3
   ja3c/Sq1lOzLXk7j3gOGSUVh7LjhyskdUg7uejTFPMpL13cNeVUVMHV2e
   4w96uzzNhj+VM6xnAU78LPYw4RkbsKAG8Tx2B0VM94pS8Z+M4BX2KVbkF
   /8rfyKZfCKMCPHpEURBzwD5naop9iMJVPE7zBwcR4AmnDfem+gbv7TCow
   FMv1ADQYtW/k/o+2jOnQOC17zdAz2fFeKMJMhoJ1KDo0/+qcX/qWOE0DA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="399464207"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="399464207"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 08:47:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="642570145"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="642570145"
Received: from mbeebe-mobl1.amr.corp.intel.com (HELO [10.209.82.240]) ([10.209.82.240])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 08:47:55 -0800
Message-ID: <efb55727-f8bd-815c-ddfc-a8432ae5af4e@intel.com>
Date:   Fri, 18 Nov 2022 08:47:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v4 1/6] x86: KVM: Advertise CMPccXADD CPUID to user space
Content-Language: en-US
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-2-jiaxi.chen@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20221118141509.489359-2-jiaxi.chen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/22 06:15, Jiaxi Chen wrote:
> CMPccXADD is a new set of instructions in the latest Intel platform
> Sierra Forest. This new instruction set includes a semaphore operation
> that can compare and add the operands if condition is met, which can
> improve database performance.
> 
> The bit definition:
> CPUID.(EAX=7,ECX=1):EAX[bit 7]
> 
> This CPUID is exposed to userspace. Besides, there is no other VMX
> control for this instruction.

The last time you posted these, I asked:

> Intel folks, when you add these bits, can you please include information
> about the "vetting" that you performed?

I think you're alluding to that in your comment about VMX contols.
Could you be more explicit here and include *all* of your logic about
why this feature is OK to pass through to guests?

Also, do we *want* this showing up in /proc/cpuinfo?

There are also two distinct kinds of features that you're adding here.
These:

> +#define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */

and these:

+#define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)

Could you also please include a sentence or two about why the feature
was treated on way versus another?  That's frankly a lot more important
than telling us which random Intel codename this shows up on first, or
wasting space on telling us what the CPUID bit definition is.  We can
kinda get that from the patch.

Another nit on these:

> This CPUID is exposed to userspace. Besides, there is no other VMX
> control for this instruction.

Please remember to use imperative voice when describing what the patch
in question does.  Using passive voice like that makes it seem like
you're describing the state of the art rather than the patch.

For example, that should probably be:

	Expose CMPCCXADD to KVM userspace.  This is safe because there
	are no new VMX controls or host enabling required for guests to
	use this feature.

See how that first sentence is giving orders?  It's *telling* you what
to do.  That's imperative voice and that's what you use to describe the
actions of *this* patch.
