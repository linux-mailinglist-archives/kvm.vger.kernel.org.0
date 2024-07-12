Return-Path: <kvm+bounces-21581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6BD93028B
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10FC7282E9E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 23:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F85136E3B;
	Fri, 12 Jul 2024 23:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nI0S5qPq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E6413666F
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828630; cv=none; b=NKuGyI4rUk5XKp79eluuG5YAAx2AuF9s/+2D1XfPF0Aqd4y+NZ7Y5DbZqRgi7OeFsNfDs3+Nj8NdakpsrBa+cR5H2vnVR1zxFist2yWpvJca+zRpK7A4+ODlW5XjqrEQiALmWfvbb93cOtVRsG7oz8R3MR3iwmWWcUU0H9aU3nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828630; c=relaxed/simple;
	bh=cmYpoF0xYtRa45+mNJctQpa5TnUyfzcuSPug3wlqcvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a8CP1QmrZZ3BITiaxBKa8uCaMrW9egvzgAeaTWtE/RFgGhUS7+eIPYvczDE0HAmP5HWTxP9CTC5q6qOnnpSpsJPEONrUGusLpUg9UuJWL0noJJuTNGyaIa/e9Wg8yr4VmimTFDe4E0U+362ETSwIl5KptJ6lyObRxh380kbjWv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nI0S5qPq; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-78296514ec8so2529124a12.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720828628; x=1721433428; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cEJgbg4CCyF3MHRbU7NKkCa3p/p2CwTRx4NUeR5d5MU=;
        b=nI0S5qPqXyWn+bpGyrqMWREykxGdyeDrXoNxsNXwxPyTCwPpH6aHpZx47VRSWGjNc4
         CsYKSWfFIMpQLvfwo7TCkvWEwxTcqXxVYutLf2ndkLmK5+gnXeiaf8jurvhD3bnmpNh0
         yQB7fldSWsXwLc5IVriByka43LONM8bELblvpIwGyx6nOCt99Ikm3XyDYGj4pmC8D83H
         pyqYBWQTly18FgZBa20asc821oAVWV4XTHc/kHlR5240KfEEQrP3n18pPRHK+Qmw0jm8
         TTnhODD/us71EVGNRDtcca781Q16m1fh8A9rJ4APP/T5I4iygHcUwqiPH7n6V9dph9vd
         cNPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720828628; x=1721433428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEJgbg4CCyF3MHRbU7NKkCa3p/p2CwTRx4NUeR5d5MU=;
        b=fJodSHC3iosyQC9tO64oPAlyboLeL6/MTCzxfhjI9+ayjBFx4iXF0qD5k3DZddeSFv
         z3KKPe3jv3CtPBnrQdIPAkr8jxNKTHeJAqyUV+6BXMkkvXDGZPNTuF7Mp9/GWGK+iTMi
         ZSNB7MU2nTGMN6tB9hb3+3GEJWGRLvIg+VQJgDvgdN958HWF7etQ9oWW/Oo2kVR2rQRA
         GvShZC0QoS3pj+L3B05A+ENUOEJWjPi101RzGGkJX/NqAjzdnHcktTqqc201Iki08UVh
         fsj8ZCiDqE34q3Rm2exL06IYn//SonnfBbpVmFfggBlqYPPVqiAXdAZjUtARImTZbiF/
         J/WQ==
X-Gm-Message-State: AOJu0YxRFgxzJ71VRUFYU9w6JLW1STCGzauB1LOP4Gn3ZQ3u29c2VY+S
	WCVTnpxVcRExrIDhiHZnIBve39NMotMAmvlUj11aHRIzitjawfTd1zq4NfS8422xdZiIvrF6LQI
	bIw==
X-Google-Smtp-Source: AGHT+IE44FUTD83Jw9iMDulJjoUXdj5GyyDysDeGFbMVUyY7slvdCxnzhrrWkbKDhI9T6wEny1aIsP0J8VA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d396:b0:2c9:5ca5:4d20 with SMTP id
 98e67ed59e1d1-2cac4aec7e1mr45868a91.0.1720828628003; Fri, 12 Jul 2024
 16:57:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 16:56:52 -0700
In-Reply-To: <20240712235701.1458888-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712235701.1458888-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712235701.1458888-3-seanjc@google.com>
Subject: [GIT PULL] KVM: Generic changes for 6.11
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Might be worth peeking at the vcpu->wants_to_run vs. preemption change, to make
sure that it aligns with QEMU's views on live migration and steal time.  Ditto
for the vCPU ID change from Mathias (though if QEMU runs afoul of that one...).

The following changes since commit c3f38fa61af77b49866b006939479069cd451173:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.11

for you to fetch changes up to 25bc6af60f6121071ab4aa924a24cf6011125614:

  KVM: Add missing MODULE_DESCRIPTION() (2024-06-28 08:51:41 -0700)

