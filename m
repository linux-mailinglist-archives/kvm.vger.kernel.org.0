Return-Path: <kvm+bounces-52899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05409B0A69E
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B9635A26BC
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259771ACEDD;
	Fri, 18 Jul 2025 14:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IM/njrcy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B25F4503B
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752850234; cv=none; b=Q0M+5ZUypdhAoKojhKjKAqGzs8x0SxdWj7zVjG78sZThwGR4vgOqE36jXlTilbJkGjWn6aRCejmN/FjmfkuUhfymGoOFUzaL4fgLRmWdfvWQT71CKwWN1HXGDEq/s/UEOshZtGcAbJ87SrEnXeKzsr5mb/uU/VFz7+NhtvqTQNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752850234; c=relaxed/simple;
	bh=mQj/fZKUb5zwAXiAFE4TdP7dkjioGEkEXr0GDMohAC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EEN3Z65lPZYRoUx3HmIEHY8ruPtQP5GIxLsGfpXFuBMG1cytTIdwMQ2Tn4FjWdInkc3wcMBem0/QE7sTt4A3WjM2Kufutxnr/b8j79kuIzwarYpg6Qb7gixninf5NXx1wqYn9nCPosq/eopg1Yw0OjQ7uxPbJwVy14g7QGgVr3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IM/njrcy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752850231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DXwgiGPomWe8gRzJNNZctpJkd683dk1nkWxQefrULi4=;
	b=IM/njrcybKKAuy8i4p2krNzDoBtFvZO7z0ot8Pc1+jygydygY5DLfgULSQj2aj9yvAzGMt
	eO6SHH19PZwdunz8o3VaYjCd7uTySTiX9luIg3az5Bx0PahJcJH2ITkBTC1K0fUeEMN8RE
	xnHiNWV+jbJgIY5V3XS7TGf484ahtv4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-qRacLYyLNfiJeaS1SA_NWA-1; Fri, 18 Jul 2025 10:50:29 -0400
X-MC-Unique: qRacLYyLNfiJeaS1SA_NWA-1
X-Mimecast-MFC-AGG-ID: qRacLYyLNfiJeaS1SA_NWA_1752850229
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-455eda09c57so14542945e9.2
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752850228; x=1753455028;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DXwgiGPomWe8gRzJNNZctpJkd683dk1nkWxQefrULi4=;
        b=hd40zAn5CoewIzs5v1iUrsUq5r3WoCo2me3dw9zTKhesKZ/TepA5xbeekZq1cHVLVk
         Il0MVp1SORgf5fWVw9fwF2pE6Y/ffc9i9h0POkY3s1WMaFxP9hVjDUx2aNxF2RUttLpQ
         NNoot9RQFzUX+qdFSxDeRc+3rjLkaTxuR3E6oU2tVn6EhMXOOfdHGcDEChjcGB+ePF1i
         bDbfSSmcJazhvkVxI+YiTaw4KeMDs5DxbXpVAYiCP3Ow6XeExQcRvcGuu9Srj8hfDpSF
         SQEJshxsieBZTq74jn/5xmlnnkyP8ipwb9xi8gB27azJFINOmUJE2HqTTBjzeWZtogHn
         zFXA==
X-Forwarded-Encrypted: i=1; AJvYcCVqSclV98BVHY25eF9go2hkyozeKxKVxxbjmHL3Szx5Nh5l6cgqzIdxF5tlqb6vrnsIYow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRO0jFAyRB61z2FZx/loVVY4yQfLFTbU4gkcseUUtrv2TK04tc
	S2S/PHGb+ctEEjrzpyeGQaOD3sWiIFse0yed3BkRfBJ9VT0xi1ZSjFlNl8Q1cob2JDZhdkyJhOU
	j9MiMMrMArAtrBNGrVvxMkF3j9a/QJhhEe9uMylmP7N7dbt7mn/BSQg==
