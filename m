Return-Path: <kvm+bounces-15216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9E38AAB10
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B415B22660
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 09:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9F47EEF2;
	Fri, 19 Apr 2024 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KUVizkcx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4CC78676
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 08:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713517177; cv=none; b=A4GJNkAxXpoteyPPk2AeZEof+RXWB+7F3ibzh7LTZZVpQEUbCFdwC+AaHMKfsP4sny6x4tJdA3qQgB+W0CRjcAEk92aZXY7AN5O6tdF9AMbJUNPgitsBkUhb1Mv+Tx/oHgDV8M75JKOUk4GTo+E8/A+i3qNQjc7+Z9KhzLytCxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713517177; c=relaxed/simple;
	bh=y4rNe9gyVulZlmm7cp7LGHzmoqxjT4o9TZAfg83xNSA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nYO8kkGWepPrAEB/E57//D+zy+V40Cw943+OfojIH3DHRPrIRfwbE7xTD6UlenU6NtL/FCAOv38p7ErqBUjSqDcIjshWgj9sizg2fvZVqA56N/w3A8NeHhUFU4xueigGmJ1SxDUZjUrIHWjYhbVOrf+bKHcuPdNj5hCIqY/LG4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KUVizkcx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713517174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xCXBhCcX/Rs9QQci0q4QWTKJT0dsFBOURhywyhJQSgc=;
	b=KUVizkcxnMPM3JF1PEdlN5XBIM7xwGveEk5KtzJvQVjOtmtXCLGB43CTxwBoEzY8LFmfEB
	f/dmxPDsC0k9Sb6VkaBGqVq5hTETs3eTKD3Sg+TTzFJ3AiQIIwVDnfPR9lsDfVuikStef3
	E/rLfHmza4MHP1vzjmerbLSNYHuMiNY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-YW7Akur9Ok2f0fIbn8Tltw-1; Fri, 19 Apr 2024 04:59:29 -0400
X-MC-Unique: YW7Akur9Ok2f0fIbn8Tltw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A2E181384E;
	Fri, 19 Apr 2024 08:59:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09C1A20368B9;
	Fri, 19 Apr 2024 08:59:27 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v4 0/6] KVM: Guest Memory Pre-Population API
Date: Fri, 19 Apr 2024 04:59:21 -0400
Message-ID: <20240419085927.3648704-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Pre-population has been requested several times to mitigate KVM page faults
during guest boot or after live migration.  It is also required by TDX
before filling in the initial guest memory with measured contents; while
I am not yet sure that userspace will use this ioctl, if not the code
will be used by a TDX-specific ioctl---to pre-populate the SEPT before
invoking TDH.MEM.PAGE.ADD or TDH.MR.EXTEND.

This patch series depends on the other pieces that have been applied
to the kvm-coco-queue branch (and is present on the branch).

Paolo

v3->v4:
- renamed everything to KVM_PRE_FAULT_MEMORY, KVM_CAP_PRE_FAULT_MEMORY,
  struct kvm_pre_fault_memory.
- renamed base_address field to gpa
- merged introduction of kvm_tdp_map_page() and kvm_arch_vcpu_map_memory()
  in a single patch, moving the latter to mmu.c; did *not* merge them
  in a single function though
- removed EINVAL return code for RET_PF_RETRY, do it in KVM and exit
  on signal_pending()
- return ENOENT for RET_PF_EMULATE
- do not document the possibility that different VMs can have different
  results for KVM_CHECK_EXTENSION(KVM_CAP_PRE_FAULT_MEMORY)
- return long from kvm_arch_vcpu_map_memory(), update size and gpa in
  kvm_vcpu_map_memory()
- cover remaining range.size more thoroughly in the selftest

v2->v3:
- no vendor-specific hooks
- just fail if pre-population is invoked while nested virt is access
- just populate page tables for the SMM address space if invoked while
  SMM is active
- struct name changed to `kvm_map_memory`
- common code has supports for KVM_CHECK_EXTENSION(KVM_MAP_MEMORY)
  on the VM file descriptor, which allows to make this ioctl supported
  only on a subset of VM types
- if EINTR or EAGAIN happens on the first page, it is returned.  Otherwise,
  the ioctl *succeeds* but mapping->size is left nonzero.  While this
  drops the detail as to why the system call was interrupted, it is
  consistent with other interruptible system calls such as read().
- the test is not x86-specific anymore (though for now only compiled
  on x86 because no other architectures supports the feature)
- instead of using __weak symbols, the code is conditional on a new
  Kconfig CONFIG_KVM_GENERIC_MAP_MEMORY.


Isaku Yamahata (6):
  KVM: Document KVM_PRE_FAULT_MEMORY ioctl
  KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to pre-populate guest memory
  KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
  KVM: x86/mmu: Make __kvm_mmu_do_page_fault() return mapped level
  KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()
  KVM: selftests: x86: Add test for KVM_PRE_FAULT_MEMORY

 Documentation/virt/kvm/api.rst                |  50 ++++++
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  72 +++++++++
 arch/x86/kvm/mmu/mmu_internal.h               |  42 +++--
 arch/x86/kvm/x86.c                            |   3 +
 include/linux/kvm_host.h                      |   5 +
 include/uapi/linux/kvm.h                      |  10 ++
 tools/include/uapi/linux/kvm.h                |   8 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/pre_fault_memory_test.c     | 146 ++++++++++++++++++
 virt/kvm/Kconfig                              |   3 +
 virt/kvm/kvm_main.c                           |  63 ++++++++
 12 files changed, 390 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/pre_fault_memory_test.c

-- 
2.43.0


