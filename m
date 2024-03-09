Return-Path: <kvm+bounces-11430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEAF8876E8A
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC8301F22A02
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9903436AF2;
	Sat,  9 Mar 2024 01:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s85dU/Wv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A60B2E644
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947660; cv=none; b=WcNPdT/6Io3L24pyj57L4kP/2nZVtLT9UgDTz3EGBZRedqyZYN5VRLksMIwCCy8bD4l5O2sMCDFdlZ3I9FfPcM3iZQghZwZOT7A1m/dKwDGpeZfU8hKrpJRy/jCY8ySOyFqUqAvOCqwjk+KxaWPJ2YO53NTDobR9y/tc3rSU3vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947660; c=relaxed/simple;
	bh=cSo/9H4LV+ugQDK8WH64MT/A8kylvoerz+EThSRDTZ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tZspA6pzvPLX6sdTybKaXgGRiiK4f+JLO7wLTx9oV5aOqz7/jonitz+NqUvlFxzsfzqMwBH9ojxeSiNdhXpShhFuxzzrEmiCAmOzgy1t3ca+bUhNhFOeScwo64JUUHW20WzCeHgUBPLo5VlzHByLzjc4wqSlsPOIPVr1C1KS7Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s85dU/Wv; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d9a541b720aso4750458276.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947658; x=1710552458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J2mk3yjINFLzpjFivjrb5N/1XLkVh6F5pa6/JTyW+Xg=;
        b=s85dU/WvNT6ambJeTz55S2TJcT8bgzf2wWEEFHu0dKcS3Qv6uzfwJAbFAgJSxuuLYo
         EchOugvVQNajRruIO3ECwj6usk2UZ5X+H1T0BffxnsCm4Irs0Pxi+c72NdTC4y6ViRwq
         2xZ7ZoWgyBp/u0zLjKDXSG1rUBU3jhk5d67edHlWz20p95ID/dXyB7RJsn4vj7mDbCBs
         v94oKwCfjaYeAa1mRxKfMA40cGFFwFHnmbq5eqJwcMMnbyaeaSndEXWPCjIgTIUbUFXd
         i05LAOZpzKVt4Dzv+fJvAGoxILN1zvTBkEa+aPDQAQ3PU9f9q22RmFbnOevnoERbpwiL
         uC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947658; x=1710552458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J2mk3yjINFLzpjFivjrb5N/1XLkVh6F5pa6/JTyW+Xg=;
        b=Mh7X0YGkAVYBhLO4+PONXdtnnL4tcJ9OOtvV6XZW7z8kwlx1Z604LFTM7SR5AGwI53
         K+cbVVh+2lTPpWXs/RO8SVaLsMA7WMZdBNpzL4LSoB3/FaNvIueACtE4il0ePztfRF35
         3+1VhfyjDm+9xqjyK7SAv7TNSs05BB1RBhY9yPQDqKw2fEAXrB5p6lwvK8Q4+wFM14sv
         XAdn/m6sqLDI6eyGAeySloIWOlM4siyKY0OIUpssgM17VXCK7LhOckNMh9YAmujSuVZb
         ioHhkl/+b4JM8rJ5rZLncw4UrsnrymBO7XpOT37tP++nBGgL7Nd9RnMMYHmLz9fmSTHM
         tSDw==
X-Forwarded-Encrypted: i=1; AJvYcCUt58yrOKpdjkLf6l4/XsNXQwBINXWLutubcPqMDvWbEbrluZi0NXOBX/LKQp4h/5RydIO4cDV3uuS2Hv1dbgEwjU7v
X-Gm-Message-State: AOJu0YwQ07dgH+Hz2GLX2vMh+HauE1htnViVFIGWQiXbOcJljsyNP5DR
	Xdum07aDTms7Rpjem+cVFgzIB+4AqfV2THrMQhePhhmQRxpgzJoPaVD/MBXTOGZK9+5oV25AAFi
	NJQ==
X-Google-Smtp-Source: AGHT+IHrI5FDrUBoUl0r6JtHEuthwtAy7BhRUu74r7xvlQts2botI/ZyPUrf7LiPIj+ypGRGHDyvqTmpyOU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ef46:0:b0:dcd:88e9:e508 with SMTP id
 w6-20020a25ef46000000b00dcd88e9e508mr185467ybm.5.1709947658336; Fri, 08 Mar
 2024 17:27:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:20 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-5-seanjc@google.com>
Subject: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to asm/vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Move the bit defines for MSR_IA32_VMX_BASIC from msr-index.h to vmx.h so
that they are colocated with other VMX MSR bit defines, and with the
helpers that extract specific information from an MSR_IA32_VMX_BASIC value.

Opportunistically use BIT_ULL() instead of open coding hex values.

Opportunistically rename VMX_BASIC_64 to VMX_BASIC_32BIT_PHYS_ADDR_ONLY,
as "VMX_BASIC_64" is widly misleading.  The flag enumerates that addresses
are limited to 32 bits, not that 64-bit addresses are allowed.

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h | 8 --------
 arch/x86/include/asm/vmx.h       | 7 +++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index af71f8bb76ae..5ca81ad509b5 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1122,14 +1122,6 @@
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
index 4fdc76263066..c3a97dca4a33 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -133,6 +133,13 @@
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
2.44.0.278.ge034bb2e1d-goog


