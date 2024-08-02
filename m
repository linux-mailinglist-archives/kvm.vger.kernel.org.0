Return-Path: <kvm+bounces-23121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0803946417
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 21:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EBE21F22C23
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973FC130E40;
	Fri,  2 Aug 2024 19:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="czdn7o28"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723257A13A
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 19:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628289; cv=none; b=k+h9AtwVCmnGMW5JG8ZeluwstJZ/Oa3S/8eRAnVel6DpL51Tt4eDn5StRDEa/CHtCyslJ5An5lC5rSzZp1jNnC6IEa36S6onpTsDUcAgwUj5aNtq7NBAKilEsFGAK06Jv2FYqaboH2T4A6vPZc8qzrnGqWtbHgIsh0m9XYN3p20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628289; c=relaxed/simple;
	bh=kH7IYR7zBJzDgCb4mp8jhpOwUdQ4CJQGnGMEivOUcfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dy7bKb69ofKLU0yem/6i+5T6uxGA7zX7OoHi3qkPviHhaegoZwgIHzcYgrCOCx0ETL30cJGSSZltQc/NeaS8d/NvScyQFKwh5Jh7t0mtxrLlGUF8TPp0ZzPoWS4sRjOb/ye+aL93lYXppY4d6g/P8AYE62KytLjOBUJlOmpf7KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=czdn7o28; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a242496897so6685102a12.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 12:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628288; x=1723233088; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0yZA/m2BmuooHYMrQtHZI/2LD/LZNOm46ViK83mQlGA=;
        b=czdn7o28UWBh1H7Rc6p1josjWAiFIKyOWzYuJM2avuxuo+DpalcHk4+DxQmYq9QssD
         7RLFlgTi8v4amYOGS2pXruOfKlcHSJC7NiBzRuT3cOm+s2bXcv94999MsROqaXp1/7mp
         6JGmDBuaQ15Ejef9ShW3Ek0b3wt+VyC8sjNCAIfwCjC4lGZ8/2guXXiQ3D7dTr2fYfY4
         86SuLk8cpB7tKZxL/uwR09xcjPrI3u5t8kPpIaurYAp4kzyYxIVna4yu/Jxn3T8Du4pn
         pISa0m6s3nvpTORm0XhuTcX7mrA3pLhOfUf+z9Gq5b4n1SNR6Xil4KtFhDScqXMtzG2l
         6NHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628288; x=1723233088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0yZA/m2BmuooHYMrQtHZI/2LD/LZNOm46ViK83mQlGA=;
        b=FG1+eL6a3UgQzaUMLdRWXssnmTsZ7f+kYd0wXltV4K3yvsqUenk72jip2YX2Xf9iyf
         K233uxdOrLF9/p1YMuV/5Ymi4GuKcLySV/zvRa5rdpsZ/GuZx/vZ8f1s6PSkhwwrm/aT
         6ImT0DQzm18QtsKWCSN3GOzeYqNrndG+6Yovn84xdT5DM48h8khquk9UrsEbnioJ0v0t
         C/FRnb9kagvQGJ8Nao+n+bRRURtde5fDm7tgOdnLJcRYsiTx8b4R21kBltcxIj6TcXAM
         YBtWGnFSCFUWvizmVbqIyHA9dXyZHG62aAg6AC/HNijWLqW3/RAyWpa9c5K7IOGlnXzw
         ZRZg==
X-Gm-Message-State: AOJu0YxI9upzrFC9dMVVerzttBtcRB2Atz3yIZEF6OfEns96sO2QZIm9
	KQlOX7trWeIq5J4VSEhZl49kzCa5iXJ4Bfxf90z2ejnCE/aexi29Vgt3hT8sBTQt5E6wMtIZcGn
	tsA==
X-Google-Smtp-Source: AGHT+IENPeRQ23Bb2K/Kq1zD91vd3dLeBsSlYk8jiLIo5PGRaYnIsL438VpxjIKwYaVrRR+p4LzacGFzdNU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6307:0:b0:75c:49a4:2a2c with SMTP id
 41be03b00d2f7-7b749d180e2mr7687a12.7.1722628287593; Fri, 02 Aug 2024 12:51:27
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 12:51:18 -0700
In-Reply-To: <20240802195120.325560-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802195120.325560-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: x86: Exit to userspace if fastpath triggers one on
 instruction skip
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Exit to userspace if a fastpath handler triggers such an exit, which can
happen when skipping the instruction, e.g. due to userspace
single-stepping the guest via KVM_GUESTDBG_SINGLESTEP or because of an
emulation failure.

Fixes: 404d5d7bff0d ("KVM: X86: Introduce more exit_fastpath_completion enum values")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..736dda300849 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -211,6 +211,7 @@ enum exit_fastpath_completion {
 	EXIT_FASTPATH_NONE,
 	EXIT_FASTPATH_REENTER_GUEST,
 	EXIT_FASTPATH_EXIT_HANDLED,
+	EXIT_FASTPATH_EXIT_USERSPACE,
 };
 typedef enum exit_fastpath_completion fastpath_t;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 332584476129..3c54a241696f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2184,8 +2184,10 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 	}
 
 	if (handled) {
-		kvm_skip_emulated_instruction(vcpu);
-		ret = EXIT_FASTPATH_REENTER_GUEST;
+		if (!kvm_skip_emulated_instruction(vcpu))
+			ret = EXIT_FASTPATH_EXIT_USERSPACE;
+		else
+			ret = EXIT_FASTPATH_REENTER_GUEST;
 		trace_kvm_msr_write(msr, data);
 	} else {
 		ret = EXIT_FASTPATH_NONE;
@@ -11206,6 +11208,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.apic_attention)
 		kvm_lapic_sync_from_vapic(vcpu);
 
+	if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
+		return 0;
+
 	r = kvm_x86_call(handle_exit)(vcpu, exit_fastpath);
 	return r;
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog


