Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455667B759F
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 02:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbjJDAEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 20:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjJDAEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 20:04:45 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABF99B
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 17:04:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-27763c2c27dso1195690a91.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 17:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696377882; x=1696982682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I6lu9ryrsr8Moak960ZZ9AGY/M//ntgV58bCer0QLBQ=;
        b=ShHzTr2rZ5163hXr7SezhX3n+DIzpaaG6f/5X3hJyeYwQPW3CFLdOzmOHHO9jVPAny
         5igOyRExNRfX7qS69pPyPMxPzGdHQmQdqi4SLIRLuVXrRntySFKMhSWZZEBznGm8o8Z+
         8I/Kdqs4uqfwEf205Ar777Lj8yZsIIHgwa1BKjwczH9ukWlGTAUrExbyYxSk6OmcNIn3
         EFhcmmBzFiPVAt7cwtwVYORVxtDqktz+leK/yXtM0G+wj9sYW2lXB5DtC4WYgZDgHdoE
         NrudWtV03YmBjV5E1KlCJKOYTQM/2Dt0AVaRJO48oDHQZgSd/MOfq4Q72e+n63qbXGA3
         lyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696377882; x=1696982682;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I6lu9ryrsr8Moak960ZZ9AGY/M//ntgV58bCer0QLBQ=;
        b=bguBD8hxxG2hscqnTe/O3rlLRAqWapMMzCHNMN21X4zaRJyGCeyEpFWiVZ3qJ/iCTE
         oIg3sRlRz7uFe+kaU1f+t9I3O6OOw7SzG667DCUue90PyL68TLVZi1EyUdx3vfX7Z4kx
         +/xlUrvU6bBEqb8yVXZo+WJUk00RkYCz5QzqPfODNy82Up1xecpzvBf2gF/lazzUe5Qt
         QrH334aGi5deJk04FJ7aBPhQIJluv0MiJWkE0nKo2otJW1zBHW7gaplox2kNFCLXVp6Z
         nrsplaB8XEBzcZIHmG0qoPFRqJBpmVuASNXZaqBKAnoIt+89v5+EpZ2EU9DYfkkT1zvj
         ud2A==
X-Gm-Message-State: AOJu0YzAgEAtaRfdbxlPu1FKZq7C1NDDDtHV3CNVjO+rIVyOMz+oaDSW
        MTc6rkEqPZd00rz9g7I7jAj2RaHsMT4=
X-Google-Smtp-Source: AGHT+IGwfQdgydEfqcPxox0VvjWXWW479tAIdyyr9BYEWCUwp9fRRSTjD0DFk5jsrAndRDgeT6+Sxl2w1XM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8501:b0:274:8e74:2607 with SMTP id
 l1-20020a17090a850100b002748e742607mr13630pjn.3.1696377881881; Tue, 03 Oct
 2023 17:04:41 -0700 (PDT)
Date:   Tue, 3 Oct 2023 17:04:40 -0700
In-Reply-To: <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
Mime-Version: 1.0
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com> <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com> <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
Message-ID: <ZRysGAgk6W1bpXdl@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
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

On Tue, Oct 03, 2023, David Woodhouse wrote:
> On Mon, 2023-10-02 at 17:53 -0700, Sean Christopherson wrote:
> >=20
> > The two domains use the same "clock" (constant TSC), but different math=
 to compute
> > nanoseconds from a given TSC value.=C2=A0 For decently large TSC values=
, this results
> > in CLOCK_MONOTONIC_RAW and kvmclock computing two different times in na=
noseconds.
>=20
> This is the bit I'm still confused about, and it seems to be the root
> of all the other problems.
>=20
> Both CLOCK_MONOTONIC_RAW and kvmclock have *one* job: to convert a
> number of ticks of the TSC running at a constant known frequency, to a
> number of nanoseconds.
>=20
> So how in the name of all that is holy do they manage to get
> *different* answers?
>=20
> I get that the mult/shift thing carries some imprecision, but is that
> all it is?=20

Yep, pretty sure that's it.  It's like the plot from Office Space / Superma=
n III.
Those little rounding errors add up over time.

PV clock:

  nanoseconds =3D ((TSC >> shift) * mult) >> 32

or=20

  nanoseconds =3D ((TSC << shift) * mult) >> 32

versus timekeeping (mostly)

  nanoseconds =3D (TSC * mult) >> shift

The more I look at the PV clock stuff, the more I agree with Peter: it's ga=
rbage.
Shifting before multiplying is guaranteed to introduce error.  Shifting rig=
ht drops
data, and shifting left introduces zeros.

> Can't we ensure that the kvmclock uses the *same* algorithm,
> precisely, as CLOCK_MONOTONIC_RAW?

Yes?  At least for sane hardware, after much staring, I think it's possible=
.

It's tricky because the two algorithms are wierdly different, the PV clock =
algorithm
is ABI and thus immutable, and Thomas and the timekeeping folks would right=
ly laugh
at us for suggesting that we try to shove the pvclock algorithm into the ke=
rnel.

The hardcoded shift right 32 in PV clock is annoying, but not the end of th=
e world.

Compile tested only, but I believe this math is correct.  And I'm guessing =
we'd
want some safeguards against overflow, e.g. due to a multiplier that is too=
 big.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6573c89c35a9..ae9275c3d580 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3212,9 +3212,19 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
                                            v->arch.l1_tsc_scaling_ratio);
=20
        if (unlikely(vcpu->hw_tsc_khz !=3D tgt_tsc_khz)) {
-               kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
-                                  &vcpu->hv_clock.tsc_shift,
-                                  &vcpu->hv_clock.tsc_to_system_mul);
+               u32 shift, mult;
+
+               clocks_calc_mult_shift(&mult, &shift, tgt_tsc_khz, NSEC_PER=
_MSEC, 600);
+
+               if (shift <=3D 32) {
+                       vcpu->hv_clock.tsc_shift =3D 0;
+                       vcpu->hv_clock.tsc_to_system_mul =3D mult * BIT(32 =
- shift);
+               } else {
+                       kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000=
LL,
+                                          &vcpu->hv_clock.tsc_shift,
+                                          &vcpu->hv_clock.tsc_to_system_mu=
l);
+               }
+
                vcpu->hw_tsc_khz =3D tgt_tsc_khz;
                kvm_xen_update_tsc_info(v);
        }

