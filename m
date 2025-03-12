Return-Path: <kvm+bounces-40844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13441A5E347
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 488C5179962
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD0B258CD8;
	Wed, 12 Mar 2025 17:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K6xosv+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BC12566F4
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802321; cv=none; b=THjahWwkwLBqqYCDfJ5jGF4cKL7dVWbPKCxX3vPGEZjl3gK1hlZbn0CoR8DjW0mqMpirOIToFlRPTYt6epaebGo/j4Wz/MTjvo/rj/h9F3dA44o5z/4wBY+RGUMc7m4Qu+XdhVaP25KPbnVyPe3f+oIKm/6wyWDPzAV0SV7KOQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802321; c=relaxed/simple;
	bh=tZucr18dFkzlB3deJ6wbqtZ+bsyrb7slNtwTBa7RNbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lTlR4ctmI52Dr3ElZvri29JiQBaoiK5az5QkcRn9o5xu2TfE+FB3zvyMHkvBfSjZ5HQzWEXqRjM17r5bUs1VuCgWVOcIsJOa7KDWm6w6RrOYLoNACW0njghTFdILDisudVUjYWdz89ZiR10EpG4qb39O+DlmtX6raZnTJhSFSJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K6xosv+R; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bc97e6360so310975e9.3
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 10:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741802318; x=1742407118; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wx8w/RZ95u4Jazhb7Dc1SjbWTPE/GXa4O3urxkMUigQ=;
        b=K6xosv+Re/1yS+0++zsehDJXwpa8iLxb5wcADpWixPHIAXnM8R+3bgiRDLALiv0E2y
         Shiazdz1GuLqxvbXa7Zdjkrx6FGFMQeBFXGt2fAQIJlcN9W4iOnRNZlH5+WoH2sNfHYc
         vV5euj1zKYMe6AuPDzBg+6u5eyF9uqBVqqBRY9QoSvzIwCOZvEbCGfKrnEf+mCraEnFK
         deoMnnxESQ9KjBm6Scshx69YYkuvyihnSNy2jJttu59PmdrxZ/Qc8oRpAhOAhHAOs1W8
         1z55RxSNGrVOLrVRuApT/yr6Pe0Xm+5Kj5fCQA8aM2Z4jgHP3tTvWG0HNIgNzMoKrtLU
         UUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741802318; x=1742407118;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wx8w/RZ95u4Jazhb7Dc1SjbWTPE/GXa4O3urxkMUigQ=;
        b=ggQf/qzGmDah1JKv7UhLpifGNu4FMKtylydZ+0M9KQTxt2hiMLC0rJ5TYitiN7/q44
         HEAF2r3fRiQGo6eM/WZNPCr+37XnogTS0INVoG1dDe6+LAd/YJlse531OjzoukraVhKC
         2uYVRqJf4+qlnAoPpPnHkPiwjSAN/xXpKFinOlmtDoLf/pog93xAmRKjrDk7HuQvaAo3
         tW0I5g+ep0gf7ndBpq5l0dUezcwLK4sIZf8dIN+ScHmRSHgfyD40uIGgfnVIdiLkMfBn
         /5s1sF4G7TypyNz3uuc5Ihr3IcMWHJJXh+5vqR79U7iBL5Lsars8w68PXtHdIBPGpUid
         uQ1w==
X-Gm-Message-State: AOJu0Yy8H8EOU8i0GvGl/Q2fRR01aWsxkO38v+aqK4Uu+C83D3Fe2DgJ
	78YUGlI60WUTSq38qiDw8Oq9ppkP+9lq4giXl7xhQ1NaoEgKoiiWU+llVduREtXf86FY4a6fs3Q
	ugKBXH68pChgTXXNDD5QxbzWAFbMV5K35RKfktNZdKwI0wfCbSSpHo1DZl2l0trh6lqSqREIOpz
	zQgVaTiYd8YoiZ0UnVv5S6vpU=
X-Google-Smtp-Source: AGHT+IFJlj4nTok+ueA0jACRwns8uL5LH08IddJBcx9wqowAWc71zjFE+8nTZuhjVvmJcfe8xTEJ+RPsaQ==
X-Received: from wmsp15.prod.google.com ([2002:a05:600c:1d8f:b0:43c:ec4d:6037])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fce:b0:43b:cd0d:9466
 with SMTP id 5b1f17b1804b1-43d07fd485emr45933555e9.9.1741802317784; Wed, 12
 Mar 2025 10:58:37 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:58:19 +0000
In-Reply-To: <20250312175824.1809636-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250312175824.1809636-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250312175824.1809636-7-tabba@google.com>
Subject: [PATCH v6 06/10] KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as supporting
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The KVM_X86_SW_PROTECTED_VM type is meant for experimentation and
does not have any underlying support for protected guests. This
makes it a good candidate for testing mapping shared memory.
Therefore, when the kconfig option is enabled, mark
KVM_X86_SW_PROTECTED_VM as supporting shared memory.

This means that this memory is considered by guest_memfd to be
shared with the host, with the possibility of in-place conversion
between shared and private. This allows the host to map and fault
in guest_memfd memory belonging to this VM type.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/Kconfig            | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ae3aa50c7e..b874e54a5ee4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2246,8 +2246,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+
+#define kvm_arch_gmem_supports_shared_mem(kvm)         \
+	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&      \
+	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM))
 #else
 #define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_gmem_supports_shared_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ea2c4f21c1ca..22d1bcdaad58 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -45,7 +45,8 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+	select KVM_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+	select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
-- 
2.49.0.rc0.332.g42c0ae87b1-goog


