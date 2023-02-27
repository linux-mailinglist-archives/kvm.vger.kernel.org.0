Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDE76A4600
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 16:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjB0PZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 10:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjB0PZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 10:25:02 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D32A5C8;
        Mon, 27 Feb 2023 07:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677511502; x=1709047502;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+CejFf8b0UQvbot2jFXkztwMBtpHRC/UL4Ous0PzlUA=;
  b=hu497h45ij+//XIxaQnMt9YrECD90YqNebpuv0hpz6ZfPbmUniiztqU6
   IS8BpRM/9U6ukzGVKU6NGINkQHm+DD5/yOaTgaeyvHcCIcPXJE0iHxcdl
   hY8Qp1KC46s04bu9pNy6KZk8o9qRIlqqWluq0+3oJmRCwrio+XJRA+SDm
   crc4SSyuTKkVkJwkeBCWwCyAT16oYjFRDjtknTy0RtP9K99pdl1H9j+PG
   ImgOnSl/G0OxCIuDxf6mtP93n18kdLyYEwLSreazJ6wJG4jUtO4C1U2pM
   uZWMCW0iTh0LvdC5goO3joZDb6yE+42/5W4maJAN785Helscgyg5gAsua
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="333926329"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="333926329"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 07:25:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="797674229"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="797674229"
Received: from mkrathi-mobl.gar.corp.intel.com (HELO [10.251.27.133]) ([10.251.27.133])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 07:25:00 -0800
Message-ID: <445daef5-8417-ddbb-abbf-3c5ab38e1c9c@intel.com>
Date:   Mon, 27 Feb 2023 07:25:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
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
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble> <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic> <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic> <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble> <Y/n9XcbnCzWv2Vul@zn.tnic>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y/n9XcbnCzWv2Vul@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/23 04:21, Borislav Petkov wrote:
> +	/*
> +	 * Make sure EFER[AIBRSE - Automatic IBRS Enable] is set. The APs are brought up
> +	 * using the trampoline code and as part of it, EFER gets prepared there in order
> +	 * to be replicated onto them. Regardless, set it here again, if not set, to protect
> +	 * against any future refactoring/code reorganization which might miss setting
> +	 * this important bit.
> +	 */
> +	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled) &&
> +	    cpu_has(c, X86_FEATURE_AUTOIBRS))
> +		msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
>  }

I guess the belt and suspenders could be justified here by how important
the bit is.

But, if EFER[AIBRSE] gets clear somehow shouldn't we also dump a warning
out here so the fool who botched it can fix it?  Even if AIBRSE is fixed
up, some less important bit could still be botched.

It will freak some users out, but it does seem like the kind of thing we
_want_ a bug report for.
