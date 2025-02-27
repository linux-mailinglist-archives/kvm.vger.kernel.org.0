Return-Path: <kvm+bounces-39480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F34AA47199
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:49:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05A627AF368
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B8B149E00;
	Thu, 27 Feb 2025 01:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e3kKPokN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7918E3A1BA
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620947; cv=none; b=nEW2KB+FtnQTBuMGmH87JelhBCzaxQmmeU0FXWMkJ9x6m0KtKprqQzYhBH4KXP3UqnupQTPy8L+25VGJzNbcfTa8rbACvMTXsZ4KvS5MUVoZnZikU/q166q6pzDjv4Ftfo4kT1CjyEItfcGr1qD5mtUT8tNte4grBSnrSp556rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620947; c=relaxed/simple;
	bh=FxXG4vu/6eu+p30+t5KxZky4GYe1qhhb4jfmOZkmPys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sq1PaU3qbbB+r62EyNrOKssfeycLpsesdKdRGOeGpOHEGOZ5+VTvNMEuSxzrTwbr2z/rHHCorPZ9/2e6PRpYcQ16csGnk/j5YhKxTrySLzBVgmYRQmJAOeyk9Q9SYPlD5+SAox2I9zsdp1mj/5SVm++2qzXsP1J5h/BF4/Ku4jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e3kKPokN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc518f0564so1042736a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740620946; x=1741225746; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GpF7VaswH1+PtCwj7e39drWtyVDZ7wRi7CgpqaqVasQ=;
        b=e3kKPokNWZVqZFPOx/8sfSaS2bGT4C+fNRqmy5rJox57LknJVn3pnJ/kePcs0Pc9bh
         JwP6NswzFOzLV71S2T7b0SLyryZrL6ttwTORW8JBRblUjdb0XmUSME2rJPH1n8d6RDIy
         7t/3cwQnd0k7iPrqW2E4/lOOdnaPPkXNH+F248A80OKLmxndlaY+38DjISn7iZpeN0H7
         1N9sNv92fY2mrr4SVJlRqUTD8uBb2NRv8c3+YppbBbfiKr3wE8mqBDjeGzyYjDo6rKdP
         poYUMdZqrzt0jBgMsWm0aayqPAaA9QbqWcxisSgzGiektVIJqPNdXe/cqsBboYxfsWN7
         rzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740620946; x=1741225746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GpF7VaswH1+PtCwj7e39drWtyVDZ7wRi7CgpqaqVasQ=;
        b=VZZB7HAmPdb4rTf+XYHlXspC105omPIzMM96eXHNLVBInfkCw7p6QWBUAwiEZcLuNy
         2wNShbbJSmfw0w57OQlvLEkmRBtGvmyHEcN0d0mjZYH+W9xQmK9vdWbOVQ8avBWOlOUL
         PFTULx5nM8QLXCdUbL+8O/d2r3cLkB8HKCQSD3uIuseh6NbfyaS8dX/GJocd/yXgBcKQ
         NX8llYgW7Ij2LTrTZYYhG5aZdytukloKSGdN1FY34FkB1n5uolLr293B9b6DxhUBw1h2
         3olkEqVUGtKiJ+GYsc8vbkA8DaeFIGmaoY09LEonABGFwiRPanW0W77VDUF2v6XzXoJZ
         mscQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjaj0ZWnH7LFTIeyXSmniRMK13R7Tm+U82XPFBHQBgjNomnYTxZ4ot3P14Dk/jfuD8Pk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhwcSLo2ss2ey+b/yEcmCQcT7BdQBUo80GLStekpP3KA7GKUlg
	o/6ica9Zor3NtWtsiS1pmOMoci8b1YWZ3PwOZR2r+i/uutKn3wvIIn7rSJk2x895aIKoXUfh3W3
	h1g==
X-Google-Smtp-Source: AGHT+IE1Ud6/nNgaJU0N0FB6mqBtnxDmIgHW50+GZisORAEZMHbHbI9bClZkETrXKUspUI8U9MdvNfjAVMA=
X-Received: from pjz6.prod.google.com ([2002:a17:90b:56c6:b0:2fc:3022:36b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51:b0:2ee:ed1c:e451
 with SMTP id 98e67ed59e1d1-2fe68ae1b15mr15878436a91.15.1740620945822; Wed, 26
 Feb 2025 17:49:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:48:52 -0800
In-Reply-To: <20250227014858.3244505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227014858.3244505-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227014858.3244505-2-seanjc@google.com>
Subject: [PATCH 1/7] KVM: SVM: Remove wbinvd in sev_vm_destroy()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kevin Loughlin <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Zheyun Shen <szy0127@sjtu.edu.cn>

Before sev_vm_destroy() is called, kvm_arch_guest_memory_reclaimed()
has been called for SEV and SEV-ES and kvm_arch_gmem_invalidate()
has been called for SEV-SNP. These functions have already handled
flushing the memory. Therefore, this wbinvd_on_all_cpus() can
simply be dropped.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 74525651770a..d934d788ac39 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2879,12 +2879,6 @@ void sev_vm_destroy(struct kvm *kvm)
 		return;
 	}
 
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
 
 	/*
 	 * if userspace was terminated before unregistering the memory regions
-- 
2.48.1.711.g2feabab25a-goog


