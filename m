Return-Path: <kvm+bounces-26016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9828E96F892
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 17:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 553DC286D4A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 15:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E500C1D31AD;
	Fri,  6 Sep 2024 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ErVKXUnO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDF51CEAB1
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 15:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637550; cv=none; b=e+mWx8Mk5TOGM72wJwrF++9k/xDITzgbMzeTUtbwt61vJxeHEsuM1L6rsJ4mtbZHzVzprLmoE5nqUidJLMJkBxsQqeRCLF6HM6WkQELFP26ByR2/7DvkTrFXy3Wh5jAt/KbWYsRiU5jqy4C3QC7G9kUOGffFUo0gDKi9waW65es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637550; c=relaxed/simple;
	bh=1T66QnOQ5YMrzOcnt3O9CCNYqMRn16hQAV4F1GAiWxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jb1svES98FN44O7ewBVY3x8dVwv2CVW5BfK7Wuz8Xjbe+XNDPukCUY2+QtW6JxjDBQbUTURKvf8VkG+aQExJe6SQ/zSy1g/G0luH4JvFc1T1R4qRAAxJTlr1ZiXPyiYy9frcmGI1P3CxY9/m/ggG9SKvwvdEmfDYlFbOJ+uHIGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ErVKXUnO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725637547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kuEoHVN4VS1AvlIIhN1QY1SKE4hlBdJDGHFexsIgI2Y=;
	b=ErVKXUnOGslTJL8yQyRR+OFLSJe0NmxazqIiQEuBTW9e7JfAx8VxAcV3ioe1SQ1SXXPAj6
	FgH2CuD2wm9UrSSSeYM7iGvmTolD9/wnvetjrwWGBrtm/1YnxcYwdPLuWvPtvw9yttxnHn
	Ahb81/C9UofLwG3ItEY/443C8MEytCo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-xEMjjv4DNcetnWHKOb5DKg-1; Fri,
 06 Sep 2024 11:45:43 -0400
X-MC-Unique: xEMjjv4DNcetnWHKOb5DKg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF35519344FA;
	Fri,  6 Sep 2024 15:45:42 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D18D71955D48;
	Fri,  6 Sep 2024 15:45:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.11-rc7
Date: Fri,  6 Sep 2024 11:45:17 -0400
Message-ID: <20240906154517.191976-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Linus,

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 59cbd4eea48fdbc68fc17a29ad71188fea74b28b:

  KVM: Remove HIGH_RES_TIMERS dependency (2024-09-05 12:04:54 -0400)

Many small fixes that accumulated while I was on vacation...

----------------------------------------------------------------
x86:

- Fixup missed comments from the REMOVED_SPTE=>FROZEN_SPTE rename.

- Ensure a root is successfully loaded when pre-faulting SPTEs.

- Grab kvm->srcu when handling KVM_SET_VCPU_EVENTS to guard against accessing
  memslots if toggling SMM happens to force a VM-Exit.

- Emulate MSR_{FS,GS}_BASE on SVM even though interception is always disabled,
  so that KVM does the right thing if KVM's emulator encounters {RD,WR}MSR.

- Explicitly clear BUS_LOCK_DETECT from KVM's caps on AMD, as KVM doesn't yet
  virtualize BUS_LOCK_DETECT on AMD.

- Cleanup the help message for CONFIG_KVM_AMD_SEV, and call out that KVM now
  supports SEV-SNP too.

- Specialize return value of KVM_CHECK_EXTENSION(KVM_CAP_READONLY_MEM),
  based on VM type

- Remove unnecessary dependency on CONFIG_HIGH_RES_TIMERS

- Note an RCU quiescent state on guest exit.  This avoids a call to rcu_core()
  if there was a grace period request while guest was running.

----------------------------------------------------------------
Leonardo Bras (1):
      kvm: Note an RCU quiescent state on guest exit

Maxim Levitsky (1):
      KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_GS_BASE

Paolo Bonzini (1):
      Merge tag 'kvm-x86-fixes-6.11-rcN' of https://github.com/kvm-x86/linux into kvm-master

Ravi Bangoria (1):
      KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is missing

Sean Christopherson (2):
      KVM: x86/mmu: Check that root is valid/loaded when pre-faulting SPTEs
      KVM: x86: Acquire kvm->srcu when handling KVM_SET_VCPU_EVENTS

Steven Rostedt (1):
      KVM: Remove HIGH_RES_TIMERS dependency

Tom Dohrmann (1):
      KVM: x86: Only advertise KVM_CAP_READONLY_MEM when supported by VM

Vitaly Kuznetsov (1):
      KVM: SEV: Update KVM_AMD_SEV Kconfig entry and mention SEV-SNP

Yan Zhao (1):
      KVM: x86/mmu: Fixup comments missed by the REMOVED_SPTE=>FROZEN_SPTE rename

 arch/x86/kvm/Kconfig             |  7 ++++---
 arch/x86/kvm/mmu/mmu.c           |  4 +++-
 arch/x86/kvm/mmu/spte.c          |  6 +++---
 arch/x86/kvm/mmu/spte.h          |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c       |  8 ++++----
 arch/x86/kvm/svm/svm.c           | 15 +++++++++++++++
 arch/x86/kvm/x86.c               |  5 ++++-
 include/linux/context_tracking.h |  6 ++++--
 include/linux/kvm_host.h         | 10 +++++++++-
 9 files changed, 47 insertions(+), 16 deletions(-)


