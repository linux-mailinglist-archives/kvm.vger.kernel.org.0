Return-Path: <kvm+bounces-9462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F90986084C
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:36:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE1C11F23F25
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56647B65D;
	Fri, 23 Feb 2024 01:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kKe6orUq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA50AD53
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652151; cv=none; b=p5Vj/V1tCXCG0Up7SWi7AunZ8+ihO3tBgrgPdhMze64YQq1eIYWfGTN0qDkKXK0QxJyPviV4qI6WnQpSkwwXqYiz7b3bXispB6NV5KIztB0rf4hK8eigcBIr0SWIPEZX9iMQjy0cUCtass3cd49v/PfbrvPvjKYBRnzQnRWVK3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652151; c=relaxed/simple;
	bh=p4d3Q0Ezf7xGBghQvwbWJdhARUgaypqvkJKM9BnPDz0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mzYIZl1gBPuUHF6jCPtSLN0t0Tq+upKKV2dP3K6T94c9pSgrql9p1EzKTj/RHiRRfib3dXXUw50F8a9mMbxTl6L/PD5M6AnrxUjggBNmfaPny1tntaPPF6jpFPD7/R1LsFot3WRvj9MO1B+JqX+eXIuBoyW7jhzuqggjwwNEiDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kKe6orUq; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so556231276.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652149; x=1709256949; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wM73uSKwWS47RUq68QegjT1HnyhxD9Ii9nwZABJn6I4=;
        b=kKe6orUqSNLsObiOLhBjWxOTM/lyU7jFR6hpcIf6kKhZeHOflQsntFjS02MSygG/59
         wunGz210vE4eNBXBUKSjH6yxhRxoI1JFz1J/6HwVFKt2o6Zu0dC8GXGOXSQxq0Kac+7O
         irLWE36fI8bFE5dHkyzkqpa38wck2t6rYXbjxV+25nf0ms2FHUB0l/Plx30DubLQ6k9n
         UHcYsTOn7V+12/x0MVoPd7YlJK2JLcRn8p4wAkI0w0rgifyfGe4Wtc9ZPUZ9RWoEe34D
         nxl5NnSwq/kRmbpH59sHZeFUh+WJhS/S1TF6mjaJs6egKdfLO3emhtsnfpX4Xi4CEC6M
         ziiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652149; x=1709256949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wM73uSKwWS47RUq68QegjT1HnyhxD9Ii9nwZABJn6I4=;
        b=ZMQHAL8vn6+JRJ+g9uWDe6JybdPa4FwI7e1nwD0OONQKPieDe2tJB0h2ENIE8bzKw3
         AmwMG1oorxsCEAce9q9UMKb5XFfezZ/5bUv037z4jTmisOr8cjf6/EWhAaVJzDJkX4vq
         bWXCvy4cdhE+HlCjmX4LN0Nro57XFhbd5AzD2B4L103cZeVyaK51s46gxzPFIaMgGrBH
         c9np2AMlPQhgkBSuHTyFqDUizf2PZCO57IhkIi1dtxE8gPJ74imHumRSyNj7tIiuZEtq
         MrMzmn2Vg22LGYF5xW5Slp0GkV8gjhipBOVkyJbOSKpmeBZunEffgZOLdhlLh1bKpWmt
         lj2w==
X-Gm-Message-State: AOJu0YyfjnM9cPbabAp6YLXAXFYr2XOoHjevXYtaTqzRE4R1cB5VMGeF
	AKOROXahyzDsLXcXQCjrW25OMhx2TMn3S1euz9E9jGob41EvG09ikLJPY5vkYHsugTv2bRmpf8N
	EiQ==
X-Google-Smtp-Source: AGHT+IHA2JNk7sue8BnBcUvK6I6CX/uQlY+iUi0rCInDpHy6xd2yG/qDics+T39rRD2l5LCFyspd5l5pqnw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18c8:b0:dc7:68b5:4f21 with SMTP id
 ck8-20020a05690218c800b00dc768b54f21mr215694ybb.9.1708652149006; Thu, 22 Feb
 2024 17:35:49 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:32 -0800
In-Reply-To: <20240222012640.2820927-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222012640.2820927-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170864687051.3082005.15844066182287586773.b4-ty@google.com>
Subject: Re: [PATCH v5] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Friedrich Weber <f.weber@proxmox.com>, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 21 Feb 2024 17:26:40 -0800, Sean Christopherson wrote:
> Retry page faults without acquiring mmu_lock, and without even faulting
> the page into the primary MMU, if the resolved gfn is covered by an active
> invalidation.  Contending for mmu_lock is especially problematic on
> preemptible kernels as the mmu_notifier invalidation task will yield
> mmu_lock (see rwlock_needbreak()), delay the in-progress invalidation, and
> ultimately increase the latency of resolving the page fault.  And in the
> worst case scenario, yielding will be accompanied by a remote TLB flush,
> e.g. if the invalidation covers a large range of memory and vCPUs are
> accessing addresses that were already zapped.
> 
> [...]

Applied (quickly) to kvm-x86 fixes, as I want to get this into -next for at
least a day or two before sending it to Paolo for 6.8.  But I'm more than happy
to squash in reviews/acks, especially since many people gave very helpful
feedback on earlier versions.

[1/1] KVM: x86/mmu: Retry fault before acquiring mmu_lock if mapping is changing
      https://github.com/kvm-x86/linux/commit/67e4022ffad6

--
https://github.com/kvm-x86/linux/tree/next

