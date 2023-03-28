Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E58B6CCDE9
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 01:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjC1XNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 19:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjC1XNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 19:13:37 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45601BFB
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:13:34 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id x33so10088009uaf.12
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 16:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680045214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Ovm+AM85KXAJZHu2fD53I2qFnekQy/WozXcpTNpGGI=;
        b=Dnh//BOQKl1nkYVftlXgaATG8gbO0cTyEPMrBs5HAYsbWGowNRajjCifsI/vIZgLNu
         Tjt0Tmm9zQxzn2NTJyBR/8uM3MZh9heUL07KmfnRS5COYj2T2xckjf0LxMVs8cjOewS9
         NYz7jIbXQcnk8byiK+pYEu9mtRx73cRD4q/lIjQ3WEqh9I69sD5H8zWp5l5RNcqJuD9L
         B/lmajj6pvI5pH1UvMmEb9b99s/Ekxm3z4i0lQt4WvOnArzetoUU3oAYdaSA02LEhS1E
         2eV3VVkXy4+De5jJXoMYgWSU320EMUj2I4v8zgw0hYG6JBa6LC/U/ZhNEDDoVWlqTQKo
         /+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680045214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Ovm+AM85KXAJZHu2fD53I2qFnekQy/WozXcpTNpGGI=;
        b=YExKGDs6KECryo+Wkb5ZQ5Nsgun9RHCSOzoRP1hqI1tX0wZPe5NGsJ2UY7HsHhtHtS
         JzYg80lc3wEId2QC16qCp6g2AbvpmyuvJ1N8epFpTDStQVKz/mYSGVKf41Sb4nj1PrRW
         xu84/PQjXc2DNEmcJ8al1nP1q03h5yu9KHYcp/2ztEPa8yNRWaxn17i2AdV1xrK+4wqR
         vohbpa+9QlZkwAUFhxbJFoAwCLlpLxeDFNZP5FdkONyK/kSlrtQ2iR+oczUx8nP9G15R
         L6SbalGjxNX4TbWfHX3pjrvraYg892qjiXcgDFLaWZ6watZVzXrtBwhudW7SFrEVvzGh
         C0/A==
X-Gm-Message-State: AAQBX9dsnGM8h3DkYkhVlf0DFxaS+/xLKxNkd4+ShDQVFN6SfhtxQ3c0
        VR49hUbLvDEk4yNEMHScBKpFm9VVxloxLdIDSLK2XA==
X-Google-Smtp-Source: AKy350ZUtjKBRPgsVzb0NsvH9ktDoKD0M4zlZHz9dMVIVnpXMME0mXMlPzdM9gmRFI/jrkFWsuRZI4V23Qv4c5QV1os=
X-Received: by 2002:a1f:b2d2:0:b0:43b:96b8:1a9f with SMTP id
 b201-20020a1fb2d2000000b0043b96b81a9fmr5841630vkf.2.1680045213907; Tue, 28
 Mar 2023 16:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-15-vipinsh@google.com>
 <ZBzSgI2mkpl3QTNt@google.com> <CAHVum0dSh-=VsiR+dC6MC3FO_ev4CqNZ6PrVuZoQ+uRd5qn-0g@mail.gmail.com>
In-Reply-To: <CAHVum0dSh-=VsiR+dC6MC3FO_ev4CqNZ6PrVuZoQ+uRd5qn-0g@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 28 Mar 2023 16:13:07 -0700
Message-ID: <CALzav=dURfiFvCZNjysk28q4sJMzFWLLnjXZ_LfP9kcHsAz50g@mail.gmail.com>
Subject: Re: [Patch v4 14/18] KVM: mmu: Initialize kvm_mmu_memory_cache.gfp_zero
 to __GFP_ZERO by default
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 10:31=E2=80=AFAM Vipin Sharma <vipinsh@google.com> =
wrote:
>
> On Thu, Mar 23, 2023 at 3:28=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On Mon, Mar 06, 2023 at 02:41:23PM -0800, Vipin Sharma wrote:
> > > Set __GFP_ZERO to gfp_zero in default initizliation of struct
> > > kvm_mmu_memory_cache{}
> > >
> > > All of the users of default initialization code of struct
> > > kvm_mmu_memory_cache{} explicitly sets gfp_zero to __GFP_ZERO. This c=
an
> > > be moved to common initialization logic.
> >
> > If that were true we could get rid of gfp_zero entirely and hard-code
> > __GFP_ZERO in the memory allocator! mmu_shadowed_info_cache is the one
> > that does not set __GFP_ZERO.
> >
>
> Can we use __GFP_ZERO for mmu_shadowed_info_cache?

Yes but doing so would add CPU cost to zero the memory on allocation.
Someone would need to do some performance testing to confirm that the
cost of zeroing is acceptable.

> Also, MIPS doesn't
> use __GFP_ZERO, I think it might be a missed thing in MIPS rather than
> intentional.
