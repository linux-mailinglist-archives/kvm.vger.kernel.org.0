Return-Path: <kvm+bounces-18963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A29608FDA4A
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DA441F25447
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A8E16E864;
	Wed,  5 Jun 2024 23:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EGlIrM7a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8D016D4D2
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629573; cv=none; b=FX0N01Gd15yP7olDa3CSiS1pHrR8nleKX7G4jGgEVPqDBzJfxQ/78eot162qrVHFb50mIv6Eypr5NkGnsjQuXj0EtrAIIZCttbPwNSLk2l9IE9m/Nr27O3aiPdNLuBsbtx8y6r87e7JUH9xo+GeYgkvMId3BgsCIZiidJ+GzoeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629573; c=relaxed/simple;
	bh=dO25VgHPABsHY2fEB1vc850vQbsSZc7TVlAn3AUTs0s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QZO10ThlyBR1U9QiKYfnRWS+VJuUpK1EDlf/Uvgpdj/iGQQJ5v523cZEWtae8Wntsjg9OmwQM0i+9L0SzQi5fF1j/kWAcNOiU3IvuIaCLIAfukUpqN+dAfrNyMtDfUPqVZlvo49zBOrxZuFOFt+5XP3HOBHDCY83N3pJJ8QHJTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EGlIrM7a; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfa73db88dcso616763276.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629570; x=1718234370; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EXdA077yWpI6eczOdgTucO+pfSrwF4gU1Jrgqc+2K/k=;
        b=EGlIrM7apFsKkOtraFd9l3xurhcgrWIqRYqyAJNVqDJBLSNJXuz0R4lDJNUMBKHLLj
         POG2mxNeFowfCw4sGG1wU/RrutdtmU+Vsc2JLCbad5kT84ZJG1vZVTRcCirKnvQVXXBm
         L04XY8F2Zdt3pIxlBHCfyjKk4C5zjdC1euKqkIF+j588O7uZ0KGQbYVMRc8dc6pCDu1M
         cPW56OrUE7NaECbRMohaN3T+nfjP4mLZViak1A3FJdNpX7lEeAmyitkfjrax1uT7lzVP
         5iX1xU5K11vbWI/h9LMO+7lBlMI4rFqESVHu/oxSzFQ+nFC2MzKTO+ZNnBU0zEHjjwAM
         fZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629570; x=1718234370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXdA077yWpI6eczOdgTucO+pfSrwF4gU1Jrgqc+2K/k=;
        b=U3QG0NtJN17cuBodsdq1ldY10Vyggm1yeufKYkDCCc+lwwStHdPtnK61h1g/tNd/1y
         E47gxz80E2h/+ewYm89BozPLJqaKHa3/bXUG9I59u8pZWV0GZCL2PZUiMu/0wRT0Fu5M
         McayhypoPloAsWDvzY7jp0KJQ0CRCEhqqwbjPgwlvpiX3bBd0WiO/zDJ5Y+4o+dkF7SD
         0DnJTNaqdlcDucZKi7joCsmULgVKlxzLfqkZ4UFgsGwg+ctS05N48STIyNe8F5xKXaJg
         lw7Lm0YUPgilQ+wweMDGFUt3V4i+ZCvbM//6YeY5T8FiH4AgsOLTrN3uvweKrO4Ep+Se
         cmRw==
X-Forwarded-Encrypted: i=1; AJvYcCUJXX93LrLY0cfI1wSLcrGsUbgcwifk4h6N2XFS/ZeDVKk2PeGid0AgYt9Kir/dRvpVStfA9IgjdAp/v1gGePTyfs4/
X-Gm-Message-State: AOJu0YwLnQFE8pbmKd4vDoXiwEWmEka2pSO/j5ME+qtJewquDRypBxyk
	Jw+oA8oGYFEueyKFSpy5daajuZoBq9NElgnDUEjKtnIaD9Mhi4DYB8HYEGVb3CiuvxWztbS3zom
	x2w==
X-Google-Smtp-Source: AGHT+IGwHwc7adeQ7Fa0nF/PuQjXMtSIZpJWHdiU+6eoX6gflpLW5j8n1F+4W20UZwZOpHoho/kpjm6DKT8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c09:b0:dfa:59a1:e8f4 with SMTP id
 3f1490d57ef6-dfacace3345mr463340276.10.1717629569624; Wed, 05 Jun 2024
 16:19:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Jun 2024 16:19:12 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240605231918.2915961-5-seanjc@google.com>
Subject: [PATCH v8 04/10] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to asm/vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Move the bit defines for MSR_IA32_VMX_BASIC from msr-index.h to vmx.h so
that they are colocated with other VMX MSR bit defines, and with the
helpers that extract specific information from an MSR_IA32_VMX_BASIC value.

Opportunistically use BIT_ULL() instead of open coding hex values.

Opportunistically rename VMX_BASIC_64 to VMX_BASIC_32BIT_PHYS_ADDR_ONLY,
as "VMX_BASIC_64" is widly misleading.  The flag enumerates that addresses
are limited to 32 bits, not that 64-bit addresses are allowed.

Last but not least, opportunistically #define DUAL_MONITOR_TREATMENT so
that all known single-bit feature flags are defined (this will allow
replacing open-coded literals in the future).

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog]
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h | 8 --------
 arch/x86/include/asm/vmx.h       | 7 +++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d93b73476583..b25c1c62b77c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1167,14 +1167,6 @@
 #define MSR_IA32_VMX_VMFUNC             0x00000491
 #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
 
-/* VMX_BASIC bits and bitmasks */
-#define VMX_BASIC_VMCS_SIZE_SHIFT	32
-#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
-#define VMX_BASIC_64		0x0001000000000000LLU
-#define VMX_BASIC_MEM_TYPE_SHIFT	50
-#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
-#define VMX_BASIC_INOUT		0x0040000000000000LLU
-
 /* Resctrl MSRs: */
 /* - Intel: */
 #define MSR_IA32_L3_QOS_CFG		0xc81
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index e531d8d80a11..81b986e501a9 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -135,6 +135,13 @@
 #define VMX_VMFUNC_EPTP_SWITCHING               VMFUNC_CONTROL_BIT(EPTP_SWITCHING)
 #define VMFUNC_EPTP_ENTRIES  512
 
+#define VMX_BASIC_VMCS_SIZE_SHIFT		32
+#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
+#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
+#define VMX_BASIC_MEM_TYPE_SHIFT		50
+#define VMX_BASIC_INOUT				BIT_ULL(54)
+#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
+
 static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
 {
 	return vmx_basic & GENMASK_ULL(30, 0);
-- 
2.45.1.467.gbab1589fc0-goog


