Return-Path: <kvm+bounces-41567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB7E1A6A846
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58E0C7AF047
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58428223301;
	Thu, 20 Mar 2025 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wy213NHy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB2E21CA0E
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742480426; cv=none; b=O+rvaAO0uJKyVSOdE6DY53jQYJIC5oJJuHefile50lwnHxA4VNYDa1L+ByRBcZLD5z8VFc7+Npf3IkrriNKCCJKoGEOWn5PiVa6I2PF59TNdU8TcMLuxo+PMkx8HW4hm7C3t2ib+Occaz690LHHnEofr7/rnXaV5FcjjVFxi3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742480426; c=relaxed/simple;
	bh=tNxAW1HmwP8/PiQIse38Fr8cRYAU0tEkiagmuxMfErw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YeuMoV3d2k77aAZSUCd8mLIboLgHplZN41Nnwr2qHJqm5YRYsMzrg/MXUVysGRbhBFQS8wFthXiwzcAcHYvzWDIuT9ZJmKfPSS48v0mSh5SQDJ3803PZVxPcSfBSrTx6Vks5aZhld70M5TVGuv8RWmzrWsaGT2ApCZM2hgEwf90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wy213NHy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff53a4754aso2390362a91.2
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 07:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742480424; x=1743085224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQ7a++J17KUMjST6dXpOWFRvicXAAwyuIpdw08Rmji0=;
        b=wy213NHy2bDGwdCa+pWjxhowj3JAu7kz2G2XTuNPHFDjP4I4rXZS9cAuCDtQLWrPID
         DnHY+BneMBTtcwR7L5GmxUMR2diZ0jvVEdab0mPc/r7X4xSAT5g+s9jfZ80Qfc8p8av9
         L9qiam/wrozcTXxzG+PDe4o4hVADN+eikFs42CU8oC+Ea6f6Ufjqo/MBaVkOVzYH0Bzy
         gLzvDMjb0Yz0KES6OSOFKGbDxdUvALa1tRRLJmOgQWl2bMKQnd1zEqdc/Tvky+OMCyn7
         dNjdYoCz68K17yzI/zKT/4Pqv15N+isdA3mvdrxx2Vjn0eGmOUIfyomkD0wuaTUdDyw6
         FBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742480424; x=1743085224;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQ7a++J17KUMjST6dXpOWFRvicXAAwyuIpdw08Rmji0=;
        b=mivdQW+UmMyW0IaBYfzaRLUYzt2FMH9wkbKs9EGYcx5TeUk/yS16vzVK2lBV3F+FB+
         XIA8mQFYDRFA54sWIBeFq1nmHPueL4Gkz0lrp0XvwBPyvjlZ7siqWLMkgVOXg3Jiz4DJ
         2ZjQ4wbuFOJ7oxpGwiXsrxmtg/BAWHvqiOn39bfWexaWt3dvrWl/7ymXQBgrvwR4Pcqe
         EHhz2U+gRnIGSwuneP4CTOM7NzPNQ42+XCUZXTj2AqB+VgD4G2EL7raraHaleSbYvUEI
         Er+0dJfhgDThTGOWtXkTRv0f+lv/z7Vxu1xRNXqGFPalz+AV29fckK+PnQNrPn4W1cHv
         /ziA==
X-Gm-Message-State: AOJu0YxXqj+S56KSXFDuueaii8hRIOKR5ojVCGhWnVCNIZhu3UpQ2WWx
	yX7Ak5A2ihC8AGL9UQAm7Pf8skAP3FPKxGHdXfnFCJyLYFgzOQaTxwd8xeDSC/IMLUa+60/nNIO
	lKw==
X-Google-Smtp-Source: AGHT+IGsK0w6QEPvj5kiwwTvWmxPAMrfJ6tTPMnCXbo611A7BC5y+8le7igPgrv/XD8n7L3SDRwsFIpCwTw=
X-Received: from pjuw11.prod.google.com ([2002:a17:90a:d60b:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:554e:b0:2ff:6fc3:79c3
 with SMTP id 98e67ed59e1d1-301d50b4d30mr5762161a91.9.1742480424438; Thu, 20
 Mar 2025 07:20:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Mar 2025 07:20:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250320142022.766201-1-seanjc@google.com>
Subject: [PATCH v2 0/3] KVM: x86: Add a module param for device posted IRQs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a module param, enable_device_posted_irqs, to control and enumerate
KVM support for device posted IRQs.

v2:
 - Add prep patches to use kvm_arch_has_irq_bypass() in vendor code when
   querying support IRQ bypass, a.k.a. device posted IRQs, so as not to
   unexpectedly introduce a (desired) dependency on enable_apicv. [Yosry]
 - Use "&=" when constraining enable_device_posted_irqs based on APICv
   and IOMMU posting support. [Yosry]

v1: https://lore.kernel.org/all/20250315025615.2367411-1-seanjc@google.com


Sean Christopherson (3):
  KVM: VMX: Don't send UNBLOCK when starting device assignment without
    APICv
  KVM: SVM: Don't update IRTEs if APICv/AVIC is disable
  KVM: x86: Add a module param to control and enumerate device posted
    IRQs

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/avic.c         |  3 +--
 arch/x86/kvm/vmx/posted_intr.c  |  7 +++----
 arch/x86/kvm/x86.c              | 10 +++++++++-
 4 files changed, 14 insertions(+), 7 deletions(-)


base-commit: c9ea48bb6ee6b28bbc956c1e8af98044618fed5e
-- 
2.49.0.395.g12beb8f557-goog