----------------------------------------------------------------
KVM generic changes for 6.11

 - Enable halt poll shrinking by default, as Intel found it to be a clear win.

 - Setup empty IRQ routing when creating a VM to avoid having to synchronize
   SRCU when creating a split IRQCHIP on x86.

 - Rework the sched_in/out() paths to replace kvm_arch_sched_in() with a flag
   that arch code can use for hooking both sched_in() and sched_out().

 - Take the vCPU @id as an "unsigned long" instead of "u32" to avoid
   truncating a bogus value from userspace, e.g. to help userspace detect bugs.

 - Mark a vCPU as preempted if and only if it's scheduled out while in the
   KVM_RUN loop, e.g. to avoid marking it preempted and thus writing guest
   memory when retrieving guest state during live migration blackout.

 - A few minor cleanups

----------------------------------------------------------------
Borislav Petkov (1):
      KVM: Unexport kvm_debugfs_dir

Dan Carpenter (1):
      KVM: Fix a goof where kvm_create_vm() returns 0 instead of -ENOMEM

David Matlack (3):
      KVM: Introduce vcpu->wants_to_run
      KVM: Ensure new code that references immediate_exit gets extra scrutiny
      KVM: Mark a vCPU as preempted/ready iff it's scheduled out while running

Jeff Johnson (1):
      KVM: Add missing MODULE_DESCRIPTION()

Julian Stecklina (1):
      KVM: fix documentation rendering for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM

Mathias Krause (4):
      KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
      KVM: x86: Limit check IDs for KVM_SET_BOOT_CPU_ID
      KVM: selftests: Test max vCPU IDs corner cases
      KVM: selftests: Test vCPU boot IDs above 2^32 and MAX_VCPU_ID

Parshuram Sangle (2):
      KVM: Enable halt polling shrink parameter by default
      KVM: Update halt polling documentation to note that KVM has 4 module params

Sean Christopherson (8):
      Revert "KVM: async_pf: avoid recursive flushing of work items"
      KVM: Add a flag to track if a loaded vCPU is scheduled out
      KVM: VMX: Move PLE grow/shrink helpers above vmx_vcpu_load()
      KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
      KVM: Delete the now unused kvm_arch_sched_in()
      KVM: x86: Unconditionally set l1tf_flush_l1d during vCPU load
      KVM: x86: Drop now-superflous setting of l1tf_flush_l1d in vcpu_run()
      KVM: x86: Prevent excluding the BSP on setting max_vcpu_ids

Yi Wang (3):
      KVM: Setup empty IRQ routing when creating a VM
      KVM: x86: Don't re-setup empty IRQ routing when KVM_CAP_SPLIT_IRQCHIP
      KVM: s390: Don't re-setup dummy routing when KVM_CREATE_IRQCHIP

 Documentation/virt/kvm/api.rst                     |  8 +--
 Documentation/virt/kvm/halt-polling.rst            | 12 ++--
 arch/arm64/include/asm/kvm_host.h                  |  1 -
 arch/arm64/kvm/arm.c                               |  2 +-
 arch/loongarch/include/asm/kvm_host.h              |  1 -
 arch/loongarch/kvm/vcpu.c                          |  2 +-
 arch/mips/include/asm/kvm_host.h                   |  1 -
 arch/mips/kvm/mips.c                               |  2 +-
 arch/powerpc/include/asm/kvm_host.h                |  1 -
 arch/powerpc/kvm/powerpc.c                         |  2 +-
 arch/riscv/include/asm/kvm_host.h                  |  1 -
 arch/riscv/kvm/vcpu.c                              |  2 +-
 arch/s390/include/asm/kvm_host.h                   |  1 -
 arch/s390/kvm/kvm-s390.c                           | 11 +--
 arch/x86/include/asm/kvm-x86-ops.h                 |  1 -
 arch/x86/include/asm/kvm_host.h                    |  2 -
 arch/x86/kvm/irq.h                                 |  1 -
 arch/x86/kvm/irq_comm.c                            |  7 --
 arch/x86/kvm/pmu.c                                 |  6 +-
 arch/x86/kvm/svm/svm.c                             | 11 +--
 arch/x86/kvm/vmx/main.c                            |  2 -
 arch/x86/kvm/vmx/vmx.c                             | 80 +++++++++++-----------
 arch/x86/kvm/vmx/x86_ops.h                         |  1 -
 arch/x86/kvm/x86.c                                 | 36 +++++-----
 include/linux/kvm_host.h                           | 12 ++--
 include/uapi/linux/kvm.h                           | 15 +++-
 .../selftests/kvm/x86_64/max_vcpuid_cap_test.c     | 22 +++++-
 .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 16 +++++
 virt/kvm/async_pf.c                                | 13 +---
 virt/kvm/irqchip.c                                 | 24 +++++++
 virt/kvm/kvm_main.c                                | 46 +++++++++----
 31 files changed, 196 insertions(+), 146 deletions(-)

