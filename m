Return-Path: <kvm+bounces-53485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8703B1267A
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE1901CC4C25
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC117262FC1;
	Fri, 25 Jul 2025 22:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CyqQI3Db"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D5B2609E3
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481248; cv=none; b=qv/vz9pkrHPv0mHxtVll90kL84/abYIQIG90z18PZUCbW8r3lQ8JJwoxRFlpQU2VU1KCbabgF81U0ncL1V+k301BT2jjY43ADAJi3w43iGyODOk4UfXhwk2Yptjrch3eo4n6scoYosNkSQRsgR7knXV61b4DqX34uXo5GkI22o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481248; c=relaxed/simple;
	bh=1HKC7FcCNLxtL4/MPAd6dv3PNDLKeNfnwe8C57W/1q8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=keLTaaakwo8g/D+RQkdF7PytW/XOrs2T+5HOvRM6pmA9/LuFMocdbgczp57C/V2EWlPi9yXm+0ouN2Joz8qrEbUs1jmfLVxGQPedwOT3w83MNlZMxwcQa1nNwGCMPmKtOF9JvocI2gOo5eDvM22NYW3aTHOrEUXLKxWFTgDDIpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CyqQI3Db; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b38d8ee46a5so2356937a12.1
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481247; x=1754086047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=npP9tVsWwpuqQ6I4xCkjIaDe22vv5i8qj9zi06g5XKA=;
        b=CyqQI3DbfqX8N5oG/YkZfrkA/XCvhEYC//W1lsPru7ghDcNHNBJQrw36d6LPGrHhMJ
         YYjF3qohNmNghK8qmlqfw+Np9UIGLvPhN5rU6qur4qtLSr+fMx3Y4YwVfJ23o+9cN59s
         HWXrd8D8+jr6yCV+zjwU0hoMRxUN9/Sb/10GY44okGQmt2LOXw6msK91a708sgsXb64C
         AqnPawSbwyuot4vMR4nUgbX8SaP59XbtxzU+EVnPYkuDF5AbkdkfrppdGEmXXN9bOJVq
         HjiFZRzr++E/1xfD6KLAbxHRDobZLTEnukYDm6BamI2UUNFndcx5D4zjTWmh9DAr6wVC
         zR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481247; x=1754086047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=npP9tVsWwpuqQ6I4xCkjIaDe22vv5i8qj9zi06g5XKA=;
        b=nHWzGpcxiUOxzXLI6gFDLiruAC6bgHBMw0DIYkYvoXnXljHLKNsPQYfWpLQIpSjZzr
         qW8CnHELmB4JF89h0P78Ugvp57PxI/NaARtcN7j9R5ylrM4v77YGjZGZ5k3IZBPvo/W9
         33K8uOmRMPO1ONj1s9pAbMq81cQZ9G3qyo5b11OhG/Kq5rO3IYYh2G4AUIFxxQ5qViY8
         HqDVNRp0V1SAA6GQBnfueqi2aQOOkNR4hbLx11AbwK51bTOjDNKNcLKI7o5tjjhEsXJ2
         yMWKrCLcrCz81VL5j0f9ssyZwzB+CI/z7a8hDkrGCm0LbGrOTN7BiA+GJncTl8aijarU
         jjEQ==
X-Gm-Message-State: AOJu0YxmXT5+3H/pamyZJY1coNJDvahWifaw0SUR0+dkNiM2AnPFRmc1
	s1smCUG5VKazugMmF/oMp0beSH7nEMS9/YqHKIJcqYk/k3yAwqt5oehH/Zpgs1mPg3KD5zd8JMQ
	AQukxyQ==
X-Google-Smtp-Source: AGHT+IFOKntl3XhJ0x5UOHZyvQOnE9vR5kykfJ91JPmkYloQ3ByNv7J2t87ttzuYPp5ag91LEzHu3xnMsWU=
X-Received: from pfay25.prod.google.com ([2002:a05:6a00:1819:b0:748:d81f:a79e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939e:b0:238:351a:f95f
 with SMTP id adf61e73a8af0-23d6e3b8bbbmr5865649637.22.1753481246762; Fri, 25
 Jul 2025 15:07:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:06 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMIO State Data mitigation changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework the MMIO Stale Data mitigation to apply to all VMs that can access host
MMIO, not just VMs that are associated with a VFIO group.

My motivation for this series is all about killing off assigned_device_count
(spoiler alert), I honestly have no idea if there are any real world setups
that are affected by this change.

You should see a trivial conflict with Linus' tree (commit f9af88a3d384
("x86/bugs: Rename MDS machinery to something more generic")).  As usual,
Stephen's resolution[*] is correct:

diff --cc arch/x86/kvm/vmx/vmx.c
index 191a9ed0da22,65949882afa9..47019c9af671
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@@ -7290,8 -7210,8 +7210,8 @@@ static noinstr void vmx_vcpu_enter_exit
  	if (static_branch_unlikely(&vmx_l1d_should_flush))
  		vmx_l1d_flush(vcpu);
  	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
- 		 kvm_arch_has_assigned_device(vcpu->kvm))
+ 		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
 -		mds_clear_cpu_buffers();
 +		x86_clear_cpu_buffers();
  
  	vmx_disable_fb_clear(vmx);

[*] https://lore.kernel.org/all/20250709171115.7556c98c@canb.auug.org.au

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmio-6.17

for you to fetch changes up to 83ebe715748314331f9639de2220d02debfe926d:

  KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps MMIO into the guest (2025-06-25 08:42:51 -0700)

----------------------------------------------------------------
KVM MMIO Stale Data mitigation cleanup for 6.17

Rework KVM's mitigation for the MMIO State Data vulnerability to track
whether or not a vCPU has access to (host) MMIO based on the MMU that will be
used when running in the guest.  The current approach doesn't actually detect
whether or not a guest has access to MMIO, and is prone to false negatives (and
to a lesser extent, false positives), as KVM_DEV_VFIO_FILE_ADD is optional, and
obviously only covers VFIO devices.

----------------------------------------------------------------
Sean Christopherson (3):
      KVM: x86: Avoid calling kvm_is_mmio_pfn() when kvm_x86_ops.get_mt_mask is NULL
      KVM: x86/mmu: Locally cache whether a PFN is host MMIO when making a SPTE
      KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps MMIO into the guest

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu_internal.h |  3 +++
 arch/x86/kvm/mmu/spte.c         | 43 ++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/spte.h         | 10 ++++++++++
 arch/x86/kvm/vmx/run_flags.h    | 10 ++++++----
 arch/x86/kvm/vmx/vmx.c          |  8 +++++++-
 6 files changed, 67 insertions(+), 8 deletions(-)

