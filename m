Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9D273617B
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 04:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjFTCTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 22:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjFTCTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 22:19:50 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981C210C1
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 19:19:48 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3ff242aae7aso242031cf.0
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 19:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687227588; x=1689819588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EPXA9p2JzuvzKzWgCYYXlon3hk90pdnuUAk2cg5+oQ=;
        b=sNHrZ1LKYtFz3X1H+MgLDy6o0nbrrhrd1YKD6rtJcW3ttYHs9f5dyY0axzWJCvpzWF
         3o0ncsgfP5UDH7NTvRyQAcsGgg9JpLu+jFVAH3FJLnLMFYG+fxywkAC28XwfvqNqZmQK
         IFUklgGtHIOC3T2HblFwLsGfrEizS/eFOyfR59HJGCj3NLATeWYbP+Pg2p8UrZWBeMpa
         32bFBxdll4sSVTWVtOqWKiuT2J6FqgQ2hp7Mod9/Sx0Ak+MTgWCQUN9kS8y1HoT2CBgL
         iZLyV4YibsmMoTiVxXer72V03w1CLB/TQXGwBB9khGhCUst7GGbzHBkJpPmgooW/jTiW
         nYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687227588; x=1689819588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EPXA9p2JzuvzKzWgCYYXlon3hk90pdnuUAk2cg5+oQ=;
        b=FoncvS5Rf2Y/koWQ70ze75VLfIDvj6o/xJwgNZWADHvSPNDydqM5V00yGItZ+zjTls
         zMXQD6d+qywPWOKiuG7SpQJoN4pe8N934aEkNAUOEKJr3CtMdNSWZJXRPosCtoVumGkI
         H0/zjEWWkrBTWB4GDOYnyZI665mdQ5GLLY82OZSKqLwt8+Kl1Akvnc3bjjJ4o5jD2RKO
         M6z6oZStNf9WwCsV23f3R2wqrPFc/mLoQBOQvlqxGQn9/vfYrrb+oYxacMQ/VeZGdVAw
         AwFHKHVZdiMYVIbubdngSQp17fFP/9+6Dd2f+W+YLh4KKscSSyaEQKv+o6suECxILm2B
         77Zw==
X-Gm-Message-State: AC+VfDz26keO2cdNW2gMjFdHpM2R+s54fThaDdvTOTys8KEQwzU6naoV
        pMb7fruxPo/tlymPusGtz5s6flE3BqbU2hZk4fBARw==
X-Google-Smtp-Source: ACHHUZ4X3CzpwwHdrmJnCxXIBAk6HQXykSsn31iNLJMOP1aC/6DP8FnJZ+MTQ6AdfTjiGdmwOfd3hduXZamO7zy5qTQ=
X-Received: by 2002:ac8:7f93:0:b0:3ef:404a:b291 with SMTP id
 z19-20020ac87f93000000b003ef404ab291mr104628qtj.7.1687227587619; Mon, 19 Jun
 2023 19:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <26cf0b0a-cda5-08a9-a669-6966f9e626b1@redhat.com>
In-Reply-To: <26cf0b0a-cda5-08a9-a669-6966f9e626b1@redhat.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Mon, 19 Jun 2023 20:19:11 -0600
Message-ID: <CAOUHufagkd2Jk3_HrVoFFptRXM=hX2CV8f+M-dka-hJU4bP8kw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 00/10] mm/kvm: locklessly clear the
 accessed bit
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 9, 2023 at 3:08=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> On 5/27/23 01:44, Yu Zhao wrote:
> > TLDR
> > =3D=3D=3D=3D
> > This patchset adds a fast path to clear the accessed bit without
> > taking kvm->mmu_lock. It can significantly improve the performance of
> > guests when the host is under heavy memory pressure.
> >
> > ChromeOS has been using a similar approach [1] since mid 2021 and it
> > was proven successful on tens of millions devices.
> >
> > This v2 addressed previous requests [2] on refactoring code, removing
> > inaccurate/redundant texts, etc.
> >
> > [1]https://crrev.com/c/2987928
> > [2]https://lore.kernel.org/r/20230217041230.2417228-1-yuzhao@google.com=
/
>
>  From the KVM point of view the patches look good (though I wouldn't
> mind if Nicholas took a look at the ppc part).  Jason's comment on the
> MMU notifier side are promising as well.  Can you send v3 with Oliver's
> comments addressed?

Thanks. I'll address all the comments in v3 and post it asap.

Meanwhile, some updates on the recent progress from my side:
1. I've asked some downstream kernels to pick up v2 for testing, the
Archlinux Zen kernel did. I don't really expect its enthusiastic
testers to find this series relevant to their use cases. But who
knows.
2. I've also asked openbenchmarking.org to run their popular highmem
benchmark suites with v2. Hopefully they'll have some independent
results soon.
3. I've backported v2 to v5.15 and v6.1 and started an A/B experiment
involving ~1 million devices, as I mentioned in another email in this
thread. I should have some results to share when posting v3.
