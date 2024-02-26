Return-Path: <kvm+bounces-9936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EB4867963
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EBF51F26CCA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AE215445B;
	Mon, 26 Feb 2024 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5zmQ07g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5491912FF82;
	Mon, 26 Feb 2024 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958406; cv=none; b=Ei0mvy+PXUb/nEimi9lx3atwd836vuzcxHv6waRv3Va1jk0iZ68UB+ejnxzHR6m7rYa+//INeJIgGqjgAKviDof0FDWZzDEyPC6z3lKoVKgnlNgcng7vlWzJOPMd1W2vy+T8UyAxRLwH8ThCgZ6eBTi8UweFlsEmTHrnvLXKng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958406; c=relaxed/simple;
	bh=qqbq3Bwm43dJh8id89W2TYXp5QH09UlcB6vdIL6AVDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=POY5p6iMnY4fq/1jZPXLBK2pvc3J7U5k+JIu04CpnrZwNPYPvnREQ1dxzNmj8OV2nMTc8Cqei4fNKpcA7qfuOnt5Qyv1ONl/7Gf67TwONp8n868zSv/wS7zUbHCgH1q918zGfGuY8VBxw0tZmpZoUGFcVXEeSihz7l/w3W4yyoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I5zmQ07g; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5a0919f2022so297194eaf.1;
        Mon, 26 Feb 2024 06:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958404; x=1709563204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuFgloaw/T98jLpJSXGJfxanwsQCbN3BvZjtpbYZY9M=;
        b=I5zmQ07gPcROjHLJqzlY7T+TqWGFmh5r/xPRPl5gPKT39e+EE1C2z91kPpQyl0ic//
         uinDm/fqztzbPAUPWKGnW5+MVDGmdcKXAr4qAHnjEfAOc0eKMGzz5EsAxeagfgXB+G1g
         XcX7Yn3YAvHtLCXbpxdCNEdf/nrWrsXcXewC3JIv92Y/ujDNbIX++id5V0cqPtUYogf1
         D3yJmRXV1c5oFDk1pgnHHKiogtZbfMKWUBGK4GSmJzyRuNm5PMzdotHRYjH+U/PZVs7o
         lJ1bWPXgmsIIdPbBae0iOCe17JN9ZzIBb6F9tBqSOPlHW8u++oD5VWxAEzYbRGuOOSW5
         eKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958404; x=1709563204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nuFgloaw/T98jLpJSXGJfxanwsQCbN3BvZjtpbYZY9M=;
        b=rAmbsfq6l2rnSwVZ/ZrsZWxFtRjW1kHb/U43d0Q+K+ai+E6etxNTW0zLaH2VoT1eAE
         zglHjjHrbsYhok+vAbpERs3EjEWpMrtQBKGiLju3wmIP1CKv+H88sfO6LPFTz/9/JllO
         YvzPOYLyrXSiYjWV16nX2FPJ0VkjFh5p/RreSDzPpBXXkBNDCKGZAsiou9O/ULAA0vUX
         cPBfFaKGLEW3T/yqn01nlqkgFJkfC8O59r+L85akFaDspe250VTWDTDR5htdt27X0sVN
         ph0K8O1tvuOiTVW7SmjUB6hECAXMRMcSLMKJN5GwUwL4sqLbFY9qXMPIflPxVIfhKrEc
         BYVA==
X-Forwarded-Encrypted: i=1; AJvYcCWqz0y6zgamjn4IXd9Z9uJKAK/BxhotOh18mOy/2gzA96I3J+OK8AnkUN50FXgvNiv4486gIjunkgC3D9rTlZ9dckoS
X-Gm-Message-State: AOJu0YwuAImbKG18oPedZVuP4LYlhfsYuVC3+rsZgTL2wHRgqyyB5m0G
	9B89qJJBpE/yehfJFycgdHUT0Hbf8Ie0Nl2FRNPpyA90U1bJlL4Bj/FFXB7t
X-Google-Smtp-Source: AGHT+IGjgJBiYbBVOHtGYle9iWXhqY6cflLoOIZ20fo8AoJm+voj+6sWNjAMcfJ0VA4hKdsuB66yYQ==
X-Received: by 2002:a05:6358:5e8a:b0:17b:56ad:6b14 with SMTP id z10-20020a0563585e8a00b0017b56ad6b14mr4467201rwn.2.1708958404049;
        Mon, 26 Feb 2024 06:40:04 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id z12-20020a634c0c000000b005e2b0671987sm3998766pga.51.2024.02.26.06.40.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:40:03 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
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
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>
Subject: [RFC PATCH 73/73] x86/pvm: Disable some unsupported syscalls and features
Date: Mon, 26 Feb 2024 22:36:30 +0800
Message-Id: <20240226143630.33643-74-jiangshanlai@gmail.com>
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

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

n the PVM guest, the LDT won't be loaded into hardware, rendering it
ineffective. Consequently, the modify_ldt() syscall should be disabled.
Additionally, the VSYSCALL address is not within the allowed address
range, making full emulation of the vsyscall page unsupported in the PVM
guest. It is recommended to use XONLY mode instead. Furthermore,
SYSENTER (Intel) and SYSCALL32 (AMD) are not supported by the
hypervisor, so they should not be used in VDSO.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/entry/vsyscall/vsyscall_64.c | 4 ++++
 arch/x86/kernel/ldt.c                 | 3 +++
 arch/x86/kernel/pvm.c                 | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index f469f8dc36d4..dc6bc7fb490e 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -378,6 +378,10 @@ void __init map_vsyscall(void)
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
 
+	/* Full emulation is not supported in PVM guest, use XONLY instead. */
+	if (vsyscall_mode == EMULATE && boot_cpu_has(X86_FEATURE_KVM_PVM_GUEST))
+		vsyscall_mode = XONLY;
+
 	/*
 	 * For full emulation, the page needs to exist for real.  In
 	 * execute-only mode, there is no PTE at all backing the vsyscall
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index adc67f98819a..d75815491d7e 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -669,6 +669,9 @@ SYSCALL_DEFINE3(modify_ldt, int , func , void __user * , ptr ,
 {
 	int ret = -ENOSYS;
 
+	if (cpu_feature_enabled(X86_FEATURE_KVM_PVM_GUEST))
+		return (unsigned int)ret;
+
 	switch (func) {
 	case 0:
 		ret = read_ldt(ptr, bytecount);
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index 567ea19d569c..b172bd026594 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -457,6 +457,10 @@ void __init pvm_early_setup(void)
 	setup_force_cpu_cap(X86_FEATURE_KVM_PVM_GUEST);
 	setup_force_cpu_cap(X86_FEATURE_PV_GUEST);
 
+	/* Don't use SYSENTER (Intel) and SYSCALL32 (AMD) in vdso. */
+	setup_clear_cpu_cap(X86_FEATURE_SYSENTER32);
+	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
+
 	/* PVM takes care of %gs when switching to usermode for us */
 	pv_ops.cpu.load_gs_index = pvm_load_gs_index;
 	pv_ops.cpu.cpuid = pvm_cpuid;
-- 
2.19.1.6.gb485710b


