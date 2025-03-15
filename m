Return-Path: <kvm+bounces-41140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 761D4A62518
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 04:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B062B3BF768
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB59818FDB2;
	Sat, 15 Mar 2025 03:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UAMT/Ldj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B086318A6DF
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 03:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742007996; cv=none; b=cCWoGs2LOXPNjbkEB7/R5PZlaAoIO7cp8uQKnYwxnsoAoFTJbfS2T4wvAJOOxf+zirJhpbANgwW09XESzvnN8tZ9WOeqt8W3dwgBPBIjmYKW0x6l++zOwTrhk1GFZ0eardDNzncWN0cPfKHZzvGHdwhhtikzh463cxhSeLAvYws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742007996; c=relaxed/simple;
	bh=ORxMRxanum7dJ4QhbbOoW6MS6dV40SegF61qcn5cQK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YWyUurtlCfZT2BoWRVolhoodbNSibC5lEIn366zqFPDwYzMntxo4aM9ldV8pLOk1B3MEyRtMZ/7Zpf4/ixpJCR4LOZrpT28+7eAOonxGVkwSFoDt/AzvEHuFNZQbnqiVlWlPLdxinehNxyg85ewav1fhjVq1WXaTfxgi8xZXdIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UAMT/Ldj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3011c150130so499063a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 20:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742007994; x=1742612794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A+D7/CZc6x+lcAi6xbF5IFcWIU9h8go1MiK4EHRJXP4=;
        b=UAMT/LdjeX0edyYremYgTvkrkszCPGCpjVyAYX62V4ktJUi/Z/M1s/Qewwj03Gvphb
         2H4ZickLHWjxa5xLDisv8t4jq7XBY5DL0zFG28iyXQduvGGaiYRSUJz8PCPav5XOQZqW
         YEBYZMlqBkAzLI4SQPS4b7QYouAKWh+8laX7hFkwSCjyp+f2XgR8dTuHLeGztbx9r7zo
         OMfHDtzBE+fj4iYBAdd/PvUeILJy+kD/YFbt4YNzL5LuHQMJjA+TcnOzFIGuX5iL8Un5
         6HbE1FnABlkL9nZ8+uURlYasmbds3ssIkqV+0UF+xpdNZFZev7Bi17V9BkDo+kK54cw9
         e1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742007994; x=1742612794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A+D7/CZc6x+lcAi6xbF5IFcWIU9h8go1MiK4EHRJXP4=;
        b=A3MHD8N5IU5vof16oUIR+wyYAUCknLtRXiEJRGQrw6htp24lAGjhXNMZrXbBF8kn8E
         HvAI+Q3ubZMD3SxVMaCs4VYUrwieI6UxJ+rkiMGWxXI8KvJaLKC6DKC3Pq+EZIEzR/0C
         G52xMzRgeLytkGrSFC+tX7Z6TBlpwyNrJ4pjg/wZ849ROz782U1Pn70bYuUYsgw445PV
         4UBlU7+Dg0z4OEfhWmhrNH59X2SQBxY3ju3MIJSwXFkmy3j/OZTsCpKvEEVXL0/bOW9O
         aZGE2C3S6MnuNpaGqtrB4QaoNeJk2xKvyLbIuiqXaU33q0uQfiE2u0sEb3Lg/v/8vhm9
         R28g==
X-Forwarded-Encrypted: i=1; AJvYcCXYSXmO8h4QnCjen0AC0ZbTWv5YAbe7QLH2Aps2Sv67y+buoCEQZYJ6NiDrai+9lNdm/lg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx1ajhWlzbbI5GGn/m/zFFVfFB/xztXXUJXlUznkIY9zQrXr0E
	IdcstFDx0LcL/UnqAM8kD53UamcbBaRo/D3ez4gMsxEC6qL10C0u2hfbGGNd5zIEuHZORgjks0V
	iHA==
X-Google-Smtp-Source: AGHT+IH3X+L+I/21qttxgDTkKxHuhAtYSP/nASSYaa/gcSlKKoQ0V6Lk918oh7tBqn4FZDeDooNPZD4EXAU=
X-Received: from pjl6.prod.google.com ([2002:a17:90b:2f86:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fc4c:b0:2f4:4500:bb4d
 with SMTP id 98e67ed59e1d1-30151cc8c11mr5807708a91.20.1742007993991; Fri, 14
 Mar 2025 20:06:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 20:06:22 -0700
In-Reply-To: <20250315030630.2371712-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315030630.2371712-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315030630.2371712-2-seanjc@google.com>
Subject: [PATCH 1/8] x86/irq: Ensure initial PIR loads are performed exactly once
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Ensure the PIR is read exactly once at the start of handle_pending_pir(),
to guarantee that checking for an outstanding posted interrupt in a given
chuck doesn't reload the chunk from the "real" PIR.  Functionally, a reload
is benign, but it would defeat the purpose of pre-loading into a copy.

Fixes: 1b03d82ba15e ("x86/irq: Install posted MSI notification handler")
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 385e3a5fc304..9e5263887ff6 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -412,7 +412,7 @@ static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
 	bool handled = false;
 
 	for (i = 0; i < 4; i++)
-		pir_copy[i] = pir[i];
+		pir_copy[i] = READ_ONCE(pir[i]);
 
 	for (i = 0; i < 4; i++) {
 		if (!pir_copy[i])
-- 
2.49.0.rc1.451.g8f38331e32-goog


