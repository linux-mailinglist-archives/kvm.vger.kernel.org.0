Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA147B09AE
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 18:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjI0QKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 12:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjI0QKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 12:10:32 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC5E196
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 09:10:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56c306471ccso10778419a12.3
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 09:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695831029; x=1696435829; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VjR/OUxnEHg50NT9HcYxI5Bi85H8/C7qbzkbq7YZT9o=;
        b=lPvEZIbBP40aOV3jk3EixgnxYab3aqg9ETiazkHqc6+FcNytxaD2m++K6dcWRRmoyk
         BXqwXQ9zsaDNCBafDnidF8xS/569MDtkZXgiVoM7Xb+QdpKEvwi1wOGJbD0li4DcXB8i
         DfvxndOsvK9PlHl4ztMAF5EH69Bv9jPZ/pGhG/TtY+62/yJlDSJJO3q0H4aNOzZ+U1O4
         eNOyOAqrYSOzIuFAI20+IcBm1RMLr7V0DcmRX/+Op4iON6jhAu/f5Wi4p9T70HPFfeYf
         W08lNRPkZEPJcmOFeWE45Vy/zzkbKgfDqJgwCicqnE2NT73T4nvp/78IpZFQCpDetr6j
         EtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695831029; x=1696435829;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VjR/OUxnEHg50NT9HcYxI5Bi85H8/C7qbzkbq7YZT9o=;
        b=Kzqivlgul0GGu7JpEexsxCWaaP79SOsE8F5c0FMfZYEZtIT7qoOJ+Dbxs3FtQF3KT6
         hIbDdfSzFt5Wn4HsJimrYLOFvBofD8KcB4lbraF8NQIIBUSNQ+jy+7690NSfFv3et7z0
         ejAFtMNlA6Y50lhLligE+cx1yCPMntJX/GMq/4yeOhIFxk4afB07TWHmq1VDd3xz/R6U
         Wa7vg4QeNnGT5W+mbop8y2IrhCjidT2I0f0LwpJPeziIAi2So0cQaNZ1K8dIPVlAXsA9
         cnI2fPlo9aaUhT14bwXXnxB/gpF2pLBeW/JAJte9ZC2bSMOenH4uRXNDSsXS5qJGkhqj
         Pilg==
X-Gm-Message-State: AOJu0YwjxVie7SjEy7zlw5gg3e3+om7QXhR4oK/c7x1g3TQw/6bp30zh
        Wn8qAu2lXp0qnvGfAbQ99z88Gp2SgrE=
X-Google-Smtp-Source: AGHT+IEiZO/2KVpTzKd45Y4lPezPcxhhNBzB1Qhy2IdwNVbLPwbxI9nWCzs94jYGwnXDZXo78Of8yCNff1s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1ca:b0:1bc:5182:1de2 with SMTP id
 e10-20020a17090301ca00b001bc51821de2mr35706plh.1.1695831029192; Wed, 27 Sep
 2023 09:10:29 -0700 (PDT)
Date:   Wed, 27 Sep 2023 09:10:27 -0700
In-Reply-To: <2c79115e-e16d-49cc-8f5b-2363d7910269@zytor.com>
Mime-Version: 1.0
References: <20230927040939.342643-1-mizhang@google.com> <CAL715WJM2hMyMvNYZAcd4cSpDQ6XPFsNhtR2dsi7W=ySfy=CFw@mail.gmail.com>
 <2c79115e-e16d-49cc-8f5b-2363d7910269@zytor.com>
Message-ID: <ZRRT8zUfekA1QrQL@google.com>
Subject: Re: [PATCH] KVM: x86: Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ_NMI)
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin@zytor.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
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

On Tue, Sep 26, 2023, Xin Li wrote:
> On 9/26/2023 9:15 PM, Mingwei Zhang wrote:
> > ah, typo in the subject: The 2nd KVM_REQ_NMI should be KVM_REQ_PMI.
> > Sorry about that.
> >=20
> > On Tue, Sep 26, 2023 at 9:09=E2=80=AFPM Mingwei Zhang <mizhang@google.c=
om> wrote:
> > >=20
> > > Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ_N=
MI).
>=20
> Please remove it, no need to repeat the subject.

Heh, from Documentation/process/maintainer-kvm-x86.rst:

  Changelog
  ~~~~~~~~~
  Most importantly, write changelogs using imperative mood and avoid pronou=
ns.

  See :ref:`describe_changes` for more information, with one amendment: lea=
d with
  a short blurb on the actual changes, and then follow up with the context =
and
  background.  Note!  This order directly conflicts with the tip tree's pre=
ferred
  approach!  Please follow the tip tree's preferred style when sending patc=
hes
  that primarily target arch/x86 code that is _NOT_ KVM code.

That said, I do prefer that the changelog intro isn't just a copy+paste of =
the
shortlog, and the shortlog and changelog should use conversational language=
 instead
