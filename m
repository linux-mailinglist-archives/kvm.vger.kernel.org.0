Return-Path: <kvm+bounces-66807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB9FCE85E0
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 00:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5298E301E93A
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 23:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4603F2FCC01;
	Mon, 29 Dec 2025 23:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iMGPdjGA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87952FB998
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 23:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767052645; cv=none; b=MLQKxQs5xywMyVZ6uWDT5MK6E9h+7Pt5tulZZFSUsbH38hEGwM/bSJmbchyIL9qop8zg0Fz4HCAN4E77adZgISBFoekheaPN0Sxm4mHzhm9BpLzXCkevfpi8VJk3OV8aJiRSVa9HoQt3ajXiK+kft97phHqWEsbM1u6iIURJmos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767052645; c=relaxed/simple;
	bh=XsdXtJjKqE4UQSylmLBTu+OUvPU6Hv2It+NLCukC3Fw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MZFfq92WTOKF+0G5t5o34IjObqBMePqLoisyF0W6apIPSqFimUSmsC3RHtqJ7sIz3yZPDPzOUrlgeaGhlT1mRABX5evj7/ed6k7M4utR+bDic3poYO/o4/mok8a2M9Qoajh6aq3OJ0RwP6DvQW6fU0HmFSesu64G/DRBdcFvKz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iMGPdjGA; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7c240728e2aso20431762b3a.3
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 15:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767052643; x=1767657443; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vaCAmCD1pI2PB4kVDvq818qZSC88KaBTxMeyOFyVIUw=;
        b=iMGPdjGA1NQR/+V2pygPXYkbZKCeSUCbyCWckcMe8i7VNxbWAVUa0DKCkg38TNo7tk
         Ru3i/cn1OQoxpa0xQ49TLxtBOHnHNRREO8NvQ7HjzeGoi6v6RZQpaeEmqZxE5e64nBSZ
         YrSRWR2ntXcP7mf4h6b4eg4oqrVHgP9uArjOrSnD1WL8EdUgSSHTs6a2moDAC/wQAFu3
         tMQXq7WnbGyu6mfiweCpH/5RmONrO0vVfezaB8e/MjA1I4WpUhzgm6sB0hytO8LJA7kw
         WHumsubJ1Io4LeLO1UDQ9auzlmIEu5kqdyuMefPSzpFaLA7o/aiGPUsxtXtFpQF5GWxZ
         vGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767052643; x=1767657443;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vaCAmCD1pI2PB4kVDvq818qZSC88KaBTxMeyOFyVIUw=;
        b=Ba90pQyZjjOlcvTsvD1/AwrOP3cu4hdvf2L4gzDaS0lDy91TnIktmNhNOA/mYtq+xY
         85pie0LKAxpP3vpQZooM2UFlAM9Z44TcKNrB8LQJR7HzDfROORO6jiL7op8LwebDPhGp
         OSIlr4c6bQDWdLaTm4zmkoTpZMc+4VcFrEqKppZZVW11iV5P8RhuoPi2uLmPOuqCKM5o
         p+64wYaeYsPuMSJzSTZ7+WVgKTYrDvXi651fR6Ms/R4IpawDwEr2kjvaUkzjf7rTdaXh
         cZfF0kdt45+rh0iRH9ztGyqGwHB4aqNd7Dos7WkofhKnGtiGWjipec1ilwIk3jRJPmcg
         OOzw==
X-Forwarded-Encrypted: i=1; AJvYcCWzc14Rj+DuKIsWWQyTaL8mb7V5pDh8d8WZacXIYCCKIKe29wNIyhAYYEmUqKD7GaRNQT4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV7NWpujt7uY+aeE4/gF2IQEZGbt0ZDF6nJ8N8r5zMbslVEhK0
	BlcOkcU94LwHsXtbFcUEnEmlwsKzTIcsCS1u7t5jR4tRN7QbGosq+IuDOjs3+BMM/ZBHBJPCt6P
	o7NDwvQ==
X-Google-Smtp-Source: AGHT+IGWSzvMBdAgSpc1cQ4FNAzud2F9vkcmbgsGWHl/uECW+mXFCBlsNw6jhBxprH27ZWhYhxw4eDFyKfA=
X-Received: from pjhk89.prod.google.com ([2002:a17:90a:4ce2:b0:34c:1d76:2fe9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9185:b0:343:af1:9a57
 with SMTP id adf61e73a8af0-376aa8e98d6mr28981483637.56.1767052643109; Mon, 29
 Dec 2025 15:57:23 -0800 (PST)
Date: Mon, 29 Dec 2025 15:57:21 -0800
In-Reply-To: <43d1cde6-2277-4f3c-8e7d-59e6edb2228a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-16-seanjc@google.com>
 <43d1cde6-2277-4f3c-8e7d-59e6edb2228a@linux.intel.com>
Message-ID: <aVMVYY_WkNClfXuj@google.com>
Subject: Re: [PATCH v6 15/44] KVM: x86/pmu: Snapshot host (i.e. perf's)
 reported PMU capabilities
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 25, 2025, Dapeng Mi wrote:
>=20
> On 12/6/2025 8:16 AM, Sean Christopherson wrote:
> > Take a snapshot of the unadulterated PMU capabilities provided by perf =
so
> > that KVM can compare guest vPMU capabilities against hardware capabilit=
ies
> > when determining whether or not to intercept PMU MSRs (and RDPMC).
> >
> > Reviewed-by: Sandipan Das <sandipan.das@amd.com>
> > Tested-by: Xudong Hao <xudong.hao@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/pmu.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 487ad19a236e..7c219305b61d 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -108,6 +108,8 @@ void kvm_init_pmu_capability(const struct kvm_pmu_o=
ps *pmu_ops)
> >  	bool is_intel =3D boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_INTEL;
> >  	int min_nr_gp_ctrs =3D pmu_ops->MIN_NR_GP_COUNTERS;
> > =20
> > +	perf_get_x86_pmu_capability(&kvm_host_pmu);
> > +
> >  	/*
> >  	 * Hybrid PMUs don't play nice with virtualization without careful
> >  	 * configuration by userspace, and KVM's APIs for reporting supported
>=20
> Hi Sean,
>=20
> It looks a merging error here. We don't need this patch.

Gah, right you are.  I overlooked it because it didn't conflict on a rebase=
, and
I once again forgot to test on a hybrid PMU, grr.

Thanks!

> The original patch "51f34b1 ("KVM: x86/pmu: Snapshot host (i.e. perf's)
> reported PMU capabilities")" had been merged into upstream and subsequent=
ly
> we submitted a new patch "034417c1439a ("KVM: x86/pmu: Don't try to get
> perf capabilities for hybrid CPUs")" to fix the warning introduced from
> previous patch=C2=A0 "51f34b1 ("KVM: x86/pmu: Snapshot host (i.e. perf's)
> reported PMU capabilities")". Thanks.
>=20
> -Dapeng Mi
>=20
>=20

