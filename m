Return-Path: <kvm+bounces-21327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA3B92D796
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 19:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D292B24933
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A407F1957F5;
	Wed, 10 Jul 2024 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KYokKn/x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292F6192483
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 17:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633240; cv=none; b=bVFXrmq0P2Y3n0aWShqkdb7RNVL81JG//vwvTQuCDTJvQIok+c/kTcq3Dvi5OMe2Wg5Du3fTiI0rpMnnlVjFrhEEyFbYmRikHiYZ4I3qtHfCJKRVClXO5w5mOj+YNrGTIMp6H/SB5V3r55RQQNvYJHsyXMmNH68jIGHTYxqmj6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633240; c=relaxed/simple;
	bh=opzMe0nXF8vNlyJupZcDVV/kJQgovpTF493lgSf1Jnk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vwb0fe/DCw3YmzFHJDaHXXvD2tRskbQUzj2OIdAii1oU+7qCOQKPsVEzltxnHJzQOByOrRhdozW9TvSUkIBYQeab4Nl4XjZVO+KUzngd8I6ALf9g2tCIcRSvpTdIfDAVf/nOtDxNaieeQ2USD68Q5pEhq7DkdlX80kIC2lE9a+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KYokKn/x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720633237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=deJJLDfnOfFPz4qroPoBEdALt7gnxQ1Eowi++rkDz7U=;
	b=KYokKn/xNqkO/NJTDul70cARz7sXbyS3gDuLhEKrYzlQVvoP53TVtTgjXedlDM1/aYUtUl
	vJRY+DmsCa/O4bU+w/WeRN9tu4DtoAMQtLBoTckkQE+UzMMQcSWsgTlH47GZPkE2M5Uutz
	4/6RHSy2BX9IOERgVHOL48mnU7EmfVM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-FcM0hb2KPnKo9yyQqKbNLQ-1; Wed,
 10 Jul 2024 13:40:34 -0400
X-MC-Unique: FcM0hb2KPnKo9yyQqKbNLQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F177195419C;
	Wed, 10 Jul 2024 17:40:33 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B81501955E85;
	Wed, 10 Jul 2024 17:40:31 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	seanjc@google.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH v5 0/7] KVM: Guest Memory Pre-Population API
Date: Wed, 10 Jul 2024 13:40:24 -0400
Message-ID: <20240710174031.312055-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Pre-population has been requested several times to mitigate KVM page faults
during guest boot or after live migration.  It is also required by TDX
before filling in the initial guest memory with measured contents.
Introduce it as a generic API.

Paolo

v4->v5:
- add EIO as possible error
- do not introduce __kvm_mmu_do_page_fault(), instead update stats in callers
- remove goto
- fix commit message to not mention weak symbol
- return error if range->size is 0
- fix comment to explain TDP restriction
- fix guest_test_phys_mem > guest_test_virt_mem case in test

Isaku Yamahata (3):
  KVM: Document KVM_PRE_FAULT_MEMORY ioctl
  KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to pre-populate guest memory
  KVM: selftests: x86: Add test for KVM_PRE_FAULT_MEMORY

Paolo Bonzini (2):
  KVM: x86/mmu: Make kvm_mmu_do_page_fault() return mapped level
  KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()

Sean Christopherson (2):
  KVM: x86/mmu: Bump pf_taken stat only in the "real" page fault handler
  KVM: x86/mmu: Account pf_{fixed,emulate,spurious} in callers of "do
    page fault"

 Documentation/virt/kvm/api.rst                |  55 +++++++
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  96 +++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h               |  26 +---
 arch/x86/kvm/x86.c                            |   3 +
 include/linux/kvm_host.h                      |   5 +
 include/uapi/linux/kvm.h                      |  10 ++
 tools/include/uapi/linux/kvm.h                |  14 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/pre_fault_memory_test.c     | 146 ++++++++++++++++++
 virt/kvm/Kconfig                              |   3 +
 virt/kvm/kvm_main.c                           |  60 +++++++
 12 files changed, 394 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/pre_fault_memory_test.c

-- 
2.43.0


