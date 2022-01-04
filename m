Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5624846FD
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 18:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiADR3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 12:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbiADR3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 12:29:44 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100AFC061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 09:29:44 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id v10so28898668ilj.3
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 09:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m1GnrodwIx3U3MtKS6H0HNAvAZXFbA1aoo+jqiQdTH0=;
        b=fctI+z0EraOx3SJTtbegT5MMc8azCbmtUzxlZd0i15u1nI3rQoC4i02eIwcrjwb8W5
         bxx+t2TrLE7QJ0FB7lwIe4wj7t5+H6l3PtD7XkiURhd+gYsL2CnBrNlbXBc446QdyxZ8
         yX5DGxnRdWZiorqW8vjbuYbJAGH9PhUn/cKxodJw/l6rojnJil5TI9xQ35jt8/0oBSvl
         iJlhIHRXHUj0HLNJ8jj9Jz84ne4m2tzbmTWVtenqESnOV7RfaGTip3Dqw52QA/8sBJ68
         7DbvaAisHCPniXqOoIEFVplZJvuKhTfbsjypZhD/U3mqwu25OKWpSz2p9nPLzZhWSSR+
         B2sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m1GnrodwIx3U3MtKS6H0HNAvAZXFbA1aoo+jqiQdTH0=;
        b=w3iz1K0MKBs+YBlvwJJGduyeU8bzx2WJdG8UT8FL0en0+awHPMU9umlGT125DiAofc
         OGYE9S6VLJm2BcwExhFrv4CSYXVIiluUCluu9X4wNwHEjJeEnVF30w0gdtslfZsL0GyR
         i70y6z0x7anTLxc+3j+5toWBAeNhvZQN7TjQn82ilX9AmyUAmFBg8ZpSm74331cZRN62
         sx1aUxV22L0y32lmG5o8aEBe5JxiU2MCIUIU6O81EZ9G8AHYWm11LMzv59XdhZWL7FfR
         OAh8YDFpY9J0G1vPml95EetY35wKAluwGGXZztaRiqgjvbAZvNAxy0ToogOu74aKVNBO
         Wckg==
X-Gm-Message-State: AOAM533P9ZhfQgWvOWW0kL9JeE/JVRIPcO3vp59ZkyFaPO2etUXvIcnH
        8FDvJtPmXbRJ0nr82/lzlrxgthTsVq/3rIwh7qfq2A==
X-Google-Smtp-Source: ABdhPJx8kb43aDwoPlu1xtoqV8WdE0e1FhIjA/uac6cj4RYIhNDlu0kYtCt2+7WoQMZ+Cz9By5Gs/f0T1qazbh6Cm2s=
X-Received: by 2002:a05:6e02:178c:: with SMTP id y12mr22287704ilu.298.1641317383370;
 Tue, 04 Jan 2022 09:29:43 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-4-dmatlack@google.com>
 <YdQdv5lAWsJA1/EA@xz-m1.local>
In-Reply-To: <YdQdv5lAWsJA1/EA@xz-m1.local>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 4 Jan 2022 09:29:32 -0800
Message-ID: <CANgfPd9MmKC_E6J+isYX+6DmT+kCQBF=o7_w4xg-WqPEJ5WG8A@mail.gmail.com>
Subject: Re: [PATCH v1 03/13] KVM: x86/mmu: Automatically update
 iter->old_spte if cmpxchg fails
To:     Peter Xu <peterx@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 4, 2022 at 2:13 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Dec 13, 2021 at 10:59:08PM +0000, David Matlack wrote:
> > @@ -985,6 +992,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                        * path below.
> >                        */
> >                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> > +
>
> Useless empty line?
>
> Other than that:
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> --
> Peter Xu
>

Looks good to me too.

Reviewed-by: Ben Gardon <bgardon@google.com>
