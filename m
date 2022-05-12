Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1708F524EA9
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 15:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354483AbiELNse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354630AbiELNsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 09:48:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B621365419
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 06:48:29 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so4960207pjm.1
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 06:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XTqMxjhIn1jUYYr1ALo/DlLRk85oazw41UC3366CUb8=;
        b=GvsJmFSDZ8o6LCBH9Mh693vukltHnjMOfIqFhUvMvJ5uCsr9QEwSealT+7LMhnD9Re
         J3nZi/kBiWke6QhoZkiRj665ZZFvNmN2BNpvPl7/3Nq/sgyCtVZ0UOh2+18vGbb/Gto+
         llEpMW2tvaZDtDYDIJLU3Rp0EmU5QZn+s38sNfkhrLzyp5eB1k9lJWYkNTDOI0EmsVWp
         14R5tyC6LiV1ac+rplvCkfUtvlvH969p7HYEzf/tFi46OfGMs0vAkfiyGAItVIjYnd5d
         1DDHTsnnGLE+f4friRNmecLMqyIxXjDstrQ8suLfYU2J9zaZyBtYdB/QTn/CpMzdr0Dw
         3nBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XTqMxjhIn1jUYYr1ALo/DlLRk85oazw41UC3366CUb8=;
        b=moGjSWnIOqe1FyuxGbvCnzo+KewNQ4Smb8BJi30IzImJYIijPBNQme5PdIlJPQoSL8
         UkEhwlhJYczHCLSlSJ1wd7TRTmTMOL2vDKsgsPl8jCavzMkfsxhTAcTHXJoiTIExG6OZ
         FmApskR7Ak3f4McP4OpuLXRPFHu1NaK0QXBvVP2a6E1yApcVOl0EEeSEW4A7mkNIJ9jR
         08UvLLKD2aVg69cbM3GPLzBfray8tjQ9GaZYMXqgfTGOfc/7KGL8A9msklQBI/1o8LfV
         whPBe32FieiDuYpYNxO6Ole7LxVl6HqAl/PFHP5Wcn9l8InsBe/WEY/sqHkyD1YIfn7O
         Rpwg==
X-Gm-Message-State: AOAM531Tj2mZadgIwHyqi1vgO7VFUim4DADZiOen5wRF/dF5eUz1z7n2
        EGDbTbPWCAncOb5HUvNv9M78Qg==
X-Google-Smtp-Source: ABdhPJzDUqaIXEhvnG8IhUWq92AKD62nGUZqhCw5quZuMX5Qj+KxHqlevZNiH9NM06UtEv2FfmTeBw==
X-Received: by 2002:a17:90b:4a12:b0:1de:c82d:7cda with SMTP id kk18-20020a17090b4a1200b001dec82d7cdamr8082711pjb.9.1652363308844;
        Thu, 12 May 2022 06:48:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x189-20020a6286c6000000b0050dc762815dsm3780751pfd.55.2022.05.12.06.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 06:48:28 -0700 (PDT)
Date:   Thu, 12 May 2022 13:48:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: x86: fix a typo in __try_cmpxchg_user that caused
 cmpxchg to be not atomic
Message-ID: <Yn0QKHKKibBP2V0F@google.com>
References: <20220202004945.2540433-5-seanjc@google.com>
 <20220512101420.306759-1-mlevitsk@redhat.com>
 <875ymayl55.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875ymayl55.fsf@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > Fixes: 1c2361f667f36 ("KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses")
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Yes, this is the root cause of the TDP mmu leak I was doing debug of in the last week.
> > Non working cmpxchg on which TDP mmu relies makes it install two differnt shadow pages
> > under same spte.

Ewww, as in running a buggy L0 resulted in a CMPXCHG going sideways in L1?  That's
awful.  My apologies :-(

> In case the fix is not squashed with 1c2361f667f36, the above should
> really go before '---'.
> 
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 8ee8c91fa7625..79cabd3d97d22 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7329,7 +7329,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
> >  		goto emul_write;
> >  
> >  	hva = kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa));
> > -	if (kvm_is_error_hva(addr))
> > +	if (kvm_is_error_hva(hva))
> 
> Looks like a typo indeed, so
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Yep, if this doesn't get squashed

Reviewed-by: Sean Christopherson <seanjc@google.com>
