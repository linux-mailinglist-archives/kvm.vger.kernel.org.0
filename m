Return-Path: <kvm+bounces-53487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E83ADB1267E
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FCF2563EDE
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E4B264623;
	Fri, 25 Jul 2025 22:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0U4lHNMd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD87D262FEB
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481252; cv=none; b=VPb6Zq62tFrQBubhZ/6ZcSGuxNKajPjTxlGp/l3SZGwTwXV55/V+c+P7/BXtDRIRgh387HM7q1r9q1kDPVhDp5tAJz1fQ2FVrmA7ca3821AWU616NOkFTzyAH9Xy0qewQ48+7uW+abjz7hojKbcq8xyz8hGLGunlNPogOUoXXOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481252; c=relaxed/simple;
	bh=fTDYV6W4LbKflQ4abZjNwAYJA3G8xvjNOYFPDnAdaSw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oB/UjZFq+PE0hVk/RjMkZNn9xsJ8iBL8Ru8nK5smcwcnTPAMVQKN8dYODUXHrJomWF48sj1zpv4kwAM4v9dtXolAT0C8bAgH1eXBfd1mZpY3BCpy0n2x3fqDNGmWKONAer8dLnnuwnBfNr5UhTYS1ihtuxs9QaYO+wSig9JS8vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0U4lHNMd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31215090074so3951948a91.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481250; x=1754086050; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y6htonD57XDXz16V1OAQINLlwnqllG7sgUgB7CHnHg=;
        b=0U4lHNMdeW+2qHfa40E2N+paPu4M1u0zi2wKRooJTezhU9udE8tBmjYDNu+y6OGoPC
         kA2VJR0tnPYx9AhxSdeXLKUGcvtUijnsbAEOqJnQIrHdi0tTfuK9eW2gXjHjPzmJvUDU
         jHiqvYEGajUcRQ3gDkKvuV8Wd8WF5BjcCyrWZWliSVic+wkrAQnXIVRWnlo2g4UxW9FK
         ZZgRar+u1cldN4pkAT7HjyvoIQbL7LPHn+Dt/ZoyHRTTjd+kytPI65ecFWgQ8j8s/dt8
         klq2xBhjzRTo8eO2yaGnPJxhCx+CRQW0rIF1Lxwf9wBg/WOzKIPLmQWotxIrud3SJg7W
         0ykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481250; x=1754086050;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Y6htonD57XDXz16V1OAQINLlwnqllG7sgUgB7CHnHg=;
        b=I3iWQwN8vqo4axJwNaDmTRfF8zlGzYDLuDHp1tfx4XLvXv9O2gukmPo+xtpK/nL0Ke
         m7kP+a+rTGuNR3JttWx+N/MPTs2SIBC/NsTFslaZNJCf3p47M6ZG+RMjq4GQqfY5SoYd
         kXsHghpaiXnAU6qvraEfaP7q0MXvuF7Y5l//cfQ/XGkgyJfF7nRuJhwf+qS+7dquGDKI
         wKne/KCILcxHsAoZX+8mtlKvbrORiazez608/89RP36oP4sOaXWuJwGkg/dqjEG9TXsR
         fbZSyRCQ9sJ5QerZmgvfhub6e42BHZjfRZH2fp8Kf7xFkxfTejPiwr6d6inFZL0yyU6B
         WmQg==
X-Gm-Message-State: AOJu0Yxn7cF6FXXAVYfEDaz7NKFLZ/kzPdfLQcemRPQB08bgv1zbqFwh
	oiARlHebScnB2ErKw07lKmi7/N0iDn59cMs1/BnUATsFitK1xHQZonY9l9PWOI4Vuj0953dLog/
	vgTjdHg==
X-Google-Smtp-Source: AGHT+IFia7CnxcPZn6s1QJ5WnyDe0N4S00zu8qyLru6aJYUSbzYS9oOvJPDW2xLA4DhYxMt6hdAejB28KZ0=
X-Received: from pjbhl4.prod.google.com ([2002:a17:90b:1344:b0:313:d6cf:4fa0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a06:b0:311:f2f6:44ff
 with SMTP id 98e67ed59e1d1-31e77adafeemr5441517a91.17.1753481250103; Fri, 25
 Jul 2025 15:07:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:08 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-9-seanjc@google.com>
Subject: [GIT PULL] KVM: Device assignment accounting changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Two changes that depend on the IRQ and MMIO State Data pull requests, to kill
off kvm_arch_{start,end}_assignment().

Note!  To generate the pull request, I used the result of a local merge of
kvm/next with kvm-x86-irqs-6.17 and kvm-x86-mmio-6.17.  The resulting shortlog
matches my expectations (and intentions), but the diff stats showed all of the
changes from kvm-x86-irqs-6.17, and I couldn't for the life of me figure out
how to coerce git into behaving as I want.

AFAICT, it's just a cosmetic display error, there aren't any duplicate commits
or anything.  So, rather that copy+paste those weird diff stats, I locally
processed _this_ merge too, and then manually generated the stats with
`git diff --stat base..HEAD`.

The following changes since <the result of the aforementioned merges>:

  KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps MMIO into the guest (2025-06-25 08:42:51 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-no_assignment-6.17

for you to fetch changes up to bbc13ae593e0ea47357ff6e4740c533c16c2ae1e:

  VFIO: KVM: x86: Drop kvm_arch_{start,end}_assignment() (2025-06-25 09:51:33 -0700)

----------------------------------------------------------------
KVM VFIO device assignment cleanups for 6.17

Kill off kvm_arch_{start,end}_assignment() and x86's associated tracking now
that KVM no longer uses assigned_device_count as a bad heuristic for "VM has
an irqbypass producer" or for "VM has access to host MMIO".

----------------------------------------------------------------
Sean Christopherson (3):
      Merge branch 'kvm-x86 mmio'
      Revert "kvm: detect assigned device via irqbypass manager"
      VFIO: KVM: x86: Drop kvm_arch_{start,end}_assignment()

 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/irq.c              |  9 +--------
 arch/x86/kvm/x86.c              | 18 ------------------
 include/linux/kvm_host.h        | 18 ------------------
 virt/kvm/vfio.c                 |  3 ---
 5 files changed, 1 insertion(+), 49 deletions(-)

