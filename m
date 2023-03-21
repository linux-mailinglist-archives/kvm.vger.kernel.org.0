Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599DA6C38D2
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 19:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCUSCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 14:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjCUSCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 14:02:01 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B22F244A1
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:01:59 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-544f7c176easo150069257b3.9
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679421718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZUrScmLYMfR4iG+NeZ5qlid5pDnowXpZL8+Zsolqew=;
        b=i9bse8K+ZXXMycB0x4x6O859Bh1llQ1iFck0hStc/UQlX9B69Omq9mWnDdECewYlLM
         STJdS2HDIRel+PUN+s1iZW8NS2Xi/xDA0jN1v9e3pb90tSmFs5D3CxTMgVx/m6oS8Y3k
         Z7A9ZhZiPUWXwqQQA3JXLnjC3RrWw/zGjtXUkX36MnvAZnudii/PRjDfeWf6LCwsJuj4
         IXG4V8lUG4RMlip7kOFrdesu3GA68H2qGnBABgcKwLNmiy9ZDnZh3Tm6xyPCTrV8DRBd
         fzbQ7LYSVvxPlM5J3xV66zRIjsVqzt5bvwDqq6MIEf9iA47gAXIAkFPuLw9kedN/1+yy
         uX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679421718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZUrScmLYMfR4iG+NeZ5qlid5pDnowXpZL8+Zsolqew=;
        b=rBcmh062oG4Iab3aBbnu/1zMOnG/mumxDqSaywyTBc2tGwg7M1kRWX4DftxoUaon4x
         Y38KupaEZcgYXOFBMV9z0yZJBSCH7FNMlDRzuXF75favziKSP+JLtMUMtAO0Gglour16
         kMi4uM3JYWX/QT1Lw37Fw7+Hx5MleMItH1qzYA0gkm/7gr0tjR4yFhbCmQqjojKM4XvO
         GXLMlzs5Vlo+C3HQiokD7qD15NKbIiJqN18urU42UoFCTnk2yikDTL2Fj28SfffQXysJ
         IKa7cHZBOfcNsD/3PNUYob+Srk4wzaRyMJIXEoe+WagcVj3Mv479K09kliFTtTkyBd5p
         990g==
X-Gm-Message-State: AO0yUKXCrSo/+uclL2BzifNPshLluSSaRJON2yQRgMd4RfesTr7LTdIh
        kPJesgyLQ38Si1Ngiet1qlxjTferlT+0F6Su3GPWww==
X-Google-Smtp-Source: AK7set/OSEeNsFmyKfrDlqGYBYotgpLPnGCmoDcO0JhNlPln4qWyleoovkhEwIQHK391p/1eZqNeo2Uj7dWzRdtwSno=
X-Received: by 2002:a05:7500:3c97:b0:fe:1025:ca07 with SMTP id
 ls23-20020a0575003c9700b000fe1025ca07mr1595gab.6.1679421718113; Tue, 21 Mar
 2023 11:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com>
In-Reply-To: <ZBnLaidtZEM20jMp@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 21 Mar 2023 11:01:21 -0700
Message-ID: <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
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

On Tue, Mar 21, 2023 at 8:21=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Mar 20, 2023, Anish Moorthy wrote:
> > On Mon, Mar 20, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Mar 17, 2023, Anish Moorthy wrote:
> > > > On Fri, Mar 17, 2023 at 2:50=E2=80=AFPM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > > I wonder if we can get away with returning -EFAULT, but still fil=
ling vcpu->run
> > > > > with KVM_EXIT_MEMORY_FAULT and all the other metadata.  That woul=
d likely simplify
> > > > > the implementation greatly, and would let KVM fill vcpu->run unco=
nditonally.  KVM
> > > > > would still need a capability to advertise support to userspace, =
but userspace
> > > > > wouldn't need to opt in.  I think this may have been my very orig=
inal though, and
> > > > > I just never actually wrote it down...
> > > >
> > > > Oh, good to know that's actually an option. I thought of that too, =
but
> > > > assumed that returning a negative error code was a no-go for a prop=
er
> > > > vCPU exit. But if that's not true then I think it's the obvious
> > > > solution because it precludes any uncaught behavior-change bugs.
> > > >
> > > > A couple of notes
> > > > 1. Since we'll likely miss some -EFAULT returns, we'll need to make
> > > > sure that the user can check for / doesn't see a stale
> > > > kvm_run::memory_fault field when a missed -EFAULT makes it to
> > > > userspace. It's a small and easy-to-fix detail, but I thought I'd
> > > > point it out.
> > >
> > > Ya, this is the main concern for me as well.  I'm not as confident th=
at it's
> > > easy-to-fix/avoid though.
> > >
> > > > 2. I don't think this would simplify the series that much, since we
> > > > still need to find the call sites returning -EFAULT to userspace an=
d
> > > > populate memory_fault only in those spots to avoid populating it fo=
r
> > > > -EFAULTs which don't make it to userspace.
> > >
> > > Filling kvm_run::memory_fault even if KVM never exits to userspace is=
 perfectly
> > > ok.  It's not ideal, but it's ok.
> > >
> > > > We *could* relax that condition and just document that memory_fault=
 should be
