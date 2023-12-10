Return-Path: <kvm+bounces-4002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E8580BA3E
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 12:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF9601C2090E
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 11:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326AB8494;
	Sun, 10 Dec 2023 11:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QL5BVqUv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4829510A
	for <kvm@vger.kernel.org>; Sun, 10 Dec 2023 03:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702206066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vcMTkBmsMSR+TJtwz30pl082Vy2SUA+d1o6O16UtCUc=;
	b=QL5BVqUvW6SPtJMygPSG5ZLZQ67zRlcDB9ZaQLAbIPozkmL8eRH0ZUuXOx/CPQosWJE6Wh
	Ix4FS1Wr8xoKkZzc2GGxQ2Qzul+WGLPNnZbb8OAQVzEcq0ZMvBNxCt+s9IcDobO73ZNg3a
	0dX36PqulyxNVuQECKu7Fa+JEEB3aYE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-15-bbEOZewPMF6L0_gJPRBFDQ-1; Sun,
 10 Dec 2023 06:01:02 -0500
X-MC-Unique: bbEOZewPMF6L0_gJPRBFDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81AE529AB3E6;
	Sun, 10 Dec 2023 11:01:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64F1CC157C0;
	Sun, 10 Dec 2023 11:01:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.7-rc5
Date: Sun, 10 Dec 2023 06:01:01 -0500
Message-Id: <20231210110101.2435586-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Linus,

The following changes since commit 33cc938e65a98f1d29d0a18403dbbee050dcad9a:

  Linux 6.7-rc4 (2023-12-03 18:52:56 +0900)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 4cdf351d3630a640ab6a05721ef055b9df62277f:

  KVM: SVM: Update EFER software model on CR0 trap for SEV-ES (2023-12-08 13:37:05 -0500)

----------------------------------------------------------------
Generic:

* Set .owner for various KVM file_operations so that files refcount the
  KVM module until KVM is done executing _all_ code, including the last
  few instructions of kvm_put_kvm().  And then revert the misguided
  attempt to rely on "struct kvm" refcounts to pin KVM-the-module.

ARM:

* Do not redo the mapping of vLPIs, if they have already been mapped

s390:

* Do not leave bits behind in PTEs

* Properly catch page invalidations that affect the prefix of a nested
  guest

x86:

* When checking if a _running_ vCPU is "in-kernel", i.e. running at CPL0,
  get the CPL directly instead of relying on preempted_in_kernel (which
  is valid if and only if the vCPU was preempted, i.e. NOT running).

* Fix a benign "return void" that was recently introduced.

Selftests:

* Makefile tweak for dependency generation

* -Wformat fix

----------------------------------------------------------------
Claudio Imbrenda (2):
      KVM: s390: vsie: fix wrong VIR 37 when MSO is used
      KVM: s390/mm: Properly reset no-dat

David Woodhouse (1):
      KVM: selftests: add -MP to CFLAGS

Kunkun Jiang (1):
      KVM: arm64: GICv4: Do not perform a map to a mapped vLPI

Like Xu (2):
      KVM: x86: Get CPL directly when checking if loaded vCPU is in kernel mode
      KVM: x86: Remove 'return void' expression for 'void function'

Paolo Bonzini (3):
      Merge tag 'kvmarm-fixes-6.7-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master
      Merge tag 'kvm-s390-master-6.7-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master
      Merge tag 'kvm-x86-fixes-6.7-rcN' of https://github.com/kvm-x86/linux into kvm-master

Sean Christopherson (3):
      KVM: Set file_operations.owner appropriately for all such structures
      Revert "KVM: Prevent module exit until all VMs are freed"
      KVM: SVM: Update EFER software model on CR0 trap for SEV-ES

angquan yu (1):
      KVM: selftests: Actually print out magic token in NX hugepages skip message

 arch/arm64/kvm/vgic/vgic-v4.c                          |  4 ++++
 arch/s390/kvm/vsie.c                                   |  4 ----
 arch/s390/mm/pgtable.c                                 |  2 +-
 arch/x86/kvm/debugfs.c                                 |  1 +
 arch/x86/kvm/svm/svm.c                                 |  8 +++++---
 arch/x86/kvm/x86.c                                     |  9 ++++++---
 tools/testing/selftests/kvm/Makefile                   |  2 +-
 .../testing/selftests/kvm/x86_64/nx_huge_pages_test.c  |  2 +-
 virt/kvm/kvm_main.c                                    | 18 ++++++++----------
 9 files changed, 27 insertions(+), 23 deletions(-)


