Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A5072A841
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 04:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjFJCQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 22:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjFJCQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 22:16:39 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0F23ABB;
        Fri,  9 Jun 2023 19:16:37 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-650c8cb68aeso2169993b3a.3;
        Fri, 09 Jun 2023 19:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686363397; x=1688955397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcNhoUDAsRpK7BoMM5YSCG2VySoUwtfJPQtOXEJqtTU=;
        b=qVyT4CjpB0MKdpACa6p1GEhW/46l2HdxkIu/rZNsu5Dt1bsZt6ZOvk7h4Czhl1fzDb
         0Cw1HiMReQDkTL3Mrb6mFqMjLGfeSSQwFBiGP0EK4hJWCJmi2Te5jQY6uyiFFLqDOB9L
         7UawZ6enqwjwnBtFxR7n+0BNWcjcOciotTv6TdTBCKzt39XBjumhauFM5vrNmHicUDJV
         AD4OVmDE7d/P3zRccnIQvVj21mIPrPRq9MczKwj9ydsNBcADAkbnSOMVvz56vAl3dvI9
         o6KkZrdxX9b5z6PbC8kP5yzEjq7cJldl87iVRoh/gCJwmLNlhXMdhn9uhChasNezxDjA
         7kfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686363397; x=1688955397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcNhoUDAsRpK7BoMM5YSCG2VySoUwtfJPQtOXEJqtTU=;
        b=dpTl9bfKSqBJZJg/0ZUY85opTO5APxFWi67kdorHE1fqEHOuDV0F6EqLJnKi9ymQ43
         HG40jdjG8UTXG4Iv5j48oL8U263Lt141qAelj9JCX5mx56XQFXDPRCuhXVClvrQLAEQY
         PGK59wkLIt5TWC81oCAWnhhFqsQPl1LCkl4eqxpcHxOn3DEZNVKG0kpNpBS3ERWGNCjo
         0AA5nYVzMVWh8KAS3eUsx6OQDY/n8Ua8NvmA6K3nTJrSbBgXrwaUrlh25v5F7P1m1BiC
         77hut2mEWAuycFORC097j8NAH0GqGrI3dihQVAKjPPRKqIjww9hsRQxpxrc+FJxi2OYU
         kKcw==
X-Gm-Message-State: AC+VfDwv6VdHuO9T/9KhWSsNiJbmTIiROk+NJM1LvCra3tSHmzlLhuIl
        D7+nfnGIL/iZ2hSl3Yb0l4SqvzA9pwzeQVsQgXc=
X-Google-Smtp-Source: ACHHUZ4ModfoosTDVIdw89bsBYkL/hBOUxrCimDBvQCANSRpX9NorT950iLu4U9Qy1/mDaZZ+XeLxfe8v6iIZ40UnA4=
X-Received: by 2002:a05:6a00:1887:b0:663:18c:a176 with SMTP id
 x7-20020a056a00188700b00663018ca176mr3493868pfh.32.1686363397055; Fri, 09 Jun
 2023 19:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
 <20230605064848.12319-6-jpn@linux.vnet.ibm.com> <CT6ATGRN6KJU.12QZ7TJGGX7LC@wheely>
In-Reply-To: <CT6ATGRN6KJU.12QZ7TJGGX7LC@wheely>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Sat, 10 Jun 2023 12:16:25 +1000
Message-ID: <CACzsE9p-tKtNSjO6jFmRJaG2iWZE-F8jd_NgsRLKSYgqGpRySQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/6] KVM: PPC: Add support for nested PAPR guests
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Jordan Niethe <jpn@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, mikey@neuling.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, sbhat@linux.ibm.com,
        vaibhav@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 7, 2023 at 7:09=E2=80=AFPM Nicholas Piggin <npiggin@gmail.com> =
wrote:
[snip]
>
> You lost your comments.

Thanks

