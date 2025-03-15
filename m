Return-Path: <kvm+bounces-41146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0BDA62525
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 04:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4476788095A
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE49E19DFA4;
	Sat, 15 Mar 2025 03:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gdiikDAQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16BA19C574
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 03:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742008006; cv=none; b=jo8yIrtt4yq8swQXkFef5ujuJGcGYBBGrLk4iGLovcWnXNp6u2fUBZ0GdfpO3QaY23bR0DJRSDXszHMZZVGEGCPJylklhD9J9obUbmR5CYu+v8HgwsxdZYUxY7m2SZdyO020GM+Tw7Vo/H9n7Y/Z/halx5Ev8LhKhmge04v9zWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742008006; c=relaxed/simple;
	bh=kyZPgKDP+G4NiFhQkapY7Z40kUAzSIF8X2Em11vw2i8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KX1HO5pWA09y6gt7zXNFptU6HxR0amllbiBviCbXhF88PkrwBL+cQN1sFso/rK+wW3OYwhoXoLbCIp11thrTW3l0CYOqVMg6O0YQk3qvgNwJvd0XbcMshTDuaTJ6uhBJyRe4RUjj2uY24n6ly/wyYsA6qXkqppjBDELoXdqPxqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gdiikDAQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2254e500a73so35826365ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 20:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742008004; x=1742612804; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G6aJw5/ES1UOfEaKxfAACWN89ZnVy5JuxHZXx05VAEo=;
        b=gdiikDAQmhkZVpccgyQyzXAoXEyPBvXk7uxwtMnsIEoCMG/6J/BXs7ntlpXlvhaXA1
         qQ2LV5Hub8fmwTAxiZrRsS7Mz8b6GrBvz68AtJVzAugBDu0ah73wDHoDEgJ+CapP0m/q
         EGXDQM7H2T47tzcJmExK1A9Dy1gMDJXJm7AhnGDP8O47sqB5Lvj993ozXe4kca2xFmOI
         s6yvHWTJZZd1PmuroBrrlZCg6S08dtxaU7fWrgmxz+ZUGaSFKZN90ThcSj33hQzpLw6X
         lrO6ftmct1pjCMTkIvTNYuTStn+DYlbCrnlyatbV33ODq3YtPYzHRtmIIR49Tkp8ttWZ
         CSeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742008004; x=1742612804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G6aJw5/ES1UOfEaKxfAACWN89ZnVy5JuxHZXx05VAEo=;
        b=krNo8fAobZhcpG8OMMmeHQfsMtsN+H1MsOvxBH0eLFWhDdbWL+5Od6aQ3JgyB2ODuU
         vrvfHuoWaHvrnBxdz3OMbvNuMEfbz/B7TrTvZw1otF49nLv055IAZqdXRY69O3EvEhOB
         OLOqy5CuGuvXNmDLXibSUizBlFRoRnFyDU7ltxyEgCLACK3R65Q79MjwYQxpf8Jz0BCI
         St0O73fYrnS9ENGlBHNBrbtHluF2jiN+R2V4lBGzggL2H6QWi9P9WhLrkr2hniFIbSNS
         VoHp+hPPCa5lyUzBPU+g/fw7p0FbcDsDL/UZqAR/oNYwjfuhW1Lut9DmOBz7pN4Kt5fZ
         YBew==
X-Forwarded-Encrypted: i=1; AJvYcCUApgvjldCprqhEhQBUN9xTCeVE4UT5bEfhF3NU+oRfSotzKKjcI7OJe7Xr23Y1nnATYXg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXr7IoIKBe08bZ3I1IacLEA47P1Ivh+ThRwd/dgJzOd5i8jisA
	qWLAp6GrSiwUSuYeJoi/FM8z0F/aZyy56sT1f+QM6y7YPZQvpnNWsAlyJ0Q0jgdRs/ylQiqRWu9
	zKw==
X-Google-Smtp-Source: AGHT+IESdoU5JvhAzuOhjydI2CjAPYyqye5HZ3O+0f0UA0gPpp7LXZq02t7B33tZ8tgvi8g0NZmeMCZy9I0=
X-Received: from pjbee15.prod.google.com ([2002:a17:90a:fc4f:b0:2fe:d556:ec6e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e548:b0:223:653e:eb09
 with SMTP id d9443c01a7336-225e0a369c4mr48322735ad.7.1742008004023; Fri, 14
 Mar 2025 20:06:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 20:06:28 -0700
In-Reply-To: <20250315030630.2371712-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315030630.2371712-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315030630.2371712-8-seanjc@google.com>
Subject: [PATCH 7/8] KVM: VMX: Use arch_xchg() when processing PIR to avoid instrumentation
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Use arch_xchg() when moving IRQs from the PIR to the vIRR, purely to avoid
instrumentation so that KVM is compatible with the needs of posted MSI.
This will allow extracting the core PIR logic to common code and sharing
it between KVM and posted MSI handling.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7e36faffc72..b65e0f7223fe 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -680,7 +680,7 @@ bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr)
 		if (!pir_vals[i])
 			continue;
 
-		pir_vals[i] = xchg(&pir[i], 0);
+		pir_vals[i] = arch_xchg(&pir[i], 0);
 	}
 
 	for (i = vec = 0; i <= 7; i++, vec += 32) {
-- 
2.49.0.rc1.451.g8f38331e32-goog


