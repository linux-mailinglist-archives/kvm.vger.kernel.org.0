Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB4A6D6FE1
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 00:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbjDDWHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 18:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbjDDWHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 18:07:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B963C0E
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 15:07:04 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 140-20020a630792000000b0050be9465db8so9835218pgh.2
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 15:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680646024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PYOXWaIXVgu21dviYCjvigowUWurwptLqVpQPrUgLEg=;
        b=jqs+P8r6S2BVp3ZMQwQFacJ3n5ppbwMiiYko/e40Fgb/rWC6s6fi5pe2iAom+MwF1r
         nNKu4dhvBaQV/XYJk6bq08TWzjw3/1Vwd27D8/Kg99Kf3h6f37RnqvzsNMkFgMIT8m0Q
         IOeP8zNbbJ0E6USe6so0JE53bwHm4gNTenShOYrs+Qi1/x6mM2QfMpqk0z+IAX1vXSkZ
         A6v9zPbtZexyWYBCaAUsW/UsN0b2mh2LDbFaO+54gxAmLkKJ19eJ++Y/Ara833kM5kVt
         fPeh6COfGPTfidgFEuiEs+N+5WxMglTqkBFdNbiXUD2wTo9Q2ihtPRoLkn2vWkdy4j9v
         ijpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680646024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PYOXWaIXVgu21dviYCjvigowUWurwptLqVpQPrUgLEg=;
        b=qOTt0NCoaD5j1ekNVhPlO7IXhH67pP2D/dTKd42eUqjsiJ/DSM6aw6lgeOSapSrPtk
         X5XT2wwStppbrloKe9R89U/kclfdFWVsgR8FCcZgeXkLkKEVqfReUozjUCw+bjo/jG8k
         aq3LuRcOeo9xEGrKtIyE9snBXWZHnB8DrmYdl0HfIzPAPXVCvYOFgj1Q+pkHnJlUq9RU
         SPszjSwvSohUuGDwQd03tUeq4Y/fdim2kLZeyJyZx+DL0WqFsUkbg1sglrplDndjysCO
         5U92GAlw56TC83UcPHsw6IbYNRJ2c3PbbugQW//EjOodXGUJT8fC3w0LY1lKru4pB1Ld
         YsOg==
X-Gm-Message-State: AAQBX9dgc4uyIMIIOeBQc6u2Q+nIVeimgfOsPaqur4ZqGGAkMHxCFbVe
        KnHfGZy23AdvaMyHdk84OXwJ9/jCadg=
X-Google-Smtp-Source: AKy350bzGoReubeh2Dsyzsbf1nCOd8pscqq+FL0lrvPZBm9DCjAPgAbIY4hLpQZLs0DZXBcq9HcjLvjPHeo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c643:b0:1a1:ba37:d079 with SMTP id
 s3-20020a170902c64300b001a1ba37d079mr284942pls.3.1680646024191; Tue, 04 Apr
 2023 15:07:04 -0700 (PDT)
Date:   Tue, 4 Apr 2023 15:07:02 -0700
In-Reply-To: <CAF7b7mpbeK24ECkL4RWG3S6piYQQTEqLFMKYTFz9g4tcjVdZVw@mail.gmail.com>
Mime-Version: 1.0
References: <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com> <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
 <ZBoIzo8FGxSyUJ2I@google.com> <CAF7b7moV9=w4zJhSD2XZrnZTQAP3QeO1rvyT0dMWDhYj0PDcEA@mail.gmail.com>
 <ZCx74RGh1/nnix6U@google.com> <CAF7b7mpbeK24ECkL4RWG3S6piYQQTEqLFMKYTFz9g4tcjVdZVw@mail.gmail.com>
Message-ID: <ZCyfhj729wGXi7B/@google.com>
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

