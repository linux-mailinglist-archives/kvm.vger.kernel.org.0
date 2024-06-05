Return-Path: <kvm+bounces-18977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01FB48FDA61
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE8A11C2194F
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95EA16D4D7;
	Wed,  5 Jun 2024 23:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oh4Pk6iL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B235716D301
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629726; cv=none; b=OqgpOf3TUcFgYEQ+bJJb8r/yeKxM6dbRwHE7SL+YqXH491C8XvcBZcORD3GaP3K+hIoE01O5HDil2DFxCFbFBq2spPChURTPIEpufkRMVU7iFw3ocGl45iv6UmOPIioXMitbS8boEiZyUQTLwpwYHsWntVqHiDXBzVc+w8mfbQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629726; c=relaxed/simple;
	bh=P9RyWYMf+YNGFABRF36xrbKpYycRkItrn2jGT6YV6xM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L8Pgl0gWRpHEd7OkTwV7Jreosa51vcfofKo+hDu+GbCuPpUWMO/qbJVUbJwadyV0SkbtaV9p/HsvUNxnEpwCmTW7f0Ynm3zQsL6dQDJfZXA1X73tfkqvYvDPDLSiRxeUUuw/6L+Y1Qb3w7QJQOFSiYyGDAWqI+uUSxaL7Sx0/Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oh4Pk6iL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f8ea7f4501so281191b3a.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629724; x=1718234524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H3rxztaoR/EcRsO3ESvOSnc/k1wzc+90O8DkMkOTXQc=;
        b=Oh4Pk6iL+XgAfXYKr+G7ICy3O1iTWFuZ6TjsQUkTjgWOVg059oN7VmV3uj+baDjn+8
         CAFNeqzy62hQli7KvZLXdym+lftapnH8VVCJClcFAptcl4YxhZ5luhht4t4rEv+NpKCR
         UzdoYz3RnIVY0P6LcQT+pRfxciWYZH0xcN4UZNrS0/vhr9EKbmuhgYO6LEzNWVe3/9lS
         SOMhr1ars23HdJ2O+fEFGPZ9ePZL5qA6RmKha5ADB+xhgMG3B3jRXoHcVCo5ROsthukI
         Y4sQQBIXHmZWCzDRx1nq63R77eiP123n8teb216dWIvjVylfyQWUqxWcBDdiCrKUjeGR
         ZA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629724; x=1718234524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H3rxztaoR/EcRsO3ESvOSnc/k1wzc+90O8DkMkOTXQc=;
        b=wdmJrgZ8VshjZa5ZKgWGePHNEszwDmC0pEth+uI2zGkc90RhBvRfa4Kv12ZDPMdHaP
         PvQt2Wf2Z0Qppn+hrY/ZcY96tj+iXnd0aeX1ycEPl+jlqCnZD4G34djv7yrPd+LYpB6V
         FBsn33YysnTZikyBmI/czNU4iLahGj3+KVKNwvJ/6YauNcdHRTq8oMVjtQ8liX50K6Oz
         ErL2dTCfy4XLSsFGo0aSibsqqf7HaUqeJmay1CrO1vcLmFzKOr/p0P+kANKqZGJT3PTf
         5lLBnF+Pgqb2w5MD/4sRcB8TWSMjH5i6XR3P83urf8QArP1crmbnGKbM1a3J9+7DCvlB
         t5fg==
X-Gm-Message-State: AOJu0Yx+Gt1bF7RCyW25Y+u41O6XrEOOVR1eFXXxd/09wxhXDcRcT+Pz
	jBYh//k3/sKMLni/yB8R02h7Frq6I8loAAl6MotYB9DES6t1wVHvcuqdteQNBuCwe8tbGQUiSPA
	xvA==
X-Google-Smtp-Source: AGHT+IH4TSrexHaVhknzqOOfUAGeLdJ3UHxST8aI0GyJFdKhuOqTcX7GH54EtcXI7cdfBz9OWdtn0T8Adh8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d09:b0:702:2c04:c2c4 with SMTP id
 d2e1a72fcca58-703e56f1288mr168628b3a.0.1717629723832; Wed, 05 Jun 2024
 16:22:03 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:48 -0700
In-Reply-To: <20230911182013.333559-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911182013.333559-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762776154.2908110.1249774051318139502.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] nVMX: Test for EP4TA pointing at MMIO
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 11 Sep 2023 11:20:10 -0700, Sean Christopherson wrote:
> Finally posting the testcase for the fix to back !visible roots with a dummy
> root[*].  The testcase is very simple: point EP4TA at MMIO (TPM base), do
> VM-Enter, and expect the VM to not die.
> 
> [*] https://lore.kernel.org/all/20230729005200.1057358-6-seanjc@google.com
> 
> Sean Christopherson (3):
>   nVMX: Use helpers to check for WB memtype and 4-level EPT support
>   nVMX: Use setup_dummy_ept() to configure EPT for test_ept_eptp() test
>   nVMX: Add a testcase for running L2 with EP4TA that points at MMIO
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/3] nVMX: Use helpers to check for WB memtype and 4-level EPT support
      https://github.com/kvm-x86/kvm-unit-tests/commit/ee7c8d4e630a
[2/3] nVMX: Use setup_dummy_ept() to configure EPT for test_ept_eptp() test
      https://github.com/kvm-x86/kvm-unit-tests/commit/5676a8651066
[3/3] nVMX: Add a testcase for running L2 with EP4TA that points at MMIO
      https://github.com/kvm-x86/kvm-unit-tests/commit/e87078ea65b0

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

