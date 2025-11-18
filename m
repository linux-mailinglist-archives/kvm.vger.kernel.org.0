Return-Path: <kvm+bounces-63622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A26C6C03D
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:32:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4709E3630A4
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D32131577D;
	Tue, 18 Nov 2025 23:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VQQqjyCV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7E13126CC
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508686; cv=none; b=mh1+8mnx0+o+owkQ6iV/EzreNLIgZbQJ9QQHswig0wXc0gKW+orRBQqVYUP6LEFD7q0nF9KK02YN+oQBV1eS4l9We4NNFiqtgLM0XtM3p6Qy6hS5YMBB4XZmKVsgqp5uY1doSoKxFQKfLIwDVgL67trcfLW0RG9+pA/O4YChxFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508686; c=relaxed/simple;
	bh=5WBwqUVhmKiZfIpTpsQTwtOFw21J/JhhQ4L/zj7meTg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cXWMr4LRzpIP3z1FXB5R0XaYGnP1sSANBriU8ro+bMVn+H5h9hlnLkX0a+JMp6et6srYWEog5FdBhQVH50/xdqomKw36rqHjr3xXKl4Szl0m/GsyQuoW2JKwy6RTEzOTN3ZvGAvWlHhpAev7YtQs87iEeWay4sPXlwdZFxA0RX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VQQqjyCV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343daf0f488so7358862a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508684; x=1764113484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vhbmIaudy7FUgPhz41c9iiSjQeSWp1bqqQI5ni0zcdI=;
        b=VQQqjyCVKUjethBzmocMAKOMZ1Qk6f5+puPh/BGYtTyIWze6b1FACLZwRYeu2GTtT6
         Ka5NqxXzLHFbn7+q4velVVnI0knXOUecLZK1+BZ5V/cOs26euxCEk0eGIw/iCi2xLh/4
         vtPBR+vy8msAFS2Ej6JQijGmxjN3w2H6WJbI8Vq7GbkTZq/DKlRv4mO7pcM2hGu9Qq9M
         8oVpUbsUPGhrpKfoyp0VrrMOXA+uECznX1BNDbTejb7wBC/ArDFhRBhhM8WKvvFXF3eB
         /ChnZmu4M3eUGiNK8oXMFjia3S86lnBVfqiOQWh2eLY9QYI/SqDHIBCcJvcBTZYocvN2
         F8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508684; x=1764113484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vhbmIaudy7FUgPhz41c9iiSjQeSWp1bqqQI5ni0zcdI=;
        b=lLLK+N+LXGOZTzx2+5c49LY7zB4vhAGo8o6/MkQgtnESdlemKJQb7sMwrpMv3K6Lb4
         5wN5M9Hhwlos76MutU8FVFK8AKhP+AOilW4/V0Ct17VYSfDmgN3FiddUxdV01TC37LiW
         A1IrLZ7P80QQkKlMR7pdrJoTPH8iJMKBxDYCE5U4f3aiQBfjSWPZdxvyVBiA1R8MAQni
         2hRrlIQCrbX8QH9GrKnuzAQf8N2Y7qezKJFBUBfPCBOKZtJHFImXTYy/k0rJiIn8VERb
         BLm/ep9oH53H4cW5g3N+el4v4ZJje+n/fZbTA2XfvWYM1+MN9ROJ9CPWwMILAW+PSzTY
         RDKA==
X-Forwarded-Encrypted: i=1; AJvYcCUfylpWGjO0310bOxIFx5FU4SXdNFrgd4Kowo960z70nwPhaJDzyQUirVUnnXTYCo+Swd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV0m2xpSjyK48b2vL1OXBkl2uKXq57dfVYJM4Hq0xvH/OWlcbi
	TZiEtzXPeKwrEOweWmoxargq4SzgY2PdRCcRvawhyK6g7XHIb2aKMoQSpqqzrtH5YEvJ4Q/WhyH
	mj8IpQw==
X-Google-Smtp-Source: AGHT+IE1o3OuDgEYh+WwImWCZtj32ss/bDTcBxOCjrPrz1sqG0DLMNd/QRhOEpFCg6/bq23FewNy3cS6Bik=
X-Received: from pjbpd18.prod.google.com ([2002:a17:90b:1dd2:b0:340:e8f7:1b44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5484:b0:341:124f:474f
 with SMTP id 98e67ed59e1d1-343fa6390cfmr19214010a91.32.1763508684387; Tue, 18
 Nov 2025 15:31:24 -0800 (PST)
Date: Tue, 18 Nov 2025 15:31:22 -0800
In-Reply-To: <20251028002824.1470939-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aP-1qlTkmFUgTld-@google.com> <20251028002824.1470939-1-rick.p.edgecombe@intel.com>
Message-ID: <aR0Byu3bd3URxzhu@google.com>
Subject: Re: [PATCH] KVM: TDX: Take MMU lock around tdh_vp_init()
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: ackerleytng@google.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	binbin.wu@linux.intel.com, borntraeger@linux.ibm.com, chenhuacai@kernel.org, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, ira.weiny@intel.com, 
	kai.huang@intel.com, kas@kernel.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev, maddy@linux.ibm.com, maobibo@loongson.cn, 
	maz@kernel.org, michael.roth@amd.com, oliver.upton@linux.dev, 
	palmer@dabbelt.com, pbonzini@redhat.com, pjw@kernel.org, 
	vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	zhaotianrui@loongson.cn
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 27, 2025, Rick Edgecombe wrote:
> Take MMU lock around tdh_vp_init() in KVM_TDX_INIT_VCPU to prevent
> meeting contention during retries in some no-fail MMU paths.
> 
> The TDX module takes various try-locks internally, which can cause
> SEAMCALLs to return an error code when contention is met. Dealing with
> an error in some of the MMU paths that make SEAMCALLs is not straight
> forward, so KVM takes steps to ensure that these will meet no contention
> during a single BUSY error retry. The whole scheme relies on KVM to take
> appropriate steps to avoid making any SEAMCALLs that could contend while
> the retry is happening.
> 
> Unfortunately, there is a case where contention could be met if userspace
> does something unusual. Specifically, hole punching a gmem fd while
> initializing the TD vCPU. The impact would be triggering a KVM_BUG_ON().
> 
> The resource being contended is called the "TDR resource" in TDX docs 
> parlance. The tdh_vp_init() can take this resource as exclusive if the 
> 'version' passed is 1, which happens to be version the kernel passes. The 
> various MMU operations (tdh_mem_range_block(), tdh_mem_track() and 
> tdh_mem_page_remove()) take it as shared.
> 
> There isn't a KVM lock that maps conceptually and in a lock order friendly 
> way to the TDR lock. So to minimize infrastructure, just take MMU lock 
> around tdh_vp_init(). This makes the operations we care about mutually 
> exclusive. Since the other operations are under a write mmu_lock, the code 
> could just take the lock for read, however this is weirdly inverted from 
> the actual underlying resource being contended. Since this is covering an 
> edge case that shouldn't be hit in normal usage, be a little less weird 
> and take the mmu_lock for write around the call.
> 
> Fixes: 02ab57707bdb ("KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table")
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> Hi,
> 
> It was indeed awkward, as Sean must have sniffed. But seems ok enough to
> close the issue.
> 
> Yan, can you give it a look?
> 
> Posted here, but applies on top of this series.

In the future, please don't post in-reply-to, as it mucks up my b4 workflow.

Applied to kvm-x86 tdx, with a more verbose comment as suggested by Binbin.

[1/1] KVM: TDX: Take MMU lock around tdh_vp_init()
      https://github.com/kvm-x86/linux/commit/9a89894f30d5

