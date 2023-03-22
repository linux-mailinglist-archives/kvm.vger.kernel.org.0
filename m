Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D43D6C5875
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 22:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCVVHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 17:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjCVVHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 17:07:34 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4684C1C
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 14:07:32 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id p2so13667939uap.1
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 14:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679519252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5TCoTHpgTZlxdts8IX0636SFjI9KXDqW+CMXjMZVtM=;
        b=h+j9DnibdhqfoukM1ME09C/0AaEFlAqpYypAcXLkmXNwyM9ceD2JSr6/iRR6tIhvdN
         Gb9XcFM+OVMVOlkkEWS9qD6Xm9tYhjCSNbar304/dA4PuU7335KS2I20yZAopw+aBuQL
         D+sewRPOvSdcY8MghE34+dRIIsBi2SMQsf45mnLOCT/Xsw1pR0n1DlxjpFWm0k47+FKZ
         Fdde4WO3xEdItUrXlRtJin4b1NyPH9aqnU7+P+6v2ZFALfphD+eK02BmXt2PM0/0tWes
         jj3D5ZJHpn9fnbhv/lInMXur7LWpdonzoxRl2rTa9MOS7AUzJRIvJQsGX3Rm/ePBiLkx
         5IyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679519252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5TCoTHpgTZlxdts8IX0636SFjI9KXDqW+CMXjMZVtM=;
        b=EipFZbuIWotp3WtmVk3rzOL+acxtkm2WjgQOf/fhOKDNorREmahUOypXezfclsHnm2
         AXZPdTyiUTdg8tJHaJyb8B6INdUu5CbDWo2j2uNv6d1RidWK5Kme75wdI0VayiOg7RF5
         XiDlMis2a7orUfq1jcob2/mQnnJXQlasxzpoDeJBXdahhgHvXqvTUneuRTmLeqAAPRi2
         bEbU6Ffndp1RBeCepo/h3LX25+DWg3RufOZNeIYLICcU6Pk1subTbEupQbJ8M2ZO+wIO
         O+TQZCKUxmxdl0tGtRi4WC0T8RTL2tPVOFtgm4SncF3nha8jPXEuRTUeqCOIAsySvoGb
         5I3A==
X-Gm-Message-State: AO0yUKVAb/NjVQRtTLCqrEfYqOPywanZpkqhBzaMfgUCjHeHT/vVf12y
        DHX2bwre8mbJbzz2FFh893Q+I0Zelce0IV9GkJsvjA==
X-Google-Smtp-Source: AK7set9HQiDRXzeXRhcbLzSHEmOEcZPJAMOZFTBMfbXjdpFxiizhK4psYS1g0cPwoI/Saj7RwOuoAVfyn7CDB5YGyQ8=
X-Received: by 2002:a1f:7ccb:0:b0:436:9f44:4e30 with SMTP id
 x194-20020a1f7ccb000000b004369f444e30mr405367vkc.16.1679519251551; Wed, 22
 Mar 2023 14:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com> <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
 <ZBoIzo8FGxSyUJ2I@google.com>
In-Reply-To: <ZBoIzo8FGxSyUJ2I@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 22 Mar 2023 14:06:55 -0700
Message-ID: <CAF7b7mpWBCa9Y4xuNLbmgh=EQWOzU4bpSDxGjmRnpH3UEZkB3g@mail.gmail.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Mar 21, 2023, Anish Moorthy wrote:
> > On Tue, Mar 21, 2023 at 8:21=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Mon, Mar 20, 2023, Anish Moorthy wrote:
> > > > On Mon, Mar 20, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > > Filling kvm_run::memory_fault but not exiting to userspace is ok =
because userspace
> > > > > never sees the data, i.e. userspace is completely unaware.  This =
behavior is not
> > > > > ideal from a KVM perspective as allowing KVM to fill the kvm_run =
union without
> > > > > exiting to userspace can lead to other bugs, e.g. effective corru=
ption of the
> > > > > kvm_run union, but at least from a uABI perspective, the behavior=
 is acceptable.
> > > >
> > > > Actually, I don't think the idea of filling in kvm_run.memory_fault
> > > > for -EFAULTs which don't make it to userspace works at all. Conside=
r
> > > > the direct_map function, which bubbles its -EFAULT to
> > > > kvm_mmu_do_page_fault. kvm_mmu_do_page_fault is called from both
> > > > kvm_arch_async_page_ready (which ignores the return value), and by
> > > > kvm_mmu_page_fault (where the return value does make it to userspac=
e).
> > > > Populating kvm_run.memory_fault anywhere in or under
> > > > kvm_mmu_do_page_fault seems an immediate no-go, because a wayward
> > > > kvm_arch_async_page_ready could (presumably) overwrite/corrupt an
> > > > already-set kvm_run.memory_fault / other kvm_run field.
> > >
> > > This particular case is a non-issue.  kvm_check_async_pf_completion()=
 is called
