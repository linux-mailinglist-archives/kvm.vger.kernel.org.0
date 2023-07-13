Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFCD751A18
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 09:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjGMHm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 03:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjGMHm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 03:42:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02AF2108;
        Thu, 13 Jul 2023 00:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=kTKp92nMORKUni0dDHjGU0PJGOsCJq93jIUVcsPJDLw=; b=PG+QC7QZT8c+wHG7QXMZtiU7Iy
        ns+yBDoctmpQZtLYxx8Jh9fErsXo4fYvBoNvzrEiiSndGFfr/bH5n73gubATb70OgYYjgLd8HEuEg
        LEEbJCb7EURr0jtB8Iq0U1kOrfZ6StJPQafc/fycSi8g6+wXwkxULR9L6/Oi3RWFjIs5ksIhRUjV+
        8HPV7UlgLkogadF3uFtCQcSgp4TMw3pco0zEcmU34g+rP3kro6LVtryBS2u4Hs22A6bv9fyLSZNGt
        eU6AhoJuG27LpS/37Sr6ztYuoP5dgUBegqL2/IzxGH4RBpLZAOjWU0XQ/e3cOCoeTFBzUuDziyXbg
        m5AQX5xA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJqxi-00HWIH-GC; Thu, 13 Jul 2023 07:42:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DA6BB300222;
        Thu, 13 Jul 2023 09:42:04 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C17F9245CA115; Thu, 13 Jul 2023 09:42:04 +0200 (CEST)
Date:   Thu, 13 Jul 2023 09:42:04 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
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
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Message-ID: <20230713074204.GA3139243@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
 <20230712221510.GG3894444@ls.amr.corp.intel.com>
 <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 03:46:52AM +0000, Huang, Kai wrote:
> On Wed, 2023-07-12 at 15:15 -0700, Isaku Yamahata wrote:
> > > The SEAMCALL ABI is very similar to the TDCALL ABI and leverages much
> > > TDCALL infrastructure.  Wire up basic functions to make SEAMCALLs for
> > > the basic TDX support: __seamcall(), __seamcall_ret() and
> > > __seamcall_saved_ret() which is for TDH.VP.ENTER leaf function.
> > 
> > Hi.  __seamcall_saved_ret() uses struct tdx_module_arg as input and output.  For
> > KVM TDH.VP.ENTER case, those arguments are already in unsigned long
> > kvm_vcpu_arch::regs[].  It's silly to move those values twice.  From
> > kvm_vcpu_arch::regs to tdx_module_args.  From tdx_module_args to real registers.
> > 
> > If TDH.VP.ENTER is the only user of __seamcall_saved_ret(), can we make it to
> > take unsigned long kvm_vcpu_argh::regs[NR_VCPU_REGS]?  Maybe I can make the
> > change with TDX KVM patch series.
> 
> The assembly code assumes the second argument is a pointer to 'struct
> tdx_module_args'.  I don't know how can we change __seamcall_saved_ret() to
> achieve what you said.  We might change the kvm_vcpu_argh::regs[NR_VCPU_REGS] to
> match 'struct tdx_module_args''s layout and manually convert part of "regs" to
> the structure and pass to __seamcall_saved_ret(), but it's too hacky I suppose.

I suspect the kvm_vcpu_arch::regs layout is given by hardware; so the
only option would be to make tdx_module_args match that. It's a slightly
unfortunate layout, but meh.

Then you can simply do:

	__seamcall_saved_ret(leaf, (struct tdx_module_args *)vcpu->arch->regs);


