Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD0B748412
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjGEMVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 08:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjGEMVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 08:21:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9E1E7B;
        Wed,  5 Jul 2023 05:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a6Nk9N28tpATSH0+5KW2Z9yQf6QWBdI+heV4d9bxsB0=; b=ivKX9HIxU6riK0WSJJLdyvIgi2
        NDlZ7qZXzS17fOW9w9bzF9Du8/Ufbc80Igg4RSTEICzPPV0nFt76M+5nXerfm06XUHbfY9IEMlRqQ
        K6tjcAW6984NHdAzcKNrrRGw2zJb6EO5DB/MuvOeWirPLarZtFiA1Pho3RjZ2aryLUso7Qpfh+EQU
        J+igUWGpKw8f2vrOojdndQAAoue7f4CzaODAmJp1aS1cZvy8+jOEGIXcytLalcj5/5dDmWHDVg8T+
        NMuYbXYK/b5DkrNLG4KKQnygswV4ID4EvTp7HDwgv0PWKl0v8WnDPa2qjfRCwEaoMcJfi0iC0tcir
        YZqIVtqw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qH1VN-00A3sQ-HN; Wed, 05 Jul 2023 12:21:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2126630012F;
        Wed,  5 Jul 2023 14:21:09 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0A4BB2022DED3; Wed,  5 Jul 2023 14:21:09 +0200 (CEST)
Date:   Wed, 5 Jul 2023 14:21:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230705122109.GA4253@hirez.programming.kicks-ass.net>
References: <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
 <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
 <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
 <20230630120650.GB2534364@hirez.programming.kicks-ass.net>
 <fdd81fbd2424d8da04f98d156668cad5e73c740b.camel@intel.com>
 <20230705102137.GX4253@hirez.programming.kicks-ass.net>
 <ab3dea02892920cd6640a31a9c846afd6c6a9d54.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab3dea02892920cd6640a31a9c846afd6c6a9d54.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 11:34:53AM +0000, Huang, Kai wrote:

> Yeah I think from long-term's view, since SEAMCALLs to support live migration
> pretty much uses all RCX/RDX/R8-R15 as input/output, it seems reasonable to
> unify all of them, although I guess there might be some special handling to
> VP.VMCALL and/or VP.ENTER, e.g., below:
> 
>         /* TDVMCALL leaf return code is in R10 */                              
>         movq %r10, %rax

Well, that's a problem fo whoever does tdcall(0, &args), no?

But did I say it had a crap calling convention already?
