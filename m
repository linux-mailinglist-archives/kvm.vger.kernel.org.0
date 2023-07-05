Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F20B747E0C
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 09:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjGEHQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 03:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjGEHQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 03:16:47 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1801A1;
        Wed,  5 Jul 2023 00:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oCduNboc+Z/GXu+P5K5ealCYvHJhr9bE/XTSWcyXYU0=; b=DtgGzn/2iSyk4rAQZePuRpGrwP
        tiTKW4fXbZoL5ClSF9V2NGWi/WsughnUEr2tOkB/UdVD/mQZn/A5E17x0ns6HhTO3EQaRWitIsMJz
        tVBfwrwQffccXTlAZHZrP1V/mHRU0v17phRidBMyycSxaZiHDx9ScTZFrkkcoGFBdO73PQH0TR0lo
        N8IcFt/OyUVlRayNpaetJJiANLqdGgtnif1Z+kXRuod7x1wA5Ptcc9oxRcXbYVYd7xn6KqotWcn4c
        8lXvixxvB4D4MQklglElM/POaFZxTMgAdMTbtDcKMJPVyz/WKwhTQ1N+oXAhwR+q8mqr257XbIiHy
        ZWq57E/Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qGwkH-00Bzsx-1z;
        Wed, 05 Jul 2023 07:16:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B2ABD300274;
        Wed,  5 Jul 2023 09:16:12 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A1E2C2028F056; Wed,  5 Jul 2023 09:16:12 +0200 (CEST)
Date:   Wed, 5 Jul 2023 09:16:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230705071612.GD462772@hirez.programming.kicks-ass.net>
References: <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
 <20230704165836.GB462772@hirez.programming.kicks-ass.net>
 <0bd5a2f95a0f309ff35d511ce832c5f11abf6013.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bd5a2f95a0f309ff35d511ce832c5f11abf6013.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 04, 2023 at 09:50:22PM +0000, Huang, Kai wrote:
> On Tue, 2023-07-04 at 18:58 +0200, Peter Zijlstra wrote:
> > On Fri, Jun 30, 2023 at 02:24:56PM -0700, Sean Christopherson wrote:
> > 
> > > Waiting until userspace attempts to create the first TDX guest adds complexity
> > > and limits what KVM can do to harden itself.  Currently, all feature support in
> > > KVM is effectively frozen at module load.  E.g. most of the setup code is
> > > contained in __init functions, many module-scoped variables are effectively 
> > > RO after init (though they can't be marked as such until we smush kvm-intel.ko
> > > and kvm-amd.ko into kvm.ko, which is tentatively the long-term plan).  All of
> > > those patterns would get tossed aside if KVM waits until userspace attempts to
> > > create the first guest.
> > 
> > ....
> > 
> > People got poked and the following was suggested:
> > 
> > On boot do:
> > 
> >  TDH.SYS.INIT
> >  TDH.SYS.LP.INIT
> >  TDH.SYS.CONFIG
> >  TDH.SYS.KEY.CONFIG
> > 
> > This should get TDX mostly sorted, but doesn't consume much resources.
> > Then later, when starting the first TDX guest, do the whole
> > 
> >  TDH.TDMR.INIT
> > 
> > dance to set up the PAMT array -- which is what gobbles up memory. From
> > what I understand the TDH.TDMR.INIT thing is not one of those
> > excessively long calls.
> 
> The TDH.TDMR.INIT itself has it's own latency requirement implemented in the TDX
> module, thus it only initializes a small chunk  (1M I guess) in each call. 
> Therefore we need a loop to do bunch of TDH.TDMR.INIT in order to initialize all
> PAMT entries for all TDX-usable memory, which can be time-consuming.

Yeah, so you can put a cond_resched() in that loop and all is well, you
do not negatively affect other tasks. Because *that* was the concern
raised.
