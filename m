Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856A973F900
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 11:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjF0JtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 05:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjF0JtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 05:49:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75DD2698;
        Tue, 27 Jun 2023 02:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687859346; x=1719395346;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Cd7Gb/cSfWMtYaqI4IIQwz8koCmdUbWenXmNDuGS04=;
  b=n1jv0SsQ4VonC8xdo6yiDPMXEz/Du3fodOC8lMP5RC8WBcjxhCUh1K6f
   5YVipv46pp0p1tOAkNmuxFXrG1vmbQQDQpanbqVS603xF8skhs0MkhD1q
   6nV3QBY2i4TvZS18cz6isVdKaPCdxis965awTddXtfbCr4QgCDUXnv3ge
   7rQgXoQ2Da5IffpDTrATGRIY/YAHT/utovw99ayUkZqmlV387/CvRLpWi
   RoI/LEte/bxGOI8yeQo6gyGwWjMhAUtUhpmFBUfx5h4trUTAOPcoZVy1x
   X3onwRf+6a7NBRVrzxNLwMoN6ob65nQkLG9WqM4eIbhi0/KwQEfINLPgY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="447911632"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="447911632"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="719719700"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="719719700"
Received: from rbhaumik-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.217.121])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:48:59 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id D342F103732; Tue, 27 Jun 2023 12:48:56 +0300 (+03)
Date:   Tue, 27 Jun 2023 12:48:56 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230627094856.6udzuhzhygc4nzit@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:35AM +1200, Kai Huang wrote:
> +/*
> + * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
> + * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> + * leaf function return code and the additional output respectively if
> + * not NULL.
> + */
> +static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +				    u64 *seamcall_ret,
> +				    struct tdx_module_output *out)
> +{
> +	u64 sret;
> +	int cpu;
> +
> +	/* Need a stable CPU id for printing error message */
> +	cpu = get_cpu();
> +	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +	put_cpu();
> +
> +	/* Save SEAMCALL return code if the caller wants it */
> +	if (seamcall_ret)
> +		*seamcall_ret = sret;
> +
> +	switch (sret) {
> +	case 0:
> +		/* SEAMCALL was successful */
> +		return 0;
> +	case TDX_SEAMCALL_VMFAILINVALID:
> +		pr_err_once("module is not loaded.\n");
> +		return -ENODEV;
> +	default:
> +		pr_err_once("SEAMCALL failed: CPU %d: leaf %llu, error 0x%llx.\n",
> +				cpu, fn, sret);
> +		if (out)
> +			pr_err_once("additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%llx, r9 0x%llx, r10 0x%llx, r11 0x%llx.\n",
> +					out->rcx, out->rdx, out->r8,
> +					out->r9, out->r10, out->r11);

This look excessively noisy.

Don't we have SEAMCALL leafs that can fail in normal situation? Like
TDX_OPERAND_BUSY error code that indicate that operation likely will
succeed on retry.

Or is that wrapper only used for never-fail SEAMCALLs? If so, please
document it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
