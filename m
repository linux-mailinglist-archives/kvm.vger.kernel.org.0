Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F11694E5D
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 18:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjBMRsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 12:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjBMRsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 12:48:38 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD3F14E9C;
        Mon, 13 Feb 2023 09:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676310516; x=1707846516;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j1DwugrJL9mSpbjhMZ7GStuq8wsxps0u+ATugfsOC24=;
  b=QzuumK3TD1ZUZhHHEyq5VUJOOId/uffFriXg+IUV/hSgq2XE+FK4RWVy
   c8zWW4YXa3jNqDEBile8FdBP8aANhNJ9IwL5A3VN2bNe+BC1pLKjBUMII
   d+q+osfst+gXbMUISEgTda409GLIyR4feK5t1K0ECA3OiYSQddvMmLffi
   sesg06KOxBmaZnwcjF83N2/QuBysmVeVoVYL62p4CJ4GgFdJLF5+RNd1C
   o+UDMFFh84hdcYfn3/vuILinbBNwuLJ/qVMhaiXjbjJsawAkym48xA2lP
   7fDWzJpnVTb8X1tWkQQcCzESVZkr7YWE/KNkCj5edqiTJSgV7DNkx7BLe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="318972715"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="318972715"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 09:48:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="757673923"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="757673923"
Received: from mlswanso-mobl.amr.corp.intel.com (HELO [10.251.26.232]) ([10.251.26.232])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 09:48:33 -0800
Message-ID: <13348209-40da-226e-7852-9dcd16758ed6@intel.com>
Date:   Mon, 13 Feb 2023 09:48:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1676286526.git.kai.huang@intel.com>
 <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 03:59, Kai Huang wrote:
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 4a3ee64c1ca7..5c5ecfddb15b 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -8,6 +8,10 @@
>  #include <asm/ptrace.h>
>  #include <asm/shared/tdx.h>
>  
> +#ifdef CONFIG_INTEL_TDX_HOST
...
> +#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
> +#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
> +
> +#endif

All these kinds of header #ifdefs do it make it harder to write code in
.c files without matching #ifdefs.  Think of code like this completely
made up example:

	if (!tdx_enable()) {
		// Success!  Make a seamcall:
		int something = tdx_seamcall();
		if (something == TDX_SEAMCALL_UD)
			// oh no!
	}

tdx_enable() can never return 0 if CONFIG_INTEL_TDX_HOST=n, so the
entire if() block is optimized away by the compiler.  *BUT*, if you've
#ifdef'd away TDX_SEAMCALL_UD, you'll get a compile error.  People
usually fix the compile error like this:

	if (!tdx_enable()) {
#ifdef CONFIG_INTEL_TDX_HOST
		// Success!  Make a seamcall:
		int something = tdx_seamcall();
		if (something == TDX_SEAMCALL_UD)
			// oh no!
#endif
	}

Which isn't great.

Defining things unconditionally in header files is *FINE*, as long as
the #ifdefs are there somewhere to make the code go away at compile time.

Please post an updated (and tested) patch as a reply to this.
