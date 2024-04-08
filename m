Return-Path: <kvm+bounces-13931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC7F89CEEA
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D30881F24C01
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBCB1487C5;
	Mon,  8 Apr 2024 23:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B6lhfpFN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD11B4437C
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 23:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712618469; cv=none; b=Ac5eiwHXkcks7JyJHGVviGpc3SmR5MIR0LwjlnM2VcI1lWdQ42WS4Fwajz9TDaerJ2Xy51JIGRRF/Lj9mMbIlClzeLB98gAg81gNwtNe+OjJG3z5cf4ILPRtwk3RzV/STAS+ukq1+9Uzqb03PXu6OI5Wd1lx2pq+SYP76u/fzFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712618469; c=relaxed/simple;
	bh=73NyjQ9jTspi4Vo9rs6GAoRJetcGTgtL2w4l+r6/bZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J2C+nIanvo7bOZP5iN87s2Dzu7jGu1fkZ+GKa7rHUjOvA44FlseUE0R3HNxpZRRGy01ivyR1vKRaE5731l/hEoj2+RNKDcuCk5mrFoeqBIj21+mPwG7fly+hR68+F/ndkvAPNTp5PgugtQGhAVt35X8VCv4uLKjy4WsUhCwOYpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B6lhfpFN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc4563611cso7411498276.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 16:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712618467; x=1713223267; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAmUps3fqSSeTtMjZ2t2oR9+XDoNJRncj38VfyILVlI=;
        b=B6lhfpFNfaTPix50KSDohYB77ybojp6ehrgs0TbTbwPAIEUdSCl3WwmYBWRnh+3GF3
         OQoTXV+5EvwQasVWguVnaOfF0XzYMKFLkMsjy1Wbg7qOe6kDpRoi1s0xHKfYcznX0+CA
         TGpInonJXlKK9rNk790qJS9hn4BFARq1NTEsG72xfXMs1jkegG2gfrvWVYSPH+lVLLy5
         nrKnpRjQY9lp8KUGFvLPscyevc/LeOdeDYPj7KeEAJK4+JIgNRc1/Uw7VXwk97S69aqg
         G+9OB/XfkMTSACzx3KnnZpFLlbGxf9Qij71WFN7PFZ3gvdyLbQj5vNoSxjeo9DXMFVnx
         w7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712618467; x=1713223267;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jAmUps3fqSSeTtMjZ2t2oR9+XDoNJRncj38VfyILVlI=;
        b=N5+d7q9ChSj8JeyELmqIkBF+AeMGLqWNfbEqqVf18OsJ1eFiFZOfT4wQmHsqfPzmvZ
         saepwAxe78VE6igjz+hXkayo54Ruv5jz1aTYxHMVnIQTmmRTVcX8zGsRv9T8uk/d0KoJ
         iSNu7Ea0EP2aH3kkj/Uf9Q0kKXjarZDKn9pE6APbkyNiqlWe+No7PpFlThDNlpzmltfg
         b7aD8CjRahOPOEPFCoYmzerS0rtIozrveA6TZeKH67UQ6sS1h9PeWQwh935dr/8c5rDf
         tY1VcHCYMYAH2KnQg8dq2zhONKklFVnALd5joXkaLYyuXqqYiOlxMrWBsiqc84NNoWNd
         NSDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl/3Ni4RxiNLfo71ICeU1JF5U1hv10EYKqoQExJpKdJaL1I3V5K3GjYumfypJtzgdr1RM0Dxroj+30x/NHOp+bu3VW
X-Gm-Message-State: AOJu0YxAl8RdQe3/2U/RUc8aU0LInNcvNgt6KgvMkwcLRGcxF+XmFzcE
	TO5TJUGmS5EQL/PB8vBQT/Q/Klq8eDixEcgKtGQviX7XI5ksiJICXDZXtclSW5Z3rhm943eoJRA
	cIw==
X-Google-Smtp-Source: AGHT+IFUcHjnvxedK+I4lyvh2pzfpl+jD4rB/VzNuFRZTn6oZ0X85k5RAJHtKIhy26MTuhSuNPdtYHWm0II=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1245:b0:dcc:f01f:65e1 with SMTP id
 t5-20020a056902124500b00dccf01f65e1mr3044891ybu.8.1712618466822; Mon, 08 Apr
 2024 16:21:06 -0700 (PDT)
Date: Mon, 8 Apr 2024 16:21:05 -0700
In-Reply-To: <ecaf87b40d6da2ca39a5eaf94d2efded2ae3368c.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320001542.3203871-1-seanjc@google.com> <ecaf87b40d6da2ca39a5eaf94d2efded2ae3368c.camel@infradead.org>
Message-ID: <ZhR74WgWxO4MQcbl@google.com>
Subject: Re: [PATCH 0/3] KVM: Fix for a mostly benign gpc WARN
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com, 
	Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 22, 2024, David Woodhouse wrote:
> On Tue, 2024-03-19 at 17:15 -0700, Sean Christopherson wrote:
> > Fix a bug found by syzkaller, thanks to a new WARN sanity check, where =
KVM
> > marks a gfn_to_pfn_cache as active without actually setting gpc->gpa or=
 any
> > other metadata.=C2=A0 On top, harden against _directly_ setting gpc->gp=
a to KVM's
> > magic INVALID_GPA, which would also fail the sanity check.
> >=20
> > Sean Christopherson (3):
> > =C2=A0 KVM: Add helpers to consolidate gfn_to_pfn_cache's page split ch=
eck
> > =C2=A0 KVM: Check validity of offset+length of gfn_to_pfn_cache prior t=
o
> > =C2=A0=C2=A0=C2=A0 activation
> > =C2=A0 KVM: Explicitly disallow activatating a gfn_to_pfn_cache with
> > =C2=A0=C2=A0=C2=A0 INVALID_GPA
>=20
> It looks like these conflict with
> https://lore.kernel.org/kvm/20240227115648.3104-9-dwmw2@infradead.org/
>=20
> Want to arrange them to come after it?

Very belated, yes.  Though by the time you read this, they should be in
kvm-x86/next.

