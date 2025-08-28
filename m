Return-Path: <kvm+bounces-56176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 741B2B3AB22
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B150A1BA6EC0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CC4827E079;
	Thu, 28 Aug 2025 19:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V1yc7p31"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373D427C84F
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 19:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756411080; cv=none; b=VY0zLegf8TfWEB62AG8FrLzj8/cd41UEn58Z012f//FmYR5aRjHBLg+IEZHNWjBGJ0xmEp++To9elXgfQjw6AKYyYjMKe1bSWYpuQw5PQkc2s6K8txvyYcuaL2BABzoXB0+9n9ZN6h1PvGvqMBuPHsDDUqWOvz4V4KtWohW+qZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756411080; c=relaxed/simple;
	bh=BOwWcteBhzF9ZCxYgLAjaBaGgaN302B3hQ8FoYKBVlQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F1lG51fKM0ZVQAchcoFG/zNH9HM1XJxOtCWb6HeEK/2iUcQO+90f81bQ59+XuVXZUaEZcfxNFcFhyamk4TdqhS7BhCNWmagEDjaXLUprC2YS/bNA8nxvG61ukmDmN+qJf/KGUlC6xh+XkCTMm4ujhXk7gQv/vSfyEGrTKAYXEVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V1yc7p31; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4c32f731e7so1040204a12.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 12:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756411078; x=1757015878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bdq+7JGy4B21T0bnG9OjLe0/o1KSwsdC1PjNFByJcs4=;
        b=V1yc7p31L4hwKWKKiNaiOh1Wp+NGMkpM8OGMCD79BqN2XuN+cIUmnRK/XAcDrF9VTc
         S3Nq5eMLobbE97gyJvwIG3W+DOnjzcynNBPXEptzqHJl7wMu2IZiIVgguMvCGT1FeT6f
         azAPvv8bv7h7DFBFX0nS4yfCNpwEbL4hmCxplwOP4bA7E0Qm6UetTGpRPE9ev18cE+yQ
         lhJgwQh9nKQrNlHsPKrf1viUsf6qYD08JHz4+HLhZQiPq/Zz1kPk0bR1SmFEwkNtYGiQ
         tD5s8ityRJwBuJBhoqsxbxY+7xJoILDI98dGLTIAxa6Bd3fBwmxqpoTv30IT8AJn3/77
         ZQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756411078; x=1757015878;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bdq+7JGy4B21T0bnG9OjLe0/o1KSwsdC1PjNFByJcs4=;
        b=Se8JfP8NPBlqRhVArq0Ld3iJlpYUKpT8UFHTsC9RSOTZtgBZ2eKbvz1HnigPbyyBsQ
         mcNE+8MV9PC20IxyYGd084afu7P1kfQv1JRtinDeT1HfihkCJTgfyScMW7iRZDiDiu9V
         TVh+i6MTP6RjhIt4oYiLqT/4AQn9/yuPC1NtrxWhzzDbCRu/GnS1kndN981GlE68HB9v
         WuBv2E3BzwxtDDnDkoJbaV2/riD5vU8ybb61zDp7sMptiKIgXiNe4+58ejlSM7Vrxd7b
         uRpe4rUh3XpykS7fL7IbQPFXkJX7W2bZ+ADoEN1irdoIWWS3qQutaGoz1tr0W8Fa5fUw
         FQaA==
X-Forwarded-Encrypted: i=1; AJvYcCVXmmmCOfaXt3vKSBx/NmbuCuPDxQ9if6rTXTw2YsMiPlNDkPHuTwkqTtSOz2F17+kH9yI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRbKEHvS++8iQgiYm/ZUmqiflYrzq9kbbc8ZEBCndBULBWKkX8
	HCm+vl9D3ux0MM+pxBDIB3+bwYjcizZOcRDrFWT9KwJsEHaXepxLJqlatpL0WvrTwU1XiAo6mor
	MTcK2Kg==
X-Google-Smtp-Source: AGHT+IE+EdWii51V3hZfb32YWtUaceJAIxnvvKKaBCSr3RCVdHe9uAWLpbmgwOb0D9OP9OVPp15a0q2Tu00=
X-Received: from plbm11.prod.google.com ([2002:a17:902:d18b:b0:249:329:c51c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec88:b0:242:9bbc:3644
 with SMTP id d9443c01a7336-2462efacca1mr370061045ad.54.1756411078545; Thu, 28
 Aug 2025 12:57:58 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:57:57 -0700
In-Reply-To: <a0f42c955d4b86229b9cc200b37963ac24458f76.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-3-seanjc@google.com>
 <68afa57959dd8_315529471@iweiny-mobl.notmuch> <a0f42c955d4b86229b9cc200b37963ac24458f76.camel@intel.com>
Message-ID: <aLC0xXVLq1olR5qQ@google.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025, Rick P Edgecombe wrote:
> On Wed, 2025-08-27 at 19:40 -0500, Ira Weiny wrote:
> > > +		.map_writable =3D true,
> >=20
> > Why is map_writable set?=C2=A0 Doesn't this get translated into host_wr=
itable?
>=20
> I guess it's normally set only if it's a !KVM_MEM_READONLY slot for priva=
te
> faults memory.=20

map_writable can also be %false on read faults and the host userspace mappi=
ng
isn't writable.=20

> But that flag is invalid for gmem. So we should only have
> map_writable=3Dtrue cases for tdx.

Yep.  And not TDX specific, map_writable _must_ be true for write faults.  =
The
reason there's two separate flags is so that KVM can opportunistically crea=
te a
writable mapping on read faults.

