Return-Path: <kvm+bounces-56183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C617B3AB9F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 22:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B85A56719C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 20:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0256286D49;
	Thu, 28 Aug 2025 20:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G5KaIX28"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872E6285411
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 20:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756412822; cv=none; b=SYx6AbdxI5o+44ohi/mHsPysmQAi3mi+YK8ONaSJlh1LOB8tTkYx6Rvk0MhswoVD6hJ38Rbug/4fYEv9EdFhX25+PdNuL2J7wW9N6qvqO5D93Wtw09+eZbF+uK4McTihTEMG/WlVMR4jy/X/JoAR50fAhoTC3GJWMpN7Un/SIaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756412822; c=relaxed/simple;
	bh=lQCj/8DX2+2fPso80C7omivOFNdfKWj9QCf3lQhPPRo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X6SIF/U6g6gUPBEWAVMz3FdOXitrINopizCxnG6WVg0THuska39M8leomHEPfj/jCsFdR5HRjMRnGkAvwVyiA/68n2WkfQpqvJbgTCU0oC+imui+33+CrbWrGH2jJzxU1r8piuLuz6v51mJN4cA/IXc9SYKC3V5jf2qntRLIYGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G5KaIX28; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471757d82fso1113304a12.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 13:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756412821; x=1757017621; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GSfr0LzBocl9L9UhuFbA5UhknpM1E+hopBnA+D2wBr4=;
        b=G5KaIX28Rh8o5uyqo7lRCVCQsKNpQzgMSEwyXipGZt6vDjdwX/GhveeczzawiHn9GQ
         uoGdho8c5AhAlurJItG0e7XBXBAwj7VodwE7eFZ73XkrJtPJVenUORTqPkuntN/YllzY
         mdA1sgVCofHJpTR3Tnb3RGv9yrA5S4xcYs1SzlVkjMw0jRtNF7WH463QJk94LwV2PNjw
         JOG+D8tZMmX8QGRzUoxhBkH1nYlZbLp9x16lxsn5GXuNmWU714oC1MUf3pN8PTYwOItu
         5PzjX+efD/BOwwglMNok/smgOxLRltzeXssOmC3hClmhcVNlUaybVPRzkNAoINzU27dP
         dc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756412821; x=1757017621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GSfr0LzBocl9L9UhuFbA5UhknpM1E+hopBnA+D2wBr4=;
        b=Hsp2VDVy69VEDeKwVGiiwyM1kRUt9mjRV7bTrtcrp5ub0UjYRGrdBQYtimzxPxpRtW
         fI6Up4FLK+hbVhM1E6JXDs83/cGhzKU5mauoE6ssZWhIr9aCfiCYXzMhk8MvV3XB+MQL
         5Tca2E3V2/RfeNjZWZLcoFmFiIgYpCBpm3ufjG5YX26bKRzQHc9sF5ddU6WwLqmSAebU
         Vau6e3jnTLriQaHESjr/ACyCNL+CmrXHAAYnCqUXfEmynyXo/2Ev1rfLq1UOe6RzKExC
         IwinRSGiPsPBY6NjmRBD4eP2m3382vH0zmbY1bhylkhBU1jA2qcYCXdABvhXK5YuqTde
         oxeA==
X-Forwarded-Encrypted: i=1; AJvYcCWL+5o0gvXZbVA9UWdx9MJGaSquTKqulpXJpsR/7zJ4IS3AqROfUadxm9oZJ9XjXMe/POg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVqZ2y0ceIAzqPvGfq0HeFbQVpCI0q2CO9bYZ35hLcFeHBJrv5
	8YmfsCIWz0g78afOvMy1KaFKs0KJZwGJe/vJOfabI+ZsJib8xyM3+tNeADyPj+k3o4E83gWLtmG
	Zv1znRg==
X-Google-Smtp-Source: AGHT+IGzXOKfZVvo+2eg6DXkxP+qrQxlD6YKvr1m/uZAbrEhBiVXCwwJbl3iWJVXN2X6ydlBuQ3wyXAC4sY=
X-Received: from pjbsd11.prod.google.com ([2002:a17:90b:514b:b0:325:b6a1:dda2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d08:b0:243:7136:2fee
 with SMTP id adf61e73a8af0-24371363240mr22615414637.16.1756412820760; Thu, 28
 Aug 2025 13:27:00 -0700 (PDT)
Date: Thu, 28 Aug 2025 13:26:59 -0700
In-Reply-To: <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com> <aLCJ0UfuuvedxCcU@google.com> <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
Message-ID: <aLC7k65GpIL-2Hk5@google.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 28, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-08-28 at 10:00 -0700, Sean Christopherson wrote:
> > > tdx_td_finalize() now just returns -EINVAL in case of nr_premapped being !0.
> > > KVM_BUG_ON/WARN_ON should be also ok.
> > 
> > Ok, so I vaguely recall that I may have pushed back on using a scratch field in
> > "struct kvm_tdx" for temporary data (or maybe it was abusing vcpus[0] that I
> > disliked?), but what we ended up with is far worse.
> 
> I think it was also that the tdh_mr_extend() loop was too heavyweight for the
> fault path. But that was before we got to the kick+lock stuff.

Me confused.  This is pre-boot, not the normal fault path, i.e. blocking other
operations is not a concern.

If tdh_mr_extend() is too heavy for a non-preemptible section, then the current
code is also broken in the sense that there are no cond_resched() calls.  The
vast majority of TDX hosts will be using non-preemptible kernels, so without an
explicit cond_resched(), there's no practical difference between extending the
measurement under mmu_lock versus outside of mmu_lock.

_If_ we need/want to do tdh_mr_extend() outside of mmu_lock, we can and should
still do tdh_mem_page_add() under mmu_lock.

