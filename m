Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A437419CF
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 22:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjF1UlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 16:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjF1UlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 16:41:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD501FF7;
        Wed, 28 Jun 2023 13:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q74U9h5cJqAF7kQMrqejEwYKPbZZwynJrbUyaN3UMdk=; b=U7ven3j1n/AGEZHnBs70CiAm3c
        IFp7vZgZH+yI7tHPmRDhAxOv2CZ4gCjKF9xF4GFFql17CQMcuZsdavKL+gcE2vidJElANCkN/8Nlp
        2Wi1Mxv7uQu7+LMDHIpCxsmPRFaciMupyA2OtLGyMmPZK3R+wiSQCLj3z19/8StnPgL1++XOAQOS8
        Zm4KNBKwkc32cbwqyYjVZpp4wAMQtDJfxRPhUH2DlnwKFk6ZmIYyfJj7mDbnGRbWIgDUIo8M72um9
        gTIhGZf2TIGG6gfoSjXoe3/DZawyJWKyubvPt63WJDlpJBmXc+ZlzlbsSKsW657uHq2vLD9F7d0vU
        ffz4ertQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qEbvl-004CII-F8; Wed, 28 Jun 2023 20:38:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 317E33002C5;
        Wed, 28 Jun 2023 22:38:23 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 18B8C214D80C3; Wed, 28 Jun 2023 22:38:23 +0200 (CEST)
Date:   Wed, 28 Jun 2023 22:38:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ashok.raj@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230628203823.GR38236@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 05:29:01PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 27, 2023 at 02:12:50AM +1200, Kai Huang wrote:
> > diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> > index 49a54356ae99..757b0c34be10 100644
> > --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> > +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> > @@ -1,6 +1,7 @@
> >  /* SPDX-License-Identifier: GPL-2.0 */
> >  #include <asm/asm-offsets.h>
> >  #include <asm/tdx.h>
> > +#include <asm/asm.h>
> >  
> >  /*
> >   * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
> > @@ -45,6 +46,7 @@
> >  	/* Leave input param 2 in RDX */
> >  
> >  	.if \host
> > +1:
> >  	seamcall
> 
> So what registers are actually clobbered by SEAMCALL ? There's a
> distinct lack of it in SDM Vol.2 instruction list :-(

With the exception of the abomination that is TDH.VP.ENTER all SEAMCALLs
seem to be limited to the set presented here (c,d,8,9,10,11) and all
other registers should be available.

Can we please make that a hard requirement, SEAMCALL must not use
registers outside this? We can hardly program to random future
extentions; we need hard ABI guarantees here.

That also means we should be able to use si,di for the cmovc below.

Kirill, back when we did __tdx_hypercall() we got bp removed as a valid
register, the 1.0 spec still lists that, and it is also listed in
TDH.VP.ENTER, I'm assuming it will be removed there too?

bp must not be used -- it violates the pre-existing calling convention.

