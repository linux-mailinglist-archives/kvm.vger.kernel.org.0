Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E3F7461A3
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 19:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjGCR4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 13:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjGCR4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 13:56:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E1BC2;
        Mon,  3 Jul 2023 10:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688406967; x=1719942967;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tXCkUV57n+k42/6WNxCUqFu0N3OYKzthRacRkqM/8M4=;
  b=flQsM+SuVo3aJmhviTcDIZdCaLDjc8pbYcfCFHDCJl8fqyFMXat6xe0j
   8Y2cbhVxlzo7n6QTJZS6CmuBosFnEAJ8xNZMOPQkmURK3ID5jKhsQpoZs
   MCwGd3T6bYO/JPsgGjuF2DFl9pnFsrlknKq79A8KryG+yRXP3FQI7fJ+R
   uR4zwIh4RfH63ZHpTyIbxGBxAk9WQGIG1OIdTe1NtSG2TcYtG3U8NYbjs
   OeU5PZdHatu1xPIbAdT0ZaLgXMlr8YukihQzAta/4VAe8eLwA1Wu0JxMG
   jwYV92z3BQgQeDkHWaG4bFyTJt2MlblAd+9yW+WnTv0R1eAiS+DBrowzZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="342528980"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="342528980"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 10:56:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="788597117"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="788597117"
Received: from foliveix-mobl5.amr.corp.intel.com (HELO box.shutemov.name) ([10.251.218.218])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 10:55:59 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id B504410955C; Mon,  3 Jul 2023 20:55:56 +0300 (+03)
Date:   Mon, 3 Jul 2023 20:55:56 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Len Brown <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Ying Huang <ying.huang@intel.com>,
        Dan J Williams <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230703175556.nn5xozz7dzxjocqm@box.shutemov.name>
References: <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
 <20230703104942.GG4253@hirez.programming.kicks-ass.net>
 <eb83e722-0379-1451-9c9c-9b9de33cb4cb@intel.com>
 <20230703150330.GA83892@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230703150330.GA83892@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 03, 2023 at 05:03:30PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 03, 2023 at 07:40:55AM -0700, Dave Hansen wrote:
> > On 7/3/23 03:49, Peter Zijlstra wrote:
> > >> There are also latency and noisy neighbor concerns, e.g. we *really* don't want
> > >> to end up in a situation where creating a TDX guest for a customer can observe
> > >> arbitrary latency *and* potentially be disruptive to VMs already running on the
> > >> host.
> > > Well, that's a quality of implementation issue with the whole TDX
> > > crapola. Sounds like we want to impose latency constraints on the
> > > various TDX calls. Allowing it to consume arbitrary amounts of CPU time
> > > is unacceptable in any case.
> > 
> > For what it's worth, everybody knew that calling into the TDX module was
> > going to be a black hole and that consuming large amounts of CPU at
> > random times would drive people bat guano crazy.
> > 
> > The TDX Module ABI spec does have "Leaf Function Latency" warnings for
> > some of the module calls.  But, it's basically a binary thing.  A call
> > is either normal or "longer than most".
> > 
> > The majority of the "longer than most" cases are for initialization.
> > The _most_ obscene runtime ones are chunked up and can return partial
> > progress to limit latency spikes.  But I don't think folks tried as hard
> > on the initialization calls since they're only called once which
> > actually seems pretty reasonable to me.
> > 
> > Maybe we need three classes of "Leaf Function Latency":
> > 1. Sane
> > 2. "Longer than most"
> > 3. Better turn the NMI watchdog off before calling this. :)
> > 
> > Would that help?
> 
> I'm thikning we want something along the lines of the Xen preemptible
> hypercalls, except less crazy. Where the caller does:
> 
> 	for (;;) {
> 		ret = tdcall(fn, args);
> 		if (ret == -EAGAIN) {
> 			cond_resched();
> 			continue;
> 		}
> 		break;
> 	}
> 
> And then the TDX black box provides a guarantee that any one tdcall (or
> seamcall or whatever) never takes more than X ns (possibly even
> configurable) and we get to raise a bug report if we can prove it
> actually takes longer.

TDG.VP.VMCALL TDCALL can take arbitrary amount of time as it handles over
control to the host/VMM.

But I'm not quite follow how it is different from the host stopping
scheduling vCPU on a random instruction. It can happen at any point and
TDCALL is not special from this PoV.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
