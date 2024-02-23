Return-Path: <kvm+bounces-9512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FBBE860FA1
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 11:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F0CA1F26E7E
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 10:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5DE97B3D8;
	Fri, 23 Feb 2024 10:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDE9EJcC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0952063104
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708684818; cv=none; b=lpM5UFMhBnJrPxBJYy85sjw9+NM7kxm+6MhfE2MxdPkqCo3pVs6QjUr+rOb0EjH5xI8uITvqoEzcEt2cbXSyAS5Q60S0amzp5HESgVy5zvODiNxeQPvCePgyJpLP4IHllBNe/r3I84Fxia2U/dlLoYiDW/Kr5q8LBwFUeKE8kPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708684818; c=relaxed/simple;
	bh=Xfk36w848FnfrA1lN/seVSB+qKcPGYoneE2jqWKAdxM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bbI89DE4i/z8BoJC98oneYyTAG2T6Mdb1KZNCB2X1BOgc/f9gtT3rCi3jlC0wzg8Kxk5joUfmLYSCpG17Y2DiQX2WohSUHqvIRgsruyRPrcfptoC75UHYzGKLAhSspOSpgaRSLvgTIVzTG2B2evZ87izpAC8bSxAJ50zlatYMO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FDE9EJcC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708684814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oynZG24uRHfx+IPkhc4um2RyGrLEMnq7IRNosym5KAE=;
	b=FDE9EJcCiq34lfrFdLgTNkyOR59GuH2SHRDhB2QW0R2Q2LyHoz4LuLNt/S/GA1ZVhgNrmc
	ZkRpsftLGBQo8U/MNELkvIOsGpbw52RTlwWUhjj9Kj89NwZx3s7NMs55LulXbEdJc02ND9
	zUcU5EULtZYw7aG/UDzlTw4JBOeEMU8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-6AQzrZmlM5i5BhH_NQO1hw-1; Fri,
 23 Feb 2024 05:40:10 -0500
X-MC-Unique: 6AQzrZmlM5i5BhH_NQO1hw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CD853C0ED47;
	Fri, 23 Feb 2024 10:40:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A050112132A;
	Fri, 23 Feb 2024 10:40:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v2 00/11] KVM: SEV: allow customizing VMSA features
Date: Fri, 23 Feb 2024 05:39:58 -0500
Message-Id: <20240223104009.632194-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

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

The series is defined as follows:

- patches 1 and 2 are unrelated fixes and improvements for the SEV API

- patches 3 to 5 introduce the new device attribute to retrieve supported
  VMSA features

- patch 6 (new in v2) disables DEBUG_SWAP by default

- patches 7 and 8 introduce new infrastructure for VM types, partly lifted
  out of the TDX patches

- patches 9 and 10 introduce respectively the new VM types for SEV and
  SEV-ES, and KVM_SEV_INIT2 as a new sub-operation for KVM_MEM_ENCRYPT_OP.

- patch 11 tests the new ioctl.

The idea is that SEV SNP will only ever support KVM_SEV_INIT2.  I have
patches in progress for QEMU to support this new API.

Thanks,

Paolo

v1->v2:
- fix compilation with SEV disabled (patch 4)
- new patch "KVM: SEV: disable DEBUG_SWAP by default" (patch 6)
- move definition of __KVM_X86_*_TYPE outside uapi headers (patch 7)
- do not export __kvm_is_vm_type_supported (patch 8)
- fixes to documentation (patch 10)
- reject all features for SEV (patch 10)
- do not enable any features for legacy KVM_SEV_INIT/KVM_SEV_ES_INIT (patch 10)


Paolo Bonzini (11):
  KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
  KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
  Documentation: kvm/sev: separate description of firmware
  KVM: SEV: publish supported VMSA features
  KVM: SEV: store VMSA features in kvm_sev_info
  KVM: SEV: disable DEBUG_SWAP by default
  KVM: x86: define standard behavior for bits 0/1 of VM type
  KVM: x86: Add is_vm_type_supported callback
  KVM: SEV: define VM types for SEV and SEV-ES
  KVM: SEV: introduce KVM_SEV_INIT2 operation
  selftests: kvm: add tests for KVM_SEV_INIT2

 Documentation/virt/kvm/api.rst                |   2 +
 .../virt/kvm/x86/amd-memory-encryption.rst    |  81 +++++++--
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +
 arch/x86/include/asm/kvm_host.h               |  11 +-
 arch/x86/include/uapi/asm/kvm.h               |  35 ++++
 arch/x86/kvm/svm/sev.c                        | 110 +++++++++++-
 arch/x86/kvm/svm/svm.c                        |  14 +-
 arch/x86/kvm/svm/svm.h                        |   6 +-
 arch/x86/kvm/x86.c                            | 157 ++++++++++++++----
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   6 +-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../selftests/kvm/x86_64/sev_init2_tests.c    | 146 ++++++++++++++++
 13 files changed, 510 insertions(+), 69 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c

-- 
2.39.1


