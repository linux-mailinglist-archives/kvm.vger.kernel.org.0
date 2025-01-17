Return-Path: <kvm+bounces-35716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 934C8A1475F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:10:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8A3E16CC1E
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA321632F2;
	Fri, 17 Jan 2025 01:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RPc/TKtq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E411215350B
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737076054; cv=none; b=J/y658OoBktZ8+gIH4VbzmYwpQLjuCjtplEBUCz6vpDgCGaebc4Ca0pZwHuXawPCbleKHQPG0nwt8rM9ot4uf6YYIhaCD3M40NDZldXU7QhlTy0d0RQbxJbTcgxNnzSIb8yD/+5Cv0lZOctzYbJAUPbIXpcdhRmf53ktgmHH1Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737076054; c=relaxed/simple;
	bh=BuldEnEeGmI9Hw0DVTb8LsiZwmC3XXvZPUEZhBILBts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I2Fg9Jcs5ABAEcfKx5mUXWcxpHVcLc9Ic3hv+qXUp5xpqQ9YLcc/lXysc6hmSZ3OUDGS1FM5cmOAJtMdZ0Q0OZIJCo4tluLpo8WVKmphKxSXVd2WKCNMr5+sQu0SoTmcIL9PRjppk10OhPflhqw4AzBarxn0XbkbE4knuLZ8tQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RPc/TKtq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee86953aeaso3088388a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737076052; x=1737680852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uNacvWVxexFG3YeYZaGodI9DphNDLIiWKnJHtghb0eg=;
        b=RPc/TKtqRstV4ey/34j7KcZl/Thy/K6bKWMt9HKnoNqNPgR0EH4tRuSb75UKqMGxIu
         z89FDNB9MBDr5gnNxXhwPBNZFj1oPs6EDLBqE45I+lh332OAY0JUQzUgTW2alEWKpPO3
         nXeLKWHR0Wf+Xb579RVC47HYWwN3EUg6m6gsxiXrA5vSfVIZD5RT4IgXyNQT7t7wLa3H
         7LSK7VAk6yvO6pxahAXZKfqoP4iJI/XAlPZFF6rmdjf68tLbKtNs8y03O9Xtu0MF9iLS
         tomIuDRs43JIZLjPNLfJtUk4+rYGjF7c+kv/L58yqwG2MegYI39aRry/qbKZkwhdoMD+
         RdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737076052; x=1737680852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uNacvWVxexFG3YeYZaGodI9DphNDLIiWKnJHtghb0eg=;
        b=ebjBhU44qqdNMlDIuFcWYY5rxZymynBdS4EE9uey4P97OlsxVOamf68Q9cKCEVT7sp
         gKbcitHa1LPqpz4fD2rkJqJNXSbipySPWhX45CBDX25OIIDRBvwA1b6LVeCkEhCkZvHk
         Cf9kYIIF04RxoLkAObKo8uwHfUDSA7amGIz9VMrmAhQvyvGi4bWHEh6PYvUr1bir6n35
         rq3bOmi4TmqyTaR7fvAE2gpZ9jeR+vX53n+1D1kcE21eN5GG/762pE1KpsT1FykfOOHU
         kQal/vPIBD7zDHWqg1PooggsavA1n8jyfl4jB8YDzxkCjvemvjRuzdg+fH3e5A1fHbPz
         S/1w==
X-Gm-Message-State: AOJu0YwfuCAl88M2EbC4sXMS5lRr1zbcq7eeRion8ziaxYFJnNHQ5fNv
	Y0+YnX2E0obUVW3WEX0u1W/iM28HXrnusnh5NorrYaWPlp7PVWiQgvhw7G0Tn2tDabSo/fxJppB
	TSg==
X-Google-Smtp-Source: AGHT+IEPoyfyZtaaWCrK+yiJe5hZZ9ztN6DYrVpU93GAOQGnvPWsHL1Iwb6I63C0xEYdVtHQaeGD+6C0ERY=
X-Received: from pjbse4.prod.google.com ([2002:a17:90b:5184:b0:2eb:12d7:fedd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:534c:b0:2f6:dcc9:38e0
 with SMTP id 98e67ed59e1d1-2f782b01f69mr1289968a91.0.1737076052353; Thu, 16
 Jan 2025 17:07:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Jan 2025 17:07:17 -0800
In-Reply-To: <20250117010718.2328467-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117010718.2328467-7-seanjc@google.com>
Subject: [GIT PULL] KVM: vcpu_array fixes and cleanups for 6.14
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The wonderful vcpu_array changes that you already know and love :-D

The following changes since commit 3522c419758ee8dca5a0e8753ee0070a22157bc1:

  Merge tag 'kvm-riscv-fixes-6.13-1' of https://github.com/kvm-riscv/linux into HEAD (2024-12-13 13:59:20 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vcpu_array-6.14

for you to fetch changes up to 01528db67f28d5919f7b0a68900dc212165218e2:

  KVM: Drop hack that "manually" informs lockdep of kvm->lock vs. vcpu->mutex (2024-12-16 14:37:30 -0800)

----------------------------------------------------------------
KVM vcpu_array fixes and cleanups for 6.14:

 - Explicitly verify the target vCPU is online in kvm_get_vcpu() to fix a bug
   where KVM would return a pointer to a vCPU prior to it being fully online,
   and give kvm_for_each_vcpu() similar treatment to fix a similar flaw.

 - Wait for a vCPU to come online prior to executing a vCPU ioctl to fix a
   bug where userspace could coerce KVM into handling the ioctl on a vCPU that
   isn't yet onlined.

 - Gracefully handle xa_insert() failures even though such failuires should be
   impossible in practice.

----------------------------------------------------------------
Sean Christopherson (6):
      KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()
      KVM: Verify there's at least one online vCPU when iterating over all vCPUs
      KVM: Grab vcpu->mutex across installing the vCPU's fd and bumping online_vcpus
      Revert "KVM: Fix vcpu_array[0] races"
      KVM: Don't BUG() the kernel if xa_insert() fails with -EBUSY
      KVM: Drop hack that "manually" informs lockdep of kvm->lock vs. vcpu->mutex

 include/linux/kvm_host.h | 16 +++++++++---
 virt/kvm/kvm_main.c      | 68 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 65 insertions(+), 19 deletions(-)

