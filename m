Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6739B4CC65F
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbiCCToD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbiCCTnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:43:31 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6C311A14
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:42:30 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id l12so8131016ljh.12
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 11:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ecPDtA9WiIxWstcv6DBKSjmEZWDQO2IVFmnAq89Mo/M=;
        b=XY5CtqBIfFDumu11gCTdK6V2xgmlfId8d2R6bAS6NiFo9bEyYRQDF69RSTTsi4bRf8
         olNVPr/S5eTmshQDigkN7HkdwXa8m84PT0pCxwnGFy3q6/5YIK62WbtqfjzgTJ9Tvthi
         Nugmuqy7CR54hZvnIClq/Ol3U8Xkgcyv42KZiP2ZYn/Fq6lAG7UOMvYzl6dQmdEjZdyv
         rv/vsGN2DKB3hM+vCtSR6CV1nMzPEuiLnp7+400svd4CdL3vW2ziHJpyuMQa32U/JCO7
         zWiYvhPTFcr9U79+SOWGrzQNWSLthsd8e7+ys8e4aKd0qWAGOdmvj2S+T/i15cShCFe6
         7VeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ecPDtA9WiIxWstcv6DBKSjmEZWDQO2IVFmnAq89Mo/M=;
        b=tq4EDGWXSqLkyxIM7yZv3Gf2NQIq9oAxL4za9LS0cDR0Co7yYGS4ZlHYTCB/fYk2mg
         bm0jmXCHb7cf1xhbhdFA6dcBHHXxK4yxUinwKopWvIbANsWsA1DIRFbigFG8DLavn3Fl
         C6DlmauU08leyTYi/pT8eoM4qDpF/csiMqNu1GshC+dXFi7UTShKAIYvbOXUguRYxHv9
         Px2knP3dWCxocKqLK/qFW1ilZZvj+KjhVrK5O9c+FSCX0lk3oi2ERk4JhUeR1RImJQ2h
         moyqOL8/u6BpqPfl+WhH4WB6/swRHL/8LFwzBWVEdLXrtprSpQZaVkMYLn0W3JjpcFVe
         9EGw==
X-Gm-Message-State: AOAM532MAabtEY0VoiqnSzPkcI9Wb5gS63Hun+o3BEDG9YPc/d2JnExf
        2lbcZyvCXHUmR6YiNzoBFUlOYBxx4iBBaTEY4mghkg==
X-Google-Smtp-Source: ABdhPJw9Idux+qMcZbyBueqgRpNCZaVQsAtXY6WI1toj8KGzCOXUJ4+HY7l4cl0DS87P0bmI+d7PUm4LzpoM0NcDPgY=
X-Received: by 2002:a2e:6804:0:b0:245:f269:618 with SMTP id
 c4-20020a2e6804000000b00245f2690618mr23839225lja.198.1646336548352; Thu, 03
 Mar 2022 11:42:28 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-17-dmatlack@google.com>
 <CANgfPd_bfxT0n3sH+D9mBTrtFkE722u7Rts1EbRm-ERpGF+X-g@mail.gmail.com>
In-Reply-To: <CANgfPd_bfxT0n3sH+D9mBTrtFkE722u7Rts1EbRm-ERpGF+X-g@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 3 Mar 2022 11:42:01 -0800
Message-ID: <CALzav=dMjYjoX_CS3DJhQYb_cQtQEo16iuo7Svg3U2GJhwsWvg@mail.gmail.com>
Subject: Re: [PATCH 16/23] KVM: x86/mmu: Zap collapsible SPTEs at all levels
 in the shadow MMU
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 12:40 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Feb 2, 2022 at 5:02 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> > in the rmap). This leads to correct behavior because KVM never creates
> > intermediate huge pages during dirty logging. For example, a 1GiB page
> > is never partially split to a 2MiB page.
> >
> > However this behavior will stop being correct once the shadow MMU
> > participates in eager page splitting, which can in fact leave behind
> > partially split huge pages. In preparation for that change, change the
> > shadow MMU to iterate over all levels when zapping collapsible SPTEs.
> >
> > No functional change intended.
> >
>
> Reviewed-by: Ben Gardon <bgardon@google.com>
>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e2306a39526a..99ad7cc8683f 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6038,18 +6038,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >         return need_tlb_flush;
> >  }
> >
> > +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> > +                                          const struct kvm_memory_slot *slot)
> > +{
> > +       bool flush;
> > +
> > +       flush = slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> > +                                 PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL, true);
>
> The max level here only needs to be 2M since 1G page wouldn't be
> split. I think the upper limit can be lowered to
> KVM_MAX_HUGEPAGE_LEVEL - 1.
> Not a significant performance difference though.

Good point. There's no reason to look at huge pages that are already
mapped at the maximum possible level.

>
> > +
> > +       if (flush)
> > +               kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +
> > +}
> > +
> >  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >                                    const struct kvm_memory_slot *slot)
> >  {
> >         if (kvm_memslots_have_rmaps(kvm)) {
> >                 write_lock(&kvm->mmu_lock);
> > -               /*
> > -                * Zap only 4k SPTEs since the legacy MMU only supports dirty
> > -                * logging at a 4k granularity and never creates collapsible
> > -                * 2m SPTEs during dirty logging.
> > -                */
> > -               if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
> > -                       kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +               kvm_rmap_zap_collapsible_sptes(kvm, slot);
> >                 write_unlock(&kvm->mmu_lock);
> >         }
> >
> > --
> > 2.35.0.rc2.247.g8bbb082509-goog
> >
