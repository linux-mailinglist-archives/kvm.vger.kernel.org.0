Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724B26C3585
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjCUPWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCUPWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:22:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB27829141
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:21:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 204-20020a2514d5000000b00a3637aea9e1so16705137ybu.17
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679412076;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CsLWwveK8R9A9l8X9VK4vRcKskhlWUqs/XasMamWYvQ=;
        b=iMfYxltxJDVsnVwSpTXLSi8cxMbEIOvRSV64c83YsYuFYejeuoLFX7upZnBE5taCFz
         sosQ5EUStzvfSgVM3iC7ycci7WkMYYk3wjw8w/l8XuMifApw3NXUS6FbZFr7n5oBw7A1
         GVwkdIy5dmr4oK1ignKp0LkUChrFoVmBcAX2GZVy3+J8rQAgQERYoqrZnDJDmV6T467u
         Q78H/3DMJyZEBeUa4icNGHsOVyJ2HIXw06gf0Y8Q3qaJdBl15VDiHq25YEIuM5Gdufqs
         WPF2g8toZzxAgm9YmxBbshX0zdb6y/Jc6TSIAAnGcxpTAi9+WjYMqFr3E0mXlML1tgqj
         7Ytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679412076;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CsLWwveK8R9A9l8X9VK4vRcKskhlWUqs/XasMamWYvQ=;
        b=T1HtDTODVSr8PwQxDlqPHm51dCFAnQQRsO9ARmUWd5xjoR4CkIdi76PJbNRscVN6n9
         5lzdcmxaRZniBMZsrOZwQiMhcAc87+gUlRJloNDNTNrxhzIpBFqCDhOkMrreSdAGITP1
         lEDFVhYrnw+b0SORt0bi7s85XO43dnShuv06RnQYADmOiezYpA8YOMxOUe0jW7i/1aHY
         KPEjdzP3R4YS+Lhb4T3papzYrnSGZaE0KOuY0bMn8UlBxwpSzmidoXc1/xqvOAXFIyEg
         BcgDjhLdAyGand+M9TmZRZqViE18UnoIZ0Ec4JPlnqzefAWlpNr40FzfpjC4LEecfuDV
         wHjA==
X-Gm-Message-State: AAQBX9fZ5wfKctlUj10KsjwAQ8bcsKQ5hUbQRc+oieEtYSjPqq2iiei1
        FyoK78TFCrp5CoLwED7Iyr5w8atwRqo=
X-Google-Smtp-Source: AKy350YSvG9dRqTHsOv5KhAJzKmllOJWT5CUGdxiG5mb/ngvS2UXYDwbMEZ9CYAE/sRsBN5PXaIg4K1MI7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150f:b0:b39:b0d3:9a7f with SMTP id
 q15-20020a056902150f00b00b39b0d39a7fmr1510601ybu.7.1679412076332; Tue, 21 Mar
 2023 08:21:16 -0700 (PDT)
Date:   Tue, 21 Mar 2023 08:21:14 -0700
In-Reply-To: <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
Message-ID: <ZBnLaidtZEM20jMp@google.com>
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

On Mon, Mar 20, 2023, Anish Moorthy wrote:
> On Mon, Mar 20, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Mar 17, 2023, Anish Moorthy wrote:
> > > On Fri, Mar 17, 2023 at 2:50=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > I wonder if we can get away with returning -EFAULT, but still filli=
ng vcpu->run
> > > > with KVM_EXIT_MEMORY_FAULT and all the other metadata.  That would =
likely simplify
> > > > the implementation greatly, and would let KVM fill vcpu->run uncond=
itonally.  KVM
> > > > would still need a capability to advertise support to userspace, bu=
t userspace
> > > > wouldn't need to opt in.  I think this may have been my very origin=
al though, and
> > > > I just never actually wrote it down...
> > >
> > > Oh, good to know that's actually an option. I thought of that too, bu=
t
> > > assumed that returning a negative error code was a no-go for a proper
> > > vCPU exit. But if that's not true then I think it's the obvious
> > > solution because it precludes any uncaught behavior-change bugs.
> > >
> > > A couple of notes
> > > 1. Since we'll likely miss some -EFAULT returns, we'll need to make
> > > sure that the user can check for / doesn't see a stale
> > > kvm_run::memory_fault field when a missed -EFAULT makes it to
> > > userspace. It's a small and easy-to-fix detail, but I thought I'd
> > > point it out.
> >
> > Ya, this is the main concern for me as well.  I'm not as confident that=
 it's
