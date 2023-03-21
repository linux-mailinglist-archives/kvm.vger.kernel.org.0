Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0836C3AEE
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCUTpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCUTpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:45:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6D03B3C8
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:44:34 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ml17-20020a17090b361100b0023f9e99ab95so3231186pjb.1
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679427792;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b177pa5+qKsJAuVzKADqk2f/uVzL4ZVwTj1ARM266bQ=;
        b=GSip5Ydlv3LpRENoqNnrBEU4W0f/UarnMgy2ucq1W0ZWWQ9MM/xWe9v3J9xVjzV4uG
         jIAWO3cq1bUd0gF6CIvzaDzaB/9mR3hIUIO7MXuy2Rwe+aWn5CU5B5QfW7MYZtvhX3uu
         8Z2xhIzQyPVQneFi9ddU4qllI+FtoUWo+1pB/qQGd1ThO8RJ262YVun/jrHNs3jlIANP
         Ll4Sf9P75or3dSZtBPSB9PFfgjGpD7RFgvEghID2IkS8LV46oeEdx/0trdc06imHARI+
         zoSFlpIJLC+9wbS7kb20vCu0vwLMao4gF9PKYqIQ7MnjCYivNynhcAbB4kN+58M2eoaV
         vhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427792;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b177pa5+qKsJAuVzKADqk2f/uVzL4ZVwTj1ARM266bQ=;
        b=OhR5p21fKQ1Dn1oL9ckfvkvbThB/uLbtJ23AhGWEQPrGxMGqsIP3ObdtQkUyOeFgtV
         xSDtTuOGkq5dvPumfQxWpoWlGIuY1qLCjdTlm6NNWajl0ktAXsv64/Lgqr3uo4JG/ti7
         dHc3yqxo/D6ypcvhYFBLzTuDj0sWZboSO8Z+5yR9+WZGISjeAl/PBTcfiY8mVT4YSRIM
         MVkpdR8jhrMD8pfVQCCQzdNjaKkMTQUpHLC0DRPcxfgBBZzmvQdOiUVI3HBeV9qmUXs0
         oacpq7lDUQX7/p51+KgYSpHMYHHcPBuVNayX7TaOLjLJ9H7okNpf+cvaLRv6YN9qEnWe
         6jMQ==
X-Gm-Message-State: AO0yUKVi69kCzbMP3qWQM2aZskb3lL3yE/Zu3wthpUO9lED07DjlTwSa
        DBJSI4R1yp2Qf/6UPEXkzNTFx1QdDEA=
X-Google-Smtp-Source: AK7set/UIIRbuto3sAWruQJJZ2+4GRJ5z+F4gq9wOJovv8atAbc67IXo+tIsW9PByInFtV5UG+0R8hnWsEI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6191:0:b0:502:e1c4:d37b with SMTP id
 c17-20020a656191000000b00502e1c4d37bmr31237pgv.12.1679427791789; Tue, 21 Mar
 2023 12:43:11 -0700 (PDT)
Date:   Tue, 21 Mar 2023 12:43:10 -0700
In-Reply-To: <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com> <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
Message-ID: <ZBoIzo8FGxSyUJ2I@google.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023, Anish Moorthy wrote:
> On Tue, Mar 21, 2023 at 8:21=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Mar 20, 2023, Anish Moorthy wrote:
> > > On Mon, Mar 20, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > Filling kvm_run::memory_fault but not exiting to userspace is ok be=
cause userspace
> > > > never sees the data, i.e. userspace is completely unaware.  This be=
havior is not
> > > > ideal from a KVM perspective as allowing KVM to fill the kvm_run un=
ion without
> > > > exiting to userspace can lead to other bugs, e.g. effective corrupt=
ion of the
> > > > kvm_run union, but at least from a uABI perspective, the behavior i=
s acceptable.
> > >
> > > Actually, I don't think the idea of filling in kvm_run.memory_fault
> > > for -EFAULTs which don't make it to userspace works at all. Consider
> > > the direct_map function, which bubbles its -EFAULT to
> > > kvm_mmu_do_page_fault. kvm_mmu_do_page_fault is called from both
> > > kvm_arch_async_page_ready (which ignores the return value), and by
> > > kvm_mmu_page_fault (where the return value does make it to userspace)=
.
> > > Populating kvm_run.memory_fault anywhere in or under
> > > kvm_mmu_do_page_fault seems an immediate no-go, because a wayward
> > > kvm_arch_async_page_ready could (presumably) overwrite/corrupt an
> > > already-set kvm_run.memory_fault / other kvm_run field.
> >
> > This particular case is a non-issue.  kvm_check_async_pf_completion() i=
s called
> > only when the current task has control of the vCPU, i.e. is the current=
 "running"
