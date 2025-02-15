Return-Path: <kvm+bounces-38220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 020D2A36A6D
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 386083B2D73
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2D882C60;
	Sat, 15 Feb 2025 00:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/yQ3cbi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682B8170A13
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580943; cv=none; b=sZOHsOwpkY+5ve8BAQvqtlyNpfbk1w8FEQ/ySAH+7rshafVeLL+crv53gCjlIPOCTmM4g5xtW4+bEELtacihK6qNzotfLnbZaTOe7Too5D8b1T5hGcMPWVaRa8c9BcMf4mjvovOM6eaJncUCIKhbGU+78rr/6ajux75f5SeJNnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580943; c=relaxed/simple;
	bh=oTrztYsLyvwtgGLVf1tQ8GAPVF5vvtL5w9W5awmGqWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bQ28K4aH/Y2SoV/ihTboE7bEURyv5ora0EGLF0vHDsc92M9ZE6IB8xXOgV84VudmLxufu3sov+myiZvaYxhMSe6DrIceZnsf2CjuyKuXwRhHYkb/5abbH56nsxn4279M+waaeE5xjM0oafurfCEMMaoewdIp2tNEX0DqNCX3Vzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/yQ3cbi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso8484054a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580942; x=1740185742; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pNsIgOyf4QC9I3CvrkHrF/C70G83LOB+aLDY9O6HBIc=;
        b=i/yQ3cbihV/Ik0YOx9Cygpca48VSYCeJ0KLb4389/eyGMBuIjen9Vs5kMcxStwldDU
         bqU83omkwKQKXedsre+vl0BUYTaMBzTR1+TEk9Mm4bVJQ4HLfzN6TgRjcuWirTTQ1QBn
         HWVWyotS77GKSTdQ/Hr8ovlxcg26Vhr/xQd0NLPy9YLxTR/pHIQK3YBB5QNHvCBWukwn
         F6QA+4R5MQCj+e2RLnB43xRwWFM7ENzigyT9AxuOTFgf8HQnJFQ7N41eLbyDsXBnc7Sm
         8Wje5Jc3jgjydXUaO1sVGQadfLZaykAG6EADwvX3z7nio+M1EAyvvOE7MdGo/tWYM3qB
         Oszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580942; x=1740185742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pNsIgOyf4QC9I3CvrkHrF/C70G83LOB+aLDY9O6HBIc=;
        b=s1zQnSgcz7bE1X8Jhp8PivyRKcfqwQS6mXTaeurz9oD+eNXTmSFs7ZvJ7K62Z9fiI2
         ZfFJB65iu6lXj009d3W9TK1NZT7pcEYjejByBTr+DdS6hszQSViVno94/4PHpi11Mdr7
         Z4Ha16Y187XHLq5pUYl6f/I0xpbFX2YipaN+ZF8bRR3Woq7/dvJpk8rgybmVlQSkuyCg
         9wbiS4HRQENWSprGDTPPFEAn2NCYt7QZ+3qDn74ThLvw7kd/R0N4i0pqhwVn8DMa/AH8
         mGxcsVIbz40U+MvenpCPN8mgZksizW6IttKfDND32kpeo9mq2GW2sAe8ObUUdmqWnTsQ
         nfYw==
X-Forwarded-Encrypted: i=1; AJvYcCUcwJcsP5AsT1icLgrx/e3qB8YAl1rONusmp34hr0zX9MjX623VQ0mo2Hq4rouxwca877g=@vger.kernel.org
X-Gm-Message-State: AOJu0YySdwTao9Li0ggPYm86ejXbxRPVJ9+16zkLUtEDqQ2HQXERMYMd
	fd29WUj9j7M8NDf0Fzub4PmYBPZj4vtXS/E8yFKyKvbV3QGphriv1qnOcO1TfKYlRrstvSZrzqc
	NBw==
X-Google-Smtp-Source: AGHT+IFivmaYswWZhaa6Czc5kcx3boX9fghq5jele205LhNXaQ8LsTuPJ7sgZ5ibW32cKGozhQE/CKLT3Eg=
X-Received: from pjboe14.prod.google.com ([2002:a17:90b:394e:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0e:b0:2ee:8427:4b02
 with SMTP id 98e67ed59e1d1-2fc41049fbfmr1809156a91.28.1739580941915; Fri, 14
 Feb 2025 16:55:41 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:24 -0800
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958060314.1192011.10710541316458092620.b4-ty@google.com>
Subject: Re: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Houghton <jthoughton@google.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yu Zhao <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 04 Feb 2025 00:40:27 +0000, James Houghton wrote:
> By aging sptes locklessly with the TDP MMU and the shadow MMU, neither
> vCPUs nor reclaim (mmu_notifier_invalidate_range*) will get stuck
> waiting for aging. This contention reduction improves guest performance
> and saves a significant amount of Google Cloud's CPU usage, and it has
> valuable improvements for ChromeOS, as Yu has mentioned previously[1].
> 
> Please see v8[8] for some performance results using
> access_tracking_perf_test patched to use MGLRU.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[01/11] KVM: Rename kvm_handle_hva_range()
        https://github.com/kvm-x86/linux/commit/374ccd63600b
[02/11] KVM: Add lockless memslot walk to KVM
        https://github.com/kvm-x86/linux/commit/aa34b811650c
[03/11] KVM: x86/mmu: Factor out spte atomic bit clearing routine
        https://github.com/kvm-x86/linux/commit/e29b74920e6f
[04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn() and kvm_age_gfn()
        https://github.com/kvm-x86/linux/commit/b146a9b34aed
[05/11] KVM: x86/mmu: Rename spte_has_volatile_bits() to spte_needs_atomic_write()
        https://github.com/kvm-x86/linux/commit/61d65f2dc766
[06/11] KVM: x86/mmu: Skip shadow MMU test_young if TDP MMU reports page as young
        https://github.com/kvm-x86/linux/commit/e25c2332346f
[07/11] KVM: x86/mmu: Only check gfn age in shadow MMU if indirect_shadow_pages > 0
        https://github.com/kvm-x86/linux/commit/8c403cf23119
[08/11] KVM: x86/mmu: Refactor low level rmap helpers to prep for walking w/o mmu_lock
        https://github.com/kvm-x86/linux/commit/9fb13ba6b5ff
[09/11] KVM: x86/mmu: Add infrastructure to allow walking rmaps outside of mmu_lock
        https://github.com/kvm-x86/linux/commit/4834eaded91e
[10/11] KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
        https://github.com/kvm-x86/linux/commit/bb6c7749ccee
[11/11] KVM: x86/mmu: Support rmap walks without holding mmu_lock when aging gfns
        https://github.com/kvm-x86/linux/commit/af3b6a9eba48

--
https://github.com/kvm-x86/linux/tree/next

