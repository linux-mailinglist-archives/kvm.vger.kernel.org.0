Return-Path: <kvm+bounces-43661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B177CA93795
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 15:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67044920671
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 13:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B5427605B;
	Fri, 18 Apr 2025 13:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UV0CwcV7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198902749C1
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 13:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744981614; cv=none; b=GWAar20BJ2IOu8eB8hqudNshu4k/aSnwORdBiEBOoqyjrUfhALO3c4yMoE4Jn1GXQzHw9Bd3GWRkAPsKxnURfGEXgYNZFV2t3VTlqObX+mpFfyQ3Ah9X8/BeY7jVGkyi5CFe3pyQ+ggHK5+IvI/n1IaGkaIOxdJxKqmrq61FfQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744981614; c=relaxed/simple;
	bh=+I+KvP9uYO3YG2dVoUBmkm/rmZEZzRCvZpepQDHzSPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hy1Nxm+Z4CKnj2h1zU41tqIGUCNoVZ/WpEkVwdR73X1Xfgai3ir6ijGNYndNyxQO6KTB9oN7mCGZznM6Dcc2LGXaoUSNfu50HOB7kRvevD7PW+F3OU3KboXXLu+1sEfRLXMql0zClYYcnZdiRXccUn9eIPvODjvnoIERkVOVYAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UV0CwcV7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744981610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hRMJdmwVlYpR7naNlMo6wQWCTeVTLcbjg4HWD0gsERY=;
	b=UV0CwcV77MqzIBXy2Qt8WHSHwqBpMSYw8iG0HyAFI5MLyOS6lEYc77ipxZQbtm849AbLC4
	oaDV1Aij6birHiTIVIjPOHa/rtFndV+pFQVkHTet2sz0WLvSIX9IN9r6EjnjGulSQyNt10
	82oNILUb5ssW9AZY+uAVKxckIzZYHCk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-RRtyu0J4P_iFsCSR9y5LrQ-1; Fri,
 18 Apr 2025 09:06:47 -0400
X-MC-Unique: RRtyu0J4P_iFsCSR9y5LrQ-1
X-Mimecast-MFC-AGG-ID: RRtyu0J4P_iFsCSR9y5LrQ_1744981606
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B50FA195608C;
	Fri, 18 Apr 2025 13:06:45 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 113FF19560A3;
	Fri, 18 Apr 2025 13:06:44 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.15-rc3
Date: Fri, 18 Apr 2025 09:06:44 -0400
Message-ID: <20250418130644.227320-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Linus,

The following changes since commit 8ffd015db85fea3e15a77027fda6c02ced4d2444:

  Linux 6.15-rc2 (2025-04-13 11:54:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9cf353943e2a1f2904062ea0e619402790289a9b:

  KVM: x86: Do not use kvm_rip_read() unconditionally for KVM_PROFILING (2025-04-15 07:42:46 -0400)

----------------------------------------------------------------
x86:

* Bugfixes from a planned posted interrupt rework

* Do not use kvm_rip_read() unconditionally to cater for guests
  with inaccessible register state.

----------------------------------------------------------------
Adrian Hunter (2):
      KVM: x86: Do not use kvm_rip_read() unconditionally in KVM tracepoints
      KVM: x86: Do not use kvm_rip_read() unconditionally for KVM_PROFILING

Sean Christopherson (8):
      KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled
      KVM: SVM: Allocate IR data using atomic allocation
      KVM: x86: Reset IRTE to host control if *new* route isn't postable
      KVM: x86: Explicitly treat routing entry type changes as changes
      KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer
      iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE
      iommu/amd: WARN if KVM attempts to set vCPU affinity without posted intrrupts
      KVM: SVM: WARN if an invalid posted interrupt IRTE entry is added

 arch/x86/kvm/svm/avic.c        | 68 +++++++++++++++++++++++-------------------
 arch/x86/kvm/trace.h           | 13 ++++++--
 arch/x86/kvm/vmx/posted_intr.c | 28 +++++++----------
 arch/x86/kvm/x86.c             | 23 +++++++++++---
 drivers/iommu/amd/iommu.c      | 15 +++-------
 5 files changed, 80 insertions(+), 67 deletions(-)


