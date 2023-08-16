Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3A677E5C9
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344456AbjHPP7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 11:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344494AbjHPP6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 11:58:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CC42711
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 08:58:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56385c43eaeso6732674a12.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 08:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692201505; x=1692806305;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AlEksp+W5th3R7gYgc5KdY3FwbFOqSJHU/Pdtj/sHPc=;
        b=4hPZ8aoiSwbbtgY4JhNFTWP0UBRBiaFDJbv7pO8IcssYnGSuONuQsxAw53w9VFfPOZ
         AiWXfzGj0Kq7/DJvBnZupEUTquIjhv5J04a4lA91+5T+LYTAqJJztJNj4WSezGAfLNm1
         vULYIFgU5lsz6yHbmk2J91bTp2B7pQoW10wFMEwuoEEG4rinPvPlhWmx5zfVx1F7UIFj
         5KRgtaji6QH3vOqsxtc8RcaUbBzWRXjc6KQL2GTqCD9Ize3wpAVZnDEW1s6BQFLiCuY9
         eCibI7l8DzT1uqyJJUJf7yYXZW208t+EI2gWyYlXAljslkiaF0Jq3CqY/BdH2pMpfbHZ
         Udug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692201505; x=1692806305;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AlEksp+W5th3R7gYgc5KdY3FwbFOqSJHU/Pdtj/sHPc=;
        b=cKcsSqvM5QjTW6Fo7z6wyLhUTaj2D9fAOxRNVzsOa7FxxzZlcsN0idiSstXv+H8AWY
         EfQT8IW1KLo+rvkxBGS15e0P+kfpe5yUiKV92xNkfqh+4kpCfX1IPuFYthOlEngFyAyw
         7Cftz+4tn+71Eevw5AaJ49IsNqvq1G0mCJT3SKXwH6ExlsUewOyUb98g1CM1WpBywIoU
         kLC8KyFPpKeTZhebzCngGR9+/avvZHluovW4w7Aet0bvKn1W5AVZjsPAJOtRKk2tuJby
         SeQGGQzCWtSXLr0Cjzle+tdu2rprH1cge8dBkOvHV+nYBqUHhj3xM4bMsmJZZgtn0nP3
         0MLA==
X-Gm-Message-State: AOJu0YxJ6etJfr3IHdZIL53/Wf9i6c477OqWbDtD95H+TDlCd32e6Li2
        Wo1mnT+FggzmtdHfRrBkRNpukV42hU0=
X-Google-Smtp-Source: AGHT+IGlGdObb9caIKpCe8nB40C28gIA4Ew3eOVEJAfRr38vtvMUP4muRVHv1URBKhcF+eOgbMGV1o60i88=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a0:b0:55b:ddd5:9b57 with SMTP id
 by32-20020a056a0205a000b0055bddd59b57mr4214pgb.1.1692201504714; Wed, 16 Aug
 2023 08:58:24 -0700 (PDT)
Date:   Wed, 16 Aug 2023 08:58:22 -0700
In-Reply-To: <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com> <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
Message-ID: <ZNzyHqLKQu9bMT8M@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023, Anish Moorthy wrote:
> On Fri, Aug 11, 2023 at 3:12=E2=80=AFPM Anish Moorthy <amoorthy@google.co=
m> wrote:
> >
> > On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> > >
> > > Tagging a globally visible, non-static function as "inline" is odd, t=
o say the
> > > least.
> >
> > I think my eyes glaze over whenever I read the words "translation
> > unit" (my brain certainly does) so I'll have to take your word for it.
> > IIRC last time I tried to mark this function "static" the compiler
> > yelled at me, so removing the "inline" it is.
> >
> >...
> >
> On Mon, Aug 14, 2023 at 5:43=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Can you point me at your branch?  That should be easy to resolve, but i=
t's all
> > but impossible to figure out what's going wrong without being able to s=
ee the
> > full code.
>=20
> Sure: https://github.com/anlsh/linux/tree/suffd-kvm-staticinline.
> Don't worry about this unless you're bored though: I only called out
> my change because I wanted to make sure the final signature was fine.
> If you say it should be static inline then I can take a more concerted
> stab at learning/figuring out what's going on here.

That branch builds (and looks) just fine on gcc-12 and clang-14.  Maybe you=
 have
stale objects in your build directory?  Or maybe PEBKAC?
=20
> > > Btw, do you actually know the size of the union in the run struct? I
> > > started checking it but stopped when I realized that it includes
> > > arch-dependent structs.
> >
> > 256 bytes, though how much of that is actually free for the "speculativ=
e" idea...
> >
> >                 /* Fix the size of the union. */
> >                 char padding[256];
> >
> > Well fudge.  PPC's KVM_EXIT_OSI actually uses all 256 bytes.  And KVM_E=
XIT_SYSTEM_EVENT
> > is closer to the limit than I'd like
> >
> > On the other hand, despite burning 2048 bytes for kvm_sync_regs, all of=
 kvm_run
> > is only 2352 bytes, i.e. we have plenty of room in the 4KiB page.  So w=
e could
> > throw the "speculative" exits in a completely different union.  But tha=
t would
> > be cumbersome for userspace.
>=20
> Haha, well it's a good thing we checked. What about an extra union
> would be cumbersome for userspace though? From an API perspective it
> doesn't seem like splitting the current struct or adding an extra one
> would be all too different- is it something about needing to recompile
> things due to the struct size change?

I was thinking that we couldn't have two anonymous unions, and so userspace=
 (and
KVM) would need to do something like

	run->exit2.memory_fault.gpa

instead of=20

	run->memory_fault.gpa

but the names just need to be unique, e.g. the below compiles just fine.  S=
o unless
someone has a better idea, using a separate union for exits that might be c=
lobbered
seems like the way to go.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5bdda75bfd10..fc3701d835d6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3289,6 +3289,9 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu=
, struct kvm_page_fault *fa
                return RET_PF_RETRY;
        }
=20
+       vcpu->run->memory_fault.flags =3D 0;
+       vcpu->run->memory_fault.gpa =3D fault->gfn << PAGE_SHIFT;
+       vcpu->run->memory_fault.len =3D PAGE_SIZE;
        return -EFAULT;
 }
=20
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f089ab290978..1a8ccd5f949a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -531,6 +531,18 @@ struct kvm_run {
                struct kvm_sync_regs regs;
                char padding[SYNC_REGS_SIZE_BYTES];
        } s;
+
+       /* Anonymous union for exits #2. */
+       union {
+               /* KVM_EXIT_MEMORY_FAULT */
+               struct {
+                       __u64 flags;
+                       __u64 gpa;
+                       __u64 len; /* in bytes */
+               } memory_fault;
+
+               char padding2[256];
+       };
 };
=20
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
