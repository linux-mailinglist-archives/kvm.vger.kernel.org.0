Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CA3743943
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjF3KXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjF3KXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:23:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F65E2974;
        Fri, 30 Jun 2023 03:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688120586; x=1719656586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XOJWnYkaajaycqJGspwc8mIlN3y/eWtpUL/gkm1GaoA=;
  b=Zuku41uDgP47883htCNpVJcIbCeZSTMwsHTKQx+REGJ2S1DPdTuV/XSb
   v0tKZaDzFaJ8BbzTGIleK/ffbFXGGXaGamK/CCTG61YGJ4Tqrk9DRmEL7
   V48Y4gDQVOq8vkSgCs0J/gwRo9Hir3aRqWQ+lZdsTeXLjrceblCKI+G0C
   YwojCtLyzZHLfdfb3sA/bIwKnaMhHRwjZeheYpR7DuZfVsaPKB+9TqHx4
   lDi2i4mseZak+yo9vQfmqogb/c/cnogD1SGpbCfGz8ryaRm7LflRvhrrD
   cV4qTXfa3PXBHfOaRyXOMH+NrKP4EuHMKZKQJonSxvLgCr9jJ+YfxpZ5F
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="362403551"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="362403551"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 03:23:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="787678202"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="787678202"
Received: from valeriik-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.49.47])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 03:22:57 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 7005D109754; Fri, 30 Jun 2023 13:22:54 +0300 (+03)
Date:   Fri, 30 Jun 2023 13:22:54 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230630102254.gb36e77w4m4obx4b@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <20230628211132.GS38236@hirez.programming.kicks-ass.net>
 <20230628211641.GT38236@hirez.programming.kicks-ass.net>
 <20230630090309.6mnsvfhcptekmzfu@box.shutemov.name>
 <84e13c5e32f001b8c79f0f18fe18f3225cf47dfb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84e13c5e32f001b8c79f0f18fe18f3225cf47dfb.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 10:02:32AM +0000, Huang, Kai wrote:
> 
> > 
> > I'm okay either way.
> > 
> > Obviously, arch/x86/coco/tdx/tdcall.S has to be patched to use the new
> > TDX_MODULE_CALL macro.
> > 
> 
> Cool then we have consensus.
> 
> Kirill will you do the patch(es), or you want me to do?

Please, do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
