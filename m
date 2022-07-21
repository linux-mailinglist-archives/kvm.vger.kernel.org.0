Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33DC57C9FE
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiGULxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiGULxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:53:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D94CA7B7B6
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PaTMkS9CUmeszJi8ZetWqsZilZKnUJOSPYJnnbmFWaY=;
        b=eqymAJQ8GZCva3mB7g1RKtXnb9lr3NIrcZTqihkAKFmQ00Yw1EhSq09JRR3PKXcQGgr0dv
        b5T8g/B7XSGI/UBqDnHvDi+ZNqDF080F+XmO+JmcSJXknftTZJK4UID06Ni87Ew5Dd7LOs
        w60ckgqEZb3XCtuHXy+FKadchztoF1Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-VGu78coLOd-ZkuUkM_nzLQ-1; Thu, 21 Jul 2022 07:53:48 -0400
X-MC-Unique: VGu78coLOd-ZkuUkM_nzLQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B978C8115B1;
        Thu, 21 Jul 2022 11:53:47 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B63C401E92;
        Thu, 21 Jul 2022 11:53:44 +0000 (UTC)
Message-ID: <532c71cbca049004bd6860508fdc056ae118ab1f.camel@redhat.com>
Subject: Re: [PATCH v2 05/11] KVM: x86: emulator: update the emulation mode
 after CR0 write
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
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
Date:   Thu, 21 Jul 2022 14:53:43 +0300
In-Reply-To: <YtiUq7jm2Z1NTRv3@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-6-mlevitsk@redhat.com> <YtiUq7jm2Z1NTRv3@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-20 at 23:50 +0000, Sean Christopherson wrote:
> On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > CR0.PE toggles real/protected mode, thus its update
> > should update the emulation mode.
> > 
> > This is likely a benign bug because there is no writeback
> > of state, other than the RIP increment, and when toggling
> > CR0.PE, the CPU has to execute code from a very low memory address.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/emulate.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 6f4632babc4cd8..002687d17f9364 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -3659,11 +3659,22 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
> >  
> >  static int em_cr_write(struct x86_emulate_ctxt *ctxt)
> >  {
> > -	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
> > +	int cr_num = ctxt->modrm_reg;
> > +	int r;
> > +
> > +	if (ctxt->ops->set_cr(ctxt, cr_num, ctxt->src.val))
> >  		return emulate_gp(ctxt, 0);
> >  
> >  	/* Disable writeback. */
> >  	ctxt->dst.type = OP_NONE;
> > +
> > +	if (cr_num == 0) {
> > +		/* CR0 write might have updated CR0.PE */
> 
> Or toggled CR0.PG.  

I thought about it but paging actually does not affect the CPU mode.

E.g if you are in protected mode, instructions execute the same regardless
if you have paging or not.

(There are probably some exceptions but you understand what I mean).

Best regards,
	Maxim Levitsky

> It's probably also worth noting that ->set_cr() handles side
> effects to other registers, e.g. the lack of an EFER.LMA update makes this look
> suspicious at first glance.

> 
> > +		r = update_emulation_mode(ctxt);
> > +		if (r != X86EMUL_CONTINUE)
> > +			return r;
> > +	}
> > +
> >  	return X86EMUL_CONTINUE;
> >  }
> >  
> > -- 
> > 2.26.3
> > 


