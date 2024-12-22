Return-Path: <kvm+bounces-34319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F559FA7D4
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:42:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D1C81885F81
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B787718FDDF;
	Sun, 22 Dec 2024 19:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAkveR+R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B7D13BC0C
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896551; cv=none; b=bMJicG2OvYVx93JSLeNIQazFmN+/iT2czMXpqFV0X2Ka0TusoO6Jz5A4HTaOPPJCNNtwDu551kv0dabJgSacmCt6CY8mEc8vFUFV1N3I7nzTJRyNZmTh+IujBlwZx/o8Cu2qp20vJIMQ83AKY3gMhsV8Tu9U9nVf5oa2K3zIMZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896551; c=relaxed/simple;
	bh=f8iDfuqIet14sZp5fvgAd8361Fbn4MrjK/pLF4niuf8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TDp+HfEx5UOF5BlennH5QQRfICNt5tYkp3HySjhxlodECejbE8YNqP0sYH0sRwo8meFg7+68ZBincO9S55uSpsev/3HzFI9ZQM0ppJjIIMj793zQi4xq3wUDzlfqXEwRdE2W2E2SHpjZi0c/m26BQdC+3rvfCLpoeA5f8kuW7LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KAkveR+R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O6b8d9MbHorREKWi3sDuGyBKBfuJguQtC2X1SibitFk=;
	b=KAkveR+RsjfOmDXwwnFJlTd4BHgrY0FUWaKnvjFoLsMcfkWV6ydIz37eJDmlJCtascYSv0
	wRtjUfxZqUqC3iWBIG+SbnFPlowFI9cYrqzw/F1u5M82845Y9D7Ua1jSXEmesdQ3lIosL0
	0x8nLzfe2/0HgMNbQsLAJ/NEAAfTIhY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-455-GuiB1y41MiKFNpAHLXrrew-1; Sun,
 22 Dec 2024 14:42:28 -0500
X-MC-Unique: GuiB1y41MiKFNpAHLXrrew-1
X-Mimecast-MFC-AGG-ID: GuiB1y41MiKFNpAHLXrrew
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A5821956086;
	Sun, 22 Dec 2024 19:42:27 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A5BE3000706;
	Sun, 22 Dec 2024 19:42:26 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.13-rc4 (or rc5)
Date: Sun, 22 Dec 2024 14:42:25 -0500
Message-ID: <20241222194225.355168-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Linus,

The following changes since commit 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8:

  Linux 6.13-rc3 (2024-12-15 15:58:23 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 8afa5b10af9d748b055a43949f819d9991d63938:

  Merge tag 'kvm-x86-fixes-6.13-rcN' of https://github.com/kvm-x86/linux into HEAD (2024-12-22 12:07:16 -0500)

----------------------------------------------------------------
KVM x86 fixes for 6.13:

- Disable AVIC on SNP-enabled systems that don't allow writes to the virtual
  APIC page, as such hosts will hit unexpected RMP #PFs in the host when
  running VMs of any flavor.

- Fix a WARN in the hypercall completion path due to KVM trying to determine
  if a guest with protected register state is in 64-bit mode (KVM's ABI is to
  assume such guests only make hypercalls in 64-bit mode).

- Allow the guest to write to supported bits in MSR_AMD64_DE_CFG to fix a
  regression with Windows guests, and because KVM's read-only behavior appears
  to be entirely made up.

- Treat TDP MMU faults as spurious if the faulting access is allowed given the
  existing SPTE.  This fixes a benign WARN (other than the WARN itself) due to
  unexpectedly replacing a writable SPTE with a read-only SPTE.

- Emit a warning when KVM is configured with ignore_msrs=1 and also to hide the
  MSRs that the guest is looking for from the kernel logs.  ignore_msrs can
  trick guests into assuming that certain processor features are present, and
  this in turn leads to bogus bug reports.

----------------------------------------------------------------
Paolo Bonzini (2):
      KVM: x86: let it be known that ignore_msrs is a bad idea
      Merge tag 'kvm-x86-fixes-6.13-rcN' of https://github.com/kvm-x86/linux into HEAD

Sean Christopherson (3):
      KVM: x86: Play nice with protected guests in complete_hypercall_exit()
      KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
      KVM: x86/mmu: Treat TDP MMU faults as spurious if access is already allowed

Suravee Suthikulpanit (1):
      KVM: SVM: Disable AVIC on SNP-enabled system without HvInUseWrAllowed feature

Wolfram Sang (1):
      KVM: VMX: don't include '<linux/find.h>' directly

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/mmu/mmu.c             | 12 ------------
 arch/x86/kvm/mmu/spte.h            | 17 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c         |  5 +++++
 arch/x86/kvm/svm/avic.c            |  6 ++++++
 arch/x86/kvm/svm/svm.c             |  9 ---------
 arch/x86/kvm/vmx/posted_intr.h     |  2 +-
 arch/x86/kvm/x86.c                 |  9 ++++++++-
 8 files changed, 38 insertions(+), 23 deletions(-)


