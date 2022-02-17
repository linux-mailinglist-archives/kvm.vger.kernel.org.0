Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36E14BA7C7
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 19:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244076AbiBQSJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 13:09:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244038AbiBQSJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 13:09:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D026415F0BE
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 10:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645121323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kdCG/BqRA3h3SSjWYFY12VvohzTJC0/2p0AbBe0FxJA=;
        b=MLWxHYb0jUPyZmWayLKEHpH3D9tfrxgucyVl6XWkftXOlVAEqREVFpoPUrteYVqv+0AJFd
        vvtuTYFYmeJTBFrssgeJwCIaD1ooKLwwQh7zmiOrF/riEO9VxiC59DdkvXtVDLEPgTOd9a
        VCK240AuohjbX6bzcY0xCFDs96R8pFA=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-QIP54SgaNYKvTdft-Or9Aw-1; Thu, 17 Feb 2022 13:08:42 -0500
X-MC-Unique: QIP54SgaNYKvTdft-Or9Aw-1
Received: by mail-lj1-f200.google.com with SMTP id s20-20020a2eb8d4000000b00244c0c07f5aso193464ljp.7
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 10:08:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kdCG/BqRA3h3SSjWYFY12VvohzTJC0/2p0AbBe0FxJA=;
        b=BYOGAjUSLctDiH71uTDTsrDAdlKsT+l25cXc9z22X1DmMGzPp46YueDmIuns8XqWSO
         Qkukcd+/R3cr92x+ksYNZzSPHFOCxc7Kkfl9fR9lLttftUJcWaWHrDJgVMdd+QBQhpLd
         60nqA7KcqMNTDAfWLdQv6nmY5o0LGEnK3MA+R9aNJDsajT7a2d4LMkIaP9kGODMUDMX2
         GT2WQINwLu6v13bZDxjy+FX9930nwx4cLHahwgjHTZL41q4SmuuBlq52OCa8rdglXYST
         KteGdW277d8Xgjt9EDwnn5GQx2xyJZsaCZ3wgnHlHZ2LGayTap/Cvr26t0z769hjNf1V
         U6CA==
X-Gm-Message-State: AOAM531oLA3ZZw/PQAZH31tGX3NgrQqkqRA7gvGoZSh9hXiK0IA8r3bJ
        liZCJO4Yewu7Nc05jA/VC4qjgz+rHqSx5cti4klf2CVkrHntRWoetqGrN/5Z3mkXK3LZaUHsuD8
        zPQ7zJY+bTxtxg10jl7mhHa2AgoZh
X-Received: by 2002:a05:6512:3d90:b0:437:73cb:8e76 with SMTP id k16-20020a0565123d9000b0043773cb8e76mr2969481lfv.187.1645121320871;
        Thu, 17 Feb 2022 10:08:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzChZlQY5QTvjHbE0p1UCY0dO09MQJLQKaTJOmCopXmMEEUgU0MgdXhF+IltPwII3QUm9GQahgHm2UTwnG0wkw=
X-Received: by 2002:a05:6512:3d90:b0:437:73cb:8e76 with SMTP id
 k16-20020a0565123d9000b0043773cb8e76mr2969460lfv.187.1645121320667; Thu, 17
 Feb 2022 10:08:40 -0800 (PST)
MIME-Version: 1.0
References: <20220217053028.96432-1-leobras@redhat.com> <087309d0-f39c-d5d0-2b6a-2dd8595b06ea@redhat.com>
In-Reply-To: <087309d0-f39c-d5d0-2b6a-2dd8595b06ea@redhat.com>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Thu, 17 Feb 2022 15:08:29 -0300
Message-ID: <CAJ6HWG66HZ7raAa+YK0UOGLF+4O3JnzbZ+a-0j8GNixOhLk9dA@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] x86/kvm/fpu: Fix guest migration bugs that can
 crash guest
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        David Gilbert <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022 at 11:52 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/17/22 06:30, Leonardo Bras wrote:
> > This patchset comes from a bug I found during qemu guest migration from a
> > host with newer CPU to a host with an older version of this CPU, and thus
> > having less FPU features.
> >
> > When the guests were created, the one with less features is used as
> > config, so migration is possible.
> >
> > Patch 1 fix a bug that always happens during this migration, and is
> > related to the fact that xsave saves all feature flags, but xrstor does
> > not touch the PKRU flag. It also changes how fpstate->user_xfeatures
> > is set, going from kvm_check_cpuid() to the later called
> > kvm_vcpu_after_set_cpuid().
> >
> > Patch 2 removes kvm_vcpu_arch.guest_supported_xcr0 since it now
> > duplicates guest_fpu.fpstate->user_xfeatures. Some wrappers were
> > introduced in order to make it easier to read the replaced version.
> >
> > Patches were compile-tested, and could fix the bug found.
>
> Queued, thanks (for 5.17 of course)!  For patch 2, I renamed the
> function to kvm_guest_supported_xcr0.
>
> Paolo
>

That's great!
Thanks Paolo!

