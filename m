Return-Path: <kvm+bounces-38925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C774A404BF
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BC9E7066BE
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D6C1DDA1B;
	Sat, 22 Feb 2025 01:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qf5OKmMt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893CD2F37
	for <kvm@vger.kernel.org>; Sat, 22 Feb 2025 01:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188319; cv=none; b=ZuY71WsWb+/5ClyCtHKC9Oh+yFYmr2H0ynU4fCRGe6Ql8qovLVkDtsCnqXrtcbQOXT9iHzrkpVpx2K6h6UqxvRoq3TbH4FtSinNP5JnPWtRKjAYQHBlNMicRf84wjW9HsOir5m72jOyn5AOMCyV3obmLfJd/2GC/yoJoJkKGZU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188319; c=relaxed/simple;
	bh=MgzPXhbeQnWfdIHGhOvE78AeQc6As9NC/ChOURzRh0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NRSmSDEKn2/BTzVD2AZry9yMs4lgq3uGkWkwIIzAnemoPdCgPnA6nhWj9og1Nx/pagL5utqFF1SAdyFCRNi4Og6Ug/RW4HPQUhh9u3C4xMJo3h9HI6D+Cv+Ff1EPS3bdqmnHP5ZXFl8djzci9Suq5Oyq7QAdp9JhKDHNCDtJZfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qf5OKmMt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220cb5924a4so93316515ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 17:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740188318; x=1740793118; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z3Vu+gRNAq0GCQCF5tfZrkQl+KMZuK2rIsH676nBvx0=;
        b=qf5OKmMttj6LDrIsOIM4sMFhJFhClOyVPA2nHHY6zySTkZl2WszADDl5j/kT2J9MY3
         NFzvsM0Tx+Q7WikWW0ovDAJNA9wTqAvfkpQ8TSMvSC4JPGyVvlFrb0d5CaOOP1V+uyVh
         7MQX808jqnP5Oz0+evg/R0xp4IQM/MQEcZzff3v2koCgtS0/XT2KZWKMkHngRwVFjUzu
         rR3fl6j8eVYsiWNpKi1zkQc9AhdTYqmoB8lCen2ANDnXZgG1xbzC/R/x+YgtUqTBAsE5
         XrHyau1emIDvt4YF/BpOnaK1d06wt+3drgsY7/ybFDec2f+e+ZBZZ+nJWmHzQE77nhL+
         FZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740188318; x=1740793118;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z3Vu+gRNAq0GCQCF5tfZrkQl+KMZuK2rIsH676nBvx0=;
        b=VKjGREIXCN6dfSzg3FAuFMjILyPmN/SfDk/RH64kP0DrDAV8MCfHuq0KzB/KVzC8JT
         eCIxNkDUbeo4SPbpeWVZ4CuT8wKNybvuzZP3hw2Pjz7DINoZUkgMBvWQoP30vYJrkCsC
         S9XF99D9pWp4d3dM92b1Gx4XoTcubBelW3Xy6G4KNw7zNqdlrSeGijx7Boukc8B0Lh+7
         6oXZEGPrclCibnN/LinHmKay9YbEN+XTfiefJ6IP9LG9+7cx5ZySDjLXLE5X6QCxvUM4
         uAG9b9dIsICvV616A0jKw23dprzBSkIlTQA1Lf2ZVxsQ1OLGqvCb1GvNQX0ExbsRSjQ0
         nZBQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5DFUbAPaw1XJWKJrCjH/V1XpTrkwPJbbwHqVilSwFcvm4WVIlLqHwqbwbuExGZo/yWEI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4OakYwNfuIwfYE4UBeGJXTrZJKrMgZxWGk8mFL0YOooFRD2e0
	22g+lFblxv/HLJqk7ZAS3Q1+sUb7+xXAwlzxTtv5gksV3N8Lngm8EM3H8WtbmDBwO2uIsJXv1fn
	dKA==
X-Google-Smtp-Source: AGHT+IFqj6syOBY9twY8DWYHC+clFeZSCyyaV7oqTbNZDTx/kW3NVAIfcpvhOrhAmGiLgzPQH4QTEZQeeUo=
X-Received: from pjbsv12.prod.google.com ([2002:a17:90b:538c:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d484:b0:21f:85ee:f2df
 with SMTP id d9443c01a7336-2219ff55fe0mr84845855ad.15.1740188317777; Fri, 21
 Feb 2025 17:38:37 -0800 (PST)
Date: Fri, 21 Feb 2025 17:38:36 -0800
In-Reply-To: <5da952c534b68bba9fbfddf2197209cb719f5e41.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250220170604.2279312-1-pbonzini@redhat.com> <20250220170604.2279312-21-pbonzini@redhat.com>
 <Z7fO9gqzgaETeMYB@google.com> <Z7fSIMABm4jp5ADA@google.com> <5da952c534b68bba9fbfddf2197209cb719f5e41.camel@intel.com>
Message-ID: <Z7kqnDDTSlfv38Pf@google.com>
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 22, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-02-20 at 17:08 -0800, Sean Christopherson wrote:
> > Argh, after digging more, this isn't actually true.=C2=A0 The separate =
"unload MMUs"
> > code is leftover from when KVM rather stupidly tried to free all MMU pa=
ges when
> > freeing a vCPU.
> >=20
> > Commit 7b53aa565084 ("KVM: Fix vcpu freeing for guest smp") "fixed" thi=
ngs by
> > unloading MMUs before destroying vCPUs, but the underlying problem was =
trying to
> > free _all_ MMU pages when destroying a single vCPU.=C2=A0 That eventual=
ly got fixed
> > for good (haven't checked when), but the separate MMU unloading never g=
ot cleaned
> > up.
> >=20
> > So, scratch the mmu_destroy() idea.=C2=A0 But I still want/need to move=
 vCPU destruction
> > before vm_destroy.
> >=20
> > Now that kvm_arch_pre_destroy_vm() is a thing, one idea would be to add
> > kvm_x86_ops.pre_destroy_vm(), which would pair decently well with the e=
xisting
> > call to kvm_mmu_pre_destroy_vm().
>=20
> So:
> kvm_x86_call(vm_destroy)(kvm); -> tdx_mmu_release_hkid()
> kvm_destroy_vcpus(kvm); -> tdx_vcpu_free() -> reclaim
> static_call_cond(kvm_x86_vm_free)(kvm); -> reclaim
>=20
> To:
> (pre_destroy_vm)() -> tdx_mmu_release_hkid()
> kvm_destroy_vcpus(kvm); -> reclaim
> kvm_x86_call(vm_destroy)(kvm); -> nothing
> static_call_cond(kvm_x86_vm_free)(kvm); -> reclaim

I was thinking this last one could go away, and TDX could reclaim at vm_des=
troy?
Or is that not possible because it absolutely must come dead last?

> I'm not seeing a problem. We can follow up with a real check once you pos=
t the
> patches.

Ya.  That ain't happening today.  Got demolished but KVM-Unit-Tests. :-/

> I'm not 100% confident on the shape of the proposal. But in general if
> we can add more callbacks it seems likely that we can reproduce the curre=
nt
> order. At this stage it seems safer to do that then anything more clever

