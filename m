Return-Path: <kvm+bounces-15710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60E3C8AF6CD
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 20:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 694EAB23077
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCBCB13FD7F;
	Tue, 23 Apr 2024 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CN6cTVgv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A002E13F441
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713897830; cv=none; b=nD6UKDrCzidELw5vggfEWcBaftakyuPav49+V6LITixHfdUGLx0nJipYlTl8mCNIQby242Qz3Bgl9tDF+Xyb8SlEHo/8hzs7WxGuxOso9UWBrKccVFQ3wRyVSOX6+fPbOEqcPhVGj7aDaUI1dq3vaHXdERgN0/7JMvB8ub/jcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713897830; c=relaxed/simple;
	bh=6Q0PzAxcTLTT1ggekoAB2uEZkVm343Q1Qyl6LelDu60=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CpHv2Wqx9+WFiGuzeayCglLmw7dn3oUb7oos/LTzF81+agEKf36Vd8rW4Vd8Q9YH+ZafYkUjOTS140ojJFLY/whmaLMoo/iWE0UPmYXRPP+SZlHYAewdQRGO/susKjLVtEBRJkXrUnIhp4nIeeqhIuzOZoSJyjY2jLMh9/sn+yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CN6cTVgv; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b36187e6bso2975057b3.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 11:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713897827; x=1714502627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JmLqvOdNSQ9pkxzH0Kbd66AC7FHHnAEZue54bmYt8FQ=;
        b=CN6cTVgvSQPhx8Aud/se9euCVZ7M/vd9+2NuIUD+XI2GLYjY2f3B6qEPPDxZS6fUH/
         EU5AW/aO+Bs+kEIxHDPqnh8bLinAzxqiAOyx3CFjxBbE+ayWB4m2aQIUr11uaznkSo3S
         aI4m7oudDrEMy3PhzruWpD98dmlsxTtLn4inQ62lfTNMnEanZUP4p0LEhaIXj+ot2xA0
         VhBiV/vQy5U/g89kNd/vlZwhDp14xkYLYLrkJzzePBS8sKI9A4oIEsZxyqVICFmq9WSX
         6xU8nPolDzCyBTvSOf2uNiSZYqa9TUGgrkJs3LyMqLBA+E9MUlMOsKfzQWuOvwcG/H7J
         5K5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713897827; x=1714502627;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JmLqvOdNSQ9pkxzH0Kbd66AC7FHHnAEZue54bmYt8FQ=;
        b=HI3cLiy34Ttt1sVL/cWjXALB1jI3iavmrBMD9VomgSpvB8euZJYGw4mky1RViD8ik4
         SIbv8mY4rZGO3t5kcaRZEW/069Jwqr3cupI11x2xprUi2Si0pL1s2a56o5+G6EBZXsXa
         MaV7BijpRkWUIKaG8DQfEfYpS3OBBZAL8rGRRP/LwivViyeNvHldy0fYSyJaPv2kjWfb
         gPt3xnnv3x3bngjd+hvezR06VMhR1T6FOfTXSVDek23uB/Ei8gHbpEy50YlE+kH+xWW/
         FGsb66yTZ5hI3fRIckFMVnmP6yMI38AXM1qUjk2p0XSLdD3lmR90SEbkuJ2JLs/BBU9i
         Uwhw==
X-Forwarded-Encrypted: i=1; AJvYcCWSjU2z9pYVtES34WoecJbKaGpX9Y/P5jAnXPoWfT1iNEENG5u7rJaZspzoh/Z5ErJ0JlBHtos4y7D6lDZwWVPqZM8h
X-Gm-Message-State: AOJu0YxMN0g++Z18Ov1f1/VH2/+tFs6eeOJPMjNf91jWimzUd8oa+l38
	DKslfrYRkT+2zsNXJpWkh1lc01pM6uwCxQAiG0bXzXioKAB40cXuyv6SoT8+Q0apjhq2/7JXuI2
	oKQ==
X-Google-Smtp-Source: AGHT+IGHY3X4UI2q0Y7rsaX/v5M5ZqK0E7Y0U91SxERm8UNRd88hpc/OZElqf5t5Td1Q4y9RlICBSz8YAgI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b05:b0:dc2:2e5c:a21d with SMTP id
 fi5-20020a0569022b0500b00dc22e5ca21dmr97744ybb.6.1713897827723; Tue, 23 Apr
 2024 11:43:47 -0700 (PDT)
Date: Tue, 23 Apr 2024 11:43:46 -0700
In-Reply-To: <CAJD7tkZzHQUOH3EiJ_Zn33dya+pumnohoKA7AnnVm4GE+WcOhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240418030703.38628-1-lirongqing@baidu.com> <ZicA3732THkl-B1u@google.com>
 <CAMkAt6oP2CM+EtSNtCw7+V72UsPTHRZ04t7d21j0jQsj8wkW8w@mail.gmail.com> <CAJD7tkZzHQUOH3EiJ_Zn33dya+pumnohoKA7AnnVm4GE+WcOhg@mail.gmail.com>
Message-ID: <ZigBYpHubg00BnAT@google.com>
Subject: Re: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Peter Gonda <pgonda@google.com>, Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024, Yosry Ahmed wrote:
> On Tue, Apr 23, 2024 at 6:30=E2=80=AFAM Peter Gonda <pgonda@google.com> w=
rote:
> > > struct page *snp_safe_alloc_page(int cpu)
> > > {
> > >         unsigned long pfn;
> > >         struct page *p;
> > >         gfp_t gpf;
> > >         int node;
> > >
> > >         if (cpu >=3D 0) {
> > >                 node =3D cpu_to_node(cpu);
> > >                 gfp =3D GFP_KERNEL;
> > >         } else {
> > >                 node =3D NUMA_NO_NODE;
> > >                 gfp =3D GFP_KERNEL_ACCOUNT
> > >         }
>=20
> FWIW, from the pov of someone who has zero familiarity with this code,
> passing @cpu only to make inferences about the GFP flags and numa
> nodes is confusing tbh.
>=20
> Would it be clearer to pass in the gfp flags and node id directly? I
> think it would make it clearer why we choose to account the allocation
> and/or specify a node in some cases but not others.

Hmm, yeah, passing GFP directly makes sense, if only to align with alloc_pa=
ge()
and not reinvent the wheel.  But forcing all callers to explicitly provide =
a node
ID is a net negative, i.e. having snp_safe_alloc_page() and snp_safe_alloc_=
page_node()
as originally suggested makes sense.

But snp_safe_alloc_page() should again flow alloc_pages() and pass numa_nod=
e_id(),
not NUMA_NO_NODE.