X-Gm-Gg: ASbGncuS24gkgeUALFPeDC3xSmH0QfY2jWWlcgIhcHGjjUqFOhc/sd/qg1djNxd9GsT
	bJGrUNDxEao8Yz/41ZwzeDCm/Oww+OD/A2kubpad4TG5Lu9807zgoSBqahB6D90jd8PTBfy4P9b
	d9WTHjRKPgxLS0WveXwl9J3sF93GelajMhmGXA2nT9F6jTChuovKVQLgI+0UCMiYgPn58IPC0n0
	v/j/rZ2BfNOvpA1KJqC4xK1sRxsYIMLI0QqcPg+iIDfgiwIFPjoszfPgXWzN5IXSjk21z2awOi4
	/BjuVTpv612/0plJ7xQjg78+H2JND7D8EGKYAuN7uDc=
X-Received: by 2002:a05:600c:3488:b0:456:f00:4b5d with SMTP id 5b1f17b1804b1-4563a1f42c0mr37270915e9.22.1752850228474;
        Fri, 18 Jul 2025 07:50:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHn6jKUOt8K/Agi87vQ3dTaTfuJ/qV+gjxJFYc2DM2F2MFJuTiVcpqNlnEBoIqgCLAIXlB+QQ==
X-Received: by 2002:a05:600c:3488:b0:456:f00:4b5d with SMTP id 5b1f17b1804b1-4563a1f42c0mr37270725e9.22.1752850228030;
        Fri, 18 Jul 2025 07:50:28 -0700 (PDT)
Received: from [192.168.122.1] ([151.49.73.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b740285sm22700915e9.20.2025.07.18.07.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 07:50:27 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes, and documentation changes, for Linux 6.16-rc7
Date: Fri, 18 Jul 2025 16:50:26 +0200
Message-ID: <20250718145026.179015-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit 347e9f5043c89695b01e66b3ed111755afcf1911:

  Linux 6.16-rc6 (2025-07-13 14:25:58 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 4b7d440de209cb2bb83827c30107ba05884a50c7:

  Merge tag 'kvm-x86-fixes-6.16-rc7' of https://github.com/kvm-x86/linux into HEAD (2025-07-17 17:06:13 +0200)

----------------------------------------------------------------
ARM:

* Fix use of u64_replace_bits() in adjusting the guest's view of
  MDCR_EL2.HPMN

RISC-V:

* Fix an issue related to timer cleanup when exiting to user-space

* Fix a race-condition in updating interrupts enabled for the guest
  when IMSIC is hardware-virtualized

x86:

* Reject KVM_SET_TSC_KHZ for guests with a protected TSC (currently only TDX).

* Ensure struct kvm_tdx_capabilities fields that are not explicitly set by KVM
  are zeroed.

Documentation:

* Explain how KVM contributions should be made testable

* Fix a formatting goof in the TDX documentation.

----------------------------------------------------------------
Anup Patel (2):
      RISC-V: KVM: Disable vstimecmp before exiting to user-space
      RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization

Ben Horgan (1):
      KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN

Binbin Wu (1):
      Documentation: KVM: Fix unexpected unindent warning

Kai Huang (1):
      KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC protected guest

Paolo Bonzini (5):
      KVM: Documentation: minimal updates to review-checklist.rst
      KVM: Documentation: document how KVM is tested
      Merge tag 'kvmarm-fixes-6.16-6' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-fixes-6.16-2' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-x86-fixes-6.16-rc7' of https://github.com/kvm-x86/linux into HEAD

Sean Christopherson (1):
      KVM: VMX: Ensure unused kvm_tdx_capabilities fields are zeroed out

Xiaoyao Li (1):
      KVM: TDX: Don't report base TDVMCALLs

 Documentation/virt/kvm/api.rst              | 11 +++-
 Documentation/virt/kvm/review-checklist.rst | 95 ++++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c                   |  2 +-
 arch/riscv/include/asm/kvm_aia.h            |  4 +-
 arch/riscv/include/asm/kvm_host.h           |  3 +
 arch/riscv/kvm/aia.c                        | 51 +++-------------
 arch/riscv/kvm/aia_imsic.c                  | 45 ++++++++++++++
 arch/riscv/kvm/vcpu.c                       | 10 ---
 arch/riscv/kvm/vcpu_timer.c                 | 16 +++++
 arch/x86/kvm/vmx/tdx.c                      |  9 ++-
 arch/x86/kvm/x86.c                          |  4 ++
 11 files changed, 180 insertions(+), 70 deletions(-)


