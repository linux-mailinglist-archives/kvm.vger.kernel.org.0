Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D72C3F3819
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 04:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbhHUCbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 22:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhHUCbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 22:31:37 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C68C061756
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 19:30:58 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id c10so10353540qko.11
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 19:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ooK0DyFfmJ4kDNoGRhTDLo5fbQ6yVEecKkqRgMQgWQQ=;
        b=ITmJh1iiIU25AZkkFiZ5AE7BFomVpuseXmmGmKgpouePfNV5ggDB6cjrFuu4TLD9lC
         5+ZO+FOVYnmxA1fSDV2SCW24GaQKPhgEIgMUYAU+0RYOlY/dzN2EglyhdXlfkjtxZnMW
         zuSuoS146oCPgzF0wDQErFxcWP2FoBFOVojWvmPvgRoo8FUxNkBaOfPqn10Vj/+e0xRl
         bxU6yvs25fr48KK6gFeCup+KgI8uT+Si4t22ntUzVFdKaLBDM04odzk2f4WOFyfkzAqW
         0RGCG5fMfZQzGOIyCozL/ERUFuu2D3TYN1LTJtpT1LcwsP/08TC8ReaVLCtbOkMEdhUJ
         yZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ooK0DyFfmJ4kDNoGRhTDLo5fbQ6yVEecKkqRgMQgWQQ=;
        b=Q3MohEkXGIFMR1B7Cd82k0hdHkV3Hui2tUfqHWJHAMODj7OgPm8Aq/x5OeDNatcmj9
         bXabEutdjkp3yzi0iEGH3tboWCFHMHMegoH1VEvbLnDSXtMJNFO7uqZ7NcVaMf92/bYR
         dsP4s6ZxcQWrAHLhMvZXlJtdKnmrY8XIxcqxn0uYlLPPbtBikePnQaRnWQN1wc28sIdN
         kwfJMoyBkeeB8c//5SO3iTOdlFPcSEtOgL97V+SyNW9q7tE3avM11xYpp0IP7dFyBed0
         Sg8Hrbwjr3eo2jeygky5QYSOo6+XxN2J4w0QY7gElE+l3JDGfs5dW3Q16wWBzJ0EBCmr
         O+Cw==
X-Gm-Message-State: AOAM533B4c9/R3qNUnJldig8+ZcwZ+gWBDj8sWYQ9PYDcVOPtsMcqTJ9
        Ac+dwQjdytxBjLp8nMw435kr9DoMWlwa7emShwXd1w==
X-Google-Smtp-Source: ABdhPJzBI82AFlgMq6F3duk+Ox7U+VZVLJIBJLMMC9ts2qnK5WoE03gPHQK+On/4y9/yEHLF9jq/aA05TDO1hUQN2cA=
X-Received: by 2002:a37:45c9:: with SMTP id s192mr12038137qka.21.1629513057515;
 Fri, 20 Aug 2021 19:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210818053908.1907051-1-mizhang@google.com> <20210818053908.1907051-2-mizhang@google.com>
 <CAA03e5Ggh4gODFspxcXAU6WRe0aMCvkG794JpwvyBf6ERs_6dA@mail.gmail.com>
In-Reply-To: <CAA03e5Ggh4gODFspxcXAU6WRe0aMCvkG794JpwvyBf6ERs_6dA@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 20 Aug 2021 19:30:46 -0700
Message-ID: <CAA03e5G9LKJjJuVD3aPT-nVj58MLeXPDuPqEfnjBeWh9eC=SAg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: SVM: fix missing sev_decommission in sev_receive_start
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 7:11 PM Marc Orr <marcorr@google.com> wrote:
>
> On Tue, Aug 17, 2021 at 10:39 PM Mingwei Zhang <mizhang@google.com> wrote:
> >
> > sev_decommission is needed in the error path of sev_bind_asid. The purpose
> > of this function is to clear the firmware context. Missing this step may
> > cause subsequent SEV launch failures.
> >
> > Although missing sev_decommission issue has previously been found and was
> > fixed in sev_launch_start function. It is supposed to be fixed on all
> > scenarios where a firmware context needs to be freed. According to the AMD
> > SEV API v0.24 Section 1.3.3:
> >
> > "The RECEIVE_START command is the only command other than the LAUNCH_START
> > command that generates a new guest context and guest handle."
> >
> > The above indicates that RECEIVE_START command also requires calling
> > sev_decommission if ASID binding fails after RECEIVE_START succeeds.
> >
> > So add the sev_decommission function in sev_receive_start.
> >
> > Cc: Alper Gun <alpergun@google.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: David Rienjes <rientjes@google.com>
> > Cc: Marc Orr <marcorr@google.com>
> > Cc: John Allen <john.allen@amd.com>
> > Cc: Peter Gonda <pgonda@google.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Vipin Sharma <vipinsh@google.com>
> >
> > Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 75e0b21ad07c..55d8b9c933c3 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1397,8 +1397,10 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >
> >         /* Bind ASID to this guest */
> >         ret = sev_bind_asid(kvm, start.handle, error);
> > -       if (ret)
> > +       if (ret) {
> > +               sev_decommission(start.handle);
> >                 goto e_free_session;
> > +       }
> >
> >         params.handle = start.handle;
> >         if (copy_to_user((void __user *)(uintptr_t)argp->data,
> > --
> > 2.33.0.rc1.237.g0d66db33f3-goog
>
> Should this patch have the following Fixes tag?
>
> Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")

Oops. I missed that it already has the Fixes tag. Please ignore this comment.
