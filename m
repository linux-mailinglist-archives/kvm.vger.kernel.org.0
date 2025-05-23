Return-Path: <kvm+bounces-47595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E53CAC27A6
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 18:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3657B406B5
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 16:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497BF297B77;
	Fri, 23 May 2025 16:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ts0CDJXs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ECF296FD2
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748017510; cv=none; b=Y4yfObhU6OWb0nRc6Mvpdt5ejdU1b1UrFAJvgoOyQbybPLd4JerZqIqjL4a33JNtPUo8WT+7h0jzGEY7Cakbmf4N8hu9HDfwmi/vcPg45ei8ZXb7OICtkYf3Pl8wmwaPTYLc1EpO5LISBWg53hPi1B+o9sC1+sHol7DRTVogyGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748017510; c=relaxed/simple;
	bh=qtBDG8qgqR0msl9I0i0aqAC7d9zQmMVQBkON9ryIO54=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H0HtodALbvhmXeQCJLdUpCV/Xb+vCz1v6ZuW9nhgZAxpLahrLJx0tGqP4Bhy5X0WYjkUvzScUx5Xd0FCtze+0kxMKeE5z62t/NcDNcF1TpEOcfQYM2hFH/KjgS0HJ/KhYK/7BkAL+C/1jE+eiWOPreHqV9ylob2Es7ovtr9zwzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ts0CDJXs; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e78145dc4so124553a91.2
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 09:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748017508; x=1748622308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=E18hy2hR/bREtf70IuuYVvEoWaA16T+7e9ZAWHcqTk4=;
        b=Ts0CDJXsMo6WCz8W2Ab9A4pMDclaIBblsIlT5qiVnXF+Z2eUHjlNfWNYXBjdzhQiTH
         D/LhTmu83IwqioOCkbs0NE11BqPmg3HzkKzEwmnA9BnXiSJxOIvNtjOndKtvs5QSuC9m
         vd9+WnTRt3UHgy9UEDXt1sFjr+F0bHFWH+fYlPQGAuReu8qk1rGxV/It5HyGEdo5czsz
         TYECjeQR98476oDVYC9A9TVPk+x3JcbkxLPWztdmezodDaRH/uKb5dVDLBk/eb2ZRTJA
         HJDrLUa2kyZr4H9gmAB01Lyq49Wyo97reSAmv1OEO0LMmMGadwOLm5m0uy1RsD4+Q/ja
         Cesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748017508; x=1748622308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E18hy2hR/bREtf70IuuYVvEoWaA16T+7e9ZAWHcqTk4=;
        b=t4tI+jU6kOA6zELe6aQQYHzfiY/j7f09PAckOFmsgLQ3IvinzZ0txo1v8cakm2VE+V
         VUKrPKrdKHtA0Zlh2fjGSZrA1El8R4JbP/5LHoMsXor2cYPOtHsSq/5MdOJGemSc747Z
         CUBHa2uHJYTz4Qrqj9+hekTX5B8QiE3bbTFatIywpTZtIK+2NgM5Ee7PDNdI3KZ9dfez
         2noA+Lo76/AHQOVrXWSMo3m5W2TXDw2atXxQ/epSy1CVjqJffLVTp1HjuKx/W3MUSHsY
         1bGyZ3Sp/5HGT8EKi5fgkjI/o5Mgn4dzgDvxSOQD8X1kI/J1CLSZ8y7za+9pf2LMLqhA
         hb3Q==
X-Gm-Message-State: AOJu0YyEfmJVdqmbOrp/i+6sTQQqjHVz2cCstg17ixs18ajiDwDPMfAX
	T5n+7fAHu6XaZgsxpfGuf1834MUnOsSMX7EQsgjNlqN0nxD+MlUbkwGTmSCJT+1RzCkAuOToC1I
	5avQR8w==
