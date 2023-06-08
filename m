Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6EE728C08
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbjFHXy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237665AbjFHXyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:54:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063F130D3;
        Thu,  8 Jun 2023 16:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686268490; x=1717804490;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xZ1uRwDFiJo+JxOT813efewCSGKFi1vucjFu1ekbu3w=;
  b=FApisWgGEU4KBWZrDWJud6NLqvwXyHFBesF7YTQ8kEcs6dvEMPc2XRYc
   ZbAEDM7i60cwtmoFQUOhZzsNwC45cngeKdchkxSSv7TTvsPWdZz1/pfj3
   6C9uPiVge6mQjPRtEV5zOMXijkXO3YTpni2Jpi29xuOiIzsB9UwgfgHqV
   YbQUBdP6RyzbYapHXanwqH98bHRw7qeay68guen9BFjOkMtI5eJAPZzAG
   7Kho0JXf8d9cLlS5bvKfCIW4tGDS7mee/bJ7SQSLEHMqwcFra/cAZw9wU
   9GFwAZrBiZp6qM6tuZyoIH5HBA1r1fkRpGkdedxHu6K7rfYvguiLU3ddn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="421055483"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="421055483"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:54:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="775286493"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="775286493"
Received: from fgorter-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.59.89])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:54:43 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 659D6104C0F; Fri,  9 Jun 2023 02:54:41 +0300 (+03)
Date:   Fri, 9 Jun 2023 02:54:41 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
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
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230608235441.olqpkrwzu2hplepa@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
 <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
 <19ea7470e9d6fa698f9ad7caff3279873e530a0b.camel@intel.com>
 <20230608114128.vu75wlcojpyjak22@box.shutemov.name>
 <20230608232919.GM2244082@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608232919.GM2244082@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 04:29:19PM -0700, Isaku Yamahata wrote:
> On Thu, Jun 08, 2023 at 02:41:28PM +0300,
> "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com> wrote:
> 
> > On Thu, Jun 08, 2023 at 02:40:27AM +0000, Huang, Kai wrote:
> > > On Thu, 2023-06-08 at 03:27 +0300, kirill.shutemov@linux.intel.com wrote:
> > > > On Mon, Jun 05, 2023 at 02:27:21AM +1200, Kai Huang wrote:
> > > > > For now both 'tdsysinfo_struct' and CMRs are only used during the module
> > > > > initialization.  But because they are both relatively big, declare them
> > > > > inside the module initialization function but as static variables.
> > > > 
> > > > This justification does not make sense to me. static variables will not be
> > > > freed after function returned. They will still consume memory.
> > > > 
> > > > I think you need to allocate/free memory dynamically, if they are too big
> > > > for stack.
> > > 
> > > 
> > > I do need to keep tdsysinfo_struct as it will be used by KVM too.
> > 
> > Will you pass it down to KVM from this function? Will KVM use the struct
> > after the function returns?
> 
> KVM needs tdsysinfo_struct to create guest TD.  It doesn't require
> 1024-alignment.

How KVM gets it from here?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
