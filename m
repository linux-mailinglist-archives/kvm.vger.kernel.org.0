Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742F84952D9
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 18:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377207AbiATREV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 12:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347546AbiATREQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 12:04:16 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9718FC06161C
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:04:16 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id u10so1604524pfg.10
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X+dlhCbZ1T5bEOv35DYnl7QCyW3kKdcFIjuIjbSmC1g=;
        b=St3JnP6QUs2HRDevifufDbBMbF0cWX2WnRDleOvqov0iUtvDBmX+Fb1SteYzmz+sEq
         /bFyQ7jeNbQIjcpNeMGkfGM0bMw2XgcMVKd5VQe47fXv2k+as7+Iok3mRNyMHYZaYPSj
         uVECXjRj6XczcuM7iwuNuiLizJWgY4WEQ9SN+MfF+avoFFN0e0OuVJqN0jN6aDg8gcuv
         ROIdN+/QWovhjXk9+7/90qv/SYD4IX3D3h1e3z3eqSr6Fi2t2gvYED6Fvjyss5+ngs24
         KVK4/TdXAU1yQjYHFBFYiPCTb2Ocj08DKDYs9jKoEwIrFZBzsxA12ihbVFEQl0OhC96g
         X2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X+dlhCbZ1T5bEOv35DYnl7QCyW3kKdcFIjuIjbSmC1g=;
        b=tp0bQz4MONC/oE37314h29HS2lqzJAkpi3z/QmZwcscktFUc9FziS2bmUL68mZWwlE
         RUFvbVSWVxVbaXtpPSWNMzMUIeLigY1uK+WBIWKWvIC/cFDp7uT1fdfqyn84D7YEk9z8
         OQzja6THwP633h9i87tnQ1/Ja526XIpCmoGyoflyniBPCzY6qIf1A7JmOJTvMsXbT0p9
         YrOTHo24Q9Dpx0lyVX3qidYlZVlPiH/AOKW9iSTpoYD6hwEXH4LZcOiRKvO/3tUI66Qn
         ryWvs3wGKwdreZnYzHsrPL12pVOZ/PfZGJ54UzXxkmoj7dS7jP4BIi5XUxEC2dJWlOzM
         c66w==
X-Gm-Message-State: AOAM532Un+gxrAW7Fo3NGyeaFDnkR5gOHluxD77ho5ov8t8Mqo+OX1VU
        IZYfBvzW4ee/mpPdMA6og09YYQ==
X-Google-Smtp-Source: ABdhPJzFn3mYlfxXIvBSzOPt1u8pptmsUxahomIWS83zSxjIk1TcuWEgX+FYkyvyadwpq8zn9db2mQ==
X-Received: by 2002:a63:f508:: with SMTP id w8mr17788070pgh.152.1642698255953;
        Thu, 20 Jan 2022 09:04:15 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h14sm4366518pfh.95.2022.01.20.09.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 09:04:15 -0800 (PST)
Date:   Thu, 20 Jan 2022 17:04:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Liam Merwick <liam.merwick@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 6/9] KVM: SVM: WARN if KVM attempts emulation on #UD or
 #GP for SEV guests
Message-ID: <YemWCwhQ8aYcqUw9@google.com>
References: <20220120010719.711476-1-seanjc@google.com>
 <20220120010719.711476-7-seanjc@google.com>
 <483ed34e-3125-7efb-1178-22f02173667a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483ed34e-3125-7efb-1178-22f02173667a@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022, Liam Merwick wrote:
> On 20/01/2022 01:07, Sean Christopherson wrote:
> > WARN if KVM attempts to emulate in response to #UD or #GP for SEV guests,
> > i.e. if KVM intercepts #UD or #GP, as emulation on any fault except #NPF
> > is impossible since KVM cannot read guest private memory to get the code
> > stream, and the CPU's DecodeAssists feature only provides the instruction
> > bytes on #NPF.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 994224ae2731..ed2ca875b84b 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4267,6 +4267,9 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
> >   	if (!sev_guest(vcpu->kvm))
> >   		return true;
> > +	/* #UD and #GP should never be intercepted for SEV guests. */
> > +	WARN_ON_ONCE(emul_type & (EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP));
> 
> What about EMULTYPE_TRAP_UD_FORCED?

Hmm, yeah, it's worth adding, there's no additional cost.  I was thinking it was
a modifier to EMULTYPE_TRAP_UD, but it's a replacement specifically to bypass
the EmulateOnUD check (which I should have remembered since I added the type...).
