Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB904468D5
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 20:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhKETYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 15:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232647AbhKETYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 15:24:09 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C280D61051;
        Fri,  5 Nov 2021 19:21:29 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mj4mF-003ig2-FT; Fri, 05 Nov 2021 19:21:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 0/5] KVM: Turn the vcpu array into an xarray
Date:   Fri,  5 Nov 2021 19:20:56 +0000
Message-Id: <20211105192101.3862492-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-mips@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, anup.patel@wdc.com, atish.patra@wdc.com, borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com, pbonzini@redhat.com, jgross@suse.com, npiggin@gmail.com, seanjc@google.com, paulus@samba.org, mpe@ellerman.id.au, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm structure is pretty large. A large portion of it is the vcpu
array, which is 4kB on x86_64 and arm64 as they deal with 512 vcpu
VMs. Of course, hardly anyone runs VMs this big, so this is often a
net waste of memory and cache locality.

A possible approach is to turn the fixed-size array into an xarray,
which results in a net code deletion after a bit of cleanup.

This series is on top of the current linux/master as it touches the
RISC-V implementation. Only tested on arm64.

Marc Zyngier (5):
  KVM: Move wiping of the kvm->vcpus array to common code
  KVM: mips: Use kvm_get_vcpu() instead of open-coded access
  KVM: s390: Use kvm_get_vcpu() instead of open-coded access
  KVM: x86: Use kvm_get_vcpu() instead of open-coded access
  KVM: Convert the kvm->vcpus array to a xarray

 arch/arm64/kvm/arm.c           | 10 +---------
 arch/mips/kvm/loongson_ipi.c   |  4 ++--
 arch/mips/kvm/mips.c           | 23 ++---------------------
 arch/powerpc/kvm/powerpc.c     | 10 +---------
 arch/riscv/kvm/vm.c            | 10 +---------
 arch/s390/kvm/kvm-s390.c       | 26 ++++++--------------------
 arch/x86/kvm/vmx/posted_intr.c |  2 +-
 arch/x86/kvm/x86.c             |  9 +--------
 include/linux/kvm_host.h       |  7 ++++---
 virt/kvm/kvm_main.c            | 33 ++++++++++++++++++++++++++-------
 10 files changed, 45 insertions(+), 89 deletions(-)

-- 
2.30.2

