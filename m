Return-Path: <kvm+bounces-36875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FD8A222CD
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E46A188210E
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E6A1E0DBB;
	Wed, 29 Jan 2025 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MyifLSzL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3933E1E0E0D
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171418; cv=none; b=ZQBGhwKXD1izDvmSKAFkL006fDmUyyerNvCZFXxDS2qeKXvOAH78Nu7Vs7MKhJQ0VQHTW+f/+++9gPUnVBKM0B6XswaAL+7aGp2kq0Sb4Li2g7qZWA+5yCE3ZvMtU9SKgOnYsRJjvH4Y/xZFbiyZfi70qLkrNqM+UmE5HAKw+wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171418; c=relaxed/simple;
	bh=6Cj8x5trvu+E+gGL2Qx+VGp5KiXv1bWgtMUMwuTGKao=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jsBuxQyJFWFLfAXX2dJfM9Tu6GZ2uCxvcdFMNzkzTf51S9tG9mwFZi05MVrSmLvtnmB3I2p8/4tjMfQ8bIWt0mdYNgZlXmx9sXmwe8TfJ5AAu20W+8oAsYW+BtZfUxYdISYMc+0x7LsTeGjKlfDsT2C02rHph0LHkx58y2kOSNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MyifLSzL; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-436289a570eso56669735e9.0
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171416; x=1738776216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yt94aUdAvXZMqsG3cEe+u7ei8ysAwqoWnN4dmeRVKOk=;
        b=MyifLSzLLqtY5S5p6mMdfh1LN5PcdlOF+V2EgQsocSzYVRXJ91FY3jHiD0puUYBLXT
         jj4qyvgLZMGlzdoZynEiOrT72VkjdrCfed/Rv7loR4FvIQeH8fU3tN0zsq48ycpQS9FJ
         zc5iaV4tBamIjpWtTdthgHJ/LO+oOeZ/dG8wAHbxFyt2m5ffxckTWVw+N5uZ7xNdZBHG
         FExqG/mC00oN2g1raPEJ9EYtMPNHh6mQiWHWxYcR7YwT+P6N6BRKAEjDmHiCyScVLWC6
         EzEo7iM9+BvWjEnWhVtORm8Kw9gKl6PFsZNEGqj10Vu6LkQ2kUnuZ9DcD8Jex/Tf03PZ
         3/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171416; x=1738776216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yt94aUdAvXZMqsG3cEe+u7ei8ysAwqoWnN4dmeRVKOk=;
        b=bMYW0b6lonDrMreiSUJ55u+lS5ouEYHNBxoYcY2L+yNHaLusoyT3jowMd+FO4PYFcF
         03WSHyMIVGg6yqiNtDg24cCcGjYl/ccBNOje6DGmoOqYi66F9tAFJr8ToW2YIYORISJs
         7dpaiUGge0l3QATSs2lDQRrQ2lAMN0tLCFl8csf/Pf80wWHMTw5JKQUEUTv5Mkb5NcSL
         2xmE5TQ1q355XpFB71ZumzIlHRKOXktMxb+zF8U+u0KrBMz88scS7plnWWbULJRwHhOP
         FvoRGtWDsITZElue1xBwFL/I9PbqXHogN1GHodYqkuwEBaS+6/5o+DIqPmbio9eObld8
         3V5g==
X-Gm-Message-State: AOJu0Yx10m47dTNB/cXc4nIiakWdEL4Pux5UV6MHBXfKSDW1ahzfRGKZ
	J3KLdW/vx50KdDyTOaf8UNWytMaIQd/psVwikK4EHAY6bxO1YaC68m8iRV/VyFxRndwxJJ0RYaq
	t1ZHVEodYdi2dOFj4w2fv/NThy0S6PyAXMD5gSxBJqcHgY1wkVTrn+cQiWCikP29KYPA2E962QF
	r5wOKFmh9cpksmUB6ObalYWhI=
X-Google-Smtp-Source: AGHT+IEVZD0fIeUKq/vmlbjgjG2X+DT3UCWZpcJ4Ann1EaDXdRvf6zyGqzjMjCufoNNThN4KeHC2zb1K+A==
X-Received: from wmbfk10.prod.google.com ([2002:a05:600c:cca:b0:434:feb1:add1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d26:b0:436:916b:aaf4
 with SMTP id 5b1f17b1804b1-438dc3c31a3mr45515505e9.10.1738171415500; Wed, 29
 Jan 2025 09:23:35 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:15 +0000
In-Reply-To: <20250129172320.950523-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-7-tabba@google.com>
Subject: [RFC PATCH v2 06/11] KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as
 supporting guest_memfd shared memory
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

The KVM_X86_SW_PROTECTED_VM type is meant for experimentation and
does not have any underlying support for protected guests.  This
makes it a good candidate to use for testing this patch series.
Therefore, when the kconfig option is enabled, mark
KVM_X86_SW_PROTECTED_VM as supporting shared memory.

This means that this memory is considered by guest_memfd to be
shared with the host, with in-place conversion. This allows the
host to map and fault in guest_memfd memory belonging to this VM
type.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/Kconfig            | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..35d5995350da 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2202,8 +2202,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
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
2.48.1.262.g85cc9f2d1e-goog


