Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414CF72F9FD
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 12:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243215AbjFNKD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 06:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjFNKD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 06:03:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C5186;
        Wed, 14 Jun 2023 03:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686737005; x=1718273005;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dN70DPRIIm8Vru/aWZ0BgD3rW447BgWLjBzsIad6I7E=;
  b=eKxIEltac2TLWFFXydULkGPTT2mbcu6CGBFLG5H7kK079Z8asCcuXFNZ
   jBj4H1lC1rsO8I3Zb/WryxBZvxPLQdKGrTkgyqPu7GCsTTaHXn6GclBro
   SKq1JT/DQdOvyKIs4qlB5O/SXYwQjUaFehibmW4PW/kXJVaWtcVL8Uhyl
   Aek5wSw8LHVyiFnqR88WntQYLg7wROimXzg4VdUYav714RnnCcoyJiZwV
   IV8LHVYa1O/kPtSkj8Dp8EfTTmu10Gmqz6gLCs7sJz15AEOAyqZejQKV3
   6L8tkyMFpFUeJGm+ZcsWmaiHD892CYHSnJ/AkEtSvwH5SJxDS+1SIpWpQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="422174745"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="422174745"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 03:03:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="662346663"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="662346663"
Received: from wlwpo-8.amr.corp.intel.com (HELO box.shutemov.name) ([10.251.211.89])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 03:03:06 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id A3D2710A069; Wed, 14 Jun 2023 13:02:45 +0300 (+03)
Date:   Wed, 14 Jun 2023 13:02:45 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Message-ID: <20230614100245.3vehux365zou3ze6@box>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <d3df3a9fa3075066558dd3bc84ef76ab3747185b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3df3a9fa3075066558dd3bc84ef76ab3747185b.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 09:33:45AM +0000, Huang, Kai wrote:
> On Mon, 2023-06-05 at 02:27 +1200, Kai Huang wrote:
> > --- a/arch/x86/kernel/reboot.c
> > +++ b/arch/x86/kernel/reboot.c
> > @@ -720,6 +720,7 @@ void native_machine_shutdown(void)
> >  
> >  #ifdef CONFIG_X86_64
> >  	x86_platform.iommu_shutdown();
> > +	x86_platform.memory_shutdown();
> >  #endif
> >  }
> 
> Hi Kirill/Dave,
> 
> I missed that this solution doesn't reset TDX private for emergency restart or
> when reboot_force is set, because machine_shutdown() isn't called for them.
> 
> Is it acceptable?  Or should we handle them too?

Force reboot is not used in kexec path, right? And the platform has to
handle erratum in BIOS to reset memory status on reboot anyway.

I think we should be fine. But it worth mentioning it in the commit
message.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
