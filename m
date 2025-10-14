Return-Path: <kvm+bounces-60035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 41399BDB67C
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 23:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B5E3E3523AF
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C9030B522;
	Tue, 14 Oct 2025 21:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SMWzs3RK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CC91F03C5
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 21:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760477074; cv=none; b=EIrJfmw4aQTLQkrYt6XhM061JzxKAkZD8CXiaO0TfwdOl0JBMPLX4QD2VNjx1dqBMIE62PyVva2TFt9Fy8p0ERAxyIfdyl/dugUGGMXNNUVfjIxk+3nKclvVBWZzLX2ScfAS4CxtrDYHc7uGUOjG7AF4qyUOPpzRorAHfthKv9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760477074; c=relaxed/simple;
	bh=aSeK44G7luK0uGJzEct5H63MbmzQi7b3uOiSjCGVn/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kz6K91EnAgwRrf86NrcDiy0rEu4Vc7pxcGkHtm+a/Qr67rnWfulvetIqQjwizwF4qDpWkvBlztkpbuoJbLG0syy59MQWBvbEstixfsdQ0fSW3yVaqSq8WE67RBc1O4ZL3JBGCuCMSzZ4ITlM57QWGrqv+ygWA74DEaxQfk6xAZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SMWzs3RK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33826e101ecso247050a91.1
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 14:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760477072; x=1761081872; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mYa6ss2+x4hHNgMMLwUN6Xzy5d6nXsDGh9Rx7/y85fQ=;
        b=SMWzs3RKJsadlvbzclqIlh0LmhDqDviaVcBop6iJtF3wGnSGcNOhP/nw3sGj9fKSsq
         B2dwXQ3393nejxKveBJ7hOqwKJShO6Oprq2XJYtMB5USxldqxfyDLdGMaQNsmLKsDe+Z
         syn9AEWvPGzyvI8rmVVy99ZP5U4RxhV6Umj/zjnvrVD5kQN4VseezjpTmfEHQtMKRVx8
         zTw3RIHace/yK4kvqLXAjQNo8w+5pUuID1VeDZdsioJ5X3N7Nx6WdD0+IK5eWMMCxp+H
         cxGSmzAct9z1eyiyqJ0vA10bQCmg5tdECEqo824fAP5ODsezmXR+gLiPDX4QdK24FGIa
         nIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760477072; x=1761081872;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mYa6ss2+x4hHNgMMLwUN6Xzy5d6nXsDGh9Rx7/y85fQ=;
        b=kd4IXv5whaKgckF6PvI5AnTv1lZkUrQoMXA6TN/rCJrsnlMBrmvP2Q9oHD2+pFW+fX
         eL4xY4pQi+xd782pG/6biJz025drxOV2w5nH3AoxmMYGBTELtWhdn91u8UZcClV4nZCI
         gZ3ewx07BlcfDPX8TbcV8lsCZF+Htk/QNl+fXSZ+nBGrX0aViLJhGxQFe2sVPhABvqxm
         DhipVL7N0G/LaFgb+xfkBM6VWfJADmhT6H+10Wn3YTzxcV0gKqMvVZZ3Vna/1SvmcNRV
         O1MIjEqXvcwytH2SENXo/TAFl+cLHOBPOTku8zKHKB70fDVRwIcj2sH2p6YBnxNg+ehg
         LNog==
X-Forwarded-Encrypted: i=1; AJvYcCUCuxUJvqHjMt9/8yOpILqPubvCt18ky2gdmkDxcIyoeZQZdXWtK8hhfuEVh9vAwyvNL/E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywew2ZMouvSc3RRPnnI/85gFR5FdBEs++PcYAdO2RZgp39JbIe2
	zkaHY1t/JZxWAlrlWUzixJtYXkvb8ndHGmHKesNRT2Rqwe5bjeVCCjwUegF+3s7xqwKq9bdi8DO
	XxgWxnw==
X-Google-Smtp-Source: AGHT+IHX8Jy0M1JBFk6lQsQKZTo86YiB/IwGKKkwJEOCBeRFMvDtz7vI0OgXa2nqG5b1DW86HcKEO02ZVYI=
X-Received: from pjbbb15.prod.google.com ([2002:a17:90b:8f:b0:32e:b87b:6c84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5824:b0:32d:fd14:600b
 with SMTP id 98e67ed59e1d1-339eda5e097mr44148257a91.7.1760477071924; Tue, 14
 Oct 2025 14:24:31 -0700 (PDT)
Date: Tue, 14 Oct 2025 14:24:30 -0700
In-Reply-To: <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013062515.3712430-1-nikunj@amd.com> <20251013062515.3712430-5-nikunj@amd.com>
 <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com> <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
Message-ID: <aO6_juzVYMdRaR5r@google.com>
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "nikunj@amd.com" <nikunj@amd.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, 
	"santosh.shukla@amd.com" <santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025, Kai Huang wrote:
> On Tue, 2025-10-14 at 11:34 +0000, Huang, Kai wrote:
> > > =C2=A0=20
> > > +static void kvm_vcpu_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (WARN_ON_ONCE(!enable_pml))
> > > +		return;
> >=20
> > Nit:=C2=A0=20
> >=20
> > Since kvm_mmu_update_cpu_dirty_logging() checks kvm-
> > > arch.cpu_dirty_log_size to determine whether PML is enabled, maybe it=
's
> > better to check vcpu->kvm.arch.cpu_dirty_log_size here too to make them
> > consistent.
>=20
> After second thought, I think we should just change to checking the vcpu-
> >kvm.arch.cpu_dirty_log_size.

+1

> > Anyway, the intention of this patch is moving code out of VMX to x86, s=
o
> > if needed, perhaps we can do the change in another patch.
> >=20
> > Btw, now with 'enable_pml' also being moved to x86 common, both
> > 'enable_pml' and 'kvm->arch.cpu_dirty_log_size' can be used to determin=
e
> > whether KVM has enabled PML.=C2=A0 It's kinda redundant, but I guess it=
's fine.
>=20
> If we change to check cpu_dirty_log_size here, the x86 common code won't
> use 'enable_pml' anymore and I think we can just get rid of that patch.
>=20
> Sean, do you have any preference?

Definitely check cpu_dirty_log_size.  It's more precise (TDX doesn't (yet) =
support
PML), avoids the export, and hopefully will yield more consistent code.

