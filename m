Return-Path: <kvm+bounces-54182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35AACB1CD1B
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5369E566EC6
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454F02BEC59;
	Wed,  6 Aug 2025 19:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IYnVlROR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206392BEC3A
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510324; cv=none; b=U1WfJv5l8V1nWt+QbmcpebhuX5Rv1riHPg5MQ3y6zAQOKavv/ckVjUAOsjyTVg2B5upcOo12Imz7vhKq95wWGaaiPzlYRvcJEVZ6WMso0oyQ+pcX0CG0SBwvXGoddloPtAZftq27E4vL2wTCYpfEGXaR9sgvab7ACmkIF5jSSIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510324; c=relaxed/simple;
	bh=pnnkC1bAXhozYLn1+A5GeTVXCux318fw49cZ8cqaQ5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gkmlmEBSXMr1b7f6ImX1gavrM84Rp2rixZfHLlR6RapkSsVKkPMJ5MxigfOqJyCrKlTyudGfQdDWgS33w4f0nyn1q0BJXn6NE2INVoJgGB9C+Fd6PHa0FJK65Ad3/nrvVVvLZZCvwj9Uk4twEfgbP5HSPVsVD+cKAzXAagIYUMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IYnVlROR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31effad1358so224091a91.1
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510321; x=1755115121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RsFIN1Au3Dl4zaCmP13PW3DAgvYNBzVpKCYeyT5lYGI=;
        b=IYnVlRORAOh1paTIK2Lm6a8cAUBbjU6mYFNK46LfNaO1qKv1SZBsHSBBwZr3wrPEI1
         5pktWiRCNbCJrs8AOBxCOjMhGE3//vWjdJA9Ypd6FdVC7yJR+zALuPIIUYEy0qvUpTqC
         Qm2wPWFU/aKVi2xwFE4P/ntTogfYPhM9kIMlv2Hp3TOQGui9gLeaHBQUhi4VxF7aQjd4
         HTTnLb2dHPP9NNwaoCc4amb0JNEskMzjI0UnJQQNzjZAaZfuPgC4+DQyIAGjvQfiCADQ
         qqs0KUGp7RymYMbO8ErKcYwAHz8aP89ZPnbMp8rapq6g4gqrvnrqtg2Br/8KjfAwkgcp
         x2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510321; x=1755115121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RsFIN1Au3Dl4zaCmP13PW3DAgvYNBzVpKCYeyT5lYGI=;
        b=eVOJd2pv0RXroa6GMqQRckeYADIRBf5BwQYG0V/olPwgngzMF7wGyYVzKVarSOhNWL
         ECYu2Basux2/AlDx71WMIwqiXfGQ7QQIawLAmPiQOExOvmr+y48WpmSxxhng9uxHdO/X
         H9sXWUbV+vIyPUdgI9HJKE5oC3LitUKyZTx4HewgVzgtzaAb+inWRDdFFrG6ajH5pL04
         BaZSH0SDtcNbn+tjCpXqO4Ko2BCUr3+8d+0kF8lFNByyR9QsXY5c8Shv7fomnGJLBQip
         cc3X36DPbrt7nD9PCJbKSr+8xVxeWQMb1Q1iIthuX3HnKxntfN39IBYSxG3DnOGXILaw
         N+AA==
X-Forwarded-Encrypted: i=1; AJvYcCVzh7BmjF5SOOjI1Dq95m1sYPCy1+vW0z5x1oQt3d9tsuTdHDFW1NY+iLvjq4pdddXyFsE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0cv8uKw/vmgedahOvE2a9LEJdxNbIqdphMqPrBAGzB5A6S16W
	ieaQN9rFmki8ZPtQ9EzOg/MMXNtsedakWtrHtdOqMa8SCrYdtPYNQxc53g4aUJhHKIywRaGWHLf
	/t9Gy2Q==
X-Google-Smtp-Source: AGHT+IFbNifUFnJxYDSjClZPGiWnx/CS0ykT/Hb3U03iCPY3aeaisiXn0lmHgRNeXCjIQ2AkJAWL4xb8X68=
X-Received: from pjqh12.prod.google.com ([2002:a17:90a:a88c:b0:311:d79d:e432])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c07:b0:313:aefa:b08
 with SMTP id 98e67ed59e1d1-32175622f9emr956977a91.16.1754510321187; Wed, 06
 Aug 2025 12:58:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:57:02 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-41-seanjc@google.com>
Subject: [PATCH v5 40/44] KVM: nVMX: Add macros to simplify nested MSR
 interception setting
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Add macros nested_vmx_merge_msr_bitmaps_xxx() to simplify nested MSR
interception setting. No function change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index db2fd4eedc90..47f1f0c7d3a7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -614,6 +614,19 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
 						   msr_bitmap_l0, msr);
 }
 
+#define nested_vmx_merge_msr_bitmaps(msr, type)	\
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,	\
+					 msr_bitmap_l0, msr, type)
+
+#define nested_vmx_merge_msr_bitmaps_read(msr) \
+	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_R)
+
+#define nested_vmx_merge_msr_bitmaps_write(msr) \
+	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_W)
+
+#define nested_vmx_merge_msr_bitmaps_rw(msr) \
+	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_RW)
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -697,23 +710,13 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	 * other runtime changes to vmcs01's bitmap, e.g. dynamic pass-through.
 	 */
 #ifdef CONFIG_X86_64
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_FS_BASE, MSR_TYPE_RW);
-
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_GS_BASE, MSR_TYPE_RW);
-
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	nested_vmx_merge_msr_bitmaps_rw(MSR_FS_BASE);
+	nested_vmx_merge_msr_bitmaps_rw(MSR_GS_BASE);
+	nested_vmx_merge_msr_bitmaps_rw(MSR_KERNEL_GS_BASE);
 #endif
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
-
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
-
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
+	nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_SPEC_CTRL);
+	nested_vmx_merge_msr_bitmaps_write(MSR_IA32_PRED_CMD);
+	nested_vmx_merge_msr_bitmaps_write(MSR_IA32_FLUSH_CMD);
 
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_APERF, MSR_TYPE_R);
-- 
2.50.1.565.gc32cd1483b-goog