> > > only when the current task has control of the vCPU, i.e. is the curre=
nt "running"
> > > vCPU.  That's not a coincidence either, invoking kvm_mmu_do_page_faul=
t() without
> > > having control of the vCPU would be fraught with races, e.g. the enti=
re KVM MMU
> > > context would be unstable.
> > >
> > > That will hold true for all cases.  Using a vCPU that is not loaded (=
not the
> > > current "running" vCPU in KVM's misleading terminology) to access gue=
st memory is
> > > simply not safe, as the vCPU state is non-deterministic.  There are p=
aths where
> > > KVM accesses, and even modifies, vCPU state asynchronously, e.g. for =
IRQ delivery
> > > and making requests, but those are very controlled flows with dedicat=
ed machinery
> > > to make them SMP safe.
> > >
> > > That said, I agree that there's a risk that KVM could clobber vcpu->r=
un_run by
> > > hitting an -EFAULT without the vCPU loaded, but that's a solvable pro=
blem, e.g.
> > > the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if=
 called
> > > without the target vCPU being loaded:
> > >
> > >         int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
> > >         {
> > >                 preempt_disable();
> > >                 if (WARN_ON_ONCE(vcpu !=3D __this_cpu_read(kvm_runnin=
g_vcpu)))
> > >                         goto out;
> > >
> > >                 vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
> > >                 ...
> > >         out:
> > >                 preempt_enable();
> > >                 return -EFAULT;
> > >         }
> > >
> > > FWIW, I completely agree that filling KVM_EXIT_MEMORY_FAULT without g=
uaranteeing
> > > that KVM "immediately" exits to userspace isn't ideal, but given the =
amount of
> > > historical code that we need to deal with, it seems like the lesser o=
f all evils.
> > > Unless I'm misunderstanding the use cases, unnecessarily filling kvm_=
run is a far
> > > better failure mode than KVM not filling kvm_run when it should, i.e.=
 false
> > > positives are ok, false negatives are fatal.
> >
> > Don't you have this in reverse?
>
> No, I don't think so.
>
> > False negatives will just result in userspace not having useful extra
> > information for the -EFAULT it receives from KVM_RUN, in which case use=
rspace
> > can do what you mentioned all VMMs do today and just terminate the VM.
>
> And that is _really_ bad behavior if we have any hope of userspace actual=
ly being
> able to rely on this functionality.  E.g. any false negative when userspa=
ce is
> trying to do postcopy demand paging will be fatal to the VM.

But since -EFAULTs from KVM_RUN today are already fatal, so there's no
new failure introduced by an -EFAULT w/o a populated memory_fault
field right? Obviously that's of no real use to userspace, but that
seems like part of the point of starting with a partial conversion: to
allow for filling holes in the implementation in the future.

It seems like what you're really concerned about here is the
interaction with the memslot fast-gup-only flag. Obviously, failing to
populate kvm_run.memory_fault for new userspace-visible -EFAULTs
caused by that flag would cause new fatal failures for the guest,
which would make the feature actually harmful. But as far as I know
(and please lmk if I'm wrong), the memslot flag only needs to be used
by the kvm_handle_error_pfn (x86) and user_mem_abort (arm64)
functions, meaning that those are the only places where we need to
check/populate kvm_run.memory_fault for new userspace-visible
-EFAULTs.

> > Whereas a false positive might cause a double-write to the KVM_RUN stru=
ct,
> > either putting incorrect information in kvm_run.memory_fault or
>
> Recording unused information on -EFAULT in kvm_run doesn't make the infor=
mation
> incorrect.
>
> > corrupting another member of the union.
>
> Only if KVM accesses guest memory after initiating an exit to userspace, =
which
> would be a KVM irrespective of kvm_run.memory_fault.

Ah good: I was concerned that this was a valid set of code paths in
KVM. Although I'm assuming that "initiating an exit to userspace"
includes the "returning -EFAULT from KVM_RUN" cases, because we
wouldn't want EFAULTs to stomp on each other as well (the
kvm_mmu_do_page_fault usages were supposed to be one such example,
though I'm glad to know that they're not a problem).

> And if we're really concerned about clobbering state, we could add harden=
ing/auditing
> code to ensure that KVM actually exits when kvm_run.exit_reason is set (t=
hough there
> are a non-zero number of exceptions, e.g. the aformentioned MMIO mess, ne=
sted SVM/VMX
> pages, and probably a few others).
>
> Prior to cleanups a few years back[2], emulation failures had issues simi=
lar to
> what we are discussing, where KVM would fail to exit to userspace, not fi=
ll kvm_run,
> etc.  Those are the types of bugs I want to avoid here.
>
> [1] https://lkml.kernel.org/r/ZBNrWZQhMX8AHzWM%40google.com
> [2] https://lore.kernel.org/kvm/20190823010709.24879-1-sean.j.christopher=
son@intel.com
>
> > > > That in turn looks problematic for the
> > > > memory-fault-exit-on-fast-gup-failure part of this series, because
> > > > there are at least a couple of cases for which kvm_mmu_do_page_faul=
t
> > > > will -EFAULT. One is the early-efault-on-fast-gup-failure case whic=
h
> > > > was the original purpose of this series. Another is a -EFAULT from
> > > > FNAME(fetch) (passed up through FNAME(page_fault)). There might be
> > > > other cases as well. But unless userspace can/should resolve *all*
> > > > such -EFAULTs in the same manner, a kvm_run.memory_fault populated =
in
> > > > "kvm_mmu_page_fault" wouldn't be actionable.
> > >
> > > Killing the VM, which is what all VMMs do today in response to -EFAUL=
T, is an
> > > action.  As I've pointed out elsewhere in this thread, userspace need=
s to be able
> > > to identify "faults" that it (userspace) can resolve without a hint f=
rom KVM.
> > >
> > > In other words, KVM is still returning -EFAULT (or a variant thereof)=
, the _only_
> > > difference, for all intents and purposes, is that userspace is given =
a bit more
> > > information about the source of the -EFAULT.
> > >
> > > > At least, not without a whole lot of plumbing code to make it so.
> > >
> > > Plumbing where?
> >
> > In this example, I meant plumbing code to get a kvm_run.memory_fault.fl=
ags
> > which is more specific than (eg) MEMFAULT_REASON_PAGE_FAULT_FAILURE fro=
m the
> > -EFAULT paths under kvm_mmu_page_fault. My idea for how userspace would
> > distinguish fast-gup failures was that kvm_faultin_pfn would set a spec=
ial
> > bit in kvm_run.memory_fault.flags to indicate its failure. But (still
> > assuming that we shouldn't have false-positive kvm_run.memory_fault fil=
ls) if
> > the memory_fault can only be populated from kvm_mmu_page_fault then eit=
her
> > failures from FNAME(page_fault) and kvm_faultin_pfn will be indistingui=
shable
> > to userspace, or those functions will need to plumb more specific exit
> > reasons all the way up to kvm_mmu_page_fault.
>
> Setting a flag that essentially says "failure when handling a guest page =
fault"
> is problematic on multiple fronts.  Tying the ABI to KVM's internal imple=
mentation
> is not an option, i.e. the ABI would need to be defined as "on page fault=
s from
> the guest".  And then the resulting behavior would be non-deterministic, =
e.g.
> userspace would see different behavior if KVM accessed a "bad" gfn via em=
ulation
> instead of in response to a guest page fault.  And because of hardware TL=
Bs, it
> would even be possible for the behavior to be non-deterministic on the sa=
me
> platform running the same guest code (though this would be exteremly unli=
klely
> in practice).
>
> And even if userspace is ok with only handling guest page faults_today_, =
I highly
> doubt that will hold forever.  I.e. at some point there will be a use cas=
e that
> wants to react to uaccess failures on fast-only memslots.
>
> Ignoring all of those issues, simplify flagging "this -EFAULT occurred wh=
en
> handling a guest page fault" isn't precise enough for userspace to blindl=
y resolve
> the failure.  Even if KVM went through the trouble of setting information=
 if and
> only if get_user_page_fast_only() failed while handling a guest page faul=
t,
> userspace would still need/want a way to verify that the failure was expe=
cted and
> can be resolved, e.g. to guard against userspace bugs due to wrongly unma=
pping
> or mprotecting a page.
>
> > But, since you've made this point elsewhere, my guess is that your answ=
er is
> > that it's actually userspace's job to detect the "specific" reason for =
the
> > fault and resolve it.
>
> Yes, it's userspace's responsibity.  I simply don't see how KVM can provi=
de
> information that userspace doesn't already have without creating an unmai=
ntainable
> uABI, at least not without some deep, deep plumbing into gup().  I.e. unl=
ess gup()
> were changed to explicitly communicate that it failed because of a uffd e=
quivalent,
> at best a flag in kvm_run would be a hint that userspace _might_ be able =
to resolve
> the fault.  And even if we modified gup(), we'd still have all the open q=
uestions
> about what to do when KVM encounters a fault on a uaccess.
