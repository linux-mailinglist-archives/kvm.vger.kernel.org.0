Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92502729B83
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239282AbjFINXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjFINXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 09:23:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78807180;
        Fri,  9 Jun 2023 06:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686316990; x=1717852990;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qGd++aEZqtFd2tkmlsRxaFyNXm7hhQJWK4X3LLyYpVM=;
  b=JcZ+Y/oABIBkr5ZsxcQUFB7Yx5GzcNoLJkGhWjKQN8K5B2WvTXI3f8yb
   oD9pWjwBeyq9krhLeE5BymV7AaLjDfDJyYI1Do2SfDlsTbcMIXYYLFaqU
   7nsQCAX3Wx/9DQ1jk6+D5lBEngFm2DhrVlBr0utqKa3F/dIm4lNsXJfK/
   XjNSJYj9gPxTK+5rpVja2ukDVVgGWU9+MvGqBILQg26HWbIQkWCXml5Q6
   5t6Zb9/fdsG1zPOlSrVkDVlBVZ9ZWmxLfe+p2WJ9bzyeIdtVekzB0KYAU
   McvYUkro96IXRp0cyDeOE9G/HW5KRTDAhpcDai95jbPiIlPF6Jf3Zjfxk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="347242407"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="347242407"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 06:23:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="854738291"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="854738291"
Received: from mbahx-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.216])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 06:23:04 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id D0428109B7B; Fri,  9 Jun 2023 16:23:01 +0300 (+03)
Date:   Fri, 9 Jun 2023 16:23:01 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Message-ID: <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:31AM +1200, Kai Huang wrote:
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 8ff07256a515..0aa413b712e8 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -587,6 +587,14 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
>  		tdmr_pamt_base += pamt_size[pgsz];
>  	}
>  
> +	/*
> +	 * tdx_memory_shutdown() also reads TDMR's PAMT during
> +	 * kexec() or reboot, which could happen at anytime, even
> +	 * during this particular code.  Make sure pamt_4k_base
> +	 * is firstly set otherwise tdx_memory_shutdown() may
> +	 * get an invalid PAMT base when it sees a valid number
> +	 * of PAMT pages.
> +	 */

Hmm? What prevents compiler from messing this up. It can reorder as it
wishes, no?

Maybe add a proper locking? Anything that prevent preemption would do,
right?

>  	tdmr->pamt_4k_base = pamt_base[TDX_PS_4K];
>  	tdmr->pamt_4k_size = pamt_size[TDX_PS_4K];
>  	tdmr->pamt_2m_base = pamt_base[TDX_PS_2M];

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
