Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3784E74870D
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 16:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjGEO62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 10:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjGEO6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 10:58:24 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982BC1988;
        Wed,  5 Jul 2023 07:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K66hg10RS0xPL3sDSP6x+hgXXU7ubwcqX1w5rGjcqkQ=; b=Zh3WsjW1vqCcD+OuqBPmuZIecy
        PcdciMOT+MVMVIXVmHMPi4CulMbU/oCKAEmlanfajsmL4tOrr5jrRUOYkDWzpuwbttVmRvdQqyrkQ
        g6WDuev8lr3jltNE5qb/+XsnL0WZ8S4eyEzzPy5dV3tWmtBH3idKZO1H2Jd7PeTVQfa80M+t8bf85
        ndJTbXlsu3gj60UERjKdpI3Df/bgmYJqQDBq27r5mWzBjnerUzgYN7pW6DLyOAHzJo4+k5+UEEvj6
        3YsiG0Timevwn32rycrD0ZU8ZyitIF0AWWk5bkwZcu1DoembCkV4k4ghbd70J+//Cwq8q+g5JjmWF
        PcxuOZkQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qH3x2-00CBot-2S;
        Wed, 05 Jul 2023 14:57:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 188B93001E7;
        Wed,  5 Jul 2023 16:57:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 025E72025BA45; Wed,  5 Jul 2023 16:57:50 +0200 (CEST)
Date:   Wed, 5 Jul 2023 16:57:50 +0200
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
Message-ID: <20230705145750.GD4253@hirez.programming.kicks-ass.net>
References: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
 <20230704165836.GB462772@hirez.programming.kicks-ass.net>
 <1a8099e2-da28-6b2a-7b5a-1d6346b7f95d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a8099e2-da28-6b2a-7b5a-1d6346b7f95d@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 07:34:06AM -0700, Dave Hansen wrote:
> On 7/4/23 09:58, Peter Zijlstra wrote:
> > If we have concerns about allocating the PAMT array, can't we use CMA
> > for this? Allocate the whole thing at boot as CMA such that when not
> > used for TDX it can be used for regular things like userspace and
> > filecache pages?
> 
> I never thought of CMA as being super reliable.  Maybe it's improved
> over the years.
> 
> KVM also has a rather nasty habit of pinning pages, like for device
> passthrough.  I suspect that means that we'll have one of two scenarios:
> 
>  1. CMA works great, but the TDX/CMA area is unusable for KVM because
>     it's pinning all its pages and they just get moved out of the CMA
>     area immediately.  The CMA area is effectively wasted.
>  2. CMA sucks, and users get sporadic TDX failures when they wait a long
>     time to run a TDX guest after boot.  Users just work around the CMA
>     support by starting up TDX guests at boot or demanding a module
>     parameter be set.  Hacking in CMA support was a waste.
> 
> Am I just too much of a pessimist?

Well, if CMA still sucks, then that needs fixing. If CMA works, but we
have a circular fail in that KVM needs to long-term pin the PAMT pages
but long-term pin is evicted from CMA (the whole point of long-term pin,
after all), then surely we can break that cycle somehow, since in this
case the purpose of the CMA is being able to grab that memory chunk when
we needs it.

That is, either way around is just a matter of a little code, no?
