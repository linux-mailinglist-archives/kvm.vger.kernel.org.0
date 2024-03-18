Return-Path: <kvm+bounces-12061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A632E87F426
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:39:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CBF92811A3
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5991D62162;
	Mon, 18 Mar 2024 23:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SyQAbhTB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5125C60EC7
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804851; cv=none; b=oISr7O6PKwyzgDSx2s8Iwu8X0FCEIF/JxkYj4BWbJAbVUdHXlKX1Aa++sB0WwLdfWDvgFCtnwmFCuIKlPHwufrargyICf+IZYKFiwsKU3560fJ3nk2Vkic4rQyXKWdAYN67nbEKAMHVAKTe9q4BjQviy2NDXUBFeLSFHJ/bolas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804851; c=relaxed/simple;
	bh=O8d8bKZo5siR8MieahkhVmdD32+jITrspI0Yw6jg/sg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tmRPuWdRp9/Lfdwc9p6PauvXoTyaThXA+yLtbbjQwwSUZWOxSKzSG96BaMUCDY8bOg0UesRlVzfk1xe4IqeXfoTaB6UyUpTdoIgQYDK/r98JBcYrlnGDZEQmT7LfoUj/FmFjpTQfxxurVdBXbSFiX6p44II2sPb13U2+//OqGM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SyQAbhTB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Df3YFTKjtHSFy1h833T/9wNhgRF6OQfT8JsQ4nzMHO4=;
	b=SyQAbhTBHa5Q+15iEGMhRUBN2nHO/Z//6ryWqbVnjYjTMOhpKNaSPBBu/DX076sWrSJVm8
	DpGV3WYLRFzL1w3+7Q1oz3fvfq9qBSN8Uexkeg7KS5lq/dy57y4hvPozwXQV/V+eARMRjh
	uJ4aB6LhYsc6Mnupq1mXdSFM5V4Bwu4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-bokCas9LPf2LDOxss9HlNg-1; Mon, 18 Mar 2024 19:33:54 -0400
X-MC-Unique: bokCas9LPf2LDOxss9HlNg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EAA0811E81;
	Mon, 18 Mar 2024 23:33:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4AD1B1121312;
	Mon, 18 Mar 2024 23:33:53 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v4 00/15] KVM: SEV: allow customizing VMSA features
Date: Mon, 18 Mar 2024 19:33:37 -0400
Message-ID: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

[Dave: there is a small arch/x86/kernel/fpu change in patch 9;
 I am CCing you in the cover letter just for context. - Paolo]
 
The idea that no parameter would ever be necessary when enabling SEV or
SEV-ES for a VM was decidedly optimistic.  The first source of variability
that was encountered is the desired set of VMSA features, as that affects
the measurement of the VM's initial state and cannot be changed
arbitrarily by the hypervisor.

This series adds all the APIs that are needed to customize the features,
with room for future enhancements:

- a new /dev/kvm device attribute to retrieve the set of supported
  features (right now, only debug swap)

- a new sub-operation for KVM_MEM_ENCRYPT_OP that can take a struct,
  replacing the existing KVM_SEV_INIT and KVM_SEV_ES_INIT

It then puts the new op to work by including the VMSA features as a field
of the The existing KVM_SEV_INIT and KVM_SEV_ES_INIT use the full set of
supported VMSA features for backwards compatibility; but I am considering
also making them use zero as the feature mask, and will gladly adjust the
patches if so requested.

In order to avoid creating *two* new KVM_MEM_ENCRYPT_OPs, I decided that
I could as well make SEV and SEV-ES use VM types.  And then, why not make
a SEV-ES VM, when created with the new VM type instead of KVM_SEV_ES_INIT,
reject KVM_GET_REGS/KVM_SET_REGS and friends on the vCPU file descriptor
once the VMSA has been encrypted...  Which is how the API should have
always behaved.

Note: despite having the same number of patches as v3, #9 and #15 are new!
The series is structured as follows:

- patches 1 and 2 change sev.c so that it is compiled only if SEV is enabled
  in kconfig

