Return-Path: <kvm+bounces-35715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2ADA14759
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BB633A9C5B
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E4E15697B;
	Fri, 17 Jan 2025 01:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zGkM1Zw9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B59B38F82
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 01:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737076052; cv=none; b=W2geNY8B1CYidPLNw7wy7cUOhnMNKRk2LGWgiLBecBrkRuKDVD+v1lZw/nCn7Y9bBIdNm/j2wAXdUEg7iV6ICUMdPdm6GOoEa4RUR2VTuwPt3EyZjouUDihVrTQvwGIjo3ZNCeaTBsAqhThNmtS3+XrXA+1t4ji2GaQ2NQOjOQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737076052; c=relaxed/simple;
	bh=Uu7RkY2nve068I1Bee7EqLKgGi5mvoqdt0ygI/iqPhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gKMaUdI+3lvQ7QJBcIwoEGznod19OSgOZtNYsWB7Qf9K0XLe4d1ibM7y2aidnNd+0XzQUH16Dx8Va36P0l1+7bTJNVWhZSmDqxXSJR+m1UHXF4tg214ds4USnISEpVAXHrwW2mca7YGRIoogah3oWkPQvW3IXWQbXU+mflDqRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zGkM1Zw9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef728e36d5so3091893a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737076051; x=1737680851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qp05SZcCfVp19obX9Hs79gLdTPOzowuXym+JPFc03YQ=;
        b=zGkM1Zw9ytfZ/dCQ/15+ObhAZ0chaaJWjWVm2LG1LPpli9r3HA9Ia5VtTQtpRhrK7V
         IUS3NDdb9+dhXO9HOznOBIM4efnuvjFjxKyRdYiZjBb8sXBCo+tmuTHANDtz0xYpZ/nG
         fmLJP8bimlX+dKVyaRKtpoyoNCYCJSeAisTwpcNyxAEyPCXO7SUgb1CuGyGm8wdur4Ba
         c4lYCMqnOsGmHAUJjifRjklbFoH2ox+/+E6JKtBX+m0SZUEp/j/qiFOVH7erk0SBPFAT
         hUAPGp9DfisHGSUDtujarO341XDcsfuaYOy9ywzEtjOtc55lr86sHK4cWRkOljsBbpi7
         /zsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737076051; x=1737680851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qp05SZcCfVp19obX9Hs79gLdTPOzowuXym+JPFc03YQ=;
        b=HXhwfwZt4KxhqvFOtDnWMM+Xs7D43DYhQcWF+PIzU141u59BBpP5O4G3c52cCEcK2l
         XQ/ueJSlkHtBOpN8W74QoMhVCJwngJYJ2RUq0ssLIYQp0b7hxmt8PWaZVveh4Q79SPY+
         fc7WSLWoXz302wzAYSumPQURS8oCCDqCIh2Rsyn28vthFRGrp4zyygSTpQcCl7DxQsEF
         oS0uE4wh90a7cNOk9wXlYsHDA3h3rgi0N9iRO2YHi8B1kBzW5BkWsT9B0vzLTjD0WOif
         aux3eET1Tgq3K/3xhp0hTNJaN+GqMkXmczP4N4lYTtJAYWNiro5ZsUTBK36kPwTx8PhZ
         D1HQ==
X-Gm-Message-State: AOJu0YxQx89tSVSLmC+K2DAXSCcwctPWTR8eQ4uQfwEoOAxWzuo6oN8y
	M1Rre/28TEtl0IXkUo3xARdzHRODz5ZurTW61+1QUSzcHnCbzxSYdjHb8NZ09zglZFku0LL7ZTu
	1Tg==
X-Google-Smtp-Source: AGHT+IEDi04BLRirtJbCA7J3r3owOh0w8U8RSGuOmgdj64/YXBXkNbRMQC4AFOVV2UNhrjLeimEGOEfHRSs=
X-Received: from pjbpx16.prod.google.com ([2002:a17:90b:2710:b0:2ef:786a:1835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3503:b0:2ea:61de:38f7
 with SMTP id 98e67ed59e1d1-2f782d59adbmr972902a91.29.1737076050920; Thu, 16
 Jan 2025 17:07:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Jan 2025 17:07:16 -0800
In-Reply-To: <20250117010718.2328467-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117010718.2328467-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.14
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A handful of minor cleanups, nothing noteworthy.

The following changes since commit 3522c419758ee8dca5a0e8753ee0070a22157bc1:

  Merge tag 'kvm-riscv-fixes-6.13-1' of https://github.com/kvm-riscv/linux into HEAD (2024-12-13 13:59:20 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.14

for you to fetch changes up to 4c334c68804a3296009d92c121ee56a7fe19ea87:

  KVM: SVM: Use str_enabled_disabled() helper in svm_hardware_setup() (2025-01-10 06:56:20 -0800)

----------------------------------------------------------------
KVM SVM changes for 6.14:

 - Macrofy the SEV=n version of the sev_xxx_guest() helpers so that the code is
   optimized away when building with less than brilliant compilers.

 - Remove a now-redundant TLB flush when guest CR4.PGE changes.

 - Use str_enabled_disabled() to replace open coded strings.

----------------------------------------------------------------
Sean Christopherson (2):
      KVM: SVM: Macrofy SEV=n versions of sev_xxx_guest()
      KVM: SVM: Remove redundant TLB flush on guest CR4.PGE change

Thorsten Blum (2):
      KVM: SVM: Use str_enabled_disabled() helper in sev_hardware_setup()
      KVM: SVM: Use str_enabled_disabled() helper in svm_hardware_setup()

 arch/x86/kvm/svm/sev.c |  4 ++--
 arch/x86/kvm/svm/svm.c |  8 ++------
 arch/x86/kvm/svm/svm.h | 17 +++++------------
 3 files changed, 9 insertions(+), 20 deletions(-)

