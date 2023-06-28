Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B19C74129F
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 15:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjF1Ngh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 09:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjF1Ngc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 09:36:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30737E4B;
        Wed, 28 Jun 2023 06:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ytMNkCq5mj8QRrqKEhG7DQ+40mAfpQCegQXaR8xPOy8=; b=hTq8v5SMGqKnRYTlooA05bx+Lj
        HRsozeIMcbs653IAaL+XNxCu6YICEE0b0CTdaYd0qHf4tfYBxP8Z0aiOY9+6U+6YGB4y8fMoWE82a
        tIokfXhEns2lo+ZchXhidsFn5/peKcmJyfXQsYcmVtAKNJeCxwFXhefsLPMGw1q5srfBPR4ELKInp
        SlYUXTieGCmAasREoJyoRxSY8OV0FwFTkC54mkhirbu70zX66NdujVbKpR17ENFBMubV7c2wvmx+z
        7ieoGmbW/EWfsBkNHW4jmHqREGUFRknwi501NHA8pzjGtbC7e5dC/ZghtE0Mw1hA+Eb1gwCDkj5bE
        Vq2LosxQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qEVKg-003olR-0n; Wed, 28 Jun 2023 13:35:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5432C30005E;
        Wed, 28 Jun 2023 15:35:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3B98924810076; Wed, 28 Jun 2023 15:35:41 +0200 (CEST)
Date:   Wed, 28 Jun 2023 15:35:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230628133541.GF2438817@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
 <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
 <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
 <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
 <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 12:28:12AM +0000, Huang, Kai wrote:
> On Tue, 2023-06-27 at 22:37 +0000, Huang, Kai wrote:
> > > > 
> > > > +/*
> > > > + * Do the module global initialization if not done yet.
> > > > + * It's always called with interrupts and preemption disabled.
> > > > + */
> > > 
> > > If interrupts are always disabled why do you need _irqsave()?
> > > 
> > 
> > I'll remove the _irqsave().
> > 
> > AFAICT Isaku preferred this for additional security, but this is not
> > necessary.
> > 
> > 
> 
> Damn.  I think we can change the comment to say this function is called with
> preemption being disabled, but _can_ be called with interrupt disabled.  And we
> keep using the _irqsave() version.
> 
> 	/*
> 	 * Do the module global initialization if not done yet.  It's always
> 	 * called with preemption disabled and can be called with interrupts
> 	 * disabled.
> 	 */

That's still not explaining *why*, what you want to say is:

	Can be called locally or through an IPI function call.