On Tue, Apr 04, 2023, Anish Moorthy wrote:
> On Tue, Apr 4, 2023 at 12:35=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > Let's say that some function (converted to annotate its EFAULTs) fill=
s
> > > in kvm_run.memory_fault, but the EFAULT is suppressed from being
> > > returned from kvm_run. What if, later within the same kvm_run call,
> > > some other function (which we've completely overlooked) EFAULTs and
> > > that return value actually does make it out to kvm_run? Userspace
> > > would get stale information, which could be catastrophic.
> >
> > "catastrophic" is a bit hyperbolic.  Yes, it would be bad, but at _wors=
t_ userspace
> > will kill the VM, which is the status quo today.
>=20
> Well what I'm saying is that in these cases userspace *wouldn't know*
> that kvm_run.memory_fault contains incorrect information for the
> -EFAULT it actually got (do you disagree?),

I disagree in the sense that if the stale information causes a problem, the=
n by
definition userspace has to know.  It's the whole "if a tree falls in a for=
est"
thing.  If KVM reports stale information and literally nothing bad happens,=
 ever,
then is the superfluous exit really a problem?  Not saying it wouldn't be t=
reated
as a bug, just that it might not even warrant a stable backport if the wors=
t case
scenario is a spurious exit to userspace (for example).

> which could presumably cause it to do bad things like "resolve" faults on
> incorrect pages and/or infinite-loop on KVM_RUN, etc.

Putting the vCPU into an infinite loop is _very_ visible, e.g. see the enti=
re
mess surrounding commit 31c25585695a ("Revert "KVM: SVM: avoid infinite loo=
p on
NPF from bad address"").

As above, fixing pages that don't need to be fixed isn't itself a major pro=
blem.
If the extra exits lead to a performance issue, then _that_ is a problem, b=
ut
again _something_ has to detect the problem and thus it becomes a known thi=
ng.

> Annotating the efault information as valid only from the call sites
> which return directly to userspace prevents this class of problem, at
> the cost of allowing un-annotated EFAULTs to make it to userspace. But
> to me, paying that cost to make sure the EFAULT information is always
> correct seems by far preferable to not paying it and allowing
> userspace to get silently incorrect information.

I don't think that's a maintainable approach.  Filling kvm_run if and only =
if the
-EFAULT has a direct path to userspace is (a) going to require a signficant=
 amount
of code churn and (b) falls apart the instant code further up the stack cha=
nges.
E.g. the relatively straightforward page fault case requires bouncing throu=
gh 7+
functions to get from kvm_handle_error_pfn() to kvm_arch_vcpu_ioctl_run(), =
and not
all of those are obviously "direct"

	if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
		r =3D kvm_tdp_page_fault(vcpu, &fault);
	else
		r =3D vcpu->arch.mmu->page_fault(vcpu, &fault);

	if (fault.write_fault_to_shadow_pgtable && emulation_type)
		*emulation_type |=3D EMULTYPE_WRITE_PF_TO_SP;

	/*
	 * Similar to above, prefetch faults aren't truly spurious, and the
	 * async #PF path doesn't do emulation.  Do count faults that are fixed
	 * by the async #PF handler though, otherwise they'll never be counted.
	 */
	if (r =3D=3D RET_PF_FIXED)
		vcpu->stat.pf_fixed++;
	else if (prefetch)
		;
	else if (r =3D=3D RET_PF_EMULATE)
		vcpu->stat.pf_emulate++;
	else if (r =3D=3D RET_PF_SPURIOUS)
		vcpu->stat.pf_spurious++;
	return r;


...

	if (r =3D=3D RET_PF_INVALID) {
		r =3D kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
					  lower_32_bits(error_code), false,
					  &emulation_type);
		if (KVM_BUG_ON(r =3D=3D RET_PF_INVALID, vcpu->kvm))
			return -EIO;
	}

	if (r < 0)
		return r;
	if (r !=3D RET_PF_EMULATE)
		return 1;

In other words, the "only if it's direct" rule requires visually auditing c=
hanges,
i.e. catching "violations" via code review, not only to code that adds a ne=
w -EFAULT
return, but to all code throughout rather large swaths of KVM.  The odds of=
 us (or
whoever the future maintainers/reviewers are) remembering to enforce the "r=
ule", let
alone actually having 100% accuracy, are basically nil.

On the flip side, if we add a helper to fill kvm_run and return -EFAULT, th=
en we can
add rule that only time KVM is allowed to return a bare -EFAULT is immediat=
ely after
a uaccess, i.e. after copy_to/from_user() and the many variants.  And _that=
_ can be
enforced through static checkers, e.g. someone with more (read: any) awk/se=
d skills
than me could bang something out in a matter of minutes.  Such a static che=
cker won't
catch everything, but there would be very, very few bare non-uaccess -EFAUL=
TS left,
and those could be filtered out with an allowlist, e.g. similar to how the =
folks that
run smatch and whatnot deal with false positives.
