Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FEE5FD53C
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 08:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiJMGwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 02:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJMGw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 02:52:29 -0400
Received: from out0-130.mail.aliyun.com (out0-130.mail.aliyun.com [140.205.0.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51013DF68;
        Wed, 12 Oct 2022 23:52:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047192;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---.Paw6veq_1665643942;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Paw6veq_1665643942)
          by smtp.aliyun-inc.com;
          Thu, 13 Oct 2022 14:52:22 +0800
Date:   Thu, 13 Oct 2022 14:52:22 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Mark transfer type as X86_TRANSFER_RET when
 loading CS in iret emulation
Message-ID: <20221013065222.GA100679@k08j02272.eu95sqa>
References: <fcaf1408d2aaaa39b33cdd3b11bf06e7e935d11a.1665565774.git.houwenlong.hwl@antgroup.com>
 <Y0bssbjJTQVB+SCg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0bssbjJTQVB+SCg@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 13, 2022 at 12:34:57AM +0800, Sean Christopherson wrote:
> On Wed, Oct 12, 2022, Hou Wenlong wrote:
> > When loading code segment descriptor in iret instruction emulation, the
> > checks are same as far return instruction emulation, so transfer type
> > should be X86_TRANSFER_RET in __load_segment_descriptor(). Although,
> > only iret in real mode is implemented now, and no checks are actually
> > needed for real mode, it would still be better to mark transfer type as
> > X86_TRANSFER_RET.
> 
> It's not strictly a RET though.  The RPL vs. DPL checks in __load_segment_descriptor()
> might do the right thing, but there's a rather large pile of stuff IRET can do that
> RET can't (ignoring the fact that KVM doesn't even emulate FAR RET to outer privilege
> levels).
>
Yes, if EFLAGS.NT is set, IRET performs a task switch instead of far return in Protected
Mode.
 
> And __emulate_int_real() also loads CS with X86_TRANSFER_NONE, i.e. KVM still has
> a weird path to worry about.
>
> Rather than make the IRET case slightly less wrong, what about adding a sanity
> check in __load_segment_descriptor() that KVM doesn't attempt to load CS in Protected
> Mode with X86_TRANSFER_NONE?
>
OK, sanity check is needed if someone wants to implement IRET in Protected Mode but
use load_segment_descriptor().

> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 3b27622d4642..fe735e18c419 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1641,6 +1641,14 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>                         goto exception;
>                 break;
>         case VCPU_SREG_CS:
> +               /*
> +                * KVM uses "none" when loading CS as part of emulating Real
> +                * Mode exceptions and IRET (handled above).  In all other
> +                * cases, loading CS without a control transfer is a KVM bug.
> +                */
> +               if (WARN_ON_ONCE(transfer == X86_TRANSFER_NONE))
> +                       goto exception;
> +
>                 if (!(seg_desc.type & 8))
>                         goto exception;
>
Do I need to prepare this patch or you will add this directly?

> > 
> > No functional change intended.
> > 
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/emulate.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 3b27622d4642..5052eb480068 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -2100,6 +2100,7 @@ static int emulate_iret_real(struct x86_emulate_ctxt *ctxt)
> >  			     X86_EFLAGS_FIXED;
> >  	unsigned long vm86_mask = X86_EFLAGS_VM | X86_EFLAGS_VIF |
> >  				  X86_EFLAGS_VIP;
> > +	u8 cpl = ctxt->ops->cpl(ctxt);
> >  
> >  	/* TODO: Add stack limit check */
> >  
> > @@ -2121,7 +2122,8 @@ static int emulate_iret_real(struct x86_emulate_ctxt *ctxt)
> >  	if (rc != X86EMUL_CONTINUE)
> >  		return rc;
> >  
> > -	rc = load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
> > +	rc = __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, cpl,
> > +				       X86_TRANSFER_RET, NULL);
> >  
> >  	if (rc != X86EMUL_CONTINUE)
> >  		return rc;
> > -- 
> > 2.31.1
> > 
