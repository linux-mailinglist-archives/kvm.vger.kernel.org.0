Return-Path: <kvm+bounces-40847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBEA8A5E34F
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 18:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03C55189E7EC
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB6B259CB4;
	Wed, 12 Mar 2025 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ImdWKVcc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96A8258CFF
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802327; cv=none; b=uvOQj0q/7QE1ecAnUsrvLJtMm+XyCHKW9Az200DGJrO0bt7U4CrENHRp4tl+XgSgIAGkIwhO4DpRw0Cz2w8HfUr1hDIqF6dlIdDk4KMKAjryxxzcExURfK7A8fgjNC+Zz3O+DRPBTsFvEu4g/xlSOGd/ND7BYW5Fi82LuOv4AfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802327; c=relaxed/simple;
	bh=Lq+619vRZ6FPCIIv9LOKJWBsVi+N3bTSFDaCYzs2CWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c8xP3rgWues/pTjr/xStSt4/NV4SinX7Se6v0AbeBIdNDbaQn5cX9/efLrliVTMHWVV+WO5NweWv0affegKxHjTgnNCDEPULd2geYvQ/YSp9LDcymtb93ILocejpHgGvdhP4yKjT9pZDhThFNYkE+huGy1ZYrcZE4qinnFAkZjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ImdWKVcc; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3913f97d115so83691f8f.0
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741802324; x=1742407124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hYJFKrO7ehNxwQgkQPklR1qHjwdzPiYZpyonfD7j1as=;
        b=ImdWKVccJf761T9VymPHRzChhRz8Mlh0HJkjqP0Pc6PxMbng+Mi5I5wGO46Ea3YY/L
         Gh6XEAjDdfa7tHZNEVsXBsevvzQJWoLiVXjzKy1L9GfHxS2Id5xKmOQqozqCXgWhi2fY
         DcvqLfkgXorAyUXBe7+vXWosZBzDHoYBovG2yHexaXUFJd+G0Z0M9xoUkXpt+91dhZla
         tAzh37pXOu1B6CPRCBu27Y+a0NyltPOa5QnUxGe1zDcRskGUdHh2sIqqjDacjOpyWp6o
         1DjsViVjdgee3oBgqe0+iGDC5qNf3I0ovBo4u4gxADQhQgugRY1JioLIo13kgHDuGFFE
         /z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741802324; x=1742407124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hYJFKrO7ehNxwQgkQPklR1qHjwdzPiYZpyonfD7j1as=;
        b=GOdnT9iWAbmgQEgbJIsqmqNh9l1FbWJdzsn3gsryhVJZuoU8tGgUWonjV6vZg1RrER
         X+HqhGIGr970gAhoOJejTl2KcbGn2uLbW7v2Q8AuWQSVuylLmXeazHfhWRpxfiq1Qn+f
         kUOkBeU1oXS7Vd74Cy9Rr3iCBC/sQJijROSLxCwD8lKWthFzGzAG+l+mn+gkbqT5UetK
         OC9dTNW/fE8cPKrXJkr/kUHwDhBOtVHFQ9+p4bTPeXlBzvBWBIIIuAdkoxML/MQVmR4z
         jBDxQ7c/BD/Zv4zCDB5q/Xb49v3YPma6CNsei1IY16EDJgXpAJwfeeaUO6QXj8VZDkWb
         i0hQ==
X-Gm-Message-State: AOJu0YykGL1vU/89sgFMps4LO+2/7a6MGt7pCViH+CFyKG9aTW370o0i
	nKefy+qtC7SEzUsHOVu9QLeuK2eWUpjSM37k/qSgyZYfilQptMSjdTuiPzpsbj1aMs4pLdxamTa
	0iqxBATfRlPZpJoRPjFB7qZBYCQZH7B/HdKC4b0c5TL1rn7D37xqENdpfelrvUz2cWNQqbfRmRp
	P5AO6apdlK2Tj5dmBqiVWyq7A=
X-Google-Smtp-Source: AGHT+IHQSaL0y42vC9qHHbU0sI/iFbdLjbiwdGaYuErHiOt/6W3ltnpQGYP4gPL3EaUPVT6jNAZ9Hud5Ag==
X-Received: from wmbfj15.prod.google.com ([2002:a05:600c:c8f:b0:43c:f122:1874])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4022:b0:38f:23c4:208c
 with SMTP id ffacd0b85a97d-39568a1c22bmr422481f8f.18.1741802324225; Wed, 12
 Mar 2025 10:58:44 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:58:22 +0000
In-Reply-To: <20250312175824.1809636-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250312175824.1809636-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250312175824.1809636-10-tabba@google.com>
Subject: [PATCH v6 09/10] KVM: arm64: Enable mapping guest_memfd in arm64
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

Enable mapping guest_memfd in arm64. For now, it applies to all
VMs in arm64 that use guest_memfd. In the future, new VM types
can restrict this via kvm_arch_gmem_supports_shared_mem().

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
 arch/arm64/kvm/Kconfig            |  1 +
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d919557af5e5..b3b154b81d97 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1543,4 +1543,14 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM);
+}
+
+static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..4830d8805bed 100644
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
2.49.0.rc0.332.g42c0ae87b1-goog


