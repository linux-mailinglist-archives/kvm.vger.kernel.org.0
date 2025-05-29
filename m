Return-Path: <kvm+bounces-48040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCBA8AC8519
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 841A23A07F9
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF8C25C831;
	Thu, 29 May 2025 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fxIsd4fI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804422571AD
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562026; cv=none; b=loe0dOYIzTf5loU98ijyawyawmsy70vpwR0/0SavNjg9pvcxmcg0wAHfUP08qyNoTkVJhZpiLqd9ZyvdyGqiilpmpakeXLspHXQ/EK0UkCYHN110smhpeB3nWX5NNj2B6ZH8T4+V/0RvogWpa55NtKt9mSCE7WqrOJIxSw458bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562026; c=relaxed/simple;
	bh=k7jNJZt/AtyTPL1+DIrj8UtvvKPsSZJUXY69DXeqraE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YLuGsbjqXYsWshhkEW4uZ9LGwFX+0f6PBbmbuytd01isBevaMlWBZ9ehM7fdRht6uiFUv/XJ8C+eOLSnhXFfgbPNQ7rpfQmDUt9xO5pzOZm//zBDPolfujwUr4S/T/4fXDSS2Ad3lcaMwUMWTBBqN0xgGK54d+R9c/n/cb0Kq78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fxIsd4fI; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23507382e64so11156985ad.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562024; x=1749166824; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WMfP54PH+sYYNtk0zM+/ioopKS2tbW7NgfbBWvLgye4=;
        b=fxIsd4fIvFldiAFTlCWf5Qdp26aLb4hHe+lEAI4wmB5JtICn7XcavQ/UPwi4PI1CY1
         JDO0wgJO6MZzhKt/ej9MYYhshAp/x5izsjlc98aJwvxD7AdAVlbDYQTwENL37+kboFoN
         BI5HXKaaLck0bJ8dE0LFx3avywtby//kVLI8RykLrAkWmx80Ta2NQGQG3hsJfkTHsTIw
         fN6UFL7E0SKcTQYYHdixDL0nwpUBQjldPbRz4+RsPnXnnrw3hHNkea7zQQB8X2nLRODv
         TtlO+7+I+m3s+e181NniNVBRIN/LLti52DzglmJT4HAfPwGKMHwjeWnLCRPwYWxCz0tZ
         8v3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562024; x=1749166824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WMfP54PH+sYYNtk0zM+/ioopKS2tbW7NgfbBWvLgye4=;
        b=HVhxbl8cIxUJosIZq1s9s18fCDuhZr6e05ku6DNPhAuGbTOgasGm2RFMDVfYQuIlMh
         0wo3ixuR2/0XL65COSGyNKV6ancRpgHEnjRDUO4E8XWxCR4rSG4GD7CTuTFvlTFxySD3
         H3ZJFY5d6ALWynczROQEZRNqI7y64HspZgrAWSi+bbXJa2a3rb5MhMa+tg0nLv5AXKmY
         OU4F0PW0QMxmXPzB8GVjrIvjCB+7cbnJHWGhZdNiL2nKuR4Ytw3MCI9eETyRc3eljQKw
         4LEtQGj+Y4zEWR0M6OG7D1QdJyYfqV7IOVMdMhkg+CcHlAW49Iyx8sO+A9Z+OBPNQY72
         gsmw==
X-Gm-Message-State: AOJu0YygiNU2aOdoT1uR5iFpoCh6X5RdlX6DMNRwwNPrTMvJbdmacnBz
	q4x27ZXDjNuXzZXR2EySkjMwotNfr3sutviO7cR0fdOxXSkT1M0uiNws3UUuNyNTqZBI0PiYKs4
	NmugWJQ==
X-Google-Smtp-Source: AGHT+IFgYYDP/9VKzSLklTX8r9gsOueCtgPfXhvN33S9Y/cMn8S+nSOuO53xNOgK1nijujrnRdUCWQzDuDk=
X-Received: from plbla14.prod.google.com ([2002:a17:902:fa0e:b0:234:4c97:1e84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4c1:b0:234:8eeb:d82d
 with SMTP id d9443c01a7336-23528de8f60mr21131485ad.19.1748562023766; Thu, 29
 May 2025 16:40:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:49 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-5-seanjc@google.com>
Subject: [PATCH 04/28] KVM: SVM: Kill the VM instead of the host if MSR
 interception is buggy
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

WARN and kill the VM instead of panicking the host if KVM attempts to set
or query MSR interception for an unsupported MSR.  Accessing the MSR
interception bitmaps only meaningfully affects post-VMRUN behavior, and
KVM_BUG_ON() is guaranteed to prevent the current vCPU from doing VMRUN,
i.e. there is no need to panic the entire host.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 36a99b87a47f..d5d11cb0c987 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -827,7 +827,8 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	bit_write = 2 * (msr & 0x0f) + 1;
 	tmp       = msrpm[offset];
 
-	BUG_ON(offset == MSR_INVALID);
+	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
+		return false;
 
 	return test_bit(bit_write, &tmp);
 }
@@ -858,7 +859,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	bit_write = 2 * (msr & 0x0f) + 1;
 	tmp       = msrpm[offset];
 
-	BUG_ON(offset == MSR_INVALID);
+	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
+		return;
 
 	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
 	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
-- 
2.49.0.1204.g71687c7c1d-goog


