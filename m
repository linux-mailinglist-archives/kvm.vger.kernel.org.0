Return-Path: <kvm+bounces-33754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF9B9F12E2
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA2061638BE
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB301F429D;
	Fri, 13 Dec 2024 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TWU9fAo8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E01F4711
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108526; cv=none; b=JWGBAHN/W1ZWO3FZs13dKNApnzoU1ncNGWiCANWZRo1iOlGYPZlaW8+RvMJWWFxnW5aJsLoF1H+QJqd/wZ6FAvHeJN4493sRtvfNQLuD4UqYDT6yLQW5QKBFBQibCOifK/o6SweJB8BghKrSe1c2UnhCIDvqxgCQV528zKOC3Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108526; c=relaxed/simple;
	bh=4pVyegVekE3qePTCKJJ20hbPBFuYD82p7l3jYrlPl0M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ai0K4dlO7o4/uHbh9zWxVxEZyn7/6Vft06uSnKA8+tMwHOZ1G1CZ244NX2OvqdOvDaWeNU4GBbLTFp1KTTFDJIMl3HmhPYktejoEeRp2gAObPqRbbVKL9GNFujuanakCoF+eC6zOTUuqsPiPvTpIVP/AR0e93Jpam6B73kEt7vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TWU9fAo8; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-385e00ebb16so267078f8f.3
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734108524; x=1734713324; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QFDTUdjhMWOhr77i5TfIxa/V7OmOhu1GE3Wb7is6IxQ=;
        b=TWU9fAo8MMQu9CfyO/ktma+w3Jb0qoN7kV7BEzdZKwu7sQkUZ1Bpf1EKm9VI9N+GQ6
         zFAk/Jyujo/qcwZgjHpRLzhfpMya1qNfWFxSWnlT8X1UsIGGdRPzbrKK138iGVzB3hXB
         utIoJ6QZIRmlILMGBZc01dyqB8i7dwhnx+E3kwjY1vTK+zpFnK0pl3fbxTdBzFtyIXgr
         BSjXcKz8dzskJXqlD6zIfH+eDVQ+Iec2SOVVdX007i0xG3FiW+55wSb9dxc1dI93t8fz
         GwbJJD4/Uzvok0xd5q/d8Bz3V99jCZLJ3eJdjiPNmf4PYcFF/LGZj7IpsYA8i4utnxwN
         21kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108524; x=1734713324;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFDTUdjhMWOhr77i5TfIxa/V7OmOhu1GE3Wb7is6IxQ=;
        b=SvB6kzc1IGOh/0oPDyTul3uoiDo6hYBNbkqEgsbZ+4blpUGrclj+NfOjhrWT4q8PP9
         /lA+4RBO55e/qaISbbNpHv06A4h6jgsP2eb3kEuqMG6p2UjwUF06ZrIFUW+8wzCCFHMG
         SuB7CfwCDAqNNfbM4xb7UK35F2VkXys/Mqi/QSJGR/TiV5ZYY/FeV1L2aOy27iCmov2m
         uvg8QZu1fktPTyuFiYiEeXF0VfbjxrOhkMDb2ZajXwtvTBoPgKjcHYSV8sQLjSxu9EoR
         i0N4vMNSFtstg2JmVmVwOOWWGpUSgU4+TFuhA+s2kpcDuHZfJULA+UCGK20TNUyeSoq2
         0ETQ==
X-Gm-Message-State: AOJu0YyPu0ptwJFuZYwnylYth8Eo5s/tBbW5X8TcuIHxGT8onqZMgsks
	1Vxe2darEmr7KvcZKHhXPvOI4ExWQGGnlcwuM0x+4v9qRl45fL4H/YnQhN8fBBni/8hHXjvtYIr
	qmScrmvNCjdHPkbrkNd/Hvlwd4OjoFeBjCBMT8UJ2urfAoARf3+yW9oVnfpAZAU49wXfv0P1rtt
	aQXl533bvZeT/AdD2b8LfzG44=
X-Google-Smtp-Source: AGHT+IEdZjijVCjCEZr3PkrGBsAlFaK1miBXntQYNoOTRqQcvW0yt5qcatWxqC8z3zg7zC5MHMXcUa8eHQ==
X-Received: from wmbd13.prod.google.com ([2002:a05:600c:58cd:b0:434:9dec:7cc5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:717:b0:385:ebea:969d
 with SMTP id ffacd0b85a97d-38880ad91f1mr2174346f8f.22.1734108523614; Fri, 13
 Dec 2024 08:48:43 -0800 (PST)
Date: Fri, 13 Dec 2024 16:48:10 +0000
In-Reply-To: <20241213164811.2006197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241213164811.2006197-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241213164811.2006197-15-tabba@google.com>
Subject: [RFC PATCH v4 14/14] KVM: arm64: Enable guest_memfd private memory
 when pKVM is enabled
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Implement kvm_arch_has_private_mem() in arm64 when pKVM is
enabled, and make it dependent on the configuration option.

Also, now that the infrastructure is in place for arm64 to
support guest private memory, enable it in the arm64 kernel
configuration.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/Kconfig            | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a..8dfae9183651 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1529,4 +1529,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+#define kvm_arch_has_private_mem(kvm)					\
+	(IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) && is_protected_kvm_enabled())
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..fe3451f244b5 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_MAPPABLE
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.47.1.613.gc27f4b7a9f-goog


