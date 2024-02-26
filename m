Return-Path: <kvm+bounces-9916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A88867931
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7731C2894C0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4CAC146912;
	Mon, 26 Feb 2024 14:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZkumKZX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5CD12EBC1;
	Mon, 26 Feb 2024 14:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958266; cv=none; b=WhauTEGqLGX7shDiOVRTkjYInniCyqrzaUXxgzkr0m3ahsOqggRHdcfb5BidBz8iWvFVsvR8Hi5HD9p2VtFhQO8BdhnDnhOUDDVruESYhA2tTsAJeNhRVqfD15qamDpZoNa8G0WL/rra3WVcVyY7j20fIVHp3dqNmp4baCAqowA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958266; c=relaxed/simple;
	bh=5UQ/75p105DFTiVsQkZHczkwiUZN2Bo2WzyYu3VvV3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HFPZ+jtlH/nsGc0lf/ZcaGIXA25Q3YpvBYNyhtID0x6ZhgsqNpZCW8l4mRH42VopFiOjSfNNX+NYFPKZApevLgU37HZc5G2fcXja+PCE/mBPk4+8vGPtGfdkEpop0BdBZMZmrOGTpJ3JQJ9lH1uUlw0Pb51dl6lZPAGGZ6zqVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YZkumKZX; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-29acc73df4eso498097a91.1;
        Mon, 26 Feb 2024 06:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958264; x=1709563064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqdg4X/YjHymybWX0IILhA6ds4v8UP51Kri2hBr6/kU=;
        b=YZkumKZXdluRoyBAJ1/ufj6J4qIwtUH0q2OhLrHG8hQ9InPE47FIih0YpD9yQ8Fj7T
         j09MU19ZDtUlzIRqMPPX1m6HfNaNkXuKiAVjAtlBA+UkjW3eGsa+gBDv9qyOj8W0eMDa
         SZTlvlF8/Ln+E4D5f4yzEdAOV0iU010tD7N2ZrQTMm9oxVutEEWJmos6L/mgXdwtFdc/
         QoBP8R6xrV+XMw1GWzUa0Pxc+MFJWNWOG8WLSSEJyEiFNxYXTyxgQo/sSBnrF2LVgv4v
         mKXR+CXcxOavuobVujoQ8N9MZKhYcZIU9nfSjC7ay3uHGZURsvf1vvA8ND3hie9k3dtB
         R+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958264; x=1709563064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqdg4X/YjHymybWX0IILhA6ds4v8UP51Kri2hBr6/kU=;
        b=Laacl0xY4pEfjVivDnm2uKezC9VT0KPQngNAnqXW08kesOh1iuESDc/camyxg3RB8y
         RLtLUc2GisfzeKJxHZDthmxoHvrIUCEZoxGrKjtpyQIralKkWtw2OCy69aRpyal5MhX3
         BS7xuCklbcJLRol3CHzdWkKMje7rgIrg+0yvxfwRWqHPw/q1uM+rn0ElBEkSI0ZUiT6k
         PntW70WRJfNQEqqzZNOSlU03pRYS/yqvFCWKr7UYbraRkNkdhgScn5IMcSMKFQLySv0E
         cBqmB4HVm8PeszAq+nfpCL3EJIhTskKC3HFijnS0MYbX6x1aVOQsvlO9gHqS7lk/UZ9t
         +8Qg==
X-Forwarded-Encrypted: i=1; AJvYcCUd4SLz0PGFIsFU173nev97fJeq34jklf1IOK7TFx5Bsm8aBLny8+jA2n7XqVM1XQviuc4euTW+7cYAO7t/msVE51qo
X-Gm-Message-State: AOJu0YyV2BJTv4Ft3ae4KL7hqxwDBq7IbzQr2Nnp0jDv2bFdG0EnkQn9
	+m3XGMrUQO0kmpGN6YraTbuZZKpeiEbockjfdxwugQCd922XbxUU4oiZNDTg
X-Google-Smtp-Source: AGHT+IECS7xluNhmsd8ZjIWA8oFryLoaOHejAuTxIJmqPfeBjlZqxafvW0TcCsWSOMUU7MiBSKKWzg==
X-Received: by 2002:a17:90a:4a89:b0:29a:83da:ed62 with SMTP id f9-20020a17090a4a8900b0029a83daed62mr5947851pjh.4.1708958263592;
        Mon, 26 Feb 2024 06:37:43 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id q13-20020a17090a178d00b0029ac5848d5bsm1523294pja.1.2024.02.26.06.37.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:43 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC PATCH 53/73] x86/pvm: Add Kconfig option and the CPU feature bit for PVM guest
Date: Mon, 26 Feb 2024 22:36:10 +0800
Message-Id: <20240226143630.33643-54-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Add the configuration option CONFIG_PVM_GUEST to enable the building of
a PVM guest. Introduce a new CPU feature bit to control the behavior of
the PVM guest.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/Kconfig                         | 8 ++++++++
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/include/asm/disabled-features.h | 8 +++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d02ef3bdb171..2ccc8a27e081 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -851,6 +851,14 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config PVM_GUEST
+	bool "PVM Guest support"
+	depends on X86_64 && KVM_GUEST
+	default n
+	help
+	  This option enables the kernel to run as a PVM guest under the PVM
+	  hypervisor.
+
 config ARCH_CPUIDLE_HALTPOLL
 	def_bool n
 	prompt "Disable host haltpoll when loading haltpoll driver"
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4af140cf5719..e17e72f13423 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -237,6 +237,7 @@
 #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* "" PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* "" PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* Intel Trust Domain Extensions Guest */
+#define X86_FEATURE_KVM_PVM_GUEST	( 8*32+23) /* KVM Pagetable-based Virtual Machine guest */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 702d93fdd10e..5d56e804ab18 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -105,6 +105,12 @@
 # define DISABLE_TDX_GUEST	(1 << (X86_FEATURE_TDX_GUEST & 31))
 #endif
 
+#ifdef CONFIG_PVM_GUEST
+#define DISABLE_KVM_PVM_GUEST	0
+#else
+#define DISABLE_KVM_PVM_GUEST	(1 << (X86_FEATURE_KVM_PVM_GUEST & 31))
+#endif
+
 #ifdef CONFIG_X86_USER_SHADOW_STACK
 #define DISABLE_USER_SHSTK	0
 #else
@@ -128,7 +134,7 @@
 #define DISABLED_MASK5	0
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	(DISABLE_PTI)
-#define DISABLED_MASK8	(DISABLE_XENPV|DISABLE_TDX_GUEST)
+#define DISABLED_MASK8	(DISABLE_XENPV|DISABLE_TDX_GUEST|DISABLE_KVM_PVM_GUEST)
 #define DISABLED_MASK9	(DISABLE_SGX)
 #define DISABLED_MASK10	0
 #define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET| \
-- 
2.19.1.6.gb485710b


