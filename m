Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D039633185
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 01:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiKVAo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 19:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKVAoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 19:44:54 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3374313F2F;
        Mon, 21 Nov 2022 16:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669077894; x=1700613894;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vQu+Ql6V2W8MdI2sO01U5UcW0Jf0jzenhcur0b9+iUY=;
  b=ncFQK+6KFgytMgcc+Ewt/XD6k3hiie1U7GyDYDW1cFSYPrX+CEJc+Xrm
   U+4QSMjwkVHsqHKlqkUhzr0laEd1YsXthL7pMyuhg9x5bMUl4Hl+N+Tew
   EKbqX+ovVvYY7h4r/GHLW1rSeIYEEC1pDuKulK0mywP4tDY5+T051QLLx
   gjxCildlytdctAxGsIr0LsqqC8a+e8MJ0byGwxZ4OG4twKA6Ax76PjJ1f
   eH6mJGm2mpdfmY9tDHgPAFpVJtgMCUOvALc9TKyJKVaG2rWnQrBgibViI
   56PkvpywKK7KSeFFBFOM5opfOCVYFOy7hGLFL143uKgvxAf6KDliLtBM0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="297053116"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="297053116"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 16:44:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="783652648"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="783652648"
Received: from ticela-or-327.amr.corp.intel.com (HELO [10.209.6.63]) ([10.209.6.63])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 16:44:51 -0800
Message-ID: <c564a7fe-2e33-a071-e333-39163471c678@intel.com>
Date:   Mon, 21 Nov 2022 16:44:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
 <87e17024-755d-e195-d9ea-ef62a4de6aa8@intel.com>
 <f9918596c4013444428899aca2cfa73b1f18c703.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <f9918596c4013444428899aca2cfa73b1f18c703.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 16:30, Huang, Kai wrote:
> 
> How about still having a patch to make INTEL_TDX_HOST depend on X86_X2APIC but
> with something below in the changelog?
> 
> "
> TDX capable platforms are locked to X2APIC mode and cannot fall back to the
> legacy xAPIC mode when TDX is enabled by the BIOS.   It doesn't make sense to
> turn on INTEL_TDX_HOST while X86_X2APIC is not enabled.  Make INTEL_TDX_HOST
> depend on X86_X2APIC.

That's fine and it makes logical sense as a dependency.  TDX host
support requires x2APIC.  Period.