> > vCPU.  That's not a coincidence either, invoking kvm_mmu_do_page_fault(=
) without
> > having control of the vCPU would be fraught with races, e.g. the entire=
 KVM MMU
> > context would be unstable.
> >
> > That will hold true for all cases.  Using a vCPU that is not loaded (no=
t the
> > current "running" vCPU in KVM's misleading terminology) to access guest=
 memory is
> > simply not safe, as the vCPU state is non-deterministic.  There are pat=
hs where
> > KVM accesses, and even modifies, vCPU state asynchronously, e.g. for IR=
Q delivery
> > and making requests, but those are very controlled flows with dedicated=
 machinery
> > to make them SMP safe.
> >
> > That said, I agree that there's a risk that KVM could clobber vcpu->run=
_run by
> > hitting an -EFAULT without the vCPU loaded, but that's a solvable probl=
em, e.g.
> > the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if c=
alled
> > without the target vCPU being loaded:
> >
> >         int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
> >         {
> >                 preempt_disable();
> >                 if (WARN_ON_ONCE(vcpu !=3D __this_cpu_read(kvm_running_=
vcpu)))
> >                         goto out;
> >
> >                 vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
> >                 ...
> >         out:
> >                 preempt_enable();
> >                 return -EFAULT;
> >         }
> >
> > FWIW, I completely agree that filling KVM_EXIT_MEMORY_FAULT without gua=
ranteeing
> > that KVM "immediately" exits to userspace isn't ideal, but given the am=
ount of
> > historical code that we need to deal with, it seems like the lesser of =
all evils.
> > Unless I'm misunderstanding the use cases, unnecessarily filling kvm_ru=
n is a far
> > better failure mode than KVM not filling kvm_run when it should, i.e. f=
alse
> > positives are ok, false negatives are fatal.
>=20
> Don't you have this in reverse?

No, I don't think so.

> False negatives will just result in userspace not having useful extra
> information for the -EFAULT it receives from KVM_RUN, in which case users=
pace
> can do what you mentioned all VMMs do today and just terminate the VM.

And that is _really_ bad behavior if we have any hope of userspace actually=
 being
able to rely on this functionality.  E.g. any false negative when userspace=
 is
trying to do postcopy demand paging will be fatal to the VM.

> Whereas a false positive might cause a double-write to the KVM_RUN struct=
,
> either putting incorrect information in kvm_run.memory_fault or

Recording unused information on -EFAULT in kvm_run doesn't make the informa=
tion
incorrect.

> corrupting another member of the union.

Only if KVM accesses guest memory after initiating an exit to userspace, wh=
ich
would be a KVM irrespective of kvm_run.memory_fault.  We actually have exac=
tly
this type of bug today in the trainwreck that is KVM's MMIO emulation[*], b=
ut
KVM gets away with the shoddy behavior by virtue of the scenario simply not
triggered by any real-world code.

And if we're really concerned about clobbering state, we could add hardenin=
g/auditing
code to ensure that KVM actually exits when kvm_run.exit_reason is set (tho=
ugh there
are a non-zero number of exceptions, e.g. the aformentioned MMIO mess, nest=
ed SVM/VMX
pages, and probably a few others).

Prior to cleanups a few years back[2], emulation failures had issues simila=
r to
what we are discussing, where KVM would fail to exit to userspace, not fill=
 kvm_run,
etc.  Those are the types of bugs I want to avoid here.

[1] https://lkml.kernel.org/r/ZBNrWZQhMX8AHzWM%40google.com
[2] https://lore.kernel.org/kvm/20190823010709.24879-1-sean.j.christopherso=
n@intel.com

> > > That in turn looks problematic for the
> > > memory-fault-exit-on-fast-gup-failure part of this series, because
> > > there are at least a couple of cases for which kvm_mmu_do_page_fault
> > > will -EFAULT. One is the early-efault-on-fast-gup-failure case which
> > > was the original purpose of this series. Another is a -EFAULT from
> > > FNAME(fetch) (passed up through FNAME(page_fault)). There might be
> > > other cases as well. But unless userspace can/should resolve *all*
> > > such -EFAULTs in the same manner, a kvm_run.memory_fault populated in
> > > "kvm_mmu_page_fault" wouldn't be actionable.
> >
> > Killing the VM, which is what all VMMs do today in response to -EFAULT,=
 is an
> > action.  As I've pointed out elsewhere in this thread, userspace needs =
to be able
> > to identify "faults" that it (userspace) can resolve without a hint fro=
m KVM.
> >
> > In other words, KVM is still returning -EFAULT (or a variant thereof), =
the _only_
> > difference, for all intents and purposes, is that userspace is given a =
bit more
> > information about the source of the -EFAULT.
> >
> > > At least, not without a whole lot of plumbing code to make it so.
> >
> > Plumbing where?
>=20
> In this example, I meant plumbing code to get a kvm_run.memory_fault.flag=
s
> which is more specific than (eg) MEMFAULT_REASON_PAGE_FAULT_FAILURE from =
the
> -EFAULT paths under kvm_mmu_page_fault. My idea for how userspace would
> distinguish fast-gup failures was that kvm_faultin_pfn would set a specia=
l
> bit in kvm_run.memory_fault.flags to indicate its failure. But (still
> assuming that we shouldn't have false-positive kvm_run.memory_fault fills=
) if
> the memory_fault can only be populated from kvm_mmu_page_fault then eithe=
r
> failures from FNAME(page_fault) and kvm_faultin_pfn will be indistinguish=
able
> to userspace, or those functions will need to plumb more specific exit
> reasons all the way up to kvm_mmu_page_fault.

Setting a flag that essentially says "failure when handling a guest page fa=
ult"
is problematic on multiple fronts.  Tying the ABI to KVM's internal impleme=
ntation
is not an option, i.e. the ABI would need to be defined as "on page faults =
from
the guest".  And then the resulting behavior would be non-deterministic, e.=
g.
userspace would see different behavior if KVM accessed a "bad" gfn via emul=
ation
instead of in response to a guest page fault.  And because of hardware TLBs=
, it
would even be possible for the behavior to be non-deterministic on the same
platform running the same guest code (though this would be exteremly unlikl=
ely
in practice).

And even if userspace is ok with only handling guest page faults_today_, I =
highly
doubt that will hold forever.  I.e. at some point there will be a use case =
that
wants to react to uaccess failures on fast-only memslots.

Ignoring all of those issues, simplify flagging "this -EFAULT occurred when
handling a guest page fault" isn't precise enough for userspace to blindly =
resolve
the failure.  Even if KVM went through the trouble of setting information i=
f and
only if get_user_page_fast_only() failed while handling a guest page fault,
userspace would still need/want a way to verify that the failure was expect=
ed and
can be resolved, e.g. to guard against userspace bugs due to wrongly unmapp=
ing
or mprotecting a page.

> But, since you've made this point elsewhere, my guess is that your answer=
 is
> that it's actually userspace's job to detect the "specific" reason for th=
e
> fault and resolve it.

Yes, it's userspace's responsibity.  I simply don't see how KVM can provide
information that userspace doesn't already have without creating an unmaint=
ainable
uABI, at least not without some deep, deep plumbing into gup().  I.e. unles=
s gup()
were changed to explicitly communicate that it failed because of a uffd equ=
ivalent,
at best a flag in kvm_run would be a hint that userspace _might_ be able to=
 resolve
the fault.  And even if we modified gup(), we'd still have all the open que=
stions
about what to do when KVM encounters a fault on a uaccess.
