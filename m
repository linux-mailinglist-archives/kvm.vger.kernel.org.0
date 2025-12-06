Return-Path: <kvm+bounces-65436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DCA8CA9B8B
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:32:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF188323807A
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB17830F52D;
	Sat,  6 Dec 2025 00:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iKSVd+rd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B32530CD8B
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980336; cv=none; b=osqcML5o9ITK9OSvq9yrGXgyV9/oWjRnHfcEW0p5BU2G5iZMTdZrUnRsnBJ/2Ju4SWrcKh0Nfq6CtNgQC7Y2cVyi4SqHG6CznXohufniarzhb3BiR0qcay+I7woKI64F9KJoVY173c33WgbUk2IT2J6UhMyw9H7Z+ugWdTHzHRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980336; c=relaxed/simple;
	bh=EbuHjkM11wJSgkGWY2aSFlMpNr7gwy2PyHzdmFLt294=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cilu/f3Kpz3cZhu3V1ZK0mLptnba6yliO3nAyfaU9roa0sanfDtWZbAYbepnDx2HMMpwLUtr0vD92+6m7i9rUpmpAXhGyZKlFhVOArfn/winlUSF2A5fKMLUjJR+ygIkvBc40pd03X5dNW9ZtV+tohZezXL+3j95ASVbs2QoIYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iKSVd+rd; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7c7957d978aso2757648b3a.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980333; x=1765585133; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=n8V9DDSigR69uE32CWTID9idTpYitJ2rw2w6q4YtJdw=;
        b=iKSVd+rd86Opv0mE38U0ubpL+DeS273fzlevHCCHWm4bq8qBj4Z7SYdKpUkzVJO/dh
         2G3Lmxw2qQW/SSW4FAdmJnOxm8Bb5X0YM1bJJQ8KmSKdvfCHYLlZ6GkZeYUPPHEHGQfh
         p3qKRmww80TkTY81zwp2rGZI1VJ74TweTrE+ID+RvPmOk++z9YKJYKGhjuejfEIHcJCp
         BTGR6TXuPxC4QDdACkE5tvaH+SMyW+iSan1OzQCjafUpvGtzqWv18woR6bZRm1VWkS3e
         mAtlZ9J+6oOD1wBYA51YJ9VqPTbcAgC5pJh2Z+NYfnO/ZsFRTXMlwTsgsTWkcZthrZAM
         YfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980333; x=1765585133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n8V9DDSigR69uE32CWTID9idTpYitJ2rw2w6q4YtJdw=;
        b=CqiPjm+r56D7sfNuhXRJ0HbgbswzcWCbi+aMxkPpFuLOnVpoIx2HE+ReDSqjPhyIWx
         ElobI355vg4Z8wq8YRaakKP4X+nPiH5pbMKRuMZB9SWdDwZcxWni3kKXbszly+027meN
         83m9fVFD7DadXTRRFOLC8G3hy17aEHFpvbpg3GHjXroO2gRBLETjhzLNPGtbyrSnlAly
         PSjewwwhhl2HHarAk7psvvmmS+J9MO8aS63o6pJvAo/4QrELb2q712ywf0rVettg5BRI
         iNK03dtvacgLxNGtj3LUkpHYYMxcdUBEseVLMGG7q0am13rVsrYXpbcbW5m9Z/BY0dn0
         4Ctg==
X-Forwarded-Encrypted: i=1; AJvYcCUG+WlGZcHL9AcKXzuk/REapSoTkD24GBTMdUnVVSThzWYh6szakngcoRnahc5B+YJp1No=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6jjjAtnufNbDJM9WZphoPagduFY/LY7tFowS0mWOEXdZ/so1j
	coTRxMvslbAK6nuAk16PkFxuDqJUKvhnSS61SVokcFCF0ZSiRkmaF9HFaXwCJUXVXK3RRYLJFRc
	7a6DhtQ==
X-Google-Smtp-Source: AGHT+IFvgfK2a2snqIy1Rm8aE6qptyZkQEpan42/+C7VOcIZpnFc5T7dKOJ6QhHIoZwkwV6ZMBDtCsCouY0=
X-Received: from pfbim5.prod.google.com ([2002:a05:6a00:8d85:b0:7b0:e3d3:f042])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:888d:0:b0:7e1:89ad:991
 with SMTP id d2e1a72fcca58-7e8c6da8d28mr855283b3a.32.1764980332931; Fri, 05
 Dec 2025 16:18:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:19 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-44-seanjc@google.com>
Subject: [PATCH v6 43/44] KVM: VMX: Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR
 with list address
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR to point at the vCPU's
msr_autostore list in anticipation of utilizing the auto-store
functionality, and to harden KVM against stray reads to pfn 0 (or, in
theory, a random pfn if the underlying CPU uses a complex scheme for
encoding VMCS data).  The MSR auto lists are supposed to be ignored if the
associated COUNT VMCS field is '0', but leaving the ADDR field
zero-initialized in memory is an unnecessary risk (albeit a minuscule risk)
given that the cost is a single VMWRITE during vCPU creation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3f64d4b1b19c..6a17cb90eaf4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4933,6 +4933,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(VM_FUNCTION_CONTROL, 0);
 
 	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.val));
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
-- 
2.52.0.223.gf5cc29aaa4-goog


