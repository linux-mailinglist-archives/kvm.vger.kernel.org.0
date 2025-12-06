Return-Path: <kvm+bounces-65448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B033CA9D36
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 691BB3082789
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE3223BF9B;
	Sat,  6 Dec 2025 01:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WJf4CXQN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346B01DFE26
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 01:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764983469; cv=none; b=MwEq4Iq1j17s3JKJ1jMsw0YuKvWlr7cgurO84L/HWI0d87Kae/IJNp6E3p2VkNFN+/X6qlnLDbWeY+E4nujw5eS8m2NnLW6vizwgFTheDwh+ftbuEiBBn3Vkjz5I1JSEOPIV7udvSAw8n8qCdPrMHfE01B2EVVvNdzWZOyD2+FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764983469; c=relaxed/simple;
	bh=ahpjv/o9LrVp9tjCTCe6MlNPXkZFpq6fmTPCM0Tk8Bc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CQ5uUNm93s7n67W2eyU5+bh34vDfDmOLqzVSEAMhYypgikPQo9CquuZOlgrgdpX1ZK0v6AcgMZwMbt0uFKqLL0vu3EQTF1NKikPrxAzo2VGroKccY9H/IuL0PCI0XS0/H/J+simPpQytZTZi33EEgsFfb6XuR25YjpdsSro0n/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WJf4CXQN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343daf0f38aso3058356a91.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 17:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764983466; x=1765588266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7l6e5405bVH1DspNVosbrsco7TeBvKPRawRHDQ4cDw=;
        b=WJf4CXQNt5/ot22SCIJVyN+KQECWZdiNgKS08nJnStdQCec/Zb8GMxHISIrwWGBja1
         rQPV4ftXAb8NETOeGv64VYN9QpIbng7TcQbqXfvC1xcJlcbnywzp4Smz1mQ7EmmXDh72
         h4y/i/i8aXQXvbMJzeIUxa8AN1PSJCNw0ACe6M6X0C+YB9L4gUAsv4OJWJQUbY+89jpU
         gp9Wr05z4GZ2Lg/Dn9Mu31QlRG3N+BaXBzHCSC97rHKK6sCa4RBAnxZweZSkcHaOnNYI
         0y6f+s7PAfRR5LgiY7x6i2Stj/M7oV7lUzX+M7HXlah3EZHeZcBVYobR5GwegRYS9YHq
         eu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764983466; x=1765588266;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V7l6e5405bVH1DspNVosbrsco7TeBvKPRawRHDQ4cDw=;
        b=KTM7ueTcQILW+9LnTtiDvWewA8dIqXTN2HxVrtHSAi5NZ8ywkA1kAEz5mmRwSgkTHB
         E68F65arwsengwwvaSJ/PnY8wl8Eb0+BHDrpg4HhhQSiUbiQuFanu7pwxYCnKRvFwTdg
         2dyaU9+7l8d6+HUUTgmOZE9ZSgrAPgtdXAiN7Wu3OUWkDZYA4sGHpr/brt/RELk2Z1AF
         wtsZDioEefDu2Q5EQ8mK9MY0e8neoXFT7UX+/WvFDVIcr24OIv0KARYQTNCnYFla3vmF
         kxuV09/DKCfU7tLLPLC7hpV/JaJyYSd3gmQF6CpU6meyr/+HSc0WfqKC5/7kHIeTP7zb
         h/5w==
X-Forwarded-Encrypted: i=1; AJvYcCXltwFJA65ypgN6sqSJpo75YzzP/jiBJnauVhyQPTSHRh8q1h2RhvIFj+oHVk+e7cVbD7g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+yfRus6pju2G5SKXUJtwAXVyDZnMIA03ZtSnAbDi+RI1LgbP1
	Ap4e70fCSSGhqEpznsbCMfpHEfktK+Vj9DaH+fx0GOkU7rLR1gsjqiY/iYkRaetC59+T9XFYv6/
	5G0hIQw==
X-Google-Smtp-Source: AGHT+IFC7xAn4XWvDZa+DWts2bu6U/q9MiuD8NVhGGMYnj7mARmR4s5Pdj0x5XwVYr8qoFGThh9Rt5tHVUE=
X-Received: from pjuw7.prod.google.com ([2002:a17:90a:d607:b0:32d:e4c6:7410])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:164d:b0:343:684c:f8ad
 with SMTP id 98e67ed59e1d1-349a24dd178mr797804a91.4.1764983466486; Fri, 05
 Dec 2025 17:11:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 17:10:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206011054.494190-1-seanjc@google.com>
