Return-Path: <kvm+bounces-49538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E4E6AD982F
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 00:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 381E94A0D2D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB87928DF07;
	Fri, 13 Jun 2025 22:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AJOv8mRX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CFE664C6
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 22:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749853479; cv=none; b=dSnJjVZh9ZklL4xx9GFfRDjIMZVDPowShw9QUOx5kiVZLEVVAeCDafNGGymJpqIoAPeeLQww4VEUNCwZ6oP39bDhvIEtaLPVvT3xjEpvNZCVOaEcV5TH7IdIDVhYdwMDHJ76gA4hszHnBkqY1CUHxL0SLKVZQl/DpgKOtQkROGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749853479; c=relaxed/simple;
	bh=iAiXbggyWiGI0ioNYNwEycoE8HyP8uw4mXPc+k3TuM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Aj9gQm74ahE3oicsW7+3ywAGLSPYLIo/vI8JWHpooVeZ/Ire0Fxo9+WFnZmrS3o/wkJbw2cCxBTde82rIRSQKuFJU44po7He00w67YJHdXnLb+pB8ypYb4CN3cp3m7Dqu1VW3JEKaS1WtbUekY2uzjJC06H1HxBOjY1E5Kgydy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AJOv8mRX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747dd44048cso2380961b3a.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749853477; x=1750458277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0YOAxGP+nhc8ChKM+S2z9sIC/KGH663HFb+/wtYtlnY=;
        b=AJOv8mRXmAln9yfTXD82sf8YMbrouEOsZp+n39gEliebib9jzxT5TBB9A4JYr98kLm
         b+cqMLZZPmdNv91YbWlmxy690ZgXVcpY2Sv8HKS1bs3FkdB1YNbUj2eoeDyUUF3ZM69V
         yPGBBycE11ptOnAeMB36fGZOUulP2uNOO+S4vw/OAS8LfZfGafluYfjCUI2xTfk2PeTX
         0HFy9bi3R4CRNhVet1DhXE+NddDK1qbYvKxazd1+Y9yh11mOrB3jqnKvFVlEsUrXLOnT
         w7XDPlETGdQWlcb4OgU/+DmQbBqjJ5Nbmf72shEiuOH4WhXnQL5lNKI0MOyWlrc6nUmt
         CI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749853477; x=1750458277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0YOAxGP+nhc8ChKM+S2z9sIC/KGH663HFb+/wtYtlnY=;
        b=N1AWPbIiEO7JsL6mmm1/2uVJf6LRxx8OZzczQOjhITBkbIqrsOJmKaB3qE7Nq8uSpF
         m0Zf4+XTtyw3NlYEUBD5cfHT7H+DGGjkf6Qd+c5aArYneQxmeuoKAxFxM1WG6rB9TbaO
         y1Ap41W7/eXSEkF0MpZIoPpCY/S38f5bIF8wyNBskLhFhgp/oV8Pi696IyiWfBm+LmGU
         2v+ITO8MOz4SMqHnuikbYoOl1WXUrUZfpz0PSjDxr9Hmn+yeldbrFNqhsW0XKssk6ywD
         qDqqsfFCIek5WjnkSC73J6t3rSAj5kGo+MKk+x11cSZUwyfJiItJVAEUeshD3m9M9y4/
         fxNA==
X-Gm-Message-State: AOJu0YyK2SkFefFI901HbktU67v0L3zEKNgdVDPjJD0q8nRoTyILIaLg
	X+MDu8WYjdegbNsmBT1poV3S2+J08YiQ28UtGlO+f+9AFhuneJuBhylr1Uq0VitklajMZrz1JSz
	DGGf3Aw==
