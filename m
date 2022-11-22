Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34996634462
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiKVTOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiKVTOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:14:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBC386A6C;
        Tue, 22 Nov 2022 11:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669144456; x=1700680456;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=se+OD9QShnHz7aQaFNLHMirO/kbdEBdvxBYXfCZOqXk=;
  b=YM/3xhIVtX2PfhKNBQ+GIIeEn0qrFZuQ6XfSnHv+ePktBOkhIZ9GU97B
   sgCeUnMLc+tiqT6eKsfEAtZ2QwVSsfDqX533xE12BMlJHkrWbekYjgg+C
   4SZR0BAEnzyT8BK4wKw4eKwf/aGitMNwSsyqGXalMIp/WCSr55Zv+lna8
   uFZ2FtbFb36GyDoSRHA9WRt13cPPlqnn7Q8SFFKDeXRRmpqOAtJQ+2k3O
   aO4q42jI81Q93IMgth1M9TJVw2i7I5f2BRDEEjdJnikHRDnAL9R2UGRMY
   01ofSTBWKbu98EHyX+z9q8EhIEjTOjKzFk8poStBwcrzxqG3/my3qWcON
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="293602300"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="293602300"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 11:14:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="766439301"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="766439301"
Received: from coltsavx-mobl1.amr.corp.intel.com (HELO [10.255.0.114]) ([10.255.0.114])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 11:14:13 -0800
Message-ID: <2cbd2fe3-91ea-49e6-d684-b1fab012b44e@intel.com>
Date:   Tue, 22 Nov 2022 11:14:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 07/20] x86/virt/tdx: Do TDX module global
 initialization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <40824ec3e3dc759705dcfa1cb2929d18c12b417a.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <40824ec3e3dc759705dcfa1cb2929d18c12b417a.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> The first step of initializing the module is to call TDH.SYS.INIT once
> on any logical cpu to do module global initialization.  Do the module
> global initialization.
> 
> It also detects the TDX module, as seamcall() returns -ENODEV when the
> module is not loaded.

Part of making a good patch set is telling a bit of a story.  In patch
4, you laid out 6 steps necessary to initialize TDX.  On top of that,
there is infrastructure  It would be great to lay that out in a way that
folks can actually follow along.

For instance, it would be great to tell the reader here that this patch
is an inflection point.  It is transitioning out of the infrastructure
(patches 1->6) and into the actual "multi-steps" of initialization that
the module spec requires.

This patch is *TOTALLY* different from the one before it because it
actually _starts_ to do something useful.

But, you wouldn't know it from the changelog.

>  arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++++--
>  arch/x86/virt/vmx/tdx/tdx.h |  1 +
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 5db1a05cb4bd..f292292313bd 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -208,8 +208,23 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
>   */
>  static int init_tdx_module(void)
>  {
> -	/* The TDX module hasn't been detected */
> -	return -ENODEV;
> +	int ret;
> +
> +	/*
> +	 * Call TDH.SYS.INIT to do the global initialization of
> +	 * the TDX module.  It also detects the module.
> +	 */
> +	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
> +	if (ret)
> +		goto out;

Please also note that the 0's are all just unused parameters.  They mean
nothing.

> +
> +	/*
> +	 * Return -EINVAL until all steps of TDX module initialization
> +	 * process are done.
> +	 */
> +	ret = -EINVAL;
> +out:
> +	return ret;
>  }

It might be a bit unconventional, but can you imagine how well it would
tell the story if this comment said:

	/*
	 * TODO:
	 *  - Logical-CPU scope initialization (TDH_SYS_INIT_LP)
	 *  - Enumerate capabilities and platform configuration
	      (TDH_SYS_CONFIG)
	 ...
	 */

and then each of the following patches that *did* those things removed
the TODO line from the list.

That TODO list could have been added in patch 4.

>  static void shutdown_tdx_module(void)
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 215cc1065d78..0b415805c921 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -15,6 +15,7 @@
>  /*
>   * TDX module SEAMCALL leaf functions
>   */
> +#define TDH_SYS_INIT		33
>  #define TDH_SYS_LP_SHUTDOWN	44
>  
>  /*

