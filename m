Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825AC747E03
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 09:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjGEHPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 03:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjGEHPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 03:15:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18410195;
        Wed,  5 Jul 2023 00:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EyW9XZN4w1C6P0MPRsEcqqMNHBYbEDNEAhyPTiwy2lQ=; b=kRH0KTcuJPnGqXJJIpV8CAvcvR
        7sGU5dzETN0Kpb4qVrjCA8NEuHmhNfAkW3SI+JGJUn0H99e8EWj2U6mK8510cx6IUX+LmorMiZhAE
        x1iw/5XhgpaGnDZmWQCS3fkR646mAeHrW4GBLVjWLebCqaL1/Tylp5XyIuZunabQ28Iueb39afHvN
        EFAJmbsa4112IrSxNgAyybSaVkGk2+Jt+sa3l9/J17J2PIBXsdb73vZdOhfbeHzEol8AO/eu6TXKW
        oG9h1h6bguhZNSP0d9wOD/eRAg4fDGJlw2tx9ovAR9BGUTSCADeVBDBK1o9x0ay2icc6GvIEV/ECH
        L2UZ+mdw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qGwim-009qlL-SN; Wed, 05 Jul 2023 07:14:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 236DA300023;
        Wed,  5 Jul 2023 09:14:39 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 066E82028F056; Wed,  5 Jul 2023 09:14:39 +0200 (CEST)
Date:   Wed, 5 Jul 2023 09:14:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
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
Message-ID: <20230705071438.GC462772@hirez.programming.kicks-ass.net>
References: <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
 <20230703104942.GG4253@hirez.programming.kicks-ass.net>
 <eb83e722-0379-1451-9c9c-9b9de33cb4cb@intel.com>
 <20230703150330.GA83892@hirez.programming.kicks-ass.net>
 <20230703175556.nn5xozz7dzxjocqm@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230703175556.nn5xozz7dzxjocqm@box.shutemov.name>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 03, 2023 at 08:55:56PM +0300, kirill.shutemov@linux.intel.com wrote:
> On Mon, Jul 03, 2023 at 05:03:30PM +0200, Peter Zijlstra wrote:
> > On Mon, Jul 03, 2023 at 07:40:55AM -0700, Dave Hansen wrote:
> > > On 7/3/23 03:49, Peter Zijlstra wrote:
> > > >> There are also latency and noisy neighbor concerns, e.g. we *really* don't want
> > > >> to end up in a situation where creating a TDX guest for a customer can observe
> > > >> arbitrary latency *and* potentially be disruptive to VMs already running on the
> > > >> host.
> > > > Well, that's a quality of implementation issue with the whole TDX
> > > > crapola. Sounds like we want to impose latency constraints on the
> > > > various TDX calls. Allowing it to consume arbitrary amounts of CPU time
> > > > is unacceptable in any case.
> > > 
> > > For what it's worth, everybody knew that calling into the TDX module was
> > > going to be a black hole and that consuming large amounts of CPU at
> > > random times would drive people bat guano crazy.
> > > 
> > > The TDX Module ABI spec does have "Leaf Function Latency" warnings for
> > > some of the module calls.  But, it's basically a binary thing.  A call
> > > is either normal or "longer than most".
> > > 
> > > The majority of the "longer than most" cases are for initialization.
> > > The _most_ obscene runtime ones are chunked up and can return partial
> > > progress to limit latency spikes.  But I don't think folks tried as hard
> > > on the initialization calls since they're only called once which
> > > actually seems pretty reasonable to me.
> > > 
> > > Maybe we need three classes of "Leaf Function Latency":
> > > 1. Sane
> > > 2. "Longer than most"
> > > 3. Better turn the NMI watchdog off before calling this. :)
> > > 
> > > Would that help?
> > 
> > I'm thikning we want something along the lines of the Xen preemptible
> > hypercalls, except less crazy. Where the caller does:
> > 
> > 	for (;;) {
> > 		ret = tdcall(fn, args);
> > 		if (ret == -EAGAIN) {
> > 			cond_resched();
> > 			continue;
> > 		}
> > 		break;
> > 	}
> > 
> > And then the TDX black box provides a guarantee that any one tdcall (or
> > seamcall or whatever) never takes more than X ns (possibly even
> > configurable) and we get to raise a bug report if we can prove it
> > actually takes longer.
> 
> TDG.VP.VMCALL TDCALL can take arbitrary amount of time as it handles over
> control to the host/VMM.
> 
> But I'm not quite follow how it is different from the host stopping
> scheduling vCPU on a random instruction. It can happen at any point and
> TDCALL is not special from this PoV.

A guest will exit on timer/interrupt and then the host can reschedule;
AFAIU this doesn't actually happen with these TDX calls, if control is
in that SEAM thing, it stays there until it's done.

