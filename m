Return-Path: <kvm+bounces-63257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F0EC5F473
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8A65D4E2104
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A583F2FB63D;
	Fri, 14 Nov 2025 20:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I0w+BrPa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565132FB60A
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153469; cv=none; b=NSuskOo1rdgpt/yLj34W0bDc4yV60EU32QU6eF65W0cD4AQIgPTZwQDBvPoZHpeV+JkErURQczcFhGgLSSuxB0sTne+H7FA6NpbvLzv7BaA+zPxVu1xBLKX7JxI5F0quyHIVdtlxnwMDgKc2meLbXz5Y9uo9TB3bZNPdTh0a76I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153469; c=relaxed/simple;
	bh=w53kG4R7YwcZnR+lpXcyUFUHjSYejRgZ/c87yeGZZDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cIckuBwE87drsdTE39vWfijpViyBrXqG58G+HXCARkDXlqjd5bR6Hw0iBkSCJFF0B/H5uLvxBXdIxlxJ3Q5sjeeidhdDmyzpchYxiSwuqIGZpqqJKsjKeHiDZXr+6k6GPMTJMKeoNIpUiL13zl/ou+oI8er4/fk/j37vwf2Z/V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I0w+BrPa; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438744f12fso7088322a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153468; x=1763758268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FzRCL2bVhv1bnUeLRVlUhiFFBj17om1TzQexeXV1Pmw=;
        b=I0w+BrPaOebU5KWXlS+fxlo7n+AtpnGbH24ZvEK4Rz8dKw4mzLVC+V9BRzc5+fy9BV
         f+BHPmgHo8S2GHxgMO3/S1boXas9ERBKGYIjooJPSvsUIJaZM3bgwejwFswt/3f0WPNw
         vBwBiX3UVCyvqdiai0lOnWVSjm61Bfcwe471JJRc3//otQ/4+y2NfhY39VgwuEC2o6u0
         V41P6yPf39KUmpe35xIE3dji4pcIoE7IQHUwUUZMu329aSN7ZbKlG6YYi0imwtd9/gjw
         h5UNqphPmksgg7+LNqst7z8oI7GSxXw85SeM55J2jxDbyltL1xqVJxnP4EQZ6PDtbF2v
         UWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153468; x=1763758268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FzRCL2bVhv1bnUeLRVlUhiFFBj17om1TzQexeXV1Pmw=;
        b=rGu1W75DD1UOBs7jypp9wN85XB5xwz6PJkj4VOxkAA5uNIwKzVni09nSL7X1Cg8A8f
         vNVe3GX66pIgi1gpN0tBK8ABv9gB5LFp0qHFRdRHnvWmO3kl4amU5pyKcVYqYsdMt19d
         gub63FIOlKj01fOrq8K7yimN5zgf2ekMH7ivHdEGC62zaoYNCy1odNKopWi8nKthNRYQ
         2KIGXIXhKUml0U8Cr0qYcq+/I6mVzE/HWastAASqQkut79JahR/5QvuqJ8Zh8nPzXZ8q
         GD31qRW2e3ligNUR009hqA/vh0X4Pch4Vi5wZMSSKLVadtGn1UE09NCKfEWMuhP6riR9
         Prmg==
X-Gm-Message-State: AOJu0YxVIlpNLK3q9AMerDTEs9+65bvmKTakIdco7VGf8ltIuBZBMEV6
	+liMCSd2z/CUiB7+/pS64eFC5G41PCuZZEEZTMYVKTnvcTRJ1ijOuJtT/Up61FWE9TKP9oA7ZoA
	bdiY7Yg==
X-Google-Smtp-Source: AGHT+IHpBXPHYU6ccFGqwDh8d4IjtYaxNaoQ9xkdToSaCRSLN1ofM8oO6/ThiHU3SRQ9kgsMUrF3YF9Zk0g=
X-Received: from pjud5.prod.google.com ([2002:a17:90a:cd05:b0:340:ac4b:f19a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5804:b0:343:5f43:933e
 with SMTP id 98e67ed59e1d1-343fa52ba9fmr4639440a91.19.1763153467618; Fri, 14
 Nov 2025 12:51:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:43 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 01/18] x86: cet: Pass virtual addresses to invlpg
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Correct the parameter passed to invlpg.

The invlpg instruction should take a virtual address instead of a physical
address when flushing TLBs. Using shstk_phys results in TLBs associated
with the virtual address (shstk_virt) not being flushed, and the virtual
address may not be treated as a shadow stack address if there is a stale
TLB. So, subsequent shadow stack accesses to shstk_virt may cause a #PF,
which terminates the test unexpectedly.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cet.c b/x86/cet.c
index 42d2b1fc..51a54a50 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -100,7 +100,7 @@ int main(int ac, char **av)
 	*ptep |= PT_DIRTY_MASK;
 
 	/* Flush the paging cache. */
-	invlpg((void *)shstk_phys);
+	invlpg((void *)shstk_virt);
 
 	/* Enable shadow-stack protection */
 	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
-- 
2.52.0.rc1.455.g30608eb744-goog


