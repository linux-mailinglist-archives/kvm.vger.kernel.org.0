Return-Path: <kvm+bounces-53634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E3FB14D0F
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 13:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1062543F97
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06ED28DB78;
	Tue, 29 Jul 2025 11:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="zMVcsQ+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14342287244
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 11:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753788875; cv=none; b=PahpTuIwEJPuVBDde4Jr7RTcOOdOFhGSAag33iiBtNYiD27+U62nUyN9teY0XQl+FmHEi5TV27K+f9PCvlyMFOY6CiJMFpEy90rqeofauD2EkHZoRUkS2WhAR6XxaHSxakrb8FEQhsoFZH1+lKMZAppb0iXYywECh5h6ZSp++Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753788875; c=relaxed/simple;
	bh=4bTmZMAxGYLZsOLEqyqLPYL1rn8WS8uLfgweifnVPPg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=k7eoiL19GlZAs7m8iXE0Wc+wh8H7SBOj4qSej1N+PFQfSvrqK7rL65xPZ+Evpe4Nxx9k55FeZWgm/cpFXUfNTDOkyWEoQxjuQ7kedTW3xAn/4jiZeq35pHJ2y+V9G8NYSgY0IOIkW/XXN9++iuCE6RYmNRQAm9EUtMNROGgraWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=zMVcsQ+S; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3e3f0287842so2192245ab.3
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 04:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1753788873; x=1754393673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=daOYCtHcKqTfbTy+/LedurRo3q87yoM5HXRvS7LIiGg=;
        b=zMVcsQ+SPYhIMGYFUsuBVOFd0op5weSd8d/cyGrDXCC5TMdZGWsKwzCgHPeHSJ3s8f
         KmarqTucKfhVE3S0gQXK/COeh44U0SvIwhQX7D4rEGguBlvS6j5SUeECtzjFrUvRjqOY
         8wAW5aPP/K4EADGQ+EvVfJ7Xr1/+OdJ1dAbkv1lwkRlExIfcApsS81fFVHrR045tu11e
         DjS1gNKLfanEptvq6DaiRUt1NWf4v8hozSW4l3Cx7e7WWGdYf4WzPaBoJnF0ZZPhi1zi
         ycA41YB2CeZC2I9GDW8Zj/EX3d/OiVXyndaq6S4CSWkT6m2Vq5rpuO2ZIrVKh+Mh6c65
         JIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753788873; x=1754393673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=daOYCtHcKqTfbTy+/LedurRo3q87yoM5HXRvS7LIiGg=;
        b=TpGx/h7eMjCgQ4Hg9upGVWzsZbi5IkZ2RGTT7HLYht7K9Gt2zkbv0/rlKZdF4iiKxW
         2gyZMfBxQRc0Du6jES93QGHV9Nlx0T36bzkzciaOocYnI7lardO2zwengUoia4cGjXoz
         6Xi7jnAYzJLDoB+5UspCwbclaUZwSvt7yXKR6lVMY9QwHSmxQodUflfCFRLhIISuO8ki
         fPeE7uN7TM/dR6sdorN59XKLW3+saXrETHFLou9GWJ1v9ttYSioqfOOTPafz5qAaG7qe
         eL7XGBEwKGtB9JYsL6I9a3cU81RRGgyv0ny1p3luaLy0FQjYmPg9co/MRpzluORZ/xZ4
         3JXA==
X-Forwarded-Encrypted: i=1; AJvYcCWRdqY9hFbYJ61IqMupoEqBS97evaNTjk0vHg44XXmm7bYwilqtwUwH/qrjj2ita7PZeck=@vger.kernel.org
X-Gm-Message-State: AOJu0YysLV9HXAnD8sCeRw9OPJCD6aM6TY3S+hFCld9vg0PAv5wpHMmt
	lUIWS4Vqdh58ax0Yc+yTWiDPz2l2Jyfi1+E7h7gvjxCEH36CMRt0ckGCvQEHgkfHAIRpYzu7fMm
	UyIz1CV6gBLjQx51GpzYLHzNZR7FmfsciobfN5tmRCQ==
X-Gm-Gg: ASbGncsjhqQhXOiXi5goQ6+sW4iPncvfc3VKbdEqVRV2FK/cdvFz+DQ0sTzQ1SKAZui
	lSNdyYgziP+Tb/yYgFbxCeXTtfgXIfu0rFza5jWUZkJphwvMTOLJcAJo9Z8VrBm/OURncICQybB
	SJ3Uz8omxcgJdpj+Y6NwoBnh/expHooBhKglSUxIU78nlByUR+5qbv1915lF9rBWQgQNxq595ek
	VdFReNf
X-Google-Smtp-Source: AGHT+IH917iBY708672C0730m2YYQWRgPPgotTyiQjMZA+uT5bjdUy+2BAMZX5F3xAV3M5Bh9YYEvBdXL3KqtNWqFkA=
X-Received: by 2002:a05:6e02:310d:b0:3e0:4f66:310a with SMTP id
 e9e14a558f8ab-3e3c52c5597mr251835775ab.16.1753788873090; Tue, 29 Jul 2025
 04:34:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Tue, 29 Jul 2025 17:04:22 +0530
