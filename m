Return-Path: <kvm+bounces-48544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E9BACF33F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5A6B17681D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1EA81F09AD;
	Thu,  5 Jun 2025 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="icYX4hCF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A658261390
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137911; cv=none; b=VfJkLiLDssohT7XN0nU5msg8Bxj2pxNzspGPmSobULig3ZM8sde/1XaHT0orjNSZ/mjdQeKC/lFR2Wl8TloMAwyqKJnIDxTWcxW1HYhd81mxsuTxa/j6TE/skh0FkQ7+Cpgw3EnU4vLSMubCl5hnuid183nQH1SaVxTVGkD9CP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137911; c=relaxed/simple;
	bh=+si0IwQYfdnfpPTbB12Ya48FTxWYrHLxC7qomaPe714=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JybvTSEc8Qevnu2rvl2B984hFC5lfnWfoHZ6ZvxmYV+h8lfWcERD8mKGa7NaxwMv3grpa+euijvRNnPIzQZI4HxALTsFfJcGbJc+IoUrGGDazC2MzAXXsJ0LC2/8VeZofyJaWDdXOxCdk6myuaIxAXpDGjci6ivyFEXqE7GkA5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=icYX4hCF; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4f6ba526eso724333f8f.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137908; x=1749742708; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LyV7wZJIVzKpkK9EkEwsBwrhtHO9OpqVVjeAhwV3yWE=;
        b=icYX4hCF0W1oSEhwLIWkod/atWZkuFJmPkK3YP7M1iE13pYCkoL+Hie5yBe9HtSgX7
         X5zpwRf7j8UV5dFzdT+n7W3rX9Vf4yJoQoZfiXGD6K7LhB9vh0lzYq1kv0rZn8brM2P7
         //79wbq+3Rrkp7ux1/49Uo3TWMjxou+frXLOpoVVC/WR4opYxRqEqb3pv5hm6q8vGyo2
         X3ZB9SOH0ms3N4QBfHHmoYTt06XiVG/SVyiUaELIFLFj1NJNyawFDYrY2ApTFXZ2iEtw
         1V7Anpk8IilSfvFmBjWo+2Uy+MZUpwbl9G0n2+IIVlQW7wwk3R9Joy4QBIK1MfkX8MNd
         YPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137908; x=1749742708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LyV7wZJIVzKpkK9EkEwsBwrhtHO9OpqVVjeAhwV3yWE=;
        b=N9KPPan59Mku3IPpulTJQKBw8gJSYHFRaYykUVS6wbdjbmrNv0q8gUw1IfE7N0hI/9
         A/xiF8JmL2HhMDQ6L+BovoJpUiB4qXQnaspQZyn7k5gkwDc+Xby+d7IItNh1X/4jwazo
         jjVB2yGFHrfm9rJr1yxRXT681oiIzdAk5A3UHqs2aYmUI2nsNUIcWEgPUvbMrKz5/Ty4
         slrVRd4b7I4qycZhVgvOTHTTUBWxGrxWU0mJ0aEde6IRQWm5YrZm6LKPVFilcqE9rgfF
         s1HWQXvn/wcZt+Fq5r+z4bzKAcBmd4geAaLA+KhJTYq+O20I/xSxIVLykxfDHzf6hEQO
         KVhw==
X-Gm-Message-State: AOJu0YwMt6pY6MRGW21w/62Aq3rDy4xRuqZFUZlJs+WOIA1TlYXmzT2j
	DULSy8FI96Hh82UNtwdQFmSl9BQrXZTI1u8xk32BVhwai41MJsZkca/aHH0OvnaQoQQasnr4151
	iwknmCqXWOk5/xno0oCNIDujo1LY9FfQzDMvK5gWEAzcR/j3j5C2ItTIb/oREk7HCDrVEmdAwTo
	iP3HIy4LZLrAXQkARauu9YnHh+byY=
X-Google-Smtp-Source: AGHT+IGgV5ke5hXPrHMuRnrP+wv3u6Tkx21fI8p6ntOfTtgrw4d762tpa+/9V2HMZqsC7PIFnB4sz/aRjw==
X-Received: from wrbdr8.prod.google.com ([2002:a5d:5f88:0:b0:3a4:ead6:8232])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f49:0:b0:3a4:eb7a:2cda
 with SMTP id ffacd0b85a97d-3a51d95dcd5mr6346937f8f.30.1749137907542; Thu, 05
 Jun 2025 08:38:27 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:54 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-13-tabba@google.com>
Subject: [PATCH v11 12/18] KVM: x86: Enable guest_memfd shared memory for
 SW-protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
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
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Define the architecture-specific macro to enable shared memory support
in guest_memfd for relevant software-only VM types, specifically
KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.

Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
enabled.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++++
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/x86.c              |  3 ++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 709cc2a7ba66..ce9ad4cd93c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
+
+/*
+ * CoCo VMs with hardware support that use guest_memfd only for backing private
+ * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
+ */
+#define kvm_arch_supports_gmem_shared_mem(kvm)			\
+	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
+	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
+	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
 #else
 #define kvm_arch_supports_gmem(kvm) false
+#define kvm_arch_supports_gmem_shared_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b37258253543..fdf24b50af9d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
+	select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 035ced06b2dd..2a02f2457c42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12718,7 +12718,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem =
+		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.49.0.1266.g31b7d2e469-goog


