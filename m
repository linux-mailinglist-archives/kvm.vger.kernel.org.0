Return-Path: <kvm+bounces-27427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8306D986166
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 16:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13E241F29554
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 14:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A931922F6;
	Wed, 25 Sep 2024 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4WVAvYoQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394821D5AC0
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727273529; cv=none; b=f6Be86GIQAvqgw59lguu7lL8umWpIYKF72l99XlWy6d5Nvf0Q/dv/g71Iyi3R0PRhTrDazX7YvrjVQHzUVc/0fz/l18zjPtd9J9voJECPEVIHblNYd1f8hXuamZ/5zzutoSGQd3KsQd3nXTp3ganlSFFCu8AR36edTenkm0CX6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727273529; c=relaxed/simple;
	bh=caZMVSss+hfeV7WP34KAQwEKIbUpl7RXfA/CctTtTn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gDn46G9DOOma29Os41i97Ex/vbC9KVzKCNm/Qim7O1eTnu3N96Nr0Tcc5Fnmqu/pJ1eOmwAvxKIBUex6cTyxyhhKRV8CoPTt9NqqLtYrxdWUfJC0FlmSe10lzs8DJO7pOhP41RSZmcxcaUEgUoLmh6DiuhxxAz9JeGejOkfLLRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4WVAvYoQ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02b5792baaso11021565276.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 07:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727273527; x=1727878327; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zfLBjs5PHlghwVrU7vpRjJ03RkAESW4WXi5zlWV+fXA=;
        b=4WVAvYoQaD0Fi/WB33In28H6NeooazTCZfrEguVrRSL5+HpcrSnZLgTgFo3mVAWUWQ
         oFhsSzjoaDth7euLFYf4xWnBD1AncMfaBV3wWQO2iHoTEZPg8vjt7rY7+vMal1v3ib0n
         UsWbiuFD9icZu0iO+38YfwM1U6zJikyYlcpEMm7779BkPbMvzhNq3wzJYviXsQHQg4bP
         fakYM7NRbozwlTcQXcQvlsw4ZCTjGZXyOL9+upqaZvfJKqkzOTwsahW2cFP4HoVIXI6o
         zDxbe+TYTH0InXa56qJ67fYiOiwIujwf+id5X4ApuYiZqv2gpM/Mr3Fx953h0tJDeraZ
         WJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727273527; x=1727878327;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zfLBjs5PHlghwVrU7vpRjJ03RkAESW4WXi5zlWV+fXA=;
        b=Gk92iUrFIPZSuEsGmtm4sggQQnbC06ye3NqWD29Cyh1WLRVuG9fWlM1SSObdhRB8+l
         0EAVxy6S3soykqfFMT1u6EW4P7Gg4Tr4ImO/lT3GEOSfMXLkJTg1vuKn11eHHqmuuQZJ
         Q7+g9RPTqH7vMaH+UIJcBsixSDO1na1h0qgqpVkrOrlJ2uT1WTNwpeH7twpPt57bpBEv
         cTXrdNkabJDj7MrrELC4cz4QOD3A0OjZGNLsmtgceR+kYWbI/KKYkhnuJudCTPDqL3QN
         whUYOIZsk1ZcW6ykn98aRWtmTDfttkzs9LHsSLCkgluW2OzsrGMcXhJPH8kNnqmAoOU9
         9ajQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy9BARISoW5Muea+ab5nItu0OsScT9zkceh4KXVDX//Qk0fXZfDle8DS+RYp+LbGNCMyc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsc3RkLripBBnicS7KVzHHTei2Ult1IBYpRzJiCsRnaGMz6iS7
	Mh6OV/4mzeJwIbobt49sjIpqa7BYwuKWMunH/uS7Xb8FNB6J+tyEO2AklpdD2FVwNHu2V5GVlTr
	qdQ==
X-Google-Smtp-Source: AGHT+IEPGReoQdLJ0WXkwCLY6OOacP06JYe3XTYe/8Qo1kKrLFuqeITXcsLs6p91L7BG4e12yJbQXU3iqh4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:289:b0:e0b:af9b:fb79 with SMTP id
 3f1490d57ef6-e24d7a104admr29937276.3.1727273527163; Wed, 25 Sep 2024 07:12:07
 -0700 (PDT)
