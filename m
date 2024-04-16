Return-Path: <kvm+bounces-14798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB1C8A71B4
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A61F2875BF
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B244312E1E8;
	Tue, 16 Apr 2024 16:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iSEUMcTx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963351F956
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713286341; cv=none; b=Mpi6L69b6hvsrTq4VNdDLJ5ZH0mE0ecgcx8bd6AaHX6aqfdHXYA1sH+ZdZE76J2Z7Y1/a7GPorl6slIdmodip+f0oARjUh2REswkrO7avmnR1BkZAXX8Em98sr3MBhnHp6WpWQyx8wwRghJjrhXhz785so8ZTM2EjYU0/Qs9Nis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713286341; c=relaxed/simple;
	bh=UDqgmtiCw61GSFK4OkUay/aYwj2pnAg59HNOcubz8Ok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rsvy/oY1ykEK2PNJk6BniQfeliAh6Ig6Bg3WrQgr7iJl/UYZw+AmGvR/1yE/Ncqu7fVlWtWRJDGzUP+W1Hh4jc2K+EyFpeFXCM5Wm4If6egoMEmCKN4iJvtE/P+EPhn6o/LtCjQCGv8ni0u/bbG3yenUyF2spDcNdtmbq36ubkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iSEUMcTx; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61ab173fe00so50228977b3.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713286339; x=1713891139; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Je6c/wf9ELFjP+YNaGaAoQfY5Vex5LNYYIMKI4Vr5eU=;
        b=iSEUMcTx3xOiKovgDIivBLVM6M7VqY9Ubi0ZVfeLpth5p0eEwmWinwF3pkK503C6bB
         z2aT7T4qA4xcFCuicNr+4tcMRRWXJWO8ev5PjpZKMnCvpQrIr8WAPrMYTu5RH1EYSOiQ
         svzCW3E9eXoBRvZy7/AEvsN0GBm2GLPNwk9P9nAkErhN6psXC88r1rM6rEBYgx7khu/v
         pPA+gZ1KdRnBV+HLk9DqxwPDdb2iDYG6kiFRBerikiLFpMzFEuNdvU2nOIi2XAXH/ctr
         7kgUfw8U44+yKI9rEP+CPPI9cpuMV8/Tvi0woXwZiF2qF8YtcfSuUhnCru+MbE4R625o
         1R+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713286339; x=1713891139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Je6c/wf9ELFjP+YNaGaAoQfY5Vex5LNYYIMKI4Vr5eU=;
        b=RTbm48PAEPrA5kYqE+LLrfbOX+9mvhmt6jEhnYcKu1nLYNedVuDSoLTeiu4sSGci5c
         ejtyxfU4H4JlP/GJg8gVrD+NNgeBIa+U/ss8O0ZIrklwd62l5UZGtALjqGgUjkzCGaYC
         epT3fJB/3vcVo2+nOfGplcYLClzwGhjSOGutlKavuhfQ5EKH5SCm032KcDHNtVzohzmb
         oE/L4JOPl680hFTyBQjQbqNeVOFOYkd78PF0GBZic6/SVjV0dfwuOYSsJdabZlgz6Is8
         Yz60slqwWGG1bnpRnwqj73jre5KESZYdvnBVJxHeYIAL3lrNECpOsgj96UrhEUZamyZ4
         DAHA==
X-Forwarded-Encrypted: i=1; AJvYcCXK6mvgV8hSZlB7iFoXmCVv/RLbRDGdOwp7Y79tVA0VRahufHPOgUSEN4z8nzN7f4DsW3zZ08E6PzdgZqDrDkAJhtH8
X-Gm-Message-State: AOJu0YwEWB9nRTl94NOxKyP6lPj9r+rmnyqFPmbvsjTrYOojvy5qs6/u
	ZF/8FQLW6CD0W8M9vv1LaGJcHWt50kTLlYPf99lT6iV8kM7mTCvWJsF5zYl+zvyGoCNwFJr0taR
	wsA==
X-Google-Smtp-Source: AGHT+IHKhIwJradbjwMqe7+BH2hYVk5Z55iYNunoWgnfp/KSDtaofestsEZA+cJytxBXsVHpNqQfBKywHh8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:848b:0:b0:617:d650:11e2 with SMTP id
 u133-20020a81848b000000b00617d65011e2mr3844316ywf.3.1713286339647; Tue, 16
 Apr 2024 09:52:19 -0700 (PDT)
Date: Tue, 16 Apr 2024 09:52:18 -0700
In-Reply-To: <CAF7b7mqHWFnZbN5CHvggYYOZepcu9sVzUgNFwi89bLNxgnP_WQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
 <20240221195125.102479-2-shivam.kumar1@nutanix.com> <CAF7b7mqHWFnZbN5CHvggYYOZepcu9sVzUgNFwi89bLNxgnP_WQ@mail.gmail.com>
Message-ID: <Zh6swsLAnAE58hQj@google.com>
Subject: Re: [PATCH v10 1/3] KVM: Implement dirty quota-based throttling of vcpus
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Shivam Kumar <shivam.kumar1@nutanix.com>, maz@kernel.org, pbonzini@redhat.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, aravind.retnakaran@nutanix.com, 
	carl.waldspurger@nutanix.com, david.vrabel@nutanix.com, david@redhat.com, 
	will@kernel.org, kvm@vger.kernel.org, 
	Shaju Abraham <shaju.abraham@nutanix.com>, Manish Mishra <manish.mishra@nutanix.com>, 
	Anurag Madnawat <anurag.madnawat@nutanix.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 21, 2024, Anish Moorthy wrote:
> > @@ -3656,6 +3669,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
> >         struct kvm_memory_slot *memslot;
> >
> >         memslot = gfn_to_memslot(kvm, gfn);
> > +       update_dirty_quota(kvm, PAGE_SIZE);
> >         mark_page_dirty_in_slot(kvm, memslot, gfn);
> >  }
> 
> Is mark_page_dirty() allowed to be used outside of a vCPU context?

It's allowed, but only because we don't have a better option, i.e. it's more
tolerated than allowed. :-)

> The lack of a vcpu* makes me think it is- I assume we don't want to charge
> vCPUs for accesses they're not making.
> 
> Unfortunately we do seem to use it *in* vCPU contexts (see
> kvm_update_stolen_time() on arm64?), although not on x86 AFAICT.

Use what?  mark_page_dirty_in_slot()?  x86 _only_ uses it from vCPU context.

