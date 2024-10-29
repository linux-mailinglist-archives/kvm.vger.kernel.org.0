Return-Path: <kvm+bounces-29971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D22A9B51F0
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 19:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 153CC1F21656
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 18:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDCE7205ADF;
	Tue, 29 Oct 2024 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SqTi43EB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E550205ACA
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 18:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730227166; cv=none; b=QeZKXF35Wp55/YUCl5UiDTpd4Lh+Y/6/MG3pt2P+DzHk/d+MZOmFF2iJGXKw7GxS1VkyehVnfVVXMk5AGxZH39jlyrUuyHBybhc9HDqhEcR4S8WvV928NoAJpE3KfOXMu/ymMn1Phs7iL5JbuP+W0569diVxL5sb/mlOmHCWtaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730227166; c=relaxed/simple;
	bh=QIBlHzKCzpo0A0kJ+Ne7rtACUMRu45enr6WWGFjIwAk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q7AV9rp/pYcbjUBNx9EMSDzhsf0fRpwU2SYtx+WqKcdI55a4wmAlq5bI7yIJsO9tz9J6hZ87P+VLBWzjWRg9ZrbIH/6JkhLpmrSXQIXNIw2KQqND6PoOYwYmb/78UAbtrEEaNY0Yi/RtIn/+DhssUho8Kc/WXUGJh1spLOE3A7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SqTi43EB; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7eb0a32fc5aso4821668a12.2
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 11:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730227163; x=1730831963; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFCC0Ppe61h9DsEPIrRB8kBdqdokYkAqWCjQxVIFEok=;
        b=SqTi43EBzhbBEaikAKhXAWIi92erJVOUziaMhvdfklP6BU8s6toluwp8qzFzoVUpXI
         BIvjyJGxAi/13Zcycgc3uc44yBtGZetzVn+TwNEhFTHwRxHfu5NSfH6S16IBcu2AlIZv
         O8JSFb4MpK7mzUCdauto9UDmnAWPUt4IJtC8/sdXvSG5HX5nzsoP4qmNDeKK1GjmeK7g
         AzkX6YxyE8tOZ+1SmI+B77Tz0I8CxJgFF0pw2TZayKzrWSoFy+UjwV/P40vP8aHbXCs7
         xFM2vKewXkns2FZG6IwHfPbmgz6W4mPtIC8QNsjr5n7ROFHpjcm2Q1wQBbaZcDGGa1gk
         9PMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730227163; x=1730831963;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFCC0Ppe61h9DsEPIrRB8kBdqdokYkAqWCjQxVIFEok=;
        b=aS/2e87Ia0oLal2or0vyCjw7PJOTg/qjYC46CZSiqMjFGVD5/nAyA9iYWLgbItmuSz
         M3H8n5ZlTS8y7WGRDGq1vraDeA54jQCPRtNRt14zhJb4bV7vJKLnM0PSQw5k0MEdGERM
         4iuGxDzRkZ8WJQcy49K17quP93P/B3flatkqLG/KrBvraXyEg7Tx83J9BfmK+zVhM2hj
         uHmwCQPNu3oO4Sg4HxmiAX1iQSezRuvrnHwVQQ60MX5ZBGww2tW4VbPlz5i4V3W3EAj0
         eDXcxB7UI74O1c6rW6rMgK6Hovp5fLrHQjPDwNPA/sr8ALv35YD7nXauKJ6UZiWqWrJY
         stlA==
X-Forwarded-Encrypted: i=1; AJvYcCWMlGVzZnBPXRHSTJtcvbkcTfBXLXUNCwrBmhK6Wpby7NG0fgHDyJ8RNtGbSvuQWQxF61s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9KWHf+hNrRFr9kvZHAD3Ia/ZxVzaSVpzxa6CG/icx/OYaPQGc
	4XK+ZEHPpVCo0dqHKiJ+i1CshL0SQO9HcT3nfvgdUBkTOusA3OCmXulXqe+5IilWRNINteQ5hDe
	QTPBfEIufX/xt2GOTVsASOw==
X-Google-Smtp-Source: AGHT+IHX5lwAS9LIgoFFUtnChrdz7z7B7bwmI4NPfhehjIuR/74lymdkTB0KkRffRLZp83XLD8FH6uu+JFCbE/BFSA==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a63:4f62:0:b0:6d4:4eea:bd22 with SMTP
 id 41be03b00d2f7-7edd7b857bfmr21710a12.4.1730227163130; Tue, 29 Oct 2024
 11:39:23 -0700 (PDT)
Date: Tue, 29 Oct 2024 18:39:01 +0000
In-Reply-To: <20241029183907.3536683-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241029183907.3536683-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241029183907.3536683-2-dionnaglaze@google.com>
Subject: [PATCH 1/4] kvm: svm: Fix gctx page leak on invalid inputs
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Ensure that snp gctx page allocation is adequately deallocated on
failure during snp_launch_start.

Fixes: 136d8bc931c84f ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command")

CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>

Change-Id: Ief6e728d0c859c24a286d8a7e49f9ad2eb47b889
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 714c517dd4b72..f6e96ec0a5caa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2212,10 +2212,6 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (sev->snp_context)
 		return -EINVAL;
 
-	sev->snp_context = snp_context_create(kvm, argp);
-	if (!sev->snp_context)
-		return -ENOTTY;
-
 	if (params.flags)
 		return -EINVAL;
 
@@ -2230,6 +2226,10 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
 		return -EINVAL;
 
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
-- 
2.47.0.163.g1226f6d8fa-goog


