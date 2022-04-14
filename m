Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AA850198C
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 19:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243665AbiDNRGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 13:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242929AbiDNRFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 13:05:46 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56174B40B
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 09:48:18 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b21so10131540lfb.5
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 09:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GTnxN2EsXf7ieA0fobbMxJGrUwua/adr0ftiCPpCUzQ=;
        b=E9X+HevX/munaDaFP2+L4BTUvOLjQ3Atyl/N5WHb0hix11i3pVfzmc3PEzJoSUYkNB
         kKbmjOfHBGc3o+T+HXmwcyk+IPoD7qfYclxNjV7BLaOZXmi2w333teJgRcWg/nw0ocCw
         dj3NuceO6AACJKn5xXJi6OoRoRiWoOgTbBRE5xCnUnt6b1B3JsqdGmziR6FpmkxzluTc
         cPBMcE2j+uQtolIJbw/WoSYVgBLvFu4oFiBnDsukX8xkcly7cBRY0aHIaK2+aq66Gj3G
         9iDZGJWTpgfKzz6/wsCLyg/mB0ju2t+lOtzeVyuEUsOEf3/1af+6f90MYFLDQ4fK41P0
         o9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GTnxN2EsXf7ieA0fobbMxJGrUwua/adr0ftiCPpCUzQ=;
        b=wGPnfCBnf2RrDsc3jQ+PPPGJDTBvu1yS3yLlhEHLeCIv+rTM5wcgyDbn8YK/8aMO0e
         aMUvtXwB5tf0Gph/EzarVVQ/FGdqTNBEZjlFx1fXel/FoYBdhtKOeRh56ECF4ddAV24M
         XZJheHqcgvT0VMzS2ItTq0RJqammcAa0g2N+ih6c41+qWOTmsPCf/edCJEEJLUbjlPgE
         fp9IhahFdKuBbc9Wn4iePbpWN1FgbKmmzATO+lYYIXcrcwv7qCs9LaMV/V7MApRFNWjC
         fGKS/jc1U4uyRQ0K+zYs+FFBfEHQGKCcco4NfQ49W9biH1LNiv8qHr0rQSiO0GjuP4Ga
         eSvQ==
X-Gm-Message-State: AOAM530RIceZrMnOZXIjl0PLVvi0fir9/2y68YvoXgrsXufWvqMxtoij
        HWx9mtHQNeg+dKzHs/VBQ3vnI5QU1fY5DQHKeFvYeQ==
X-Google-Smtp-Source: ABdhPJxlX3xjitRrl/Un3A8yoTtpZQfxnASYEEhBfhrSiF6WomrTewtGPfnVL5HO2q+whTsAMFSLhLgqVTad6UPvK1Q=
X-Received: by 2002:a05:6512:1285:b0:46b:a899:1111 with SMTP id
 u5-20020a056512128500b0046ba8991111mr2517893lfs.190.1649954896726; Thu, 14
 Apr 2022 09:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com> <20220401175554.1931568-17-dmatlack@google.com>
 <YlDNE55k9DNf/v2+@google.com>
In-Reply-To: <YlDNE55k9DNf/v2+@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 14 Apr 2022 09:47:49 -0700
Message-ID: <CALzav=dt+xKfk5n9o6AP0+PEUpoyB6UN5ktxT4+hZEQNbODdSA@mail.gmail.com>
Subject: Re: [PATCH v3 16/23] KVM: x86/mmu: Cache the access bits of shadowed translations
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
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