X-Gm-Features: Ac12FXwcgbzb8N18xeNkH61ZYMQ1LhG1RslkelEOomjsJCdwTCoc3-pvkEBepOY
Message-ID: <CAAhSdy1084USuM+k9T-AP7X_=s7x+WFv++U0PkjVojbPbjRCrw@mail.gmail.com>
Subject: [GIT PULL v2] KVM/riscv changes for 6.17
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

We have the following KVM RISC-V changes for 6.17:
1) Enabled ring-based dirty memory tracking
2) Improved "perf kvm stat" to report interrupt events
3) Delegate illegal instruction trap to VS-mode
4) MMU related improvements for KVM RISC-V for the
    upcoming nested virtualization support

Please pull.

Regards,
Anup

The following changes since commit 4cec89db80ba81fa4524c6449c0494b8ae08eeb0=
:

  RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
(2025-07-11 18:33:27 +0530)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.17-2

for you to fetch changes up to 07a289a031404ec583c01d8e87680d434fc62c1f:

  RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
(2025-07-28 22:28:31 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.17

- Enabled ring-based dirty memory tracking
- Improved perf kvm stat to report interrupt events
- Delegate illegal instruction trap to VS-mode
- MMU related improvements for KVM RISC-V for upcoming
  nested virtualization

----------------------------------------------------------------
Anup Patel (12):
      RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
      RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
      RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
      RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with KVM_REQ_TLB_FL=
USH
      RISC-V: KVM: Don't flush TLB when PTE is unchanged
      RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
      RISC-V: KVM: Use ncsr_xyz() in kvm_riscv_vcpu_trap_redirect()
      RISC-V: KVM: Factor-out MMU related declarations into separate header=
s
      RISC-V: KVM: Introduce struct kvm_gstage_mapping
      RISC-V: KVM: Add vmid field to struct kvm_riscv_hfence
      RISC-V: KVM: Factor-out g-stage page table management
      RISC-V: KVM: Pass VMID as parameter to kvm_riscv_hfence_xyz() APIs

Cl=C3=A9ment L=C3=A9ger (2):
      RISC-V: KVM: add SBI extension init()/deinit() functions
      RISC-V: KVM: add SBI extension reset callback

Quan Zhou (4):
      RISC-V: KVM: Enable ring-based dirty memory tracking
      RISC-V: perf/kvm: Add reporting of interrupt events
      RISC-V: KVM: Use find_vma_intersection() to search for intersecting V=
MAs
      RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()

Samuel Holland (1):
      RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap

Xu Lu (1):
      RISC-V: KVM: Delegate illegal instruction fault to VS mode

 Documentation/virt/kvm/api.rst                     |   2 +-
 arch/riscv/include/asm/kvm_aia.h                   |   2 +-
 arch/riscv/include/asm/kvm_gstage.h                |  72 +++
 arch/riscv/include/asm/kvm_host.h                  | 105 +----
 arch/riscv/include/asm/kvm_mmu.h                   |  21 +
 arch/riscv/include/asm/kvm_tlb.h                   |  84 ++++
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  12 +
 arch/riscv/include/asm/kvm_vmid.h                  |  27 ++
 arch/riscv/include/uapi/asm/kvm.h                  |   1 +
 arch/riscv/kvm/Kconfig                             |   1 +
 arch/riscv/kvm/Makefile                            |   1 +
 arch/riscv/kvm/aia_device.c                        |   6 +-
 arch/riscv/kvm/aia_imsic.c                         |  12 +-
 arch/riscv/kvm/gstage.c                            | 338 ++++++++++++++
 arch/riscv/kvm/main.c                              |   3 +-
 arch/riscv/kvm/mmu.c                               | 509 +++++------------=
----
 arch/riscv/kvm/tlb.c                               | 110 ++---
 arch/riscv/kvm/vcpu.c                              |  48 +-
 arch/riscv/kvm/vcpu_exit.c                         |  20 +-
 arch/riscv/kvm/vcpu_onereg.c                       |  83 ++--
 arch/riscv/kvm/vcpu_sbi.c                          |  49 ++
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  17 +-
 arch/riscv/kvm/vcpu_sbi_sta.c                      |   3 +-
 arch/riscv/kvm/vcpu_sbi_v01.c                      |  25 +-
 arch/riscv/kvm/vm.c                                |   7 +-
 arch/riscv/kvm/vmid.c                              |  25 +
 tools/perf/arch/riscv/util/kvm-stat.c              |   6 +-
 tools/perf/arch/riscv/util/riscv_exception_types.h |  35 --
 tools/perf/arch/riscv/util/riscv_trap_types.h      |  57 +++
 29 files changed, 1000 insertions(+), 681 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_gstage.h
 create mode 100644 arch/riscv/include/asm/kvm_mmu.h
 create mode 100644 arch/riscv/include/asm/kvm_tlb.h
 create mode 100644 arch/riscv/include/asm/kvm_vmid.h
 create mode 100644 arch/riscv/kvm/gstage.c
 delete mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
 create mode 100644 tools/perf/arch/riscv/util/riscv_trap_types.h

