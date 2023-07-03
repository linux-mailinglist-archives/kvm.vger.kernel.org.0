Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B55C745F63
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 17:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjGCPD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 11:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjGCPD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 11:03:56 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7E1E66;
        Mon,  3 Jul 2023 08:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lqm8TMHAWxnUZDzATcGlvFdy39sG8ALavmX6CjixFQY=; b=O6AB5gQlNheuz9I5RbADZ+PUPJ
        ATvZw+X674CVJh9wuJPOYigu7eaM8Z083C4NEiKq1Si5rnvRlevUcbPxP0jcx8JZcSe1t4p6+DvMO
        WP11P0qeKkF6uNZKtoSNgnSvQfE66aXLVi91zjVih0lPLxuhl91jUUkbAiE2gxaiwX1JFUDXzVYZF
        wquoHmeV34TDMueUkhk2tqBMdnszXSsJLoH+CICY/Cy3xgP1XMWNOhj1I6vQYH28aJjo2Y9uVhUYl
        TkX7Xor/1XGCOJbhgsh1hykay1S5tOdWtpzIQ0G5qIewfazGh5bzHRwSmHP1YSA+pwfVLgsEKonIo
        OFyknsQQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qGL5Q-00A6hA-0p;
        Mon, 03 Jul 2023 15:03:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8433E300095;
        Mon,  3 Jul 2023 17:03:30 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6A2732029B0A3; Mon,  3 Jul 2023 17:03:30 +0200 (CEST)
Date:   Mon, 3 Jul 2023 17:03:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
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
Message-ID: <20230703150330.GA83892@hirez.programming.kicks-ass.net>
References: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
 <20230703104942.GG4253@hirez.programming.kicks-ass.net>
 <eb83e722-0379-1451-9c9c-9b9de33cb4cb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb83e722-0379-1451-9c9c-9b9de33cb4cb@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 03, 2023 at 07:40:55AM -0700, Dave Hansen wrote:
> On 7/3/23 03:49, Peter Zijlstra wrote:
> >> There are also latency and noisy neighbor concerns, e.g. we *really* don't want
> >> to end up in a situation where creating a TDX guest for a customer can observe
> >> arbitrary latency *and* potentially be disruptive to VMs already running on the
> >> host.
> > Well, that's a quality of implementation issue with the whole TDX
> > crapola. Sounds like we want to impose latency constraints on the
> > various TDX calls. Allowing it to consume arbitrary amounts of CPU time
> > is unacceptable in any case.
> 
> For what it's worth, everybody knew that calling into the TDX module was
> going to be a black hole and that consuming large amounts of CPU at
> random times would drive people bat guano crazy.
> 
> The TDX Module ABI spec does have "Leaf Function Latency" warnings for
> some of the module calls.  But, it's basically a binary thing.  A call
> is either normal or "longer than most".
> 
> The majority of the "longer than most" cases are for initialization.
> The _most_ obscene runtime ones are chunked up and can return partial
> progress to limit latency spikes.  But I don't think folks tried as hard
> on the initialization calls since they're only called once which
> actually seems pretty reasonable to me.
> 
> Maybe we need three classes of "Leaf Function Latency":
> 1. Sane
> 2. "Longer than most"
> 3. Better turn the NMI watchdog off before calling this. :)
> 
> Would that help?

I'm thikning we want something along the lines of the Xen preemptible
hypercalls, except less crazy. Where the caller does:

	for (;;) {
		ret = tdcall(fn, args);
		if (ret == -EAGAIN) {
			cond_resched();
			continue;
		}
		break;
	}

And then the TDX black box provides a guarantee that any one tdcall (or
seamcall or whatever) never takes more than X ns (possibly even
configurable) and we get to raise a bug report if we can prove it
actually takes longer.

Handing the CPU off to random code for random period of time is just not
a good idea, ever.
