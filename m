Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF0B743940
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjF3KWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjF3KWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:22:04 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB4D2705;
        Fri, 30 Jun 2023 03:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HZTty5miVE3pLFaCbNCICtFycZZgvwRIvYM0pV9affk=; b=mr5w8p5kFvbz0qkVhJwLHaS4gB
        GnYulcZDw17ZUPFMeM6y7Op7khTnbhx8ozRYLZsQH54W5wygIBv6uMjs+VJYNwo56SZJ7bpgWHBDX
        slnIxzMdV43ozSNjwC3T+nHdnJNYRSlnKLVmbAolWhBWTjFn28pNMiSyo035DDo7AZIRB5YNO6UtD
        gr8MIP22HNB1+dhFTNbyKqxx/EWlnFGG7F4QM+GOqkgdu9LXuAxtSzrv1E/kZ1Iyc9IxGGpUzA5A8
        SOz3pGsdN7uzW+eET3vi06wjGGRVyRg8eeG4ks+b8aBqeNODpGys8xfRXC6UspjjKWSYlz5fa9mr2
        rXr6Z0zQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qFBG3-007x7D-1G;
        Fri, 30 Jun 2023 10:21:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 06C69300023;
        Fri, 30 Jun 2023 12:21:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DEF7924819474; Fri, 30 Jun 2023 12:21:41 +0200 (CEST)
Date:   Fri, 30 Jun 2023 12:21:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
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
Message-ID: <20230630102141.GA2534364@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
 <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 12:07:00PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 29, 2023 at 10:33:38AM +0000, Huang, Kai wrote:

> > Looking at the later versions of TDX spec (with TD live migration, etc), it
> > seems they are already using R12-R13 as SEAMCALL output:
> > 
> > https://cdrdv2.intel.com/v1/dl/getContent/733579
> 
> Urgh.. I think I read an older versio because I got bleeding eyes from
> all this colour coded crap.
> 
> All this red is unreadable :-( Have they been told about the glories of
> TeX and diff ?
> 
> > E.g., 6.3.15. NEW: TDH.IMPORT.MEM Leaf
> > 
> > It uses R12 and R13 as input.
> 
> 12 and 14. They skipped 13 for some mysterious raisin.

Things like TDH.SERVTD.BIND do use R13.

> But also, 10,11 are frequently used as input with this new stuff, which
> already suggests the setup from your patches is not tenable.


TDG.SERVTD.RD *why* can't they pass that TD_UUID as a pointer? Using *4*
registers like that is quite insane.

TDG.VP.ENTER :-(((( that has b,15,si,di as additional output.

That means there's not a single register left unused. Can we still get
this changed, please?!?


