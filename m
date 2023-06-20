Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89EE736BCE
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 14:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbjFTMUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 08:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbjFTMUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 08:20:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C01F1713;
        Tue, 20 Jun 2023 05:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687263620; x=1718799620;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F+HeITyySyj3YXzLM/AtaRIIghZxjYADeQkaNZHPles=;
  b=YL2MsLNTTCt7OTeTphOkjoSxlraLb2DoZ3tmSt0RKOcpGmo3tltK/T8N
   yy8c8RQTDd2ihKYdolno+aZ32116+UrHYlP+wldoqcHkJSOKQYie/t2Z4
   AhXzqpLtfbPgzTxss1AATrmg5OB/hYprScTfUnfHttbNHk4ye+b+PpU2m
   ifxUXIB8koD5cW5qZlEyJFf2qiZLVe7dNjyT9tu/ecmagx0iM2UWupKJG
   vmMCpTH3Dz7XvlMuwlI3GDkQDR/Kyz3Zp1k9P2aDlGBjDmr5FvPLAA6Tr
   5JnpI6nTiE9C5RixFChXpNBiBL4W9IxUNy1bPsFqRmOMSdJOK5JehrwKa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="357332168"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="357332168"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 05:20:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="858560189"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="858560189"
Received: from dkravtso-mobl1.ccr.corp.intel.com (HELO box.shutemov.name) ([10.252.62.180])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 05:20:14 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 30F8E10F89F; Tue, 20 Jun 2023 15:20:12 +0300 (+03)
Date:   Tue, 20 Jun 2023 15:20:12 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230620122012.mnlgko443qrpfrzg@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <759e3af5-6aec-7e50-c432-c5e0a0c3cf36@redhat.com>
 <8e7d6b83347688bb013d7ebb660d0a74a1949d52.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e7d6b83347688bb013d7ebb660d0a74a1949d52.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 10:37:16AM +0000, Huang, Kai wrote:
> > > +	/*
> > > +	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> > > +	 * the trap number.  Convert the trap number to the TDX error
> > > +	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
> > > +	 *
> > > +	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
> > > +	 * only accepts 32-bit immediate at most.
> > 
> > Not sure if that comment is really helpful here. It's a common pattern 
> > for large immediates, no?
> 
> I am not sure.  I guess I am not expert of x86 assembly but only casual writer.
> 
> Hi Dave, Kirill,
> 
> Are you OK to remove it?

I would rather keep it. I wanted to ask why separate MOV is needed here,
before I read the comment. Also size of $TDX_SW_ERROR is not visible here,
so it contributes to possible confusion without the comment.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
