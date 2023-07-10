Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5CF74D96C
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 17:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjGJPCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 11:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjGJPCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 11:02:01 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6DBCE
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 08:02:00 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id 71dfb90a1353d-47dcf42d3a0so4006549e0c.1
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 08:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689001319; x=1691593319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/sUNdtXxakq8jmp5wcqZtKus2+6D3V7y8Xb9orW/bc=;
        b=lR0HiSsQ75xixs2SGZAUx9sppXeb2VUtOOA1aLvD1Hb0V2qN+kBZC9UiNkUQ53tEu1
         9Q5CiNzlQZz8mFacRo11LBsVS1pTeTyHcDtR0FEIGnbtzOXQzTv8b0khJsEAa0DtMT+m
         QXMw0qiZ+RRp+XH8/b/zhruC9D2pJ29/6N6NCYarnnTRaU4xL7uZrWYrhoSRtEay2v+9
         CW5iqSb1KxLwErSMdYZCBTqHsSu4tZzjBa11fXJ3Ps6aUMwC/HLTMQDtlZegse4hJam7
         vYtL82aJNmt5uP7KQD13A1hocVwS1F73iAyEppsbQilE+60bBvi+ZMrWmbfoa5+ZEj4W
         FKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689001319; x=1691593319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d/sUNdtXxakq8jmp5wcqZtKus2+6D3V7y8Xb9orW/bc=;
        b=HKhpdDWd94T9MKBw4Y8SNKW/cK2+gbNMmkfvMQfIV2Uf8VokJrA2bhgsZR4fvyd67P
         V41hgagC0PYaOsr/hW/IatWIVwg0ysOqBAhYySGOgKiM6AReYIikBfZEbEI9SyLL5DTT
         hjMYXYqPfd0g6kRB4wb/xN+w53euf5nOuZ7E2jGepHoo0P8b5Jqz/YFPjix6+rEc9lA1
         jxcq8qtF9NJI4M6B2b35nZmQt7JBGoi1plZw8iwOikpzyvP1KirIiUtig5l4dFsax7qh
         +8NQKtv8bTAcnuFXMxV8QM/Fl8X5YkrVPyxclocejIbPVCDgQbrdj5MPqc1DOORpMMuA
         xOWQ==
X-Gm-Message-State: ABy/qLZucfPFx02MYI97dO27fX50ggKrbZfVSgVn1PRH18qMwIsphL97
        GeVlWVKDzRSyCLRfuEysqxKHYSjexZ3Hn44jhEwdNg==
X-Google-Smtp-Source: APBJJlF2giwme5p7futOTNlJ8L8M/CNv5v2eRtIYUGAvhRDJ73OwpteVzgCU/DW4qF+q9LfswGKQiPI9yXVkzTwPeH8=
X-Received: by 2002:a1f:c1ce:0:b0:46e:1a21:b52d with SMTP id
 r197-20020a1fc1ce000000b0046e1a21b52dmr4103998vkf.5.1689001319090; Mon, 10
 Jul 2023 08:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <ZKf7+D474ESdNP3D@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
In-Reply-To: <ZKf7+D474ESdNP3D@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 10 Jul 2023 08:00:00 -0700
Message-ID: <CAF7b7mr7BZayOxE2y8K87+AfYuGoDc7_kA2ouA3kBuhSgDiomg@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Kautuk Consul <kconsul@linux.vnet.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +   preempt_disable();
> > > +   /*
> > > +    * Ensure the this vCPU isn't modifying another vCPU's run struct=
, which
> > > +    * would open the door for races between concurrent calls to this
> > > +    * function.
> > > +    */
> > > +   if (WARN_ON_ONCE(vcpu !=3D __this_cpu_read(kvm_running_vcpu)))
> > > +           goto out;
> >
> > Meh, this is overkill IMO.  The check in mark_page_dirty_in_slot() is a=
n
> > abomination that I wish didn't exist, not a pattern that should be copi=
ed.  If
> > we do keep this sanity check, it can simply be
> >
> >       if (WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu()))
> >               return;
> >
> > because as the comment for kvm_get_running_vcpu() explains, the returne=
d vCPU
> > pointer won't change even if this task gets migrated to a different pCP=
U.  If
> > this code were doing something with vcpu->cpu then preemption would nee=
d to be
> > disabled throughout, but that's not the case.
> >
> I think that this check is needed but without the WARN_ON_ONCE as per my
> other comment.
> Reason is that we really need to insulate the code against preemption
> kicking in before the call to preempt_disable() as the logic seems to
> need this check to avoid concurrency problems.
> (I don't think Anish simply copied this if-check from mark_page_dirty_in_=
slot)

Heh, you're giving me too much credit here. I did copy-paste this
check, not from from mark_page_dirty_in_slot() but from one of Sean's
old responses [1]

> That said, I agree that there's a risk that KVM could clobber vcpu->run_r=
un by
> hitting an -EFAULT without the vCPU loaded, but that's a solvable problem=
, e.g.
> the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if cal=
led
> without the target vCPU being loaded:
>
>     int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
>     {
>         preempt_disable();
>         if (WARN_ON_ONCE(vcpu !=3D __this_cpu_read(kvm_running_vcpu)))
>             goto out;
>
>         vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
>         ...
>     out:
>         preempt_enable();
>         return -EFAULT;
>     }

Ancient history aside, let's figure out what's really needed here.

> Why use WARN_ON_ONCE when there is a clear possiblity of preemption
> kicking in (with the possibility of vcpu_load/vcpu_put being called
> in the new task) before preempt_disable() is called in this function ?
> I think you should use WARN_ON_ONCE only where there is some impossible
> or unhandled situation happening, not when there is a possibility of that
> situation clearly happening as per the kernel code.

I did some mucking around to try and understand the kvm_running_vcpu
variable, and I don't think preemption/rescheduling actually trips the
WARN here? From my (limited) understanding, it seems that the
thread being preempted will cause a vcpu_put() via kvm_sched_out().
But when the thread is eventually scheduled back in onto whatever
core, it'll vcpu_load() via kvm_sched_in(), and the docstring for
kvm_get_running_vcpu() seems to imply the thing that vcpu_load()
stores into the per-cpu "kvm_running_vcpu" variable will be the same
thing which would have been observed before preemption.

All that's to say: I wouldn't expect the value of
"__this_cpu_read(kvm_running_vcpu)" to change in any given thread. If
that's true, then the things I would expect this WARN to catch are (a)
bugs where somehow the thread gets scheduled without calling
vcpu_load() or (b) bizarre situations (probably all bugs?) where some
vcpu thread has a hold of some _other_ kvm_vcpu* and is trying to do
something with it.


On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Meh, this is overkill IMO.  The check in mark_page_dirty_in_slot() is an
> abomination that I wish didn't exist, not a pattern that should be copied=
.  If
> we do keep this sanity check, it can simply be
>
>         if (WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu()))
>                 return;
>
> because as the comment for kvm_get_running_vcpu() explains, the returned =
vCPU
> pointer won't change even if this task gets migrated to a different pCPU.=
  If
> this code were doing something with vcpu->cpu then preemption would need =
to be
> disabled throughout, but that's not the case.

Oh, looks like Sean said the same thing. Guess I probably should have
read that reply more closely first :/


[1] https://lore.kernel.org/kvm/ZBnLaidtZEM20jMp@google.com/
