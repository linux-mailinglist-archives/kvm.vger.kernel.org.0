Return-Path: <kvm+bounces-48908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D30AD465C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 854843A821F
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FC026E6E3;
	Tue, 10 Jun 2025 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C4Fqr/kR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B97260564
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596303; cv=none; b=uasWn1bnibmH8mmbmz3qLWaKLtDWPU8VjRviFUUjP3ZWj6rQMAMC052KobOAS8lU7qTOOHLR3gtHRWmFOs2An8Mwfe9iZ8+yGA/YVXU59KY0DssT9prOEZgiEPY66vhdJGoBCjN+HqFvRWWtlxb2Tb4gEZCLxhdIpSUTUGL3KPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596303; c=relaxed/simple;
	bh=IB7MuUnuIgiPbLKi3Tq9cVagh02TXhUkYhDO6XH5nEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HKC5uyp4FopJJ49g16f6BjqJPYs5x5SkbJaMPB4h2QBsN6T0sVokM+Vc7mlgXC7pNe1WfmCQsyhgMPCc4kka2uZ8Tjha7iI8H23HwgKdpf+tgJb6oaGpln/ELwPgROKGQCXi9LJsZexrA530MNKWuQtXPjX730PS7vGs2Q+wRA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C4Fqr/kR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311cc665661so5147981a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596301; x=1750201101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ruy+gu6RGSeT+f9/V4uicP7PXhGDQAcKPy/FYrm3WvE=;
        b=C4Fqr/kRJdqxMEecE2E0xEkGRqIwa7/i3f1wI9Ls/PqS5TLpkg6pYNYLBsh+YJETNz
         PgLKI6fb2rFk30KE5PorEv7000XAzg2ISa1TUYXopsZ7/dTSSpF8ZfJtxLsLWjjVOG9E
         qYiOwb2mIkRJtC3ay23JG9VQtnH7t3s1witPr8h+0Qml06vAGhCsD/WRz3GsEmxn/Vo9
         a79taufW/k6H7XVSzFg3nkGzIec75SEnBaqxO2+9Ui5N70+lZAWfEsJgCwvqbDhQf3Ja
         nkiulmK49vd9Gp+DoXvvM4GzewTkPTdnWwnsvoyIW5KHofdEw0XOhUxx1TLqDXkVmjgr
         Q3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596301; x=1750201101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ruy+gu6RGSeT+f9/V4uicP7PXhGDQAcKPy/FYrm3WvE=;
        b=RhImVKk9X3XSuU+Nv8VYKtIa+pQZfZ7qe1oyeivmQsnuHKA6VZCaPfSrqNV1B4Nv7f
         mDN7VAEs9w1ndmoZAUkORj++Urpxh2oW+xpV0TA2Ie/Be2LkxX2cQbBPguGzQGFwr/O2
         Ww55nsT0PEruwFltLzi9fQGrtxtc0g72OEvU0WvkIRzIwsqCkhOLWuc+9IRpamXP1hPv
         CH20W3vujZGSfS7lo7dut8DMee0SwIurPMqihdRo+Q2NvUvUPM7OW7G4ShcMdVUE4bQH
         8QsrXpXYbtevkyLysQPmpiNb2b2T4eLAGmG0YER5d+7T5oZs3wQ7c2a5xsJrXzhx2P6f
         czFw==
X-Gm-Message-State: AOJu0Yw/n4v2pTwv7K4YyCuKJ6+5EMuvtJA2mQQoaWIapQWRyj+lyVSk
	oiILiqVx66W8TjuzIVstiZjN3SEuLQIQ3fKgemcCIrDLhUk2Ol7MfUmi/6gw83VZ6JoObj/6dfl
	pNy9DEA==
X-Google-Smtp-Source: AGHT+IFbea8RU8Wa7FlWpADnbF097Ndh4OlVRSMm3Srv7lWxi5ffWqJcVZoxQ6p+4c7SYNx97eTifIhcUmA=
X-Received: from pjz3.prod.google.com ([2002:a17:90b:56c3:b0:312:e914:4548])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:50:b0:311:c1ec:7d03
 with SMTP id 98e67ed59e1d1-313b2011f52mr491202a91.32.1749596301442; Tue, 10
 Jun 2025 15:58:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:29 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-25-seanjc@google.com>
Subject: [PATCH v2 24/32] KVM: SVM: Drop explicit check on MSRPM offset when
 emulating SEV-ES accesses
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Now that msr_write_intercepted() defaults to true, i.e. accurately reflects
hardware behavior for out-of-range MSRs, and doesn't WARN (or BUG) on an
out-of-range MSR, drop sev_es_prevent_msr_access()'s svm_msrpm_offset()
check that guarded against calling msr_write_intercepted() with a "bad"
index.

Opportunistically clean up the helper's formatting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 59088f68c557..9e4d08dba5f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2767,12 +2767,11 @@ static int svm_get_feature_msr(u32 msr, u64 *data)
 	return 0;
 }
 
-static bool
-sev_es_prevent_msr_access(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+static bool sev_es_prevent_msr_access(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr_info)
 {
 	return sev_es_guest(vcpu->kvm) &&
 	       vcpu->arch.guest_state_protected &&
-	       svm_msrpm_offset(msr_info->index) != MSR_INVALID &&
 	       !msr_write_intercepted(vcpu, msr_info->index);
 }
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


