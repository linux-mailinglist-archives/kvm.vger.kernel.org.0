Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44CC7D19B1
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 01:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjJTXt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 19:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjJTXtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 19:49:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D019010CA;
        Fri, 20 Oct 2023 16:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697845781; x=1729381781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sUVfTo3lntITx/vLDxRaXJpf3T8h1tdB1hdFMPw4iHA=;
  b=Ja1Mh8BTYYoWirSph/H2mmVe1NkbNukdFVYhY74IL8OxC1GcnKoOC2dw
   UWo4aCWAgYrT5echBeOrbIUOaCVdp/TFGDLbqwdQtd8BxrTifnBFY8X5q
   a0uDHRk27edY7GjCf8X2T+05xkp+eWPBEFVoOEQ0hE6KMnZYyATi7u39q
   DhLcrAQ/rBhmjqLBi2Ek0RkAduAtJAnNGxBFqVCVsjE7GTTpbPH4svxMH
   m+TCSfVK099HXoyCyfhOOeiVBwuSJSdC2aT3RsupxSAob8/Vwr6qQ0LLA
   x3VnuX8IuNNQ03lykieIFVKYMCXgY1tRff2oTLpHrgDKixfy8/9GV9jcU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="389446278"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="389446278"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 16:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="707373792"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="707373792"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 16:49:40 -0700
Date:   Fri, 20 Oct 2023 16:49:34 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  3/6] x86/entry_32: Add VERW just before userspace
 transition
Message-ID: <ZTMSDkBzUZBiTBoG@tassilo>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-3-cff54096326d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020-delay-verw-v1-3-cff54096326d@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 01:45:09PM -0700, Pawan Gupta wrote:
> As done for entry_64, add support for executing VERW late in exit to
> user path for 32-bit mode.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/entry/entry_32.S | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> index 6e6af42e044a..bbf77d2aab2e 100644
> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -886,6 +886,9 @@ SYM_FUNC_START(entry_SYSENTER_32)
>  	popfl
>  	popl	%eax
>  
> +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> +	USER_CLEAR_CPU_BUFFERS
> +
>  	/*
>  	 * Return back to the vDSO, which will pop ecx and edx.
>  	 * Don't bother with DS and ES (they already contain __USER_DS).

Did you forget the INT 0x80 entry point?

-Andi

