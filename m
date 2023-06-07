Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31ADE726448
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 17:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240933AbjFGPYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 11:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240106AbjFGPYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 11:24:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBF31BE2;
        Wed,  7 Jun 2023 08:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686151418; x=1717687418;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ac2EGXwaf9hbH3WLYBdv8zMnn+CvdHzS452aCXzYo7k=;
  b=YY5IUlTQTQcz0dlWG1aq5he9YVVQBVUSdfstII56/z8+2y5I6q/uXA/1
   9QIYB8WcPvNPs6NthtaNo6JgDQKTG84160WnVsPqQHBg8X6VFx6jk9uRR
   6IdPDEym+nxHqTrRSOS5idBuCd9p2rmqybGp2zM722vdaAdfroAjeh/mW
   EaK9tqQ0qtQhh1XL9t5jCVq6Fxgj60VPrpQsITmUdQVvOU6S3p7V5ph5n
   ix91kgK7qKHlJoKtbvazrAQuSJVUkufGl+T92RI2TWbWk7yKF4TUZ6LXJ
   9yvRqDB+7UJiZqgooD5dduyxRUNQUmh+nsMNfIQP0PC8Ut5/WdPY4Foo2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="341676661"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="341676661"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:22:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="822206808"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="822206808"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:22:36 -0700
Message-ID: <e7c21694-d31b-4dbe-f75b-5a7c0127f5c8@intel.com>
Date:   Wed, 7 Jun 2023 08:22:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/23 07:27, Kai Huang wrote:
...
> +static int try_init_module_global(void)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	/*
> +	 * The TDX module global initialization only needs to be done
> +	 * once on any cpu.
> +	 */
> +	raw_spin_lock_irqsave(&tdx_global_init_lock, flags);

Why is this "raw_"?

There's zero mention of it anywhere.

> +	if (tdx_global_init_status & TDX_GLOBAL_INIT_DONE) {
> +		ret = tdx_global_init_status & TDX_GLOBAL_INIT_FAILED ?
> +			-EINVAL : 0;
> +		goto out;
> +	}
> +
> +	/* All '0's are just unused parameters. */
> +	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
> +
> +	tdx_global_init_status = TDX_GLOBAL_INIT_DONE;
> +	if (ret)
> +		tdx_global_init_status |= TDX_GLOBAL_INIT_FAILED;
> +out:
> +	raw_spin_unlock_irqrestore(&tdx_global_init_lock, flags);
> +
> +	return ret;
> +}
> +
> +/**
> + * tdx_cpu_enable - Enable TDX on local cpu
> + *
> + * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
> + * global initialization SEAMCALL if not done) on local cpu to make this
> + * cpu be ready to run any other SEAMCALLs.
> + *
> + * Note this function must be called when preemption is not possible
> + * (i.e. via SMP call or in per-cpu thread).  It is not IRQ safe either
> + * (i.e. cannot be called in per-cpu thread and via SMP call from remote
> + * cpu simultaneously).

lockdep_assert_*() are your friends.  Unlike comments, they will
actually tell you if this goes wrong.

> +int tdx_cpu_enable(void)
> +{
> +	unsigned int lp_status;
> +	int ret;
> +
> +	if (!platform_tdx_enabled())
> +		return -EINVAL;
> +
> +	lp_status = __this_cpu_read(tdx_lp_init_status);
> +
> +	/* Already done */
> +	if (lp_status & TDX_LP_INIT_DONE)
> +		return lp_status & TDX_LP_INIT_FAILED ? -EINVAL : 0;
> +
> +	/*
> +	 * The TDX module global initialization is the very first step
> +	 * to enable TDX.  Need to do it first (if hasn't been done)
> +	 * before doing the per-cpu initialization.
> +	 */
> +	ret = try_init_module_global();
> +
> +	/*
> +	 * If the module global initialization failed, there's no point
> +	 * to do the per-cpu initialization.  Just mark it as done but
> +	 * failed.
> +	 */
> +	if (ret)
> +		goto update_status;
> +
> +	/* All '0's are just unused parameters */
> +	ret = seamcall(TDH_SYS_LP_INIT, 0, 0, 0, 0, NULL, NULL);
> +
> +update_status:
> +	lp_status = TDX_LP_INIT_DONE;
> +	if (ret)
> +		lp_status |= TDX_LP_INIT_FAILED;
> +
> +	this_cpu_write(tdx_lp_init_status, lp_status);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdx_cpu_enable);

You danced around it in the changelog, but the reason for the exports is
not clear.

> +static int init_tdx_module(void)
> +{
> +	/*
> +	 * TODO:
> +	 *
> +	 *  - Get TDX module information and TDX-capable memory regions.
> +	 *  - Build the list of TDX-usable memory regions.
> +	 *  - Construct a list of "TD Memory Regions" (TDMRs) to cover
> +	 *    all TDX-usable memory regions.
> +	 *  - Configure the TDMRs and the global KeyID to the TDX module.
> +	 *  - Configure the global KeyID on all packages.
> +	 *  - Initialize all TDMRs.
> +	 *
> +	 *  Return error before all steps are done.
> +	 */
> +	return -EINVAL;
> +}
> +
> +static int __tdx_enable(void)
> +{
> +	int ret;
> +
> +	ret = init_tdx_module();
> +	if (ret) {
> +		pr_err("TDX module initialization failed (%d)\n", ret);

Have you actually gone any  looked at how this pr_*()'s look?

Won't they say:

	tdx: TDX module initialized

Isn't that a _bit_ silly?  Why not just say:

	pr_info("module initialized.\n");
