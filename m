Return-Path: <kvm+bounces-59166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CDF8BAD8ED
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6420217635E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 15:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD227306B33;
	Tue, 30 Sep 2025 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dY1kqWHa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EA0304964
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 15:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244947; cv=none; b=Qrat15R5W8cEsha7FWCW+QkzIK52tUvNQmIYdswCsFqqWCLl4QxuBMlW/dDv/lsNfTJi/n61Niv9EkpCJ25YVzjp89dvCCnOYlL9q/nJzDeuvOC1HGsYWXwC2vwcJqPEB4GlHco9U5+xT6IKvNIijiaQ8bQcN3fIT/OdOijYKUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244947; c=relaxed/simple;
	bh=bzRw5S3aSwLlBhgF+V0xet2L6cvR7OM+F2/OGtaeYUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cK7c+/s60VWSrXfAYMu6YCar96uNrXEgHnA1jovSLzq4FhqOrQ3XsfVkIT4oYQQe3kq+0YX4YwpndY6lRGqYzT1c1CgSldrRVcRuEcuGaHpyEwmsi9XMKT16eCNXY/wzcLpxKC60QWg/aJ/pUelhdRCM5c5U1AmID2kdhDGvtT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dY1kqWHa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-334b0876195so6271560a91.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759244945; x=1759849745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ODp4hXf78r1NKAjPiKA6rGoEALXfFCwoofnk7fPCbI=;
        b=dY1kqWHauoQXsllH6YXAST4NRmZR/wg521dKizitTSF8/WtgVNvRPzwj4Is/H7qdTi
         ab3MaIqYoxNMN7oSuN7HHWY0bVemkofguSoBoeffz0tfCwqTUcselWtCb+1mmPRrvaKp
         hSknuNXxAUFS9a8UMXMzZdm8BjUmlyhxRZ8ppZKCXyF8xt2L8eOadcDuiTJjlHTNn81M
         8BL4Wbjjsjz4ITkjIwkeUPWdb0O7TuDar6q7c6S/IIoTYMKuW2WOLRbTWLo59waYkAfU
         cyZ2ImoTKi2vx2NnJB8Mgdd9MG3cWf24Zo0mmaTF1uqZUEbOthPSPGq8P9RFrQbE4zEY
         hE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759244945; x=1759849745;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7ODp4hXf78r1NKAjPiKA6rGoEALXfFCwoofnk7fPCbI=;
        b=iZrNmUKROVi10iiTsi0LMO3SLUxN4pGZy1kz5mh05S8laI+6eFIaH3XuQMp9uQqy2L
         bPjwy4x11rJ86zqXHFFOyOBLp2ZRrd54bRiRHnu4Slz0BNCbsVC/WckAbVQxyIyddbOK
         UMJ8K8nxWRpGEha17iOAkr+GrXjtyZi/r+BT/vGe2s3ljaOh5rV/D/5EE24gxx2ugO80
         l6GYgw94GX30JmS9/oFFrSlE7SQfy3fapuzD76azKo8+4UlUfrpgBfeirhJWAFTOuLMg
         DZF1wgl4hVlltniccU5sLTcipIk08CemvbAAxy5QRhZVWOgttmWiXUEBcmU+JBGkkQ5Q
         CYMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0OtX20za28DF3bZV86iFC0AdvXfdg930ZLiaJuo0zhCT1e/xxgVhgJ2PM8ADz5HoQxxc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdfRE2WrQNzy2UX7iAQ9krhcgl3DKgJ6sTzz4k0sJVSK+YlG1V
	6LDgfkuzVe4oq7AkIEwsIKUmQ32azdRXl5iM3qyT15fOF3ToH0jCKEU3ZDDBn4Ab6agsK664e+1
	v7XKdLw==