> > > > ignored when KVM_RUN does not return -EFAULT... but I don't think t=
hat's a
> > > > good solution from a coder/maintainer perspective.
> > >
> > > You've got things backward.  memory_fault _must_ be ignored if KVM do=
esn't return
> > > the associated "magic combo", where the magic value is either "0+KVM_=
EXIT_MEMORY_FAULT"
> > > or "-EFAULT+KVM_EXIT_MEMORY_FAULT".
> > >
> > > Filling kvm_run::memory_fault but not exiting to userspace is ok beca=
use userspace
> > > never sees the data, i.e. userspace is completely unaware.  This beha=
vior is not
> > > ideal from a KVM perspective as allowing KVM to fill the kvm_run unio=
n without
> > > exiting to userspace can lead to other bugs, e.g. effective corruptio=
n of the
> > > kvm_run union, but at least from a uABI perspective, the behavior is =
acceptable.
> >
> > Actually, I don't think the idea of filling in kvm_run.memory_fault
> > for -EFAULTs which don't make it to userspace works at all. Consider
> > the direct_map function, which bubbles its -EFAULT to
> > kvm_mmu_do_page_fault. kvm_mmu_do_page_fault is called from both
> > kvm_arch_async_page_ready (which ignores the return value), and by
> > kvm_mmu_page_fault (where the return value does make it to userspace).
> > Populating kvm_run.memory_fault anywhere in or under
> > kvm_mmu_do_page_fault seems an immediate no-go, because a wayward
> > kvm_arch_async_page_ready could (presumably) overwrite/corrupt an
> > already-set kvm_run.memory_fault / other kvm_run field.
>
> This particular case is a non-issue.  kvm_check_async_pf_completion() is =
called
> only when the current task has control of the vCPU, i.e. is the current "=
running"
> vCPU.  That's not a coincidence either, invoking kvm_mmu_do_page_fault() =
without
> having control of the vCPU would be fraught with races, e.g. the entire K=
VM MMU
> context would be unstable.
>
> That will hold true for all cases.  Using a vCPU that is not loaded (not =
the
> current "running" vCPU in KVM's misleading terminology) to access guest m=
emory is
> simply not safe, as the vCPU state is non-deterministic.  There are paths=
 where
> KVM accesses, and even modifies, vCPU state asynchronously, e.g. for IRQ =
delivery
> and making requests, but those are very controlled flows with dedicated m=
achinery
> to make them SMP safe.
>
> That said, I agree that there's a risk that KVM could clobber vcpu->run_r=
un by
> hitting an -EFAULT without the vCPU loaded, but that's a solvable problem=
, e.g.
> the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if cal=
led
> without the target vCPU being loaded:
>
>         int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
>         {
>                 preempt_disable();
>                 if (WARN_ON_ONCE(vcpu !=3D __this_cpu_read(kvm_running_vc=
pu)))
>                         goto out;
>
>                 vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
>                 ...
>         out:
>                 preempt_enable();
>                 return -EFAULT;
>         }
>
> FWIW, I completely agree that filling KVM_EXIT_MEMORY_FAULT without guara=
nteeing
> that KVM "immediately" exits to userspace isn't ideal, but given the amou=
nt of
> historical code that we need to deal with, it seems like the lesser of al=
l evils.
> Unless I'm misunderstanding the use cases, unnecessarily filling kvm_run =
is a far
> better failure mode than KVM not filling kvm_run when it should, i.e. fal=
se
> positives are ok, false negatives are fatal.

Don't you have this in reverse? False negatives will just result in
userspace not having useful extra information for the -EFAULT it
receives from KVM_RUN, in which case userspace can do what you
mentioned all VMMs do today and just terminate the VM. Whereas a false
positive might cause a double-write to the KVM_RUN struct, either
putting incorrect information in kvm_run.memory_fault or corrupting
another member of the union.

> > That in turn looks problematic for the
> > memory-fault-exit-on-fast-gup-failure part of this series, because
> > there are at least a couple of cases for which kvm_mmu_do_page_fault
> > will -EFAULT. One is the early-efault-on-fast-gup-failure case which
> > was the original purpose of this series. Another is a -EFAULT from
> > FNAME(fetch) (passed up through FNAME(page_fault)). There might be
> > other cases as well. But unless userspace can/should resolve *all*
> > such -EFAULTs in the same manner, a kvm_run.memory_fault populated in
> > "kvm_mmu_page_fault" wouldn't be actionable.
>
> Killing the VM, which is what all VMMs do today in response to -EFAULT, i=
s an
> action.  As I've pointed out elsewhere in this thread, userspace needs to=
 be able
> to identify "faults" that it (userspace) can resolve without a hint from =
KVM.
>
> In other words, KVM is still returning -EFAULT (or a variant thereof), th=
e _only_
> difference, for all intents and purposes, is that userspace is given a bi=
t more
> information about the source of the -EFAULT.
>
> > At least, not without a whole lot of plumbing code to make it so.
>
> Plumbing where?

In this example, I meant plumbing code to get a
kvm_run.memory_fault.flags which is more specific than (eg)
MEMFAULT_REASON_PAGE_FAULT_FAILURE from the -EFAULT paths under
kvm_mmu_page_fault. My idea for how userspace would distinguish
fast-gup failures was that kvm_faultin_pfn would set a special bit in
kvm_run.memory_fault.flags to indicate its failure. But (still
assuming that we shouldn't have false-positive kvm_run.memory_fault
fills) if the memory_fault can only be populated from
kvm_mmu_page_fault then either failures from FNAME(page_fault) and
kvm_faultin_pfn will be indistinguishable to userspace, or those
functions will need to plumb more specific exit reasons all the way up
to kvm_mmu_page_fault.

But, since you've made this point elsewhere, my guess is that your
answer is that it's actually userspace's job to detect the "specific"
reason for the fault and resolve it.
