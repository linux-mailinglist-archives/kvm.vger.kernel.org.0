Return-Path: <kvm+bounces-15715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A04F48AF70C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 21:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BF4B28BD7A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E084513FD6E;
	Tue, 23 Apr 2024 19:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYE99k93"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F5713E040
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 19:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713899328; cv=none; b=iDI6hzalU1bAbv3D3lXhPPnEAMLgy7kWtegxscOKxvM1rNPHbl8ns0BVHiyW5JpYdk2rfg8/pxGoqFXbB1y8RgZECXNRc3IGEYCp3m4ZuzNhUtsq4ySl2FkL9DDOrKfLSRvDwIZvK3K6ywDGoX3/h7sEqKNrWJP0YVQCP7DKyyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713899328; c=relaxed/simple;
	bh=xeMa76LY+gCCOP4Ssr7Doi1KHZ2a9dysntB2YEROpiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gzg/9lo+rjv9lDLm5343lgORRji7UpCsP4L3iplRVUG/4CDTwzrBgW+uVRo5y+UU0yLNlJLngmqd1di8pZGTP6AfywQfyMiRXD/aU3tigwl1YyWEwvwkNx2ep+LqV6e8+C6DMBnBofZl8dNm1OOSyX3ws3De39s/AGdNJ9Np5d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jYE99k93; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-34665dd7744so4557946f8f.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713899324; x=1714504124; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ah2mjQpyf1WcEtQ08zt7MoEFqqvsEEs8vAuVVQ9cRoY=;
        b=jYE99k93Qy0iyhKxcJbywiB6gcrE98AsNpMzRmSeT9QYuK61dTdsssiktYD06YvGZF
         2Cyw4RnOTm/YlSfhWvfkeILxV1B3jSz02PSMXYPShvTjY3TTn3DSVdRo4Yl9DcHiV7Re
         hHZefB2tA7+WrCLZoHN5JLqgI8gNaI9nUBAAwm691BBhxJ/ahflWrzaLAhGgap1CtYFM
         R4yyn7BvabZwqqfqfhduCiu+U7CRr3uL4FwrgjPUpabE0sCXNEGi+dEo0hjbnC7LXN0h
         IrCIDFbC/9fqM+sNm6SDHQSKOpPzO1XQ+Re7GkV1n0bOXrbbyAwb6e3h41nk/wfZUCBO
         5TGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713899324; x=1714504124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ah2mjQpyf1WcEtQ08zt7MoEFqqvsEEs8vAuVVQ9cRoY=;
        b=wDqplKwhnTVEw8FqG0guJ2zVe5I20H91FhjZr5Fh5UgyF7KRZXxFaFafIZzB0pQ98X
         PMopl2X5OoK0rgUTJREGig7A4EKEZ3B4kvYbKxIuucXrJSArQRI8ptXrlUavwp4MJmLB
         xEG1PQPVZSECh5F/DTz7zoZ40tXmy6ezofJbWeqJUsHTaQo5WFjicnirHXbuQ4fAJuce
         J/eTKGdNey3EBJWb3KQLpuf7CpAPF9yyU4S62H0XCGRFikXXpoRtXnVM9jXK8n2gkeAn
         Gt2NP5wOcRX+6T1XzRITZpxFQbTOd2o3zH+cNYIzkPA4YGqaNEAJfcDYq3dQFYiL9LS5
         U9/A==
X-Forwarded-Encrypted: i=1; AJvYcCVsdYa+LTuTrvQzzsuL1e+ZVcMsa0C+7W6q0Yq0MNz6qbWEexB5yIUIyqTt3G9QycK4jHl0f9kE3cLGcTfAKkCfspj3
X-Gm-Message-State: AOJu0Yzma7yR/q2DvrNRbNM/lO6pBkzoBwaqb5ZDL0o+Klnyba6g17Fa
	7qSrrKyZ0z8+crjQDMbt0csKyhRXKyCN1B6pgRX8ZEYq6TVHfEowNiwug71Yjl3klUkCLl6vrLF
	UyGZPZRwtQREUkBqzz8zHD0dHIU+KJzq1PALt
X-Google-Smtp-Source: AGHT+IEpHSQlkPW6l9s8NUlenK2IW18QcF+Gipf3zm1/Nm614KSc3LtHh3wZeGqgOpn7Zfpwl+6PIN5jecNthiiTVA0=
X-Received: by 2002:adf:efcf:0:b0:347:d21:6855 with SMTP id
 i15-20020adfefcf000000b003470d216855mr89821wrp.14.1713899324105; Tue, 23 Apr
 2024 12:08:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418030703.38628-1-lirongqing@baidu.com> <ZicA3732THkl-B1u@google.com>
 <CAMkAt6oP2CM+EtSNtCw7+V72UsPTHRZ04t7d21j0jQsj8wkW8w@mail.gmail.com>
 <CAJD7tkZzHQUOH3EiJ_Zn33dya+pumnohoKA7AnnVm4GE+WcOhg@mail.gmail.com>
 <ZigBYpHubg00BnAT@google.com> <CAJD7tkafCAP=qx2H=U2taxPL-5eqrVTqPuSUxQZKSPA-qAjyvg@mail.gmail.com>
 <ZigFQPCL7S_VtxFs@google.com>
In-Reply-To: <ZigFQPCL7S_VtxFs@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 23 Apr 2024 12:08:07 -0700
Message-ID: <CAJD7tkZJQLHN5vK_3LpUy-dFHtH3c4sJ3JHFwyfdVOUn=WJW3A@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Gonda <pgonda@google.com>, Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024 at 12:00=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Apr 23, 2024, Yosry Ahmed wrote:
> > On Tue, Apr 23, 2024 at 11:43=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > But snp_safe_alloc_page() should again flow alloc_pages() and pass nu=
ma_node_id(),
> > > not NUMA_NO_NODE.
> >
> > alloc_pages_node() will use numa_node_id() if you pass in NUMA_NO_NODE.
>
> The code uses numa_mem_id()
>
>         if (nid =3D=3D NUMA_NO_NODE)
>                 nid =3D numa_mem_id();
>
> which is presumably the exact same thing as numa_node_id() on x86.  But I=
 don't
> want to have to think that hard :-)

Uh yes, I missed numa_node_id() vs numa_mem_id(). Anyway, using
NUMA_NO_NODE with alloc_pages_node() is intended as an abstraction
such that you don't need to think about it :P

>
> In other words, all I'm saying is that if we want to mirror alloc_pages()=
 and
> alloc_pages_node(), then we should mirror them exactly.

It's different though, these functions are core MM APIs used by the
entire kernel. snp_safe_alloc_page() is just a helper here wrapping
those core MM APIs rather than mirroring them.

In this case snp_safe_alloc_page() would wrap
snp_safe_alloc_page_node() which would wrap alloc_pages_node(). So it
should use alloc_pages_node() as intended: pass in a node id or
NUMA_NO_NODE if you just want the closest node.

Just my 2c, not that it will make a difference in practice.

