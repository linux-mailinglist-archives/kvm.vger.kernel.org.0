Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4626D5504
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 00:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbjDCW56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 18:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjDCW54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 18:57:56 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00A9170D
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 15:57:54 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-5419d4c340aso580735427b3.11
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 15:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680562674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IkQBhbgwY7qqI+lTWoHsgeayGGNj31051a4xVgFY1kY=;
        b=HemLRiGE2chuLDbo3wVOe6kZFIPRt/pvpwJ05K0JRbz/Ou1hJE3Ik0HdSsvs4KQeaK
         549jnB2yVBMFeB3gNMs2jVNB+kUckF4JwXW7gXtmkgorOxR7q+pXnOZz4esgTguGUiso
         Wx2vHQ/lw3autL6H/hCbi5HltErjO54O0wp4xO2dNdC3on5kxIUGJE+lZZEB/EwnkyQe
         456BXnuaEdwVvGO5G49KKWlTVHLY6RJ5lPXkznttaPCAmevRe4lglmPN4R499UjCcWMY
         1KAtV1oQOTgbgU8rES6c8WNsOjwCxKI2jTiRs60c9lu0KRg55Qf1CHEfrkhJiU9QgFJD
         B26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IkQBhbgwY7qqI+lTWoHsgeayGGNj31051a4xVgFY1kY=;
        b=j3/GSh+HKV8CUgTQ/5Mljxxf4pS65YA1rP8DJOExKukqZohf5p/8gbg/Q6QNxXwPoo
         lq+h5tF7uZ/IFJn+7D3JafmDuQdLZz0TBq35w44J23bdUStK6JHKAvVV04RcOdYpxLKw
         O+YjOhNnJyXMA304yZv1Ies9l6yLc2AxlK4lASSkM7W0RlQMUZ8k/5c9U+zWd19YtQQ6
         Nrp+H2auc7Ejlz8UosIEYk4OAYSRpHhd+v18jWrldoZ3iKvgmC9UIXNlocm/UMxo4seh
         l3OlTvBnciPTiSo4XbwV08hVs4SN/ALa7OBy6PGD5JlbFxA4UV5bL1aqmtFX0pOmnExF
         x9Xg==
X-Gm-Message-State: AAQBX9dFD31gdJtA3Evyd3TtZvXtnU4hv8xt6cJAgGvWcCQrmBVCRb87
        K9a3ipya7HCWe9ElPf9C1vnoOOwJ++ZroaeRJiVYjA==
X-Google-Smtp-Source: AKy350YkD3fGkfW6GEiZeZ3P6HzsrLcRH50mnPhWe2JOX/ijrZjnYPRPKdUHbic7Px5lsF0j3Fu2z76s2eFg90J70jY=
X-Received: by 2002:a81:a743:0:b0:541:a17f:c77d with SMTP id
 e64-20020a81a743000000b00541a17fc77dmr326683ywh.10.1680562673722; Mon, 03 Apr
 2023 15:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-16-vipinsh@google.com>
 <ZBzS9WnZu9VtSVAt@google.com> <CAHVum0dOP6kR83Uuha=Ka7=enfEdrTTX7ZtR0nhXrkJDCo9dKQ@mail.gmail.com>
 <CALzav=fgek=jgtaytz6ZEUgBzoHBKAgLk53n9w0LGZrJkMBg-A@mail.gmail.com>
In-Reply-To: <CALzav=fgek=jgtaytz6ZEUgBzoHBKAgLk53n9w0LGZrJkMBg-A@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 3 Apr 2023 15:57:17 -0700
Message-ID: <CAHVum0dZsYKOqNw4E=p+QyTc3+mbgirHyvh9VXpNfGDz2MZgvA@mail.gmail.com>
Subject: Re: [Patch v4 15/18] KVM: mmu: Add NUMA node support in struct kvm_mmu_memory_cache{}
To:     David Matlack <dmatlack@google.com>
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

On Tue, Mar 28, 2023 at 4:25=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Tue, Mar 28, 2023 at 10:51=E2=80=AFAM Vipin Sharma <vipinsh@google.com=
> wrote:
> >
> > On Thu, Mar 23, 2023 at 3:30=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On Mon, Mar 06, 2023 at 02:41:24PM -0800, Vipin Sharma wrote:
> > > > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
> > > > +     vcpu->arch.mmu_page_cache.gfp_zero =3D 0;
> > >
> > > Oh MIPS is here. Why isn't MIPS covered in the previous commits?
> >
> > Because this is the patch where MIPS get impacted. MIPS doesn't
> > initialize gfp_zero, so there was no need to change the code in MIPS.
> > However, with the addition of "node" in kvm_mmu_memory_cache{} in this
> > patch, we need initialization in MIPS to (1) Set  node to NUMA_NO_NODE
> > as 0 is now a valid value, and (2) INIT_KVM_MMU_MEMORY_CACHE() will
> > set gfp_zero to __GFP_ZERO which is different than existing code in
> > MIPS to keep it 0.
> >
> > I asked MIPS maintainers in the previous version to see if GFP_ZERO
> > can be added but didn't get any response.
> > https://lore.kernel.org/lkml/CAHVum0c+17Z-RbGAFdU-xmRejDjDQ+MKOfN4XaObh=
2SwgWAjLg@mail.gmail.com/
>
> I see. IMO it's more logical to convert the MIPS cache to
> INIT_KVM_MMU_MEMORY_CACHE() in patch 13, along with all the other
> users of struct kvm_mmu_memory_cache. Then in patch 14, add the line
> to set gfp_zero to 0 for MIPS to preserve the existing behavior. That
> produces a very simple chain of changes:
>
> Patch 13: Convert all users of struct kvm_mmu_memory_cache to INIT()
> Patch 14: Invert the default value of kvm_mmu_memory_cache.gfp_zero
> Patch 15: Add node to kvm_mmu_memory_cache
>
>

Yeah, this looks better. I will do this.
