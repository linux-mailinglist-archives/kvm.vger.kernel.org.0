Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E773716E5A
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 22:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjE3UHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 16:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjE3UHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 16:07:37 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77002102
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 13:07:33 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3f6c6320d4eso5021cf.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 13:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685477252; x=1688069252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnJw+gna055xgPY4k/D+ZQZ+/+poCudJDicda2AGR3k=;
        b=DtfynU88O3z0/4oFgDiYM7qy14b7RLg4yomBzxL0dog8TFdWbHyo2tpb/B1SOYXfmp
         NSRsIG+eVwPFOobh1xJCt8kwErPgylGUweOcutP0ywct+6P+S2IjeaikfhAUmhYPV+uH
         Mv+j09gZh5WjQDA3Z/2Gy9TgffLJonGspryTqmY7mSq0d2Id3AeV0HEZ5ulNgRW7LXMq
         4JCJAWgEwKAWSjc16VpDrPx50NJw92bJUlL+d9zw+H+Lfu/l9dON3ftxIU/zENGgXs4K
         1cHj3nLx36gvePguvMtotajaF04WFwISrYvt1J6cDwX3ikwzIPGkd33waRKuVJi8J5gu
         uXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685477252; x=1688069252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tnJw+gna055xgPY4k/D+ZQZ+/+poCudJDicda2AGR3k=;
        b=KyYr6HClw73hN533plaFA93MGski1VI5KD/CA+Hr6yWP/doKdBXTSOMw27EYzy8Lcx
         myv0DehPTw5WPXu0z2znQwWxMGAt82QXCZ/Wxgl3wKFkgDeKW4aAPqGfeXRLwLEqnk+0
         ddE+hRYMdyxXH/yMIZUzz3WMldI+dTncYE6Epvyws0rNnbmWycANLkrIoRK/eMtMjkQ2
         OV4lTXPU1lm8bff+E1xaRKx4SiPbnTaWLfq+DwyjTMO6TnOtAt1ueQqAiKpiy3kbKmpZ
         OT9kqnl9L2wXxsaGomj5ep6IrjfZ/+vgh72GpOsy4yEsAeDu4yj9/fX/57eY3vbpJb/e
         TMew==
X-Gm-Message-State: AC+VfDxItt8gixjCr8bhiyMZMReEY6Hcgcg1M8U/TIuEPteNXyiac+dc
        Iyz+2cH1Ka2stSY7MNyxgIjBuoQ71NgHnuN+H/3FaQ==
X-Google-Smtp-Source: ACHHUZ6GXKZ8JX2tTyi2dAoKnrLtSo8EMFYdPNZnbJmbRABrmf7MX05SzfLq0yw9C6unlnFwzm3TaQimSQte4R7XEoY=
X-Received: by 2002:a05:622a:1012:b0:3ef:2f55:2204 with SMTP id
 d18-20020a05622a101200b003ef2f552204mr6506qte.6.1685477252408; Tue, 30 May
 2023 13:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-5-yuzhao@google.com>
 <ZHJHJPBF6euzOFdw@linux.dev> <CAOUHufa74CufHziHSquO5bZwbFXz2MNssBzW+AH7=Xo5RCnQ0A@mail.gmail.com>
 <ZHZQdQAApIrw6fBu@linux.dev>
In-Reply-To: <ZHZQdQAApIrw6fBu@linux.dev>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 30 May 2023 14:06:55 -0600
Message-ID: <CAOUHufZOkBmZJgCU2xW2B8S3P3TWERHezy0xKWY9_TeyV9K7Rg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 04/10] kvm/arm64: make stage2 page tables
 RCU safe
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
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
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023 at 1:37=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Yu,
>
> On Sat, May 27, 2023 at 02:13:07PM -0600, Yu Zhao wrote:
> > On Sat, May 27, 2023 at 12:08=E2=80=AFPM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtabl=
e.c
> > > index 3d61bd3e591d..bfbebdcb4ef0 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -1019,7 +1019,7 @@ static int stage2_unmap_walker(const struct kvm=
_pgtable_visit_ctx *ctx,
> > >                                                kvm_granule_size(ctx->=
level));
> > >
> > >         if (childp)
> > > -               mm_ops->put_page(childp);
> > > +               mm_ops->free_removed_table(childp, ctx->level);
> >
> > Thanks, Oliver.
> >
> > A couple of things I haven't had the chance to verify -- I'm hoping
> > you could help clarify:
> > 1. For unmapping, with free_removed_table(), wouldn't we have to look
> > into the table we know it's empty unnecessarily?
>
> As it is currently implemented, yes. But, there's potential to fast-path
> the implementation by checking page_count() before starting the walk.

Do you mind posting another patch? I'd be happy to ack it, as well as
the one you suggested above.

> > 2. For remapping and unmapping, how does free_removed_table() put the
> > final refcnt on the table passed in? (Previously we had
> > put_page(childp) in stage2_map_walk_table_post(). So I'm assuming we'd
> > have to do something equivalent with free_removed_table().)
>
> Heh, that's a bug, and an embarrassing one at that!
>
> Sent out a fix for that, since it would appear we leak memory on
> table->block transitions. PTAL if you have a chance.
>
> https://lore.kernel.org/all/20230530193213.1663411-1-oliver.upton@linux.d=
ev/

Awesome.