X-Google-Smtp-Source: AGHT+IHxOlAKDce6G3e7ntXQKt1wX4suXvuZZH7i/V1r3vdMpd8L8snRXlRR+/0n5jye/ZH4eRkU+hrWbKw=
X-Received: from pjrv6.prod.google.com ([2002:a17:90a:bb86:b0:329:f232:dac7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e85:b0:31f:5ebe:fa1c
 with SMTP id 98e67ed59e1d1-3342a7ba512mr24538137a91.0.1759244943821; Tue, 30
 Sep 2025 08:09:03 -0700 (PDT)
Date: Tue, 30 Sep 2025 08:09:02 -0700
In-Reply-To: <25af94f5-79e3-4005-964e-e77b1320a16e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com> <25af94f5-79e3-4005-964e-e77b1320a16e@linux.intel.com>
Message-ID: <aNvyjkuDLOfxAANd@google.com>
Subject: Re: REGRESSION on linux-next (next-20250919)
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>, 
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, 
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>, 
	Suresh Kumar Kurmi <suresh.kumar.kurmi@intel.com>, Jani Saarinen <jani.saarinen@intel.com>, 
	lucas.demarchi@intel.com, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025, Dapeng Mi wrote:
>=20
> On 9/30/2025 1:30 PM, Borah, Chaitanya Kumar wrote:
> > Hello Sean,
> >
> > Hope you are doing well. I am Chaitanya from the linux=C2=A0graphics te=
am in=20
> > Intel.
> >
> > This mail is regarding a regression we are seeing in our CI runs[1] on
> > linux-next repository.
> >
> > Since the version next-20250919=C2=A0[2], we are seeing the following r=
egression
> >
> > ```````````````````````````````````````````````````````````````````````=
``````````
> > <4>[   10.973827] ------------[ cut here ]------------
> > <4>[   10.973841] WARNING: arch/x86/events/core.c:3089 at=20
> > perf_get_x86_pmu_capability+0xd/0xc0, CPU#15: (udev-worker)/386
> > ...
> > <4>[   10.974028] Call Trace:
> > <4>[   10.974030]  <TASK>
> > <4>[   10.974033]  ? kvm_init_pmu_capability+0x2b/0x190 [kvm]
> > <4>[   10.974154]  kvm_x86_vendor_init+0x1b0/0x1a40 [kvm]
> > <4>[   10.974248]  vmx_init+0xdb/0x260 [kvm_intel]
> > <4>[   10.974278]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
> > <4>[   10.974296]  vt_init+0x12/0x9d0 [kvm_intel]
> > <4>[   10.974309]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
> > <4>[   10.974322]  do_one_initcall+0x60/0x3f0
> > <4>[   10.974335]  do_init_module+0x97/0x2b0
> > <4>[   10.974345]  load_module+0x2d08/0x2e30
> > <4>[   10.974349]  ? __kernel_read+0x158/0x2f0
> > <4>[   10.974370]  ? kernel_read_file+0x2b1/0x320
> > <4>[   10.974381]  init_module_from_file+0x96/0xe0
> > <4>[   10.974384]  ? init_module_from_file+0x96/0xe0
> > <4>[   10.974399]  idempotent_init_module+0x117/0x330
> > <4>[   10.974415]  __x64_sys_finit_module+0x73/0xe0
> > ...
> > ```````````````````````````````````````````````````````````````````````=
``````````
> > Details log can be found in [3].
> >
> > After bisecting the tree, the following patch [4] seems to be the first=
=20
> > "bad" commit
> >
> > ```````````````````````````````````````````````````````````````````````=
``````````````````````````````````
> >  From 51f34b1e650fc5843530266cea4341750bd1ae37 Mon Sep 17 00:00:00 2001
> >
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Date: Wed, 6 Aug 2025 12:56:39 -0700
> >
> > Subject: KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabil=
ities
> >
> > Take a snapshot of the unadulterated PMU capabilities provided by perf =
so
> > that KVM can compare guest vPMU capabilities against hardware capabilit=
ies
> > when determining whether or not to intercept PMU MSRs (and RDPMC).
> > ```````````````````````````````````````````````````````````````````````=
``````````````````````````````````
> >
> > We also verified that if we revert the patch the issue is not seen.
> >
> > Could you please check why the patch causes this regression and provide=
=20
> > a fix if necessary?
>=20
> Hi Chaitanya,
>=20
> I suppose you found this warning on a hybrid client platform, right? It
> looks the warning is triggered by the below=C2=A0WARN_ON_ONCE()=C2=A0in
> perf_get_x86_pmu_capability() function.
>=20
> =C2=A0 if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 !x86_pmu_initialized()) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(cap, 0, sizeof(*cap));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> =C2=A0 =C2=A0 }
>=20
> The below change should fix it (just building, not test it). I would run =
a
> full scope vPMU test after I come back from China national day's holiday.

I have access to a hybrid system, I'll also double check there (though I'm =
99.9%
certain you've got it right).

> Thanks.
>=20
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index cebce7094de8..6d87c25226d8 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -108,8 +108,6 @@ void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_=
ops)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool is_intel =3D boot_cpu_data.x86_vendor =
=3D=3D X86_VENDOR_INTEL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int min_nr_gp_ctrs =3D pmu_ops->MIN_NR_GP_COU=
NTERS;
>=20
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0perf_get_x86_pmu_capability(&kvm_host_pmu);
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Hybrid PMUs don't play nice with virt=
ualization without careful
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* configuration by userspace, and KVM's=
 APIs for reporting supported
> @@ -120,6 +118,8 @@ void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_=
ops)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enable_pmu =3D fa=
lse;
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (enable_pmu) {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0perf_get_x86_pmu_=
capability(&kvm_host_pmu);
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* WARN if p=
erf did NOT disable hardware PMU if the number of
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* architect=
urally required GP counters aren't present, i.e. if

If we go this route, then the !enable_pmu path should explicitly zero kvm_h=
ost_pmu
so that the behavior is consistent userspace loads kvm.ko with enable_pmu=
=3D0,
versus enable_pmu being cleared because of lack of support.

	if (!enable_pmu) {
		memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
		return;
	}

The alternative would be keep kvm_host_pmu valid at all times for !HYBRID, =
which
is what I intended with the bad patch, but that too would lead to inconsist=
ent
behavior.  So I think it makes sense to go with Dapeng's approach; we can a=
lways
revisit this if some future thing in KVM _needs_ kvm_host_pmu even with ena=
ble_pmu=3D0.=20

	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
		enable_pmu =3D false;
		memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
	} else {
		perf_get_x86_pmu_capability(&kvm_host_pmu);
	}