> > easy-to-fix/avoid though.
> >
> > > 2. I don't think this would simplify the series that much, since we
> > > still need to find the call sites returning -EFAULT to userspace and
> > > populate memory_fault only in those spots to avoid populating it for
> > > -EFAULTs which don't make it to userspace.
> >
> > Filling kvm_run::memory_fault even if KVM never exits to userspace is p=
erfectly
> > ok.  It's not ideal, but it's ok.
> >
> > > We *could* relax that condition and just document that memory_fault s=
hould be
> > > ignored when KVM_RUN does not return -EFAULT... but I don't think tha=
t's a
> > > good solution from a coder/maintainer perspective.
> >
> > You've got things backward.  memory_fault _must_ be ignored if KVM does=
n't return
> > the associated "magic combo", where the magic value is either "0+KVM_EX=
IT_MEMORY_FAULT"
> > or "-EFAULT+KVM_EXIT_MEMORY_FAULT".
> >
> > Filling kvm_run::memory_fault but not exiting to userspace is ok becaus=
e userspace
> > never sees the data, i.e. userspace is completely unaware.  This behavi=
or is not
> > ideal from a KVM perspective as allowing KVM to fill the kvm_run union =
without
> > exiting to userspace can lead to other bugs, e.g. effective corruption =
of the
> > kvm_run union, but at least from a uABI perspective, the behavior is ac=
ceptable.
>=20
> Actually, I don't think the idea of filling in kvm_run.memory_fault
> for -EFAULTs which don't make it to userspace works at all. Consider
> the direct_map function, which bubbles its -EFAULT to
> kvm_mmu_do_page_fault. kvm_mmu_do_page_fault is called from both
> kvm_arch_async_page_ready (which ignores the return value), and by
> kvm_mmu_page_fault (where the return value does make it to userspace).
> Populating kvm_run.memory_fault anywhere in or under
> kvm_mmu_do_page_fault seems an immediate no-go, because a wayward
> kvm_arch_async_page_ready could (presumably) overwrite/corrupt an
> already-set kvm_run.memory_fault / other kvm_run field.

This particular case is a non-issue.  kvm_check_async_pf_completion() is ca=
lled
only when the current task has control of the vCPU, i.e. is the current "ru=
nning"
vCPU.  That's not a coincidence either, invoking kvm_mmu_do_page_fault() wi=
thout
having control of the vCPU would be fraught with races, e.g. the entire KVM=
 MMU
context would be unstable.

That will hold true for all cases.  Using a vCPU that is not loaded (not th=
e
current "running" vCPU in KVM's misleading terminology) to access guest mem=
ory is
simply not safe, as the vCPU state is non-deterministic.  There are paths w=
here
KVM accesses, and even modifies, vCPU state asynchronously, e.g. for IRQ de=
livery
and making requests, but those are very controlled flows with dedicated mac=
hinery
to make them SMP safe.

That said, I agree that there's a risk that KVM could clobber vcpu->run_run=
 by
hitting an -EFAULT without the vCPU loaded, but that's a solvable problem, =
e.g.
the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if calle=
d
without the target vCPU being loaded:

	int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
	{
		preempt_disable();
		if (WARN_ON_ONCE(vcpu !=3D __this_cpu_read(kvm_running_vcpu)))
			goto out;

		vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
		...
	out:
		preempt_enable();
		return -EFAULT;
	}

FWIW, I completely agree that filling KVM_EXIT_MEMORY_FAULT without guarant=
eeing
that KVM "immediately" exits to userspace isn't ideal, but given the amount=
 of
historical code that we need to deal with, it seems like the lesser of all =
evils.
Unless I'm misunderstanding the use cases, unnecessarily filling kvm_run is=
 a far
better failure mode than KVM not filling kvm_run when it should, i.e. false
positives are ok, false negatives are fatal.

> That in turn looks problematic for the
> memory-fault-exit-on-fast-gup-failure part of this series, because
> there are at least a couple of cases for which kvm_mmu_do_page_fault
> will -EFAULT. One is the early-efault-on-fast-gup-failure case which
> was the original purpose of this series. Another is a -EFAULT from
> FNAME(fetch) (passed up through FNAME(page_fault)). There might be
> other cases as well. But unless userspace can/should resolve *all*
> such -EFAULTs in the same manner, a kvm_run.memory_fault populated in
> "kvm_mmu_page_fault" wouldn't be actionable.

Killing the VM, which is what all VMMs do today in response to -EFAULT, is =
an
action.  As I've pointed out elsewhere in this thread, userspace needs to b=
e able
to identify "faults" that it (userspace) can resolve without a hint from KV=
M.

In other words, KVM is still returning -EFAULT (or a variant thereof), the =
_only_
difference, for all intents and purposes, is that userspace is given a bit =
more
information about the source of the -EFAULT.

> At least, not without a whole lot of plumbing code to make it so.

Plumbing where?
