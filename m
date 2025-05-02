Return-Path: <kvm+bounces-45261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F7CAA7B91
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F848189F270
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F54C210198;
	Fri,  2 May 2025 21:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wD//zs9O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BDA20F09B
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222691; cv=none; b=jW/KGn14RCQhQCnTWzm83Nlitu75Ii1FgL6s6kvfLiTCr+n5Wqv4nFz6U3NUEcL5p8v6rJ9xmBZkcVqybxd+G9lfpmnmGCU84rBkA3oU61isK/yWh4uP5j8VsyKhPCLrxqB4Z1GLSAAiupEdSXtqjQ4Mkuppui1l2IkD5CPyDlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222691; c=relaxed/simple;
	bh=2txtXmkPas782tuJZyId1VB56basPkhr7R2WNHcvWIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HLHIHxGjO1UIJQccNfr6/Dg44kyjIrC+s/G6gmUVbvv+4ymHFw8DntGL0gke/fVn/O+eqEwu5QDDy8ZCccOpN7tppRdBIOdY5A4EYUbJgPve3O4duG4jn3Jtv/dLFneJu7GncBc2+SUcyh+7dj1X4jjEXu+pGOR7iNbVqikLLzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wD//zs9O; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff6167e9ccso3006990a91.1
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222689; x=1746827489; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xuMrCSQLCVm3rK1Z/M2Y8ljgy1BUHkh9BuXdAIH55U0=;
        b=wD//zs9Od0fk/M8vUPqNfa7tymOClDvngp9LxY8jqYE7BzG7xnIe6qssmh/PWcjbdx
         TT4qT1c9bccHGUlZIQD7Djqc3TWLziYRy3CFHUPSa8dVhjjIS3+1gdqcZ3LGxNxQH/qq
         su+0FJnYU8en3hp8K6APDx2mS35GVSVveYMHUDc6swtzpEVXJVGMEklggbxspvbE0/52
         twi7MrxS06f6czu1uNQRmPFuCGygKAEOEu8lcoQ2mu03t40xnfiB0l77jCX5/hn37b5X
         RsL3uJdxIZX/Nyo3/GdVepZADoYqji+nPnkmVQkH1j3FpnIGf/0K4P1GwCgKULwhYFO6
         yGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222689; x=1746827489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xuMrCSQLCVm3rK1Z/M2Y8ljgy1BUHkh9BuXdAIH55U0=;
        b=xKpd6zLC0AYgf5EkywBkap9GaVbHtzGY2mK08BBit0c9+psUf13WFRrckG/YpL63CC
         V6yyjaPaY1WE4ElzlQ00wR8ofp/PzexX/ZY7aomnLW27ftBpGDDxD9yRJ30cZkk0iGBL
         OZcpOHEwb0qRtEZZLJJgEvjHQaeFU5dZm1vVnjBgZB/84sHYB51FezPog2uwq3gL0zuq
         ryQdteWMqj18pPWEPLzAFPYN3+lCIlvLGma28IP6dSCtvjQZJ0OkyVTb0SrRQef6sRUr
         nfAnF6gzjBti8txpMOl/L69NvG7r1g5R9Q7kGSO5TljfD3Gm/zNLhBUy0fPs7LdQnJX3
         zZ7g==
X-Forwarded-Encrypted: i=1; AJvYcCW8LzM0mxZjFNh2L+9FeH5sDFDRiszry2ZH9EE2+0TIVfR8G4HaIe1/10WnQoD5/1iG08g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJSrlo/jph5Z5HasaaUY7VgBZjqIwQrKMrgf5VnhaIwSsJTcyw
	8AhoKlVahl0VSdEB3cPYaowZb3g2Nh3MR7aSKGy1jEyeKGSQZhcm7jmpg9+lFv9iGWuY/gOC+L5
	TmQ==
X-Google-Smtp-Source: AGHT+IHot8nmmRowbrr226toKHfu1fQGbiC4az4KlzIrJYJnyZxG2Id1cugNtpGKpX82rmlgpPY7cq4QJok=
X-Received: from pjzz16.prod.google.com ([2002:a17:90b:58f0:b0:2fc:13d6:b4cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5404:b0:30a:4c44:cc05
 with SMTP id 98e67ed59e1d1-30a4e5ab0acmr4754053a91.10.1746222689088; Fri, 02
 May 2025 14:51:29 -0700 (PDT)
Date: Fri,  2 May 2025 14:50:55 -0700
In-Reply-To: <20250318013038.5628-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318013038.5628-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622239486.882502.1450694184969543673.b4-ty@google.com>
Subject: Re: [PATCH v2 0/5] Small changes related to prefetch and spurious faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Yan Zhao <yan.y.zhao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 18 Mar 2025 09:30:37 +0800, Yan Zhao wrote:
> This is v2 of the series for some small changes related to
> prefetch/prefault and spurious faults.
> 
> Patch 1: Checks if a shadow-present old SPTE is leaf to determine a
>          prefetch fault is spurious.
> 
> Patch 2: Merges the checks for prefetch and is_access_allowed() for
>          spurious faults into a common path.
> 
> [...]

Applied 1-4 to kvm-x86 mmu, and patch 5 to fixes.  Thanks!

[1/5] KVM: x86/mmu: Further check old SPTE is leaf for spurious prefetch fault
      https://github.com/kvm-x86/linux/commit/ea9fcdf76d3d
[2/5] KVM: x86/tdp_mmu: Merge prefetch and access checks for spurious faults
      https://github.com/kvm-x86/linux/commit/d17cc13cc484
[3/5] KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults
      https://github.com/kvm-x86/linux/commit/988da7820206
[4/5] KVM: x86/mmu: Warn if PFN changes on shadow-present SPTE in shadow MMU
      https://github.com/kvm-x86/linux/commit/11d45175111d
[5/5] KVM: x86/mmu: Check and free obsolete roots in kvm_mmu_reload()
      https://github.com/kvm-x86/linux/commit/20a6cff3b283
--
https://github.com/kvm-x86/linux/tree/next

