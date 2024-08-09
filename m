Return-Path: <kvm+bounces-23758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 349DD94D6D9
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E123A28411C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B09198E6E;
	Fri,  9 Aug 2024 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sbnrb9ZM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E74E192B89
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230223; cv=none; b=eLai607BKET/Dl4EksFrULlM27E++hQRAg3Q6egXZsQ2TEHLBt9QDaqIN0PPHQySSarQtppvuHH4lkrCi/q3sLPIJlWVKbEN23hG4d3oKzzAO3BzIz0Z05RY45czRjyg73IaJxc4mLe4GmM8r8Qw2myLTaOojD2SD4qGs7hmW9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230223; c=relaxed/simple;
	bh=sRrTbOJcfiSrIsMETnqBjIT3jUMPYwkaFHnukschxi8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=INP7g1Ap3uTpYs6RoatHUvgyg23QFW+5vNLt3j9Oxn3X+tQ9241gxJlOFWpggnXNWCyLfrzoy6bX97u0WKU0Jqh5ekehDFo40czZxVmrLKeWYwLA4/fmkZ44RHtpGGYV8QfcbjYfJNbkTKw35Sf3juoSejtwN/fa/f1NE8oLu68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sbnrb9ZM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb4bcdd996so2317153a91.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230220; x=1723835020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Dmb967qkQZW0D4SkRpUMqgdJRb4TcheZ9woSO8g40qM=;
        b=sbnrb9ZMAfulI93tmzCOU+a/I/BhuB3dybTTWS2Zgl4v8ppUHlGs9IYAjb2DXXQVw0
         7e+V+xCtv84Ms2c/WZBrbwE7Fe/Uu6lNHh05lOCCaO9qp6xffRdtedkzjW8iyNZQ+19F
         sxdM+BugfmxiNkoKvnLOFeHupznER39PGd+Y74g+d9xjDLo7IvqR/1eYAmEuUpivZRla
         nSSc8jqQKsUcaMC/2ykHk+M7CCEZLwbbbzLPZ4Gqxm493diqQ4D7rfSR8C56NtQUnvzq
         g48BuEKfhJUWyqnZ/4T26yk2IDHynii2RVRyRkDz8kGjPuNGfRcTFvRcZU4MmcRdETAb
         gUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230220; x=1723835020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dmb967qkQZW0D4SkRpUMqgdJRb4TcheZ9woSO8g40qM=;
        b=BOLtGJkUIbElEDOBMnU+0n2XORAPKMmc/mbtuWhDmY0AL0c8uM6INJw39oBdD7josq
         V9WXBNGSIsUb7xyWwAn2EC5T2cut+0AP1bImLr2oePE1gUyEnfgVMZt61tOVj4Pfuvgx
         IZOR+N30zMSxxZD2AID7aGODAwyY8sDkBLB9/57e4csmNnNKGb76RlcWPpQxgMLsv3nW
         uDRsIpVbzxMqebgDUUo++aVDtOROohh9P+gSZMffd8wc7NI8x7vcYCV4steePWk0R9ms
         3Kk6M41UE/YneI6mIG1wvrL7oQ82Tu1Ar88sPzRav3k5CpQ3reij0G2tgVr8bZ7tw5UZ
         FirQ==
X-Gm-Message-State: AOJu0YzfwJyHcJNXjgz5+rE+ahY/TzIGunqkWektDsKQHlGggGr3JoT7
	MlKMSf+KlIn6jUvCuq9oBY6+I7zg4TNULzwBsiewFkFQ/zTc43YljF1ZTuDJAewNCsoNWSjYWdX
	UvA==
X-Google-Smtp-Source: AGHT+IGV4VVBAjWqDuf8M8TDt3Ik+GDvR+wC8XLlmWU8kgrPMhiCKChR2E/SCFm3L0IlV7VJrRflltDSgTc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:114f:b0:2d0:11a1:8013 with SMTP id
 98e67ed59e1d1-2d1c4c2e3cbmr42172a91.2.1723230219818; Fri, 09 Aug 2024
 12:03:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:04 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-8-seanjc@google.com>
Subject: [PATCH 07/22] KVM: x86: Store gpa as gpa_t, not unsigned long, when
 unprotecting for retry
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Store the gpa used to unprotect the faulting gfn for retry as a gpa_t, not
an unsigned long.  This fixes a bug where 32-bit KVM would unprotect and
retry the wrong gfn if the gpa had bits 63:32!=0.  In practice, this bug
is functionally benign, as unprotecting the wrong gfn is purely a
performance issue (thanks to the anti-infinite-loop logic).  And of course,
almost no one runs 32-bit KVM these days.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 372ed3842732..4c3493ffce0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8934,7 +8934,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 			      gpa_t cr2_or_gpa,  int emulation_type)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	unsigned long last_retry_eip, last_retry_addr, gpa = cr2_or_gpa;
+	unsigned long last_retry_eip, last_retry_addr;
+	gpa_t gpa = cr2_or_gpa;
 
 	last_retry_eip = vcpu->arch.last_retry_eip;
 	last_retry_addr = vcpu->arch.last_retry_addr;
-- 
2.46.0.76.ge559c4bf1a-goog


