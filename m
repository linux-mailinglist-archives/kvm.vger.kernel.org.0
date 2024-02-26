Return-Path: <kvm+bounces-9970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 709C586805B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2656C28E2D0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B8012FF65;
	Mon, 26 Feb 2024 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BRwECDY0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2FA12EBE8
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974231; cv=none; b=QmRVI/nLApYlDnN63GbDX+teTUW6Wry7tn/QN3EiLeycZADZVoWRRzDQU4GBl448Nk+1vaOWd6ADKeNH6i29udxAKH2YP7U3yNEHrdnV+21kqx+Lgm6LoI3XdAvHeP+Oyvi3D4hdeH5exEFjsIcA9XjOmd9RrLf9VWOVAQsaoo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974231; c=relaxed/simple;
	bh=vcWBExDmv7RSnhov0HUdDRLdvfeRiov5FYh3uXoteKs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HoFcec3hla60u5GXmcJcSb44n1r8JoXB3MeVuGSdZj42EcaKw8rrj4BH+7S+RiSgf5KDm5NJNgLwPZseWZTI/TN/ktZD2g+8Np4k/jONC7EmdHQM5BWD4QgbL29+sRpOXCRfW43nLdCWgvCVEXy42ZKFnQXnmA5AbAbFRE/XTbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BRwECDY0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kdJK5BZbFMC4q1Whv/dgfBTc0g21lAY+xCZH4PpiiFk=;
	b=BRwECDY0do/7s/Mg5HuWaNGlXanRzbxm+zm9T4vAt3dwluBqv146QQTuXboUbQCsG9BOK6
	iwfaVmoQJXQZ7iJgTwKlazisHCoE+QmNgr71LppKwu8HNh7Smm732xio/7GBQiU0bVm+r/
	q5MM5pFY14tT0neWSMFXDZYdyJRBqHo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-TihFUZmjNjCqo770pI-c4A-1; Mon,
 26 Feb 2024 14:03:46 -0500
X-MC-Unique: TihFUZmjNjCqo770pI-c4A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3AF7285F988;
	Mon, 26 Feb 2024 19:03:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7773D492BC6;
	Mon, 26 Feb 2024 19:03:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 00/15] KVM: SEV: allow customizing VMSA features
Date: Mon, 26 Feb 2024 14:03:29 -0500
Message-Id: <20240226190344.787149-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

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

The series is structured as follows:

- patches 1 to 5 are unrelated fixes and improvements for the SEV code
  and documentation.  In particular they change sev.c so that it is
  compiled only if SEV is enabled in kconfig

- patches 6 to 8 introduce the new device attribute to retrieve supported
  VMSA features

- patch 9 disables DEBUG_SWAP by default

- patches 10 and 11 introduce new infrastructure for VM types, replacing
  the similar code in the TDX patches

- patches 12 to 14 introduce the new VM types for SEV and
  SEV-ES, and KVM_SEV_INIT2 as a new sub-operation for KVM_MEM_ENCRYPT_OP.

- patch 15 tests the new ioctl.

The idea is that SEV SNP will only ever support KVM_SEV_INIT2.  I have
patches in progress for QEMU to support this new API.

Thanks,

Paolo


v2->v3:
- use u64_to_user_addr()
- Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
- remove double signoffs
- rebase on top of kvm-x86/next
- no bit masking hacks; store CoCo features in kvm_arch
- store supported VM types in kvm_caps
- introduce to_kvm_sev_info
- clearer output messages for failed assertions
- remove broken test

Paolo Bonzini (14):
  KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
  KVM: x86: use u64_to_user_addr()
  KVM: SVM: Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
  Documentation: kvm/sev: separate description of firmware
  KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
  KVM: SEV: publish supported VMSA features
  KVM: SEV: store VMSA features in kvm_sev_info
  KVM: SEV: disable DEBUG_SWAP by default
  KVM: x86: add fields to struct kvm_arch for CoCo features
  KVM: x86: Add supported_vm_types to kvm_caps
  KVM: SEV: introduce to_kvm_sev_info
  KVM: SEV: define VM types for SEV and SEV-ES
  KVM: SEV: introduce KVM_SEV_INIT2 operation
  selftests: kvm: add tests for KVM_SEV_INIT2

Sean Christopherson (1):
  KVM: SVM: Invert handling of SEV and SEV_ES feature flags

 Documentation/virt/kvm/api.rst                |   2 +
 .../virt/kvm/x86/amd-memory-encryption.rst    |  81 ++++++--
 arch/x86/include/asm/kvm-x86-ops.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   8 +-
 arch/x86/include/uapi/asm/kvm.h               |  35 ++++
 arch/x86/kvm/Makefile                         |   7 +-
 arch/x86/kvm/cpuid.c                          |   2 +-
 arch/x86/kvm/svm/sev.c                        | 133 +++++++++----
 arch/x86/kvm/svm/svm.c                        |  15 +-
 arch/x86/kvm/svm/svm.h                        |  37 +++-
 arch/x86/kvm/x86.c                            | 174 ++++++++++++------
 arch/x86/kvm/x86.h                            |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   6 +-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../selftests/kvm/x86_64/sev_init2_tests.c    | 149 +++++++++++++++
 16 files changed, 527 insertions(+), 134 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c

-- 
2.39.1