On Fri, Apr 8, 2022 at 5:02 PM Sean Christopherson <seanjc@google.com> wrot=
e:
>
> On Fri, Apr 01, 2022, David Matlack wrote:
> > @@ -733,7 +733,7 @@ static void mmu_free_pte_list_desc(struct pte_list_=
desc *pte_list_desc)
> >  static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
> >  {
> >       if (!sp->role.direct)
> > -             return sp->gfns[index];
> > +             return sp->shadowed_translation[index].gfn;
> >
> >       return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BIT=
S));
> >  }
> > @@ -741,7 +741,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_pa=
ge *sp, int index)
> >  static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, g=
fn_t gfn)
>
> This should be replaced with a single helper to set the gfn+access.  Unde=
r no
> circumstance should _just_ the gfn change, and that will allow us to opti=
mize
> writing the entry.  More below.
>
> >  {
> >       if (!sp->role.direct) {
> > -             sp->gfns[index] =3D gfn;
> > +             sp->shadowed_translation[index].gfn =3D gfn;
> >               return;
> >       }
> >
> > @@ -752,6 +752,47 @@ static void kvm_mmu_page_set_gfn(struct kvm_mmu_pa=
ge *sp, int index, gfn_t gfn)
> >                                  kvm_mmu_page_get_gfn(sp, index), gfn);
> >  }
> >
> > +static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index=
, u32 access)
> > +{
> > +     if (!sp->role.direct) {
> > +             sp->shadowed_translation[index].access =3D access;
> > +             return;
> > +     }
> > +
> > +     if (WARN_ON(access !=3D sp->role.access))
> > +             pr_err_ratelimited("access mismatch under direct page %ll=
x "
>
> LOL, I realize this is not your code, but ratelimiting under a WARN ain't=
 gonna
> help much :-)

Ha! Yeah this silly. I'll see about adding a precursor patch to make
it less terrible.

>
> This also generates a warning and fails to compile with KVM_WERROR=3Dy, t=
hough I
> believe the test bots already reported that.
>
>
> arch/x86/kvm/mmu/mmu.c: In function =E2=80=98kvm_mmu_page_set_access=E2=
=80=99:
> include/linux/kern_levels.h:5:25: error: format =E2=80=98%llx=E2=80=99 ex=
pects argument of type =E2=80=98long long unsigned int=E2=80=99, but argume=
nt 3 has type =E2=80=98int=E2=80=99 [-Werror=3Dformat=3D]
>     5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header =
*/
>       |                         ^~~~~~
> include/linux/printk.h:418:25: note: in definition of macro =E2=80=98prin=
tk_index_wrap=E2=80=99
>   418 |                 _p_func(_fmt, ##__VA_ARGS__);                    =
       \
>       |                         ^~~~
> include/linux/printk.h:640:17: note: in expansion of macro =E2=80=98print=
k=E2=80=99
>   640 |                 printk(fmt, ##__VA_ARGS__);                      =
       \
>       |                 ^~~~~~
> include/linux/printk.h:654:9: note: in expansion of macro =E2=80=98printk=
_ratelimited=E2=80=99
>   654 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>       |         ^~~~~~~~~~~~~~~~~~
> include/linux/kern_levels.h:11:25: note: in expansion of macro =E2=80=98K=
ERN_SOH=E2=80=99
>    11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
>       |                         ^~~~~~~~
> include/linux/printk.h:654:28: note: in expansion of macro =E2=80=98KERN_=
ERR=E2=80=99
>   654 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>       |                            ^~~~~~~~
> arch/x86/kvm/mmu/mmu.c:763:17: note: in expansion of macro =E2=80=98pr_er=
r_ratelimited=E2=80=99
>   763 |                 pr_err_ratelimited("access mismatch under direct =
page %llx "
>       |                 ^~~~~~~~~~~~~~~~~~
>
>
> > +                                "(expected %llx, got %llx)\n",
> > +                                kvm_mmu_page_get_gfn(sp, index),
> > +                                sp->role.access, access);
> > +}
> > +
> > +/*
> > + * For leaf SPTEs, fetch the *guest* access permissions being shadowed=
. Note
> > + * that the SPTE itself may have a more constrained access permissions=
 that
> > + * what the guest enforces. For example, a guest may create an executa=
ble
> > + * huge PTE but KVM may disallow execution to mitigate iTLB multihit.
> > + */
> > +static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
> > +{
> > +     if (!sp->role.direct)
> > +             return sp->shadowed_translation[index].access;
> > +
> > +     /*
> > +      * For direct MMUs (e.g. TDP or non-paging guests) there are no *=
guest*
> > +      * access permissions being shadowed. So we can just return ACC_A=
LL
> > +      * here.
> > +      *
> > +      * For indirect MMUs (shadow paging), direct shadow pages exist w=
hen KVM
> > +      * is shadowing a guest huge page with smaller pages, since the g=
uest
> > +      * huge page is being directly mapped. In this case the guest acc=
ess
> > +      * permissions being shadowed are the access permissions of the h=
uge
> > +      * page.
> > +      *
> > +      * In both cases, sp->role.access contains exactly what we want.
> > +      */
> > +     return sp->role.access;
> > +}
>
> ...
>
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_int=
ernal.h
> > index b6e22ba9c654..3f76f4c1ae59 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -32,6 +32,18 @@ extern bool dbg;
> >
> >  typedef u64 __rcu *tdp_ptep_t;
> >
> > +/*
> > + * Stores the result of the guest translation being shadowed by an SPT=
E. KVM
> > + * shadows two types of guest translations: nGPA -> GPA (shadow EPT/NP=
T) and
> > + * GVA -> GPA (traditional shadow paging). In both cases the result of=
 the
> > + * translation is a GPA and a set of access constraints.
> > + */
> > +struct shadowed_translation_entry {
> > +     /* Note, GFNs can have at most 64 - PAGE_SHIFT =3D 52 bits. */
> > +     u64 gfn:52;
> > +     u64 access:3;
>
> A bitfield is completely unnecessary and generates bad code.  As is, it g=
enerates
> _really_ bad code because extracting and setting requires non-standard 64=
-bit value
> masks, multiple operations, and accesses to unaligned data.  The generate=
d code can
> be made slightly less awful by using a fully byte for access and 64 bits =
for GFN,
> but it still sucks compared to what we can hand generate.
>
> The other aspect of this is that retrieving the GFN is a frequent operati=
on,
> whereas the access is almost never read.  I.e. we should bias for reading=
 the GFN
> above all else.
>
> The simple and obvious thing is to not reinvent the wheel.  GFN =3D (GPA =
>> PAGE_SHIFT),
> and ignoring NX, access lives in the lower 12 bits of a PTE.  Then readin=
g the GFN is
> a simple SHR, and reading access info is a simple AND.
>
> We might also be able to optimize FNAME(sync_page), but I don't care much=
 about
> that, it's rarely used for nested TDP.
>
> So, keep translation_entry a gfn_t *, then do:

Looks good, will do in v4.

>
> static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
> {
>         if (!sp->role.direct)
>                 return sp->shadowed_translation[index] >> PAGE_SHIFT;
>
>         return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BIT=
S));
> }
>
> static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int ind=
ex,
>                                          gfn_t gfn, unsigned int access)
> {
>         if (!sp->role.direct) {
>                 sp->shadowed_translation[index] =3D (gfn << PAGE_SHIFT) |=
 access;
>                 return;
>         }
>
>         if (WARN_ON(gfn !=3D kvm_mmu_page_get_gfn(sp, index)))
>                 pr_err_ratelimited("gfn mismatch under direct page %llx "
>                                    "(expected %llx, got %llx)\n",
>                                    sp->gfn,
>                                    kvm_mmu_page_get_gfn(sp, index), gfn);
> }
>
> static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
>                                     unsigned int access)
> {
>         if (sp->role.direct)
>                 return;
>
>         sp->shadowed_translation[index] &=3D PAGE_MASK;
>         sp->shadowed_translation[index] |=3D access;
> }
>
