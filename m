Return-Path: <kvm+bounces-68271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E12D293E0
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE45830F0813
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B2733120D;
	Thu, 15 Jan 2026 23:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TmIyEX/D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370FF330D23
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519343; cv=none; b=WYwM4lmPsvL74oDLRxv/K1IDLz3IxjB55TsuO6AmI9V3ux7YQZCn+652cnqPOlV9DXVw3SAMtqLslbutoWLYy+5JHW0MDUa/1uCpXj1fgBV1jG8p3NymE/xjnAaFquZhOB3htLW7/SLBhiF8ucS5OvfXwv6eCwQV/mUEphABrb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519343; c=relaxed/simple;
	bh=n9VuXnyas8RzAVq5FNPFG4pbXM3KIqWWE1kNwMcTCbA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S3hFBq7noZWlVLRSbzZDrJOEUBVqxnWPGlpowyyf4vkAYzXaPTFvQ1m5Cm1tkmGrfxwrkWuzi3ZHnDa//wZW/mSomOxGGjfUEEqZ91eqSqcbgh3SVk5OaqgkkYO29nY0gEw8BuDYD+FshzLEzVZcGAA06/jBoFX/5guNUo1yG7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TmIyEX/D; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a31087af17so15002475ad.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 15:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768519340; x=1769124140; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c/zBrN190qohWKUBRuSYnE9mFnTLenfIQq4Uzz5XlzA=;
        b=TmIyEX/DYynmIOIJ4etW66jP19V46ZK2mcXN1ZcRtJ+ganeVyCMBbNdWn0USfMTJB/
         VMGEx/rFp5LAWZxOdZvq4u3KJ79sGTJqrXhSAVTdlV4rxZY+ekd7izHDUkulnv3PD/g3
         /z2owod91ZUuwcOIAPVyopqmyz/zsPD/6ERIaaWaCNldtR3PhxrHguxN6S5evrumJ3rc
         SRcykru2Sc4waO82Nf64Gw3sOOuGw08aLjB1btnk3wPpuuMXmvJymDZLvLWJlvQ900sU
         Z7Lpq/eICv6YwaydWOBVjn2/v1HEGkKqn0W4K3gkYBWzCjdXeCojvynoK00ee4uSUneu
         SVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768519340; x=1769124140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c/zBrN190qohWKUBRuSYnE9mFnTLenfIQq4Uzz5XlzA=;
        b=bkUL6DRg9LUmctdN2xBBbFcBdI1okun6+LBfhtvUJKoNFvjvRNE/OVT3C8FG/sLIV1
         8pX/3Hx9SMBWdW0iRZtD5AGvODr2ZUvcW4fCnXWcB4T0nmXQA86DUdBeZTh0ieN3CU2Z
         Nm+wGHaH3khMboob0pIn9Vi3NW5Ynv+8Mn1+jWoc2fpiKVdn6T0emFTYuc/+CeftQYzO
         DGtcR/8CP09DtaVDKMBWm9iCrCaay/ERUxvpuOQJ8G8rzAuPhpvl8qfbaVX/0nCh4Vsi
         HmVYYa6m2hHlia8GZnY7nwX2LwleCMC6DLTdE3xsXlMc4726zPnL8VtAiaIuPPLziLGT
         X0gw==
X-Forwarded-Encrypted: i=1; AJvYcCXHvibSx4sJWDpXF34ryC6sSYwgW5ZNCKwQ9tlLogL4dc2OZUkxsa/bHEWWvAJBRjuu3Bk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuROYCcAud8Y+2HSNjAvMriDC3MoMvmSEF1KJI8qzRp1UROvVw
	RX7nIHpva6NyoSA8LRidmlQG7tr8Tf8FR01/39ppExufGbB5k6PV+f++IctphxKfQ+jPipdfilb
	SzNIV2Z8EKpGc5w==
X-Received: from plcl20.prod.google.com ([2002:a17:902:e2d4:b0:2a0:9fe7:eaa6])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f685:b0:2a1:3ee7:cc75 with SMTP id d9443c01a7336-2a717539460mr9150535ad.19.1768519339675;
 Thu, 15 Jan 2026 15:22:19 -0800 (PST)
Date: Thu, 15 Jan 2026 15:21:44 -0800
In-Reply-To: <20260115232154.3021475-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115232154.3021475-6-jmattson@google.com>
Subject: [PATCH v2 5/8] KVM: x86: nSVM: Save gPAT to vmcb12.g_pat on VMEXIT
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

According to the APM volume 3 pseudo-code for "VMRUN," when nested paging
is enabled in the vmcb, the guest PAT register (gPAT) is saved to the vmcb
on emulated VMEXIT.

Under KVM, the guest PAT register lives in the vmcb02 g_pat field. Save
this value to the vmcb12 g_pat field on emulated VMEXIT.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b0c0184e6e24..5fb31faf2b46 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1189,6 +1189,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
 	vmcb12->save.cpl    = vmcb02->save.cpl;
 
+	if (nested_npt_enabled(svm))
+		vmcb12->save.g_pat = svm->vmcb->save.g_pat;
+
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
 		vmcb12->save.s_cet	= vmcb02->save.s_cet;
 		vmcb12->save.isst_addr	= vmcb02->save.isst_addr;
-- 
2.52.0.457.g6b5491de43-goog


