Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834553EBBA4
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 19:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhHMRqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 13:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhHMRqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 13:46:50 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E68CC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 10:46:23 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id h9so16705209ljq.8
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 10:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8Holqm94msH8zwwttqnwNNIb5GP1G9/99qvE2v+dcU=;
        b=FPBviLCHTYpGAqgTfZCCThlPsy3SvDQxjuebC13p0iXhj0OeNzcrk8YOeVtI5XtpMF
         Uz75WPbJwSvlgpLB3W9qk6PHRin4VdhT9qA8BJG5ghCMldOJLsqDkm82fAq0EG8X/9BU
         8X0Jhf6XqawQsbRgFF6RRyadIjhI2BKj4pTGDmuYTJyYsiQMyLxObkqnuD976ng/AB8v
         NgMtefW1nPUJFOW/t+mhBlXgdY58Unh1X9nWpqYWjWqlYtWMHQ7OFlwxbWE6Xg1lIYrk
         MK78YUyYD35s7G1H9/bmzRptli+3Oa4ZmwL653IleMYkjHZaiwFDmBcZfA+TZ/gXbrXs
         WVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8Holqm94msH8zwwttqnwNNIb5GP1G9/99qvE2v+dcU=;
        b=WOUo3VEYN1QYNwoCkcioldnazKwMLnFibDc7S9/xvESH4vu5z0Shur30uyrAQnQ4PK
         P4d3dDKW6hZ+YPShG0eYYn2GUKmkgd/Z79fpDUeb3E8/XgevWM48jPJIw0zpY9zT4LVI
         KpDCQlcDP02dDGlXCoOjQ3EHlQ7JGWFiVgZSrRaWK57W1SG2TGTfRA+BDUVfQLQ3yvtG
         6UlSejEEIwr5DaJ/HTKkVqqePkonauIUqRB53e5zrVVxYydfs64MiI/3iSYuaVkHDt+E
         vw9mfqo//9kWuww57lIo6A61oTI+yz6ePdVN1/6h71vgMnuQUVfT/3eyJlqPWb2wjuFz
         npCA==
X-Gm-Message-State: AOAM5307mNdHjpXL21oqajH9a3b816OSEjQriBSONm6z9LGo2eC7gAxK
        zb046wj1wQpj2R5jo7Rr7xlVla9SRhqjIpfJ+A6Nyo/loT4=
X-Google-Smtp-Source: ABdhPJx8HrYl3U2RpJvJAW94Qnm4I1248XWC/aFD75EZtnwMe+a7ZCPJypazWWRAKqrHLiT2BB63moMkioDJPlkcPDc=
X-Received: by 2002:a2e:a5c1:: with SMTP id n1mr2653235ljp.65.1628876781486;
 Fri, 13 Aug 2021 10:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com> <20210804085819.846610-2-oupton@google.com>
 <78eeaf83-2bfa-8452-1301-a607fba7fa0c@redhat.com> <CAOQ_QsiwzKpaXUadGR6cWC2k0pg1P4QgkAxNdo0gpVAP1P3hSQ@mail.gmail.com>
 <0b415872-7a67-d38b-ae01-62c38b365be0@redhat.com>
In-Reply-To: <0b415872-7a67-d38b-ae01-62c38b365be0@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 13 Aug 2021 10:46:10 -0700
Message-ID: <CAOQ_Qsjs7MOeh8ZGx3_CdgpedFwb9pYG_tQ4insdPwaqhAY=6g@mail.gmail.com>
Subject: Re: [PATCH v6 01/21] KVM: x86: Fix potential race in KVM_GET_CLOCK
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021 at 3:44 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/08/21 12:39, Oliver Upton wrote:
> > Might it make sense to fix this issue under the existing locking
> > scheme, then shift to what you're proposing? I say that, but the
> > locking change in 03/21 would most certainly have a short lifetime
> > until this patch supersedes it.
>
> Yes, definitely.  The seqcount change would definitely go in much later.
>   Extracting KVM_{GET,SET}_CLOCK to separate function would also be a
> patch of its own.  Give me a few more days of frantic KVM Forum
> preparation. :)

Sounds good :-) I'm probably going to send this out once more, in
three separate series:

- x86 (no changes, just rebasing)
- arm64 (address some comments, bugs)
- selftests (no changes)

--
Thanks,
Oliver

> Paolo
>