Subject: [PATCH v2 0/7] KVM: x86/tdx: Have TDX handle VMXON during bringup
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

The idea here is to extract _only_ VMXON+VMXOFF and EFER.SVME toggling.  AFAIK
there's no second user of SVM, i.e. no equivalent to TDX, but I wanted to keep
things as symmetrical as possible.

TDX isn't a hypervisor, and isn't trying to be a hypervisor. Specifically, TDX
should _never_ have it's own VMCSes (that are visible to the host; the
TDX-Module has it's own VMCSes to do SEAMCALL/SEAMRET), and so there is simply
no reason to move that functionality out of KVM.

With that out of the way, dealing with VMXON/VMXOFF and EFER.SVME is a fairly
simple refcounting game.

Decently tested, and it seems like the core idea is sound, so I dropped the
RFC.  But the side of things definitely needs testing.

Note, this is based on kvm-x86/next, which doesn't have
EXPORT_SYMBOL_FOR_KVM(), and so the virt/hw.c exports need to be fixed up.
I'm sending now instead of waiting for -rc1 because I'm assuming I'll need to
spin at least v3 anyways :-)

v2:
 - Initialize the TDX-Module via subsys initcall instead of during
   tdx_init(). [Rick]
 - Isolate the __init and __ro_after_init changes. [Rick]
 - Use ida_is_empty() instead of manually tracking HKID usage. [Dan]
 - Don't do weird things with the refcounts when virt_rebooting is
   true. [Chao]
 - Drop unnecessary setting of virt_rebooting in KVM code. [Chao]
 - Rework things to have less X86_FEATURE_FOO code. [Rick]
 - Consolidate the CPU hotplug callbacks. [Chao]

v1 (RFC):
 - https://lore.kernel.org/all/20251010220403.987927-1-seanjc@google.com

Chao Gao (1):
  x86/virt/tdx: KVM: Consolidate TDX CPU hotplug handling

Sean Christopherson (6):
  KVM: x86: Move kvm_rebooting to x86
  KVM: x86: Extract VMXON and EFER.SVME enablement to kernel
  KVM: x86/tdx: Do VMXON and TDX-Module initialization during subsys
    init
  x86/virt/tdx: Tag a pile of functions as __init, and globals as
    __ro_after_init
  x86/virt/tdx: Use ida_is_empty() to detect if any TDs may be running
  KVM: Bury kvm_{en,dis}able_virtualization() in kvm_main.c once more

 Documentation/arch/x86/tdx.rst              |  26 --
 arch/x86/events/intel/pt.c                  |   1 -
 arch/x86/include/asm/kvm_host.h             |   3 +-
 arch/x86/include/asm/reboot.h               |  11 -
 arch/x86/include/asm/tdx.h                  |   4 -
 arch/x86/include/asm/virt.h                 |  26 ++
 arch/x86/include/asm/vmx.h                  |  11 +
 arch/x86/kernel/cpu/common.c                |   2 +
 arch/x86/kernel/crash.c                     |   3 +-
 arch/x86/kernel/reboot.c                    |  63 +---
 arch/x86/kernel/smp.c                       |   5 +-
 arch/x86/kvm/svm/svm.c                      |  34 +-
 arch/x86/kvm/svm/vmenter.S                  |  10 +-
 arch/x86/kvm/vmx/tdx.c                      | 209 ++----------
 arch/x86/kvm/vmx/vmcs.h                     |  11 -
 arch/x86/kvm/vmx/vmenter.S                  |   2 +-
 arch/x86/kvm/vmx/vmx.c                      | 127 +-------
 arch/x86/kvm/x86.c                          |  20 +-
 arch/x86/virt/Makefile                      |   2 +
 arch/x86/virt/hw.c                          | 340 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c                 | 315 ++++++++++--------
 arch/x86/virt/vmx/tdx/tdx.h                 |   8 -
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  10 +-
 include/linux/kvm_host.h                    |  10 +-
 virt/kvm/kvm_main.c                         |  31 +-
 25 files changed, 657 insertions(+), 627 deletions(-)
 create mode 100644 arch/x86/include/asm/virt.h
 create mode 100644 arch/x86/virt/hw.c


base-commit: 5d3e2d9ba9ed68576c70c127e4f7446d896f2af2
-- 
2.52.0.223.gf5cc29aaa4-goog