Date: Wed, 25 Sep 2024 07:12:05 -0700
In-Reply-To: <d65e62d2-ca64-4b29-8656-bb8411fe837d@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-8-xin3.li@intel.com>
 <ZiJzFsoHR41Sd8lE@chao-email> <ZmoT0jaX_3Ww3Uzu@google.com>
 <feefa9d1-f266-414f-bb7b-b770ef0d8ec6@zytor.com> <ZuNJlzXntREQVb3n@google.com>
 <d65e62d2-ca64-4b29-8656-bb8411fe837d@zytor.com>
Message-ID: <ZvQaNRhrsSJTYji3@google.com>
Subject: Re: [PATCH v2 07/25] KVM: VMX: Set intercept for FRED MSRs
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>, Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, shuah@kernel.org, 
	vkuznets@redhat.com, peterz@infradead.org, ravi.v.shankar@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2024, Xin Li wrote:
> > > MSR_IA32_FRED_SSP0 is an alias of the CET MSR_IA32_PL0_SSP and likely=
 to
> > > be used in the same way as FRED RSP0, i.e., host FRED SSP0 _should_ b=
e
> > > restored in arch_exit_to_user_mode_prepare().  However as of today Li=
nux
> > > has no plan to utilize kernel shadow stack thus no one cares host FRE=
D
> > > SSP0 (no?).  But lets say anyway it is host's responsibility to manag=
e
> > > host FRED SSP0, then KVM only needs to take care of guest FRED SSP0
> > > (just like how KVM should handle guest FRED RSP0) even before the
> > > supervisor shadow stack feature is advertised to guest.
> >=20
> > Heh, I'm not sure what your question is, or if there even is a question=
.  KVM
> > needs to context switch FRED SSP0 if FRED is exposed to the guest, but =
presumably
> > that will be done through XSAVE state?  If that's the long term plan, I=
 would
> > prefer to focus on merging CET virtualization first, and then land FRED=
 virtualization
> > on top so that KVM doesn't have to carry intermediate code to deal with=
 the aliased
> > MSR.
>=20
> You mean the following patch set, right?

Yep, and presumably the KVM support as well:

https://lore.kernel.org/all/20240219074733.122080-1-weijiang.yang@intel.com

> https://lore.kernel.org/kvm/20240531090331.13713-1-weijiang.yang@intel.co=
m/

...

> > Ugh, but what happens if a CPU (or the host kernel) supports FRED but n=
ot CET SS?
> > Or is that effectively an illegal combination?
>=20
> The FRED Spec says:
>=20
> IA32_FRED_SSP1, IA32_FRED_SSP2, and IA32_FRED_SSP3 (MSR indices 1D1H=E2=
=80=93
> 1D3H). Together with the existing MSR IA32_PL0_SSP (MSR index 6A4H), thes=
e
> are the FRED SSP MSRs.
>=20
> The FRED SSP MSRs are supported by any processor that enumerates
> CPUID.(EAX=3D7,ECX=3D1):EAX.FRED[bit 17] as 1. If such a processor does n=
ot
> support CET, FRED transitions will not use the MSRs (because shadow stack=
s
> are not enabled), but the MSRs would still be accessible using RDMSR and
> WRMSR.
>=20
>=20
> So they are independent, just that FRED SSP MSRs are NOT used if
> supervisor shadow stacks are not enabled (obviously Qemu can be
> configured to not advertise CET but FRED).
>=20
> When FRED is advertised to a guest, KVM should allow FRED SSP MSRs
> accesses through disabling FRED SSP MSRs interception no matter whether
> supervisor shadow stacks are enabled or not.

KVM doesn't necessarily need to disabling MSR interception, e.g. if the exp=
ectation
is that the guest will rarely/never access the MSRs when CET is unsupported=
, then
we're likely better off going with a trap-and-emulate model.  KVM needs to =
emulate
RDMSR and WRMSR no matter what, e.g. in case the guest triggers a WRMSR whe=
n KVM
is emulating, and so that userspace can get/set MSR values.

And this means that yes, FRED virtualization needs to land after CET virtua=
lization,
otherwise managing the conflicts/dependencies will be a nightmare.

