Return-Path: <kvm+bounces-39319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92635A46944
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87A5B173F2D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B29235BFF;
	Wed, 26 Feb 2025 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PY8KKlnR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD91922D4DD
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593705; cv=none; b=bmsBa4qY029UmbEcb6M968UOLK8OT9ZFVXcHs6eNeEmWJ/vmN1mgqfyBmH9kqXEEXMGFye3fztfjj3MdvOo8HcLnSauuDTiLRw9RD958uqTIajc9Dr5X4od5UJdXCVgGGeoiwiTE6Ldci9EDo4NMbVCvXEuTsaLIv6gSdUAEumw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593705; c=relaxed/simple;
	bh=0je6xjpQ/sUkUJXE1Wcbc/wTC6LRmY/GtirPAxfiwuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d4ktoS+1xphTump/Y5P9shoMCXHmL4y/ZGSlKMaHrrUjJkqw7X2xlc7kI0KAKsbhYGHJwIEIS7XcDI4O8c1pdz8KfVRoo5Q0zcO34mkHcvbgpLx1Kjkeqnr9FNm98rzRNdKtHfUYTV+S7Kjyx9cTToC1Pj1wMl1PiCU5ZEE/V40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PY8KKlnR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XAQLS7DozQHfJNsQvv9I10tSk2kkFQggtGNk9dnteMo=;
	b=PY8KKlnRo3yoGHjPDFg6kOl2lKOsQe1NgYcPy1nAIisIx5xwc+UsyDwcc+SGifcsQHBQHM
	cU2C66A8bsvLd5INpbkyhiErad/t36+gIdqr5C/RTwSDJ17OZhKchZPOMS2gBWnFdFBGlN
	mIYvMTUe5iwphhZayVRZALJg7LLFvq0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-511-Tsvy6HPNMlSMuuSVPabTgw-1; Wed,
 26 Feb 2025 13:14:56 -0500
X-MC-Unique: Tsvy6HPNMlSMuuSVPabTgw-1
X-Mimecast-MFC-AGG-ID: Tsvy6HPNMlSMuuSVPabTgw_1740593695
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02E78180087A;
	Wed, 26 Feb 2025 18:14:55 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E3B071944D02;
	Wed, 26 Feb 2025 18:14:53 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v4 00/33] TDX initialization + vCPU/VM creation
Date: Wed, 26 Feb 2025 13:14:19 -0500
Message-ID: <20250226181453.2311849-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi,

Here is v4 of TDX VM/vCPU creation series.  The main change is to rebase
on top of Sean's "KVM: x86: Free vCPUs before freeing VM state" which
will go into v6.14.  Instead of introducing separate vm_destroy and
vm_free callbacks, vm_destroy is moved at end of kvm_arch_destroy_vm.

Detailed changelog from v3:

KVM: VMX: Refactor VMX module init/exit functions
- fix modpost issues [Kai]

KVM: VMX: Initialize TDX during KVM module load
- extract cpus_read_lock() out of __do_tdx_cleanup [Kai, Chao]
- removed kvm_can_support_tdx()

KVM: TDX: Get system-wide info about TDX module on initialization
- fix for introduction of __tdx_cleanup

KVM: TDX: create/destroy VM structure
- included two patches from Sean's "Free vCPUs before freeing VM state" series
- replace vm_free hook with vm_destroy, introduce new vm_pre_destroy [Sean, Yan]
- rename tdx_vm_free to tdx_vm_destroy
- remove TDX_SEAMCALL_RETRIES from __tdx_reclaim_page

KVM: TDX: initialize VM with TDX specific parameters
- squashed "KVM: TDX: Set arch.has_protected_state to true" [Kai]

Paolo

Isaku Yamahata (13):
  x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free TDX
    guest KeyID
  KVM: TDX: Add placeholders for TDX VM/vCPU structures
  KVM: TDX: Define TDX architectural definitions
  KVM: TDX: Add helper functions to print TDX SEAMCALL error
  KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
  KVM: TDX: Get system-wide info about TDX module on initialization
  KVM: TDX: create/destroy VM structure
  KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS extension check
  KVM: TDX: add ioctl to initialize VM with TDX specific parameters
  KVM: TDX: Make pmu_intel.c ignore guest TD case
  KVM: TDX: Don't offline the last cpu of one package when there's TDX
    guest
  KVM: TDX: create/free TDX vcpu structure
  KVM: TDX: Do TDX specific vcpu initialization

Kai Huang (5):
  x86/virt/tdx: Read essential global metadata for KVM
  KVM: Export hardware virtualization enabling/disabling functions
  KVM: VMX: Refactor VMX module init/exit functions
  KVM: VMX: Initialize TDX during KVM module load
  KVM: TDX: Get TDX global information

Paolo Bonzini (3):
  KVM: x86: move vm_destroy callback at end of kvm_arch_destroy_vm
  x86/virt/tdx: allocate tdx_sys_info in static memory
  KVM: x86: expose cpuid_entry2_find for TDX

Rick Edgecombe (6):
  x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
  x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations

Sean Christopherson (3):
  KVM: x86: Free vCPUs before freeing VM state
  KVM: x86: Don't load/put vCPU when unloading its MMU during teardown
  KVM: TDX: Add TDX "architectural" error codes

Xiaoyao Li (2):
  KVM: x86: Introduce KVM_TDX_GET_CPUID
  KVM: x86/mmu: Taking guest pa into consideration when calculate tdp
    level

Zhiming Hu (1):
  KVM: TDX: Register TDX host key IDs to cgroup misc controller

 arch/x86/include/asm/kvm-x86-ops.h            |    4 +-
 arch/x86/include/asm/kvm_host.h               |    2 +
 arch/x86/include/asm/shared/tdx.h             |    7 +-
 arch/x86/include/asm/tdx.h                    |   59 +
 .../tdx => include/asm}/tdx_global_metadata.h |   19 +
 arch/x86/include/uapi/asm/kvm.h               |   60 +
 arch/x86/kvm/Kconfig                          |   12 +
 arch/x86/kvm/Makefile                         |    1 +
 arch/x86/kvm/cpuid.c                          |   33 +-
 arch/x86/kvm/cpuid.h                          |    3 +
 arch/x86/kvm/lapic.c                          |    1 +
 arch/x86/kvm/mmu/mmu.c                        |    9 +-
 arch/x86/kvm/vmx/main.c                       |  180 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |   52 +-
 arch/x86/kvm/vmx/pmu_intel.h                  |   28 +
 arch/x86/kvm/vmx/tdx.c                        | 1545 +++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                        |   90 +
 arch/x86/kvm/vmx/tdx_arch.h                   |  130 ++
 arch/x86/kvm/vmx/tdx_errno.h                  |   37 +
 arch/x86/kvm/vmx/vmx.c                        |   23 +-
 arch/x86/kvm/vmx/vmx.h                        |   37 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   22 +
 arch/x86/kvm/x86.c                            |   27 +-
 arch/x86/virt/vmx/tdx/tdx.c                   |  276 ++-
 arch/x86/virt/vmx/tdx/tdx.h                   |   39 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c   |   50 +
 include/linux/kvm_host.h                      |    9 +
 include/linux/misc_cgroup.h                   |    4 +
 kernel/cgroup/misc.c                          |    4 +
 virt/kvm/kvm_main.c                           |   21 +-
 30 files changed, 2669 insertions(+), 115 deletions(-)
 rename arch/x86/{virt/vmx/tdx => include/asm}/tdx_global_metadata.h (58%)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

-- 
2.43.5


