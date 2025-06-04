Return-Path: <kvm+bounces-48436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2C4ACE465
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6AD347A8A35
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A0D1FECAF;
	Wed,  4 Jun 2025 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HMvthrqn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D595F19E819
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 18:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749062187; cv=none; b=WyaDwfiy4FfVxpqpz0swaEhV1ad/4QdcDjXMKZKt2SpKVdA7tiddmKc5e94XLvJKEPdjTZU/Mj0O+jNGKWK+npwnCLqUrEwfCdNJ8DV7jbdL0FzietWIjQ+UkaFNNbC9vqJNV6d8PU+PZ0nZPEb9weSIl78zs8JSXoVIPr6GbTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749062187; c=relaxed/simple;
	bh=ZM6YpedL6AOaeH51XjkJTYmUak9q8PQJfDC6E7fBCL0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VrUHqUP6VMlRVJ2fo8lU+SJgf09galPtm/wcg3Pz9eU8jxyC8IigTMDFvDunb6JwM5agXocrr3OhMPXjywXVk7TAximRl2xKD85oQuRafI9wQbwsnxbEDVR2KZUxcpniRoaL16t5gWBbvQH1/nN6R0XNBZJnO7ifxKuwPt497Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HMvthrqn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31171a736b2so215041a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 11:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749062185; x=1749666985; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qREyxY0pJl545xhWMoai0EeJehT/Bmg+Akfn0vmwunQ=;
        b=HMvthrqnZBwtj9/N92DNbaexX88xx5dx0LmzrTb5g89P1TkusofY9ZZWnA+g/wbnum
         db61Ja1WQRoe4HhY3PkpculGCszt7uaFwPZiBl1bHi8wzAPaWcvKIq25BlT1grPe82JC
         y45UsSkkmQnsv3BfwDOygfDR6oylTXyD5TrWiSOYdCvP9DS3iwJFOPeWYVlaDPz9STaN
         sh293X0r5rxhWkM4BpTrT43CXlMB46SBwB/x0QTG/i4NPoy8VOaztZu2VIeNbYUb4w6x
         qIacS5+iOFRHpKTA5nmwHhJVZGZyUwQtz+PCpBd+bzNQH5G5mZrFDUq8RD3TeHbXjW8t
         LgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749062185; x=1749666985;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qREyxY0pJl545xhWMoai0EeJehT/Bmg+Akfn0vmwunQ=;
        b=FB0XO7PgiOL2QHjF1cBnxI+f2Su4w4guGWFIqe23PUekrnxWiF4Sfl8e81bvduDZJu
         MrF1OI29BiYPq/3In2SMyVGb0/UAS2l+gTL3oVsOQfKtBs0Wg2ZdUUsAtto0E+KcIENR
         zmKN5ZrVEoqofGYpudcdPfPxg9C32pQGM4juG6+IVLcMFRWebIVgKS2XlnWIYUBBiGkk
         Nps6Xp10JNWMY3LF6CKoPmjq0TlCU0+iS49uQdI2bVA07MAfU+yZg9DmPuvf0r22ZwJ3
         o537VMIQCLMNHjSW1m93aP3ocNTqBYfVkgdr/sZkq6XbhE3jOHb7u8Hegdlj57AFsmpA
         5kcA==
X-Gm-Message-State: AOJu0YxXYQuymqB8sg6FMUYAawrubrHyUQcU9Dm8yh2bI/bO1P7mY0wt
	DiPynTe/C4+A29ZVir/zWeDWb7BF6tbtIeevAQJcE2sNY65lSB+2bUEGQYf4TFf3uTeLIJAURf2
	sBtjDXw==
X-Google-Smtp-Source: AGHT+IHXTsLB80IYpQi4b3hV6ylTZ/MKx+kMfHcZHKJ3VR4KP0FbuhJdvo77CnEA1hR7DOPsV1AwZ4F5ZBo=
X-Received: from pjbnb5.prod.google.com ([2002:a17:90b:35c5:b0:312:1900:72e2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:264c:b0:311:f2f6:44ff
 with SMTP id 98e67ed59e1d1-3130cd97b71mr6855865a91.17.1749062185108; Wed, 04
 Jun 2025 11:36:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  4 Jun 2025 11:36:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250604183623.283300-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/6] x86: FEP related cleanups and fix
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

The ultimate goal of this series is to be able to check for forced emulation
support in a nVMX test that runs with a garbage IDT (the test currently
assumed forced emulation is always available, which fails for obvious reasons).

Getting there is a bit annoying, mostly because the EFI path happens to load
the IDT after setup_idt().  I _could_ have just tweaked the EFI path, but opted
for a slightly bigger overhaul, e.g. so that it's easier to see that the BSP is
responsible for loading the IDT, and so that setup_idt() can _guarantee_ it can
handle a #UD without exploding.

Sean Christopherson (6):
  x86: Call setup_idt() from start{32,64}(), not from smp_init()
  x86: Drop protection against setup_idt() being called multiple times
  x86: Move call to load_idt() out of setup_tr_and_percpu macro
  x86: Load IDT on BSP as part of setup_idt()
  x86: Cache availability of forced emulation during setup_idt()
  nVMX: Force emulation of LGDT/LIDT in iff FEP is available

 lib/x86/desc.c   | 29 ++++++++++++++++++++++++-----
 lib/x86/desc.h   | 14 +-------------
 lib/x86/setup.c  |  1 -
 lib/x86/smp.c    |  1 -
 x86/access.c     |  2 +-
 x86/cstart.S     |  3 ++-
 x86/cstart64.S   |  2 +-
 x86/emulator.c   | 11 +++++------
 x86/emulator64.c |  2 +-
 x86/la57.c       |  2 +-
 x86/lam.c        |  2 +-
 x86/msr.c        |  2 +-
 x86/pmu.c        |  2 +-
 x86/vmx_tests.c  |  7 ++++---
 14 files changed, 43 insertions(+), 37 deletions(-)


base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.49.0.1266.g31b7d2e469-goog


