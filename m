Return-Path: <kvm+bounces-65423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 44925CA9BBB
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 895C231A6E2C
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90072EAD16;
	Sat,  6 Dec 2025 00:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LPeIErv8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E6E2F3602
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980309; cv=none; b=OI5eLnfrYkrW4xSf62TivGi09GrYeDPjbxDMKBcU3C8M/Adun2TDkLrb3SXkb8qWOv+Vo/8HIbuJgInQX9Pi/JHKDjZ/CyulRNF5hLySoP5LNl3g0LrWIuBOeqyCLcb4HpnlDroLoDK7rUpksJQRHR/Bx+dq6OOutq6JRf6KzxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980309; c=relaxed/simple;
	bh=XkalrXDc3Qa++HcZCT+ub3/cOt2TlQhCgor1dl+ppOo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cTyVWyF2Ao1k4B0tBbsMPiz1yYedCn34LBpeCUcJDRB57RXZpUorBdkZmIEJ5Bmg3Qgf1UnENq86Yftx238PELHSQ3Wk4WtOUCiLuEOyhv2l79Oa96q8on7/4rHgGEb/IbnYOscSSGnXR+6xSnFWKDdSBThaSl9NE9Hm1nxaL5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=fail (0-bit key) header.d=google.com header.i=@google.com header.b=LPeIErv8 reason="key not found in DNS"; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295592eb5dbso46086765ad.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980307; x=1765585107; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wDDQncQUzzwpRSzzmwHiRYOU7FF2nSUQYIeQTrnvQK8=;
        b=LPeIErv8XJaCf0GqhOGvqDME4xx8RaSPLGaW3LW84EkpdR2n3FnqBLAglxLF22IHCv
         QP2GKLEBgciOSXlBqVcgkgsCnfLLFP3kwcqXuUmwbLB+doE8UmtE/in7ysQxHEeWM7r7
         lZVIgCDhFFB4W+IRE0jSon7CR+83XnwXAlAFhKdQFJpH/004PS9bT10HxZWJ4lVSmBD6
         Mc+xYAWvOjPZSR7i+tRyJy6x1CB2x/Qyf4CRd86qbza3CkCngFCd53RFJh2/H4OMpo3e
         kbBS3Tsp0z4rfXdMehjFpU+gQvQ5GL/HUcp60xMPQI3MMjj0ExVJcJlWVIyR9lfnn5ZG
         jOiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980307; x=1765585107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wDDQncQUzzwpRSzzmwHiRYOU7FF2nSUQYIeQTrnvQK8=;
        b=fsmtDg3KPLUjActzHETxT/UaUNEiZpXfeZ1+VAvCtyRbLr4ovzJDX92Zu+RdXpz8P4
         b98FRo0SvymDJayTrWevZOQGniFh3ds+M5bRn13uiqMz01cFrF2YxsdHTO+j/iBRRAud
         6Nv0KcMg3IvPSRLCedPqVrJIDjMRzMCKt0OGyTMFECbp1royl2MNQr5c2XbMQVSPu59l
         SmlklqEsTlGSI5LNnB3QK6nsJRucBzvUTD+mzRPkcPeB80LniyY0KSE7JjlzJjgYcoVC
         NWMUMUaMvkG65hxKAl1kmisxG0Cw3jC387qIB4Bnj9Zp0HK81M1w9/RIswRSi2V8Z1SX
         NKXg==
X-Forwarded-Encrypted: i=1; AJvYcCVCHNHH/PsNBfKbOwDRqhRjyOp5aeE6cbWXxc3Ut+plrglOx+5UbOxKxvb5aR06waZqj9A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yze6SJaCXcpmGhxxdjPD2EKbm5Ejf+X+zRlT66uBxtZ9MIoncYs
	RDk7fFlt1DeOCKZ1O+F/2OLJAwtY4gPqYR6bF7Swgk3EpFvMGzNfFFKllwMXX05u0atV/tK9DKG
	Ht+sePw==
X-Google-Smtp-Source: AGHT+IG4vHPmom8LOFsNf9ubPRsWVZC6RkdL55O4HgJ6N06qyh5/Ls7bYlKNT7sQNBmfh9FVeBcsEGoEIG4=
X-Received: from plhz1.prod.google.com ([2002:a17:902:d9c1:b0:298:51f6:847d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f84:b0:294:fc77:f021
 with SMTP id d9443c01a7336-29df5deb193mr7205895ad.49.1764980306541; Fri, 05
 Dec 2025 16:18:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:06 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-31-seanjc@google.com>
Subject: [PATCH v6 30/44] KVM: nVMX: Add macros to simplify nested MSR
 interception setting
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Add macros nested_vmx_merge_msr_bitmaps_xxx() to simplify nested MSR
interception setting. No function change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 40777278eabb..b56ed2b1ac67 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -617,6 +617,19 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
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
@@ -700,23 +713,13 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
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
2.52.0.223.gf5cc29aaa4-goog