>
> > diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/inclu=
de/asm/kvm_book3s.h
> > index 0ca2d8b37b42..c5c57552b447 100644
> > --- a/arch/powerpc/include/asm/kvm_book3s.h
> > +++ b/arch/powerpc/include/asm/kvm_book3s.h
> > @@ -12,6 +12,7 @@
> >  #include <linux/types.h>
> >  #include <linux/kvm_host.h>
> >  #include <asm/kvm_book3s_asm.h>
> > +#include <asm/guest-state-buffer.h>
> >
> >  struct kvmppc_bat {
> >       u64 raw;
> > @@ -316,6 +317,57 @@ long int kvmhv_nested_page_fault(struct kvm_vcpu *=
vcpu);
> >
> >  void kvmppc_giveup_fac(struct kvm_vcpu *vcpu, ulong fac);
> >
> > +
> > +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> > +
> > +extern bool __kvmhv_on_papr;
> > +
> > +static inline bool kvmhv_on_papr(void)
> > +{
> > +     return __kvmhv_on_papr;
> > +}
>
> It's a nitpick, but kvmhv_on_pseries() is because we're runnning KVM-HV
> on a pseries guest kernel. Which is a papr guest kernel. So this kind of
> doesn't make sense if you read it the same way.
>
> kvmhv_nested_using_papr() or something like that might read a bit
> better.

Will we go with kvmhv_using_nested_v2()?

>
> This could be a static key too.

Will do.

>
> > @@ -575,6 +593,7 @@ struct kvm_vcpu_arch {
> >       ulong dscr;
> >       ulong amr;
> >       ulong uamor;
> > +     ulong amor;
> >       ulong iamr;
> >       u32 ctrl;
> >       u32 dabrx;
>
> This belongs somewhere else.

It can be dropped.

>
> > @@ -829,6 +848,8 @@ struct kvm_vcpu_arch {
> >       u64 nested_hfscr;       /* HFSCR that the L1 requested for the ne=
sted guest */
> >       u32 nested_vcpu_id;
> >       gpa_t nested_io_gpr;
> > +     /* For nested APIv2 guests*/
> > +     struct kvmhv_papr_host papr_host;
> >  #endif
>
> This is not exactly a papr host. Might have to come up with a better
> name especially if we implement a L0 things could get confusing.

Any name ideas? nestedv2_state?

>
> > @@ -342,6 +343,203 @@ static inline long plpar_get_cpu_characteristics(=
struct h_cpu_char_result *p)
> >       return rc;
> >  }
> >
> > +static inline long plpar_guest_create(unsigned long flags, unsigned lo=
ng *guest_id)
> > +{
> > +     unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
> > +     unsigned long token;
> > +     long rc;
> > +
> > +     token =3D -1UL;
> > +     while (true) {
> > +             rc =3D plpar_hcall(H_GUEST_CREATE, retbuf, flags, token);
> > +             if (rc =3D=3D H_SUCCESS) {
> > +                     *guest_id =3D retbuf[0];
> > +                     break;
> > +             }
> > +
> > +             if (rc =3D=3D H_BUSY) {
> > +                     token =3D retbuf[0];
> > +                     cpu_relax();
> > +                     continue;
> > +             }
> > +
> > +             if (H_IS_LONG_BUSY(rc)) {
> > +                     token =3D retbuf[0];
> > +                     mdelay(get_longbusy_msecs(rc));
>
> All of these things need a non-sleeping delay? Can we sleep instead?
> Or if not, might have to think about going back to the caller and it
> can retry.
>
> get/set state might be a bit inconvenient, although I don't expect
> that should potentially take so long as guest and vcpu create/delete,
> so at least those ones would be good if they're called while
> preemptable.

Yeah no reason not to sleep except for get/set, let me try it out.

>
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.=
c
> > index 521d84621422..f22ee582e209 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -383,6 +383,11 @@ static void kvmppc_core_vcpu_put_hv(struct kvm_vcp=
u *vcpu)
> >       spin_unlock_irqrestore(&vcpu->arch.tbacct_lock, flags);
> >  }
> >
> > +static void kvmppc_set_pvr_hv(struct kvm_vcpu *vcpu, u32 pvr)
> > +{
> > +     vcpu->arch.pvr =3D pvr;
> > +}
>
> Didn't you lose this in a previous patch? I thought it must have moved
> to a header but it reappears.

Yes, that was meant to stay put.

>
> > +
> >  /* Dummy value used in computing PCR value below */
> >  #define PCR_ARCH_31    (PCR_ARCH_300 << 1)
> >
> > @@ -1262,13 +1267,14 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vc=
pu)
> >                       return RESUME_HOST;
> >               break;
> >  #endif
> > -     case H_RANDOM:
> > +     case H_RANDOM: {
> >               unsigned long rand;
> >
> >               if (!arch_get_random_seed_longs(&rand, 1))
> >                       ret =3D H_HARDWARE;
> >               kvmppc_set_gpr(vcpu, 4, rand);
> >               break;
> > +     }
> >       case H_RPT_INVALIDATE:
> >               ret =3D kvmppc_h_rpt_invalidate(vcpu, kvmppc_get_gpr(vcpu=
, 4),
> >                                             kvmppc_get_gpr(vcpu, 5),
>
> Compile fix for a previous patch.

Thanks.

>
> > @@ -2921,14 +2927,21 @@ static int kvmppc_core_vcpu_create_hv(struct kv=
m_vcpu *vcpu)
> >       vcpu->arch.shared_big_endian =3D false;
> >  #endif
> >  #endif
> > -     kvmppc_set_mmcr_hv(vcpu, 0, MMCR0_FC);
> >
> > +     if (kvmhv_on_papr()) {
> > +             err =3D kvmhv_papr_vcpu_create(vcpu, &vcpu->arch.papr_hos=
t);
> > +             if (err < 0)
> > +                     return err;
> > +     }
> > +
> > +     kvmppc_set_mmcr_hv(vcpu, 0, MMCR0_FC);
> >       if (cpu_has_feature(CPU_FTR_ARCH_31)) {
> >               kvmppc_set_mmcr_hv(vcpu, 0, kvmppc_get_mmcr_hv(vcpu, 0) |=
 MMCR0_PMCCEXT);
> >               kvmppc_set_mmcra_hv(vcpu, MMCRA_BHRB_DISABLE);
> >       }
> >
> >       kvmppc_set_ctrl_hv(vcpu, CTRL_RUNLATCH);
> > +     kvmppc_set_amor_hv(vcpu, ~0);
>
> This AMOR thing should go somewhere else. Not actually sure why it needs
> to be added to the vcpu since it's always ~0. Maybe just put that in a
> #define somewhere and use that.

Yes, you are right, just can get rid of it from the vcpu entirely.
>
> > @@ -4042,6 +4059,50 @@ static void vcpu_vpa_increment_dispatch(struct k=
vm_vcpu *vcpu)
> >       }
> >  }
> >
> > +static int kvmhv_vcpu_entry_papr(struct kvm_vcpu *vcpu, u64 time_limit=
, unsigned long lpcr, u64 *tb)
> > +{
> > +     struct kvmhv_papr_host *ph;
> > +     unsigned long msr, i;
> > +     int trap;
> > +     long rc;
> > +
> > +     ph =3D &vcpu->arch.papr_host;
> > +
> > +     msr =3D mfmsr();
> > +     kvmppc_msr_hard_disable_set_facilities(vcpu, msr);
> > +     if (lazy_irq_pending())
> > +             return 0;
> > +
> > +     kvmhv_papr_flush_vcpu(vcpu, time_limit);
> > +
> > +     accumulate_time(vcpu, &vcpu->arch.in_guest);
> > +     rc =3D plpar_guest_run_vcpu(0, vcpu->kvm->arch.lpid, vcpu->vcpu_i=
d,
> > +                               &trap, &i);
> > +
> > +     if (rc !=3D H_SUCCESS) {
> > +             pr_err("KVM Guest Run VCPU hcall failed\n");
> > +             if (rc =3D=3D H_INVALID_ELEMENT_ID)
> > +                     pr_err("KVM: Guest Run VCPU invalid element id at=
 %ld\n", i);
> > +             else if (rc =3D=3D H_INVALID_ELEMENT_SIZE)
> > +                     pr_err("KVM: Guest Run VCPU invalid element size =
at %ld\n", i);
> > +             else if (rc =3D=3D H_INVALID_ELEMENT_VALUE)
> > +                     pr_err("KVM: Guest Run VCPU invalid element value=
 at %ld\n", i);
> > +             return 0;
> > +     }
>
> This needs the proper error handling. Were you going to wait until I
> sent that up for existing code?

Overall the unhappy paths need to be tightened up in the next revision.
But yeah this hits the same thing as the v1 API.

>
> > @@ -5119,6 +5183,7 @@ static void kvmppc_core_commit_memory_region_hv(s=
truct kvm *kvm,
> >   */
> >  void kvmppc_update_lpcr(struct kvm *kvm, unsigned long lpcr, unsigned =
long mask)
> >  {
> > +     struct kvm_vcpu *vcpu;
> >       long int i;
> >       u32 cores_done =3D 0;
> >
> > @@ -5139,6 +5204,12 @@ void kvmppc_update_lpcr(struct kvm *kvm, unsigne=
d long lpcr, unsigned long mask)
> >               if (++cores_done >=3D kvm->arch.online_vcores)
> >                       break;
> >       }
> > +
> > +     if (kvmhv_on_papr()) {
> > +             kvm_for_each_vcpu(i, vcpu, kvm) {
> > +                     kvmppc_set_lpcr_hv(vcpu, vcpu->arch.vcore->lpcr);
> > +             }
> > +     }
> >  }
>
> vcpu define could go in that scope I guess.

True.

>
> > @@ -5405,15 +5476,43 @@ static int kvmppc_core_init_vm_hv(struct kvm *k=
vm)
> >
> >       /* Allocate the guest's logical partition ID */
> >
> > -     lpid =3D kvmppc_alloc_lpid();
> > -     if ((long)lpid < 0)
> > -             return -ENOMEM;
> > -     kvm->arch.lpid =3D lpid;
> > +     if (!kvmhv_on_papr()) {
> > +             lpid =3D kvmppc_alloc_lpid();
> > +             if ((long)lpid < 0)
> > +                     return -ENOMEM;
> > +             kvm->arch.lpid =3D lpid;
> > +     }
> >
> >       kvmppc_alloc_host_rm_ops();
> >
> >       kvmhv_vm_nested_init(kvm);
> >
> > +     if (kvmhv_on_papr()) {
> > +             long rc;
> > +             unsigned long guest_id;
> > +
> > +             rc =3D plpar_guest_create(0, &guest_id);
> > +
> > +             if (rc !=3D H_SUCCESS)
> > +                     pr_err("KVM: Create Guest hcall failed, rc=3D%ld\=
n", rc);
> > +
> > +             switch (rc) {
> > +             case H_PARAMETER:
> > +             case H_FUNCTION:
> > +             case H_STATE:
> > +                     return -EINVAL;
> > +             case H_NOT_ENOUGH_RESOURCES:
> > +             case H_ABORTED:
> > +                     return -ENOMEM;
> > +             case H_AUTHORITY:
> > +                     return -EPERM;
> > +             case H_NOT_AVAILABLE:
> > +                     return -EBUSY;
> > +             }
> > +             kvm->arch.lpid =3D guest_id;
> > +     }
>
> I wouldn't mind putting lpid/guest_id in different variables. guest_id
> is 64-bit isn't it? LPIDR is 32. If nothing else that could cause
> issues if the hypervisor does something clever with the token.

I was trying to get rid of a difference between this API and  the
others, but I'd forgotten about the 64bit / 32bit difference.
Will put it back in its own variable.

>
> > @@ -5573,10 +5675,14 @@ static void kvmppc_core_destroy_vm_hv(struct kv=
m *kvm)
> >               kvm->arch.process_table =3D 0;
> >               if (kvm->arch.secure_guest)
> >                       uv_svm_terminate(kvm->arch.lpid);
> > -             kvmhv_set_ptbl_entry(kvm->arch.lpid, 0, 0);
> > +             if (!kvmhv_on_papr())
> > +                     kvmhv_set_ptbl_entry(kvm->arch.lpid, 0, 0);
> >       }
>
> Would be nice to have a +ve test for the "existing" API. All we have to
> do is think of a name for it.

Will we go with nestedv1?

Thanks,
Jordan

>
> Thanks,
> Nick
>
