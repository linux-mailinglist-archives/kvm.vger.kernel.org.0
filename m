Return-Path: <kvm+bounces-19108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B15900EB2
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AD841C2198C
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4A21CD3B;
	Sat,  8 Jun 2024 00:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e18q2VWP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5533A1BC53
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805215; cv=none; b=NfyOSTpxQ16v70mvC5xkqIdSehmXjix4Ufx3Yp2Dat5VCWRjjo4izMFVlHpV0l6w2M8jxTup+ATwkOc0tRY7nC35OYLTCEcXaH/4ukIWhUhe9f/R2GgcnL8Q+eQqA4ypLYx/3mG6p5vvrGeXrlyNeipCWiuJ/6CLDeLxVzJveBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805215; c=relaxed/simple;
	bh=+Rgd0uG8zFVDeMbiPveKaoIB6ed40a/lydcxeYv2SLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rqPBN40czZOYjk7+3xyHqch2zchrLWEHELsQUVyHl5c4c50Xwzvbu3mRfD6Btr0TCD97mjgP11tuz5nEeHGmngZBntLCHNpBh7VYWgf3/ZuFyZnNn3712E5HVj8mKzbZGYe02lMsmRTE/S2g6tY+9ySj+2N6DxvKr4750ZNUIhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e18q2VWP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6c7e13b6a62so2475797a12.0
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805214; x=1718410014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9BJaexKSfJJd6oXZEzTDtIkjFffas2FF3vn5yJVMfK8=;
        b=e18q2VWPgf4oQ40xLhET1XE6NkKDgYhAH2P+56EPH/jDzymoSA40l6BJOKqoac1mVN
         RAKOrxwzlhO0FFj89dO0PRNKAQynWR1iyfbf8XnFIivnlHVN/qHtWKHu7hCO0H9h25Xa
         dWJCsKjuDdbjscZJpQzAms1wv1DTgxjUtrumWywJkbZrlxPmjJUJdvNi5wE4ulK0eCp/
         B4/gRZcvU37OJMWiWYXajKndpvULlNxUpB5wgB7QpGl94/18z46KUftZa61mpqyPYrjt
         TqTQdkRJZjrBHpzzm4iJwCjMyUbqAhUZSP7T59w3/VQLW+uju34yVuQ4IXa5QdiVWDIU
         tWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805214; x=1718410014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9BJaexKSfJJd6oXZEzTDtIkjFffas2FF3vn5yJVMfK8=;
        b=A3VLgsxK7J5uRaHQ3GBNj7eJPe1JL0PYedUk4kO0d9XlgFYBi5OgvB0/G7Rm5g3q5E
         RScmKmuNL46awEnPTWkQLjFPBFxXXzfwXZ4BVItYIqU8/mPUO4PKclBGypAjIbYR987i
         57QguBeD5VIGzyY1q2aCltNkVCbmw1AT9I1rhdoKVOCFUlNm8XGkWwz6+ow2BoGlqt2T
         WBLuC2TaZEo33+akVsRt4F3pidgED2eHqiO/CdcLy0pAN8V8WMO6s2ef8PVHHJGudQzT
         EMy811XpT/hS71s035uT0HtHbjqMxNjk2qOyAbe6LK15FKBe4Trwnl4JEjzmxacOFJHT
         dXtg==
X-Gm-Message-State: AOJu0YzQGNQIpRg9IZk+pt7Aa9I6YexMaiIPHj45ZUiJedHMwjECOf+i
	odg4L+T4RZPovEsiUidmTTvb7pY/uPyREkG1+cOShXlAdxjymE5ajoYILePdyCDpSVnuHLsnv01
	OxA==
X-Google-Smtp-Source: AGHT+IGSWWVQPTwJRta7zJEdra8ZC8/nCqaYH3EjnTjLAbAgOrfQRgAJ3ikjR3Fon2AfI2+l6m4fHLN4sa8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6309:b0:2c0:122d:c534 with SMTP id
 98e67ed59e1d1-2c2bcc5f046mr9783a91.7.1717805213214; Fri, 07 Jun 2024 17:06:53
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:06:37 -0700
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608000639.3295768-7-seanjc@google.com>
Subject: [PATCH v3 6/8] x86/reboot: Unconditionally define cpu_emergency_virt_cb
 typedef
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Define cpu_emergency_virt_cb even if the kernel is being built without KVM
support so that KVM can reference the typedef in asm/kvm_host.h without
needing yet more #ifdefs.

No functional change intended.

Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 6536873f8fc0..d0ef2a678d66 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,8 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 typedef void (cpu_emergency_virt_cb)(void);
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
-- 
2.45.2.505.gda0bf45e8d-goog


