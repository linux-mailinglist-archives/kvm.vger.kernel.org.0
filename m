Return-Path: <kvm+bounces-24989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4C0595DA13
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 02:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C3481F21517
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FEF4AEF4;
	Sat, 24 Aug 2024 00:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GBF1P9Eu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FBA5CB8
	for <kvm@vger.kernel.org>; Sat, 24 Aug 2024 00:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457626; cv=none; b=gtesXcds1peYSJFEajmjbrHlOJL1EBRJmCwJq9CJ2MaJx2UJU8TnFnyWq1Z/up0AEnVs+AZHDBs8vBcNYJtIK8aaLvP23R+ZD8TYpxQFnFUhYxIisM3wTRpFMRupzrqLpx0vkzgS5MCyRCzZp2H8Tch2noKT1kNn/Vi5MC6q1/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457626; c=relaxed/simple;
	bh=CBlzlCej0jlDEn2XXcD3WNh08kLlrh+iXs5vQ8oBStk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=toyVjSGL+DHF2qqrmqa4RoUpWmjHitzxiIXGW6TYLKfCU/Z4rVTkJhv8yXHpK8Dzp2YlQBD/dLcPWwk5BB44x81VKA3PCMHqwUiRYHUHs6Y1hCHzatRxbOiUTPIHJBpmtRwSStX11Ctlc8sqrHtaDZNsqIDk/axxr+WKMDGVooE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GBF1P9Eu; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7143e0e4cdbso1913293b3a.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 17:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457625; x=1725062425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ca0bECA5aRr3r9kHtnZQuHEvw2Ot4ILpPTiRBu+Z1Q=;
        b=GBF1P9EuTOpyWDE5cKqORrvUUgQFQGil7uLVcn0oPl422K3TofMXc8BM2+gjUIRm+l
         AeFxXAX7Cqyv0CWQsXnbBgS0b2moFxK07WTW2yj4Kh+ho4AEvRPQg6DIZ8D2z7qtC2u6
         8Xwo+w9WVYQahXCpew/Zxj4YO8lNj9c6Gvvy46EzarSItCD34LHP++2QYRXfW3aRY1b5
         bZTHIVB9+lGo1rZyTMfdjNBQksgUAnTy0EVV2X30AcMjXJWjrHo/oxG5FZO0jvbb39mS
         bfJCxuHZ2eGraKGbopvfCsemq7ZcgpkR2VK07QjOCNTt58nEyZhIQhwbZ75BcXbn26h/
         e0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457625; x=1725062425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ca0bECA5aRr3r9kHtnZQuHEvw2Ot4ILpPTiRBu+Z1Q=;
        b=uRlon1vxTGAMS1uIwYaittlFVqODzhwXtVf8yHZbnEIfhOC43zChG96k1vYN2EHXAK
         6h+TSTaD8DEBt8tls3GibTe+8rjNgauSaquGk6NGORn+A88by4ESwhF/iedTqegVsY/7
         dGCUQ3wxuFef3bhhrXuq4gAb8mpt67EqnEkvBl4KbXS6xiBkEdRuQ2q21qTAYTfxwc4k
         kWCn2D4JE7CU/Ubwdiv7wPJJx8BbtX5Rj12ihZ3WmaQj5RuB9H7Zd6rU1iVMLcZSZs2W
         +hb+RGCD41vqk/fbZTvrSksyVeYdHTVg+z4YH92l+nHGKFreC0GpNBmBTjcFeNmRu9nG
         as+g==
X-Forwarded-Encrypted: i=1; AJvYcCXr8DjxSdcG2DXZ+YxPUM3nDIxHbnH0ys9A38ox1e973szZ+9gOQ33ze31M6eIA/pRETEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO9aW/6L37KuM6avgcMhvEX2B13Tcn+JtiT3lNmmCeSAL4lNqm
	80a3H+jo8rztPbUmGrpDzPHWok6uK1ITuVD/YvTUVZOTGntF2InxgD+HO6CNZ1vTXUfIgDeJw1T
	mAA==
X-Google-Smtp-Source: AGHT+IFjH1L+yx6ePew+AVPSI6ETQhn78QMIuKkHsHXFR08QFYT6Z4rKQmWThVz1lyeaqhvB+H2v7V4R2l4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8b93:b0:714:37ed:dcb3 with SMTP id
 d2e1a72fcca58-714458baf14mr14478b3a.4.1724457624368; Fri, 23 Aug 2024
 17:00:24 -0700 (PDT)
Date: Fri, 23 Aug 2024 17:00:23 -0700
In-Reply-To: <b3c27ca7-a409-4df5-bb55-3c3314347d7d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240821112737.3649937-1-liuyongqiang13@huawei.com> <b3c27ca7-a409-4df5-bb55-3c3314347d7d@intel.com>
Message-ID: <Zskil6dbwJmL93cO@google.com>
Subject: Re: [PATCH -next] KVM: SVM: Remove unnecessary GFP_KERNEL_ACCOUNT in svm_set_nested_state()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangxiaoxu5@huawei.com, hpa@zytor.com, 
	x86@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de, mingo@redhat.com, 
	tglx@linutronix.de, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 23, 2024, Kai Huang wrote:
> 
> 
> On 21/08/2024 11:27 pm, Yongqiang Liu wrote:
> > The fixed size temporary variables vmcb_control_area and vmcb_save_area
> > allocated in svm_set_nested_state() are released when the function exits.
> > Meanwhile, svm_set_nested_state() also have vcpu mutex held to avoid
> > massive concurrency allocation, so we don't need to set GFP_KERNEL_ACCOUNT.
> 
> Hi Sean/Paolo,
> 
> Seems more patches are popping up regarding to whether to use _ACCOUNT for
> temporary memory allocation.  Could we have a definitive guide on this?

If the allocations are temporary, e.g. scoped to exactly one function, not massive
(use best judgment), and can't be used in any kind of novel DDoS attack, e.g. are
limited to one per vCPU or so, then they don't need to be accounted.

At least, that's my take on things.

