Return-Path: <kvm+bounces-47035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7671ABCB5F
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43F1B4A08E2
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5F522069E;
	Mon, 19 May 2025 23:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wiyed438"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8BF21A45D
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697297; cv=none; b=PZ5OfYKmzvv3dgFBbPmjlCcEPwi4ZwDEW7ZSajbbQ8XKbBFZbej1PRY256M8ZjVaGHLOUjWDOl9Iwn+OS2xMAm8ljCiR/vp/W73xMUT/GEKoqVKALIUd/CKgvP//rBTL7W34ft4SURXq7zyAoeLn5FnOm/hjzIcJE+O5Y1ymWy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697297; c=relaxed/simple;
	bh=ABYKT87hUcjZ47YhZTQDIPC9cAn/v+Sry3menbwd5+k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nOSaE5eJRUA8rxDnzVU5j87K9Eo2+QmsdS1qWPucZ+FxhLALbFIMGZZBe5adMq4nOKg8Y9VmLWoeu79BWKhJAN8xK2nW8hBMO3l/yRtmACTjT5rdfP+45NFyLr25lykL+exlPjSx1qyjCOe1hD9nzVfiSXewhiybPhwdhv+JZ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wiyed438; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-231e412d4c9so23546325ad.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697295; x=1748302095; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eosjEUPXX9wu9dJnrDuC2wPHanGn2nAIE+9tvUyY9+Q=;
        b=Wiyed4389z4h26irDZVQyqKmQJQLYSGNBG/lGr3Op5OElu3W4Rwye+5m5NBA8XBr1c
         4BvI27fmSLsIOF42plID+uR+zGymLAU6Lpoz7/Nc9chD8eSjDrj/Xdpnm6E/qy/Sx6xI
         6iGWmE6lJ+tvjXkNGC88/ib1uGzwS6Lodkq8Aev/TfJ9/tSlOyCelOx5EMK0He8/5VE8
         Am8J5xJrTC0AzFmHBTsQhNfdHMNKun9K5adQJBjuGfEtzmvMxKuk0YxRLmlIAyFDF4lP
         khSwuRSldFDHulHG5ubvo0Iq2lxhnW0uVSeD7gZd48A97qf8dfjt3f9SD+4vi/k/eIRc
         9wfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697295; x=1748302095;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eosjEUPXX9wu9dJnrDuC2wPHanGn2nAIE+9tvUyY9+Q=;
        b=vSU7qbliHs+fMJyb0WYdL2GFjI0ESyVlIyKnjuqTYCPmdTMJPgvou/RvdvO75+Lh+8
         /JlvoisfeCfi6gKijc6RMpAoTech6exO9t9T1XtVqBWyn9qBn5D+g98WH8bPUMNtyHfn
         +WAIbE0PHB07tMC6OiXtVoj1bFItds7K1sT7Ie21wWzJEky3FmIyVVozyPa0/hCAVW49
         DVCqn6+ajok035TcEdBcMRIBHDqnWE6cIQpeKmRQADbEFRDkZDvDPz7Ly3dNNvpVGrlY
         bSL2DFokXYfOYrFNXTBFrpAOCMditPXd4hW8FMnShnM6DROPo1WHMrrBmwQQA4hyb4qv
         JKsw==
X-Gm-Message-State: AOJu0YxKxWpzfq4PtlJJvPhESTDLcdzVi+MKeyz28rLv7xkiVPQn3FoA
	wmmvx6WQy6mPyVxc3K7y64c1FQ6qXbZS6QRUN4GLe/dmWAzsdOXgi8yaFsjovqFvGgUK8kze5eN
	Dw/lSyw==
X-Google-Smtp-Source: AGHT+IG78zcntgjKlrty4n74EQTp4yTRbBdkG1kjpn+sAJZJpv8icqYrL30aPlVyOesK1rcC7UWDb/BPFow=
X-Received: from plki13.prod.google.com ([2002:a17:903:1a0d:b0:231:f3aa:e763])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f791:b0:223:501c:7576
 with SMTP id d9443c01a7336-231d439b01dmr229344175ad.12.1747697294762; Mon, 19
 May 2025 16:28:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:27:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-1-seanjc@google.com>
