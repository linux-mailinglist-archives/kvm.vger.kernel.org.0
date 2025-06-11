Return-Path: <kvm+bounces-49109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D36AD60BA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:09:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A15F31E1121
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF782BDC28;
	Wed, 11 Jun 2025 21:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tsw+Qvdf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C74D1EB39
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749676184; cv=none; b=RZQsAVNEKGFu8R2+BRJmrN83lyvSyHtnMktWzJ6BY8E42MQhPKvxPwuzA0WwVaWvbRQmO2O/ENcllrM/ca0DkRo76F5xe1+6GrIBFw+FOKNvNZGDnspAp7Y9pZ6FpA6XX6HZFKJBnci+XV2+FI9Ucwdbmm/umJ12bESx5PbCNlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749676184; c=relaxed/simple;
	bh=aNvWjxK6lyH38L8TrWmLCp5uspZgS1RsSRt2DKL3AEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eOsG9gdlMc2MueV3aLMWzQ6R5VOsxIJ3b4OvwNSuuPOl2BUdSkpvs5tT6WxVCXRFF/JwgP2RgXy8dOm6cE+slOfZCa1FsZ4221kIc0anGcOp4YmU8J2i9D188VIcy+T7gL4J0Azp9YnAjA9piuM2JfcLixB9sov0eLHHhLrGOLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tsw+Qvdf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-310e7c24158so232217a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749676183; x=1750280983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMQkqCwzmIXYFrrnZkAcfDl3xDOFYF2dYn4KNgsYvkY=;
        b=tsw+QvdfdcPDtBXmrBzxkZ48igYhpLtKM5e9Vn0M5YKq/VEw2adAdah5J9++kAoF6a
         WDhQbZJ/D+We3K/fFoSqOn9zoffYjIFKOGhFRHOVkNX/jvUsao4dTTl3cb+q61NkERYE
         5Gn5PVlLvjTdF84ylxld+z9+LzJeQ1oSEb2jZVayOmFKbAKLhy08K9vPMW/bmg2GoOei
         VWorIvzko2cJ0nuSRYhQUlLklKrjQ6fMzMvxGpiM6JeTwS15FomhdY8DP+hs1tWB2/ly
         cI0131qBOAROStW1GjxfXNS/8x2exgInOP0KGd8dT1j0nGgle2aKryXPMYc6yE7FFUDm
         kY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749676183; x=1750280983;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZMQkqCwzmIXYFrrnZkAcfDl3xDOFYF2dYn4KNgsYvkY=;
        b=hoXHsTyoeq+VUbBy0ic8WgbRMiIIhfz3oc27pmdVBs+qa2Wk+TwEY3bmk4b9OhOyqc
         +hWswB1Hzk+8KIZ7d2NVPo+5GZHXD7fhGgEXZY4iJha6FLGAaZOB5aEYZhuHGy0henlh
         ndlMdSHysjZfHydc55V+NweP5N4vIp3JTTvhBR8ooDaNyCvB+LAKESQ6cNtJZZvI4eS0
         3w7nfjoTV3jmYC10tXWlFBl94IjZHmPypmRvJwhAgNF61foJsQBYqO8qmVfjTbvT0XZp
         z2MeaBVNr7mYjMgo3qt8Z7sqTSn4qaVmcKiOOMGITsBM1acJOyh3+XNarSWjoDgQmynR
         BW1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUygVRiPxp/Xc6FFipXM5jC+CimbE5MR46Oo0ViIx/VInvw5mOPLC0DYsKm0yf6Gm2z6pU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWgWBRYz2D3E4xDLlPBw7gdYcEYHZzidZIdnOYbHmhxsTJ+hSD
	yHjlR4AUb20KOupeBjWeuHRmp0Tl0+gu+24vYFNMlTLBvDKfKmvaUDJtlHVYorHh0lmLqndWbpk
	m/Tf8Bg==
X-Google-Smtp-Source: AGHT+IEb/UGrw1LaCOx+NlySWUskzO3viqPifHVWpoL14YgOs7Ph7yCuEndM+iEYCbyktI8ZT/I3bf7B8B8=
X-Received: from pjbqi16.prod.google.com ([2002:a17:90b:2750:b0:312:f650:c7aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d49:b0:311:ad7f:3281
 with SMTP id 98e67ed59e1d1-313bfb676f6mr1565236a91.12.1749676182673; Wed, 11
 Jun 2025 14:09:42 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:09:41 -0700
In-Reply-To: <32ff838c57f88fd4b092326afcb68b6a40f24ba0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
 <aEnGjQE3AmPB3wxk@google.com> <32ff838c57f88fd4b092326afcb68b6a40f24ba0.camel@intel.com>
Message-ID: <aEnwlQtenIEUczVX@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for KVM_PRE_FAULT_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025, Rick P Edgecombe wrote:
> On Wed, 2025-06-11 at 11:10 -0700, Sean Christopherson wrote:
> > Back to the main topic, KVM needs to have a single source of truth when=
 it comes
> > to whether a fault is private and thus mirrored (or not).=C2=A0 Common =
KVM needs to be
> > aware of aliased GFN bits, but absolute nothing outside of TDX (includi=
ng common
> > VMX code) should be aware the mirror vs. "direct" (I hate that terminol=
ogy; KVM
> > has far, far too much history and baggage with "direct") is tied to the=
 existence
> > and polarity of aliased GFN bits.
> >=20
> > What we have now does work *today* (see this bug), and it will be a com=
plete
> > trainwreck if we ever want to steal GFN bits for other reasons.
>=20
> KVM XO's time has come and gone. Out of curiosity is there anything else?

Not that I know of.

> Readability is the main objection here, right?

Maintainability first and foremost, but definitely readability too (which o=
bviously
plays into maintainability).  E.g. if we properly encapsulate TDX, then it'=
ll be
harder to pile on hacks and whatnot simply because common code won't have a=
ccess
to state that lets it misbehave. =20

But yes, you're correct in that I don't have a specific use case in mind.

