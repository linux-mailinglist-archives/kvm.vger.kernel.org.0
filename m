Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFBD72DF11
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 12:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjFMKTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 06:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbjFMKTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 06:19:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704F613A;
        Tue, 13 Jun 2023 03:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686651548; x=1718187548;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PQ9SSE+dMfofmg/Jm7X/ua46UeTu5f5xwyyaNzG+ZSc=;
  b=fM/mHGb6GDnk/g60hDBkrzcGWKFb6bZ9K/d399yZ7NbvDlXlDXQsrn3y
   l/as1yhkHZ/EW/IOKjJ4oK4Mwu9O/ieW7b1Abfch5zJ3kWzqdYwXjuhHq
   fa2N7JArtO/fCyAqSp4BGouU3DgL81LSUIxqwn2UstiQATfJXqExnHJDj
   HKx8htr1jENkSol3shFen6PUgtq69+UlXXjBSAbGTd4nRKBmgYQTAqozw
   D/88WANQDE5tg0FetMkMCqphRO+REQErM8ah4Wc8nBpAOBDOK5m/s6Tpp
   TU2O9M6+pJWEGVUnX/SRQxvNEaQ2yWt4Y/Zg+8sQxcKF4fdNsc+30LrTN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="360769962"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="360769962"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 03:19:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="1041703071"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="1041703071"
Received: from attilavx-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.62.33])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 03:19:02 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id B7E8D10BB6B; Tue, 13 Jun 2023 13:18:59 +0300 (+03)
Date:   Tue, 13 Jun 2023 13:18:59 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Message-ID: <20230613101859.lwqlwa4t72sthvwk@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
 <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
 <ddbcadf36016bb60a695f54b28f5c9e9af53a07f.camel@intel.com>
 <201af662-f700-9145-c113-563e378074ad@intel.com>
 <89c99e7360dc2acfe5fb56c2bbb40e074e1f94d5.camel@intel.com>
 <20230612143355.sur7zc7byu7omxal@box.shutemov.name>
 <3e188621d97af794f03072e5261dcc9f589900aa.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e188621d97af794f03072e5261dcc9f589900aa.camel@intel.com>
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

On Mon, Jun 12, 2023 at 10:10:39PM +0000, Huang, Kai wrote:
> On Mon, 2023-06-12 at 17:33 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Mon, Jun 12, 2023 at 02:33:58AM +0000, Huang, Kai wrote:
> > > 
> > > > 
> > > > Maybe not even a pr_warn(), but something that's a bit ominous and has a
> > > > chance of getting users to act.
> > > 
> > > Sorry I am not sure how to do.  Could you give some suggestion?
> > 
> > Maybe something like this would do?
> > 
> > I'm struggle with the warning message. Any suggestion is welcome.
> 
> I guess it would be helpful to print out the actual consumed TDMRs?
> 
> 	pr_warn("consumed TDMRs reaching limit: %d used (out of %d)\n",
>                                               tdmr_idx, tdmr_list->max_tdmrs);

It is off-by-one. It supposed to be tdmr_idx + 1.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
