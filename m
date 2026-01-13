Return-Path: <kvm+bounces-67874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2311FD1602C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EA7A93053794
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EBD2820C6;
	Tue, 13 Jan 2026 00:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0B9k/6pi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B711722B8CB
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264245; cv=none; b=KyHjsKZ0qtblCcsi50DrwqkXTlp1Y0I2qevAr6e6KEINGerYkUgzTM50NGxbwiRgva7IarHWFRGHxuKQOkXey/BDnP5QC4GrgHQGkSwAj/WqhCvbiRahmuO7K2C+1uhEqLGZ/gKRKtqpMw/XPGOSDCjb6VA5ergG6aNz1MCyAOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264245; c=relaxed/simple;
	bh=VkCjLytO1ux9i8uRqJqOp4y4po1Gg2Hc+qogiSAqt9g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IUwL8ZFepb+eHEqB9KYS73HH3mRyneQgLL505I+TkNL1mdRmzEmvjLldGz+A+lL6AOBO05UyF1zKS9lLwGs9uvN1q9F7GMfv2Qe4tChr67mXGKXjUwJIRn+t411mZ/5Pvobgv1p4EhCDkRrOB74UK7ANMkTGxDqVh6KPvul1l7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0B9k/6pi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ed2so6265058a91.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264242; x=1768869042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugtMeXQoG/v0gmSJ0kvlm0/hksPZ0j77UnWX+eyrz3Y=;
        b=0B9k/6piZusNp3ndTRRDmKtE+u2KbU5pt6QypwX4OMnbw9tPVUx+DC+K8mHhzEB8eV
         a07re7QBe2l41DgIVGueTX1/WXBUxm+WQpNqxLv1lzU9A9ofUNCNB7APJnHG7IUc+kLu
         HfWzLPtQC1fLYs4dzKKVNNjxws9WzE3le31Ujj8aPzRcCEiLxpRhDx+EmN0V0PIUbfCz
         nDPLAAJ0YBHlpL2b++IALna8c1LeBTXqdOML+rOUu0CqdHbV591ZNR7koNOCvHGHz4sf
         L4sVh4rb98bCahIhoVGaBADZROLrGHci2481TqFfm6/SRsha1jxog8XSSitcdsf1TD89
         6Jgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264242; x=1768869042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugtMeXQoG/v0gmSJ0kvlm0/hksPZ0j77UnWX+eyrz3Y=;
        b=ml8uKsrCyMfLilDGezOG1gx20mqWOdMQXTLEkHp1HevakQl1QiMawviO3S4F/OTLNR
         aGBPQTxcZHx+xm6luuiaDcaYjpEniqfU0+HjsZMLHEu+mvexwYUW9KNhmI94czBI8Lhf
         J7uhsGy2+cFO7jZ6noD+MtfYFLt4j9HuH668LMIrPHj+Jj0gpoLsTdChyPezy9uTQ+4f
         4IMjvltR3SVWMMES45frQy4xuyYx0vm5MDZlKImfpkjc1Q+lqTjtClkYWGD2zkJmZuPo
         LpnBMkTnKz7PwrRaxOjJKmZa7bcNe5Z/No1BlWBNOzvhLcOtVBVDcUtSYteeLoQVelqL
         Nncg==
X-Forwarded-Encrypted: i=1; AJvYcCXK2yTBf1CeEHeyVRs5Jpfqzp6hRaZayhHP+nO2yhjsYWgFF8W+062fI5vvZaugvqTPJRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLMDHUzuYKh7CaMqbM6NXJbABZUcq7wHom9WPSvJ4hIqMiKzjJ
	XFtR8wpx2rli1kfHWX/t5mdaiZ1FhtMQzSUxddXPGwUmuSpQI/p7Ik2iWD3f1PM4a52B6wcLsrA
	lSODtB3D7vtlGBA==
X-Google-Smtp-Source: AGHT+IEccbNQ4GcGL8d7NNWxCrtOXIcCLpkLBB9GNgvN+JQUSY8qIxF0CgKlAWtcyBdkdr3anPQUtQ+G072f4Q==
X-Received: from pjbfa5.prod.google.com ([2002:a17:90a:f0c5:b0:34c:bdf1:2a21])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2251:b0:33e:30e8:81cb with SMTP id 98e67ed59e1d1-34f68b65ff0mr15680469a91.13.1768264242031;
 Mon, 12 Jan 2026 16:30:42 -0800 (PST)
Date: Mon, 12 Jan 2026 16:29:59 -0800
In-Reply-To: <20260113003016.3511895-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003016.3511895-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003016.3511895-5-jmattson@google.com>
Subject: [PATCH 04/10] KVM: x86: nSVM: Restore L1's PAT on emulated #VMEXIT
 from L2 to L1
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@kernel.org>, Cathy Avery <cavery@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM doesn't implement a separate G_PAT register to hold the guest's
PAT in guest mode with nested NPT enabled. Consequently, L1's IA32_PAT
MSR must be restored on emulated #VMEXIT from L2 to L1.

Note: if L2 uses shadow paging, L1 and L2 share the same IA32_PAT MSR.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c751be470364..9aec836ac04c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1292,6 +1292,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_rsp_write(vcpu, vmcb01->save.rsp);
 	kvm_rip_write(vcpu, vmcb01->save.rip);
 
+	/*
+	 * KVM doesn't implement a separate guest PAT
+	 * register. Instead, the guest PAT lives in vcpu->arch.pat
+	 * while in guest mode with nested NPT enabled. Hence, the
+	 * IA32_PAT MSR has to be restored from the vmcb01 g_pat at
+	 * #VMEXIT.
+	 */
+	if (nested_npt_enabled(svm))
+		vcpu->arch.pat = vmcb01->save.g_pat;
+
 	svm->vcpu.arch.dr7 = DR7_FIXED_1;
 	kvm_update_dr7(&svm->vcpu);
 
-- 
2.52.0.457.g6b5491de43-goog


