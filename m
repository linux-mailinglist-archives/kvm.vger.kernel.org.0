Return-Path: <kvm+bounces-37753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84462A2FCF5
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 23:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE3721884CDC
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4ED2505CC;
	Mon, 10 Feb 2025 22:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4c/Gi0Pz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BEE2505B1
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739226222; cv=none; b=oaAK3ZpClHS3/h2NqIKXKPXNTSw0HQkKWmVtq0IBLvP0vc9mZPKyuBbiE3y61/MLfhSSLBDAYdqvCkjNWf8ghU8fh5QolcKgDtHZZDuDmCj17kPwp3cFnl7djJ7Y7TuUxdvun6A+H6YAKyPPfCC/wpjNXVUk7fZbbdLU17okLYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739226222; c=relaxed/simple;
	bh=hF8Vf4v4gr1R+Shd48LsTyb/BYZwoN0AaP4YvUCD6FU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N6sG52zNh6u1vEAAGLsVPBiQ3ANHK0dVQ/NdCaxADf4ydaQTI78aUlLAk5VzDsDbxTdUsTHVpDH7Di9FBso5GT0Ccps0rNpPIrol01rysv5UqkwGjWcbkAvQCmHk12FAETjp7Bxan+qRtNISmap+LWl+XK2OrhWpnFpHgqdqnSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4c/Gi0Pz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa1e63a5ffso13542233a91.3
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 14:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739226220; x=1739831020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pUXvYzG8eRKf2w27XFFoCbVFPZhMAFQZ2tlWsem28oM=;
        b=4c/Gi0PzVH8a9EgDCiqitnq8V4knhIxPHxi0eLI/uVXtuqLMYY8ZaWLXZS8g0KxtHU
         oph7inMFINU2v/IINGVFmiGkV5PmUM6jOcFmseBRlmyPaqJBc08XKeujNLWafnPUQd79
         WLzG7Ngq54f052sQi1i+GmMuIVLo5AcOv5deboj/oR9Zdf+dePcOooHebU8WK6oLCnGp
         Vl8F90a/KJut6ytynnRpTUH2y5m5N2emPwVkZM+aeWyqV3+R6iBrOuDLKtVsj25H1SGc
         3/DeVNbAKaQzco+1MFWXaWmXZU9/dKT57o4nMMrpXHBx9i33yj70bmA38VkDigPAgC/7
         +h4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739226220; x=1739831020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pUXvYzG8eRKf2w27XFFoCbVFPZhMAFQZ2tlWsem28oM=;
        b=R8Z936wKQ8vCkYlBky6+6AR8dJPh2v5NNYkTIGzFTPBUGlRkxvS78LMWWwcffAn9ZS
         s3r31Dc2qz+VNZOHqRVQJB9pTsRyodeZiTUAzN/ghfjmhQoIiDozEpBVwjYvFo1sUenl
         egw5tSSI4kIAldfum/Pujs6raiH/QbSnlSrVlgT5Ja8SmtJKBkGp1KzAEdWNAn6Nzqxq
         hUGUtX35Yf9LApT/OuffBImS/Y+PdG7Togp+crVVr9aU4VHq0xTKawJvxQFSmGmffcAj
         u/yjhcFwSRnnc9WD8N4Ts0oTubK+NFA6aSxpA9speF+ZJOnrbINkYTQnMwzHFhEkgzk8
         sRUA==
X-Forwarded-Encrypted: i=1; AJvYcCWBl+M4T9/yUZDo8JcGnpQNSsHKI92RrWRkIx1pycBizCPlP4JNVVef41PS7mD34w5iKM4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2H2Mb5OnL5KwENs+dxejePK5hVzm1JRwigrq5vsEi9uw5wFeu
	m01QhG8mkAyIwwcvaY/UCLjYHLMd2/p9ho15ISMDfcd3q5WSCvzt7PsBrAZaznFFe/uTe8ZPZMP
	kdg==
X-Google-Smtp-Source: AGHT+IEy3+bVFo6JcMsoWvq+cYL38XbyKOeuF/tQSdUVXK2R0Wk67Xr5wVNUmJlCk3rS7iPBAN0yLqQOGnk=
X-Received: from pfmu14.prod.google.com ([2002:aa7:838e:0:b0:730:9617:a4c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3989:b0:730:f1b7:9bb2
 with SMTP id d2e1a72fcca58-730f1b79cfdmr3734751b3a.13.1739226220172; Mon, 10
 Feb 2025 14:23:40 -0800 (PST)
Date: Mon, 10 Feb 2025 14:23:38 -0800
In-Reply-To: <Z6bDZWzePT6CAreU@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207030640.1585-1-yan.y.zhao@intel.com> <20250207030900.1808-1-yan.y.zhao@intel.com>
 <Z6Yhmg2nmUAtp4yn@google.com> <Z6bDZWzePT6CAreU@yzhao56-desk.sh.intel.com>
Message-ID: <Z6p8aukJgpKqg3Rn@google.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Make sure pfn is not changed for
 spurious fault
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 08, 2025, Yan Zhao wrote:
> On Fri, Feb 07, 2025 at 07:07:06AM -0800, Sean Christopherson wrote:
> > On Fri, Feb 07, 2025, Yan Zhao wrote:
> > > Make sure pfn is not changed for a spurious fault by warning in the TDP
> > > MMU. For shadow path, only treat a prefetch fault as spurious when pfn is
> > > not changed, since the rmap removal and add are required when pfn is
> > > changed.
> > 
> > I like sanity checks, but I don't like special casing "prefetch" faults like this.
> > KVM should _never_ change the PFN of a shadow-present SPTE.  The TDP MMU already
> > BUG()s on this, and mmu_spte_update() WARNs on the transition.
> However, both TDP MMU and mmu_set_spte() return RET_PF_SPURIOUS directly before
> the BUG() in TDP MMU or mmu_spte_update() could be hit.

Ah, that's very different than treating a prefetch fault as !spurious though.  I
would be a-ok with this:

	if (is_shadow_present_pte(iter->old_spte) &&
	    (fault->prefetch || is_access_allowed(fault, iter->old_spte)) &&
	    is_last_spte(iter->old_spte, iter->level)) {
		WARN_ON_ONCE(fault->pfn != spte_to_pfn(iter->old_spte));
		return RET_PF_SPURIOUS;
	}

