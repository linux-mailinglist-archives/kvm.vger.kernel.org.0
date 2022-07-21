Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354BA57CCEC
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiGUOLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiGUOLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:11:16 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A98E52893
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:11:14 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c3so1840688pfb.13
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JdLRsvRnZXSge95hUUniiBkKTb/15qbqNRgmQFuXFpQ=;
        b=U9/GVNr7Qn7GXD9Ir8eRl7CIKSjh+S8N0xIJQVcE0Ek6IRZjcuGRrVPhycCG0BujXm
         /zs70hdIHMmYtwWARr77YGYwuAFIwyUrW68zLuF1r2iAv4SNEmdZMWsbNH+Q0Itg2dsO
         AWFV7qZl+ejmr1kHeMaKQn2V2iRlaUgOGl2fkqSLhQNcSD2NCjv+6GfvQ/Q4UgpJNQxq
         aK5s0IshYbWISsTjE5hvtlIdSq6QXbpyL8U8xHszq9rhHMjztAp07NSAo0i6hF6Txmsa
         dj0pK98iQCMIK6+A2QJD5/7Erhb2E4dU6YtKq0GPFRfbKl4GR+V5yx0mAn+/1nfvisKw
         6YcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JdLRsvRnZXSge95hUUniiBkKTb/15qbqNRgmQFuXFpQ=;
        b=NinhVHqrKBc4eEr+9Hjv8HjHPY+8aU33hfWpwBTryD/Dc3MSREpVdFQncZanFx1IUe
         N6TzFdafRN7bkUuIJOPtvaVNj8Irn93whuv1lg+w+jcWKHhUvFhLIcbHzI79kBA1qr9+
         yqbFhwRJ35nBYxfDW2xkE7mrWvRvWyfDPwLxLg5IIlUgrrg3BQUqsalw1DBo8eIdWK0F
         Tf4EKo+7gKAVfSRwEqQXFs9VdJ0wtCNJcM59oNwnfsPoP2hfXw5yPBCds/9KwvPPA5Ig
         b5VvBgur2RrFYnc+n66zE/MnOYsbQfiGXumuXVqWFrycYlAHtQGbC2MHgtmAZ8YBCbZM
         qWWQ==
X-Gm-Message-State: AJIora+6GBMhtdQHzCO3n0qpysXZsnmNd7UyyiILvIYDKGCmrqi6yvbH
        TZNrOKk7oqwf68rd4u8tTsEJqWyLSCm5jg==
X-Google-Smtp-Source: AGRyM1s01zL0Y2g/nLveXPvxylj4bvkc9N7+K/k0hCI2a45sUWQDWZ/0MowhBRo7y2SRhY5eioETrA==
X-Received: by 2002:a63:9041:0:b0:415:c0e8:c588 with SMTP id a62-20020a639041000000b00415c0e8c588mr37681722pge.282.1658412673210;
        Thu, 21 Jul 2022 07:11:13 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902778c00b0016d1f474653sm1495911pll.52.2022.07.21.07.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:11:12 -0700 (PDT)
Date:   Thu, 21 Jul 2022 14:11:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 05/11] KVM: x86: emulator: update the emulation mode
 after CR0 write
Message-ID: <YtlefGulMwp/WwKv@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-6-mlevitsk@redhat.com>
 <YtiUq7jm2Z1NTRv3@google.com>
 <532c71cbca049004bd6860508fdc056ae118ab1f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532c71cbca049004bd6860508fdc056ae118ab1f.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022, Maxim Levitsky wrote:
> On Wed, 2022-07-20 at 23:50 +0000, Sean Christopherson wrote:
> > On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > > CR0.PE toggles real/protected mode, thus its update
> > > should update the emulation mode.
> > > 
> > > This is likely a benign bug because there is no writeback
> > > of state, other than the RIP increment, and when toggling
> > > CR0.PE, the CPU has to execute code from a very low memory address.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  arch/x86/kvm/emulate.c | 13 ++++++++++++-
> > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > index 6f4632babc4cd8..002687d17f9364 100644
> > > --- a/arch/x86/kvm/emulate.c
> > > +++ b/arch/x86/kvm/emulate.c
> > > @@ -3659,11 +3659,22 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
> > >  
> > >  static int em_cr_write(struct x86_emulate_ctxt *ctxt)
> > >  {
> > > -	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
> > > +	int cr_num = ctxt->modrm_reg;
> > > +	int r;
> > > +
> > > +	if (ctxt->ops->set_cr(ctxt, cr_num, ctxt->src.val))
> > >  		return emulate_gp(ctxt, 0);
> > >  
> > >  	/* Disable writeback. */
> > >  	ctxt->dst.type = OP_NONE;
> > > +
> > > +	if (cr_num == 0) {
> > > +		/* CR0 write might have updated CR0.PE */
> > 
> > Or toggled CR0.PG.  
> 
> I thought about it but paging actually does not affect the CPU mode.

Toggling CR0.PG when EFER.LME=1 (and CR4.PAE=1) switches the CPU in and out of
long mode.  That's why I mentioned the EFER.LMA thing below.  It's also notable
in that the only reason we don't have to handle CR4 here is because clearing
CR4.PAE while long is active causes a #GP.  
 
> E.g if you are in protected mode, instructions execute the same regardless
> if you have paging or not.
> 
> (There are probably some exceptions but you understand what I mean).
> 
> Best regards,
> 	Maxim Levitsky
> 
> > It's probably also worth noting that ->set_cr() handles side
> > effects to other registers, e.g. the lack of an EFER.LMA update makes this look
> > suspicious at first glance.
