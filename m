Return-Path: <kvm+bounces-54217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F47B1D28C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 08:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A01A1899A1B
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 06:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B633221D9E;
	Thu,  7 Aug 2025 06:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VA7bqTGT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8171BE46;
	Thu,  7 Aug 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754548669; cv=none; b=DUY1ZlK8EU965bHVqGxO7f8OlGVFW2wl87BOY9DvgqrmFHyKFxinCsBY3vOFQF4zOxWIa62PtXpN0YlnOH6T0nZwdqZ4C/eoQ6bDF3gIVIFBOQPCAZUIZt0pkOcP7orZL727VLi1wPMywv11IGjFLExj/mqXpZea5T9ADah76d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754548669; c=relaxed/simple;
	bh=KU/dL3mG3Md8aBqaFIdCNSPZNK7zMBvCEEECnzytUB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HL4FxvTUiuu0d1CGasEqtp9sANkdPRWdDOZ0Ev8oNwF1Yr99rgYmKgeu+RUz1QQe1k7KgGfiVUB1LxR8XC7Fs6esdqsFAFmvg4OGAWA3ojisZea5EKl7BhuallL48WeTy0yUPsjt8A9VG4kkMrunGfvVpw0axPiIfhLGcNlFMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VA7bqTGT; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-af939afe5efso79600366b.2;
        Wed, 06 Aug 2025 23:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754548666; x=1755153466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b3kXoEJzAnht57ORcdub3zD3TjgG/w06tqt5/2uQm8o=;
        b=VA7bqTGTKJVUQVkufg++9TT0v8Nh4+Ma/BdpZ86psDm1Jc5ri26k4mOrlsXThnL7+a
         3czCL+pLE59cdoPud7hC6IGplVWl2D2apuKxnsZYQUM27RjTUl6g0tqXtXIt9VlhNwho
         Ii/SQBEoP8iZnFZ3AFamslIfxPhVMmeFFmYssE8pSfdouNovcw4Ny5C6Vd1H2UGljdF+
         F83zS9kYSPHt1G7V7Y0PLssX6YnaMhB+pm1iXZsLedJSD51Ok3KTDBfrosxvE9aje+rZ
         19SbUar2szOwmGkjRRuG61y/FS67ork2Ho2+NA6uRQMK6S/VOJoFARxoYnpk445xe16R
         z1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754548666; x=1755153466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b3kXoEJzAnht57ORcdub3zD3TjgG/w06tqt5/2uQm8o=;
        b=XojgAsRPkVVZnT8Mr0IDzKwNdOt3LMrYlTiGuLTKWrjCd7xkZqExW80XEu6yu/cLWx
         nTV7cX3P4JPVkCMY9uC4fvrErfm2+BsEOZDEf/1GWzD0w3fN1kdXQIRqOsZI6Oz6fUT2
         VeQgQTwJXNn8K3/v4Pz3Om6jPxkY5kBsUmzhRZJRIBDJZwlZHTt68Dry/KbJm1YUgASs
         +YPqyPn1HLJj9CK1kqkUJPplNbzhDBFsVV0crz8veAkpgmGw/9YMpVwJpzlbn87YP+wL
         wCUR4lKgyuGGSNw7c6/MnawTKpQg3Jvd9uD8dMuP/7ioAEoIhJXnM6Io965g/FnR0mg5
         iAlw==
X-Forwarded-Encrypted: i=1; AJvYcCVLXkIs9LvKCjwz45dzLQrB17CspyACXxP+SX4D2kHgNl3sn4iI8iX2T6iyBr70iRTsAo64ZimP2mnKcj8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYiGlGxkhFRkzUcem/PB9C6bySdUOupCFjHl0dywJaV7VCvOOL
	rDuIHfb4ufX5hg4m3ox4Ygb2OEdzeZt34xHhQYI/fC52LqVy1j/FXa/lgAU2EQ==
X-Gm-Gg: ASbGncsyRWAtAspFEyuNAk8D4hmQCAPuTdgbBWABPIAmpqPS1xcQgl74/38CbatUifi
	Rs3LxJCPftT0q/4PiKdOdwr+Yi+aOS2//1bxfZGhOTX8XqJp7EprRPDshTIpVLJBf2pykeFOmia
	mQRqLBecy061PcAl8nSwt47CYI8LrO/29YkAze9mgHRTR/cBaDdc4M12CrJVcLJuT+uAmVNjTT9
	LTk6qsbV4V/vQcPGDG92s+uzk5eD6zkK2qzFXGONQT8aqtPcD5NS1eyFpNvbJovjUvPDCEDZTCg
	WBReRBavyu6WxR8I8IztP0SSCUa0FyB+K0G2cO2tXlaC0NFSY3VFaZMX01gSkuANxVNbTx7nZdv
	1NS2L/M10bTEQGiI7x078Yw==
X-Google-Smtp-Source: AGHT+IF5vJV9wVXd+wDl2ivqlJxldKYE2Ea38jhYAJ7H8Pa0wLMcOswp/1vKVn6eGCF3qy51Xt8onw==
X-Received: by 2002:a17:907:9810:b0:af8:fa64:917f with SMTP id a640c23a62f3a-af992c27b3emr529378766b.48.1754548665654;
        Wed, 06 Aug 2025 23:37:45 -0700 (PDT)
Received: from fedora ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a219ecfsm1246343966b.94.2025.08.06.23.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 23:37:45 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM: VMX: Micro-optimize SPEC_CTRL handling in __vmx_vcpu_run()
Date: Thu,  7 Aug 2025 08:36:51 +0200
Message-ID: <20250807063733.6943-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use memory operand in CMP instruction to avoid usage of a
temporary register. Use %eax register to hold VMX_spec_ctrl
and use it directly in the follow-up WRMSR.

The new code saves a few bytes by removing two MOV insns, from:

  2d:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  32:	8b bf 48 18 00 00    	mov    0x1848(%rdi),%edi
  38:	65 8b 35 00 00 00 00 	mov    %gs:0x0(%rip),%esi
  3f:	39 fe                	cmp    %edi,%esi
  41:	74 0b                	je     4e <...>
  43:	b9 48 00 00 00       	mov    $0x48,%ecx
  48:	31 d2                	xor    %edx,%edx
  4a:	89 f8                	mov    %edi,%eax
  4c:	0f 30                	wrmsr

to:

  2d:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  32:	8b 87 48 18 00 00    	mov    0x1848(%rdi),%eax
  38:	65 3b 05 00 00 00 00 	cmp    %gs:0x0(%rip),%eax
  3f:	74 09                	je     4a <...>
  41:	b9 48 00 00 00       	mov    $0x48,%ecx
  46:	31 d2                	xor    %edx,%edx
  48:	0f 30                	wrmsr

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/vmx/vmenter.S | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 0a6cf5bff2aa..c65de5de92ab 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -118,13 +118,11 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 * and vmentry.
 	 */
 	mov 2*WORD_SIZE(%_ASM_SP), %_ASM_DI
-	movl VMX_spec_ctrl(%_ASM_DI), %edi
-	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
-	cmp %edi, %esi
+	movl VMX_spec_ctrl(%_ASM_DI), %eax
+	cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
 	je .Lspec_ctrl_done
 	mov $MSR_IA32_SPEC_CTRL, %ecx
 	xor %edx, %edx
-	mov %edi, %eax
 	wrmsr
 
 .Lspec_ctrl_done:
-- 
2.50.1


