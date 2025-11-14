Return-Path: <kvm+bounces-63272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC36C5F4BE
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C2D1C3545A7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD4834B1AE;
	Fri, 14 Nov 2025 20:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k+1HniI9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C9B34A78C
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153495; cv=none; b=QlMLhjbq2156nz5CrHbAox+MRK5Vtkk1JbkknyzM4K0eXAkMUUxY4D3t9ecwKGBuIga/3PBwCi0m5oBQfAyV1RVAks2i1Pj5gxxQnrALXgrfNOjL9DUuaj5Bm/jOEHZkTQFiOva2SWnur7+FDndmW96ZjaYEjXb1O9W9dSmihaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153495; c=relaxed/simple;
	bh=dU0PuvMGpmkJA9ZDnBKhe1PSrJr40mdwnagED1Ws6lg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TwpzRQopAx2tWtQPzeKEJHHAXDnmC8Dv9jqHbRLDivHAc1xM8z48ecGrc1CqXWAsIVjGQHtriAvqjuuJSFh7lgA1uLD0cFG7j3o3AGGYx3H7CWZsJgBXb5ebr2hF9F7hQeQ1ImBbHhuFQStPIDaQH5I/fJN4YXi84y1ROsnLF3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k+1HniI9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340bb1bf12aso5807214a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153493; x=1763758293; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MWoalXmZtfEkH+RDTpL9EzSIxkJNxsHuiroKuGJdya8=;
        b=k+1HniI9+NBi6OUevv6Q6HytZZRanQf2mj8iGAbIk/Qi7rlmu8FrhKfRcnr1RxJazB
         Jj+XemHuiT/kpddu0NYTHjIEv5pDKBG9mXbtk8eqEXxdz7vs6XdGzYbI7cCBEPrA4L9h
         nQSHgiXSrZx4bg4avQChqoe8I/AZpYINcmJ7LTJsNaYgbJ8lZal37L/4uqLBP7SLn440
         ouNR+j1M4vA/0A+ypbHhrfZqdg/lERStlslMFZWXIbBSEwmZCmm7OTIaPUQcYBLT2C7U
         eeuadAr1NsAqyP6FhBoLVuym19gzy5Zi519Ttcy8ZCxC8E24sjpricT6wy/jqGp4gmW1
         sKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153493; x=1763758293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MWoalXmZtfEkH+RDTpL9EzSIxkJNxsHuiroKuGJdya8=;
        b=hJW/K9iMBaU/MavmE0A1AucIzpsnYYkgnm7+5gpfGCtPo/aPTGxN8mA1n/svW492Bm
         DX5ySXwkr1dc0TMVBXEySwH7SwFnQhmehTfBI4mqgM37koN20M+9Y0Ef070rIOUYWkbO
         jXRsEgt0bsAGlSlKApGviXOzLlLDxE1hiqAvqwwMAI38a+O18ICIg78JLFDAtEQDi/qs
         D4Jfc82fZHx0D9+zhmRceSGckiwtrO7J4SeYeqY8gKUyeZpzOnbWLh0Au4uVayjyqvCl
         ANMlLM13flbCH13RCKiUU3e8XzYk93BVT2xADVazJUa/YrRJC/SFD/CJUd5l4GmKYDLF
         gz6w==
X-Gm-Message-State: AOJu0YwWKz+YZKW0ym6cRwKk5eDAwWoGNdC/Z/5iliwEff9Ux1+CONS6
	aYlZVofm236/YPNCF/yCzr4AX7v8l0Ts28k2BJ5jJQ/PMimrzf9Nwzb6OmhBFORqAmlZbk56/ag
	2GUq1eA==
X-Google-Smtp-Source: AGHT+IEkVBXtjJenyi/eHLqTn3gmeFBUvh1QY2Y/XVekPhl/Ynq+3zVENJODvpANstKaF17UxWTPz42GGtc=
X-Received: from pjwt7.prod.google.com ([2002:a17:90a:d147:b0:32b:ae4c:196c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3509:b0:341:8adc:76d2
 with SMTP id 98e67ed59e1d1-343f9ee49a5mr5359140a91.16.1763153493573; Fri, 14
 Nov 2025 12:51:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:58 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-17-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 16/18] x86: cet: Enable NOTRACK handling for
 IBT tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

gcc's jump table handling makes use of 'notrack' indirect jumps, causing
spurious #CP(3) exceptions.

Enable 'notrack' handling for the IBT tests instead of disabling jump
tables as we may want to make use of 'notrack' ourselves in future
tests.  This will allow using report() in IBT tests, as gcc likes to
generate a small jump table for exception_mnemonic():

 000000000040707c <exception_mnemonic>:
  40707c:       endbr64
  407080:       cmp    $0x1e,%edi
  407083:       ja     407117 <exception_mnemonic+0x9b>
  407089:       mov    %edi,%edi
  40708b:       notrack jmp *0x4107e0(,%rdi,8)
    ::
  4070b1:       mov    $0x411c7c,%eax	# <-- #CP(3) here

Link: https://lore.kernel.org/all/fc886a22-49f3-4627-8ba6-933099e7640d@grsecurity.net
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 26cd1c9b..74d3f701 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -82,8 +82,9 @@ static uint64_t cet_ibt_func(void)
 #define CP_ERR_SETSSBSY	0x0005
 #define CP_ERR_ENCL		BIT(15)
 
-#define ENABLE_SHSTK_BIT 0x1
-#define ENABLE_IBT_BIT   0x4
+#define CET_ENABLE_SHSTK			BIT(0)
+#define CET_ENABLE_IBT				BIT(2)
+#define CET_ENABLE_NOTRACK			BIT(4)
 
 static void test_shstk(void)
 {
@@ -112,7 +113,7 @@ static void test_shstk(void)
 	install_pte(current_page_table(), 1, shstk_virt, pte, 0);
 
 	/* Enable shadow-stack protection */
-	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
+	wrmsr(MSR_IA32_U_CET, CET_ENABLE_SHSTK);
 
 	/* Store shadow-stack pointer. */
 	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
@@ -140,8 +141,8 @@ static void test_ibt(void)
 		return;
 	}
 
-	/* Enable indirect-branch tracking */
-	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
+	/* Enable indirect-branch tracking (notrack handling for jump tables) */
+	wrmsr(MSR_IA32_U_CET, CET_ENABLE_IBT | CET_ENABLE_NOTRACK);
 
 	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == CP_ERR_ENDBR,
-- 
2.52.0.rc1.455.g30608eb744-goog


