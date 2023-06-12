Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7324C72CA68
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 17:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238925AbjFLPj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 11:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237297AbjFLPj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 11:39:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23B910C7;
        Mon, 12 Jun 2023 08:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686584366; x=1718120366;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j+rWQ8uomjRkNZBpW4VaiwZ0eeJFJe8H9MzLKuSwh4c=;
  b=Yc79jCzbvk16DUpmPy+df5Bq9z0A1kfpRr9OY11QXXtTDt0I23SBzB8h
   K6qrVf6Uzakqu/gdVP4OD2UT5EWCRzoSyfFSx2M52s37zW01Z64AsER5i
   eyNGYLATe846zWKzmVDdhmayfccIVZcxjhCT7huVB1tsAjqIhkWv40T2i
   XZKWvrx4A6AW0MvI6djt/RHbU842y9nZgiRXV355vlOgUobeetcec9Uxz
   L4ERcEbHQeYFA/IvoFv0pOQbiDToCG2cOzAwzKuMhVX39KLstnN507aun
   pYLtrgDiFbUTVZ0yY2TWKc5LJtOnQplWo8w7NjP6rfdXV9d4zJp/DolU2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="356966623"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="356966623"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 08:39:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="714434993"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="714434993"
Received: from spmantha-mobl1.amr.corp.intel.com (HELO [10.209.43.2]) ([10.209.43.2])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 08:39:23 -0700
Message-ID: <696ea7fe-3294-f21b-3bc0-3f8cc0a718e9@intel.com>
Date:   Mon, 12 Jun 2023 08:39:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 08/51] x86/speculation: Do not enable Automatic
 IBRS if SEV SNP is enabled
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
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
        zhi.a.wang@intel.com, Kim Phillips <kim.phillips@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-9-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230612042559.375660-9-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/23 21:25, Michael Roth wrote:
> A hardware limitation prevents the host from enabling Automatic IBRS
> when SNP is enabled.  Instead, fall back to retpolines.

"Hardware limitation"?  As in, it is a documented, architectural
restriction?  Or, it's a CPU bug?

> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index f9d060e71c3e..3fba3623ff64 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1507,7 +1507,12 @@ static void __init spectre_v2_select_mitigation(void)
>  
>  	if (spectre_v2_in_ibrs_mode(mode)) {
>  		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
> -			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
> +			if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
> +				msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
> +			} else {
> +				pr_err("SNP feature available, not enabling AutoIBRS on the host.\n");
> +				mode = spectre_v2_select_retpoline();
> +			}

I think this would be nicer if you did something like:

	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
		setup_clear_cpu_cap(X86_FEATURE_AUTOIBRS);

somewhere _else_ in the code instead of smack-dab in the middle of the
mitigation selection.
