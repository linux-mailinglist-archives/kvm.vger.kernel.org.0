Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9E6505FC7
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 00:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiDRWcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 18:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiDRWcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 18:32:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7E32AC58;
        Mon, 18 Apr 2022 15:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650320977; x=1681856977;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x3LX6huKtEVcSvcP8lAWxAATuMO8mjnqdyupJ1IbV6g=;
  b=kX/s7S7fdjWviEkE4A04E+T9J1USapJYe3my0Hk6daEs0j4lI6sohx7v
   XCLWEpMcQNxMOn1iXgks3VLmOaxhMnCEyA/7zrZJLDdhsurtD4s9AYRHJ
   ULhHCSbjmsDcRfvAGc1T27sFpy0TwJtkjck2YzfQbwBGTBGPxUH8DyPav
   3rU9dVjYyeew9HMARpdYLVVHPX2JBUYBpramr4G3HbuFMJgiar+pQQCS9
   sLY8Lzt+cu5KJiInaUpeu410gVM77UWzgmUxGh+KqGt0DNNTC1vh+i3uP
   yxsctxmqijS5WvudDMsUZaaVQyo4OrJzeddblExBzwTLpneGEmlDghw8Y
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="262483945"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="262483945"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 15:29:37 -0700
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="657406058"
Received: from efiguero-mobl.amr.corp.intel.com (HELO [10.212.242.93]) ([10.212.242.93])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 15:29:36 -0700
Message-ID: <8e2269a7-3e71-5030-8d04-1e8e3fc4323f@linux.intel.com>
Date:   Mon, 18 Apr 2022 15:29:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 01/21] x86/virt/tdx: Detect SEAM
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 9:49 PM, Kai Huang wrote:
> +/* BIOS must configure SEAMRR registers for all cores consistently */
> +static u64 seamrr_base, seamrr_mask;
> +
> +static bool __seamrr_enabled(void)
> +{
> +	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> +}
> +
> +static void detect_seam_bsp(struct cpuinfo_x86 *c)
> +{
> +	u64 mtrrcap, base, mask;
> +
> +	/* SEAMRR is reported via MTRRcap */
> +	if (!boot_cpu_has(X86_FEATURE_MTRR))
> +		return;
> +
> +	rdmsrl(MSR_MTRRcap, mtrrcap);
> +	if (!(mtrrcap & MTRR_CAP_SEAMRR))
> +		return;
> +
> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
> +	if (!(base & SEAMRR_PHYS_BASE_CONFIGURED)) {
> +		pr_info("SEAMRR base is not configured by BIOS\n");
> +		return;
> +	}
> +
> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
> +	if ((mask & SEAMRR_ENABLED_BITS) != SEAMRR_ENABLED_BITS) {
> +		pr_info("SEAMRR is not enabled by BIOS\n");
> +		return;
> +	}
> +
> +	seamrr_base = base;
> +	seamrr_mask = mask;
> +}
> +
> +static void detect_seam_ap(struct cpuinfo_x86 *c)
> +{
> +	u64 base, mask;
> +
> +	/*
> +	 * Don't bother to detect this AP if SEAMRR is not
> +	 * enabled after earlier detections.
> +	 */
> +	if (!__seamrr_enabled())
> +		return;
> +
> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
> +	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
> +
> +	if (base == seamrr_base && mask == seamrr_mask)
> +		return;
> +
> +	pr_err("Inconsistent SEAMRR configuration by BIOS\n");

Do we need to panic for SEAM config issue (for security)?

> +	/* Mark SEAMRR as disabled. */
> +	seamrr_base = 0;
> +	seamrr_mask = 0
> +}
> +
> +static void detect_seam(struct cpuinfo_x86 *c)
> +{

why not do this check directly in tdx_detect_cpu()?

> +	if (c == &boot_cpu_data)
> +		detect_seam_bsp(c);
> +	else
> +		detect_seam_ap(c);
> +}
> +
> +void tdx_detect_cpu(struct cpuinfo_x86 *c)
> +{
> +	detect_seam(c);
> +}

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