X-Google-Smtp-Source: AGHT+IGbqYy23e2CHK855fCtvAevGSzZ6YPVzXdykpUR9oW6FyFW+cX08H6Q7LBbZi1O5077fivPLdXXKLY=
X-Received: from pfbha10.prod.google.com ([2002:a05:6a00:850a:b0:746:1cdd:faa3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f95:b0:747:accb:773c
 with SMTP id d2e1a72fcca58-7489cfff3a7mr1243026b3a.13.1749853476803; Fri, 13
 Jun 2025 15:24:36 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:24:35 -0700
In-Reply-To: <CAJZ91LBYBVexcOpk6zqL=mup8VJ7RDEepHk+0Y_GDt5B2+8iyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613111023.786265-1-abinashsinghlalotra@gmail.com>
 <aEwualvoLvbtbqef@google.com> <CAJZ91LBYBVexcOpk6zqL=mup8VJ7RDEepHk+0Y_GDt5B2+8iyg@mail.gmail.com>
Message-ID: <aEylI-O8kFnFHrOH@google.com>
Subject: Re: [RFC PATCH] KVM: x86: Dynamically allocate bitmap to fix
 -Wframe-larger-than error
From: Sean Christopherson <seanjc@google.com>
To: Abinash <abinashlalotra@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, vkuznets@redhat.com, 
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	avinashlalotra <abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 13, 2025, Abinash wrote:
> I am building the kernel WITH LLVM.
> KASAN is not enabled.
> CONFIG_FRAME_WARN=1024 (default) . I used defconfig -> my system config ->
> oldconfig to obtain the .config  .
> EXPERT=y So KVM_WERROR=y
> I think this warning is due to FRAME_WARN=1024 .

Well drat, it really is just KVM_MAX_NR_VCPUS=4096.  Luckily, it's quite easy to
fix (we already did this dance for the sparse_banks):

Side topic, please let me know if I got your name right for the Reported-by.

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Jun 2025 12:39:22 -0700
Subject: [PATCH] KVM: x86/hyper-v: Use preallocated per-vCPU buffer for
 de-sparsified vCPU masks

Use a preallocated per-vCPU bitmap for tracking the unpacked set of vCPUs
being targeted for Hyper-V's paravirt TLB flushing.  If KVM_MAX_NR_VCPUS
is set to 4096 (which is allowed even for MAXSMP=n builds), putting the
vCPU mask on-stack pushes kvm_hv_flush_tlb() past the default FRAME_WARN
limit.

  arch/x86/kvm/hyperv.c:2001:12: error: stack frame size (1288) exceeds limit (1024)
                                 in 'kvm_hv_flush_tlb' [-Werror,-Wframe-larger-than]
  2001 | static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
       |            ^
  1 error generated.

Note, sparse_banks was given the same treatment by commit 7d5e88d301f8
("KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv'
instead of on-stack 'sparse_banks'"), for the exact same reason.

Reported-by: Abinash Lalotra <abinashsinghlalotra@gmail.com>
Closes: https://lore.kernel.org/all/20250613111023.786265-1-abinashsinghlalotra@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++++-
 arch/x86/kvm/hyperv.c           | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 330cdcbed1a6..12edf36d4ed7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -699,8 +699,13 @@ struct kvm_vcpu_hv {
 
 	struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo[HV_NR_TLB_FLUSH_FIFOS];
 
-	/* Preallocated buffer for handling hypercalls passing sparse vCPU set */
+	/*
+	 * Preallocated buffers for handling hypercalls that pass sparse vCPU
+	 * sets (for high vCPU counts, they're too large to comfortably fit on
+	 * the stack).
+	 */
 	u64 sparse_banks[HV_MAX_SPARSE_VCPU_BANKS];
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 
 	struct hv_vp_assist_page vp_assist_page;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 24f0318c50d7..75221a11e15e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2001,11 +2001,11 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	unsigned long *vcpu_mask = hv_vcpu->vcpu_mask;
 	u64 *sparse_banks = hv_vcpu->sparse_banks;
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
-	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
 	/*
 	 * Normally, there can be no more than 'KVM_HV_TLB_FLUSH_FIFO_SIZE'

base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041
--

