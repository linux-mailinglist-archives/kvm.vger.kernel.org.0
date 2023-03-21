Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6BF6C38FD
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 19:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjCUSQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 14:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCUSQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 14:16:06 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A082313DCE
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:16:02 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id f16so16432576ljq.10
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679422561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BND2reZbrACVYlW63dB5E1+8EoTldLzcT8Xu9BiGX8g=;
        b=e8kgqOlMiby4+JCWO/YjZYidyFAEopXLorFTy+IxbNxFfsRy9oxw9SLoXKG8cK93xQ
         nvgLneU7bwPofLJXCm30FAD0JwMnE6gUubxxWm0N+ZOcsPadiegdRdH3nRoUGgCM8Jiy
         MrbCmoN7glS+3ZOMueWBC3V1sBuVONcTgExbIClVHXYguKIFQ2ZNpNT5URyWazAqezmo
         AyGNbEiMLmodfpUfL8/IkhznpBEmRXwnXNueml8ggmj7Q3w51Y+9lK0r5oXJ2OM9wC1e
         UjGijPYxYRa2Lf7q8vLQq+6mOVpnBwkXzVn+OqUuzqiGLOjM8+7cKFt5lnJ95m522WMj
         IscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679422561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BND2reZbrACVYlW63dB5E1+8EoTldLzcT8Xu9BiGX8g=;
        b=eULrTyXxxltGnHhx02C944uDwHTaspxqcA84AwByYrGCDS7a2zTk6wi5c9+XM6VGaW
         5eZXSZtGICWiacNblMmDBRyNxdGKiTQJ8gJhecQEFsBmDpg+L9oGJONj4tN0KiaYyUaJ
         9HRz+kwrVWaLY7/1AxCjxiEFU1qxw96oKjLMIWOhZIkSGBRBAiDMpFUDqP8eIzG9xFHF
         mdJ2WWLkZhfJrA0LPO4TnqXX1QetMc4gqSLWMlb7sOTVvcM7bIyLMxVxZ2VlNDnQFX1X
         ldw/glac0+nUam5sFSZVokZbJh6cgvDqBg1aE5ygOVtqe+uIawr+H9A94ssYhXQvNXPr
         Tlhg==
X-Gm-Message-State: AO0yUKVOx7nOv2nSC/bqY2oKZt6HumQSGCJ2qvDqXDr+skHSYzGME7X7
        5exGL+PqD70tMVWp977f/zFvLZ2VIbgZAbemVmdxYuwQm1gsDsXut/E7fQ==
X-Google-Smtp-Source: AK7set+JTIRGS0cX+zWO6juq5/jEsTljUy7Ju9GSgdu+MWk0/2cvL31/lPsBbGQI9z2swzjxv0AhLgdwG+lootPuLHQ=
X-Received: by 2002:a2e:9c4c:0:b0:298:afbd:5aef with SMTP id
 t12-20020a2e9c4c000000b00298afbd5aefmr1195371ljj.2.1679422560741; Tue, 21 Mar
 2023 11:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230320225159.92771-1-graf@amazon.com> <ZBnjZg6jxPtBPXc2@google.com>
In-Reply-To: <ZBnjZg6jxPtBPXc2@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 21 Mar 2023 12:15:47 -0600
Message-ID: <CAMkAt6ozZ5LwvRNn+hP5-ZGOyrtDMmBUR+x5iJ37xVZyQk4kBw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Allow restore of some sregs with protected state
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Sabin Rapan <sabrapan@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 11:03=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> +Peter
>
> On Mon, Mar 20, 2023, Alexander Graf wrote:
> > With protected state (like SEV-ES and SEV-SNP), KVM does not have direc=
t
> > access to guest registers. However, we deflect modifications to CR0,
>
> Please avoid pronouns in changelogs and comments.
>
> > CR4 and EFER to the host. We also carry the apic_base register and lear=
n
> > about CR8 directly from a VMCB field.
> >
> > That means these bits of information do exist in the host's KVM data
> > structures. If we ever want to resume consumption of an already
> > initialized VMSA (guest state), we will need to also restore these
> > additional bits of KVM state.
>
> For some definitions of "need".  I've looked at this code multiple times =
in the
> past, and even posted patches[1], but I'm still unconvinced that trapping
> CR0, CR4, and EFER updates is necessary[2], which is partly why series to=
 fix
> this stalled out.
>
>  : If KVM chugs along happily without these patches, I'd love to pivot an=
d yank out
>  : all of the CR0/4/8 and EFER trapping/tracking, and then make KVM_GET_S=
REGS a nop
>  : as well.
>
> [1] https://lore.kernel.org/all/20210507165947.2502412-1-seanjc@google.co=
m
> [2] https://lore.kernel.org/all/YJla8vpwqCxqgS8C@google.com

Yea we are using similar patches to do intra-host migration for SNP VMs.

I have dropped the ball on my AI from that thread. Let me look/test this pa=
tch.

>
> > Prepare ourselves for such a world by allowing set_sregs to set the
> > relevant fields. This way, it mirrors get_sregs properly that already
> > exposes them to user space.
> >
> > Signed-off-by: Alexander Graf <graf@amazon.com>
> > ---
> >  arch/x86/kvm/x86.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 7713420abab0..88fa8b657a2f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11370,7 +11370,8 @@ static int __set_sregs_common(struct kvm_vcpu *=
vcpu, struct kvm_sregs *sregs,
> >       int idx;
> >       struct desc_ptr dt;
> >
> > -     if (!kvm_is_valid_sregs(vcpu, sregs))
> > +     if (!vcpu->arch.guest_state_protected &&
> > +         !kvm_is_valid_sregs(vcpu, sregs))
>
> This is broken, userspace shouldn't be allowed to stuff complete garbage =
just
> because guest state is protected.

Agreed, we've been using something like this:

kvm_valid_sregs()
-       if (sregs->fer & EFER_LME && !vcpu->arch.guest_state_protected) {
+       if (sregs->efer & EFER_LME) {


>
> >               return -EINVAL;
> >
> >       apic_base_msr.data =3D sregs->apic_base;
> > @@ -11378,8 +11379,19 @@ static int __set_sregs_common(struct kvm_vcpu =
*vcpu, struct kvm_sregs *sregs,
> >       if (kvm_set_apic_base(vcpu, &apic_base_msr))
> >               return -EINVAL;
> >
> > -     if (vcpu->arch.guest_state_protected)
> > +     if (vcpu->arch.guest_state_protected) {
> > +             /*
> > +              * While most actual guest state is hidden from us,
> > +              * CR{0,4,8}, efer and apic_base still hold KVM state
> > +              * with protection enabled, so let's allow restoring
> > +              */
> > +             kvm_set_cr8(vcpu, sregs->cr8);
> > +             kvm_x86_ops.set_efer(vcpu, sregs->efer);
> > +             kvm_x86_ops.set_cr0(vcpu, sregs->cr0);
>
> Use static_call().  This code is also broken in that it doesn't set mmu_r=
eset_needed.
> This patch also misses the problematic behavior in svm_set_cr0().
>
> And I don't like having a completely separate one-off flow for protected =
guests.
> It's more code and arguably uglier, but I would prefer to explicitly skip=
 each
> chunk as needed so that we aren't effectively maintaining multiple flows.
>
> Easiest thing is probably to just resurrect my aforementioned series, pen=
ding the
> result of the discussion on whether or not KVM should be trapping CR0/CR4=
/EFER
> writes in the first place.
