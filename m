Return-Path: <kvm+bounces-57475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2DCB55A3C
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43BE316C1A4
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38ECA2E3B0D;
	Fri, 12 Sep 2025 23:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dleISosl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678ED2E1C6B
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719466; cv=none; b=eoX4PmyfggNnCsMkpMFwF1ccKcONPbnfChK/n8nt/Q5tQmKTOR+fJ8br60aI+zxQLXBDjNSpZpgOudKI+1LRXulvyzz87XWHsNL01huoJ/Rk3EC+YJWtiOfEy9MI7UxxwnhiInbgn0ex3pfy3SmUoKh/XRySvS/rhavJEUxe2Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719466; c=relaxed/simple;
	bh=oqfxEduhxDr+EMb4NgJ6QjjX4Eln5KqTEXpKlxdlRLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YMG7oh0zowiVr7hapaXssCOS+RPjGUysY5ECMfYpvcJtO4ucdLCMkBvb4iUALjp4dUXm9kzrt0p5BXH3ACCIjhNIHnyf/HFl0X6DyQAAA767cBxdBgdu+S75kZ7Zmb9Fe4Afpa1frZaD2uOMTpYZYe79U/jtMa58J9WDm3F7jT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dleISosl; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24ced7cfa07so26275125ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719463; x=1758324263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oN2KOTjTaXX7Mn3Y30lree8vkKri8RC5m3orTfrrrD0=;
        b=dleISoslxIrA2H8b4AdUOHZCkSlLd8x6EvolG7fiRdfyavD5Y1198N7RitYQqiTH3Q
         QXs/gfcMPXyVy8o6IEK81Fy0M7NTm0iv++YAse94/ZEpT3BfXizl8VT4HQmBtAfBbL1+
         UheqbyoexQbjfpFquYAXytgVMAwHhlVA6dl6hOQvjQ/ed/SH/pd4DvebVaHJ1a2LSNBP
         h15Xrre74e9wqQUbpOBPHQpj/PXV5eowRoeCbglw7LtfOdLQDUnXa7ptOLnX5hjbHlai
         0hbLWCttwEDmiWiO4FkKIppGCk7mtRHcHdomNk1dNHc/chHLUzRl+5rGvWhar4hSuLsi
         bbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719463; x=1758324263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oN2KOTjTaXX7Mn3Y30lree8vkKri8RC5m3orTfrrrD0=;
        b=PEfWaeAnH6cVsOEEygh5I659xA/v/Q63RXLintZTbptjotXKBmEid+nulDlIAb2Lqj
         GNgDH7DE+ZgG5Z5YUxg5eBt0Pg7l5vxCoQsZ4hfWHM/1F8GnIu9e3ZoiPFtdbi8AU4MW
         kCOEgwNIhhNl0KfpfFSgNU7MBmE6hDeA7sUvBmUz86Lem81abgaVUADdeaOO4Td0oPSd
         CkBqFy2oYy5dA6oXbG3c9JwCfZ+1QGFrh9XMeqUsKqNQsVFvZgArlnAVaATOL7150Vki
         Iig9mfJxPggK+DN5ajpjzHZCnULJiCvfz8fLTpnEUlSC8aq4i+wHr2OwKZdYqGzkO5TQ
         T0Hg==
X-Gm-Message-State: AOJu0YypbN/bW0Eek8wawPQrw57S2RByl1rQyLLl3OqktKCLxYoVIyd3
	xU81P+85TiCi8pgWyzVo7t0pTejWtca88Tu6I1KAHzumFPcBXJcvK3KQlbI1fc8O1RUV6LxZop+
	DeVM5JA==
X-Google-Smtp-Source: AGHT+IF4ouXasakEIa4631sD0tHiSMgMdyeOf4Be425QMzhF4PkjL+dHALvyxn4cB9SRRLA42F0LmF5uaLw=
X-Received: from plblf15.prod.google.com ([2002:a17:902:fb4f:b0:248:753f:cb3a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea02:b0:248:e716:9892
 with SMTP id d9443c01a7336-25d278284a6mr52818135ad.59.1757719462726; Fri, 12
 Sep 2025 16:24:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:10 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-33-seanjc@google.com>
Subject: [PATCH v15 32/41] KVM: x86: Define Control Protection Exception (#CP) vector
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a CP_VECTOR definition for CET's Control Protection Exception (#CP),
along with human friendly formatting for trace_kvm_inj_exception().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/trace.h            | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 8cc79eca34b2..6faf0dcedf74 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -35,6 +35,7 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define CP_VECTOR 21
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 06da19b370c5..322913dda626 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -462,7 +462,7 @@ TRACE_EVENT(kvm_inj_virq,
 #define kvm_trace_sym_exc						\
 	EXS(DE), EXS(DB), EXS(BP), EXS(OF), EXS(BR), EXS(UD), EXS(NM),	\
 	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF), EXS(MF),	\
-	EXS(AC), EXS(MC), EXS(XM), EXS(VE)
+	EXS(AC), EXS(MC), EXS(XM), EXS(VE), EXS(CP)
 
 /*
  * Tracepoint for kvm interrupt injection:
-- 
2.51.0.384.g4c02a37b29-goog


