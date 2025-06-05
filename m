Return-Path: <kvm+bounces-48603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CF5ACF858
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08B1A166E0D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5983F27D791;
	Thu,  5 Jun 2025 19:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xaqxAQ1A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1313C27BF99
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749153025; cv=none; b=omuLdW9ddNITbyiw2xbkOnJiCqDcncLZixU5bHlhgmsuOdu/gJ4BXA00ItDlKe5xxjeJUqjjzGPbNz3j69Aqf2JffpYCNS+SG+bA929ApEylcdX36o14WbqE5PYMvHfyqHJxOyUj1tgqJWbahLDqJJKSJTpUeKvU5WK48QvSoZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749153025; c=relaxed/simple;
	bh=TflTtOFYOoUc4cVuPAvdOITqmHHc6pcnCgi8Ql7m9Rk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=p52zw9FLvQnQRW84TKwxPc6AUuaDXb6S1CaN3qrTjaoSfeSxGAvdw/gFcvC4auuQYPl9z9viVKNoObPHtbrPGXeroUzNjxUfOW7TpACBuNBI8t1wW07ZCgG01GEaDysNRMHidyIu7BS8tbCUw6oYbMqhmXaDpsp8CmfuZkWH+LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xaqxAQ1A; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311fa374c2fso2284040a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749153023; x=1749757823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnwxO9GogIau5EpmXLwXictumDZfroYmuoG/2pq9rqo=;
        b=xaqxAQ1ATqZGky+mSoCaB5oMkhz/SggvCO8PD4H308idUgJnBEI6WPYImsTBLqLpQ+
         PSymqiD/8hchFxGuMpZK8ZhitdgchmeNScyaNTpgOAISkvao6DGvUOFvK+kGbLINPSu6
         1ZMgVAR5eYVdA3VEys+PkGZ5odDR+0S0He0xVs4C5l0obz16er2z2T41xc7LksZQKC7p
         p9EshORctN81C2fdRKn4dW52fD2+IbeMLa6vkCPPfp5LmnKTaVfVyMivjZDTF3aLQA+w
         OwVbL9MjYnpc7VC0ZWFuMFLJ59sJ4R/MDDwv/PE9OI7c3zwk8eZI2hftqobwagFSqUMd
         yi7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749153023; x=1749757823;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YnwxO9GogIau5EpmXLwXictumDZfroYmuoG/2pq9rqo=;
        b=kB52wgRBDOVl6if1QlmdBKbcFBhHbXUJw07xk1ECxn4vqlQ1SJVMZtw6laGFvxFdDf
         8mGcOS+JZwW+4MHq6mNbQRgfIeAiIZeVeJP40asabVtUgMntp06WnwKVJhw0RgJBYbgB
         vGIRTLIermxa18a5KYAGC6bLuN8g2Rb4YfbOGl2VCNQSt0xbfgNkcdiYHzWpZFyXC80p
         dN+IqBeT6lYqmeoZLVMgslCJkX75gnKj/ZnOZDGjhRAZAluycb64ztAEIim2FVhjCUNw
         ooZkF+sPjBA+sn1qkWk6icmx396m0Pe/4pNSvfeC9BB9pFXSsKI1VjYAF3zIxStOEmBI
         z5Xg==
X-Gm-Message-State: AOJu0YwrCXI4JimsGXIYk7R5svwQstyJK98aOKdreyxRyFxT7g1bGj1j
	i9+h0mR6BZVC1XKYay/rJyA1+jAqhBUjGCCG0Kzg4dZnmsda4QBTUyHooR+w2Vo3XnbFdhimJVJ
	fpv3/Mg==
X-Google-Smtp-Source: AGHT+IGp8RVwCKNPkVtRNFf2/Hcg+g70jZPhLr6lPIG7Wja7Cwqp16NUoA0vIqJSdxh6fZRE9ayphp+3AUI=
X-Received: from pjbpa17.prod.google.com ([2002:a17:90b:2651:b0:311:462d:cb60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3851:b0:313:1ea2:a577
 with SMTP id 98e67ed59e1d1-313470736cbmr1304000a91.29.1749153023341; Thu, 05
 Jun 2025 12:50:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:50:14 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605195018.539901-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: x86: Fix WFS vs. pending SMI WARN
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+c1cbaedc2613058d5194@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Fix a user-triggerable WARN that syzkaller found by stuffing INIT_RECEIVED,
a.k.a. WFS, and then putting the vCPU into VMX Root Mode (post-VMXON).  Use
the same approach KVM uses for dealing with "impossible" emulation when
running a !URG guest, and simply wait until KVM_RUN to detect that the vCPU
has architecturally impossible state.

Sean Christopherson (4):
  KVM: x86: Drop pending_smi vs. INIT_RECEIVED check when setting
    MP_STATE
  KVM: x86: WARN and reject KVM_RUN if vCPU's MP_STATE is SIPI_RECEIVED
  KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check to KVM_RUN
  KVM: x86: Refactor handling of SIPI_RECEIVED when setting MP_STATE

 arch/x86/kvm/x86.c | 49 ++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 19 deletions(-)


base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


