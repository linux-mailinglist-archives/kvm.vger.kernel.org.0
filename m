Return-Path: <kvm+bounces-39906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA778A4C93B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BB637A7E15
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9302524EF75;
	Mon,  3 Mar 2025 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nX3DUxyR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0099524DFF4
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021829; cv=none; b=JAjRGuXcClVOezBfQzGfoX7FH0ZCplA/q7GE6Y9qfCdEECS0YogKfof6B1gvcuHFcDBQKP9wlcnUXVgIkisa/57+u+8lFaoQYFZIH42Yh72nskneYYvC/6yY4hM/uwd2BnWdaJn4Vi5mjfY9ZzivASogoJurTlVwNDoMZLLQ/+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021829; c=relaxed/simple;
	bh=DUkn5GbyH5CsPI0C4PwuQxIiwtGgSakNH9hZfIYfgMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H54wRawSXrfR14wCN2xaZGdqu4HtzcR/7dRBDAZOA/sOLtqrIFu38H3OA6KnIWwrRvOGJZvsh6XIsk159L5Q6AVXUxkZN4I/BuKmrSceIc1yeB/NsTTsC8gKb4aHk17x0EpUET5dDc8gjGc+A7i5dPlTj5HBFGsn+tKErBxOEds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nX3DUxyR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bca561111so1147085e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741021826; x=1741626626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kBo9cxuckkLxj1P4sgBwDTqSuyzpVc+06bRUFpsmRRk=;
        b=nX3DUxyRqDrCgDK4MjhAent2+2t0M3XT5ynD2zKc7891zaeMUSLNWmm1sxIGPCZcZI
         mZdRbC18DZ88V0JxDN3ZpIlbXkQBatZklhDcIprgxoTwFkO0xUx8UJo8EaseJQfVSUhH
         NT8TiFSZI91ULRBXgLZoFKl32LqxM/DG+DE0CUlF349xp1erKquxA3cFrnPHHG8umSiL
         XpCBL2ygMnoS1oRN/aq25IE9MHZSdqRurv5Hh/rYzDcAELaQv3RlJhTOhyrCpqZRBGAx
         4RLvY0ScfQUzKcKmOoH80wz8/uvW9i2z+2Gk3VX580fpcr5MKhE9Ey0mbK1pYljjnqok
         Xr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741021826; x=1741626626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBo9cxuckkLxj1P4sgBwDTqSuyzpVc+06bRUFpsmRRk=;
        b=VuFflI4j53D3VcykZUXZbdDLckNu6dFLNOoGXRjz+V+gn6QrXj9mgdY8UqEToFru4I
         sVCbZ41FJoOgYx9Gz64it1lqtcQrasrJ7ZcYf2iVGwCbMHr5sQQcenejG39Th4gMQ1+z
         Qn+KlVIP6DO2cELsIoSIa4iFLa7PGSyodeWHPVEPc6LJdI5Z639LabLqEYBoe4ncH2YR
         BwRRA5j1ErSmKztDlWiPKPixmlQO2B4B/Da4peuatxl0xyiG28YeptHRMlKyb5Bsq6Pb
         8OJpmOe+A3CwdJcqB5jRferpOJpE3Euu/t5Y1qLyRTI9GhgbNO2t5aojV61H9d9lJHUf
         ZVng==
X-Gm-Message-State: AOJu0YznsNbdAoikjVw/VJetghpUZTFqsk1Dl3RgP+MQrVwRhGWajfSX
	lCKyt6ajdOL0QgW+wQgFLGt1gI3Dl0lq6m9BFGmFb0WQAErR823nKqxgKANpFChMMP43gaXktpE
	ONDGoxQ7UG1TIrYHId1GNxnl60cPO9xgPgXWjqA/hQaId2DDgf7wvIQjaSn68PxixzhBWbnDSA5
	DRTFsZFj5f2ctWzdlpDSHbaJA=
X-Google-Smtp-Source: AGHT+IEzzWpqEnLXSXMECYOpjexIXQkN5OcLraeoWVVOWbC+GmYVuhkSVhxjsVgVJQAszWAWjCT5GaMLGQ==
X-Received: from wmqa13.prod.google.com ([2002:a05:600c:348d:b0:439:64f9:d801])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f89:b0:439:96b2:e8f
 with SMTP id 5b1f17b1804b1-43bb4550794mr52549605e9.28.1741021826102; Mon, 03
 Mar 2025 09:10:26 -0800 (PST)
Date: Mon,  3 Mar 2025 17:10:09 +0000
In-Reply-To: <20250303171013.3548775-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250303171013.3548775-6-tabba@google.com>
Subject: [PATCH v5 5/9] KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as supporting
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
index 0b7af5902ff7..c6e4925bdc8a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2245,8 +2245,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
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
2.48.1.711.g2feabab25a-goog


