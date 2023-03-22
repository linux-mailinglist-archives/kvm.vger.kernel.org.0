Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D505C6C5A2F
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 00:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCVXR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 19:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCVXR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 19:17:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E97B1911A
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 16:17:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ip12-20020a17090b314c00b0023f7dfb7d7fso3598867pjb.6
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 16:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679527046;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WvxXaPbedDworVbjF5qPgHOjzI64Bsth2Wm19SmdDHs=;
        b=VsVPTbnXKBxR8nCNNF8ELAkcZbnw774IuIaZG9KJgJWV7OkL1K4ue2f5fBWjW1Bo5M
         9xVr4F2yw/GSM+u+UtYp3PRW9AekFVppVM/0UM4pho/SiuP1dGjwayce3UhQPZB+W/vl
         R8NaRPHqbOAs805f8vFqvvgHnM51StbhNjj1v9ZoFCDkesYs2qk3jodySH29B0tbMaVA
         ixiyskOooqSVlzGzBqyUToap64btA8ee5o5+2lWNNtYnLg8/42UVlHeBt/XXCzAzzkM7
         cm3qx0aWJaXtKvXMWhlFp0HofyECZaI7pS/PNcGvHRY2lqFCc76qbI9NCTwrAzx3/ec/
         my9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679527046;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WvxXaPbedDworVbjF5qPgHOjzI64Bsth2Wm19SmdDHs=;
        b=UmlFdBw9GTrZGpBZWJrZA8Eeo8hmAIr+pGnca5igQwE75tVeGvO994yTQ4/9OLigXg
         Ji1lCTlitSupanqEK/BBWM2YFjX0fLBXbqbbAEH5/ey4Qw4rOS/NblN371fZoY9bYXOs
         pP/4+pXCh3lOg+y9IOJkcfE02hkXEu4HEmTEHD/n6qUUFyzvZC/DMhhHGoLLrERNcEus
         HxxCYfPI4l2reGGl/nx+gB3zEs5gEO3cjY2Zjyc28rqlLV92+89VGehykNtj313VL2em
         F8XlXXp+5z1JA0TSHDMF9/nQYfiKhDdg+4l00hc5jrmIDLVsmvWc81bU7TdzAUMrL96F
         taMw==
X-Gm-Message-State: AO0yUKU/2HEwwXhBUB3BPqptqkUXAL5MA9NlcP7QRPDRDhr6taADu9M+
        fKTz+gNR6m87BOjmZmCS1aRRL+c+l5A=
X-Google-Smtp-Source: AK7set/eLa11nV1rB5+B2BDOy1E/dTkhAlYaQGeXDqVPbNkOkwGJIztdMrgFWXy3kacSCMavXnP3sLYhyEY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b58e:b0:19f:28f4:1db with SMTP id
 a14-20020a170902b58e00b0019f28f401dbmr1754471pls.8.1679527045941; Wed, 22 Mar
 2023 16:17:25 -0700 (PDT)
Date:   Wed, 22 Mar 2023 16:17:24 -0700
In-Reply-To: <CAF7b7mpWBCa9Y4xuNLbmgh=EQWOzU4bpSDxGjmRnpH3UEZkB3g@mail.gmail.com>
Mime-Version: 1.0
References: <20230317000226.GA408922@ls.amr.corp.intel.com>
 <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com> <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
 <ZBoIzo8FGxSyUJ2I@google.com> <CAF7b7mpWBCa9Y4xuNLbmgh=EQWOzU4bpSDxGjmRnpH3UEZkB3g@mail.gmail.com>
Message-ID: <ZBuMhA8eOPC8HzkC@google.com>
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023, Anish Moorthy wrote:
> On Tue, Mar 21, 2023 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Tue, Mar 21, 2023, Anish Moorthy wrote:
> > > > FWIW, I completely agree that filling KVM_EXIT_MEMORY_FAULT without=
 guaranteeing
> > > > that KVM "immediately" exits to userspace isn't ideal, but given th=
e amount of
> > > > historical code that we need to deal with, it seems like the lesser=
 of all evils.
