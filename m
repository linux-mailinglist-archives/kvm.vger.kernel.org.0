Return-Path: <kvm+bounces-15712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 570148AF6F6
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 21:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 132162866E4
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE2413F452;
	Tue, 23 Apr 2024 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dr3CMfwS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18DE22F00
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 19:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713898834; cv=none; b=VXZfCnkx3YobAeAGJGn1ySn/xtcijPlCpo/XLZ60caWrSqrLxmRTnuCa6KyORNZ3JmQykmChUmvkSAEz4p0bnn9PA8sacYWsdvEmPsnCkRRVWRFuZZFnxxJ3Jw+EIyMMm/q5N4Z1BMVU4qH4glKcC0ubKJY9MtOQvt7Mb6mnfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713898834; c=relaxed/simple;
	bh=9ZRNV5IEjj6pQK6ABa004aPFYt/qCttauflFnqjwfxw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Shqc/cCVVAbgDCXsa5NmDOV8F5+1s4LCQU8U6Y3J3dftLMYyDC/29MC7bMIam7H9pXbvaq3ci2lVlG3Du2ztm/62ctt6BmxCNO6rB0YfPNlvc+8UDSbh0l/96CBzYCTQ2QUKZ52AfR3ODBi1gSthwzTP/XHT5LHBqQ5o5C7+dUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dr3CMfwS; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b36187e6bso3204047b3.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713898818; x=1714503618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eozkpt25SNGElp7CTU+M9ByD5iwYugeLYobjRhBknpg=;
        b=dr3CMfwSSdZhxKlxeShejgjxLIaXJAKS4SvuIDmqx3/AcKStUoQtRLAIwspKhtlCKm
         XrVD7TWBu2x/U8Rn2G1PpzPJ2BU8FnmnFfXGmY0/WmMDl9Yrq2r9ThJ9z6SpY3JOiGGW
         SuuWJwjO1OCVUjscNpq51yXuruIpsv8Vh2iHJAmn2L961FnUf/pjZXTsADsolIoxxcXD
         Nj/Z09cB3pFaqwopzirP0YGwr2NIf5XLCCkePz22f88dNrGKxx1CS5IJMvVN3DiSGvrZ
         hy4ISaNhZOdAyjpQS99UcZKgmPmokbnKpMzerT+nc+7Y1bCztl5UB6d3ZOxwdxjosBF/
         0zew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713898818; x=1714503618;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Eozkpt25SNGElp7CTU+M9ByD5iwYugeLYobjRhBknpg=;
        b=vxRe1b5aZDFYg4ZbJcWNBno+VnTBNklItH7u/9WffHVkJEw1EbHFnQ6P0vcmRWEYO5
         7CQKDPeC2zB54M6/gTZNgf+b0mbMHS6Q8Tlql8EV0TV4YyBrwXbWallx921S15sLmd1d
         L13rMD2+xOOWa5Th9OUqrZriAD14R9bqh48pjJxGISo4EDXJsfnNrnW+we/xhlqfpvSz
         HG+JcKmez50xBsvG/qPXWuqQvdyYL+qp/m1fJa1Wz0mE7RnEzF5ZATB8IM8WmrbLKnTo
         lcbtO9F/7LxR383zePJviy05YNfq9dVlmJ1y8+JUACo9qW4c9xoO3T/QtVN+9UfIr5wr
         FBbA==
X-Forwarded-Encrypted: i=1; AJvYcCX2WTCURq7txYSj/bTdM0TTrFspeJ9V8VQoEDAZzLuTLaKcZ5omCtHf+5GQhnAUHQYdTL5uMrOnr1oQVSRIvsUN9T5L
X-Gm-Message-State: AOJu0YxDNArHIUalXI+qVWgeFeYRsMYYOUSb/l8jp9dXVMcd9y72X854
	2NSVz2+1+h/2rqrIqQntLT2rM1IwSB3Ji3QUqPpfBzNvl9EdqnJyf4seP6gGaepEAPy6Ob8kkCP
	V0A==
X-Google-Smtp-Source: AGHT+IGiRNNvdCFslqF9rkpxTb+WgxL1/TFOmz348vK2zzlIy738cs2BJVeV1FIUy6JcowHJgK+lhdLGB50=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100e:b0:dc6:e884:2342 with SMTP id
 w14-20020a056902100e00b00dc6e8842342mr107014ybt.5.1713898817626; Tue, 23 Apr
 2024 12:00:17 -0700 (PDT)
Date: Tue, 23 Apr 2024 12:00:16 -0700
In-Reply-To: <CAJD7tkafCAP=qx2H=U2taxPL-5eqrVTqPuSUxQZKSPA-qAjyvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240418030703.38628-1-lirongqing@baidu.com> <ZicA3732THkl-B1u@google.com>
 <CAMkAt6oP2CM+EtSNtCw7+V72UsPTHRZ04t7d21j0jQsj8wkW8w@mail.gmail.com>
 <CAJD7tkZzHQUOH3EiJ_Zn33dya+pumnohoKA7AnnVm4GE+WcOhg@mail.gmail.com>
 <ZigBYpHubg00BnAT@google.com> <CAJD7tkafCAP=qx2H=U2taxPL-5eqrVTqPuSUxQZKSPA-qAjyvg@mail.gmail.com>
Message-ID: <ZigFQPCL7S_VtxFs@google.com>
Subject: Re: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Peter Gonda <pgonda@google.com>, Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024, Yosry Ahmed wrote:
> On Tue, Apr 23, 2024 at 11:43=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > But snp_safe_alloc_page() should again flow alloc_pages() and pass numa=
_node_id(),
> > not NUMA_NO_NODE.
>=20
> alloc_pages_node() will use numa_node_id() if you pass in NUMA_NO_NODE.

The code uses numa_mem_id()

	if (nid =3D=3D NUMA_NO_NODE)
		nid =3D numa_mem_id();

which is presumably the exact same thing as numa_node_id() on x86.  But I d=
on't
want to have to think that hard :-)

In other words, all I'm saying is that if we want to mirror alloc_pages() a=
nd
alloc_pages_node(), then we should mirror them exactly.

> That's the documented behavior and it seems to be widely
> used. I don't see anyone using numa_node_id() directly with
> alloc_pages_node().



