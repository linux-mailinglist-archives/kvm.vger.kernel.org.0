Return-Path: <kvm+bounces-48547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D06ACF34E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6439189C64C
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95BA62750F0;
	Thu,  5 Jun 2025 15:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R9ur9m82"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D6D274FF4
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137917; cv=none; b=QvxFpTvprU4m2NFChzDSi56MZYAarwrEqvSs6qk3ZjnEM4J8cBx5EwhHTpsSq5i5EK4VeG16sTV4MrzZToq49ktrJUqgC4r8BAKQh4HqVGl1+ajXfJpYx5A68XKudZMPUYtm6BRjdUiokXA4/QM+9+jgigxWT+zeBP2CiqtpEMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137917; c=relaxed/simple;
	bh=BK3VzOi6x3EKu5QuZepEQ0F5haIyPLKoEu+JnsSG2Yg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rFJryvbVg7MsSDFk3FOO4c839sXTJ4KIA4WmZNtqXZZFtGA/+kcgMtcpxyKBnPuzwVa+O60Y3W0wZoJ0i1XHt2tla9icU5CidbcQ0wquQ0OGraQNbTsNOj+A8IzoS4ggO0y3XOiYKt1cLr+7u7HaAwIxvQYgwxU6aJyiIfH5fu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R9ur9m82; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-451d5600a54so8828535e9.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137914; x=1749742714; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sdTi36595hf+KxJmYyJWjfbB0V6sDCqPIzT+xc3Ya54=;
        b=R9ur9m82EbGBMTvcKrwQKNL6XtGG8UL8uOF5no+o3uykJSiz2aUSjSV+7Rv2af793Y
         r8Nx4P6Nvsk4Rqeb4SOQG9cc175wFMHx1xCahYZotjqv7U5NeLQofWotjCBxHUFfAjhI
         Py0hHDTPlHRufBLomBvAM58IeobvSnQweGnnDP30RHQWeLF9L3Vs49w5umPAM+ZTudhY
         nw/Mme4CyFnA/rBinQ3pcPgfsb4zAQUo9P0iH7ug2R9x3VB2tuSQ9YOAwruyxkweRCkg
         2B77Tk5a2xl4ghCPB0INLCX5lj823gfEmSqs3SJ91DVYDI4pLuqsZXIf9BiE72zTxrKK
         XuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137914; x=1749742714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sdTi36595hf+KxJmYyJWjfbB0V6sDCqPIzT+xc3Ya54=;
        b=JNp1lIcHK4Wz/C1MrZM9uRjOfEGQyrDRMvBiE2287w5ykff71Qwi5IE+f5uW6chipu
         yBDKUOXtAnFyZJ6tLvbcPW+6DSj9rum64LM0BxIQxrnkcIJAG26TTZ2is63xk0u0gsQH
         w0mW1uWfGUK+ff1ze9IgtIQtgdi2o82URJp+iF1MAbbmj9/2LbiIIWdrn/ZK8pr6PcQ+
         fmY6Y8eLU9m1tSN0cxIzUiOrOcmVimDyaO+Q4o2jscMRMoZE1qDC8t2lpaWB6RKOLa0o
         uBk5IeJZIRfnr+jksFmH5/0uxt0X53xMIX5P8FHQgry0vWPls/vKV5IphH/PFu0ToiH7
         9Y5w==
X-Gm-Message-State: AOJu0Ywl0sinOTeyDOA81R0zdgReIWq95kH9Ou38OHXopXU6kERZ8ohl
	Nfm5a+tkeUhU9xIUjc+xBI2JJ1sdIb6oWXo7QKDsjFL3BOIeI9JAhMp+2hNsE3WUwcZaI/41JDu
	rFopAwQBGsJxZ7LusXglu73RIX9rxRufIwPYUAJpXDFyFvEp3OSc3b8dnX0T3VWNp0yBGS+WI43
	RY4Xs4D1PBpS5hIO1TiDp2lwX/tg4=
X-Google-Smtp-Source: AGHT+IHjMKXCvTmBxoiQUc3S0//vqXVb77uBJR4SvhxKOwINqq6jYrFaYhNl/XwH/tFcftUafwOB/rmHeg==
X-Received: from wmbhc7.prod.google.com ([2002:a05:600c:8707:b0:442:f482:bba5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e89:b0:44b:eb56:1d45
 with SMTP id 5b1f17b1804b1-451f0aa7ff9mr75040805e9.15.1749137913905; Thu, 05
 Jun 2025 08:38:33 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:57 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-16-tabba@google.com>
Subject: [PATCH v11 15/18] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
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

Enable the host mapping of guest_memfd-backed memory on arm64.

This applies to all current arm64 VM types that support guest_memfd.
Future VM types can restrict this behavior via the
kvm_arch_gmem_supports_shared_mem() hook if needed.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 arch/arm64/kvm/Kconfig            | 1 +
 arch/arm64/kvm/mmu.c              | 7 +++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 08ba91e6fb03..8add94929711 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1593,4 +1593,9 @@ static inline bool kvm_arch_has_irq_bypass(void)
 	return true;
 }
 
+#ifdef CONFIG_KVM_GMEM
+#define kvm_arch_supports_gmem(kvm) true
+#define kvm_arch_supports_gmem_shared_mem(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
+#endif
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
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f14925fe6144..19aca1442bbf 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2281,6 +2281,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with shared memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	if (kvm_slot_has_gmem(new) && !kvm_gmem_memslot_supports_shared(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.49.0.1266.g31b7d2e469-goog


