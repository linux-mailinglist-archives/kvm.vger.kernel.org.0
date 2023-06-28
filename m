Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F0C7410E5
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjF1MaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 08:30:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:1966 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbjF1MaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 08:30:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687955408; x=1719491408;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SAzJtHLtNMNNef0gGslBTtW/PqahrrYxc8mh0SENA4Y=;
  b=FHJM0pnspdOa8To96VAnSckyu73wYxa2020s5WKltzL/6f5ghCiBX9XE
   Dl8ISw5qUDaoa3hpOii/5MSE4C6TIQBc/GeuRuT98C/T50b+1xIGRazDI
   FBBXWj80sEx0e1Nq74WE0cKJ2IPDlCoihzPLSRYNkYf028tYZAd8662Ol
   YOTCkl4bK3S4qebGX7lC47Vy3zKSYorc9t3QxI1YvlCFWdDK11VpLBdrF
   ndM63LrS3rC40hLGL/lFzVuqvAygPs/kUNehckL70TpYoOsEJPTg6Enqp
   JYoPAxzVxVxAvHG3xr5uoceNL+0atNFq7qa0vLfQgY5at2Eo6sTW5rR5K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="364380459"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="364380459"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 05:30:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="720229784"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="720229784"
Received: from rajritu-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.47.187])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 05:30:00 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id E19531095C8; Wed, 28 Jun 2023 15:29:57 +0300 (+03)
Date:   Wed, 28 Jun 2023 15:29:57 +0300
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
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Message-ID: <20230628122957.sl7wzenjby3o2xsw@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:49AM +1200, Kai Huang wrote:
> @@ -1113,6 +1115,17 @@ static int init_tdx_module(void)
>  	 */
>  	wbinvd_on_all_cpus();
>  
> +	/*
> +	 * Starting from this point the system may have TDX private
> +	 * memory.  Make it globally visible so tdx_reset_memory() only
> +	 * reads TDMRs/PAMTs when they are stable.
> +	 *
> +	 * Note using atomic_inc_return() to provide the explicit memory
> +	 * ordering isn't mandatory here as the WBINVD above already
> +	 * does that.  Compiler barrier isn't needed here either.
> +	 */
> +	atomic_inc_return(&tdx_may_has_private_mem);

Why do we need atomics at all here? Writers seems serialized with
tdx_module_lock and reader accesses the variable when all CPUs, but one is
down and cannot race.

Hm?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
