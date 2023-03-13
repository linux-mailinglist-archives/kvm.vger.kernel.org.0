Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFAB6B7F86
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 18:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCMRab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 13:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCMRaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 13:30:25 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858026B950
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 10:30:03 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bs68-20020a632847000000b00502eb09ea39so2848109pgb.16
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 10:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678728600;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e2N3C5v1hA4Itf/iKfJ9OnL6mk8vTK1105rfJQS18k4=;
        b=LNQXO0/s0QEkvrDKU1ezfv1NoVomkjz54L/tOU6jf+FgW/+IqxJmv8Sv15StRHn0c1
         SC72qHv6JfHXJBHDOfmwu+AL90h+z9+ez5ycWcNyT71CqhmZH02GXNkKmUWKm+2ZR4lG
         F/L+pCxWEq6w1HSt/BfyX/PmXE1FpZYXtzzg9+QBi9xd8ekLi7eQWvgtX/YUG8h0PAFs
         Dn/WyFLYxqUzgZ+JAx32XBxp0irCmLM87+1vCOeHhiKqTt45P/aKBpchSR1lsbrPW0Bf
         E5TKJODRDIQH3+Rnug66MgJAPNcnNZDf52bCj5DyzDGMaf7IRxzPaEpUd6CvauVr2x9D
         Igtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678728600;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e2N3C5v1hA4Itf/iKfJ9OnL6mk8vTK1105rfJQS18k4=;
        b=hh4Y40H7bGZ53edzmpmqkvaPfwzBfa2Zi4pqNRWAIn0/USLNLLthPyKmidJc3FB2cp
         zPtmA5VhwMH6f3+6PaInZ3Hh5gSrkVKV2oKYeQGurbYSMibDyZB0jCdoKaebFVO1T0TY
         f8o+oTTwT6hVFQp9hs2EojovdUXcEDvyKL+tI1ECEcL9O6DgBnSURlMoVnBh5le2FnjV
         z8y1H5RqFuzKdw9ArFiokafgik+aKu7/AJHp8wfSFlsmXWwns7casbcuBovNqBpZPgCh
         d5F2kw28KvbFo6POob49P17p5Q0zhnrKrg6pn7Vuro6n+eCpBd0eCyQ13PbKrc+1myBh
         5FFw==
X-Gm-Message-State: AO0yUKXhdRU5mZVBSvT8dD9DOreqE9CYVgUc9X/TUKCrFQ2qwL1oeR62
        1I8WNZcPpb7g9sxphYZshfx6TA6Bou0=
X-Google-Smtp-Source: AK7set9hke37NS5y7R3bUhoeJbJdJL3tPZo0/ltvugmlHxD9z7YUr6kKm5ot+Cs0riclCm2FIptpMzQf/vw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:746:b0:19f:3b0f:4d97 with SMTP id
 kl6-20020a170903074600b0019f3b0f4d97mr2222941plb.6.1678728600462; Mon, 13 Mar
 2023 10:30:00 -0700 (PDT)
Date:   Mon, 13 Mar 2023 10:29:58 -0700
In-Reply-To: <eb7ccc4f362ce833600f0096710003188571e4b2.camel@intel.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com> <20230310214232.806108-15-seanjc@google.com>
 <eb7ccc4f362ce833600f0096710003188571e4b2.camel@intel.com>
Message-ID: <ZA9dbo2ZufqLdHNg@google.com>
Subject: Re: [PATCH v2 14/18] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Gao <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023, Huang, Kai wrote:
> On Fri, 2023-03-10 at 13:42 -0800, Sean Christopherson wrote:
> > Check "this" CPU instead of the boot CPU when querying SVM support so t=
hat
> > the per-CPU checks done during hardware enabling actually function as
> > intended, i.e. will detect issues where SVM isn't support on all CPUs.
> >=20
> > Disable migration for the use from svm_init() mostly so that the standa=
rd
> > accessors for the per-CPU data can be used without getting yelled at by
> > CONFIG_DEBUG_PREEMPT=3Dy sanity checks.  Preventing the "disabled by BI=
OS"
> > error message from reporting the wrong CPU is largely a bonus, as ensur=
ing
> > a stable CPU during module load is a non-goal for KVM.
> >=20
> > Link: https://lore.kernel.org/all/ZAdxNgv0M6P63odE@google.com
> > Cc: Kai Huang <kai.huang@intel.com>
> > Cc: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> Should we add:
>=20
> Fixes: c82a5c5c53c5 ("KVM: x86: Do compatibility checks when onlining CPU=
")
>=20
> As that commit introduced using raw_smp_processor_id() to get CPU id in
> kvm_is_svm_supported() and print the CPU id out in error message?

My vote is to not to add a Fixes because using raw_smp_processor_id() and n=
ot disabling
migration for module probe case was deliberate and is safe.  I don't want t=
o give the
impression that the existing code is functionally broken.  The only quirk i=
s that
the reporting could be misleading.

That said, I'm not against adding a Fixes tag, because I certainly can't ar=
gue
against the reporting being flawed.

> > ---
> >  arch/x86/kvm/svm/svm.c | 25 +++++++++++++++++++------
> >  1 file changed, 19 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 2934f185960d..f04b61c3d9d8 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -520,18 +520,20 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
> >  		vcpu->arch.osvw.status |=3D 1;
> >  }
> > =20
> > -static bool kvm_is_svm_supported(void)
> > +static bool __kvm_is_svm_supported(void)
> >  {
> > -	int cpu =3D raw_smp_processor_id();
> > +	int cpu =3D smp_processor_id();
>=20
> Since we have made sure __kvm_is_svm_supported() is always performed on a=
 stable
> cpu, should we keep using raw_smp_processor_id()? =EF=BF=BD
>=20
> It is faster than smp_processor_id() when CONFIG_DEBUG_PREEMPT=3Dy, but y=
es the
> latter can help to catch bug.

Most kernels with any amount of CONFIG_DEBUG_* options enabled are comicall=
y slow
anyways, I much prefer having the sanity checks than the performance.
