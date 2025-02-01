Return-Path: <kvm+bounces-37035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EA8A2465A
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F301167A47
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F275336D;
	Sat,  1 Feb 2025 01:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iicOtG3b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62CB224CC
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374924; cv=none; b=JW1RJyEeX3SxwEoyJE2rp7lYGzILQVedJnhaI5f8sqj75n6BsUBAJjDR4fv2JIYBktWvGxYwxyxSnfC65epM+LcsItPdcpqE/K+wVP89BQ1pzFTuT2I7HS6YjSwAtqRRpRDotugtvQYX7ToNvsJ982HSW84KoZLy/+/PmiMy9qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374924; c=relaxed/simple;
	bh=0UVEz7Yf4APmVdd/+AGLKukxGO1cn8yh9iUuPAteZH0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y+AD2wr64OFur1xl2ohPPVbsg5MOEQMQRpiYYi4L/qTaIXEfMcR88hooY+MjD3KOnvS7tDBSgRcBvtIfn6Q/zmkB7ZjzYhACDEyYwNfYv2yvoi1Xy+LfeEDA/BXG/lb0/2pd8jEjE0umS2u4U5EZOszIHM2a04bR6cg+IJdIoW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iicOtG3b; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efc3292021so7243802a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374922; x=1738979722; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ch7J5FApSjtLmMgjboJuXdLA8zQpXCRwdiOWm7e70JA=;
        b=iicOtG3bpbeHW44yFQ8yLwn+p2w8oZxs+jt0zfEvwHRKOqtxxcSbkYpF/M3ZM0feDi
         jplq2VOTsiLMtCjZHRcMV8TOVt9p2xeElMWuebUR1U+j2ffVWWviJxyITT9s6bx9dXRn
         FRdBEzBTmJ+lyqxWo5PQDuY1s1HVKUlxM60gNcUoI5E+1VL893FVim4v+V+NE1lBr8sl
         hF8LzVGKihB5MfYybljA+uemWgsIQ9sU4b9W7OpA9HIsPjxA8Li7mpo9GbQIlCTE06UP
         iNWqrnso19e3Z4gcrZOpM4e1CFSC4vtNvLbAqkg4F0nDsi0Z2lOAs6Z9Mw+5CC2JSOZ5
         Diew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374922; x=1738979722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ch7J5FApSjtLmMgjboJuXdLA8zQpXCRwdiOWm7e70JA=;
        b=OKQaixv9pFM3zfv9EFE/9kLY7EstCVAroP4wSzgyiOJct+dey0Uz6KhL3J4hry8ZNo
         wfotSpHRBenjfRQpRqHhfzgYzPq46EmIGbiwZM0MycVzojv3Bn7/FkGORmJWG3LHxR9B
         D91bkOORGRthVhY0v99GhXO2XXpr0zYK84+bRx5Q89c6xYYoyBrS1FnDb676DHaNUTIK
         i5zNEcVs4nFyp9IEU3OfYFK0fsOF7naJIDTpYpfGkhv92Jmf03pwlmEaRObHfuriFgye
         /eRGxp6lgz4cS9S+11paeVRr7LYGTJ9dr/BMe/mndHHwmBZRrUHtUqlAq9zvO6BRXe6M
         7KnA==
X-Gm-Message-State: AOJu0YxjlCLCDdkzD6hVN3Zn1WmVasQe2vsWwusbP0+NIy2KtBeK0Ghk
	2g9KyKbQsKkU/aGEUuYwBBW9o5IT2sidhG4BDNt32GDMsnGggyIKDMVhex4EFN5GyvOFBRqmZCj
	41g==
X-Google-Smtp-Source: AGHT+IGvjkw8fnnEbcSuYvUL2VtZua6gMJ2cUrDqwz56RDm9CnaQqFl8dZRTAPoXgRzxuzyE3ZLzmsbAtzc=
X-Received: from pjbqb8.prod.google.com ([2002:a17:90b:2808:b0:2ea:6b84:3849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c88e:b0:2ee:ad18:b309
 with SMTP id 98e67ed59e1d1-2f83aba9d18mr18457927a91.3.1738374921915; Fri, 31
 Jan 2025 17:55:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:08 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-2-seanjc@google.com>
Subject: [PATCH v2 01/11] KVM: nVMX: Check PAUSE_EXITING, not
 BUS_LOCK_DETECTION, on PAUSE emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When emulating PAUSE on behalf of L2, check for interception in vmcs12 by
looking at primary execution controls, not secondary execution controls.
Checking for PAUSE_EXITING in secondary execution controls effectively
results in KVM looking for BUS_LOCK_DETECTION, which KVM doesn't expose to
L1, i.e. is always off in vmcs12, and ultimately results in KVM failing to
"intercept" PAUSE.

Because KVM doesn't handle interception during emulation correctly on VMX,
i.e. the "fixed" code is still quite broken, and not intercepting PAUSE is
relatively benign, for all intents and purposes the bug means that L2 gets
to live when it would otherwise get an unexpected #UD.

Fixes: 4984563823f0 ("KVM: nVMX: Emulate NOPs in L2, and PAUSE if it's not intercepted")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f72835e85b6d..3654c08cfa31 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8092,7 +8092,7 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 		 * the PAUSE.
 		 */
 		if ((info->rep_prefix != REPE_PREFIX) ||
-		    !nested_cpu_has2(vmcs12, CPU_BASED_PAUSE_EXITING))
+		    !nested_cpu_has(vmcs12, CPU_BASED_PAUSE_EXITING))
 			return X86EMUL_CONTINUE;
 
 		break;
-- 
2.48.1.362.g079036d154-goog


