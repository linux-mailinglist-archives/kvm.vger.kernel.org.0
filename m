Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7479509140
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 22:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382001AbiDTURH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 16:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351311AbiDTURF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 16:17:05 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2333545AED
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 13:14:18 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id y11so3247576ljh.5
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 13:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJeJg0+7yuhIIAhBKi8R+93L8vqeP6W8kyXJr8GG1pI=;
        b=HSz9HLd3PoNGwOH+/KLPsWNdUTTiv309ZCXXPC78A0YG1uyRCzgk+QIaVtqUcqOmNa
         8Fkk6wqTkZL6nWfsYNKE3rvW30ymrL9PdfSxF4X/wZRUuDOmwNnuEJ1i5RssMeAdgWzc
         +cC04C3C/y48N6CU++vTG6ZFIgBIsoxAGRKKpMA7xlQVfft1V7mPIdhtTemsp2BlB9Df
         77G2GyfawTStTKhUrJPmAwUWYMgEPu2K/OE4j+I7a7GsF+ckR+v7HkkPbBJXq7waz8WD
         cdXZLan6ZKMmp69yPsCjwOPlhx4NUhtlMN1o5PfVTMjBLXS1xBFLoV6pfbcmTOD7KT44
         TaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJeJg0+7yuhIIAhBKi8R+93L8vqeP6W8kyXJr8GG1pI=;
        b=Ton/r2fHKG5Npq1a9Pgq4RqHNGVXPsmh4TijMboMRlhZcwCM9y4MNEFykuNMB4B7ML
         XFcSo0J1ZxvsYA5TsODYSp9Idit0QS657NiQLhrsYHFfPH1ToD+mCN7upbdB1LoTeXfI
         IiBqmeJyfZwdT1NkaOyIpte/S1gNbMLPz+etL462k7gFh8tZFfwnaUglLUkJ3E9Oojpm
         xLOTSJFQNkQqbyq5FWUHRIyU3rrtl3rq1paZh3m8NmLbHe/ThTiX0UgTGFcgkIOdVnE0
         3owdap9ReEHVeVL+UDrKCukPtdivpxS1Qo6WwjMnROwoYA8I1lmHwYruHEriYUgQxalP
         Pr5w==
X-Gm-Message-State: AOAM5304o2AQvorrIjm4aBp0b86wS5XUmz0j9tDdxttkum75vNUg5UBR
        qf9celzl+b0i9atreVuLWIjHKMfdZ+3wsBz5ug8v3w==
X-Google-Smtp-Source: ABdhPJztyvf74c6z3MEGjiDK4bDbLkNGeNpmHAcDrfMInHWFsQ5cOPt+p6/xeo9CA5ry3GmCZ/Sse9XM4KSNJixA2gc=
X-Received: by 2002:a2e:3c19:0:b0:24d:a5ad:e7d3 with SMTP id
 j25-20020a2e3c19000000b0024da5ade7d3mr14578504lja.426.1650485654993; Wed, 20
 Apr 2022 13:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com> <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
In-Reply-To: <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 20 Apr 2022 14:14:03 -0600
Message-ID: <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
To:     John Sperbeck <jsperbeck@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 8, 2022 at 9:08 AM Peter Gonda <pgonda@google.com> wrote:
>
> On Thu, Apr 7, 2022 at 3:17 PM John Sperbeck <jsperbeck@google.com> wrote:
> >
> > On Thu, Apr 7, 2022 at 12:59 PM Peter Gonda <pgonda@google.com> wrote:
> > >
> > > svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
> > > source and target vcpu->locks. Mark the nested subclasses to avoid false
> > > positives from lockdep.
>
> Nope. Good catch, I didn't realize there was a limit 8 subclasses:

Does anyone have thoughts on how we can resolve this vCPU locking with
the 8 subclass max?

