Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E9355A110
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiFXSux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiFXSuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:50:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A6381736;
        Fri, 24 Jun 2022 11:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656096650; x=1687632650;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ut2SGnvpDx+O8nXdZtY5kkO5aRgYZRiMvdxYgKwPPVE=;
  b=RNwVstez+6KGZFiIBakNJubuiwt0NJ7XwqexC7M+d0bP/sZEsCbymnvW
   SmP0l3Gt8mHCxSrgGceRrJlv7Z9wBOOMgB2FwUDLGBzi4sBLEE8JgtAI3
   /1C1ZND985skhhNG3g0lBhN+sFCtWYLYDwh7Jap7KRCn9Mb1JQRf2SR1K
   GBmA9s6ZA35C36YNh+JZ01MXXwQWtTyG94BUjJQK9DzVAi3TmKJnXK0W6
   8qHU5F8V4Rn9JM/nrfNtumoyLMdQfym6WvZrVRWm5W3UsaWZhUqYX/6+v
   FayPDhs/lcno03Jt3olkTKvgO1n9SI7/aLpO4B8vhcAZmZVRobOX+wKTl
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="260878551"
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="260878551"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 11:50:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="731429723"
Received: from mdedeogl-mobl.amr.corp.intel.com (HELO [10.209.126.186]) ([10.209.126.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 11:50:49 -0700
Message-ID: <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
Date:   Fri, 24 Jun 2022 11:50:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 08/22] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So, the last patch was called:

	Implement SEAMCALL function

and yet, in this patch, we have a "seamcall()" function.  That's a bit
confusing and not covered at *all* in this subject.

Further, seamcall() is the *ONLY* caller of __seamcall() that I see in
this series.  That makes its presence here even more odd.

The seamcall() bits should either be in their own patch, or mashed in
with __seamcall().

> +/*
> + * Wrapper of __seamcall().  It additionally prints out the error
> + * informationi if __seamcall() fails normally.  It is useful during
> + * the module initialization by providing more information to the user.
> + */
> +static u64 seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +		    struct tdx_module_output *out)
> +{
> +	u64 ret;
> +
> +	ret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +	if (ret == TDX_SEAMCALL_VMFAILINVALID || !ret)
> +		return ret;
> +
> +	pr_err("SEAMCALL failed: leaf: 0x%llx, error: 0x%llx\n", fn, ret);
> +	if (out)
> +		pr_err("SEAMCALL additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%llx, r9 0x%llx, r10 0x%llx, r11 0x%llx.\n",
> +			out->rcx, out->rdx, out->r8, out->r9, out->r10, out->r11);
> +
> +	return ret;
> +}
> +
> +static void seamcall_smp_call_function(void *data)
> +{
> +	struct seamcall_ctx *sc = data;
> +	struct tdx_module_output out;
> +	u64 ret;
> +
> +	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9, &out);
> +	if (ret)
> +		atomic_set(&sc->err, -EFAULT);
> +}
> +
> +/*
> + * Call the SEAMCALL on all online CPUs concurrently.  Caller to check
> + * @sc->err to determine whether any SEAMCALL failed on any cpu.
> + */
> +static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
> +{
> +	on_each_cpu(seamcall_smp_call_function, sc, true);
> +}

You can get away with this three-liner seamcall_on_each_cpu() being in
this patch, but seamcall() itself doesn't belong here.

>  /*
>   * Detect and initialize the TDX module.
>   *
> @@ -138,7 +195,10 @@ static int init_tdx_module(void)
>  
>  static void shutdown_tdx_module(void)
>  {
> -	/* TODO: Shut down the TDX module */
> +	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
> +
> +	seamcall_on_each_cpu(&sc);
> +
>  	tdx_module_status = TDX_MODULE_SHUTDOWN;
>  }
>  
> @@ -221,6 +281,9 @@ bool platform_tdx_enabled(void)
>   * CPU hotplug is temporarily disabled internally to prevent any cpu
>   * from going offline.
>   *
> + * Caller also needs to guarantee all CPUs are in VMX operation during
> + * this function, otherwise Oops may be triggered.

I would *MUCH* rather have this be a:

	if (!cpu_feature_enabled(X86_FEATURE_VMX))
		WARN_ONCE("VMX should be on blah blah\n");

than just plain oops.  Even a pr_err() that preceded the oops would be
nicer than an oops that someone has to go decode and then grumble when
their binutils is too old that it can't disassemble the TDCALL.



>   * This function can be called in parallel by multiple callers.
>   *
>   * Return:
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index f1a2dfb978b1..95d4eb884134 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -46,6 +46,11 @@
>  #define TDX_KEYID_NUM(_keyid_part)	((u32)((_keyid_part) >> 32))
>  
>  
> +/*
> + * TDX module SEAMCALL leaf functions
> + */
> +#define TDH_SYS_LP_SHUTDOWN	44
> +
>  /*
>   * Do not put any hardware-defined TDX structure representations below this
>   * comment!

