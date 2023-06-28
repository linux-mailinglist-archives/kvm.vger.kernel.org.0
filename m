Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9362741061
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 13:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjF1Lug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 07:50:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:53903 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbjF1Luf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 07:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687953035; x=1719489035;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0y2L7BWu5pxHd+qe15FseOMCJGFMdnLrhdBLfYvItgU=;
  b=dQ4XId+VHqpPH1pXJe0bkvF6CaCueVbI4tE4deREFv15erUelqor8lJ7
   65sb6sfSbUZw95tgr9t5CN0kxRF4M3tOGEF/sYoSLC1QvbtdiuyleDu4d
   bXw5ElB5SKNl6EOfOqix78l9kjvtcOlm6SE5nUcJK2l5b5DO5D214l3ju
   nhGPp8QG2j8XrmqMYP6PmJQgcr32BNBhOYUJ8IbOQeWXarazOQgyHZ734
   rLkYOQWlIJQN1dhLZHngvXUlhVvr4UR5XHpdxrjnQMJminc3NuVR2q6pl
   MN6Tlfn9QxpsGAByvoRaDEGboqMXLTiWKCbYYBp66YBXdVJE13LUtBDVP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="427828650"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="427828650"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 04:50:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="782254879"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="782254879"
Received: from rajritu-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.47.187])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 04:50:25 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 7D4761095C8; Wed, 28 Jun 2023 14:50:22 +0300 (+03)
Date:   Wed, 28 Jun 2023 14:50:22 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Gao, Chao" <chao.gao@intel.com>,
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
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230628115022.2plia6tonmxxaj5x@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
 <ZJukd/bnkffgsQzT@chao-email>
 <7c4b54cbbb887a3b7e468819a2cf11f7434674cc.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c4b54cbbb887a3b7e468819a2cf11f7434674cc.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 03:34:05AM +0000, Huang, Kai wrote:
> On Wed, 2023-06-28 at 11:09 +0800, Chao Gao wrote:
> > > +/*
> > > + * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
> > > + * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> > > + * leaf function return code and the additional output respectively if
> > > + * not NULL.
> > > + */
> > > +static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64
> > > r9,
> > > +				    u64 *seamcall_ret,
> > > +				    struct tdx_module_output *out)
> > > +{
> > > +	u64 sret;
> > > +	int cpu;
> > > +
> > > +	/* Need a stable CPU id for printing error message */
> > > +	cpu = get_cpu();
> > > +	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> > > +	put_cpu();
> > > +
> > > +	/* Save SEAMCALL return code if the caller wants it */
> > > +	if (seamcall_ret)
> > > +		*seamcall_ret = sret;
> > 
> > Hi Kai,
> > 
> > All callers in this series pass NULL for seamcall_ret. I am no sure if
> > you keep it intentionally.
> 
> In this series all the callers doesn't need seamcall_ret.

I'm fine keeping it if it is needed by KVM TDX enabling. Otherwise, just
drop it.

> > > +
> > > +	switch (sret) {
> > > +	case 0:
> > > +		/* SEAMCALL was successful */
> > 
> > Nit: if you add
> > 
> > #define TDX_SUCCESS	0
> > 
> > and do
> > 
> > 	case TDX_SUCCESS:
> > 		return 0;
> > 
> > then the code becomes self-explanatory. i.e., you can drop the comment.
> 
> If using this, I ended up with below:
> 
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -23,6 +23,8 @@
>  #define TDX_SEAMCALL_GP                        (TDX_SW_ERROR | X86_TRAP_GP)
>  #define TDX_SEAMCALL_UD                        (TDX_SW_ERROR | X86_TRAP_UD)
>  
> +#define TDX_SUCCESS           0
> +
> 
> Hi Kirill/Dave/David,
> 
> Are you happy with this?

Sure, looks good.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
