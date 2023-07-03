Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA52745A98
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 12:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjGCKuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 06:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjGCKuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 06:50:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFFDC9;
        Mon,  3 Jul 2023 03:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Egmu4PcPG3YUkJp0tRZXJg7Ab4Gnh+DI3c4ffyVSY8s=; b=pLAZXR4pPvwfWO7Q6+RO4iVkSC
        89KdYHUbzmv52oZQsddS68kNrKO1gS5HWOJ3mSnbApbQElGUoYWa1FfYTQZiGGdGI7ZoRuh3BiM5Z
        NakSPE6FSa14WvGpHUKF6yh1/t9P7ZZqJ6CEGahY/kTmKNkKRmsdgkGhV9AuIqrfQOvC6DmH6Jyl7
        rgjJXdZBkj6XzBWdJC3kpV4JdCfV5Uvyib6Ix/fEoPmxFhOqhpUO5EXwEc1hHr7eM1+6soamrBdPH
        v355zIJglpkIRxKLkOVR+Q1tMAwkYQI/nij73qxWfoDB3GdWaFKYRjiZzDvot+3V2cr1mrUrT5/w3
        bS4DQ97Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qGH7n-008A7x-Ed; Mon, 03 Jul 2023 10:49:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BDA463002E1;
        Mon,  3 Jul 2023 12:49:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A4CAF202A2A17; Mon,  3 Jul 2023 12:49:42 +0200 (CEST)
Date:   Mon, 3 Jul 2023 12:49:42 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20230703104942.GG4253@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ9IKALhz1Q6ogu1@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 02:24:56PM -0700, Sean Christopherson wrote:

> I dunno about that, *totally* killing TDX would make my life a lot simpler ;-)

:-)

> > > I don't get this obsession with doing at module load time :/
> 
> Waiting until userspace attempts to create the first TDX guest adds complexity
> and limits what KVM can do to harden itself.  Currently, all feature support in
> KVM is effectively frozen at module load.  E.g. most of the setup code is
> contained in __init functions, many module-scoped variables are effectively 
> RO after init (though they can't be marked as such until we smush kvm-intel.ko
> and kvm-amd.ko into kvm.ko, which is tentatively the long-term plan).  All of
> those patterns would get tossed aside if KVM waits until userspace attempts to
> create the first guest.

Pff, all that is perfectly possible, just a wee bit more work :-) I
mean, we manage to poke text that's RO, surely we can poke a variable
that supposedly RO.

And I really wish we could put part of the kvm-intel/amd.ko things in
the kernel proper and reduce the EXPORT_SYMBOL surface -- we're
exporting a whole bunch of things that really shouldn't be, just for KVM
:/

> The userspace experience would also be poor, as KVM can't know whether or TDX is
> actually supported until the TDX module is fully loaded and configured.

Quality that :-(

> There are also latency and noisy neighbor concerns, e.g. we *really* don't want
> to end up in a situation where creating a TDX guest for a customer can observe
> arbitrary latency *and* potentially be disruptive to VMs already running on the
> host.

Well, that's a quality of implementation issue with the whole TDX
crapola. Sounds like we want to impose latency constraints on the
various TDX calls. Allowing it to consume arbitrary amounts of CPU time
is unacceptable in any case.

> Userspace can workaround the second and third issues by spawning a dummy TDX guest
> as early as possible, but that adds complexity to userspace, especially if there's
> any desire for it to be race free, e.g. with respect to reporting system capabilities
> to the control plan.

FWIW, I'm 100% behind pushing complexity into userspace if it makes for
a simpler kernel.

> On the flip side, limited hardware availability (unless Intel has changed its
> tune) and the amount of enabling that's required in BIOS and whatnot makes it
> highly unlikely that random Linux users are going to unknowingly boot with TDX
> enabled.
> 
> That said, if this is a sticking point, let's just make enable_tdx off by default,

OK.
