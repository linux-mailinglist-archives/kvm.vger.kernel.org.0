Return-Path: <kvm+bounces-17782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C108CA1A9
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B80DAB20DA2
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4ABD139D0E;
	Mon, 20 May 2024 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0z3VlvvD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C08139584
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227981; cv=none; b=XlXjR6Ij4b/CPrStCVm0lkKatlW8yTmNVwgDBSSI5LahgREGtmsXmCzH9Mzk3CHz54Jb7cQONvcfJU88ewd2ILyAVskSNXjSNdBEr3/aE8fcmtcZTJyrWp/6UNjL9ruVqQe1u5/M5asLYOuIh0n2zL+49rX8ISujcQqOw1Xfmts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227981; c=relaxed/simple;
	bh=nXHVpzniZOysYzfW/CV68jHMygH8DnBCyqgjKkOhtNw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZzKNiLrWsiAhXctthTT0K1McdTH/2D1mlvtyJ5sIUgMZfc0kcb8SeeM+uGkRJvcX/FL9OBjBfu8yv7DjSsLOISU5OJbX4Drj7xBAtgJcl3DExAurOGOUyA271e4zesE8n/uqQaGNzkLtnGgAdN3OPRACE9AdzHJQvCYOra+/Gu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0z3VlvvD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2bd72b9d660so1503810a91.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227979; x=1716832779; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VlfduVinRWM9m0GyTF5hGISStcVx0wfGxxyrYdGA6O0=;
        b=0z3VlvvD7WIs+nd39R88vMlTDYuzWtx3Jh2fDvO6BxcbwxelBgtK+CliHde7Z64+vP
         CZ9Epvi2bYuTxqWmuLEupmXjELSXTaVQKpUnNFgocuN3RHswHk3lnX/8iBA3Vv8Rlfyy
         3xm2jBDe5gmrKuBsaMnvIWxMtDvaRJdrUQBlMTtHIjD1Qg0fGvWTyagQBSdTe1b8qNVP
         EcC/0jZ7G9zaywvbIJhv84zoKQGH+zXgoezen9+DlMNqHiaa4ujYw2w9DHNAkMR1Rwvr
         0mlZ4HPJohuzdVXQK7secwLogaOfI2S/2lq7maJH6gSHbNqKin6rcpcFO3d0WdGaYS7t
         heig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227979; x=1716832779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VlfduVinRWM9m0GyTF5hGISStcVx0wfGxxyrYdGA6O0=;
        b=JMNeh+A5s3h+rFEoMASGxXlEFp2Py7p/N/ipel0jAPFbolzdTmQZiK56Mo5CC2AaSf
         R4JCxSTIjzunrYMk942Hrf92aurr0y+ByEDgiP7G2/1i+MtfKNluG/0CIb8cQND1LknU
         UGtWIPc3+A5ed0/+mhKKun7NrGYUsVCnuc7MqQvSGFa7SPyIZEWwTrA8qBOK5NiqrjGy
         DuJO/Z1x3Zm1ao8R9aKMaEpwKc9RYGGuWuABLrAtUM/EokJrSV8ufbxQTVo1tm9Rf7sB
         36m1rdKSWE1QdvOTjLKXqqT0hrZM3ZTNa5mUwommlJ5PxfpLfz4Fy+zQKYDClt3T5gFV
         I9dQ==
X-Gm-Message-State: AOJu0YxsOWI1S67ADnxcC9+J2uLrJLUbEHJ5THZkr0Ccq36tOZFWmS1s
	bY5uDQtLO+w6YJZkLBNOysHGQtgx9vzz0zlN/LSy1qLLeFHpAThLdpeKnFZ1DlAG45y9mHZQRbF
	2Ww==
X-Google-Smtp-Source: AGHT+IE2DqlU3D5hQsMzthWvSFDNrYVJ0U+lM4nqHPlKffjstwVS4slgG1nG5ISlW+rP4RrEbCyLl7Dgr9o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9408:b0:2b9:78b9:fefd with SMTP id
 98e67ed59e1d1-2b978b9ff83mr52559a91.7.1716227979228; Mon, 20 May 2024
 10:59:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:19 -0700
In-Reply-To: <20240520175925.1217334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-5-seanjc@google.com>
Subject: [PATCH v7 04/10] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to asm/vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h | 8 --------
 arch/x86/include/asm/vmx.h       | 7 +++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b14434af00df..7e7cad59e552 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1168,14 +1168,6 @@
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
2.45.0.215.g3402c0e53f-goog


