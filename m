Return-Path: <kvm+bounces-38211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FAA7A36A16
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:50:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 972E03B10EA
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F241774E09;
	Sat, 15 Feb 2025 00:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uglToXfE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B0FEACE
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580632; cv=none; b=k9D2hxE6x7gW+CAEiirvaLE8/Dp1UdnGQFLkrnWC6sx3V2s/ifPA4gSafw2m6CawlqQHZihuWoPfVaHjCUfP6/YlGOKzjEbUJY5Zbxbx8lkynLeNEro02bvlFifq5ZA/A55OroebWxKK/1fjBN5onkf2vQP82u3XQ9cvgNeo4JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580632; c=relaxed/simple;
	bh=DD1RMHcqHXHtSXjy9qZLFVRyL9tDxgSiiURo9OQ96ok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KhSC7VMlSS2crzMTIZR1y+EE1XTUou2r13qweYDQtxACAFdfPc4/VWOef4Idsct5Xjmv2WfBSLKIcFsaRR8I8b49OSNZ2EtVqsD2Wn5prwvBVbUkR6UtcCFNCTFH9MbDLSICEaCrLbrSaLdKbK4LwIjiiz2gmNX3hKgnnXGoS1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uglToXfE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc3e239675so1600467a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580630; x=1740185430; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YIE47UKxxWcKjCmL21kwJ8j8oO1nS7dRlhB8wJS9w5g=;
        b=uglToXfEvrnoSt2adz/vM+b0sCVPWjsKmd/d4S+IJ6gEsS+sti83ztD1hFF+M8mPOq
         +BgEQI5ly3x2b/2LKrQr02QMGeh6LHXYBnmy0kgzkGWisYl0aekswCxRlS72xujLLGfu
         fCLVNuzT8EqlHn7uUsUqxXM3TmEzI/X2DvlddUKTQRmh72pWjR1mamt7pN9X5gtyNsgF
         +5o6KA82QiS/I8bITQWr1t6uag3joCXj00WUi+9rahUanjj5aEH5QkYUIFG2vRF0oip7
         xfp/cO70Q//ri8wxqsogA+5OLxqgTWXHygq5IY5rhDlYDQN1waHjJCFIsw67JoXpEq2H
         tC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580630; x=1740185430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YIE47UKxxWcKjCmL21kwJ8j8oO1nS7dRlhB8wJS9w5g=;
        b=CUetAefJksQ8VprWaSv02GBJUJfY2lDQ2XG5y999054jNpIAI+gqCfB2WvyXXBqGGu
         fBb7A+LsGvFj7sBWV3fEfeymvSM79cyQ5z0KJeFbwVLIWPRyMgS1gMdx2p3afjCy+v0o
         cRBtV0IEeKUg2hHTzkDX00veHTIoO/7/hsUBQk5RUXMzTQAS0N20XVTUUINalKWoNdNY
         LrdMXQq/v90bFJPuOrxPzPxgKb7iNEqMme80qiOuHBtMNxr4OlPZn09kctQN9Z4OgGSQ
         ubWR983e8J8v8+66/XE2OJuZYPQMSXtHxOoGww30KuDkBYgFs8nQkAyDnuO0MasGarIv
         DfxA==
X-Gm-Message-State: AOJu0YwIpqEhTDCeNtDjBhHMCrobl8C7UgnlsfzLm+Zy4n1gpcqtYXFx
	1o2wWofeRFt0vJyHWewvguNIh0gjrzQ0lZwDGYwGgJkt6OSNJlhOQe/PwaHNhNF71tlpVLBxib7
	Mcw==
X-Google-Smtp-Source: AGHT+IGYzFsreJBlV69pBS5DoE2MfEEmhv2kxLxr0Du9uKGuYXL3tqBYxD8gFLEQfCYq0uQKBRZAkppwvXo=
X-Received: from pjvf11.prod.google.com ([2002:a17:90a:da8b:b0:2fc:1158:9fe5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c8e:b0:2ee:5958:828
 with SMTP id 98e67ed59e1d1-2fc40f0e672mr1782459a91.9.1739580630045; Fri, 14
 Feb 2025 16:50:30 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:07 -0800
In-Reply-To: <20250130010825.220346-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250130010825.220346-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958023279.1189000.15717835333610830974.b4-ty@google.com>
Subject: Re: [PATCH] KVM: nSVM: Enter guest mode before initializing nested
 NPT MMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"

On Wed, 29 Jan 2025 17:08:25 -0800, Sean Christopherson wrote:
> When preparing vmcb02 for nested VMRUN (or state restore), "enter" guest
> mode prior to initializing the MMU for nested NPT so that guest_mode is
> set in the MMU's role.  KVM's model is that all L2 MMUs are tagged with
> guest_mode, as the behavior of hypervisor MMUs tends to be significantly
> different than kernel MMUs.
> 
> Practically speaking, the bug is relatively benign, as KVM only directly
> queries role.guest_mode in kvm_mmu_free_guest_mode_roots(), which SVM
> doesn't use, and in paths that are optimizations (mmu_page_zap_pte() and
> shadow_mmu_try_split_huge_pages()).
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: nSVM: Enter guest mode before initializing nested NPT MMU
      https://github.com/kvm-x86/linux/commit/46d6c6f3ef0e

--
https://github.com/kvm-x86/linux/tree/next