Subject: [PATCH 00/15] KVM: x86: Add I/O APIC kconfig, delete irq_comm.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This series is prep work for the big device posted IRQs overhaul[1], in which
Paolo suggested getting rid of arch/x86/kvm/irq_comm.c[2].  As I started
chipping away bits of irq_comm.c to make the final code movement to irq.c as
small as possible, I realized that (a) a rather large amount of irq_comm.c was
actually I/O APIC code and (b) this would be a perfect opportunity to further
isolate the I/O APIC code.

So, a bit of hacking later and voila, CONFIG_KVM_IOAPIC.  Similar to KVM's SMM
and Xen Kconfigs, this is something we would enable in production straightaway,
if we could magically fast-forwarded our kernel, as fully disabling I/O APIC
emulation puts a decent chunk of guest-visible surface entirely out of reach.

Side topic, Paolo's recollection that irq_comm.c was to hold common APIs between
x86 and Itanium was spot on.  Though when I read Paolo's mail, I parsed "ia64"
as x86-64.  I got quite a good laugh when I eventually realized that he really
did mean ia64 :-)

[1] https://lore.kernel.org/all/20250404193923.1413163-1-seanjc@google.com
[2] https://lore.kernel.org/all/cf4d9b81-c1ab-40a6-8c8c-36ad36b9be63@redhat.com

Sean Christopherson (15):
  KVM: x86: Trigger I/O APIC route rescan in
    kvm_arch_irq_routing_update()
  KVM: x86: Drop superfluous kvm_set_pic_irq() => kvm_pic_set_irq()
    wrapper
  KVM: x86: Drop superfluous kvm_set_ioapic_irq() =>
    kvm_ioapic_set_irq() wrapper
  KVM: x86: Drop superfluous kvm_hv_set_sint() => kvm_hv_synic_set_irq()
    wrapper
  KVM: x86: Fold kvm_setup_default_irq_routing() into kvm_ioapic_init()
  KVM: x86: Move kvm_{request,free}_irq_source_id() to i8254.c (PIT)
  KVM: x86: Hardcode the PIT IRQ source ID to '2'
  KVM: x86: Don't clear PIT's IRQ line status when destroying PIT
  KVM: x86: Explicitly check for in-kernel PIC when getting ExtINT
  KVM: Move x86-only tracepoints to x86's trace.h
  KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling in-kernel I/O APIC
  KVM: Squash two CONFIG_HAVE_KVM_IRQCHIP #ifdefs into one
  KVM: selftests: Fall back to split IRQ chip if full in-kernel chip is
    unsupported
  KVM: x86: Move IRQ mask notifier infrastructure to I/O APIC emulation
  KVM: x86: Fold irq_comm.c into irq.c

 arch/x86/include/asm/kvm_host.h            |  22 +-
 arch/x86/kvm/Kconfig                       |  10 +
 arch/x86/kvm/Makefile                      |   7 +-
 arch/x86/kvm/hyperv.c                      |  10 +-
 arch/x86/kvm/hyperv.h                      |   3 +-
 arch/x86/kvm/i8254.c                       |  11 +-
 arch/x86/kvm/i8254.h                       |   3 +-
 arch/x86/kvm/i8259.c                       |  17 +-
 arch/x86/kvm/ioapic.c                      |  87 +++-
 arch/x86/kvm/ioapic.h                      |  22 +-
 arch/x86/kvm/irq.c                         | 336 ++++++++++++++-
 arch/x86/kvm/irq.h                         |   3 +-
 arch/x86/kvm/irq_comm.c                    | 469 ---------------------
 arch/x86/kvm/lapic.c                       |   7 +-
 arch/x86/kvm/trace.h                       |  80 ++++
 arch/x86/kvm/x86.c                         |  37 +-
 include/linux/kvm_host.h                   |   9 +-
 include/trace/events/kvm.h                 |  84 +---
 tools/testing/selftests/kvm/lib/kvm_util.c |  13 +-
 virt/kvm/irqchip.c                         |   2 -
 20 files changed, 577 insertions(+), 655 deletions(-)
 delete mode 100644 arch/x86/kvm/irq_comm.c


base-commit: 3f7b307757ecffc1c18ede9ee3cf9ce8101f3cc9
-- 
2.49.0.1101.gccaa498523-goog


