Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3784FC51E
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 21:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349711AbiDKT3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 15:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiDKT3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 15:29:09 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E262D1EAE8;
        Mon, 11 Apr 2022 12:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649705208; x=1681241208;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=361ZTGM96hxe/t9hSuSoqin9yJQVr5tnIcedOoLzyXM=;
  b=HcDqwUXdxoMlvvs4jNh+IkzmEgU6IP8xkodwarq3NDQjUxhS+JLxBRGp
   SEacHOQVzToDjuqZIRJB95NmfssmbOYaRGAqj569yeQaFFDNztMKZWsiJ
   wa2t0rzxRGOZKQ+f5XhxI3vdaGSQRv4pGbYwjw5GPLuQygB74g+5t8F3d
   oHLARBD6xy7x9gnVQSurYEr2GuTY8nxRi0OYO0fQRLtXpAg5YceKbEr3C
   CUdZi3QxcVMEh1JPxstBkinFegzaLHheGyLjx4J35jSEg0qo7T+oiK6Yp
   CK01Bvc62Vxxk/yINktWqWQYRV8VALSQxba7hrbV26iGjzFsBLiINqVlc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="249480514"
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="249480514"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 12:26:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="572352902"
Received: from minhjohn-mobl.amr.corp.intel.com (HELO [10.212.44.201]) ([10.212.44.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 12:26:47 -0700
Message-ID: <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
Date:   Mon, 11 Apr 2022 12:26:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
References: <20220411180131.5054-1-jon@nutanix.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
In-Reply-To: <20220411180131.5054-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/11/22 11:01, Jon Kohler wrote:
>  static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
>  {
> +	/*
> +	 * Hardware will always abort a TSX transaction if both CPUID bits
> +	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
> +	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
> +	 * here.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
> +	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
> +		tsx_clear_cpuid();
> +		setup_clear_cpu_cap(X86_FEATURE_RTM);
> +		setup_clear_cpu_cap(X86_FEATURE_HLE);
> +		return TSX_CTRL_RTM_ALWAYS_ABORT;
> +	}

I don't really like hiding the setup_clear_cpu_cap() like this.  Right
now, all of the setup_clear_cpu_cap()'s are in a single function and
they are pretty easy to figure out.

This seems like logic that deserves to be appended down to the last if()
block of code in tsx_init() instead of squirreled away in a "get mode"
function.  Does this work?

        if (tsx_ctrl_state == TSX_CTRL_DISABLE) {
		...
        } else if (tsx_ctrl_state == TSX_CTRL_ENABLE) {
		...	
        } else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT) {
		tsx_clear_cpuid();

		setup_clear_cpu_cap(X86_FEATURE_RTM);
		setup_clear_cpu_cap(X86_FEATURE_HLE);
	}

