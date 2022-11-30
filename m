Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E580B63E239
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 21:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiK3UhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 15:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiK3Ugx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 15:36:53 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648CC1D3;
        Wed, 30 Nov 2022 12:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669840612; x=1701376612;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r1FDXbnXDjUldZm7GrdgEZtQHBGflDxjpKsRBC7x164=;
  b=g+PRrf0OCq3/nAYL7eotFFJNgtAt0jKI6mdn2jaWXFbYHI9Lt8pclxPT
   LpeAwBNChfc3Dy/tyAzN45h1Rox3v2+0gDbYp3Rt05IEC/4oeTHnDrRRB
   LcGYTQJa1f4vU/fEFooF/+nY8S7WzvJwqd6QApsEWXYyWeS4gjd8AH2E8
   2MPjvwWyoJWD03W5GLBaDKu5PRSvmUUrLCZawtJIyDdp1YPDopV6AAgAg
   6+p/SizVETWJX+X2SDeaM7xd2mZkwqz6JP4A8uR8iZGABXrEkMWPFSGcC
   8fUctPZ0iIuEp3rJ4t9aK9Vqo+WiOjeuIwwg085O9CGCDO9he339rrTTC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="377671777"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="377671777"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 12:36:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="644360640"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="644360640"
Received: from subhadee-mobl.amr.corp.intel.com (HELO desk) ([10.251.3.232])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 12:36:51 -0800
Date:   Wed, 30 Nov 2022 12:36:49 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] x86/cpu, kvm: Support AMD Automatic IBRS
Message-ID: <20221130203649.gwhypmw35mfgwsxh@desk>
References: <20221129235816.188737-1-kim.phillips@amd.com>
 <20221129235816.188737-7-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221129235816.188737-7-kim.phillips@amd.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 05:58:15PM -0600, Kim Phillips wrote:
>--- a/arch/x86/kernel/cpu/common.c
>+++ b/arch/x86/kernel/cpu/common.c
>@@ -1406,6 +1406,14 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
> 	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
> 		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
>
>+	/*
>+	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel flag only
>+	 * after IBRS_ENHANCED bugs such as BUG_EIBRS_PBRSB above have been
>+	 * determined.
>+	 */

Minor comment, setting NO_EIBRS_PBRSB in cpu_vuln_whitelist for
non-EIBRS CPUs also (AMD and others) can remove this order dependency.

>+	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
>+		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
