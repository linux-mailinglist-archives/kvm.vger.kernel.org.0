Return-Path: <kvm+bounces-13542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E03CA8986DF
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C5DD1F28D5E
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA82B8595C;
	Thu,  4 Apr 2024 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U9f5CKQf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4407484FD8
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232812; cv=none; b=igFtaVytKN0Wj+aw/Z2Jay4lgzn4qcGueYtWkinodBZ4ya1rHyWF4GmKmXisG6z8Ko/pZ8uLYaSlTih5jtWdXiDD09DcNjG4ZyvnJ/1x/a57dQsbnKECRKvlI/IjKDEK4uwee8+GdPMnMDoMT+aYJKWii3a8siPquB5XM9RYzA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232812; c=relaxed/simple;
	bh=lvgrt2+h+32nV9sB6Pbowk90McEKUA04yJRDBc4Cfx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bg9b+bVqHM2qFqRJfFAMIfN7BpcFGatLOfTPO1MVM3TkCOWMwEXK2goJdL3/hhEeJs7VHyC9g2HPXIVPkgy4P+Phsj1sOdWy12xKPSERRBT900p49fzTJ04LT6UBSGDKncBGrldZV+fOiAhabD0oBPAuv3+5emfI+SAUyBNtqxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U9f5CKQf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iX8vkGO/ubhfuqfL3RRUiW2W1cfaaMsTND1lD88J4N4=;
	b=U9f5CKQfyiS+mPshFLLuTH+WR2luB5rdSbpixEhAxtR8jgSrDcX9XE6B3V2Kdsi+qxnnU1
	9/O37iK+GK1Ce2gwZ5ioMw3Kjrfkj5FPcKB6dTzoURcLonSpmlNFbUWsXMumZTowPLFa5I
	ABnXNBRqvl1paBnlSs/ZJMjMz8A+q58=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-zuCUrquIPS-saWkijWOZmg-1; Thu,
 04 Apr 2024 08:13:28 -0400
X-MC-Unique: zuCUrquIPS-saWkijWOZmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E06C383CCE8;
	Thu,  4 Apr 2024 12:13:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19086200A386;
	Thu,  4 Apr 2024 12:13:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v5 00/17] KVM: SEV: allow customizing VMSA features
Date: Thu,  4 Apr 2024 08:13:10 -0400
Message-ID: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

This is the same as v4, except for the following minor changes:

- moving the KVM_X86_SEV_VMSA_FEATURES attribute to a
  separate group, KVM_X86_GRP_SEV [Isaku]

- as part of the previous change, retroactively define group 0
  as "KVM_X86_GRP_SYSTEM"

- squashing in the "fixup! KVM: SEV: sync FPU and AVX state at
  LAUNCH_UPDATE_VMSA time" patch

- disabling FPU and AVX sync for the old-style KVM_SEV_ES_INIT
  ioctl [Michael]

- adding an fstp instruction to the new test case, in order to
  keep the x87 stack balanced (just for cleanliness/paranoia)

Paolo Bonzini (16):
  KVM: SVM: Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
  KVM: x86: use u64_to_user_ptr()
  KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
  KVM: SEV: publish supported VMSA features
  KVM: SEV: store VMSA features in kvm_sev_info
  KVM: x86: add fields to struct kvm_arch for CoCo features
  KVM: x86: Add supported_vm_types to kvm_caps
  KVM: SEV: introduce to_kvm_sev_info
  KVM: SEV: define VM types for SEV and SEV-ES
  KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA time
  KVM: SEV: introduce KVM_SEV_INIT2 operation
  KVM: SEV: allow SEV-ES DebugSwap again
  selftests: kvm: add tests for KVM_SEV_INIT2
  selftests: kvm: switch to using KVM_X86_*_VM
  selftests: kvm: split "launch" phase of SEV VM creation
  selftests: kvm: add test for transferring FPU state into VMSA

Sean Christopherson (1):
  KVM: SVM: Invert handling of SEV and SEV_ES feature flags

 Documentation/virt/kvm/api.rst                |   2 +
 .../virt/kvm/x86/amd-memory-encryption.rst    |  52 ++++-
 arch/x86/include/asm/fpu/api.h                |   3 +
 arch/x86/include/asm/kvm-x86-ops.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   8 +-
 arch/x86/include/uapi/asm/kvm.h               |  20 +-
 arch/x86/kernel/fpu/xstate.c                  |   1 +
 arch/x86/kernel/fpu/xstate.h                  |   2 -
 arch/x86/kvm/Makefile                         |   7 +-
 arch/x86/kvm/cpuid.c                          |   2 +-
 arch/x86/kvm/svm/sev.c                        | 190 ++++++++++++++----
 arch/x86/kvm/svm/svm.c                        |  27 ++-
 arch/x86/kvm/svm/svm.h                        |  54 +++--
 arch/x86/kvm/x86.c                            | 165 +++++++++------
 arch/x86/kvm/x86.h                            |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |  11 +-
 .../selftests/kvm/include/x86_64/processor.h  |   6 -
 .../selftests/kvm/include/x86_64/sev.h        |  19 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 -
 .../selftests/kvm/lib/x86_64/processor.c      |  14 +-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  |  44 +++-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../selftests/kvm/x86_64/sev_init2_tests.c    | 152 ++++++++++++++
 .../selftests/kvm/x86_64/sev_smoke_test.c     |  96 ++++++++-
 25 files changed, 703 insertions(+), 185 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c

-- 
2.43.0






