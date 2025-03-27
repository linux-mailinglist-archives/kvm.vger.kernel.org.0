Return-Path: <kvm+bounces-42094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F10A7A728A7
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 03:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39C591792C2
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 02:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6128378F2E;
	Thu, 27 Mar 2025 02:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c35DI0T6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0BA17741
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 02:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743041786; cv=none; b=C940I/itBN265GRmXPrQlLPaoUOJ2ql6xwWhLxNqgnKAeUsvvvGs2YQeLOAWUWo9J2DkDdeoemSmKTSdMZA4YLRlYTtesXZyzNVWyK0/wj78HpoqACRUYRtBwxlivbRGpxTviyN1myJgIsEoRD7jCbr+Zg/lvaRbgnZYKSu2gp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743041786; c=relaxed/simple;
	bh=/4ObhZMlW8lbfXwHCKM37IIFmsl8zUcIrIuaufjPNyw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=edFv/8e8Q3aTksfFGZlWUcZJla40QALZT0nQIh3mtZV3MR5ufbM0SHhuUdWvT12tH65WLE4XZ530NasHLtwefjGz49c/XNTFNUbZxzfWs7VWSskFj/v8sAZgy2yCHajJHQMbeQaB3kz4dn6Vk+7AVUSQj9iTDaFv/d7EcbfQAxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c35DI0T6; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6e8f94c2698so2364686d6.0
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743041784; x=1743646584; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFojVxnar/uxzYA1kxiB9eF4fkInOSop8hkfFvUJi3Q=;
        b=c35DI0T6e3xTKgIwAC9g7A4GIydWMG3xasOwp/MbLJJUte7ya43eu8Nh88iuRGtugs
         Rus8i/4ckN54jLuj+OFwHQViDC/mO0Gm3lattYWOQVzD9t+H3yIpIt3ciYVEi/18fZ3R
         cJXrpoi6COV8uyFdJmMIq3fnx/mpubCIjAroCX7Rf4jbMs+3wkNW9YWL9gQKqazBZsS2
         fV4+RAeEwkfhx7m4pojbG2G1u8c9g9mYJ7ESVpwTy0yBsD5FzfTM1/uVV6CGHQQCRi6T
         d6iCnf6QscEc08i/K70pzZ0y7W2CwC6qIUkBQp1Xdzf3Ixt7PMw9HEeDGYePNyzgyDtc
         +VyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743041784; x=1743646584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aFojVxnar/uxzYA1kxiB9eF4fkInOSop8hkfFvUJi3Q=;
        b=QLctI6IG4rQlgGWNQPSvSXxNDfcx4ukQ7X3bVXtUeRrFGf7ry9o6TxbA3C0ktTf39i
         0F2Nman59ULoUFdkdf/xqYF3lpJW6aO7Gu0MavXKtKizBB4HoeEvZi3U5qsSq3g+v8Ys
         QmKeju35rmJuWWrss0GlPRwR9JJ33ut0raByMwjO/jMygT/ARMkuKJyijYdBwjgQuwza
         LSIbMNTICQKXTGW/l7nXBp7UxlFfA1zPWqMsYjd4PRdDXrr0k3BjBuZmBow7kGjVa30C
         zDyN8XfhOx6SDaVFQnET17FBVUMQtGKNw7fe9l18paGSwndTC/XyBtoLPvFDSu1hIuRm
         20zQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlsQaHSt5EMWxbeahlKhQC7I9u4PkcNkXsmLb3nWMT4c4DjmyetypHowXwEUppllz+zCw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp7frLYSjQYxikes6OurNVqjd9W3q9acSY5i22FQkjj9BcQv2i
	Gspt6AsfV94BxIu/E+LmmTXNRW9sEz1XfifpdJY2KXFBoQ4IP3oY/+04m4GbzEjbNsDT5AYVf9v
	D9ADHH/GoUMCSPTceZmUNqqGe1oeKkeN8Rat4
X-Gm-Gg: ASbGncs7BrNjWJFrKkti2CcAXmp3ZM5eYjK1JqXaSKoxqjs+2LJ8ARnh8aCytmOyJOZ
	RLu/c0fuDD0JpJyMbylshYOUcAUzIqjzFIdkT0K5O2qrUSu+Lsk6SDLHLMT8295/jRKCJpYuoZ1
	mKQGA9y+wDblWSWkcx+5wNdwTNX0ukddsLblK7/Ik=
X-Google-Smtp-Source: AGHT+IF8FdzDd8QYN1oGjSj1k/pQSI+TUyF/Huds9n2UQhF8YZjJCRcMIq8dCcFMF3ZyAp9c2hAJaZ9SAxg6EMeDIE0=
X-Received: by 2002:a05:6214:2488:b0:6e4:442c:288b with SMTP id
 6a1803df08f44-6ed23872a9bmr22896936d6.11.1743041783448; Wed, 26 Mar 2025
 19:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
 <20250324123712.34096-3-dapeng1.mi@linux.intel.com> <3a01b0d8-8f0b-4068-8176-37f61295f87f@oracle.com>
 <a8e4649d-5402-4c3a-bc86-1d1b76122541@linux.intel.com>
