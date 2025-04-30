Return-Path: <kvm+bounces-44952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E7FAA524F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D35A31C07664
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429D4270EBB;
	Wed, 30 Apr 2025 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yCk8t83G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C444C26C3B5
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032243; cv=none; b=MqAZrSRh19R1CuZZ1NwJ+4JffjXqJOH6ZxNLUDC2jRQoN71DLdz31a8JabFRVe+HBJ5nBKTZUnCFTX+b9I8CJNnA0v9oHchYOY6O7LTszfd5dei1ZuNTy0juggG1P+g74c9ikkOA/pI19wxbcoZp+QHjMwciTXcJ7JM97HqHL4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032243; c=relaxed/simple;
	bh=zT3f53bQYwYRMiDbIzuNcOZPjcOyX467WnIVdZBFCY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zw7FNb/4ZPr5HvcU/zpSDfXEII+Q+nc6noMOt0OOQnhBJ4JCVarAu6WYR8n0T9nqvWJSSUlHK5OEOohr5FPl/WlBpIbmvRWL3/zU2Jx4gJLC6XUjTOZC+6/gwRRPh9Z0dtaUwCVpbm/k7vBWbkdy+UdfQXyCmMXqEJaBhVRWo64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yCk8t83G; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf5196c25so150675e9.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032240; x=1746637040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/dUU1YHD6BOP4+jeLnrgluDyscgK/772S0e/eaG98M=;
        b=yCk8t83G42lLpvQIQYfZ3ZMYPpWqGDp6tbg7TKcIRgqQcsctARYz7UEkXr0nEeAoHa
         N3+9yUx/6wIWvvB60QIQkSnsZDvhrw/Pv5Fjmuu4HdeIsTLV140E3csY998cvPJ42UQE
         WbbKaU34qR3FNKZL7za90no+K+knrZTZepEf4SB6eiM3/uHofbBYgyWTTEevsFSeRIdy
         UyPJlfRYY2IyAXxMqhaEny3ZK8jXD/4ThQk1NgwASBv+wOql1PAnVcDls8MWA5qiCnGl
         FXNs2Gv1bIayB8N+FcexescqM02QGTWDjJ9rM4zJV9PS17xthY9SYdqi6SZyT57SJXGU
         SfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032240; x=1746637040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/dUU1YHD6BOP4+jeLnrgluDyscgK/772S0e/eaG98M=;
        b=u0DTDpDonD3nrH8Bz4BqWnURKMQJs3ZgQ+lh9hzJlkoQ1sSyN8ttKTbFTA4CHf6joo
         5OYtEifAKHnpRxZwt/pgGgg9vFT+WkkHfyQaPraXGJ2ngmZB62Snpm8YSW7wuR7GHbqh
         YYKvd8I6YlrEke/W/2kg+3dIe/YURsBhw+yZnVbP2PedvNq1KGds9+JnYkIuGvP3dxgr
         ieX8P68ygcMUJBE6ban91VsY52vgEe8WfGYtE6/XQYUb+RutRJR4mWaqMD+4TMWRt0M5
         0vVRYC6vH5MTTHErd8OwWXCUKB5cLmHYmQDx9FKWSF5hUphUN54S5fF045yRWI5/NW3s
         nHQQ==
X-Gm-Message-State: AOJu0YyOPvYibeB0C4fvzNb52/lgpxRTTa6ROm/Nh9B/T6gOXy86/lBV
	vPGk7mRRoyPEzupIAL3NgkPPtv2sGprgbgKQSLL6JytMABCexoMWu62U1YJdykwGXzmyFNJ1DSR
	A5HLScrpnBG2f6oYw8pPuLtVB53gTUZN4ZlVIJoBnTbgRtsXMLMpwMCDiUKMu4L5V2X4DmY8cIF
	zWgTTpIkZFqqdfNLhoIYXzUa4=
X-Google-Smtp-Source: AGHT+IFYYSu+z7lcdTevEwKYxKvR0BM42N5Yxez0Q/Zy8BqAGBeXJPTD7ox5Spif8yRdhs0jTp5x8CQKow==
X-Received: from wmhu3.prod.google.com ([2002:a05:600c:a363:b0:43d:1d5b:1c79])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:35d2:b0:43c:fffc:786c
 with SMTP id 5b1f17b1804b1-441b1f3ab0fmr32935775e9.19.1746032239805; Wed, 30
 Apr 2025 09:57:19 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:53 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-12-tabba@google.com>
Subject: [PATCH v8 11/13] KVM: arm64: Enable mapping guest_memfd in arm64
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

Enable mapping guest_memfd in arm64. For now, it applies to all
VMs in arm64 that use guest_memfd. In the future, new VM types
can restrict this via kvm_arch_gmem_supports_shared_mem().

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++++++++
 arch/arm64/kvm/Kconfig            |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 08ba91e6fb03..1b1753e8021a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1593,4 +1593,16 @@ static inline bool kvm_arch_has_irq_bypass(void)
 	return true;
 }
 
+#ifdef CONFIG_KVM_GMEM
+static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_GMEM);
+}
+
+static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
+}
+#endif /* CONFIG_KVM_GMEM */
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 096e45acadb2..8c1e1964b46a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_SHARED_MEM
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.49.0.901.g37484f566f-goog


