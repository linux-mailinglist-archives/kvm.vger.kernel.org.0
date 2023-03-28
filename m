Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6586CCD1A
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 00:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjC1WU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 18:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjC1WUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 18:20:50 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9DF35A1
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 15:20:27 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id s1so7130673ild.6
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 15:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680042022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZP88M9f5GPgntOW5aWzm3W1ZYbMVLhFnx22IH5gvuow=;
        b=OoZK7LgWCYMlkwm+pVo0qTnez9YbhTPXrTr1bF1+lhtyg9BGvCqIToDTOQkx9EHYgz
         /4Af+2Fi/ofndSSZ2uc+UOP9suM5QzQtcUdXWwgKGyn4qc4pfiFzCjcJIwBm6ejcfSZW
         wciAJcqSm6VHfUrbvzzJsBVYSvOe+wlNJXEgjTYd1rbW+53xjFbZrLAa6G7nEsTfU+S4
         r2Zgj3NQI/MM1sST9PNzVwPZMgWE/YzjtYMg016bqXu+91khjZHrwzM93XmmZUyaEetF
         rIL9pzJoLsMc+km392oR/iYDho+b5bXUPoxtifbo/w45nx4Qh4ve2oGgk6NA4AMcvFQA
         U92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680042022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZP88M9f5GPgntOW5aWzm3W1ZYbMVLhFnx22IH5gvuow=;
        b=y2bf8mRWysRw/ZXn4omFXyqhVTDtJwXooBrMurIm0tL6vZD/55yhdp0g8dyrkvMk/j
         KXi3A5haxXGbe7+dD44eZpjsEEVjSeEqgyn5KSWOO4hn2RurSWaaYUXekX4MUqrAlMtX
         OM116rw8kRAD/dDAbUDkyzvBzrm4lExxrVQuFFyEd6Nt1HVjNzLtRoCVMLMbcI4D9c/w
         Uvt+8UAI4EwzZSObnLLXLwT+jSdDOMcPLpCBW8E02MfOhuUI51yGiMiITS3Z172bp3Tg
         k4B9AMXpVolNLjJpcIsUDnsIYRSmW7NhigQAAInLK4Fs0eeSdBIalG/gzqD4//cXEhJD
         M3aQ==
X-Gm-Message-State: AAQBX9fxMaO13gOIhNSS6sgakMC2RJGTdx9/d1jgqw/I8og5iPHVMbZe
        UIn1d86YzMkysGmeWxZzatZsIRcwYrqAJKkjHFAbeA==
X-Google-Smtp-Source: AKy350YxiI4LKbu7l7JWBnnUuN11nihLtf0hluOHU+rpf/qG7IQ6gDgC0z1sW/Qljrxwdv7lZMFVR+IcGuvhXNgC2F8=
X-Received: by 2002:a05:6e02:782:b0:316:b0b2:beff with SMTP id
 q2-20020a056e02078200b00316b0b2beffmr13404282ils.4.1680042021948; Tue, 28 Mar
 2023 15:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com> <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
 <ZBoIzo8FGxSyUJ2I@google.com>
In-Reply-To: <ZBoIzo8FGxSyUJ2I@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 28 Mar 2023 15:19:45 -0700
Message-ID: <CAF7b7moV9=w4zJhSD2XZrnZTQAP3QeO1rvyT0dMWDhYj0PDcEA@mail.gmail.com>
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
>
> > Whereas a false positive might cause a double-write to the KVM_RUN stru=
ct,
> > either putting incorrect information in kvm_run.memory_fault or
>
> Recording unused information on -EFAULT in kvm_run doesn't make the infor=
mation
> incorrect.

Let's say that some function (converted to annotate its EFAULTs) fills
in kvm_run.memory_fault, but the EFAULT is suppressed from being
returned from kvm_run. What if, later within the same kvm_run call,
some other function (which we've completely overlooked) EFAULTs and
that return value actually does make it out to kvm_run? Userspace
would get stale information, which could be catastrophic.

Actually even performing the annotations only in functions that
currently always bubble EFAULTs to userspace still seems brittle: if
new callers are ever added which don't bubble the EFAULTs, then we end
up in the same situation.
