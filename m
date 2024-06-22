Return-Path: <kvm+bounces-20321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D5F913266
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 08:41:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C8A41F2332D
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 06:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670B514B941;
	Sat, 22 Jun 2024 06:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GhTR/Rj5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D316F073
	for <kvm@vger.kernel.org>; Sat, 22 Jun 2024 06:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719038497; cv=none; b=apyagF2fYba/FWZbTOIhWJOES/c7//axOXTqM5dX/h8ZK+MT2U02qUvGvTa9JGQukefMFu6u/lWM5ZMHHIjcVwcjHsdS0qlbdLB5S+kZvy6RTn5vuFCivXlcD8BIeY+j6rfv5afozUjAX9NR+R2juT3zEV7jlY5T7z//7e72xW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719038497; c=relaxed/simple;
	bh=YsgUZq0JgKZpe8Fb1tTYZ526tvi63AW7OiJlEjt9lkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AUa97T5gx5vEhEPXzDU6+8RQGPTJkaaIU+GLA8RkW96zP/dwXFNU7Y++w97aazMMaFYyhMsGL39GVwmsFQ0FTmfstAEKH005pm09t6dglQCfgY6GxJQXL6b6Z4T28AgBmaagJgIJ1ddljVu6iHD4Zh+8kKLgYCMRc47d0rn6v5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GhTR/Rj5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719038494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9fjp/oT9DTpssKYT+E0cu4ifOyOy9kksnkNQv449Pmc=;
	b=GhTR/Rj5Qw3nN1U+ntqmDODfQSufaXnTb4zR/MPpe3KqlST4xwaGrf8eOEuNpZqTgz36GU
	8GGEAxjKsVpTR3y7veyzMkXzAnsckx+CC3nULIoSDvV1U352ICgujplYYZbnKSwzp8BBb1
	AtqI6h6gwx/KcXHy8sGIAsh4jRD8IpA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-Ux9tN9auNk-PplXP28EUyw-1; Sat,
 22 Jun 2024 02:41:31 -0400
X-MC-Unique: Ux9tN9auNk-PplXP28EUyw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FE521956083;
	Sat, 22 Jun 2024 06:41:30 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB2F21956089;
	Sat, 22 Jun 2024 06:41:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.10-rc5
Date: Sat, 22 Jun 2024 02:41:28 -0400
Message-ID: <20240622064128.135621-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Linus,

The following changes since commit db574f2f96d0c9a245a9e787e3d9ec288fb2b445:

  KVM: x86/mmu: Don't save mmu_invalidate_seq after checking private attr (2024-06-05 06:45:06 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e159d63e6940a2a16bb73616d8c528e93b84a6bb:

  Merge tag 'kvm-riscv-fixes-6.10-2' of https://github.com/kvm-riscv/linux into HEAD (2024-06-21 12:48:44 -0400)

----------------------------------------------------------------
ARM:

* Fix dangling references to a redistributor region if the vgic was
  prematurely destroyed.

* Properly mark FFA buffers as released, ensuring that both parties
  can make forward progress.

x86:

* Allow getting/setting MSRs for SEV-ES guests, if they're using the pre-6.9
  KVM_SEV_ES_INIT API.

* Always sync pending posted interrupts to the IRR prior to IOAPIC
  route updates, so that EOIs are intercepted properly if the old routing
  table requested that.

Generic:

* Avoid __fls(0)

* Fix reference leak on hwpoisoned page

* Fix a race in kvm_vcpu_on_spin() by ensuring loads and stores are atomic.

* Fix bug in __kvm_handle_hva_range() where KVM calls a function pointer
  that was intended to be a marker only (nothing bad happens but kind of
  a mine and also technically undefined behavior)

* Do not bother accounting allocations that are small and freed before
  getting back to userspace.

Selftests:

* Fix compilation for RISC-V.

* Fix a "shift too big" goof in the KVM_SEV_INIT2 selftest.

* Compute the max mappable gfn for KVM selftests on x86 using GuestMaxPhyAddr
  from KVM's supported CPUID (if it's available).

----------------------------------------------------------------
Alexey Dobriyan (1):
      kvm: do not account temporary allocations to kmem

Andrew Jones (1):
      KVM: selftests: Fix RISC-V compilation

Babu Moger (1):
      KVM: Stop processing *all* memslots when "null" mmu_notifier handler is found

Bibo Mao (1):
      KVM: Discard zero mask with function kvm_dirty_ring_reset

Breno Leitao (1):
      KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()

Colin Ian King (1):
      KVM: selftests: Fix shift of 32 bit unsigned int more than 32 bits

Marc Zyngier (1):
      KVM: arm64: Disassociate vcpus from redistributor region on teardown

Michael Roth (1):
      KVM: SEV-ES: Fix svm_get_msr()/svm_set_msr() for KVM_SEV_ES_INIT guests

Paolo Bonzini (4):
      virt: guest_memfd: fix reference leak on hwpoisoned page
      Merge tag 'kvmarm-fixes-6.10-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-x86-fixes-6.10-rcN' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-riscv-fixes-6.10-2' of https://github.com/kvm-riscv/linux into HEAD

Sean Christopherson (2):
      KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes
      MAINTAINERS: Drop Wanpeng Li as a Reviewer for KVM Paravirt support

Tao Su (1):
      KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits

Vincent Donnefort (1):
      KVM: arm64: FFA: Release hyp rx buffer

 MAINTAINERS                                           |  1 -
 arch/arm64/kvm/hyp/nvhe/ffa.c                         | 12 ++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c                       |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                    | 15 +++++++++++++--
 arch/arm64/kvm/vgic/vgic.h                            |  2 +-
 arch/x86/kvm/svm/svm.c                                |  4 ++--
 arch/x86/kvm/x86.c                                    |  9 ++++-----
 .../testing/selftests/kvm/include/x86_64/processor.h  |  1 +
 tools/testing/selftests/kvm/lib/riscv/ucall.c         |  1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c    | 15 +++++++++++++--
 tools/testing/selftests/kvm/riscv/ebreak_test.c       |  1 +
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c      |  1 +
 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c  |  4 ++--
 virt/kvm/dirty_ring.c                                 |  3 +++
 virt/kvm/guest_memfd.c                                |  5 +++--
 virt/kvm/kvm_main.c                                   | 19 ++++++++++---------
 16 files changed, 68 insertions(+), 27 deletions(-)


