Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7483B92D7
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhGAOIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 10:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhGAOIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 10:08:43 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F92C061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 07:06:13 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 11so7414094oid.3
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 07:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q/b9vCdaygIeC9vS+9fQyLbUZfa/vZYnTPImcqjbsh8=;
        b=ksCzG/IeP/UoPwvYZdwDBDxKJ8hIaPHWqofvRsIE/wb9CVnBKeR5t5mse57PdaYsAh
         tLI8c8sM949fzJK4Yj1l9X0FcXA+zMSUx596TBcD+5Mah5WOfDLU3C7J/n7FQTDQEP/c
         oxn//xhz3I20ipBBQ8gX5P8H0m7+Qs8W3CTqKAO81/0KsWFHqEeooJq4mMDOp+Jl2dyj
         MtSG3xAq+iBBLyBueeZ7SgX5kNEBiTURDZjLfnYzoSHUyJiK9bVQ1sKP2K60HaGFKaXs
         /T0UOBpMxLoUPlFna11/qxMiasGetBrymjp+cTxFvDHT1Srj1F78sjYvJ+kJ96hsBZfV
         3p9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q/b9vCdaygIeC9vS+9fQyLbUZfa/vZYnTPImcqjbsh8=;
        b=N8Th0kJ/icTdv/Nc/YvoGDXfqAtVRwAv9yI87N0xlB5W2mL2wA08yntapoTM7k/BXK
         Eso4hUHlMyYXF3fNslKXb9gBg4cKkmLqE3+1inxfR+5Azn2bYLnptB2npCqBEY4mxrDu
         n5U8AaQp+/nK3jqu99LU0iWvvmKoeDtXsPXjDvXqvHKpyMgv99ivKyKNlqddnqU5sfl0
         A7wMZPzWwFKiTcoqbRlj1r1kNdZV6KZej3Ox2ecCTjG5guQNV1mg1mnSPc5md6V1XUut
         5+L5hFJFr5uTtedQljh8fsDK8gzoKrqz52sTALEVQ6JO9SIQICdTC7KMIdOXX9D9qAsz
         eqgg==
X-Gm-Message-State: AOAM533JSPmDg9Uyf6N6+kkVvyCazcphICoLGAGbUCV7CDfItvmkp70/
        eNd7gz13T14pRdEVC/s/j41IjVWOVrY7oZPOvdFZKQ==
X-Google-Smtp-Source: ABdhPJzI/BKso2x8AyD9Q/UTkch0ZJ9wgWGbbMKgkUK6Bpyt1APbz443A8LFMEfbhFxJFICJaBq5ODSCKCpVoznMYDE=
X-Received: by 2002:aca:b38a:: with SMTP id c132mr29463575oif.90.1625148372285;
 Thu, 01 Jul 2021 07:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com> <20210615133950.693489-6-tabba@google.com>
 <20210701131733.GE9757@willie-the-truck>
In-Reply-To: <20210701131733.GE9757@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 15:05:35 +0100
Message-ID: <CA+EHjTw3F6uCTJMVQRn0xXzAH1k4HYJr92jRLyjiFXfueqWDSQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/13] KVM: arm64: Restore mdcr_el2 from vcpu
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

On Thu, Jul 1, 2021 at 2:17 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:42PM +0100, Fuad Tabba wrote:
> > On deactivating traps, restore the value of mdcr_el2 from the
> > vcpu context, rather than directly reading the hardware register.
> > Currently, the two values are the same, i.e., the hardware
> > register and the vcpu one. A future patch will be changing the
> > value of mdcr_el2 on activating traps, and this ensures that its
> > value will be restored.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index f7af9688c1f7..430b5bae8761 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -73,7 +73,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
> >
> >       ___deactivate_traps(vcpu);
> >
> > -     mdcr_el2 = read_sysreg(mdcr_el2);
> > +     mdcr_el2 = vcpu->arch.mdcr_el2;
>
> Do you need to change the VHE code too?

No. The code that would toggle mdcr_el2 only affects nvhe and only in
protected mode.

Cheers,
/fuad

>
> Will
