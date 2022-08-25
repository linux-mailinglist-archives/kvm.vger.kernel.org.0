Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65025A15FD
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 17:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242879AbiHYPof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 11:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiHYPoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 11:44:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9406AB8F14
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:44:31 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s206so18250317pgs.3
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=lkpFp7wJllz+fu6eLPih5PvFqPT3ByhDxfAjsVV14FA=;
        b=cxKhA2ZbI3qXBQ9J+dqf+awbKPsIqG7QTdGumRHtTPcq9s0h7GNthbM7hPWbG6mCDv
         8/pYm7f6tUspB31Zwg2WJZ8uHQleKkQ52ZvYmhq8uqjErHNyUJkH/taj+xN8vVhjcQAi
         k0Y+3sLbmE1w88vY6ibS21WxKF8re4nG4jCA49WQUz1OEbLOE/5q5kmtWxPdfXILiamo
         HjRy/Pq1kccl8sQNSf/wNFM8XMtCEii4LQZSBp/WXn9XIuRug9EiQYvGcsDUp5sP6UpM
         T5gpUy3FYWnvpzmCpeLmlvSPowgKziH4/evG2QP/aS5qCpPmCCC/63gpDNzy1qvwhvLs
         N0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=lkpFp7wJllz+fu6eLPih5PvFqPT3ByhDxfAjsVV14FA=;
        b=hjiVGprmX/vumLAV0EEIHnDoR+FxqVbC1DAGJ7owQbXmGxdqmfKMMdBSX0Ckjh+qms
         Hdwd4GxjvTn98QFI+hRL0VYVTUwByUd2tAuSPWnH18E2sZ2bT6YMbscZNUwetwTxHhFV
         he0iO2yjQaSmjuraNxuNLKPNWyUmkYBKpmeFXYD1z2mxpangHgG8XnrFUSZbAXgen6LZ
         GdcWgf3FeeScqVRLQvALLMmDzWOi9vjupCyz3wP5uHPVPeafkIrBun6lgAVcMs10EZZ0
         Tq3nU+ow98tEArT+ZDoiJF+UYfTxg555YsOqqRdrdCWhQ+zG/O8pUlQ4xH5XA5sqPYtO
         tP8A==
X-Gm-Message-State: ACgBeo3JFKiUGPJJi2WAVb3K3HsnhBYvtPEr7p1YI2UO9isyd8l1jGJq
        9TaKhzZV6AuZpqRHbOLDQh+SvQ==
X-Google-Smtp-Source: AA6agR6pNtBQmLkgZI3GWUgKVHKnaml7ulQEiPPiXi3GubMmqdy7n2xLch86HRK5F1F+AbDo8czUnQ==
X-Received: by 2002:a63:88c1:0:b0:42b:49b3:3a7f with SMTP id l184-20020a6388c1000000b0042b49b33a7fmr3400773pgd.64.1661442270940;
        Thu, 25 Aug 2022 08:44:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z6-20020a63e106000000b0042a2777550dsm12434721pgh.47.2022.08.25.08.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:44:30 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:44:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/13] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
Message-ID: <YweY2oiE1BVy1Ruu@google.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
 <20220803155011.43721-14-mlevitsk@redhat.com>
 <Ywa5K3qVO0kDfTW9@google.com>
 <a3a4e22f3f2fd0b8582f233d0c34c8460f0dae6f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3a4e22f3f2fd0b8582f233d0c34c8460f0dae6f.camel@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-24 at 23:50 +0000, Sean Christopherson wrote:
> > On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> > > @@ -518,7 +519,8 @@ struct kvm_smram_state_32 {
> > >  	u32 reserved1[62];
> > >  	u32 smbase;
> > >  	u32 smm_revision;
> > > -	u32 reserved2[5];
> > > +	u32 reserved2[4];
> > > +	u32 int_shadow; /* KVM extension */
> > 
> > Looking at this with fresh(er) eyes, I agree with Jim: KVM shouldn't add its own
> > fields in SMRAM.  There's no need to use vmcb/vmcs memory either, just add fields
> > in kvm_vcpu_arch to save/restore the state across SMI/RSM, and then borrow VMX's
> > approach of supporting migration by adding flags to do out-of-band migration,
> > e.g. KVM_STATE_NESTED_SMM_STI_BLOCKING and KVM_STATE_NESTED_SMM_MOV_SS_BLOCKING.
> > 
> > 	/* SMM state that's not saved in SMRAM. */
> > 	struct {
> > 		struct {
> > 			u8 interruptibility;
> > 		} smm;
> > 	} nested;
> > 
> > That'd finally give us an excuse to move nested_run_pending to common code too :-)
> > 
> Paolo told me that he wants it to be done this way (save the state in the
> smram).

Paolo, what's the motivation for using SMRAM?  I don't see any obvious advantage
for KVM.  QEMU apparently would need to migrate interrupt.shadow, but QEMU should
be doing that anyways, no?

> My first version of this patch was actually saving the state in kvm internal
> state, I personally don't mind that much if to do it this way or another.
> 
> But note that I can't use nested state - the int shadow thing has nothing to
> do with nesting.

Oh, duh.

> I think that 'struct kvm_vcpu_events' is the right place for this, and in fact it already
> has interrupt.shadow (which btw Qemu doesn't migrate...)
> 
> My approach was to use upper 4 bits of 'interrupt.shadow' since it is hightly unlikely
> that we will ever see more that 16 different interrupt shadows.

Heh, unless we ensure STI+MOVSS are mutually exclusive... s/16/4, because
KVM_X86_SHADOW_INT_* are currently treated as masks, not values.

Pedantry aside, using interrupt.shadow definitely seems like the way to go.  We
wouldn't even technically need to use the upper four bits since the bits are KVM
controlled and not hardware-defined, though I agree that using bits 5 and 6 would
give us more flexibility if we ever need to convert the masks to values.

> It would be a bit more clean to put it into the 'smi' substruct, but we already
> have the 'triple_fault' afterwards 
> 
> (but I think that this was very recent addition - maybe it is not too late?)
> 
> A new 'KVM_VCPUEVENT_VALID_SMM_SHADOW' flag can be added to the struct to indicate the
> extra bits if you want.
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> 