of describing the literal code movement.

> > > When vPMU is active use, processing each KVM_REQ_PMI will generate a

This is not guaranteed.

> > > KVM_REQ_NMI. Existing control flow after KVM_REQ_PMI finished will fa=
il the
> > > guest enter, jump to kvm_x86_cancel_injection(), and re-enter
> > > vcpu_enter_guest(), this wasted lot of cycles and increase the overhe=
ad for
> > > vPMU as well as the virtualization.

As above, use conversational language, the changelog isn't meant to be a pl=
ay-by-play.

E.g.

  KVM: x86: Service NMI requests *after* PMI requests in VM-Enter path

  Move the handling of NMI requests after PMI requests in the VM-Enter path
  so that KVM doesn't need to cancel and redo VM-Enter in the likely
  scenario that the vCPU has configured its LVPTC entry to generate an NMI.

  Because APIC emulation "injects" NMIs via KVM_REQ_NMI, handling PMI
  requests after NMI requests means KVM won't detect the pending NMI reques=
t
  until the final check for outstanding requests.  Detecting requests at th=
e
  final stage is costly as KVM has already loaded guest state, potentially
  queued events for injection, disabled IRQs, dropped SRCU, etc., most of
  which needs to be unwound.

> Optimization is after correctness, so please explain if this is correct
> first!

Not first.  Leading with an in-depth description of KVM requests and NMI ha=
ndling
is not going to help understand *why* this change is being first.  But I do=
 agree
that this should provide an analysis of why it's ok to swap the order, spec=
ificially
why it's architecturally ok if KVM drops an NMI due to the swapped ordering=
, e.g.
if the PMI is coincident with two other NMIs (or one other NMI and NMIs are=
 blocked).

> > > So move the code snippet of kvm_check_request(KVM_REQ_NMI) to make KV=
M
> > > runloop more efficient with vPMU.
> > >=20
> > > To evaluate the effectiveness of this change, we launch a 8-vcpu QEMU=
 VM on

Avoid pronouns.  There's no need for all the "fluff", just state the setup,=
 the
test, and the results.

Really getting into the nits, but the whole "8-vcpu QEMU VM" versus
"the setup of using single core, single thread" is confusing IMO.  If there=
 were
potential performance downsides and/or tradeoffs, then getting the gory det=
ails
might be necessary, but that's not the case here, and if it were really nec=
essary
to drill down that deep, then I would want to better quantify the impact, e=
.g. in
terms latency.

  E.g. on Intel SPR running SPEC2017 benchmark and Intel vtune in the guest=
,
  handling PMI requests before NMI requests reduces the number of canceled
  runs by ~1500 per second, per vCPU (counted by probing calls to
  vmx_cancel_injection()).

> > > an Intel SPR CPU. In the VM, we run perf with all 48 events Intel vtu=
ne
> > > uses. In addition, we use SPEC2017 benchmark programs as the workload=
 with
> > > the setup of using single core, single thread.
> > >=20
> > > At the host level, we probe the invocations to vmx_cancel_injection()=
 with
> > > the following command:
> > >=20
> > >      $ perf probe -a vmx_cancel_injection
> > >      $ perf stat -a -e probe:vmx_cancel_injection -I 10000 # per 10 s=
econds
> > >=20
> > > The following is the result that we collected at beginning of the spe=
c2017
> > > benchmark run (so mostly for 500.perlbench_r in spec2017). Kindly for=
give
> > > the incompleteness.
> > >=20
> > > On kernel without the change:
> > >      10.010018010              14254      probe:vmx_cancel_injection
> > >      20.037646388              15207      probe:vmx_cancel_injection
> > >      30.078739816              15261      probe:vmx_cancel_injection
> > >      40.114033258              15085      probe:vmx_cancel_injection
> > >      50.149297460              15112      probe:vmx_cancel_injection
> > >      60.185103088              15104      probe:vmx_cancel_injection
> > >=20
> > > On kernel with the change:
> > >      10.003595390                 40      probe:vmx_cancel_injection
> > >      20.017855682                 31      probe:vmx_cancel_injection
> > >      30.028355883                 34      probe:vmx_cancel_injection
> > >      40.038686298                 31      probe:vmx_cancel_injection
> > >      50.048795162                 20      probe:vmx_cancel_injection
> > >      60.069057747                 19      probe:vmx_cancel_injection
> > >=20
> > >  From the above, it is clear that we save 1500 invocations per vcpu p=
er
> > > second to vmx_cancel_injection() for workloads like perlbench.

Nit, this really should have:

  Suggested-by: Sean Christopherson <seanjc@google.com>

I personally don't care about the attribution, but (a) others often do care=
 and
(b) the added context is helpful.  E.g. for bad/questionable suggestsions/i=
deas,
knowing that person X was also involved helps direct and/or curate question=
s/comments
accordingly.
