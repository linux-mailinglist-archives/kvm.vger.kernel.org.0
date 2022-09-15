Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE2C5B9A16
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 13:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiIOLxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 07:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiIOLxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 07:53:15 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C18E0F3;
        Thu, 15 Sep 2022 04:48:33 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 198so22206818ybc.1;
        Thu, 15 Sep 2022 04:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=4YTgZoPUV69pkvO04Qiq1IYFTKDs/Mxeui6UQ1pONmc=;
        b=doeLDP9Ubh/IeqpCSgQUVTFxxeA0lvwaLlXCjYtIID7JzzIGB5Nb9dRQ0h77qJGQJx
         Ri6k5/732JSNadr9wxLD2VBQFbu3hacXa/AkAPwD4gqlZl/o+kDQRb0K45AZihvWaiTO
         GJtEx9cMt1j2BRVAo3FsFaLtDQlCIDhnSwHfWeIi71b0ksjla7DN+S8fWWti4m7G9kvV
         Vlp941xt6lBlRn1mlJHq+dE0rwEufr8Y7eXwp0U49YNh/MZ0oXwdZL3Bn5bXwM9OHukl
         9/1/VOCXd5mmRCNkZcirHvQzN4utl0wVVdetojiUrIG4u8w9DqyJM4mAkW828cdQDGON
         MsNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4YTgZoPUV69pkvO04Qiq1IYFTKDs/Mxeui6UQ1pONmc=;
        b=gn3OSxN+QmUaEknaWdy1n3ufut3dtqpxnwQe8mhjfRVh3xG9Pc/7QpT88yo3g3N8wp
         CSba8WEpMyt+LU3icgWEGJH9xrcma2VbhfI94T5iK71WuvXHzh0TJQ+AhzogdaXAkecD
         gAP+wrUrKlTWXvtg7JgGk/USuBy8WvfIwNpDQ9dMrEk0S5jWb9ad2YaS9UYttIsu5qTj
         6dI0YIdLp+4PB0B6WDwjQk2nwCsKhps3nHPCnyZ8z/KvfmkljK0kDnO46+NyHoh/9lKw
         PSWjqrE3eC7uuXvgFzYlFP8qiP/NuNgPk7NsJjAWQWvqYq3hAyI0C02lWySt+bMFeQMP
         xQ9Q==
X-Gm-Message-State: ACgBeo0vO5pP6op8Lgo7lLXf1LP/OAnqzgZMPLfsaPOTuRp7T/nykbpu
        stgM65ZCYAZzOimPSFPHNuXbKWa08bJ6PQD2pTg=
X-Google-Smtp-Source: AA6agR77ddqEgMedXuRm0TKVtk33AbWPYKaOy/lMd4lAb26Herzft/YJpS1ICnsCGdUcKMreZ2r97PrmZAyiSxyMe3M=
X-Received: by 2002:a25:b9c8:0:b0:675:9dcf:e60b with SMTP id
 y8-20020a25b9c8000000b006759dcfe60bmr33079977ybj.188.1663242464452; Thu, 15
 Sep 2022 04:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <c0ee12e44f2d218a0857a5e05628d05462b32bf9.1661331396.git.houwenlong.hwl@antgroup.com>
 <YxjYWtgLZMxFBrjl@google.com> <20220913120721.GA113257@k08j02272.eu95sqa>
In-Reply-To: <20220913120721.GA113257@k08j02272.eu95sqa>
From:   Liam Ni <zhiguangni01@gmail.com>
Date:   Thu, 15 Sep 2022 19:47:35 +0800
Message-ID: <CACZJ9cWP6fXNHuL6r3sHkTDEtR8q1Aw=7DG2Mkj24XCONNL+Yg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in validate_direct_spte()
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Sept 2022 at 20:13, Hou Wenlong <houwenlong.hwl@antgroup.com> wr=
ote:
>
> On Thu, Sep 08, 2022 at 01:43:54AM +0800, David Matlack wrote:
> > On Wed, Aug 24, 2022 at 05:29:18PM +0800, Hou Wenlong wrote:
> > > The spte pointing to the children SP is dropped, so the
> > > whole gfn range covered by the children SP should be flushed.
> > > Although, Hyper-V may treat a 1-page flush the same if the
> > > address points to a huge page, it still would be better
> > > to use the correct size of huge page. Also introduce
> > > a helper function to do range-based flushing when a direct
> > > SP is dropped, which would help prevent future buggy use
> > > of kvm_flush_remote_tlbs_with_address() in such case.
> > >
> > > Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new o=
ne to flush a specified range.")
> > > Suggested-by: David Matlack <dmatlack@google.com>
> > > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e418ef3ecfcb..a3578abd8bbc 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -260,6 +260,14 @@ void kvm_flush_remote_tlbs_with_address(struct k=
vm *kvm,
> > >     kvm_flush_remote_tlbs_with_range(kvm, &range);
> > >  }
> > >
> > > +/* Flush all memory mapped by the given direct SP. */
> > > +static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct =
kvm_mmu_page *sp)
> > > +{
> > > +   WARN_ON_ONCE(!sp->role.direct);
> > > +   kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> > > +                                      KVM_PAGES_PER_HPAGE(sp->role.l=
evel + 1));

Do we need "+1" here?    sp->role.level=3D1 means 4k page.
I think here should be   =E2=80=9CKVM_PAGES_PER_HPAGE(sp->role.level)=E2=80=
=9D

> >
> > nit: I think it would make sense to introduce
> > kvm_flush_remote_tlbs_gfn() in this patch since you are going to
> > eventually use it here anyway.
> >
> OK, I'll do it in the next version. Thanks!
>
> > > +}
> > > +
> > >  static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gf=
n,
> > >                        unsigned int access)
> > >  {
> > > @@ -2341,7 +2349,7 @@ static void validate_direct_spte(struct kvm_vcp=
u *vcpu, u64 *sptep,
> > >                     return;
> > >
> > >             drop_parent_pte(child, sptep);
> > > -           kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn,=
 1);
> > > +           kvm_flush_remote_tlbs_direct_sp(vcpu->kvm, child);
> > >     }
> > >  }
> > >
> > > --
> > > 2.31.1
> > >
