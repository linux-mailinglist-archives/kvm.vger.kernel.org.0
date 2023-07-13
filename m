Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0A0751C9F
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjGMJFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjGMJE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:04:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609AE35BC;
        Thu, 13 Jul 2023 02:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=ecb3dsTnizPLwQBPga+sFZir+8eVUnbKQ5zrkRJr7LU=; b=wFg5Y+l4Y9PhmrSvFvL4bww7kC
        GNLtl27AOL0D7JC0UtgKHSPb/v0OfjZAMNCTbJCYNXqSuUy8AUURrue2CqPamV8D0Gr3yQLladZQE
        zBHmMaflzleVlKasyUWeJLDOFiA1ol/aK7zpzHeJvapMtEAfuoQ+gsENGTBlcQkEA4ufkIk/3ZCcG
        wYIYCX6Yq5XONoPgiOKT7QCnPQpGEBRGrJNIFHGxs3bS0LBqWNSZPVDtppjDclMirFP+D1oCxKHzK
        fNOu7phwNuFSwhCR3ZpNi5hecAoF31kPulw4FX3P51I92lkDzbTRCAE7gUMS0sFDWVpGi+dnr9Ldr
        RBn+egiQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJsEW-00HaXc-DP; Thu, 13 Jul 2023 09:03:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0265030058D;
        Thu, 13 Jul 2023 11:03:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DE8D2245CA111; Thu, 13 Jul 2023 11:03:31 +0200 (CEST)
Date:   Thu, 13 Jul 2023 11:03:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Message-ID: <20230713090331.GD3138667@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
 <20230712221510.GG3894444@ls.amr.corp.intel.com>
 <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
 <20230713074204.GA3139243@hirez.programming.kicks-ass.net>
 <d4887818532e1716b5dd8a08819c656ab4e4c5bf.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4887818532e1716b5dd8a08819c656ab4e4c5bf.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 08:18:09AM +0000, Huang, Kai wrote:
> On Thu, 2023-07-13 at 09:42 +0200, Peter Zijlstra wrote:
> > On Thu, Jul 13, 2023 at 03:46:52AM +0000, Huang, Kai wrote:
> > > On Wed, 2023-07-12 at 15:15 -0700, Isaku Yamahata wrote:
> > > > > The SEAMCALL ABI is very similar to the TDCALL ABI and leverages much
> > > > > TDCALL infrastructure.  Wire up basic functions to make SEAMCALLs for
> > > > > the basic TDX support: __seamcall(), __seamcall_ret() and
> > > > > __seamcall_saved_ret() which is for TDH.VP.ENTER leaf function.
> > > > 
> > > > Hi.  __seamcall_saved_ret() uses struct tdx_module_arg as input and output.  For
> > > > KVM TDH.VP.ENTER case, those arguments are already in unsigned long
> > > > kvm_vcpu_arch::regs[].  It's silly to move those values twice.  From
> > > > kvm_vcpu_arch::regs to tdx_module_args.  From tdx_module_args to real registers.
> > > > 
> > > > If TDH.VP.ENTER is the only user of __seamcall_saved_ret(), can we make it to
> > > > take unsigned long kvm_vcpu_argh::regs[NR_VCPU_REGS]?  Maybe I can make the
> > > > change with TDX KVM patch series.
> > > 
> > > The assembly code assumes the second argument is a pointer to 'struct
> > > tdx_module_args'.  I don't know how can we change __seamcall_saved_ret() to
> > > achieve what you said.  We might change the kvm_vcpu_argh::regs[NR_VCPU_REGS] to
> > > match 'struct tdx_module_args''s layout and manually convert part of "regs" to
> > > the structure and pass to __seamcall_saved_ret(), but it's too hacky I suppose.
> > 
> > I suspect the kvm_vcpu_arch::regs layout is given by hardware; so the
> > only option would be to make tdx_module_args match that. It's a slightly
> > unfortunate layout, but meh.
> > 
> > Then you can simply do:
> > 
> > 	__seamcall_saved_ret(leaf, (struct tdx_module_args *)vcpu->arch->regs);
> > 
> > 
> 
> I don't think the layout matches hardware, especially I think there's no
> "hardware layout" for GPRs that are concerned here.  They are just for KVM
> itself to save guest's registers when the guest exits to KVM, so that KVM can
> restore them when returning back to the guest.

Either way around it should be possible to make them match I suppose.
Ideally we get the callee-clobbered regs first, but if not, I don't
think that's too big of a problem.


