Return-Path: <kvm+bounces-26846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 151A79786D5
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C97892864F1
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D17B126BF5;
	Fri, 13 Sep 2024 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJ1d30kc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3780D84A5E
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248774; cv=none; b=THNvEabo8RFFwSz+vIiLf7fnchbobMifduD4jtxxdk8Jjy7m3wMpapEfY/YWoKPiMflnCkxRQoPWrtoRFlt5n1JpfwO0f6cb7Lgj/LfSJUNjWXVdFq3bsJR50XTKQc944ytnxeFK1+X30000rk0kzht2BcKse1u+coN2cy16jwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248774; c=relaxed/simple;
	bh=HDuqfoGAVFaFiIFfM0Hgx7ESE0/KySm9U402yKd83Lk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=faVsuTeJYrD0akO/rYFGdpJbz8lXe4+C0UVXhI1zfnkKVuGcYqIEPvZ0dPy83EynmDEc/DbsVoAymwcoKytPWSQ97FgyZdo4dslBu9A5o0nwur4Y+jULR63NjFeZ72tHZpOdxiFcPSJK3uC0Rgde99Xa3eUY+ey4FmLUUklQtmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IJ1d30kc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d8b7c662ccso3158963a91.0
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 10:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726248772; x=1726853572; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0xC0WDg0DA01ClxmzXesXFMgeFghs8OuAlIxAFkxwlI=;
        b=IJ1d30kcqdzwnIyrlfd16smjmHeUr/D7KDywAsdo1k+965L2M8xCAcvTGuI7PvWqFb
         OX7W8Vt7BNMUMv5z9lW4MTol8f7fuPXnEgzNUcgEarS5f6eJeTpwimDSf5mcEV26xP4c
         riJBwPY2I1DohmdoFt9OW3E2W77aKGqkUoDaQ8o1ZpR5e7IGbY9vAU82AQ8UCJX7nhm4
         suXkbXDVQXJAwwgKHwKrblDIcoRB5sco70RyU63JMuKoTs8JH6jxVZn8w3k1PfZ97eIF
         bOpHshaZ3TTc8ojPJbKu8LnAZdbZ+geyCPxSqOt0UdPRpDzshrxhLT9RRKXTfeqgW9T6
         eJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726248772; x=1726853572;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0xC0WDg0DA01ClxmzXesXFMgeFghs8OuAlIxAFkxwlI=;
        b=H42xPlcKOylcrT2ONLVXaTQlSEvwhhrdcSbBBq+A0YLNQG/IsvKJZ2WWCf27khCplA
         b6NJ6bqsn69n2Hf+V73d3xWZFI2b6vzcx5RgTRvE0ZQhS7aUyqzx955zF3r7lf3G+ijt
         4/GF+wY9XxssEbDX/3OjosNV08v93DSRbCDrfUdPCZ5oo9h2OKpqZhMABvvtybWlZfl1
         pCu46f1nueaKI4SSwqtEClwQ4Gz+R2+EIYOEWnLET9Y+3/Q2Vlfo7XX2OpQKc1vEdR2/
         u8ubT8PHDklJzri+wWuLruZaoQiixo2RRrcOIAVqlgD8oaMMyX3+FANwoYvozt2soAJL
         SkYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMe7a4gNMYusGAw2Kawm1htYKiCEbQG03n0byo3sdHsM/y+2qFQOiDyYKmE3GHfU5fMhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF1Qas/rycRNM8SEXerc5EWNWb0Er6sdleAhwFJUvK6htH7x8Y
	+YnJ8YFDbYICIzw4S5e9npfTIJXAUwQw2yagaJYd68uGMcVY4imp6U8QRch1VHyuw1Bswpx8JHY
	WsapdCexHHA==
X-Google-Smtp-Source: AGHT+IHMNOAn6ONfLm0s0lShKg1+JX+PSnwD4/Fe9XkheUIM13sgRhSgr1mgasZb8r9b3ATfihXftl8+FLb4gQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a17:90a:f60a:b0:2d2:453:1501 with SMTP id
 98e67ed59e1d1-2db9ff6b19amr14420a91.2.1726248772274; Fri, 13 Sep 2024
 10:32:52 -0700 (PDT)
Date: Fri, 13 Sep 2024 10:32:27 -0700
In-Reply-To: <20240913173242.3271406-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240913173242.3271406-1-jmattson@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240913173242.3271406-2-jmattson@google.com>
Subject: [PATCH v4 1/3] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"

AMD's initial implementation of IBPB did not clear the return address
predictor. Beginning with Zen4, AMD's IBPB *does* clear the return
address predictor. This behavior is enumerated by
CPUID.80000008H:EBX.IBPB_RET[bit 30].

Define X86_FEATURE_AMD_IBPB_RET for use in KVM_GET_SUPPORTED_CPUID,
when determining cross-vendor capabilities.

Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index cabd6b58e8ec..a222a24677d7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -215,7 +215,7 @@
 #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* Disable Speculative Store Bypass. */
 #define X86_FEATURE_LS_CFG_SSBD		( 7*32+24)  /* AMD SSBD implementation via LS_CFG MSR */
 #define X86_FEATURE_IBRS		( 7*32+25) /* "ibrs" Indirect Branch Restricted Speculation */
-#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier without RSB flush */
+#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier without a guaranteed RSB flush */
 #define X86_FEATURE_STIBP		( 7*32+27) /* "stibp" Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_ZEN			( 7*32+28) /* Generic flag for all Zen and newer */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* L1TF workaround PTE inversion */
@@ -348,6 +348,7 @@
 #define X86_FEATURE_CPPC		(13*32+27) /* "cppc" Collaborative Processor Performance Control */
 #define X86_FEATURE_AMD_PSFD            (13*32+28) /* Predictive Store Forwarding Disable */
 #define X86_FEATURE_BTC_NO		(13*32+29) /* Not vulnerable to Branch Type Confusion */
+#define X86_FEATURE_AMD_IBPB_RET	(13*32+30) /* IBPB clears return address predictor */
 #define X86_FEATURE_BRS			(13*32+31) /* "brs" Branch Sampling available */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
-- 
2.46.0.662.g92d0881bb0-goog


