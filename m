Return-Path: <kvm+bounces-55116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F99B2D985
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 12:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 417573A75E6
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 10:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50E8227563;
	Wed, 20 Aug 2025 10:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YcMlGS+2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595E51D5170;
	Wed, 20 Aug 2025 10:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755684032; cv=none; b=Vp/PouNWHfr1D/4HEpye5OvWZuHgnlILwX1PvjO0E0euf9VZLDgf5ZDpsu9rsz6EeVP8P6OrUf1iUzh9krsm042FeFfmbUR/s74GL/l1JC6E2c6GjRzdD8GaxFdpwbWWM2QuZLdFF8OpAX3fVGmwkKAMfHBFSGGOjRdl9fCIA9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755684032; c=relaxed/simple;
	bh=Yth+q92SHcEaq64lLAMMSgnCn7UK8xiYQ7jCdTKJVKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qveNhx5avz1BE/yFJwI/pDXHFQz8ZeNgC3s/2rtFhHnRrbobJvGPhLaSYZ10t66a1S+pdNEOiccKi4lNSJgmiI2J9+WbnsmyRMPvqFH4GtxTYaeMlKnRfqGfq0ekvoDyYy/zmuo2uLT0jYJq0AhtVPOR7KS+iTNO5VES6F2rCNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YcMlGS+2; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3c380aa1ad0so271260f8f.3;
        Wed, 20 Aug 2025 03:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755684028; x=1756288828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sWEMWib46hxbOTAQbWhLdYmAtxQxdWrlDQL0tYExbxs=;
        b=YcMlGS+2SWYyi7jXhIJAuOVt12xUxUTGAdCfKdX7+e5VIUplZ4xfpV4fSNiq+5yGYg
         JomCsaXoJZUmvQi6Oa7jfzyO21ARZS3p91dXaRlmZkOfxh+Q9NwUJWwFnaBXIQ+okVsi
         /Ubw21EuImvWPTO3ZeJ1q2GSqrAF3opKUPQlOJwsToaq5/kib4A7aBDJJgRRYJThCTyF
         e8SFVZOzgKOl4Tb31TmY6Z2O7nH5ZAXUJdX2air7BsRZIOXBXZt5jeQukLhy7P6qhJrB
         kHShJcd9rRqIltlkPdIT/M1SOj24+tAsWFagp3A+pxco0tdrKit6CDL42fJYgibWqsho
         fAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755684028; x=1756288828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sWEMWib46hxbOTAQbWhLdYmAtxQxdWrlDQL0tYExbxs=;
        b=MAh6DTLFkfqVHbpInPjLt5e/jbIWW0gdozmpjBOn9VY6Kw6ru9ojScxLbI60L/xkWN
         rJ4+Ic+CA8Oc7/ZKhdtginotm7PQIuJOw8+uSO99/4HaRcMOfxF0dSumEmm6LRjT4JA4
         A8SwPergYhbf1CGcujhdRbeyPvYQalmUgqmH+WfyBsGNs/n9KsvhJu21itfEfGhfiYt6
         e/vZw97uXtqZ4AeTF9u7I0BjmcHfLzzPN8npBa4rlTPlcyX+MuxkZuAv8qc9U5sZF+nR
         AeT3c0CN7E33zw3vsGoew5m7V4JmmXsUqkuvObmaMCkY9Vs42ViZ9R3oOlOvX95sIt7j
         kMIg==
X-Forwarded-Encrypted: i=1; AJvYcCVBZt9B4x5b49s7RZKKy8dhtqVhxTXP2fBbG+cpkVbuQ6uHCj/fJ/F4ANsZas6QPb8XZLXYigqYijezrtE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfh0M4LOsMc44Lnu4DtHqgZfYdppCqOU+cAKGCnYgH5tmHNtKT
	JLCN2CbCdLhJHacVSaOIhFMYisAamNGxRwBnhPTsx5/JkeGTMLEBmbW+9NEuNw==
X-Gm-Gg: ASbGncsMYbSSeBeTLkVvsMaPwzx/S6+gPMHPpgDp5twkpKuvPFP1DtmSDLwIR1qwQZd
	Fccy9Wl2mmHi3hhSmojClYChHw/MiG1659S2Rbtongc2IUqAyMbEwoFMB9r3ahhufb32dCmQjC4
	xUljoqNdbcSekORZLlZyxsI3443+dldCsHAJwX1lb2zuelBsJ+8HueE7CKbHECt4Q6U9gtmfnuh
	291kJtmam0DowZCbvzT941fC1KjMk+3HO8qE32NaTer0Bkucgj06dwt768VjUvGIHPk73Rxs7KP
	Qmx2l26J66FtIahVzciVNvWOJAg39vxHoNBwaRcdiGAPTLs6PqpVnvT0piqdOsfGn5g6n7PV93X
	70j8BguGa54WnNlQ5pDCiwQ==
X-Google-Smtp-Source: AGHT+IFUO/XFYDY72yU5JmwENY+JkNhcVuHx67L9BJd+04wRNPVoF8gQQvcb+8Bkc2HCcKnYUmENxg==
X-Received: by 2002:a05:6000:18ac:b0:3b6:1630:9204 with SMTP id ffacd0b85a97d-3c32e03e7d7mr1468617f8f.19.1755684027595;
        Wed, 20 Aug 2025 03:00:27 -0700 (PDT)
Received: from fedora ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0748797acsm6830129f8f.10.2025.08.20.03.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 03:00:26 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM: VMX: Fix SPEC_CTRL handling
Date: Wed, 20 Aug 2025 11:59:54 +0200
Message-ID: <20250820100007.356761-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SPEC_CTRL is an MSR, i.e. a 64-bit value, but the assembly code
assumes bits 63:32 are always zero. The bug is _currently_ benign
because neither KVM nor the kernel support setting any of bits 63:32,
but it's still a bug that needs to be fixed

Fixes: 07853adc29a0 ("KVM: VMX: Prevent RSB underflow before vmenter")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/vmx/vmenter.S | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 0a6cf5bff2aa..fb250ddae00b 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -118,13 +118,23 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 * and vmentry.
 	 */
 	mov 2*WORD_SIZE(%_ASM_SP), %_ASM_DI
-	movl VMX_spec_ctrl(%_ASM_DI), %edi
-	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
-	cmp %edi, %esi
+#ifdef CONFIG_X86_64
+	mov VMX_spec_ctrl(%rdi), %rdx
+	cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	je .Lspec_ctrl_done
+	movl %edx, %eax
+	shr $32, %rdx
+#else
+	mov VMX_spec_ctrl(%edi), %eax
+	mov PER_CPU_VAR(x86_spec_ctrl_current), %ecx
+	xor %eax, %ecx
+	mov VMX_spec_ctrl + 4(%edi), %edx
+	mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %edi
+	xor %edx, %edi
+	or %edi, %ecx
 	je .Lspec_ctrl_done
+#endif
 	mov $MSR_IA32_SPEC_CTRL, %ecx
-	xor %edx, %edx
-	mov %edi, %eax
 	wrmsr
 
 .Lspec_ctrl_done:
-- 
2.50.1