- patches 3 to 6 introduce the new device attribute to retrieve supported
  VMSA features

- patches 7 and 8 introduce new infrastructure for VM types, replacing
  the similar code in the TDX patches

- patch 9 allows setting the FPU and AVX state prior to encryption of the
  VMSA

- patches 10 to 12 introduce the new VM types for SEV and
  SEV-ES, and KVM_SEV_INIT2 as a new sub-operation for KVM_MEM_ENCRYPT_OP.

- patch 13 reenables DebugSwap, now that there is an API that allows doing
  so without breaking backwards compatibility

- patches 14 and 15 test the new ioctl.

The idea is that SEV SNP will only ever support KVM_SEV_INIT2.  I have
placed patches for QEMU to support this new API at branch sevinit2 of
https://gitlab.com/bonzini/qemu.

I haven't fully tested patch 9 and it really deserves a selftest,
it is a bit tricky though without ucall infrastructure for SEV.
I will look at it tomorrow.

The series is at branch kvm-coco-queue of kvm.git, and I would like to
include it in kvm/next as soon as possible after the release of -rc1.

Thanks,

Paolo

v3->v4:
- moved patches 1 and 5 to separate "fixes" series for 6.9
- do not conditionalize prototypes for functions that are called by common
  SVM code
- rebased on top of SEV selftest infrastructure from 6.9 merge window;
  include new patch to drop the "subtype" concept
- rebased on top of SEV-SNP patches from 6.9 merge window
- rebased on top of patch to disable DebugSwap from 6.8 rc;
  drop "warn" once SEV_ES_INIT stops enabling VMSA features and
  finally re-enable DebugSwap
- simplified logic to return -EINVAL from ioctls
- also block KVM_GET/SET_FPU for protected-state guests
- move logic to set kvm_>arch.has_protected_state to svm_vm_init
- fix "struct struct" in documentation

Paolo Bonzini (14):
  KVM: SVM: Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
  KVM: x86: use u64_to_user_addr()
  KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
  KVM: SEV: publish supported VMSA features
  KVM: SEV: store VMSA features in kvm_sev_info
  KVM: x86: add fields to struct kvm_arch for CoCo features
  KVM: x86: Add supported_vm_types to kvm_caps
  KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA time
  KVM: SEV: introduce to_kvm_sev_info
  KVM: SEV: define VM types for SEV and SEV-ES
  KVM: SEV: introduce KVM_SEV_INIT2 operation
  KVM: SEV: allow SEV-ES DebugSwap again
  selftests: kvm: add tests for KVM_SEV_INIT2
  selftests: kvm: switch to using KVM_X86_*_VM

Sean Christopherson (1):
  KVM: SVM: Invert handling of SEV and SEV_ES feature flags

 Documentation/virt/kvm/api.rst                |   2 +
 .../virt/kvm/x86/amd-memory-encryption.rst    |  52 +++++-
 arch/x86/include/asm/fpu/api.h                |   3 +
 arch/x86/include/asm/kvm-x86-ops.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   8 +-
 arch/x86/include/uapi/asm/kvm.h               |  12 ++
 arch/x86/kernel/fpu/xstate.h                  |   2 -
 arch/x86/kvm/Makefile                         |   7 +-
 arch/x86/kvm/cpuid.c                          |   2 +-
 arch/x86/kvm/svm/sev.c                        | 172 ++++++++++++++----
 arch/x86/kvm/svm/svm.c                        |  27 ++-
 arch/x86/kvm/svm/svm.h                        |  43 ++++-
 arch/x86/kvm/x86.c                            | 170 +++++++++++------
 arch/x86/kvm/x86.h                            |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |  11 +-
 .../selftests/kvm/include/x86_64/processor.h  |   6 -
 .../selftests/kvm/include/x86_64/sev.h        |  16 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 -
 .../selftests/kvm/lib/x86_64/processor.c      |  14 +-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  |  30 ++-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../selftests/kvm/x86_64/sev_init2_tests.c    | 149 +++++++++++++++
 23 files changed, 569 insertions(+), 170 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c

-- 
2.43.0


