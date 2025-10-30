Return-Path: <kvm+bounces-61526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 078C5C21E6E
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 446944F069F
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF1D283124;
	Thu, 30 Oct 2025 19:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZEpsSSHZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FD32F83B0
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 19:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761851743; cv=none; b=r19pPqjOECyY3U8TtfwTYVHfim90O/gCfhaNJGf1lIS6SFw48yC1SyowjDTQjOsvpiGeZbZZdfiJSrN6hi/28517bSZ8rqOhAZO0IRlBJtC8LhWJlcCPuC+vsM+mzeBkL8SerLfW/nBS7FAAtgJJ/EeSayarvGmAeIz9ZssoBcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761851743; c=relaxed/simple;
	bh=5kpuGHjjpW7eTD6TcJHKfUqA4500T6O1STI83TOW8fs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SyXikdUVI9GPfad+BBulHUwbfvmdzeSuyaXvs8DbajmAKphlRiVhOV4AE79Zo0o4WR/WrrJIs3d06U+ca09/JuwxtsUyt++sKnxT6IE1RGhz/9JmP4yHMpTOszBAQBDSd+LGXif2pXxa2IiSV8kryGO/udgH73qX8I+zwT9qDBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZEpsSSHZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6cff817142so909706a12.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 12:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761851741; x=1762456541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=W/2e8g1L0c2/fPIAdJgPfrLPj4zwW85TJ2q4DSKPNps=;
        b=ZEpsSSHZBtu0juLkwieUGwZtNeGeCyMjSEXFCX2/G85+IzUpJIMh9Wc0bLqkGLBmCO
         yDeyxLipzL0K6L2d8MtYUsmlFvJ2LfLIsmAjGqAipRUJ0s08WdPvmF8CB0KqGZzWg4eh
         09c5AgmLCopk1zd+1ydIBzmZJdFpQmDTkZfZZU+OORi01kWcazruCBIOJg7RvBnhmTAz
         josrWYJ21DWrftAtiO7pLHh2UCMoQlLBGThEBdhdgRJFqCaPxewb1jQ2krMAAJY46VfD
         I6512lw9p7rPhTsqVjmQHptJsg2bDwwLdS3DNvrVoa22wVVAOju4Fdsyk3WntAeRZdgM
         12hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761851741; x=1762456541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W/2e8g1L0c2/fPIAdJgPfrLPj4zwW85TJ2q4DSKPNps=;
        b=mSvi2NwKC+S28+AxAXP1Kf5XQErbX/UYIFKCNUQ6KISTasktjlTAaMoHV732ERY2gs
         JT4Jd3yaQQr8DQNsPBepCi7sPqtTLi6Ljq0oa1a6qRYwjSvrdh1ztEC4ijDI0Hq4PXeW
         RHoSQ9HxtkaIn316D300R0YQG2zJOdkFUmomqeEfx9rY724+Ky7OtK+W59A3ogeGIPuB
         IT+eiOSYWdfIYxt7vX8ri50rSU+xf+bfK7KSt/KUmYhPA0aiq0sOpKxBJvt/vXF3GymN
         UcOeD+UtqP0npO+/iSEwQZjlTHqn5qcqKtLVYzUpIqB6OiIZYBjP8MUwKrHWRwmP+dgv
         9ifQ==
X-Gm-Message-State: AOJu0YzsT61yS+L+JSFDHjqdQGR2Jp3tGzPtXUvj5kIWuY9h/AW5mlvx
	7pAuu8gkxwWNF2Arja/ZAO9o3jAx09dkifiBpP9+NdOTBma3aBLhf1Rr56s7dSA1DAbKbzT6kpN
	jF8qDpA==
X-Google-Smtp-Source: AGHT+IHBG+E9whSy2GErOVQq7nq3zTa9mi3obzAxIEd5dUmGB6oa0sd3yHkkpbWzPAltL195JDv7MbsuY58=
X-Received: from pllk11.prod.google.com ([2002:a17:902:760b:b0:290:b136:4f08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a67:b0:295:ed6:4641
 with SMTP id d9443c01a7336-2951a3bfafamr11598625ad.25.1761851740789; Thu, 30
 Oct 2025 12:15:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 12:15:28 -0700
In-Reply-To: <20251030191528.3380553-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030191528.3380553-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030191528.3380553-5-seanjc@google.com>
Subject: [PATCH v5 4/4] KVM: x86: Don't disable IRQs when unregistering
 user-return notifier
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Remove the code to disable IRQs when unregistering KVM's user-return
notifier now that KVM doesn't invoke kvm_on_user_return() when disabling
virtualization via IPI function call, i.e. now that there's no need to
guard against re-entrancy via IPI callback.

Note, disabling IRQs has largely been unnecessary since commit
a377ac1cd9d7b ("x86/entry: Move user return notifier out of loop") moved
fire_user_return_notifiers() into the section with IRQs disabled.  In doing
so, the commit somewhat inadvertently fixed the underlying issue that
was papered over by commit 1650b4ebc99d ("KVM: Disable irq while
unregistering user notifier").  I.e. in practice, the code and comment
has been stale since commit a377ac1cd9d7b.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
[sean: rewrite changelog after rebasing, drop lockdep assert]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c927326344b1..719a5fa45eb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -602,18 +602,10 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	struct kvm_user_return_msrs *msrs
 		= container_of(urn, struct kvm_user_return_msrs, urn);
 	struct kvm_user_return_msr_values *values;
-	unsigned long flags;
 
-	/*
-	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
-	 */
-	local_irq_save(flags);
-	if (msrs->registered) {
-		msrs->registered = false;
-		user_return_notifier_unregister(urn);
-	}
-	local_irq_restore(flags);
+	msrs->registered = false;
+	user_return_notifier_unregister(urn);
+
 	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
 		values = &msrs->values[slot];
 		if (values->host != values->curr) {
-- 
2.51.1.930.gacf6e81ea2-goog


