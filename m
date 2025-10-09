Return-Path: <kvm+bounces-59716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 56643BC9263
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 14:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A660D4FA7CA
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 12:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965D82E62BF;
	Thu,  9 Oct 2025 12:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ns3HjRNm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D1B2E62B7
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 12:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760014719; cv=none; b=maX+F03fKFBlVTqnOaVyTXjVNyOVcKRn0XAfohNrQpgIeh14zyGvZQ1sh1vRVsCXAnXBECB5sciWedfmh503WMEkbRUJO//g8q4r9fCP7UKpgajwWu0tFGJ7XmF6yWnIH2Pn+K915NTjkU235E2m3YFY3MYuyUFLXqRpDdfzu6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760014719; c=relaxed/simple;
	bh=fG8614poqmYHLHwPJZtoBYycrE1J9gSjrapsjsi+MJY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FZmKuc5d1FXx35YtHez8rxm3Dn8RJRbzprIn+oKEU95fOAmg8ZesnSCOPGqFaEDfQTu57l9CvMaBo+8+NR8YQmoxY6/t6D5tUZliJia6R0xL3dwFqP3QHtC/8ommAXM9kwZ6mX/2eIToGsFhptWxidCjjAXLTCgNHzAe5SHwhhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ns3HjRNm; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-268149e1c28so17722895ad.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 05:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760014718; x=1760619518; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rW1G3rL+KumF5u3WwLC+tOU95q8htP+/xpt0iPYfuBA=;
        b=ns3HjRNmQTCsc+ZTgkRcnpCRiahI8aj/Zk5jA03ejUJxtOro4zT5lTeoDDsofxw+FG
         GoWix1BvQf0sY5K+K9cL2ouBLeA185hEed+TUxl9UqNc8cQXF1Vb8zOwRcNFxxjs9tFk
         OAAD4F2mWnuZZLEDh8T4+WGRUaYRtTL5fGlRfBqGsomABkqlBHKnK9A+Y/67Uc55ZLL3
         Gh/jfnxMRm9MqBchwvL/jr9HxdtovVVuifpCmZ3jR4xMshdhelpxBIPr2pQmQnwK0Bq/
         O12hEojPeWHj995j/KPsDLRQQ9EDe8GKxgk1DB5jsE+eapOJzA0DxxREsNff5+pmAJky
         8oGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760014718; x=1760619518;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rW1G3rL+KumF5u3WwLC+tOU95q8htP+/xpt0iPYfuBA=;
        b=qpSEp0zDQ+qpQUniZpuNWZIUaoORRc9A36P0KUdoSZRYhiFuj14PB44lacwQ/hgGGY
         x7hASxk1uqhXEZPm9RLdipH966a/u84W217C6nfqX6ZHX/aVkNtpLd0KbBATsTxtawuu
         KGlElh8wPKDuudWmUPcWQMXZe0MspXHYG4OnMlCKqrRyknWB3RCUW8nKEJr+kyvBVu78
         WnoiyMNMwuBIUy5xjZUUutrF5/ItMlch4dKbqfJkSq9pKJQMWK7So1Fd+D74Pnkr4uuE
         uwNGkVyDo9rW2IQb3F4G2GZ2O/87Nuse0Yvgx+gNfNVJKnsa56mUN41nKjCRV9jd2b+s
         iDxg==
X-Forwarded-Encrypted: i=1; AJvYcCWef2FyqIAJTElAYQybxzBKJtF8fau0r5uwk6GvMpXAHGiPUwsG43lBZi2vIT11K1LVojc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoKSBbby6iStjL4qK5y5K1yHM5FoLm/j5QyMDltkPBVp5Xq1nw
	EBptkcVS1K2drx7RyEf9lJEgP2zshBtBpLH2FcrPwcfi5kwEzeO6wwKeQayQTuOnGycXg3Pmw9m
	hUN4G1g==
X-Google-Smtp-Source: AGHT+IH7h/AMFky1MZe0POKihyk6CBGGTuNOR3bkBF5NzMdZe3AIhToBPbzyEpzWmh5xCsVBnvVH62o1WfY=
X-Received: from plbkv14.prod.google.com ([2002:a17:903:28ce:b0:268:eb:3b3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef10:b0:271:5bde:697e
 with SMTP id d9443c01a7336-29027213340mr92639575ad.3.1760014717676; Thu, 09
 Oct 2025 05:58:37 -0700 (PDT)
Date: Thu, 9 Oct 2025 05:58:35 -0700
In-Reply-To: <e9e8f087-60f6-455a-b0e0-e5c29fc54129@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com>
 <25af94f5-79e3-4005-964e-e77b1320a16e@linux.intel.com> <aNvyjkuDLOfxAANd@google.com>
 <3bbc4e6d-9f52-483c-a25d-166dca62fb25@intel.com> <00d0f3f3-d2b4-4885-9a49-5e6f8390142b@intel.com>
 <e9e8f087-60f6-455a-b0e0-e5c29fc54129@linux.intel.com>
Message-ID: <aOexe4LNpmJnHTm9@google.com>
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

On Thu, Oct 09, 2025, Dapeng Mi wrote:
>=20
> On 10/7/2025 2:22 PM, Borah, Chaitanya Kumar wrote:
> > Hi,
> >
> > On 10/6/2025 1:33 PM, Borah, Chaitanya Kumar wrote:
> >> Thank you for your responses.
> >>
> >> Following change fixes the issue for us.
> >>
> >>
> >> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> >> index 40ac4cb44ed2..487ad19a236e 100644
> >> --- a/arch/x86/kvm/pmu.c
> >> +++ b/arch/x86/kvm/pmu.c
> >> @@ -108,16 +108,18 @@ void kvm_init_pmu_capability(const struct=20
> >> kvm_pmu_ops *pmu_ops)
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool is_intel =3D boot_cpu=
_data.x86_vendor =3D=3D X86_VENDOR_INTEL;
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int min_nr_gp_ctrs =3D pmu=
_ops->MIN_NR_GP_COUNTERS;
> >>
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 perf_get_x86_pmu_capability(&kvm=
_host_pmu);
> >> -
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Hybrid PMUs don't =
play nice with virtualization without careful
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * configuration by u=
serspace, and KVM's APIs for reporting=20
> >> supported
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * vPMU features do n=
ot account for hybrid PMUs.=C2=A0 Disable vPMU=20
> >> support
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * for hybrid PMUs un=
til KVM gains a way to let userspace opt-in.
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cpu_feature_enabled(X86_FEAT=
URE_HYBRID_CPU))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cpu_feature_enabled(X86_FEAT=
URE_HYBRID_CPU)) {
> >>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 enable_pmu =3D false;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 perf_get_x86_pmu_capability(&kvm_host_pmu);
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > Can we expect a formal patch soon?
>=20
> I'd like to post a patch to fix this tomorrow if Sean has no bandwidth on
> this. Thanks.

Sorry, my bad, I was waiting for you to post a patch, but that wasn't at al=
l
clear.  So yeah, go ahead and post one :-)

