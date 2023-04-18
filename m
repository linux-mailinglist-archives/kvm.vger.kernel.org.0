Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E516E6AB8
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjDRRPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjDRRPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:15:18 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B1213C18
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:14:37 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id a15so231082ljq.13
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681838075; x=1684430075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6cf1rCGBfFsm7IF2+Dyi3Wvezc5h9U/VnOfZVSR23P0=;
        b=gowjJ1xsZFbFsEd1QHrmKC/KvgzOkJwsqYXeITFP2diqAtzycD6P63Zdr5mLyqg4OR
         7Lhcp5dkobsHkmtEt3bzRoI4l9skBxLBrSzPGTmYX6qDWUu/kXkGuqnzwuTkW00Mzer5
         1ZvCW4dvhP5YH/M2NUIkHC9h1uzWDVoAxCKbXrPcC6wEc9bbfyP2zlojdsMzLqGvBfqd
         qY76cw8NX6IxX1Q+tBT/g8Jk2o4ZIAeCC6MOEW4aT0S+sgyd4+9U6rxS23O07Z2ACzWF
         RWAGJ8NyFVS9ArT00ogfykYlxIB92MNOOHe3gqY+3uO7QO+LwzPTv/epP0g67Lkid2oH
         JYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681838075; x=1684430075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6cf1rCGBfFsm7IF2+Dyi3Wvezc5h9U/VnOfZVSR23P0=;
        b=QSui07Hv/xxEswHtfmgzSHVJg+elDWFxg9h2wC1ZZ2d0QKoMyYVpiRggCuNkMYd4sR
         2ESOjDH0c0kXfuGubiKwRZkrfsSosg+rLtYjzF02BD0suW4JF97457XtdXLKbcj6VGEW
         FXg06w1zR6NXFTbxayaonKNfMCHqbXMm52wohpbsuXz8U6uYhL/Dyq7O6ERSBeOkDCU+
         uQsIonhY+f+H3o/MooccHTDpHMxD6uSIeDM401Sal6FYIGq919JHTy+IPSY/tB7XhSy6
         06JSANHmpstwxtFzf8jLvWSxlz0k/LPUWUBsG/14zf9Sen07fF7etm0CBmAY7SbbPvmW
         otkg==
X-Gm-Message-State: AAQBX9fgY/deO9aGkxmdDTyTBwbDL9L0fQ8QeAvcJlMQaTq+VCxQl/TA
        kv83befqkh4qL4ihxgdHxuOrA2WtmUhpoWwwMP6rjQ==
X-Google-Smtp-Source: AKy350YANFo7McMyTwZbFijRpweMJain1zZv12KJ7Z9pVpf6BezffThdnp6xFsMVipm2gHZQCtBFkOHIKBNQ6Dx12a0=
X-Received: by 2002:a2e:994f:0:b0:2a8:b1e3:8979 with SMTP id
 r15-20020a2e994f000000b002a8b1e38979mr1064705ljj.7.1681838075093; Tue, 18 Apr
 2023 10:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com> <20230407201921.2703758-2-sagis@google.com>
 <20230417223611.00004aee.zhi.wang.linux@gmail.com>
In-Reply-To: <20230417223611.00004aee.zhi.wang.linux@gmail.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Tue, 18 Apr 2023 10:14:22 -0700
Message-ID: <CAAhR5DHLk2c+-ziSSHLjygFv7ceWw0+4a00FXioLfmRJe09o1w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] KVM: Split tdp_mmu_pages to private and shared lists
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 12:37=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.com=
> wrote:
>
> On Fri,  7 Apr 2023 20:19:17 +0000
> Sagi Shahar <sagis@google.com> wrote:
>
> This patch is actually adding a separate counter for accounting private
> tdp mmu page not really introducing a new tdp_mmu_pages list for private
> pages. I guess better refine the tittle to reflect what this patch
> is doing.

Thanks for catching this. tdp_mmu_pages actually used to be a list of
pages when I first developed this code but was replaced with a counter
in https://lore.kernel.org/all/20221019165618.927057-6-seanjc@google.com/

>
> > tdp_mmu_pages holds all the active pages used by the mmu. When we
> > transfer the state during intra-host migration we need to transfer the
> > private pages but not the shared ones.
> >
> Maybe explain a little bit about how the shared one is processed. Guess
> one sentence is enough.

How about:
tdp_mmu_pages holds all the active pages used by the mmu. When we
transfer the state during intra-host migration we need to transfer the
private pages but not the shared ones. The shared pages are going to
be re-faulted as needed on the destination, but that approach doesn't
work for private pages which stores information in the secure EPT.

> > Keeping them in separate counters makes this transfer more efficient.
> >
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  5 ++++-
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 11 +++++++++--
> >  2 files changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index ae377eec81987..5ed70cd9d74bf 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1426,9 +1426,12 @@ struct kvm_arch {
> >       struct task_struct *nx_huge_page_recovery_thread;
> >
> >  #ifdef CONFIG_X86_64
> > -     /* The number of TDP MMU pages across all roots. */
> > +     /* The number of non-private TDP MMU pages across all roots. */
> >       atomic64_t tdp_mmu_pages;
> >
> > +     /* Same as tdp_mmu_pages but only for private pages. */
> > +     atomic64_t tdp_private_mmu_pages;
> > +
> >       /*
> >        * List of struct kvm_mmu_pages being used as roots.
> >        * All struct kvm_mmu_pages in the list should have
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 58a236a69ec72..327dee4f6170e 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -44,6 +44,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> >       destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
> >
> >       WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
> > +     WARN_ON(atomic64_read(&kvm->arch.tdp_private_mmu_pages));
> >       WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
> >
> >       /*
> > @@ -373,13 +374,19 @@ static void handle_changed_spte_dirty_log(struct =
kvm *kvm, int as_id, gfn_t gfn,
> >  static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page =
*sp)
> >  {
> >       kvm_account_pgtable_pages((void *)sp->spt, +1);
> > -     atomic64_inc(&kvm->arch.tdp_mmu_pages);
> > +     if (is_private_sp(sp))
> > +             atomic64_inc(&kvm->arch.tdp_private_mmu_pages);
> > +     else
> > +             atomic64_inc(&kvm->arch.tdp_mmu_pages);
> >  }
> >
> >  static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_pag=
e *sp)
> >  {
> >       kvm_account_pgtable_pages((void *)sp->spt, -1);
> > -     atomic64_dec(&kvm->arch.tdp_mmu_pages);
> > +     if (is_private_sp(sp))
> > +             atomic64_dec(&kvm->arch.tdp_private_mmu_pages);
> > +     else
> > +             atomic64_dec(&kvm->arch.tdp_mmu_pages);
> >  }
> >
> >  /**
>
