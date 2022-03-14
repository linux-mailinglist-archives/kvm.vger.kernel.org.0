Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C454D87F2
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 16:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbiCNPWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 11:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiCNPWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 11:22:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34D8B13F66
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 08:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647271281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rlWhetxs47d+8wbP0AiIKxYRMBnXFj9a44pgP9CO7tY=;
        b=SLfiiHClreOHHUkt63SrgktQSqbNqfObLTEz4Jk95qn33w+nUiA13YxLnTi36PIvmnPpA9
        73m5IsYyrOkmywExZYbgl5qnUkYFg6EAuXvbjmgfzeb+kwkAOOCkJ/Z1gBxrv8PfMsYgLg
        LmcA8BCCXCYQSB9b9wLr5vVuiZ8bJuo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-vE7okSW8NfWyTk2v-cupHQ-1; Mon, 14 Mar 2022 11:21:17 -0400
X-MC-Unique: vE7okSW8NfWyTk2v-cupHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F4843800528;
        Mon, 14 Mar 2022 15:21:16 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93067145B961;
        Mon, 14 Mar 2022 15:21:12 +0000 (UTC)
Message-ID: <b8794277078e9622c4e1d50f3ca55e785c643ddb.camel@redhat.com>
Subject: Re: [PATCH v3 5/7] KVM: x86: nSVM: implement nested vGIF
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Mon, 14 Mar 2022 17:21:11 +0200
In-Reply-To: <8c5fe4f6-49bd-c87a-e76d-64417a1370c0@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
         <20220301143650.143749-6-mlevitsk@redhat.com>
         <8c5fe4f6-49bd-c87a-e76d-64417a1370c0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-09 at 14:40 +0100, Paolo Bonzini wrote:
> The patch is good but I think it's possibly to rewrite some parts in an 
> easier way.
> 
> On 3/1/22 15:36, Maxim Levitsky wrote:
> > +	if (svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
> > +		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
> > +	else
> > +		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
> 
> To remember for later: svm->vmcb's V_GIF_ENABLE_MASK is always the same 
> as vgif:
> 
> - if it comes from vmcb12, it must be 1 (and then vgif is also 1)
> 
> - if it comes from vmcb01, it must be equal to vgif (because 
> V_GIF_ENABLE_MASK is set in init_vmcb and never touched again).
> 
> >   
> > +static bool nested_vgif_enabled(struct vcpu_svm *svm)
> > +{
> > +	if (!is_guest_mode(&svm->vcpu) || !svm->vgif_enabled)
> > +		return false;
> > +	return svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK;
> > +}
> > +
> >   static inline bool vgif_enabled(struct vcpu_svm *svm)
> >   {
> > -	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
> > +	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
> > +
> > +	return !!(vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
> >   }
> >   
> 
> Slight simplification:
> 
> - before the patch, vgif_enabled() is just "vgif", because 
> V_GIF_ENABLE_MASK is set in init_vmcb and copied to vmcb02
> 
> - after the patch, vgif_enabled() is also just "vgif".  Outside guest 
> mode the same reasoning applies.  If L2 has enabled vGIF,  vmcb01's 
> V_GIF_ENABLE is equal to vgif per the previous bullet.  If L2 has not 
> enabled vGIF, vmcb02's V_GIF_ENABLE uses svm->vmcb's int_ctl field which 
> is always the same as vgif (see remark above).
> 
> You can make this simplification a separate patch.


This is a very good idea - I'll do this in a separate patch.

> 
> >  static inline void enable_gif(struct vcpu_svm *svm)
> >  {
> > +	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
> > +
> >  	if (vgif_enabled(svm))
> > -		svm->vmcb->control.int_ctl |= V_GIF_MASK;
> > +		vmcb->control.int_ctl |= V_GIF_MASK;
> >  	else
> >  		svm->vcpu.arch.hflags |= HF_GIF_MASK;
> >  }
> >  
> >  static inline void disable_gif(struct vcpu_svm *svm)
> >  {
> > +	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
> > +
> >  	if (vgif_enabled(svm))
> > -		svm->vmcb->control.int_ctl &= ~V_GIF_MASK;
> > +		vmcb->control.int_ctl &= ~V_GIF_MASK;
> >  	else
> >  		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
> > +
> >  }
> 
> Looks good.  For a little optimization however you could write
> 
> static inline struct vmcb *get_vgif_vmcb(struct vcpu_svm *svm)
> {
> 	if (!vgif)
> 		return NULL;
> 	if (!is_guest_mode(&svm->vcpu)
> 		return svm->vmcb01.ptr;
> 	if ((svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
> 		return svm->vmcb01.ptr;
> 	else
> 		return svm->nested.vmcb02.ptr;
> }
> 
> and then
> 
> 	struct vmcb *vmcb = get_vgif_vmcb(svm);
> 	if (vmcb)
> 		/* use vmcb->control.int_ctl */
> 	else
> 		/* use hflags */

Good idea as well.

Thanks for the review!
Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> >  
> > +static bool nested_vgif_enabled(struct vcpu_svm *svm)
> > +{
> > +	if (!is_guest_mode(&svm->vcpu) || !svm->vgif_enabled)
> > +		return false;
> > +	return svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK;
> > +}
> > +


