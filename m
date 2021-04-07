Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DD435767A
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhDGVH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 17:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhDGVH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 17:07:28 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65818C061760
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 14:07:18 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g15so244125pfq.3
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 14:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ACcswK5hU55dpZ58cn4BLPhKcaAA2GLfa/PW9xI9wxw=;
        b=k2NjqpAAfq8AL2/ymsES3ygYDyep6qtZj7Jr/0Ef/MrWol3C+q9Faa9HNB1kHTOpbw
         ViU6QdmOV2GsCLfmXVIk1EmHkE4Gsr7I6/r+3X0xCRdAhHz+aec5Zly5EogstASwg83W
         qDQajuqeElWiobeaGXRmVVJBZJr/udWhMkqwXn7E/JMYeW3XtFaSOqtL5cRPs3NUpH6E
         glJIVgOz+ACksC5Jei05LhdwnJKYrw8qTec6aXuBayZWv7Yd2jPl4EmdoPsRyefvnvDL
         Yf9Gjh1WAM7hrQNhdg43/u+MkwRn0mQeFPwi3y/AIM8XueDbeWDirc9LaFHUXV683NNv
         bSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ACcswK5hU55dpZ58cn4BLPhKcaAA2GLfa/PW9xI9wxw=;
        b=LF4KyenNFlB10nQrvOd017qakD+M9n8kShIiqaVfOhtuXNj1+tkvBu6fM+5ODl6us7
         X8Cp8yEkGVHg/aQiBxB+NAcJmRHIllt3T+4s8SM+5mDKYVDs/AP8HiH2JGUTDL0TOhL/
         ZI7CcI/rqsxriNBLFSXih6SauEM48IvPdMx9v/yy4v4CSfLRJfT4jNTOMR9WVOW7sqFx
         YGoJPzgMLt7PzjhLCrAskk9kw0by7u8sX1z1/BUIL2isv97GXEvNHSc42IpwylAqn1F9
         akVZ7qlA2VAW8n4mdaBsp61wiuqyJpr6CY4auWRoyoK+M7DTq/BDLSx7lgdiNOcpxvaN
         tmzg==
X-Gm-Message-State: AOAM531WDFNWZGX/lD4Ub80RItYxiENPCsnBee/JHAR/w2nbzCIjgeN4
        g4d/H/A8c/ZTzKxL8+OJl5aZxudrgN6a6g==
X-Google-Smtp-Source: ABdhPJymaQU7TAe9TM/9iV99KZ4gYN4DNbSqjCPBQ6QuLx0Z1Kg3WUOOMU8TqwpTa0EW8fNmr9FB3g==
X-Received: by 2002:a63:ea50:: with SMTP id l16mr5225262pgk.70.1617829637653;
        Wed, 07 Apr 2021 14:07:17 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id e6sm22162624pgh.17.2021.04.07.14.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 14:07:16 -0700 (PDT)
Date:   Wed, 7 Apr 2021 21:07:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Make sure GHCB is mapped before updating
Message-ID: <YG4fAeaTy0HdHCsT@google.com>
References: <03b349cb19b360d4c2bbeebdd171f99298082d28.1617820214.git.thomas.lendacky@amd.com>
 <YG4RSl88TSPccRfj@google.com>
 <d46ee7c3-6c8c-1f06-605c-c4f2d1888ba4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d46ee7c3-6c8c-1f06-605c-c4f2d1888ba4@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021, Tom Lendacky wrote:
> On 4/7/21 3:08 PM, Sean Christopherson wrote:
> > On Wed, Apr 07, 2021, Tom Lendacky wrote:
> >> From: Tom Lendacky <thomas.lendacky@amd.com>
> >>
> >> The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
> >> the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
> >> However, if a SIPI is performed without a corresponding AP Reset Hold,
> >> then the GHCB may not be mapped, which will result in a NULL pointer
> >> dereference.
> >>
> >> Check that the GHCB is mapped before attempting the update.
> > 
> > It's tempting to say the ghcb_set_*() helpers should guard against this, but
> > that would add a lot of pollution and the vast majority of uses are very clearly
> > in the vmgexit path.  svm_complete_emulated_msr() is the only other case that
> > is non-obvious; would it make sense to sanity check svm->ghcb there as well?
> 
> Hmm... I'm not sure if we can get here without having taken the VMGEXIT
> path to start, but it certainly couldn't hurt to add it.

Yeah, AFAICT it should be impossible to reach the callback without a valid ghcb,
it'd be purely be a sanity check.
 
> I can submit a v2 with that unless you want to submit it (with one small
> change below).

I'd say just throw it into v2.

> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 019ac836dcd0..abe9c765628f 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2728,7 +2728,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
> >  {
> >         struct vcpu_svm *svm = to_svm(vcpu);
> > -       if (!sev_es_guest(vcpu->kvm) || !err)
> > +
> > +       if (!err || !sev_es_guest(vcpu->kvm) || !WARN_ON_ONCE(svm->ghcb))
> 
> This should be WARN_ON_ONCE(!svm->ghcb), otherwise you'll get the right
> result, but get a stack trace immediately.

Doh, yep.
