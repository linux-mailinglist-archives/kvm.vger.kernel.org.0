Return-Path: <kvm+bounces-44953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1588FAA5251
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:59:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 660521C078C7
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0792741B9;
	Wed, 30 Apr 2025 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ch2oQ6RN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26754264F80
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032245; cv=none; b=AUhGFuSKVPRoNWoC7Bhu0yd98DhknEnkosVrnZ5EXQoreyHszBX8qsr+lO0K1Z88LmI6GCwxK6d+/RmAvl3gjlegcN+V9KqMWjv4ItAzXLO6tK7BjmkiIjk3QxeG5Wynw2f/4kS0FEmaF67F4OqbuPPlDOc7FzL/cziUdJIMASM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032245; c=relaxed/simple;
	bh=XrKt/cQ1PJ4L8WD+acL5St80qFJz8v71jskxh3LK1WE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H6Lhbqnrgc5ZbB37hptpJ5E/Ft5Sa2+MWW+jJpbXQG0AmKV86j9MYiwLSX2HBmnRn5Hl4nNi/MaSBIL8oiTDs+WQFQ/3A2hq64c4Lu6eLLsbSWqRDjO2BeMUixlTpeWaPbrb2TtePG31vGxvkoo+0Iqg7qzJvT1VXytVR56xSYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ch2oQ6RN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf327e9a2so78535e9.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032242; x=1746637042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r8U8U1nhHclBviWvD96hvtWkHURwDxBT0dCfKidoius=;
        b=Ch2oQ6RNjM2pdVaWRzVFKWDiH6e+k3DqduHifO0ks8nBObuLR+t+zniR/gVGPDljoJ
         XJWGhfHutNC2cKnJhGM3p/5ZfUrgqze1QrRnLyeJgHkacRnK3h5CinxxtmdI9FSmg3/Y
         zrpHJMYlqxyoY0MAI9yvG4+0pXx5mGsvEUPERmu5WRMILZLRINzrOxrMwPL11GJMA/1F
         cS8ojRcl3zBqcrzmy83mYowcSbQ9qm4Ks1wDGNpQl3V/AGkoUe5RZAehnz0JZ7bPKcUE
         JsjFjZv0/Ak6abkELIIqaVwBEeQ1TyuFW4G5Ox9lKCt2087PJmUyMnJTwYasIcFLAdHa
         ypQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032242; x=1746637042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r8U8U1nhHclBviWvD96hvtWkHURwDxBT0dCfKidoius=;
        b=RfRd/NI7RH61n+XRrYqhCsqc038cjCGmiKoj/ilneTwbTpdck+JOIGm6U9GTmzMRPr
         0Bs+U3w//rCl0NrM1r32phXmOE1nL1kdCd8Hx1WCvw8XUUO5lJFBKau85mDqfGQryh/S
         NdUdcZzV7MT4tCQ9kWgvR+JkejkJ8UvlzDuUf0Pglun3yW13e5o5l9kv65zcyAVSR7Fo
         tBtLjYhg6gR0oUJqGOJG1DmXrz3HZN7dvRS0F9yO5HzS3Tvb6FTfsKtmsOfJ/kG1adsA
         lK+hhSFf6q9OJYum2/5q4jIugqhs9BPy/TvrizNoIjwH6ZJ/A1Dfpx6asOn6Sebq9zDt
         z6Og==
X-Gm-Message-State: AOJu0Yy3WyNVWyfer7AQb7UVB8pi9LPbmv6JFR9fz9afvVtDR8YeNFqU
	FRtF2InYKuoq0Lt6peY/xI4zEUg+l+BRjP4NIk/an9EEvL8/vy/ei0xDAHckc03X8Z7EDhnGIsA
	8gbpW/csKDgO/JgsSmXbqSuA+0OEmie1RCu5TQ3ODann641fp64qY/WVfFfVTWUn9zIoGQ0xVmx
	pooHUyyjJAk8Mv6n35OnbfLlw=
X-Google-Smtp-Source: AGHT+IH7GwjRIYej47ad9eSczR4IN/8XTDl2Y0w5DE8LJkqljmss+RSdA/meE0fu/iiOZNhdn1995hFeMQ==
X-Received: from wmbep11.prod.google.com ([2002:a05:600c:840b:b0:43b:c7e5:66e0])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c12:b0:43d:4686:5cfb
 with SMTP id 5b1f17b1804b1-441b1f5fc52mr33367835e9.27.1746032242127; Wed, 30
 Apr 2025 09:57:22 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:54 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-13-tabba@google.com>
Subject: [PATCH v8 12/13] KVM: x86: KVM_X86_SW_PROTECTED_VM to support
 guest_memfd shared memory
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The KVM_X86_SW_PROTECTED_VM type is meant for experimentation and does
not have underlying support for protected guests. This makes it a good
candidate for testing mapping shared memory. Therefore, only when the
kconfig option for in-place shared memory is enabled
(KVM_GMEM_SHARED_MEM), mark this type as supporting shared memory.

This means that this memory is considered by guest_memfd to be shared
with the host, which is now able to map and fault in guest_memfd memory
belonging to this VM type.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 709cc2a7ba66..1858dde449c3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2255,8 +2255,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
+
+#define kvm_arch_gmem_supports_shared_mem(kvm)         \
+	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&      \
+	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM))
 #else
 #define kvm_arch_supports_gmem(kvm) false
+#define kvm_arch_gmem_supports_shared_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
-- 
2.49.0.901.g37484f566f-goog


