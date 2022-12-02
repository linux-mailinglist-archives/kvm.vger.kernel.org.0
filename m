Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78B1640C51
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiLBRkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbiLBRkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:40:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAA5D8248;
        Fri,  2 Dec 2022 09:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670002832; x=1701538832;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9nkl6U6faLzmpRpWj2oEtZL5rBcBx5yMH6yvYffIRKU=;
  b=dkJhLS07yG4cKiqw+XSEvmv57Ik/JkPY9u3q2Tvx6leK6pGyU8a7rCOS
   oZ0JfR3t6mZCaTTPnmb3srvjkuxwCY1YtwtdW/3s8UY0Kk4rJGeDQIH6m
   EZYxY3PrMsCYx39SFF7YrTnowBXhM3DsVuobyNaxu1V+iBNQO+S1PvXh3
   DrES+g0bWt2liMp3dXdLa7pxnCssV0fnyOo3xTKKabanG4B2vi/ruyCHF
   gFsGm6OhaTO+OClVT4ao/yb4A/wxjfCz/J6wgIdV6uHIJ6xE5pphabLNA
   E5C5mTjIMX0H5VD0UYoWJ0n+C+YcrG3hlaHvIM7pffMeC9davXXcw3gyA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295702194"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="295702194"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 09:40:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="733886270"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="733886270"
Received: from rsnyder-mobl.amr.corp.intel.com (HELO [10.209.68.71]) ([10.209.68.71])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 09:40:30 -0800
Message-ID: <7a078451-172c-40f3-c2c7-4472c5006532@intel.com>
Date:   Fri, 2 Dec 2022 09:40:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v4 6/7] x86/cpu: Support AMD Automatic IBRS
Content-Language: en-US
To:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org
Cc:     Babu Moger <Babu.Moger@amd.com>, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
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
References: <20221201015003.295769-1-kim.phillips@amd.com>
 <20221201015003.295769-7-kim.phillips@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20221201015003.295769-7-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/22 17:50, Kim Phillips wrote:
> @@ -1240,8 +1240,11 @@ static const struct {
>  	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
>  	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
>  	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
> +	{ "autoibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
>  	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
> +	{ "autoibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
>  	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
> +	{ "autoibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
>  	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
>  	{ "ibrs",		SPECTRE_V2_CMD_IBRS,              false },

I don't think we should expose "autoibrs" to end users like this.
"eibrs" means always-on IBRS.  Intel did it first, so gets to name it.
Those are the rules, and it's why we call it "x86_64" and not whatever
Intel's silly name for it was.

Also, expanding the strings:

> +	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced / Automatic IBRS + Retpolines",

is fine, but adding new user-visible options that we have to document is
not.
