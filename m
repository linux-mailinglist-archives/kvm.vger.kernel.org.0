Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3907E3B939C
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhGAPCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 11:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbhGAPCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 11:02:02 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8EDC061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 07:59:32 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id b2so7588473oiy.6
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 07:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ltmhFCjb1WelitfArWc9DX2nLRCgQFqidnyjLJbZMyU=;
        b=EkW9I5Hw9T7Mg3qzdaW7TNoGNc0FAw7z/Tz693senj6TSQVMaoO9C5+G8no3WO5QUQ
         L/3hqNEzTF6sgam0DWFKbhtrIjPGIDPyk/Raok4vgFbuOJr495w7U4MLaEwOmLFmIQFV
         ii7a5JdB0xwrhdXAC1RLPkqwhUOEina074K8j/o9J3k3aExEf6ttdrH/Pns2+zVcPSc/
         /pm9JxrevtuwcYWahKFxt7SLlH9PGvUHVy7NDOOw5PozStUs3Zjan5fhTN4Hj4cxZYm5
         0YZvxxFfmx3gQbeMrI5zR85IiPb87texys/4CID3lZIyineyDFZrp9QI9zdgTp90wU+6
         dCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ltmhFCjb1WelitfArWc9DX2nLRCgQFqidnyjLJbZMyU=;
        b=MvuvGSnhDp/DUs74yz92HpESw8ZLQRk8zDhk4wPKhGuRGi4TOzSmLuLlfJ9ehdQVw+
         6eBFfjSRIXqo3SwrEZnS7m3M4klWYMdQa6Il4PMXzJvAZCUkgoE8ESWrWnSK433q4kU6
         ZmUDybSc/lPeSPG9DtfPOk4VVEwFSHw4GLXFT2jRJqHah04YIe6wqVMpkB35LI2xSPkr
         MLby+DHVEz06+WY5fxGcrNM0jQI1m0GG2B7kVeun1nvuzQiq80uLElvE9Z4PPoYYrDhV
         KCQsYl+mpM0qDcVNLg2QMk8kuHYL+p3OAd8fUOK9T2fKXqDkSC3g6deBMpsjWEIFjw+1
         LDvQ==
X-Gm-Message-State: AOAM532bNftEazxW4t45es8u4XVudS0ukwy+6csMOQt2kSG1udmPgwjN
        RIsiN2wjMvmq5A1SCayWRxwpqDKqGc9RbWP+L1FXXg==
X-Google-Smtp-Source: ABdhPJz7kZwgKADNdRptSCOhsnXccXkQQ52LRN1EzbPnXhsc9AMzr4LE8wtsRq7OyE83M21OVEMR1Sch+UK6Br6X3iE=
X-Received: by 2002:a05:6808:158b:: with SMTP id t11mr1261355oiw.8.1625151571717;
 Thu, 01 Jul 2021 07:59:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com> <20210615133950.693489-9-tabba@google.com>
 <20210701134823.GH9757@willie-the-truck>
In-Reply-To: <20210701134823.GH9757@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 15:58:55 +0100
Message-ID: <CA+EHjTzsx1jR9JWhN5iKENSi8ry-0-byF1wN_bTBmm3+qn6MdA@mail.gmail.com>
Subject: Re: [PATCH v2 08/13] KVM: arm64: Guest exit handlers for nVHE hyp
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Jul 1, 2021 at 2:48 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:45PM +0100, Fuad Tabba wrote:
> > Add an array of pointers to handlers for various trap reasons in
> > nVHE code.
> >
> > The current code selects how to fixup a guest on exit based on a
> > series of if/else statements. Future patches will also require
> > different handling for guest exists. Create an array of handlers
> > to consolidate them.
> >
> > No functional change intended as the array isn't populated yet.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 35 +++++++++++++++++++++++++
> >  2 files changed, 54 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index e4a2f295a394..f5d3d1da0aec 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -405,6 +405,18 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
> >       return true;
> >  }
> >
> > +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
> > +
> > +exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
> > +
> > +static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
> > +{
> > +     if (is_nvhe_hyp_code())
> > +             return kvm_get_nvhe_exit_handler(vcpu);
> > +     else
> > +             return NULL;
> > +}
>
> nit: might be a bit tidier with a ternary if (?:).

Sure thing.

Thanks,
/fuad

> But either way:
>
> Acked-by: Will Deacon <will@kernel.org>
>
> Will