X-Google-Smtp-Source: AGHT+IGM9NJRIZkNgtncVE3+hJcyUu0XSkapc2uN4wbMaYep+r5c95ikG+rWCDTpFec7/mh1CZyZjxSrYZM=
X-Received: from pjl6.prod.google.com ([2002:a17:90b:2f86:b0:30a:7d22:be7b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:2fe:a614:5cf7
 with SMTP id 98e67ed59e1d1-30e7d501d2bmr41551513a91.3.1748017508210; Fri, 23
 May 2025 09:25:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 May 2025 09:24:58 -0700
In-Reply-To: <20250523162504.3281680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523162504.3281680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523162504.3281680-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.16
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Nothing major, the most interesting change is an optimization to rescan I/O
APIC routes after an EOI VM-Exit when an interception of the EOI was necessary
only because of an in-flight IRQ from the previous routing.

The following changes since commit 45eb29140e68ffe8e93a5471006858a018480a45:

  Merge branch 'kvm-fixes-6.15-rc4' into HEAD (2025-04-24 13:39:34 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.16

for you to fetch changes up to 37d8bad41d2b0a7d269affb85979a8e4114e177a:

  KVM: Remove obsolete comment about locking for kvm_io_bus_read/write (2025-05-08 07:16:15 -0700)

----------------------------------------------------------------
KVM x86 misc changes for 6.16:

 - Unify virtualization of IBRS on nested VM-Exit, and cross-vCPU IBPB, between
   SVM and VMX.

 - Advertise support to userspace for WRMSRNS and PREFETCHI.

 - Rescan I/O APIC routes after handling EOI that needed to be intercepted due
   to the old/previous routing, but not the new/current routing.

 - Add a module param to control and enumerate support for device posted
   interrupts.

 - Misc cleanups.

----------------------------------------------------------------
Babu Moger (1):
      KVM: x86: Advertise support for AMD's PREFETCHI

Borislav Petkov (1):
      KVM: x86: Sort CPUID_8000_0021_EAX leaf bits properly

Dan Carpenter (1):
      KVM: x86: clean up a return

Li RongQing (1):
      KVM: Remove obsolete comment about locking for kvm_io_bus_read/write

Sean Christopherson (7):
      x86/msr: Rename the WRMSRNS opcode macro to ASM_WRMSRNS (for KVM)
      KVM: x86: Advertise support for WRMSRNS
      KVM: x86: Isolate edge vs. level check in userspace I/O APIC route scanning
      KVM: x86: Add a helper to deduplicate I/O APIC EOI interception logic
      KVM: VMX: Don't send UNBLOCK when starting device assignment without APICv
      KVM: x86: Add module param to control and enumerate device posted IRQs
      KVM: x86: Unify cross-vCPU IBPB

Yosry Ahmed (4):
      x86/cpufeatures: Define X86_FEATURE_AMD_IBRS_SAME_MODE
      KVM: x86: Propagate AMD's IbrsSameMode to the guest
      KVM: x86: Generalize IBRS virtualization on emulated VM-exit
      KVM: SVM: Clear current_vmcb during vCPU free for all *possible* CPUs

weizijie (1):
      KVM: x86: Rescan I/O APIC routes after EOI interception for old routing

 arch/x86/include/asm/cpufeatures.h       |  2 ++
 arch/x86/include/asm/kvm_host.h          |  4 +++-
 arch/x86/include/asm/msr.h               |  4 ++--
 arch/x86/kvm/cpuid.c                     |  8 ++++++-
 arch/x86/kvm/ioapic.c                    |  7 ++----
 arch/x86/kvm/ioapic.h                    |  2 ++
 arch/x86/kvm/irq_comm.c                  | 37 +++++++++++++++++++++++++++-----
 arch/x86/kvm/lapic.c                     |  8 +++++++
 arch/x86/kvm/svm/nested.c                |  2 ++
 arch/x86/kvm/svm/svm.c                   | 27 ++---------------------
 arch/x86/kvm/svm/svm.h                   |  2 --
 arch/x86/kvm/vmx/nested.c                | 17 ++++-----------
 arch/x86/kvm/vmx/posted_intr.c           |  7 +++---
 arch/x86/kvm/vmx/vmx.c                   | 18 ++++------------
 arch/x86/kvm/vmx/vmx.h                   |  3 +--
 arch/x86/kvm/x86.c                       | 29 +++++++++++++++++++++++--
 arch/x86/kvm/x86.h                       | 18 ++++++++++++++++
 tools/arch/x86/include/asm/cpufeatures.h |  1 +
 virt/kvm/kvm_main.c                      |  3 ---
 19 files changed, 120 insertions(+), 79 deletions(-)

