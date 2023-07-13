Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AFE751F1B
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbjGMKkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbjGMKj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:39:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE7A1BFB;
        Thu, 13 Jul 2023 03:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RGWiHPH2+ZEm4azekOzq5SLUvXL6kF7cN7yMOiGExus=; b=JKZOJ4x1CIfR1NN9pq2Eexy56E
        ZnRZckblEqHnPJOW4jadEfACb4Gy8pBAtwZqt8PHzXEFledXs9YL2Fg/mhfuIxcvE5/iKCB+o+r84
        tbDgI90AySN5OzOD+WX/vo2g9dYGv2WkEN/+wQN3MiioW3r0YHbQT8LH8cF8ATC6n5UQlDFDyvuIF
        ipr5Fl5CMc1PU+UzqJJYO9MKjHiZgz5seo9vLSbxz7hjSsANyIXjUDdBQhqecLDJcPu/BxfKSJb7L
        GRB687ywBCWH8m+DxGVbkijVHMKe6P87OJ4l/WsEI0+KLr4FiD0nKDSRbp3D9Zd3l3cl9TjCWwJ8L
        Mi2e0XoQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJtje-0003cv-Jx; Thu, 13 Jul 2023 10:39:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 41B8D300362;
        Thu, 13 Jul 2023 12:39:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 29C9E245CA111; Thu, 13 Jul 2023 12:39:46 +0200 (CEST)
Date:   Thu, 13 Jul 2023 12:39:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Message-ID: <20230713103946.GG3139243@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
 <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
 <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
 <cc5b4df23273b546225241fae2cbbea52ccb13d3.camel@intel.com>
 <20230713084324.GA3138667@hirez.programming.kicks-ass.net>
 <5cc5ba09636647a076206fae932bbf88f233b8b2.camel@intel.com>
 <a2218af09553f89674d3ba3d59db31d2521745e3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2218af09553f89674d3ba3d59db31d2521745e3.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 10:24:48AM +0000, Huang, Kai wrote:
> On Thu, 2023-07-13 at 10:19 +0000, Huang, Kai wrote:
> > On Thu, 2023-07-13 at 10:43 +0200, Peter Zijlstra wrote:
> > > On Thu, Jul 13, 2023 at 08:02:54AM +0000, Huang, Kai wrote:
> > > 
> > > > Sorry I am ignorant here.  Won't "clearing ECX only" leave high bits of
> > > > registers still containing guest's value?
> > > 
> > > architecture zero-extends 32bit stores
> > 
> > Sorry, where can I find this information? Looking at SDM I couldn't find :-(
> > 
> > 
> 
> Hmm.. I think I found it -- it's in SDM vol 1:
> 
> 3.4.1.1 General-Purpose Registers in 64-Bit Mode
> 
> 32-bit operands generate a 32-bit result, zero-extended to a 64-bit result in
> the destination general-purpose register.

Yes, that's it.
