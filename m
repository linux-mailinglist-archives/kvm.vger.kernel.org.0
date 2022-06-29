Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B299156027F
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 16:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiF2OXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 10:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiF2OXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 10:23:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B842019A;
        Wed, 29 Jun 2022 07:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656512626; x=1688048626;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VZ40xQw0fMQsaP9afTcE5BSHMDKFla4/EFEXM7mjbWU=;
  b=TKsJ3vJ6LMlJ5Ypf/NO8OGsf3O0G+h5pQZsohnVYGxagmWk/TtYBsTHd
   Scsp5HZ6WPD4FUfdYUxbfRDr4dMOtGq5KAJ7E2h5Ne6fu0jx1bwGB6Jdh
   vVSae3CX9BDBgsUwBOj85laitAaUQd8aD+LdGzWgHfhnpV1NTFpyHzYd+
   8yx1uSqltflxRZF1InzHcBiM8lcyIc4E35d9kFTNFe6pTdwiYlLuU4FVn
   aCUCjnSMr0Bc4oQr4ntHQoGdItp9SQZSfMK10s1Nb53Kp92NTjRf/lXoI
   9L2H0OZogVOXitY3QJj75WFETkjOwhxRbjH5SRBAZ7LBQ2dJZj53i4YJI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="262447052"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="262447052"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:23:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="617588085"
Received: from staibmic-mobl1.amr.corp.intel.com (HELO [10.209.67.166]) ([10.209.67.166])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:23:45 -0700
Message-ID: <a2277c2f-91a1-871f-08f1-42950bca53b3@intel.com>
Date:   Wed, 29 Jun 2022 07:22:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 04/22] x86/virt/tdx: Prevent ACPI CPU hotplug and ACPI
 memory hotplug
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
 <20220624014112.GA15566@gao-cwp>
 <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/22 04:21, Kai Huang wrote:
> Personally I don't quite like this way.  To me having separate function for host
> and guest is more clear and more flexible.  And I don't think having
> #ifdef/endif has any problem.  I would like to leave to maintainers.

It has problems.

Let's go through some of them.  First, this:

> +#ifdef CONFIG_INTEL_TDX_HOST
> +static bool intel_tdx_host_has(enum cc_attr attr)
> +{
> +	switch (attr) {
> +	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
> +	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +#endif

What does that #ifdef get us?  I suspect you're back to trying to
silence compiler warnings with #ifdefs.  The compiler *knows* that it's
only used in this file.  It's also used all of once.  If you make it
'static inline', you'll likely get the same code generation, no
warnings, and don't need an #ifdef.

The other option is to totally lean on the compiler to figure things
out.  Compile this program, then disassemble it and see what main() does.

static void func(void)
{
	printf("I am func()\n");
}

void main(int argc, char **argv)
{
	if (0)
		func();
}

Then, do:

-	if (0)
+	if (argc)

and run it again.  What changed in the disassembly?

> +static bool intel_cc_platform_has(enum cc_attr attr)
> +{
> +#ifdef CONFIG_INTEL_TDX_GUEST
> +	if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
> +		return intel_tdx_guest_has(attr);
> +#endif

Make this check cpu_feature_enabled(X86_FEATURE_TDX_GUEST).  That has an
#ifdef built in to it.  That gets rid of this #ifdef.  You have

> +#ifdef CONFIG_INTEL_TDX_HOST
> +	if (platform_tdx_enabled())
> +		return intel_tdx_host_has(attr);
> +#endif
> +	return false;
> +}

Now, let's turn our attention to platform_tdx_enabled().  Here's its
stub and declaration:

> +#ifdef CONFIG_INTEL_TDX_HOST
> +bool platform_tdx_enabled(void);
> +#else  /* !CONFIG_INTEL_TDX_HOST */
> +static inline bool platform_tdx_enabled(void) { return false; }
> +#endif /* CONFIG_INTEL_TDX_HOST */

It already has an #ifdef CONFIG_INTEL_TDX_HOST, so that #ifdef can just
go away.

Kai, the reason that we have the rule that Yuan cited:

> "Wherever possible, don't use preprocessor conditionals (#if, #ifdef) in .c"
> From Documentation/process/coding-style.rst, 21) Conditional Compilation.

is not because there are *ZERO* #ifdefs in .c files.  It's because
#ifdefs in .c files hurt readability and are usually avoidable.  How do
you avoid them?  Well, you take a moment and look at the code and see
how other folks have made it readable.  It takes refactoring of code to
banish #ifdefs to headers or replace them with compiler constructs so
that the compiler can do the work behind the scenes.

Kai, could you please take the information I gave you in this message
and try to apply it across this series?  Heck, can you please take it
and use it to review others' code to make sure they don't encounter the
same pitfalls?