> > > > Unless I'm misunderstanding the use cases, unnecessarily filling kv=
m_run is a far
> > > > better failure mode than KVM not filling kvm_run when it should, i.=
e. false
> > > > positives are ok, false negatives are fatal.
> > >
> > > Don't you have this in reverse?
> >
> > No, I don't think so.
> >
> > > False negatives will just result in userspace not having useful extra
> > > information for the -EFAULT it receives from KVM_RUN, in which case u=
serspace
> > > can do what you mentioned all VMMs do today and just terminate the VM=
.
> >
> > And that is _really_ bad behavior if we have any hope of userspace actu=
ally being
> > able to rely on this functionality.  E.g. any false negative when users=
pace is
> > trying to do postcopy demand paging will be fatal to the VM.
>=20
> But since -EFAULTs from KVM_RUN today are already fatal, so there's no
> new failure introduced by an -EFAULT w/o a populated memory_fault
> field right?

Yes, but it's a bit of a moot piont since the goal of the feature is to avo=
id
killing the VM.

> Obviously that's of no real use to userspace, but that seems like part of=
 the
> point of starting with a partial conversion: to allow for filling holes i=
n
> the implementation in the future.

Yes, but I want a forcing function to reveal any holes we missed sooner tha=
n
later, otherwise the feature will languish since it won't be useful beyond =
the
fast-gup-only use case.

> It seems like what you're really concerned about here is the interaction =
with
> the memslot fast-gup-only flag. Obviously, failing to populate
> kvm_run.memory_fault for new userspace-visible -EFAULTs caused by that fl=
ag
> would cause new fatal failures for the guest, which would make the featur=
e
> actually harmful. But as far as I know (and please lmk if I'm wrong), the
> memslot flag only needs to be used by the kvm_handle_error_pfn (x86) and
> user_mem_abort (arm64) functions, meaning that those are the only places
> where we need to check/populate kvm_run.memory_fault for new
> userspace-visible -EFAULTs.

No.  As you point out, the fast-gup-only case should be pretty easy to get =
correct,
i.e. this should all work just fine for _GCE's current_ use case.  I'm more=
 concerned
with setting KVM up for success when future use cases come along that might=
 not be ok
with unhandled faults in random guest accesses killing the VM.

To be clear, I do not expect us to get this 100% correct on the first attem=
pt,
but I do want to have mechanisms in place that will detect any bugs/misses =
so
that we can fix the issues _before_ a use case comes along that needs 100%
accuracy.

> > > Whereas a false positive might cause a double-write to the KVM_RUN st=
ruct,
> > > either putting incorrect information in kvm_run.memory_fault or
> >
> > Recording unused information on -EFAULT in kvm_run doesn't make the inf=
ormation
> > incorrect.
> >
> > > corrupting another member of the union.
> >
> > Only if KVM accesses guest memory after initiating an exit to userspace=
, which
> > would be a KVM irrespective of kvm_run.memory_fault.
>=20
> Ah good: I was concerned that this was a valid set of code paths in
> KVM. Although I'm assuming that "initiating an exit to userspace"
> includes the "returning -EFAULT from KVM_RUN" cases, because we
> wouldn't want EFAULTs to stomp on each other as well (the
> kvm_mmu_do_page_fault usages were supposed to be one such example,
> though I'm glad to know that they're not a problem).

This one gets into a bit of a grey area.  The "rule" is really about the in=
tent,
i.e. once KVM intends to exit to userspace, it's a bug if KVM encounters so=
mething
else and runs into the weeds.

In no small part because of the myriad paths where KVM ignores what be fata=
l errors
in most flows, e.g. record_steal_time(), simply returning -EFAULT from some=
 low
level helper doesn't necessarily signal an intent to exit all the way to us=
erspace.

To be honest, I don't have a clear idea of how difficult it will be to dete=
ct bugs.
In most cases, failure to exit to userspace leads to a fatal error fairly q=
uickly.
With userspace faults, it's entirely possible that an exit could be missed =
and
nothing bad would happen.

Hmm, one idea would be to have the initial -EFAULT detection fill kvm_run.m=
emory_fault,
but set kvm_run.exit_reason to some magic number, e.g. zero it out.  Then K=
VM could
WARN if something tries to overwrite kvm_run.exit_reason.  The WARN would n=
eed to
be buried by a Kconfig or something since kvm_run can be modified by usersp=
ace,
but other than that I think it would work.
