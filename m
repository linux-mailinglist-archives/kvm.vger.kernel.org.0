Return-Path: <kvm+bounces-9098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8002885A898
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 17:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB08FB24391
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 16:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F7A3E47F;
	Mon, 19 Feb 2024 16:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C5cj25p+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7313D960
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708359496; cv=none; b=VgIqC9BHaVRGEq9+ABf1WlGZVma54fNELC9o9alGM6CuFz0BEyVexIh31hSavMfNAAnYxCSPTxjBflV37BR3O3JA8aPpExIraeMv8KyRlceid+SbmNH14sPQ6E8T8jFhrZfAgI6uMlXQvRIZzQ9FZW/1eotlUvrRvdhKc8wUGWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708359496; c=relaxed/simple;
	bh=DKi9ClYEI2bnAdqgXQhxDsS6OIw5QRI8XJDUvDaOSFw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OCqzwI+eMMPCQN4o2/mU8fqkUVrL6Wse/5QYhVYxNnKHJEGFJGCD/xOOBWWKrmeSTUolj1ezW43zPtgjbR2qtE3n9KTNghckB3WX+y/Ub65qBUSgL311NJ7rKbsBtjO+Pn1Pmq/qwE3mE+ydOhMbgM8DHBlEN0v6coPr5puV+Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C5cj25p+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-602dae507caso72194727b3.0
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 08:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708359494; x=1708964294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qxVgM4sFgvltRiBksmHu5Sv+NRJFlTzi90+ryT5Fkzk=;
        b=C5cj25p+vuXpbVTM2ftW/3LHvunPLMp4SvtJAq5TiGaWFY4d+fVYbAZLEg2dW+rF3g
         nGfA37wHdOmh2MYDKyh/OUkGlrmrKmQCDJSM08OufxNo42xLdY7bLzyNZZqPjVk4QTKX
         EjZKRl0+UP4GgXX2w+ihi2idqYmU5XxkKA2+zmkI2QfvfW01ebr7l4FlFGmJK1E7a8Aq
         2bod52ZM/X64fnj5NpBZdskkNrgDpW0ob0TwG4B8u4nuqQw++1cSx1UZYbonQp3JsvDb
         EPByTn9/7fsLqknsvvMQ47+TGdkkqngIGmV2RUdmfaZawey/uY4LwzihvVkhJO/Umd/4
         3wyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708359494; x=1708964294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qxVgM4sFgvltRiBksmHu5Sv+NRJFlTzi90+ryT5Fkzk=;
        b=XNoG4b0Xw7B2sshu2yJBwdOFnMPPeWFHg5bPlhg59PGBQL1Cvi6sEl91mQ/GVBq5Lw
         Yj6CNovVgkAunUkzuvRFttGdID7VrT+/xZke5Ti1gWxNekoi7X+dS4v9ZSbX7kk+he4h
         3fK9iFlk1iD+luH6nyvpJPP3F1IWYK4GCvOFOuogAnTQNCbQ9f8rx5/p3eYB8bcDu+gX
         nFc4w56g30jHuy9S9o18A0Wk5z22Ewe3sxx1Tt2RSZ87k10PPjvjzGC4vzJ9W4RwkTtd
         Wg5Ft/ZI4Tm3tvxGMF6dR7lexX5UoagvIZWXuXy+I2xPQ56I1NZDnNcb1W+sWQecPRyu
         NCFA==
X-Forwarded-Encrypted: i=1; AJvYcCVQO2Eb2n0QwHTe98YHwS+anSvjmxzIRapxBsM8Zt57Wt4Kn6bHh6gXmh6hQJK2NZbCLFj5Jy/uKZjHdcXWOObXf6hU
X-Gm-Message-State: AOJu0Yw7ZX1g6dEPoYxIHcGX/KvTICztozZmsMWA3eFcXpbdrzEggu/h
	htbFdhBHqdEIUeH+wslR3YpkmEvP1VP3m6lEN9JYmlyWOFQqSd8NHE8+hZv07bH6BaCy43Hvg7V
	Wkw==
X-Google-Smtp-Source: AGHT+IHPO+KAFMFbQFRd+7ASVQ43PJ+mYJJ1avOdvFckaE7fEErIBRHV5mqyYUo8l3V2m9JAyHSm0+2KWrU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e611:0:b0:607:9268:6665 with SMTP id
 p17-20020a0de611000000b0060792686665mr3175499ywe.10.1708359493839; Mon, 19
 Feb 2024 08:18:13 -0800 (PST)
Date: Mon, 19 Feb 2024 08:18:12 -0800
In-Reply-To: <ZdDGooxx/a+sAzmq@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222858.396696-1-seanjc@google.com> <20240209222858.396696-2-seanjc@google.com>
 <ZdDGooxx/a+sAzmq@yilunxu-OptiPlex-7050>
Message-ID: <ZdN_RM2awyNyKiZu@google.com>
Subject: Re: [PATCH v4 1/4] KVM: x86/mmu: Retry fault before acquiring
 mmu_lock if mapping is changing
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Friedrich Weber <f.weber@proxmox.com>, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 17, 2024, Xu Yilun wrote:
> >  static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >  			   unsigned int access)
> >  {
> > +	struct kvm_memory_slot *slot = fault->slot;
> >  	int ret;
> >  
> >  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> >  	smp_rmb();
> >  
> > +	/*
> > +	 * Check for a relevant mmu_notifier invalidation event before getting
> > +	 * the pfn from the primary MMU, and before acquiring mmu_lock.
> > +	 *
> > +	 * For mmu_lock, if there is an in-progress invalidation and the kernel
> > +	 * allows preemption, the invalidation task may drop mmu_lock and yield
> > +	 * in response to mmu_lock being contended, which is *very* counter-
> > +	 * productive as this vCPU can't actually make forward progress until
> > +	 * the invalidation completes.
> > +	 *
> > +	 * Retrying now can also avoid unnessary lock contention in the primary
> > +	 * MMU, as the primary MMU doesn't necessarily hold a single lock for
> > +	 * the duration of the invalidation, i.e. faulting in a conflicting pfn
> > +	 * can cause the invalidation to take longer by holding locks that are
> > +	 * needed to complete the invalidation.
> > +	 *
> > +	 * Do the pre-check even for non-preemtible kernels, i.e. even if KVM
> > +	 * will never yield mmu_lock in response to contention, as this vCPU is
> > +	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
> > +	 * to detect retry guarantees the worst case latency for the vCPU.
> > +	 */
> > +	if (!slot &&
> 
> typo?   if (slot &&

Ugh, and bad testing on my end.

