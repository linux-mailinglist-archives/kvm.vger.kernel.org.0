Return-Path: <kvm+bounces-16949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3E2E8BF382
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 02:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5908428425D
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 00:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CACF4621;
	Wed,  8 May 2024 00:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fefSUt/A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69B5372
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 00:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715127666; cv=none; b=KRdPUnfC3Fff+SyznMRyJ4xQSugWKPQ96SQfHV2utVv+enwNuPM03OS8dQguSUJa2fYMVxRO2GeKcLXch+V1PCPMfCSgsRGhQGsefFw5zd0xrP2EY/u/vdzMeWAV7tz3EryLIMR4oAnNGXbl637gNn8ALT5+DufH8y5BfoZeuKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715127666; c=relaxed/simple;
	bh=6QNGrVnw6PUGIQqkgtVttbRiZ7WaoPYzwoKhGNB5rZw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BpUCo1aOpPpWH6GJZdM+BoolJLe1dPEeqkAybFQIoBxlGUmYv9tff85IXrB3ALg1r5Y+aEAQcKTWi9SyClu8cya9usSjz5UNh9ZZPmEofyo7/1gjI/5VfHPaBBFeZhxmBXM21TCkLUNpvDRyr7GbTJY/e+ElZL3NuHG18rYIDkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fefSUt/A; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61e0c296333so4594227b3.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 17:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715127663; x=1715732463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c5zLDljjdB2rK7nQXYwlp9FD4GIUWDXqjmQ12YQdFX8=;
        b=fefSUt/A2doUcKT5UNST+SXlINkKY1T9YAmyqRjq74PD4iRBZHDejmqTBoL0R5Mc7e
         hsId+W/dYeoJYo+0aV8uwa21F+1g6jDd7lCa1zGaWAm3VdLKRccMj6/9tbw7AVyOxgxl
         XIJbe9jAVejIDdhkvorg8D/p8KvIrmnTLVU1gPkQ0jIYn1YCx6LzPuYG65x/SayCbIXi
         zLzELfqJK79XfqNQmADvgkxSqEWuhZwtbPZLyRW2VRzlBPMANdRoavm4KoEHb1mSdVHg
         LFegORuqyUg59+nCH4A2Z3uzEF2nMHF0WGuD8+mcP+19DJnNguXTuoR7gXtX1z85nlS8
         s6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715127663; x=1715732463;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c5zLDljjdB2rK7nQXYwlp9FD4GIUWDXqjmQ12YQdFX8=;
        b=fBbHRoF8zXHPH9Z4C5wAfggAYHBJXo41xPK0uiljbJCijDezUyV0TvApMA0cloRkLu
         LKu5ZytBPs9oE/9E16rqbZDnj7cBzp2YU1sZo4IPcYZb3YlBHK+wQBAnXbQKGPXMSNRv
         SVyqSyrOSoFhfR1ruTwuY6cim7cPeBfRfAVKt6rqJ90h9tHvDsxAmvCpXGLeBaLuxBpJ
         xHUobkKs7px5ZgZ0dcaS82R4IJGhuPPMzco+24QSfbxK0CcFDxRXvAuW6Ej4rNPqHC77
         2CqVe5zqZYfF54nFy6dFxdNYr3+SelpILiYCIPM8NwX4nagV/8ztwhvftsYzw55t4pdv
         bGJg==
X-Gm-Message-State: AOJu0YxhV4K6pjuyrhc6i7oDlXuSZLJs2VeNgfZt6dLCqzNIYUJhEuw7
	esLbMt40HV33zSCr6NBqU1c0nAZPbzFHAUlBkqBsylgPkmfZ5FBZrrlH3Ex4QYqlWkZxpqG3iL5
	O7Q==
X-Google-Smtp-Source: AGHT+IFxJMvsXuvfR7+WfinHqEuybGv+6+GJ2/YrtrunJGOl9Hyc0rlRZrKELtyNNAhrSsSrlLz0CwdSzEc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d80e:0:b0:611:6f24:62b1 with SMTP id
 00721157ae682-62085a32ba6mr3654617b3.1.1715127663759; Tue, 07 May 2024
 17:21:03 -0700 (PDT)
Date: Tue, 7 May 2024 17:21:02 -0700
In-Reply-To: <b4892d4cb7fea466fd82bcaf72ad3b29d28ce778.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404121327.3107131-1-pbonzini@redhat.com> <20240404121327.3107131-8-pbonzini@redhat.com>
 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
 <ZhSYEVCHqSOpVKMh@google.com> <b4892d4cb7fea466fd82bcaf72ad3b29d28ce778.camel@intel.com>
Message-ID: <ZjrFblWaPNwXe0my@google.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo features
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-04-08 at 18:21 -0700, Sean Christopherson wrote:
> > > - Give other name for this check like zap_from_leafs (or better name?=
)
> > > =C2=A0=C2=A0 The implementation is same to kvm_gfn_shared_mask() with=
 comment.
> > > =C2=A0=C2=A0 - Or we can add a boolean variable to struct kvm
> >=20
> > If we _don't_ hardcode the behavior, a per-memslot flag or a per-VM
> > capability (and thus boolean) is likely the way to go.=C2=A0 My off-the=
-cuff
> > vote is probably for a per-memslot flag.
>=20
> Hi Sean,
>=20
> Can you elaborate on the reason for a per-memslot flag? We are discussing=
 this
> design point internally, and also the intersection with the previous atte=
mpts to
> do something similar with a per-vm flag[0].
>=20
> I'm wondering if the intention is to try to make a memslot flag, so it ca=
n be
> expanded for the normal VM usage.

Sure, I'll go with that answer.  Like I said, off-the-cuff.

There's no concrete motiviation, it's more that _if_ we're going to expose =
a knob
to userspace, then I'd prefer to make it as precise as possible to minimize=
 the
changes of KVM ending up back in ABI hell again.

> Because the discussion on the original attempts, it seems safer to keep t=
his
> behavior more limited (TDX only) for now.  And for TDX's usage a struct k=
vm
> bool fits best because all memslots need to be set to zap_leafs_only =3D =
true,
> anyway.

No they don't.  They might be set that way in practice for QEMU, but it's n=
ot
strictly required.  E.g. nothing would prevent a VMM from exposing a shared=
-only
memslot to a guest.  The memslots that burned KVM the first time around wer=
e
related to VFIO devices, and I wouldn't put it past someone to be crazy eno=
ugh
to expose an passhtrough an untrusted device to a TDX guest.

> It's simpler for userspace, and less possible situations to worry about f=
or KVM.
>=20
> [0] https://lore.kernel.org/kvm/20200703025047.13987-1-sean.j.christopher=
son@intel.com/


