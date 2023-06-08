Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E182C7273B8
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 02:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjFHA1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 20:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjFHA1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 20:27:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF973213C;
        Wed,  7 Jun 2023 17:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686184054; x=1717720054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jQzX338FXtlNwG/9LxBQzpwhJC6fI/w9zX8t/rNwMFg=;
  b=HIfqQHgENjbsCzS2DT67AIQ5W2S3X1bBVSFpPD8CuK5vRrxDxK2U2M6o
   bQXYRC+2KLKRttcbeJRl+403AS5FrTl647G4VbTdZpvU2+leFo6ydRzky
   Z/fzm6RqYYwAQS6A1sdLr8bzgfT1icyuPq030ToOKQT3FgYDWzQ86EIqw
   tXsBFhij4PFUfBCNVhFaIXgZJkw75e3hWHcyvByMBaoX379XoPZYhvpcc
   cvErLz3I0xqxYgckaOF4pEHOwwUEqrY1DLvWaYppe8UDw8MDZJBc0Kz1u
   4P5hYsv+6Ua2B+SC25livPbm+sjC2tWYY3vOyZQ1IjakzmbEhrvmQ0+Gc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="341806286"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="341806286"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:27:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="956493261"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="956493261"
Received: from zhanzhiw-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.42.209])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:27:27 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 3054610F0E0; Thu,  8 Jun 2023 03:27:25 +0300 (+03)
Date:   Thu, 8 Jun 2023 03:27:25 +0300
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
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:21AM +1200, Kai Huang wrote:
> For now both 'tdsysinfo_struct' and CMRs are only used during the module
> initialization.  But because they are both relatively big, declare them
> inside the module initialization function but as static variables.

This justification does not make sense to me. static variables will not be
freed after function returned. They will still consume memory.

I think you need to allocate/free memory dynamically, if they are too big
for stack.

...

>  static int init_tdx_module(void)
>  {
> +	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
> +			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
> +	static struct cmr_info cmr_array[MAX_CMRS]
> +			__aligned(CMR_INFO_ARRAY_ALIGNMENT);

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
