Return-Path: <kvm+bounces-25984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E3B96E8AC
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBF351C23729
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B229139CE2;
	Fri,  6 Sep 2024 04:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FUPefJP/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5403B84A51
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 04:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597264; cv=none; b=P3S/zVQY5W4p4cY4JyHZdrOitzcwr8hTGULhImE6q3RonlhMnfBjQWM0uQ59jubFdGs8OmEJBm1Ej77DgQAOmagXw1Xqkyda6rMxqJgEmwoCMFvWm4pp4FZaEaRxpSLLvXiWfm+tSpXuK2KhJznJtW1lLQ76AO9/RNv6zZ5Ryt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597264; c=relaxed/simple;
	bh=vUO7vGmYGYbyr6uF29dDmJSIjGj15xrKsxlgZD+fbfg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i3j2W891NqIjPCEVXMb0s4G6KUlR9ym/aLmSkxFIMG+zZK7nyKZOxLVizvAxY/TLuKKpk0tGgOWgGUlEpLYVBWoeTJtdt0lUinDB7SNu21oEjSPX2VsbTcYQOgrHDGjll0AcXoXUcQIH7iSqnTyEHPJgbVPf1/gau4VnKy+eids=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FUPefJP/; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2053f49d0c9so32426985ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 21:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725597263; x=1726202063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vgikLRROm580u43MLI6MsYbRQEvUit5RnsfmT63jtwE=;
        b=FUPefJP/mkwt7ASgqON3SD6fgvjFdLDCw9mLfc8r2DxQjNQT3Y0uu/K+G+KTwUsijd
         qCues+6mUfE5EtMqwGhcGBnj4oMKTYKTrgQTJiK3YcFC3QX/sW76yM0FsjHZcn73es1I
         1osHDH++r5teDW1cB4uOXvpZDZ02NdblZMixcbyPg6muPZenSDfjF9WpyiaOi8D3iJsw
         Gp7p7+0l2fPQ26TTTSQdsbwVGeoi2tw4+KeahFw2/YophgQgjIQzAL6G1OcKLt6zdBAQ
         vWMJRLaVAbDh7DrxWX4o4Hvtd+NXuAnUP19ZKNLgLPDFHS/kIdLvjTGNijavviUkdQK+
         vbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725597263; x=1726202063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vgikLRROm580u43MLI6MsYbRQEvUit5RnsfmT63jtwE=;
        b=gzm8QtAMuUwsPzdNrIX1U0X+w9lel/txl4yO4MFuloo8wZlmJ84FAgel8YxiMjXVZX
         adi8+RmAqlCh1aluMVb2rkEzxFg81U+RxTbLUg9gb8GivtUELNmPmD+AcHKEEUjcZi9P
         EmLc9SGDiAd1DjtTUFaMuOCTxiVHI9Suc9A89ZHlEuiiXQ59294wuqnraB1R7guQfuVu
         tIDKpcUKnQiKyODf3UTd3I70NSIO/flmjBYVR33lC5ldEY6bxTUomXUaBwL6Taz35gyx
         Lu0MYxdxAyyxRxNRHK5k/7l4bk5rzL14ZOw/UOgpXbMj9whwPnmgdJxjorDYI+D0vrlB
         Wfow==
X-Gm-Message-State: AOJu0YzNq4W0g9UEuXFIoFHTPlXbKePpDGx5n4juqWkzlHXkl1B0s4Hw
	ZEWBSfk5fmgbiI06ufVsnqrjkDVz+lJ2PAAuUaW19qNNnyHSM9msY/BrxXXP9D1Uo4iGRoatPDv
	yaw==
X-Google-Smtp-Source: AGHT+IEyEFfjoRDNJyVIEZ+IVKjmpudL0fgn44x8C5JkT3Kr/DFcFMcxqut3wtjuTeyUVblYq49w0HSFXXU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c5:b0:206:8dca:1b1d with SMTP id
 d9443c01a7336-206eeba5a3dmr964925ad.4.1725597262568; Thu, 05 Sep 2024
 21:34:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Sep 2024 21:34:09 -0700
In-Reply-To: <20240906043413.1049633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906043413.1049633-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906043413.1049633-4-seanjc@google.com>
Subject: [PATCH v2 3/7] KVM: nVMX: Suppress external interrupt VM-Exit
 injection if there's no IRQ
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

In the should-be-impossible scenario that kvm_cpu_get_interrupt() doesn't
return a valid vector after checking kvm_cpu_has_interrupt(), skip VM-Exit
injection to reduce the probability of crashing/confusing L1.  Now that
KVM gets the IRQ _before_ calling nested_vmx_vmexit(), squashing the
VM-Exit injection is trivial since there are no actions that need to be
undone.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e6af5f1d3b61..6b7e0ab0e45e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4304,7 +4304,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		}
 
 		irq = kvm_apic_has_interrupt(vcpu);
-		WARN_ON_ONCE(irq < 0);
+		if (WARN_ON_ONCE(irq < 0))
+			goto no_vmexit;
 
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT,
 				  INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR | irq, 0);
-- 
2.46.0.469.g59c65b2a67-goog


