Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4474840B
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 14:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjGEMTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 08:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjGEMTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 08:19:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5918199;
        Wed,  5 Jul 2023 05:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZBre0g3T1mcgEtkinxsB/uoAXz8ZMrPHkJlWIM1M77A=; b=TG2cXPGtjDPuRohKGQ7FFcgcnz
        yy7Wboha5BtCIh5QyCVQVSLA+npV9WYK+6ISz4sxLcCPm3FjxHL5pQSL2MwjC+M7qfgfxjjZ3Wlj4
        vAw8klij1kOJeqGb2eEsYx44AWGsS0u2vT5NiC09ZDaBcqpLiY0qxuvyZbFpp++oD92+J1yYxheCv
        G61n8lItcz3FLWozuuUSizvFPklOcxjS33w2Zwqp21PfKYBVMMySyh7MuwS5Ec3bGyRZ0Ux+PPuxi
        lAGXZKEmskubUXdJhdll17bgxfQLhSqAwx70+OrQU30mpcoBFgJ4RnkKY0xE6S7HznL8yluwQ2ghw
        iz6ft95g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qH1Te-00A3o9-Mw; Wed, 05 Jul 2023 12:19:22 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4352A300023;
        Wed,  5 Jul 2023 14:19:21 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2CAC62022DED3; Wed,  5 Jul 2023 14:19:21 +0200 (CEST)
Date:   Wed, 5 Jul 2023 14:19:21 +0200
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
Message-ID: <20230705121921.GZ4253@hirez.programming.kicks-ass.net>
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
> 
> So long-termly, I don't have objection to that.  But my thinking is for the
> first version of TDX host support, we don't have to support all SEAMCALLs but
> only those involved in basic TDX support. 

Since those calls are out now, we should look at them now, there is no
point in delaying the pain. That then gives us two options:

 - we accept them and their wonky calling convention and our code should
   be ready for it.

 - we reject them and send the TDX team a message to please try again
   but with a saner calling convention.

Sticking our head in the sand and pretending like they don't exist isn't
really a viable option at this point.

> Also, the new SEAMCALLs to handle live migration all seem to have below
> statement:
> 
> 	AVX, AVX2	May be reset to the architectural INIT state
> 	and
> 	AVX512
> 	state
> 
> Which means those SEAMCALLs need to preserve AVX* states too?

Yes, we need to ensure the userspace 'FPU' state is saved before
we call them. But I _think_ that KVM already does much of that.

> And reading the spec, the VP.VMCALL and VP.ENTER also can use XMM0 - XMM15 as
> input/output.  Linux VP.VMCALL seems doesn't support using XMM0 - XMM15 as
> input/output, but KVM can run other guest OSes too so I think KVM VP.ENTER needs
> to handle XMM0-XMM15 as input/output too.

Why would KVM accept VMCALLs it doesn't know about? Just trash the
guest and call it a day.

> That being said, I think although we can provide a common asm macro to cover
> VP.ENTER, I suspect KVM still needs to do additional assembly around the macro
> too.  So I am not sure whether we should try to cover VP.ENTER.

Not sure about asm, we have interfaces to save the XMM/AVX regs.
kernel_fpu_begin() comes to mind, but I know there's more of that,
including some for KVM specifically.

> > I don't think they should be special, they're really just yet another
> > leaf call. Yes, they have a shit calling convention, and yes VP.ENTER is
> > terminally broken for unconditionally clobbering BP :-(
> > 
> > That really *must* be fixed.
> 
> Sure I don't have objection to this, and for VP.ENTER please see above.
> 
> But I'd like to say that, generally speaking, from virtualization's point of
> view, guest has its own BP and conceptually the hypervisor needs to restore
> guest's BP before jumping to the guest.  E.g., for normal VMX guest, KVM always
> restores guest's BP before VMENTER (arch/x86/kvm/vmx/vmenter.S):
> 
> SYM_FUNC_START(__vmx_vcpu_run)
>         push %_ASM_BP
>         mov  %_ASM_SP, %_ASM_BP
> 	
> 	...
> 	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
> 	...
> 	vmenter/vmresume
> 	...
> SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
> 	.....
> 	mov %_ASM_BP, VCPU_RBP(%_ASM_AX)
> 	...
> 	pop %_ASM_BP
>         RET

That's disgusting :/ So what happens if we get an NMI after VMENTER and
before POP? Then it sees a garbage BP value.

Why is all this stuff such utter crap?

