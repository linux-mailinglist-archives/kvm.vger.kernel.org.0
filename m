Return-Path: <kvm+bounces-46368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC66AB5A22
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EA044A72F5
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD612C0852;
	Tue, 13 May 2025 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xb5nKyDr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93932BF3F9
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154112; cv=none; b=knGfwVwMYjSCodiUGwQ7C82mQvgXbAHqDzxZb2uAQHVqO3diVzmHINmCshgPnJRPUubZoj8amE1edY947U3MgmSe27qshW/jHb6uRywScVIrA+laekC7O6zQiomPISNiBaDckd0qmB2qncqa4lvhs7vcEdfGYHn7u7ar1ukX/tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154112; c=relaxed/simple;
	bh=qEaTBE1uwGPI8+uCA4iVoWVO+dyV2JyaLTfwA9DK/6k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C4HcQKuAzKv7OebXpEyyJJ6JB0e2lAzRzp7CiNT7/k7tRerEca86XzjIj0DeW7DZcsbb8+UFTqT9KjgqzoHCwUfSkTiUDK2S1vENHAXOejI6uFFQtqffRkIeu5O1oPBMurE+7IQsz53FefbFQgLbZ3TScS8Bf6AbZ3KGMsKzUjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xb5nKyDr; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d4d15058dso42810955e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154109; x=1747758909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZXPMKjc2x8q7vQw6jLYOA4YavTLLDAU0LUHvWww2m0=;
        b=xb5nKyDrUMJOAiN1OSgQE9yd7RRW/8LLG2SuRllRT0m+thusdHP/y1PjFRQ3YZJHyc
         jnxANxOa4ifgoBmbDBg2TBTMMgPJjVoj7XfVjZLadY3t5P06yXtJ2LVIo6YMX9qdL3gZ
         Wi+zVG8MgLfwMFbzoXS5vUJcqluU8olgOKvH5ZPmsB5UUhMdkK++C1+ksH/EjP8hdDe2
         HOrcZQ5udx+zrPc/GireS9p1VsMX+UetlIY5sJJlUFuRXyBile14CUGXFWiDGCJI9lbp
         9hbDHoixWf38cSwe+qdFYdKs2nRoJVeflHypXbbY8oQ8G4wQ4tee4mkdppMmln7VSkSt
         3jlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154109; x=1747758909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZXPMKjc2x8q7vQw6jLYOA4YavTLLDAU0LUHvWww2m0=;
        b=V1m0OQ2HGHiHo17A6v+vaeyUFjz/kTizHGmRoOz7fx8D0vtNOAHi2iguYoialLl4WL
         nK7o5zq3zGIBB/dRnx4z8XkbuN923qQfSQfpTO/VXxdLo3mkV/nV6uHjCngw+UIoQict
         jyfRFn1aNAccMxQS3ZASJMd+yNGgiFkawkATYSmAoHEAJnlJXaTvFEHjqtaEIJzkIqFj
         V3+L4V6d0T1zW/myDcloHemhTaWXom6pYcMFPga39eikW6gMS9nYQglpVV4gJhDi5STD
         zLq3DBNHa9wzdssZz2r9JTzXoqeRiwsIHkhx9Umfl7q2WwENSxw2L79kSKuC1TS8krsS
         uu9A==
X-Gm-Message-State: AOJu0YyTI1k9PXVCVNG3WIRLDToxQy7VYxQHMH+nBCei43x4A+8bXniN
	tHWZbdJA2fu4Hs34wWlRSFAUnMtFkCuQWTqpwFDZiPx4F7kC8Zik/9sU7EaDQ+vkh/cwKde7j7d
	JXkG8qzM1oQiKYMG+Jtf50uXc+JtJato1jpo2WDhufSQUDtPOqaXVnQ0fDroQsHgvQF5TnI+a0I
	8E9j6Mw+nUp2tqKsF8DBscBpM=
X-Google-Smtp-Source: AGHT+IFPpQgvrgdez5UxRSIdFt8fENxNzznV8garFYKvunshxDRiI2542r7dI1m28zPtVhnl3UAAh1kxZg==
X-Received: from wmqc20.prod.google.com ([2002:a05:600c:a54:b0:43d:8f:dd29])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5286:b0:440:66a4:8d1a
 with SMTP id 5b1f17b1804b1-442f20ba9fbmr156435e9.7.1747154109115; Tue, 13 May
 2025 09:35:09 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:35 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-15-tabba@google.com>
Subject: [PATCH v9 14/17] KVM: arm64: Enable mapping guest_memfd in arm64
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
	ira.weiny@intel.com, tabba@google.com
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
index 08ba91e6fb03..2514779f5131 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
 	return true;
 }
 
+static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_GMEM);
+}
+
+static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
+}
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
2.49.0.1045.g170613ef41-goog


