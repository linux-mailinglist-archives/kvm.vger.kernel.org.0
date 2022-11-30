Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E8A63E369
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 23:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiK3W0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 17:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiK3W0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 17:26:13 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00AB87CB7;
        Wed, 30 Nov 2022 14:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669847172; x=1701383172;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vB3zUTLnMXl5iiPneAlLL6sdoFY16u7w9ki2HcepyIU=;
  b=RDwmuS2G1x5dgi/Yd02oq+v3msFuXHYkKboyF9OuW/LNeyypL0ueCHOO
   M16GUwhj0U7xc9j2NzsT01HZHH7AiKk3JY5K+nkMO4WOnncELfH8L7Aih
   KQ5hf7BB1IuaEnzBgLrshQKlPE7SjHr0rdPvH44BT180u/6av5xXJtN++
   1RAyyuio1gLW+G1QXFLnevh5uFlRDvdvXisSCAPfYM3AtHMSMswRzPmBx
   IFvwVbUiZGSTd6ZJH+510ceAeVeGILIJgktHAQBgP793A6XG91q76TuXS
   zClMnsVsRQTPtYS5G9u8LeKCeHoP62NIf+7S23Wq2fpi7tNOR5ibyvbKC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="315549359"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="315549359"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 14:26:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707823341"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="707823341"
Received: from xwang-mobl1.amr.corp.intel.com (HELO [10.212.177.221]) ([10.212.177.221])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 14:26:09 -0800
Message-ID: <f898bec4-887b-9e3f-9b10-5d70f9294c65@intel.com>
Date:   Wed, 30 Nov 2022 14:26:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
 <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
 <Y384vDcfTpTnFxx+@hirez.programming.kicks-ass.net>
 <699700de9d63fa72fda4620d052fda3427193b21.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <699700de9d63fa72fda4620d052fda3427193b21.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/22 02:02, Huang, Kai wrote:
> Thanks for input.  I am fine with 'tdx=force'.
> 
> Although, I'd like to point out KVM will have a module parameter 'enable_tdx'.
> 
> Hi Dave, Sean, do you have any comments?

That's fine.  Just keep it out of the initial implementation.  Ignore it
for now,
