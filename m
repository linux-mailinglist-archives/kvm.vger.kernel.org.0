Return-Path: <kvm+bounces-18910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 099FF8FCFAA
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:41:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18AD21C23FA7
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533681957E2;
	Wed,  5 Jun 2024 13:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I1aMR/j9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5F188CA6
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717593562; cv=none; b=Cbg20+AQNvJidSvY2rn5octtS5H94UE3nHeeoHKPf+HqfFyFRaiOXHRMLb0ASxELtalaS67L+hrqBMUEhHYcotdCKVDkjZ95qBHdPRyRTYL3KD/0di0ODEhXxwyPuECY8b1q3lt2X24zquQYMbrnrdc083knw482BAwmkskONJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717593562; c=relaxed/simple;
	bh=y9/QOHB+OaaOhsMwXfVFQo7+qGRhsj9WB+GH6jiFISk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lgTYFcZrVqRHkWY4BuvGA8Cw0kA/nO/PRH93BlwxLZdmgAPakCcoyPZhsnWK6Yvtawc2W747jrajS026yLbWlo/DKeS04jy0mk/Y9gIq+e72ASJPtaciYAvhYdhE2Xv0+RHlBuWfeQ9l5//f1eTYMvsmruxsd2ySnGPssEOoyqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I1aMR/j9; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6507e2f0615so6216347a12.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 06:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717593560; x=1718198360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5UxNe00Gi3mRuI7htrwGVG6gVNTMWaAw2HM6Hp0r4nw=;
        b=I1aMR/j9Yc+DbUNKX2duBzMHxVFfjKLRxQonjj3PLHHJoIiYuPX8+JKj1EoFohaZml
         UQZIUIoyV/ndJSg6fo7n3y8kwP6KjTrCRsmN/hMuL03HSJX0f1Pew+ac4MJ7+7mTkHAQ
         WlnWaQ+dbU7EyUxaeEHgJJ9k3VTBhg0jZxn4OpQxiWB6veqFNlD738K6X+MRVJlbZ3Zy
         4JxrvjKhhJxooOUXm9WNqxfUld52jJ5e1rnSTPo2bPnm+1uPDC/qGtiSvXNakyaKAhJv
         DdY2L3NaaYzdD63c1ve2FEYb4rf3PAKj68yH01kU7D8oB2iAsrjqk+LctLbcHxY5Qls0
         DTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717593560; x=1718198360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5UxNe00Gi3mRuI7htrwGVG6gVNTMWaAw2HM6Hp0r4nw=;
        b=vU8G32Sq/2WMBvOXywJyR3Nw6r5WJeCAoX69S0Wo4CNuhjHlp1G7tInqr+qEA1Xaet
         PYEQI+9WN1cXXNyf/4CI5gFr7pb8jO3jpeG26hdt4A4dreV3JTKB/8LCFzSwMgxkDYjp
         6g5T7/FPBeveFRoLnUrITVmsSlDYS1Cdi2aR6GxAQU8IWRrTzWa65uEt74chKxRNhPJh
         PuU4JDUUC2z4HdQstjK6dT/ZHI58fS/5Rj5Q+ACqfjzMC6XJ9MXJ7STuVjXZll8X4KDa
         yKF7fZoEzlHrCeK7+aO65HmIX8WxNzLWluKhmFW+xGWyaUUeFEPpRGaGo1HE07sxtoaC
         T3BA==
X-Gm-Message-State: AOJu0YxG551mHd+fOOovwn9jEcJTtUrz11RUEkDLMVQizsN7RJPuFCXV
	cayedUmS9beydBrhLJRVc/sbVDOPeTaiTDYdE4qDSCuYYyqovpcNg0/tHTXWpM3VmVvgFR+YwV0
	TnA==
X-Google-Smtp-Source: AGHT+IFZustBephWoxDo9N5lZLas5M7BX3g3jskMVUK8/Mduc80YFNFvfadg8BB2gjaGv7MN0emz4L8RTUw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:452:b0:659:fa27:f2a7 with SMTP id
 41be03b00d2f7-6d952ec43ebmr6423a12.11.1717593560219; Wed, 05 Jun 2024
 06:19:20 -0700 (PDT)
Date: Wed, 5 Jun 2024 06:19:18 -0700
In-Reply-To: <7889d02e-95a5-4928-abed-05809506c980@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240528102234.2162763-1-tao1.su@linux.intel.com>
 <171754258320.2776676.10165791416363097042.b4-ty@google.com> <7889d02e-95a5-4928-abed-05809506c980@redhat.com>
Message-ID: <ZmBlxCTDv0hO0I--@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't save mmu_invalidate_seq after
 checking private attr
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Tao Su <tao1.su@linux.intel.com>, chao.gao@intel.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 05, 2024, Paolo Bonzini wrote:
> On 6/5/24 01:29, Sean Christopherson wrote:
> > On Tue, 28 May 2024 18:22:34 +0800, Tao Su wrote:
> > > Drop the second snapshot of mmu_invalidate_seq in kvm_faultin_pfn().
> > > Before checking the mismatch of private vs. shared, mmu_invalidate_seq is
> > > saved to fault->mmu_seq, which can be used to detect an invalidation
> > > related to the gfn occurred, i.e. KVM will not install a mapping in page
> > > table if fault->mmu_seq != mmu_invalidate_seq.
> > > 
> > > Currently there is a second snapshot of mmu_invalidate_seq, which may not
> > > be same as the first snapshot in kvm_faultin_pfn(), i.e. the gfn attribute
> > > may be changed between the two snapshots, but the gfn may be mapped in
> > > page table without hindrance. Therefore, drop the second snapshot as it
> > > has no obvious benefits.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 fixes, thanks!
> > 
> > [1/1] KVM: x86/mmu: Don't save mmu_invalidate_seq after checking private attr
> >        https://github.com/kvm-x86/linux/commit/f66e50ed09b3
> 
> Since I'm already sending a much larger pull request for -rc3, I guess you
> don't mind if I also queue this one. :)

Not at all, dropped from kvm-x86.

