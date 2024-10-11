Return-Path: <kvm+bounces-28655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D6A99AE2E
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 23:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CE9B1F23E14
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC261D1739;
	Fri, 11 Oct 2024 21:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kxsPETSC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D666C1D1721
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 21:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728683057; cv=none; b=XSNFOOs0xMt/49s9PK6+yQWTYt/D+vAEcuYvJT9puYKdNGpz3M/lRxQL4CSmzqD6C1n1GdfPZscz0Qyma9RSDU2u7lAfPX/xl2yVFLFTR0a1/6H7fbsTSZGKDY1p1Er7jnd9zxGhp51olnhXcyHwrTPJezdGPm7iQRRdBEf4Bpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728683057; c=relaxed/simple;
	bh=Alfb43ggy1morVAhVCl9j9Qs+u6QkOqSpSocYaViI8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R/DTtoPUk9+tYkmO7mC+AKXBnFbof+h+eKMiDNHRVCXvr3MrBTCZ9ICA6wL3lcBc0mlq3fLLynLBHekfjIC9q0+TSRzy1zVROLnWfeLhT6T212HTuRuvdqNH01pO7xse7VNsVRWZf+863f4rWV15D0nLb4IbG4Phw5T4b1QEgJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kxsPETSC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e368933adso2134392b3a.2
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 14:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728683054; x=1729287854; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8FDOlqwvEsdAJAf8IdqafehVhAI8JwdIbxbRDiLpiY=;
        b=kxsPETSCMazyrqlUZ+G7O95fuiPcGSkrzp9eB56qC2iRtLKxU7CrNCYH1K0PT5uWWE
         rIu/HqgfJuP81HV4nMwvt3Lk9dPpZNAQ1O+a65GuMgt7V5R+PeJs4oW3jTN53xFkakkL
         54le5HOUTrFuFwj8l0MCRM2V2C24tOVm6LaXKRIFYeugRL2twulrMl/NpiOYJLRROUUD
         PuFjDfnAonfYij0r9N3+j75DhTafkLfSEXMaC/7p2gtG2Za8vOV9YebrrgQDimTAllrY
         L68RJGiNEpkW4KfFVCOqTNSGcZeuj6iTDNGVyOkpCQJvcQ2uYp3fVXtE4ac6NDx6cSqk
         HsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728683054; x=1729287854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8FDOlqwvEsdAJAf8IdqafehVhAI8JwdIbxbRDiLpiY=;
        b=SeXXdkl0HQDJMMSBnahN6v/Lex1Svfebm+p3tFe2lGx3/8cz0d4q8hA9/T0TNNmewO
         DKU14Duu9c6/uUaC5sctLCiyO45MpH2viHrWP+Kes6pvKkp6VsfhXpuznd4EO0ZBsqYD
         GQYWsvs8K9JjeIc33DsLzjbO6V0GvU978wZrbyF87y/joJ53NVVpFG/mnK0+R5wixpIk
         M/7JvUfMRnusozvaXvAvvqNNC+WmKl1topuEcTt/mGXPqOUMemi6qRUNMSGwUBDLCF3F
         CdJBArbxm80/s5l16pFSNg4jciE1OVCTH/1C+8OOlNha4kSoBV94Nr6p11nEvVpS7IAY
         UdZA==
X-Gm-Message-State: AOJu0Yyci1E+gAC+j45E3tqE7GQkjI0bohpwRxvLbasTYe4GX+SP7wDp
	D6Ccw+fYyJ21O8HHHT6noEa0kvp2/zda2SN+e4qzH7cKJ7sFVxfnOxn7VVYLhgUjTE0zfdD07Lk
	Q1D0h2OFtHYHP32PlmfOkagrNHbZpz6siTS0lIyLVdsEF+xFPj0z6C9x9GuSUEiwS+As3vmHlay
	oC+ecQs8ax1WRbF4590Ek8UPYCH/OSofGH4mt6Veo=
X-Google-Smtp-Source: AGHT+IG+CTYjXiI2WYVmaCbmdgx8aJmNp5eEhEtp42YdvInIMKciu2bPG9BFE/JQsrplK7JkLlS0PX/QLI0I4A==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:6f66:b0:71e:268d:19a6 with SMTP
 id d2e1a72fcca58-71e37e28a35mr18995b3a.1.1728683053750; Fri, 11 Oct 2024
 14:44:13 -0700 (PDT)
Date: Fri, 11 Oct 2024 14:43:50 -0700
In-Reply-To: <20241011214353.1625057-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011214353.1625057-1-jmattson@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011214353.1625057-2-jmattson@google.com>
Subject: [PATCH v5 1/4] x86/cpufeatures: Clarify semantics of X86_FEATURE_IBPB
From: Jim Mattson <jmattson@google.com>
To: kvm@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jpoimboe@kernel.org, kai.huang@intel.com, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com, 
	sandipan.das@amd.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Since this synthetic feature bit is set on AMD CPUs that don't flush
the RSB on an IBPB, indicate as much in the comment, to avoid
potential confusion with the Intel IBPB semantics.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..644b3e1e1ab6 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -215,7 +215,7 @@
 #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* Disable Speculative Store Bypass. */
 #define X86_FEATURE_LS_CFG_SSBD		( 7*32+24)  /* AMD SSBD implementation via LS_CFG MSR */
 #define X86_FEATURE_IBRS		( 7*32+25) /* "ibrs" Indirect Branch Restricted Speculation */
-#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier */
+#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier without a guaranteed RSB flush */
 #define X86_FEATURE_STIBP		( 7*32+27) /* "stibp" Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_ZEN			( 7*32+28) /* Generic flag for all Zen and newer */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* L1TF workaround PTE inversion */
-- 
2.47.0.rc1.288.g06298d1525-goog