In-Reply-To: <a8e4649d-5402-4c3a-bc86-1d1b76122541@linux.intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Wed, 26 Mar 2025 19:15:46 -0700
X-Gm-Features: AQ5f1JpZQI9JO5cpCg75fYJaq8-zHvkOAlgHiqURK5hDPWIaWsG2AA_tls52R2g
Message-ID: <CAL715WJmj=7wO_HTSendCLAs6TAPbUyKM9gMFKLhiSKqgr1s4A@mail.gmail.com>
Subject: Re: [PATCH 2/3] target/i386: Call KVM_CAP_PMU_CAPABILITY iotcl to
 enable/disable PMU
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	Zhao Liu <zhao1.liu@intel.com>, Zide Chen <zide.chen@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2025 at 5:44=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 3/26/2025 2:46 PM, Dongli Zhang wrote:
> > Hi Dapeng,
> >
> > PATCH 1-4 from the below patchset are already reviewed. (PATCH 5-10 are=
 for PMU
> > registers reset).
> >
> > https://lore.kernel.org/all/20250302220112.17653-1-dongli.zhang@oracle.=
com/
> >
> > They require only trivial modification. i.e.:
> >
> > https://github.com/finallyjustice/patchset/tree/master/qemu-amd-pmu-mid=
/v03
> >
> > Therefore, since PATCH 5-10 are for another topic, any chance if I re-s=
end 1-4
> > as a prerequisite for the patch to explicitly call KVM_CAP_PMU_CAPABILI=
TY?
>
> any option is fine for me, spiting it into two separated ones or still ke=
ep
> in a whole patch series. I would rebase this this patchset on top of your
> v3 patches.
>
>
> >
> > In addition, I have a silly question. Can mediated vPMU coexist with le=
gacy
> > perf-based vPMU, that is, something like tdp and tdp_mmu? Or the legacy
> > perf-based vPMU is going to be purged from the most recent kernel?
>
> No, they can't. As long as mediated vPMU is enabled, it would totally
> replace the legacy perf-based vPMU. The legacy perf-based vPMU code would
> still be kept in the kernel in near future, but the long-term target is t=
o
> totally remove the perf-based vPMU once mediated vPMU is mature.

mediated vPMU will co-exist with legacy vPMU right? Mediated vPMU
currently was constrained to SPR+ on Intel and Genoa+ on AMD. So
legacy CPUs will have no choice but legacy vPMU.

In the future, to fully replace legacy vPMU we need to solve the
performance issue due to PMU context switching being located at VM
enter/exit boundary. Once those limitations are resolved, and older
x86 CPUs fade away, mediated vPMU can fully take over.

Thanks.
-Mingwei
>
>
> >
> > If they can coexist, how about add property to QEMU control between
> > legacy/modern? i.e. by default use legacy and change to modern as defau=
lt in the
> > future once the feature is stable.
> >
> > Thank you very much!
> >
> > Dongli Zhang
> >
> > On 3/24/25 5:37 AM, Dapeng Mi wrote:
> >> After introducing mediated vPMU, mediated vPMU must be enabled by
> >> explicitly calling KVM_CAP_PMU_CAPABILITY to enable. Thus call
> >> KVM_CAP_PMU_CAPABILITY to enable/disable PMU base on user configuratio=
n.
> >>
> >> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> >> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >> ---
> >>  target/i386/kvm/kvm.c | 17 +++++++++++++++++
> >>  1 file changed, 17 insertions(+)
> >>
> >> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> >> index f41e190fb8..d3e6984844 100644
> >> --- a/target/i386/kvm/kvm.c
> >> +++ b/target/i386/kvm/kvm.c
> >> @@ -2051,8 +2051,25 @@ full:
> >>      abort();
> >>  }
> >>
> >> +static bool pmu_cap_set =3D false;
> >>  int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
> >>  {
> >> +    KVMState *s =3D kvm_state;
> >> +    X86CPU *x86_cpu =3D X86_CPU(cpu);
> >> +
> >> +    if (!pmu_cap_set && kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY=
)) {
> >> +        int r =3D kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
> >> +                                  KVM_PMU_CAP_DISABLE & !x86_cpu->ena=
ble_pmu);
> >> +        if (r < 0) {
> >> +            error_report("kvm: Failed to %s pmu cap: %s",
> >> +                         x86_cpu->enable_pmu ? "enable" : "disable",
> >> +                         strerror(-r));
> >> +            return r;
> >> +        }
> >> +
> >> +        pmu_cap_set =3D true;
> >> +    }
> >> +
> >>      return 0;
> >>  }
> >>

