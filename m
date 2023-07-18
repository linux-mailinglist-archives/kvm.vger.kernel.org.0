Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3627588FC
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 01:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjGRXRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 19:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjGRXRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 19:17:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DB9E0;
        Tue, 18 Jul 2023 16:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689722236; x=1721258236;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=LKaFukftyjgRVkggmhjfkR3N5wbjbrueS9ivB5r4O8o=;
  b=KYZK38fo0vmIIz1leaCEWutuE51kt/gwvPW2W1sbZasmTKtWiHgzx8UD
   gjB57rOKouqDJQNFmpYQlXrMm/WpRybodVozeeUt4lmF0a5EsFCd7SHRz
   yCMj+1Dj6bSD/4yVwh65MM8onuWl2mBqoaFGBd+jr8uA0eWIYFAnAbJRP
   q7TZk7CWiqOhRyWoSVdQE39Ew1enWWXq8Gl0ozlVRilbwOuKS5/Ce0CT0
   UZwch8Q6uyyl/+MIIICQSD5o9yKWEL63afeJOxHOCZfhd5psI1Sfv/sHI
   1sw9P8wflJ9SbMYJ9EkhS8bguFKZQR8+AD1O/xkudUPi3qXZd5g/cUDK/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="430095236"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="430095236"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 16:17:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="837450299"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="837450299"
Received: from unknown (HELO [10.209.37.195]) ([10.209.37.195])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 16:17:11 -0700
Message-ID: <396d0e29-defc-e207-2cbd-fe7137e798ad@intel.com>
Date:   Tue, 18 Jul 2023 16:17:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH RFC v9 08/51] x86/speculation: Do not enable Automatic
 IBRS if SEV SNP is enabled
To:     Kim Phillips <kim.phillips@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-9-michael.roth@amd.com>
 <696ea7fe-3294-f21b-3bc0-3f8cc0a718e9@intel.com>
 <b8eeb557-0a6b-3aff-0f31-1c5e3e965a50@amd.com>
Content-Language: en-US
In-Reply-To: <b8eeb557-0a6b-3aff-0f31-1c5e3e965a50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/18/23 15:34, Kim Phillips wrote:
...
> Automatic IBRS provides protection to [1]:
> 
>  - Processes running at CPL=0
>  - Processes running as host when Secure Nested Paging (SEV-SNP) is enabled
> 
> i.e.,
> 
>     (CPL < 3) || ((ASID == 0) && SNP)
> 
> Because of this limitation, do not enable Automatic IBRS when SNP is
> enabled.

Gah, I found that hard to parse.  I think it's because you're talking
about an SEV-SNP host in one part and "SNP" in the other but _meaning_
SNP host and SNP guest.

Could I maybe suggest that you folks follow the TDX convention and
actually add _GUEST and _HOST to the feature name be explicit about
which side is which?

> Instead, fall back to retpolines.

Now I'm totally lost.

This is talking about falling back to retpolines ... in the kernel.  But
"Automatic IBRS provides protection to ... CPL < 3", aka. the kernel.

> Note that the AutoIBRS feature may continue to be used within the
> guest.

What is this trying to say?

"AutoIBRS can still be used in a guest since it protects CPL < 3"

or

"The AutoIBRS bits can still be twiddled within the guest even though it
doesn't do any good"

?

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 8cd4126d8253..311c0a6422b5 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1348,7 +1348,8 @@ static void __init cpu_set_bug_bits(struct
> cpuinfo_x86 *c)
>       * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
>       * flag and protect from vendor-specific bugs via the whitelist.
>       */
> -    if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
> +    if ((ia32_cap & ARCH_CAP_IBRS_ALL) || (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
> +        !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
>          setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
>          if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
>              !(ia32_cap & ARCH_CAP_PBRSB_NO))

