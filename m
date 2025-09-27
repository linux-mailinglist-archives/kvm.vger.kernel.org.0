Return-Path: <kvm+bounces-58918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BF8BA59A5
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 08:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D885A2A766F
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 06:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46E632749E4;
	Sat, 27 Sep 2025 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KbDgOLK/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA97E26F471
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 06:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758953362; cv=none; b=NBTeVJmRlfHWiDYOO+fOA08aVEw5UF8HCBiBWPoii97GT11rMK9GXufDjT7eB2hNBRrqWHDeG9D50khzdw7gTfzWhReC33/sZsAP+ea785TIFETr2aNsKuehBG+9ZOjsHOxVpS4xyUm48Rc94paog9VvD2+eSl38nSuUjIpUnmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758953362; c=relaxed/simple;
	bh=uF6cEQwRQ2IVMsyfTqCEPeR8Ky1ptOx346RKxGliZ/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DCtCXAemZbCbk4udB5iWhfPDwuVzrooYMVUzEreB6emC77Sb8uvXWmeQGiaNCXCYR+EcyqClx0Ud5QA6g4E1Bc6FMcxebpt8nY+S8OP8yZz4kBaSiy9ly9+eEkbZkm3cdyv9SNqQXyL4xAmz0jB5Ar/jay9qmkv65GgPsq3QHM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KbDgOLK/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so2660410a91.3
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 23:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758953360; x=1759558160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sjx4eDJlNCRIid7gT37Qok6QDG9Mz3p6K0OfGDzuat0=;
        b=KbDgOLK/RafNJ046O8LSbU/zWX+BKBv7ctywWaIU21T+jxDDRFHJyRXwuJmJBNpRx0
         4i/GufHtpJjf/ArWhJgxSwiWcyJHRjv/Da/gJeH8x6nggxKr1pMLLAXuGmS7wJrpfwVm
         MKghG3QPVCW2FpbjIeTp/IK+ztyMx9jn5109lJyhbDvx73CdE7BUqfaFf24kwQtyuEuj
         Aay6bVwfa/8uILxQeh7F86fUXEUVV+W4zUtmuB+FWjkgNatnW09hMIY5hNxAP1dDN23M
         kprjKmH4X/CNc4SeVwITNhz/nDnNHIY5uM9dC+jaqbIcHSZKq+BH7gHcDEzVQM3geEtK
         DADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758953360; x=1759558160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sjx4eDJlNCRIid7gT37Qok6QDG9Mz3p6K0OfGDzuat0=;
        b=uYPC5CU82Jqw+sTlLmwBAi724+ocMkHuLB8yzR1tTKQdUS7dopgSa8cYLiv4WToLud
         JGCT2hdyYgmO6LpcUC0/cn3bJTegcHyB2+VGoGuxxryypQolPVRbIh4PHB86INEU/gba
         aUHVZGHQid6No5VSVDofDt2EOCGO/l/XS5qA3b58ph+qGD8nA0wUu7lu9xFL8E0ixLfW
         xfPicu1UAsdeoMzxrnT5ks4jWTo7Q0JAwJ4g/KfMlZ/uoewATRmnkRwh30Yga51+bsWH
         kDwywNmHBQhxl1WaolNsHhWmHcUbBSSc9RXtA7RCRZ8SFV0peEwxV6t2iB3R1tbBp6xD
         sJ2A==
X-Gm-Message-State: AOJu0Yw1A2iajywlPn4O75rvCV0cLdh1DbbpCzMYSyQHAxrKmmxCLe7y
	g/j6mUBW3fKSTjjRY9sxbVzvWJNIo4lJ8Xy0xzMkrjSThj17lWIO1CyF0DYaesBVX9uWYi8Vzqr
	+SDGAUw==
X-Google-Smtp-Source: AGHT+IH4u3RF85Ltp8OmYqmIYOJJglPD11So6r3fq71As2PpSeJN+vXFf1N0FQxJpSccEp9wPLL4sfL1LWE=
X-Received: from pjzj6.prod.google.com ([2002:a17:90a:eb06:b0:330:7dd8:2dc2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c11:b0:32e:96b1:fb70
 with SMTP id 98e67ed59e1d1-3342a24d44cmr13342144a91.12.1758953360218; Fri, 26
 Sep 2025 23:09:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 23:09:05 -0700
In-Reply-To: <20250927060910.2933942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250927060910.2933942-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a TDX bug detected by Smatch where KVM would return '0' on failure, do a
bit of early prep for FRED virtualization, and tidy up.

The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.18

for you to fetch changes up to 510c47f165f0c1f0b57329a30a9a797795519831:

  KVM: TDX: Fix uninitialized error code for __tdx_bringup() (2025-09-19 15:25:34 -0700)

----------------------------------------------------------------
KVM VMX changes for 6.18

 - Add read/write helpers for MSRs that need to be accessed with preemption
   disable to prepare for virtualizing FRED RSP0.

 - Fix a bug where KVM would return 0/success from __tdx_bringup() on error,
   i.e. where KVM would load with enable_tdx=true despite TDX not being usable.

 - Minor cleanups.

----------------------------------------------------------------
Qianfeng Rong (1):
      KVM: TDX: Remove redundant __GFP_ZERO

Sean Christopherson (1):
      KVM: VMX: Add host MSR read/write helpers to consolidate preemption handling

Tony Lindgren (1):
      KVM: TDX: Fix uninitialized error code for __tdx_bringup()

Xin Li (1):
      KVM: VMX: Fix an indentation

 arch/x86/kvm/vmx/tdx.c | 12 ++++--------
 arch/x86/kvm/vmx/vmx.c | 37 ++++++++++++++++++++++++++-----------
 2 files changed, 30 insertions(+), 19 deletions(-)

