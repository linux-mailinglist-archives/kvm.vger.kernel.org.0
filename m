Return-Path: <kvm+bounces-58078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84CB4B8776B
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 325A32A4D18
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2252124A076;
	Fri, 19 Sep 2025 00:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ex700Jeo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C202B242D90
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758241306; cv=none; b=bVuE+2QNV8OUYHjgvAU9xyAXJSozegJDaDvsOwOcYWHoej5fvL1EMNF4+7mizI8UVRoyRzRjaZ7g5lIkNEqob2Ttgqhe8wftC9y51wcGeqwS1gOMk5WBPsYBo43Zy551gDG/+Yfz5l/N6SshR0q1vvHMgC+wcf6vfVuFhMTff5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758241306; c=relaxed/simple;
	bh=dnDGQszvB2585L+X6/25BlGF32EHEnqhtas6VbHriWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZLJTq3ZC7nSUrmIxpW/ovOsf+Uk1cEfMaDcunhUf0J7yz40EvX215WL1T7e1GO5J1IlbKYpxMUg1YqFPTGm1fp7xQDlXqjUUlRPPqeT9uwEARJNvtMvfkREM+Hke6cMkozOZw7gVVmJB+KG6bUxSvrtMOTr3Vaft6e63aHU67E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ex700Jeo; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7779219ccc2so1772081b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241304; x=1758846104; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OWpptP480nPR+gQf5fjoSJ3LeFajhGi/JQe+6yLb9Vs=;
        b=Ex700JeoqVJ8dTck8915Qznhs+85yxPemTToR/dgIM8uFHqw43ZLpYWhvYW6U9KTW+
         EC+t6Uys3rOHxDH4Kr+fXwzheVcy0Hm4DoGLmd7/nvY7WkohSqKae5MIDUKtdGbD4Fbt
         AmT5cEthdkQNekV7jbJ2ZvtSCTgXmOYyZaFxLbiKRztPXfMbe1S4GEbR9n+OtX5VtWVF
         q9k7YKX5xn1/6D63bOc6BI16tz+7BdYG4dpgRoeeBJOHRG+go4BTO85D7Nx+7IryU+bO
         BgijVh5JTX6YWGob1PKmlso7yRtOT3ELzXPQyJc+dw2WEOtX+5PTpQBj9AU6jmk3a79P
         qRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241304; x=1758846104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OWpptP480nPR+gQf5fjoSJ3LeFajhGi/JQe+6yLb9Vs=;
        b=ea0sb+Q2PilaErUDGom7QmUe3NJDCgzR/s5V2+oLISeP5CA+JlsRGS0Dw2eyijsw6D
         BaMf7X2IaQ3PROyUe+ratuUdg2a/2K7jsvVL38iNvgnTKELhD2LJVoJX0TYK+ZQKNfIh
         Vs23Dpvt7VgK22QzoFzB4i99Gwv6p9eC4ZOQC+kaRZHChLUe8erSUAkOTYtadG5LkjQB
         Ar9oTC9fiMPYv7wIC6+Y76Wi4BfLeKTMj6xaxgxayP0KnGPWn7ENY+usHcxPV2Z6XlUU
         jory2PBZs3iye3AngAMxtKsWEN9G7yflunEntXnqYUkE8Wuz4C1n4S6Em/Wmmb7O8zj6
         Or6g==
X-Gm-Message-State: AOJu0YynIDoDeHJumh/kQBfII1PYGcUX3Caulve6WF+vnMAqMWS/fsr1
	dRazPHuzUU55ymg6EBynCv+zM+7NqUuEk6jWWYJqvzmFBXMFFOJGifdBj2ISuJLm8E53lGTRx6q
	z3KnnAA==
X-Google-Smtp-Source: AGHT+IEjfq+HAzhhEgvQSAEtSpLgBp6y50u1CTtZoIpvPweMWB9fQmawm0uEG/qVN4GsxyVWEvYQOZj7WVA=
X-Received: from pgos10.prod.google.com ([2002:a63:af4a:0:b0:b4c:1faf:432c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1585:b0:262:4ce4:f694
 with SMTP id adf61e73a8af0-2926f4b8fb6mr2066642637.35.1758241304056; Thu, 18
 Sep 2025 17:21:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:21:33 -0700
In-Reply-To: <20250919002136.1349663-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919002136.1349663-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919002136.1349663-4-seanjc@google.com>
Subject: [PATCH v3 3/6] KVM: SVM: Always print "AVIC enabled" separately, even
 when force enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Print the customary "AVIC enabled" informational message even when AVIC is
force enabled on a system that doesn't advertise supported for AVIC in
CPUID, as not printing the standard message can confuse users and tools.

Opportunistically clean up the scary message when AVIC is force enabled,
but keep it as separate message so that it is printed at level "warn",
versus the standard message only being printed for level "info".

Suggested-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 683411442476..bafef2f75af2 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1167,16 +1167,15 @@ bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
 		return false;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_AVIC)) {
-		pr_info("AVIC enabled\n");
-	} else if (force_avic) {
-		/*
-		 * Some older systems does not advertise AVIC support.
-		 * See Revision Guide for specific AMD processor for more detail.
-		 */
-		pr_warn("AVIC is not supported in CPUID but force enabled");
-		pr_warn("Your system might crash and burn");
-	}
+	/*
+	 * Print a scary message if AVIC is force enabled to make it abundantly
+	 * clear that ignoring CPUID could have repercussions.  See Revision
+	 * Guide for specific AMD processor for more details.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_AVIC))
+		pr_warn("AVIC unsupported in CPUID but force enabled, your system might crash and burn\n");
+
+	pr_info("AVIC enabled\n");
 
 	/* AVIC is a prerequisite for x2AVIC. */
 	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
-- 
2.51.0.470.ga7dc726c21-goog


