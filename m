Return-Path: <kvm+bounces-14032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA8489E5BA
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:47:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A294FB21D67
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 22:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40560158A2B;
	Tue,  9 Apr 2024 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ky+MfR7d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC88615531E
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 22:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702827; cv=none; b=cz3YEHGdIauKgflxqPLYzuFqoY3DUdGMgAc6vTER5nMLxD8b5mJXuxyquI9rZ8/A1+7MbJFQpMIWBRi1wBrjDt+WKTyoMK5cI+jme0chntXQy6oaM0S9ru3XNdHNoxrbg6BFzvwrGiBJax0ZNK55EBvDKYS8MaJW2e0MuY8VYJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702827; c=relaxed/simple;
	bh=k51+5LsDbq2hvGlxfuH5BGJttTm71LkxCDDWSrA2sOY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ePdtoiFbJWV11vSAg93wEaUA+6Q6sCkEmd5Kz/mPyXk+TTxuoyeQvMOmfnYRi4M0IrmvPnVuhAyqdVAnuFvZTbgXSTQFTN09jARqGhbquqK5Z8BFd10pxZMRxeJnIsCRsCkmSMrFhFcMInL2bPBPNe+P12GaykztMynjNCSsh2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ky+MfR7d; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a2386e932so117493107b3.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 15:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712702825; x=1713307625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AlR3wd32J7CM7haAcioPhyocAIlp+PLTQ5N+UsXAt0M=;
        b=ky+MfR7d/yfZw+1X7ChJX2rI2ITfu6I/gAlZEft2kq6vaab5cZpD+eJheau/TX9puG
         e3YD+nRXPeyi/4tNlUbOXLcXaicIML6BKGGwH9X2hruOoTC9gieDbciZw2HsR67QGcxF
         ZaWJR1kTQ78srmqbMDaXxuYpecAbygIv64bmf60rfmtg64IF+3C7vNk6deXoLTvUDJAo
         jiPJSa9B2O6ZYG4EE39QWKZglYSM3WDkyN+FFQMGpBLibjPJI3ST+UAbBP77l7I13Zeq
         fIRgaHfz9ZNFCkOAjtySqaItsnUsJRzHWr0CJgYkA7QzMHr5arKW2HYAKzgGhCSQRr2b
         63UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712702825; x=1713307625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AlR3wd32J7CM7haAcioPhyocAIlp+PLTQ5N+UsXAt0M=;
        b=ZvSDmBCf/88XPDKYegTFg1npJr6qh7lIb6J/TLJ6MCFbB2NMVcJL74cdDmhXtkzNgZ
         lkkRVWyoVVIUHJiuxJxrNTQN1T+LGDkY1wltRGIfWpNZu4Rnnz5fFAtiePDOaooK2QhE
         W6AGf6/8MAIb/zctfLBP6kDm7EEwr1ffXS1b1SWEUka+Wib/GqJ9ucZYbP3PdS1PfOsh
         XLn5xjokaFtWJqS6/mZCAs8eK3L2YnnlB1aCYiF5VjefeKv3x7Hnwgtic123MczUdpro
         0dup+swHd2DPQGCyNRiUj3UGjmZQShY6lHBstZjMedpxgKvo2hOzeZ6Kum/QhH+gp4TH
         /g2A==
X-Forwarded-Encrypted: i=1; AJvYcCXYXPbA5UBP+IStiY9tBgR5T28k4WLPqcxNOdV8F4jwoLVtW+WJQWpl1nR6FCYWf165pTkjVPW4odYA/Muj1iGXoZ6X
X-Gm-Message-State: AOJu0YxGrjHYXOjB//y7CT6k4PFd0wHYxwm5kdkwDv0tf9I2sPlaVi9N
	WF83JHNc1bmytGQF06886mLaxmhA9kNJI45Ky/t1amgTbepMTjuRNVcO7XK2LBAXN05f2nEQQf3
	EoA==
X-Google-Smtp-Source: AGHT+IFLTy5GkVD0E7U+RH9kzxgpp0i5nxbXyjxmK+s0+O6klcL95tqJryS7wnm2k8slKkIjiYxCm6loI+Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:680a:b0:618:28ee:ea3b with SMTP id
 id10-20020a05690c680a00b0061828eeea3bmr270722ywb.7.1712702825115; Tue, 09 Apr
 2024 15:47:05 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:47:03 -0700
In-Reply-To: <20240215235405.368539-4-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-4-amoorthy@google.com>
Message-ID: <ZhXFZ1CLJazF9_k_@google.com>
Subject: Re: [PATCH v7 03/14] KVM: Documentation: Make note of the
 KVM_MEM_GUEST_MEMFD memslot flag
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
>  This ioctl allows the user to create, modify or delete a guest physical
>  memory slot.  Bits 0-15 of "slot" specify the slot id and this value
> @@ -1382,12 +1383,16 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>  be identical.  This allows large pages in the guest to be backed by large
>  pages in the host.
>  
> -The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
> -KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
> +The flags field supports three flags
> +
> +1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
>  writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to

This formatting is funky.  I suspect you are trying to avoid touching lines that
otherwise wouldn't be modified, but the end result is hard to read.  I would also
opportunistically clean up the wording in general, e.g.

1. KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of writes
   to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl for details.

> -use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
> +use it.
> +2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
>  to make a new slot read-only.  In this case, writes to this memory will be
>  posted to userspace as KVM_EXIT_MMIO exits.
> +3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This flag is
> +incompatible with KVM_SET_USER_MEMORY_REGION.

This is now stale, as KVM_MEM_GUEST_MEMFD is also incompatible with READONLY.

