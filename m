Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8217D53D2
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 16:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343699AbjJXOWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 10:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbjJXOWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 10:22:53 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EED4C4
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 07:22:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9e0b9b96cso33801275ad.2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 07:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698157370; x=1698762170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DMkKZbVayV+UHO5Qbc7nkBIjyL5B5bBnYpYu21nJFcE=;
        b=oh2gY6j1bFFD9d3nucjH1TsNFe6rzGIwKhqliU59gvwaHMmVIqPTY7UxSIRv8GvXbC
         A7icerkObIIdcuvd/Z5uzF6y05T+tKkz4dAb6iMG0h5N2i7/h+lAdc4kKeJ5g9WNL7ZT
         iIT8CLZ3Y6+7GwbxS//kWfKEfUkpUHhFSv0D0I+q72y6oqR5dZsfRuFw1cVgEtV2Bqs8
         NhYV4Z8sql9gQk+JGwcB9q/LF/TuFc9qXkc+54860qFRAEY+yVdIIs/H6Gxa+Rm/Ocxz
         gadi0wCecbRaPpFj5I4CwJC4RvemrS5xUiaQofsafFETPmdnnRTkl9LHLiqzSilua+dc
         0mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698157370; x=1698762170;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DMkKZbVayV+UHO5Qbc7nkBIjyL5B5bBnYpYu21nJFcE=;
        b=SItEDJmCb7NJYegiw0eJ2nhleqlgce1yglWWvePMV8cOVl+RUEoUsKdZq/Sn8jM3mw
         pWxK6mxpPUC+ucuzTVpcg5ng2ojc1jm1lhiM4J+h/1AosS7mDdjf50KGWHqZO29X6FYr
         VOGVoFAC7DNq5qWEYhQOdAJsU+yPW+/GMa7RlpMo2zquT3Sn8t1U0T946m0DZV3+sB3Q
         W8AZ+wEzRgmRIpMPgwEzwNc5WezwPxt1lbLER7k3ZFKDvvZcmGRyV6Mr7eNN4UNbv3yH
         bkuoDVh1TouMaWIVhswFwl5Tg7AUWID+QJjmtqj1EqAmAs50Myr8lpxCGRmwS15JBL/g
         WNAw==
X-Gm-Message-State: AOJu0YwiWOu7d1v3VuFQ+3UKcGKajLJBvUbjTtlcy77QTBy2eZwPNrLS
        sBQ3WCNtDKeVcWHh7QgUttBB9yVQD5o=
X-Google-Smtp-Source: AGHT+IEA4Pk3M4KNy5JEXfMk6Yz9NwwTMNwm6qNyzjsXkQkvF2FmN1ZXEKLjutUF+DvKfO7GbK0nE+aojn8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:64c2:b0:1cb:de60:874c with SMTP id
 y2-20020a17090264c200b001cbde60874cmr63314pli.12.1698157369648; Tue, 24 Oct
 2023 07:22:49 -0700 (PDT)
Date:   Tue, 24 Oct 2023 07:22:48 -0700
In-Reply-To: <957b598d-c2bc-4568-2f36-a4ae762b49a8@gmail.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com> <20231024002633.2540714-12-seanjc@google.com>
 <957b598d-c2bc-4568-2f36-a4ae762b49a8@gmail.com>
Message-ID: <ZTfTOMFEO3m8nOI2@google.com>
Subject: Re: [PATCH v5 11/13] KVM: selftests: Test consistency of CPUID with
 num of fixed counters
From:   Sean Christopherson <seanjc@google.com>
To:     JinrongLiang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023, JinrongLiang wrote:
> =E5=9C=A8 2023/10/24 08:26, Sean Christopherson =E5=86=99=E9=81=93:
> > From: Jinrong Liang <cloudliang@tencent.com>
> >=20
> > Extend the PMU counters test to verify KVM emulation of fixed counters =
in
> > addition to general purpose counters.  Fixed counters add an extra wrin=
kle
> > in the form of an extra supported bitmask.  Thus quoth the SDM:
> >=20
> >    fixed-function performance counter 'i' is supported if ECX[i] || (ED=
X[4:0] > i)
> >=20
> > Test that KVM handles a counter being available through either method.
> >=20
> > Co-developed-by: Like Xu <likexu@tencent.com>
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   .../selftests/kvm/x86_64/pmu_counters_test.c  | 58 ++++++++++++++++++=
-
> >   1 file changed, 55 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/t=
ools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > index 274b7f4d4b53..f1d9cdd69a17 100644
> > --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > @@ -227,13 +227,19 @@ __GUEST_ASSERT(expect_gp ? vector =3D=3D GP_VECTO=
R : !vector,			\
> >   	       expect_gp ? "#GP" : "no fault", msr, vector)			\
> >   static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possib=
le_counters,
> > -				 uint8_t nr_counters)
> > +				 uint8_t nr_counters, uint32_t or_mask)
> >   {
> >   	uint8_t i;
> >   	for (i =3D 0; i < nr_possible_counters; i++) {
> >   		const uint32_t msr =3D base_msr + i;
> > -		const bool expect_success =3D i < nr_counters;
> > +
> > +		/*
> > +		 * Fixed counters are supported if the counter is less than the
> > +		 * number of enumerated contiguous counters *or* the counter is
> > +		 * explicitly enumerated in the supported counters mask.
> > +		 */
> > +		const bool expect_success =3D i < nr_counters || (or_mask & BIT(i));
> >   		/*
> >   		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
> > @@ -273,7 +279,7 @@ static void guest_test_gp_counters(void)
> >   	else
> >   		base_msr =3D MSR_IA32_PERFCTR0;
> > -	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
> > +	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0)=
;
> >   }
> >   static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_ca=
p)
> > @@ -292,10 +298,51 @@ static void test_gp_counters(uint8_t nr_gp_counte=
rs, uint64_t perf_cap)
> >   	kvm_vm_free(vm);
> >   }
> > +static void guest_test_fixed_counters(void)
> > +{
> > +	uint64_t supported_bitmask =3D 0;
> > +	uint8_t nr_fixed_counters =3D 0;
> > +
> > +	/* KVM provides fixed counters iff the vPMU version is 2+. */
>=20
> s/iff/if/

The "iff" is intentional, it's shorthand for "if and only if".  Ha, it even=
 has
a Wikipedia page: https://en.wikipedia.org/wiki/If_and_only_if.
