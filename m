Return-Path: <kvm+bounces-11798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A27A487BF48
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 15:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D50811C21279
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 14:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830FB71738;
	Thu, 14 Mar 2024 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L4BnZfR4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6214D1D53F
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710427680; cv=none; b=t+0iycpT/+MTab6foamCIfd67d7Fga6YtZW2YEgtNQ3z/UaWfDiD/GUHtOh9L/hC255Hc+sFLct5xjaMuSDbTTjlVLGSDRYEr4fHa4Dr1gTPR94/2xEiWwv+6EPOOnlFq0Xka6rCx8Qs3/5J+mTEb+ozf/lEDYNNIg3XhpxxULs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710427680; c=relaxed/simple;
	bh=o8GtUI7JCR1UlHN2Jj7OLRVxrCmqhcWR9eQX21BsIY0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BcrAUHqljNZv6TrJWKkLY5jWljHELqPJe7g1MH10Z0XxRgQn1ORn1jo/okaois9dMno+tAgbdG0PJWFgSsn3IcMJ9fP5FFmEodSiKxb+ekfubIkLBsULuxMwwHTOzNqPgtmMrThbRJNsZF1+V8QCr7nDgRQEcA3Fc0B6yiCT9yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L4BnZfR4; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6b3bff094so1297908b3a.3
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 07:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710427679; x=1711032479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UCLtGcT112yIVdDhvDfaxSfuuQ/aEnwbhFAj1Y1MJlw=;
        b=L4BnZfR47Qlt94yHryz6Xj3xsgDwbIB64vQogZFwiE4/ZqXqRPJHHRFv6E2+Qp7k8E
         UqUzs2dLr6WLQPtoXKash8SGD+b/9pZn4WSwTDhe2ssYaUPCR60Hx8plCcHE+Ub9/tU2
         qPiB5uVXuC/szoR/i4p1XXDs6IMw/BkxcYHA8B3imypY2pJu2t0qAogrK8Z/IN5C+u9q
         SVu1/UVcYFXxWzLuPEESMo98Vtt9tJuOyRUHtGxOQdk0LrtGpUUq4CkEdWD+nrkD5W37
         WpBqoi0Jxl5F3XF97c9jwlCR1fA2+mH7glIekoCkZejbFJ2amsa28ozuY3LaQhsIKGNF
         EVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710427679; x=1711032479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCLtGcT112yIVdDhvDfaxSfuuQ/aEnwbhFAj1Y1MJlw=;
        b=H5SFmWe4iaJm7w+FRvak++btmMJI7//YAXvqtDwAOUeDby+rrvNQ0PvLa4kM+Wg91o
         G7ECljboIAszapse5/5LDIc70VkQ9lEFudeLnygHw7VGt+It5XxAVOwswUReF0KbBAJb
         zBb/F2peCLonO1X5AlbbOYIBfdPxMKpfIxbp82i7k7Q0IfATqfxfNkDE1odKWrjKE8dT
         Y51LleVhf3/gcxymMR+WBcqmiy98+83y7S2dfVMr/E9mNMiYAAA1zP7/5NWbpn72bhVT
         n1+ra26AY/dQ7oB7LPDZb99+F4olfGVeDAclBmjFqWrcOFKPcZO9k+ISxvogqQScXyVC
         hzmw==
X-Forwarded-Encrypted: i=1; AJvYcCVHsOMQ0xroPFgw0CKM/1OkTNEtSeirpOLBfWVm7U+KaR90BbgiE6P10x1JiaXsoeEppYMo2su+6CNanPCzCM31sg/z
X-Gm-Message-State: AOJu0YxJg0OWm5xdDgFo8gYFeD53wKVEgpiNI6b/ExP36ZpNXlBOi16k
	Dv55RLLy7c4E0041Z3U9OW4xcIpO97C7O7xjD2YV/9JUllL5JrNBCUdbNCnVVacw5YctU21gTKr
	pzw==
X-Google-Smtp-Source: AGHT+IFUARZWuJkNnGfTumcikVFdmjDQIP3ztgYAXM+CX00BY4XnJfbYnor2ZYJyZWzlUdnMVYU7RQpjNs8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3d15:b0:6e6:b638:3f78 with SMTP id
 lo21-20020a056a003d1500b006e6b6383f78mr86525pfb.5.1710427678684; Thu, 14 Mar
 2024 07:47:58 -0700 (PDT)
Date: Thu, 14 Mar 2024 07:47:57 -0700
In-Reply-To: <73c670d1-0301-49bf-472c-97ae8d1b6c7c@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com> <20240309010929.1403984-2-seanjc@google.com>
 <5ee34382-b45b-2069-ea33-ef58acacaa79@oracle.com> <ZfCL8mCmmEx5wGwv@google.com>
 <73c670d1-0301-49bf-472c-97ae8d1b6c7c@oracle.com>
Message-ID: <ZfMOHSTHXoPxP6v8@google.com>
Subject: Re: [PATCH 1/5] KVM: x86: Remove VMX support for virtualizing guest
 MTRR memtypes
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org, 
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 14, 2024, Dongli Zhang wrote:
> On 3/12/24 10:08, Sean Christopherson wrote:
> > On Mon, Mar 11, 2024, Dongli Zhang wrote:
> >> Since it is also controlled by other cases, e.g., kvm_arch_has_noncoherent_dma()
> >> at vmx_get_mt_mask(), it can be 'may_honor_guest_pat' too?
> >>
> >> Therefore, why not directly use 'shadow_memtype_mask' (without the API), or some
> >> naming like "ept_enabled_for_hardware".
> > 
> > Again, after this series, KVM will *always* honor guest PAT for CPUs with self-snoop,
> > i.e. KVM will *never* ignore guest PAT.  But for CPUs without self-snoop (or with
> > errata), KVM conditionally honors/ignores guest PAT.
> > 
> >> Even with the code from PATCH 5/5, we still have high chance that VM has
> >> non-coherent DMA?
> > 
> > I don't follow.  On CPUs with self-snoop, whether or not the VM has non-coherent
> > DMA (from VFIO!) is irrelevant.  If the CPU has self-snoop, then KVM can safely
> > honor guest PAT at all times.
> 
> 
> Thank you very much for the explanation.
> 
> According to my understanding of the explanation (after this series):
> 
> 1. When static_cpu_has(X86_FEATURE_SELFSNOOP) == true, it is 100% to "honor
> guest PAT".

Yes.

> 2. When static_cpu_has(X86_FEATURE_SELFSNOOP) == false (and
> shadow_memtype_mask), although only 50% chance (depending on where there is
> non-coherent DMA), at least now it is NOT 100% (to honor guest PAT) any longer.

Yes, though I wouldn't assign a percent probability to the non-coherent DMA case.

> Due to the fact it is not 100% (to honor guest PAT) any longer, there starts the
> trend (from 100% to 50%) to "ignore guest PAT", that is:
> kvm_mmu_may_ignore_guest_pat().

Yep.

