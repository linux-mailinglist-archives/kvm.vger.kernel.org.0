Return-Path: <kvm+bounces-9561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5BCC861B04
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 19:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF0291C253DA
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B8E142648;
	Fri, 23 Feb 2024 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NbBu/fE9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E12C13BAEA
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708711205; cv=none; b=DcLuqPMGitDRWo0HRKn4SUZBBgyU+5qRA+n6fFGpDSgO48DkxRXiLi/bZ2OqhskkdUoU/76PQG8dsgmW+ulyJhaN+AfaNW/R7ZNkC0xpUBeUgrdoRuss7ZSQUbeaz6UzjaaW/qaCBfzNVXAZOD/f2SBDq/lIarJySbqsrAd/xTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708711205; c=relaxed/simple;
	bh=JTIBShtgIr5g6rY0xtefZuQDFwfDgZS/8epM2acW8kM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W9vu6UipD9sasHWzd34yoERsy+NFk3drA0Rz4Pala34wbY9gRbJjaTr/jn9CCtOQqsTVLNqj1iJ0tYp92ibjrq+BzztIyAUjcFKmhP2yUlLq1mZZiOD6V61KnBJpt3ZpX75LSldUzyIEDqU89njBh7Rb+96TyXc+ehtnMcmj/EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NbBu/fE9; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcf22e5b70bso2003381276.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708711203; x=1709316003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZlW1EJxs94ddQvEpIRIB6nMElLk51bT9baoyhTLzcw=;
        b=NbBu/fE93yYh+mw+PMuD6GgYGcQwX7O2eUKwIZk/z1BLcmq0Ugaf/Nx0Aubhw6YDex
         Us/lKerEpmIiFERqAqJ6tSlwuSD8Ct+Ohanp8mUvwPQnW25qR5pkC9heOnnvozhz4T1d
         KMQmKDQeWG+Sd+c+KPI0Mal8IHOuO29dPOdW+3jUXRLAr3vfn0s3FpJAAXy0qSGkFCC6
         1yu7s9oNWGA3YVPKOnAepQQtkmmd/CijtSZ3MZfsGw5kiSMrqB55Y3v07Tgr/QlYXgKn
         bDl4Ng7IihZQWVdJbCzw9T5x1Ir5vcnCXhAnsJIWgi/nyVYG6kX4OXz7nbRoUb4Zu7np
         Zfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708711203; x=1709316003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZlW1EJxs94ddQvEpIRIB6nMElLk51bT9baoyhTLzcw=;
        b=I2cQE4Q6RUdc8+SmDhG0RF3NCw11T2Uu6ZXKRJMecKkDrEfJEVvIn3EejYbg28BwW6
         upYCL9d2UO0Sk7WIJiMgzXDPiNSc2AwKC1V+lRfRLvUK/Wyn1fEiYS1SwXsE89WpgXOl
         fyPiqrPNmYUNRYDh41rg/A1gXw3eDaxybKPJnM1zxfEjgogKWZDq8cguKMt+46Zfo/6R
         cs3/exn+OJ69DgXxWABmsUtYAi4ROEUbXq0I3z+5/RyftfLsbl/7O1G3A+U2BucP5bYz
         Slsw6e2YPk2pPxh/84PK3BX6cwYLwI3BrI/SY7Ry8ppVojaL2/s/ocyxNVda0G12b1ZN
         tUXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW25uYkwOa6dXHNyMcLoV78D0TtcqmISBiGl60oa+vm8MCwZpYxwwcjnKCwPv2FWg9sTfpRd21qj462WAAbgZEgy1mS
X-Gm-Message-State: AOJu0YyueYE0xHAS6rgmIkOkkBFK0pa9uz6VxLbfjVznC4qfKbuWTITf
	gsqlzprAok9XVMO8eWAP06nL7rvh9qPH25M+QF3eJDClNiqeId77/2nl0/qI4fjBZsHXgiWwors
	KKQ==
X-Google-Smtp-Source: AGHT+IFddBZPJ0oMQJFmcgncflFQLIynO52TmQ0RXS5kF1rPgpXbVxpnqSicc8D4/kWxpa1H1Uj3I4Yk7aw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c2:b0:dcc:9f24:692b with SMTP id
 w2-20020a05690210c200b00dcc9f24692bmr24709ybu.13.1708711203125; Fri, 23 Feb
 2024 10:00:03 -0800 (PST)
Date: Fri, 23 Feb 2024 10:00:01 -0800
In-Reply-To: <5580a562-b6ac-448d-a8fe-cedc32d33bab@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240221072528.2702048-1-stevensd@google.com> <20240221072528.2702048-5-stevensd@google.com>
 <5580a562-b6ac-448d-a8fe-cedc32d33bab@redhat.com>
Message-ID: <ZdjdIYNEA7k2Fmnu@google.com>
Subject: Re: [PATCH v10 4/8] KVM: mmu: Improve handling of non-refcounted pfns
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> On 2/21/24 08:25, David Stevens wrote:
> > +	} else if (!kfp->refcounted_page &&
> > +		   !kfp->guarded_by_mmu_notifier &&
> > +		   !allow_unsafe_mappings) {
> > +		r = -EFAULT;
> 
> Why is allow_unsafe_mappings desirable at all?

It's for use cases where memory is hidden from the kernel and managed by userspace,
e.g. where AWS uses /dev/mem (I think) to map guest memory.  From a kernel
perspective, that is unsafe because KVM won't do the right thing if userspace
unmaps memory while it is exposed to L2 via a pfn in vmcs02.

I suggested allow_unsafe_mappings as a way to make upstream KVM safe by default,
without completely breaking support for AWS and friends.

