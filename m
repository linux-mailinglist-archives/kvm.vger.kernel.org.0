Return-Path: <kvm+bounces-60236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 43507BE5AF0
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1A75E4FB08C
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFF52E9EC8;
	Thu, 16 Oct 2025 22:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i7S5XYUm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E592E719B
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 22:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760653712; cv=none; b=T+DBr2sT6hVLYxt9nwU3GDasbKV7KnMrH7osxVWTMOpBRq7qb5q4hIzrVzMVRgalmss38vSS4ULoI3y6ufKqCB0rdQtoCC2J2kO70s4XDFmhXzEKBjJGKGDZ1hXwXtFzMtcIny48YNlEG8hrhRJF0SrcKvD82ivyAntmHs26vsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760653712; c=relaxed/simple;
	bh=CiIKDZ3tD54lm+dMIg58E0d1ZctLY3/7BjNtbiYBFp8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZsusruvvQ7HD2F+2e+ZLm16v6kJtmqZ2/WoP+1mmWg/akuwbyoD3D2+Z5miO7W81JuBHWON06LFOPBu+XLBYRv1rcjWdbN+AXKV8vYWBh6HExq3zfoPSV5KyEWJNxbFg7B1gR0nkcfBEC5GK5eJsNkDTQn8MTgCuqruUVAvx9Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i7S5XYUm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bbbb41a84so1994882a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 15:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760653706; x=1761258506; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C7RYKj2bkYamtj/tpY96rNXOI7drHoDq8hs/glpL7oY=;
        b=i7S5XYUmdrDFaAgU9zolcYNEnJN9z9308I4daN0zxsZrTN2KjzZgKsH2l0ICRNqlkR
         6GYIEWDshgrSXo/6Q9SBgrxS3Enc0UfQh5Xoo8ATPO8oy8VOs7K57a1XE5LY49F4XJUT
         /USg2cNsjGtJq8rHGSaY3VT0YeOR+J3ivz2X4QWo5CQwb3YiUf2bTcJlIR4WEuwtJx49
         g6hfopcgjiRAkL8O9SQPLxpvdc5EKa+MfY71QcxU0R+df3LadkILP+5OGT01ROoWmcKe
         LFGmSz7A4+bdCG/OcRNIY4xQUpzCSbLlHJRL5dHXZGaBqW/0go2A7VfYTeHYlAX/BCyo
         UyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760653706; x=1761258506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7RYKj2bkYamtj/tpY96rNXOI7drHoDq8hs/glpL7oY=;
        b=R6fzLfQ04H7cmu43Tjj9gnax83s0IRMrEjG81Dz5CG/Ym1oTAMXGJyqIIK0CXl00gE
         iZjE7pweLjws1On93iuSlqCyZuASREVyPOpwt5AlVe5NZ11SdazK5kMbYQ2M5e3HztGp
         a62SqQdEr1AgVoV+87Ad4enC8CxnwzVibQJ1jNXfjLXkeD6s7wHI1sGA3dDN+GmHYdON
         BZOlEaFBo1veWrAJnR6EJJjxe1g7MTBt4+rAzvJhqtYeRVxSqevlujGDO+eoWwXyZtBr
         omm0x5DXEnfE5qVYBEnwSxGuD5erZZm3c5vPP+gbybEramiiaxzb9Qrljnlm5IbE0qpm
         tjdg==
X-Gm-Message-State: AOJu0YzhNKEGeGTURwGfW9KZjQRaDTQBdLKgZWzneSOiC+5boLVvffWZ
	9cH7poFzQvxe6ypfcN51e3eq9K616q6EPz3t04xWnACd574eUPmDxuog2wutDJr7i6UtlgoNqvP
	RKAX00Q==
X-Google-Smtp-Source: AGHT+IHr7rgfcDHrp89GOkrAJeRqbJYehFtjyPEFfaSBcGteYS74wj9nr9cTOyxVow6+nxcyA3NcfEsIUQE=
X-Received: from pjbpa17.prod.google.com ([2002:a17:90b:2651:b0:33b:51fe:1a8c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d12:b0:33b:cfaa:d01a
 with SMTP id 98e67ed59e1d1-33bcfaad01dmr1276533a91.25.1760653706135; Thu, 16
 Oct 2025 15:28:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 15:28:15 -0700
In-Reply-To: <20251016222816.141523-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016222816.141523-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016222816.141523-4-seanjc@google.com>
Subject: [PATCH v4 3/4] KVM: x86: Don't disable IRQs when unregistering
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
index 386dc2401f58..394a30bb33da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -581,18 +581,10 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
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
2.51.0.858.gf9c4a03a3a-goog