>
> [  509.093776] BUG: looking up invalid subclass: 8
> [  509.098314] turning off the locking correctness validator.
> [  509.103800] CPU: 185 PID: 28570 Comm: sev_migrate_tes Tainted: G
>        O      5.17.0-dbg-DEV #24
> [  509.112925] Hardware name: Google, Inc.
>                           Arcadia_IT_80/Arcadia_IT_80, BIOS
> 30.6.12-gce 09/27/2021
> [  509.126386] Call Trace:
> [  509.128835]  <TASK>
> [  509.130939]  dump_stack_lvl+0x6c/0x9a
> [  509.134609]  dump_stack+0x10/0x12
> [  509.137925]  look_up_lock_class+0xf1/0x130
> [  509.142027]  register_lock_class+0x54/0x730
> [  509.146214]  __lock_acquire+0x85/0xf00
> [  509.149964]  ? lock_is_held_type+0xff/0x170
> [  509.154154]  lock_acquire+0xca/0x210
> [  509.157730]  ? sev_lock_vcpus_for_migration+0x82/0x150
> [  509.162872]  __mutex_lock_common+0xe4/0xe30
> [  509.167054]  ? sev_lock_vcpus_for_migration+0x82/0x150
> [  509.172194]  ? sev_lock_vcpus_for_migration+0x82/0x150
> [  509.177335]  ? rcu_lock_release+0x17/0x20
> [  509.181348]  mutex_lock_killable_nested+0x20/0x30
> [  509.186053]  sev_lock_vcpus_for_migration+0x82/0x150
> [  509.191019]  sev_vm_move_enc_context_from+0x190/0x750
> [  509.196072]  ? lock_release+0x20e/0x290
> [  509.199912]  kvm_vm_ioctl_enable_cap+0x29d/0x320
> [  509.204531]  kvm_vm_ioctl+0xc58/0x1060
> [  509.208285]  ? __this_cpu_preempt_check+0x13/0x20
> [  509.212989]  __se_sys_ioctl+0x77/0xc0
> [  509.216656]  __x64_sys_ioctl+0x1d/0x20
> [  509.220408]  do_syscall_64+0x44/0xa0
> [  509.223987]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  509.229041] RIP: 0033:0x7f91b8531347
> [  509.232618] Code: 5d c3 cc 48 8b 05 f9 2f 07 00 64 c7 00 26 00 00
> 00 48 c7 c0 ff ff ff ff c3 cc cc cc cc cc cc cc cc cc cc b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 2f 07 00 f7 d8 64 89
> 01 48
> [  509.251371] RSP: 002b:00007ffef7feb778 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  509.258940] RAX: ffffffffffffffda RBX: 0000000000af6210 RCX: 00007f91b8531347
> [  509.266073] RDX: 00007ffef7feb790 RSI: 000000004068aea3 RDI: 0000000000000018
> [  509.273207] RBP: 00007ffef7feba10 R08: 000000000020331b R09: 000000000000000f
> [  509.280338] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000af8df0
> [  509.287470] R13: 0000000000afa3e0 R14: 0000000000000000 R15: 0000000000af7800
> [  509.294607]  </TASK>
>
>
>
> > >
> > > Warning example:
> > > ============================================
> > > WARNING: possible recursive locking detected
> > > 5.17.0-dbg-DEV #15 Tainted: G           O
> > > --------------------------------------------
> > > sev_migrate_tes/18859 is trying to acquire lock:
> > > ffff8d672d484238 (&vcpu->mutex){+.+.}-{3:3}, at: sev_lock_vcpus_for_migration+0x7e/0x150
> > > but task is already holding lock:
> > > ffff8d67703f81f8 (&vcpu->mutex){+.+.}-{3:3}, at: sev_lock_vcpus_for_migration+0x7e/0x150
> > > other info that might help us debug this:
> > >  Possible unsafe locking scenario:
> > >        CPU0
> > >        ----
> > >   lock(&vcpu->mutex);
> > >   lock(&vcpu->mutex);
> > >  *** DEADLOCK ***
> > >  May be due to missing lock nesting notation
> > > 3 locks held by sev_migrate_tes/18859:
> > >  #0: ffff9302f91323b8 (&kvm->lock){+.+.}-{3:3}, at: sev_vm_move_enc_context_from+0x96/0x740
> > >  #1: ffff9302f906a3b8 (&kvm->lock/1){+.+.}-{3:3}, at: sev_vm_move_enc_context_from+0xae/0x740
> > >  #2: ffff8d67703f81f8 (&vcpu->mutex){+.+.}-{3:3}, at: sev_lock_vcpus_for_migration+0x7e/0x150
> > >
> > > Fixes: b56639318bb2b ("KVM: SEV: Add support for SEV intra host migration")
> > > Reported-by: John Sperbeck<jsperbeck@google.com>
> > > Suggested-by: David Rientjes <rientjes@google.com>
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > >
> > > ---
> > >
> > > V3
> > >  * Updated signature to enum to self-document argument.
> > >  * Updated comment as Seanjc@ suggested.
> > >
> > > Tested by running sev_migrate_tests with lockdep enabled. Before we see
> > > a warning from sev_lock_vcpus_for_migration(). After we get no warnings.
> > >
> > > ---
> > >  arch/x86/kvm/svm/sev.c | 22 +++++++++++++++++-----
> > >  1 file changed, 17 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 75fa6dd268f0..f66550ec8eaf 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -1591,14 +1591,26 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
> > >         atomic_set_release(&src_sev->migration_in_progress, 0);
> > >  }
> > >
> > > +/*
> > > + * To suppress lockdep false positives, subclass all vCPU mutex locks by
> > > + * assigning even numbers to the source vCPUs and odd numbers to destination
> > > + * vCPUs based on the vCPU's index.
> > > + */
> > > +enum sev_migration_role {
> > > +       SEV_MIGRATION_SOURCE = 0,
> > > +       SEV_MIGRATION_TARGET,
> > > +       SEV_NR_MIGRATION_ROLES,
> > > +};
> > >
> > > -static int sev_lock_vcpus_for_migration(struct kvm *kvm)
> > > +static int sev_lock_vcpus_for_migration(struct kvm *kvm,
> > > +                                       enum sev_migration_role role)
> > >  {
> > >         struct kvm_vcpu *vcpu;
> > >         unsigned long i, j;
> > >
> > > -       kvm_for_each_vcpu(i, vcpu, kvm) {
> > > -               if (mutex_lock_killable(&vcpu->mutex))
> > > +       kvm_for_each_vcpu(i, vcpu, kvm) {
> > > +               if (mutex_lock_killable_nested(
> > > +                           &vcpu->mutex, i * SEV_NR_MIGRATION_ROLES + role))
> > >                         goto out_unlock;
> > >         }
> > >
> > > @@ -1745,10 +1757,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
> > >                 charged = true;
> > >         }
> > >
> > > -       ret = sev_lock_vcpus_for_migration(kvm);
> > > +       ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
> > >         if (ret)
> > >                 goto out_dst_cgroup;
> > > -       ret = sev_lock_vcpus_for_migration(source_kvm);
> > > +       ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
> > >         if (ret)
> > >                 goto out_dst_vcpu;
> > >
> > > --
> > > 2.35.1.1178.g4f1659d476-goog
> > >
> >
> > Does sev_migrate_tests survive lockdep checking if
> > NR_MIGRATE_TEST_VCPUS is changed to 16?
