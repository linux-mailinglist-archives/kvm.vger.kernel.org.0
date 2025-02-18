Return-Path: <kvm+bounces-38467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FDAA3A43A
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 150CE1887B83
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B6427127C;
	Tue, 18 Feb 2025 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zbxj3k33"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B488D271267
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899518; cv=none; b=oZFz3DJb62J2ix2JgixTtLXXLsz2KwrcKe5HGGg9avP7DF/geVPPbjscHY/zKBxLQI/B29EzL1pvYK5XopUZk2y3p4SIIEOCA9vjW8fbNDHtVcuUZXLvGMoCC0gUrnsMW5yCw4Mc4ZDzKcxVYgIcdxZls8oWI8REV3I9658gCM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899518; c=relaxed/simple;
	bh=Z9jHWi3dfgHfjbl+/l8xW29XFbEXC2z1XcUJVwGCDWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XcrLx5/trYuU7bpV3ICGRlGg0eI1uZpwM3eM2X285thfnLF+HAYiwUsRsLTiLKTzEASHRJTMVOUymIV0LGpEc6JNhEwHoHMAoe5vKVeCmSdTD4WcrtEl+6UcF18v5GPO1Eq9lcMFZlRfgdo89zijlFQwrE9hwslgxKjGMLqZ0hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zbxj3k33; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-439870ceef3so11373065e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739899515; x=1740504315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jx4xZjDfMBMXXhEUJXok46KCHPVTD9NLwBhDL+J2lnc=;
        b=Zbxj3k33ypLir7b2k9eJi0zi331yC90cWdljk2az6l+OJEPJbJ83ey8X+qLUGlWUTK
         CRV/ThtcdlfRm/VYkyA3rAv5zTIetv9xO7Ym7p4pzim5IfyacmQ52uCtMN45X1czYE01
         656a0rikfPaltMKqPY0OPTExjkA1xcslMpFzZJwDlMP19N1MDJpApVKLtR4F8KAcnCaT
         B9BdYtJ3MupF2cvSCETvjb21Pl9B0971ncuTHwHmp7uKK2M5/Lx2zuNz+BDdreF3Mof4
         Stsg21hRjr1DuztkZ1LLVdyPZtfib8Onyo7DGbDNbMYimAk3kmgVPKrjbXVjcMfj6nHy
         OBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899515; x=1740504315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jx4xZjDfMBMXXhEUJXok46KCHPVTD9NLwBhDL+J2lnc=;
        b=mnWEHlzMoZNisYDkmVh5Ph2pN/wvOE2fkp8AkON14SxFhMUiTRngOI8GziqWFxRxRo
         w1SMz4+08nmSQzrrq+yq+13dgefE5TCMd+iwV7cD5lRzcpfF1TR33K9MwqrSXI9fdTkq
         4o71fAzpPcsjzuQUrgpeUNPOT/jPPu9EyF+8s51WYg9PE9PDI5ATNhlTNRrWU6azyn5N
         Eleyi1joO+I9qfunKa4bigvmn8EmZTAPUEmUF0PCrofwlnzhKHZL9sEjpl6ehHNfLAVI
         Wqy7fP3ibQNUIqpSQ9VhT2+cVFC2YIgKOh5ohJjNloJK2Zjy9RLrjzs2OUPp4RezeVN8
         AgUA==
X-Gm-Message-State: AOJu0Ywxm1tx3nD23/e5Xvzg9Dkrkqldgy+5z1CUq/6c3S7vEjmaCoxZ
	3ROnczTIMqt9uQEahp4O3gsDSuXLzczJJCsboGkbNY/f2ZiEGWI2mfxbZHnT8g2hQs/eCGY0MrP
	YWCu6pdh/ATfNlMIlb2Ej4Eutjww7SNNhG66AdtW9XJn8sIMvkTZgpbbG1ge8I7iYf7T8AFPHjU
	v0kDFb89TH+ew/KUpEZB8nE6M=
X-Google-Smtp-Source: AGHT+IFmZffBFgEdtdB4umKgK2ktvciHW+KwlXO0p1rZeaOpM3ZGypPScKK7EME3e2ZtSdCfEZtgUxje0w==
X-Received: from wmbfk13.prod.google.com ([2002:a05:600c:ccd:b0:439:841e:b677])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c86:b0:439:8346:505f
 with SMTP id 5b1f17b1804b1-43999dd21e9mr4817225e9.20.1739899515197; Tue, 18
 Feb 2025 09:25:15 -0800 (PST)
Date: Tue, 18 Feb 2025 17:24:56 +0000
In-Reply-To: <20250218172500.807733-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218172500.807733-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250218172500.807733-7-tabba@google.com>
Subject: [PATCH v4 06/10] KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as supporting
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
	jthoughton@google.com, tabba@google.com
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
2.48.1.601.g30ceb7b040-goog


