Return-Path: <kvm+bounces-8124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FA884BCD2
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5052AB24726
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424461400F;
	Tue,  6 Feb 2024 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RAnFlgjd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60A713AC6
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707243695; cv=none; b=lgjkvCBOYnA1q5logUZImCbFzi0lYC70EoFjbLz54ofaZ+AyG3L75GBeq6DbSZs/inuRrggKouunzKamkTrIWMZ8z/paOmn1vIkPaXKHj6TvS6cGdqdZK/fo9OW30edD9vEGn/pPSS5u8/rADYG8/PUpzK0VKx3WHOjYF3IriU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707243695; c=relaxed/simple;
	bh=1u8Hb11Lc8orVZldLDqTQXqnEWK1yzdhcMtdUySuf/I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pTfOPmHTBZHSQZ+EWoFyAQ2AIdBleLLBB8LsSBdZV2dk8JUVif2nA5ZiNKtkIVISC1VAU2pReOLOWUpISU42Ew/eCrljb4QM3X6exw1Q89B7u2V1LyWmVPfW0Yd4rvICTm6IiS+BnNeznC2p08xkYHK8tH4mdZ0fQpchzGWS4S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RAnFlgjd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707243692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gA2fT1cqxBoDE5ZOq9i+i3xwJmVjEI52qqjkD5raps0=;
	b=RAnFlgjdg1bBYQoRiUx1T8/qylqi9jC8+T+jb5RpytiigPABMxbRQExQW+hFmxKMrMm5Rb
	AAm5AWgYEaKZa5wR2P7IQhDBPKbPrQaNRnrEIBXqAFU5HrYap3pADa4zftz6G+BDjWWtHw
	5XIg64GGry4dnJn7bnsS9nbB67Y6tA8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-U6f5ku8IOiePTN_WakMDBA-1; Tue, 06 Feb 2024 13:21:29 -0500
X-MC-Unique: U6f5ku8IOiePTN_WakMDBA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D57E183B7EA;
	Tue,  6 Feb 2024 18:21:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B8032492BC7;
	Tue,  6 Feb 2024 18:21:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 6.8-rc4
Date: Tue,  6 Feb 2024 13:21:28 -0500
Message-Id: <20240206182128.3271452-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Linus,

The following changes since commit 6613476e225e090cc9aad49be7fa504e290dd33d:

  Linux 6.8-rc1 (2024-01-21 14:11:32 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e459647710070684a48384d67742822379de8c1c:

  x86/coco: Define cc_vendor without CONFIG_ARCH_HAS_CC_PLATFORM (2024-02-06 03:56:04 -0500)

This missed -rc3 due to an issue with clang compilation, which is solved by
the top commit.

----------------------------------------------------------------
x86 guest:

* Avoid false positive for check that only matters on AMD processors

x86:

* Give a hint when Win2016 might fail to boot due to XSAVES && !XSAVEC configuration

* Do not allow creating an in-kernel PIT unless an IOAPIC already exists

RISC-V:

* Allow ISA extensions that were enabled for bare metal in 6.8
  (Zbc, scalar and vector crypto, Zfh[min], Zihintntl, Zvfh[min], Zfa)

S390:

* fix CC for successful PQAP instruction

* fix a race when creating a shadow page

----------------------------------------------------------------
Anup Patel (14):
      RISC-V: KVM: Allow Zbc extension for Guest/VM
      KVM: riscv: selftests: Add Zbc extension to get-reg-list test
      RISC-V: KVM: Allow scalar crypto extensions for Guest/VM
      KVM: riscv: selftests: Add scaler crypto extensions to get-reg-list test
      RISC-V: KVM: Allow vector crypto extensions for Guest/VM
      KVM: riscv: selftests: Add vector crypto extensions to get-reg-list test
      RISC-V: KVM: Allow Zfh[min] extensions for Guest/VM
      KVM: riscv: selftests: Add Zfh[min] extensions to get-reg-list test
      RISC-V: KVM: Allow Zihintntl extension for Guest/VM
      KVM: riscv: selftests: Add Zihintntl extension to get-reg-list test
      RISC-V: KVM: Allow Zvfh[min] extensions for Guest/VM
      KVM: riscv: selftests: Add Zvfh[min] extensions to get-reg-list test
      RISC-V: KVM: Allow Zfa extension for Guest/VM
      KVM: riscv: selftests: Add Zfa extension to get-reg-list test

Christian Borntraeger (1):
      KVM: s390: vsie: fix race during shadow creation

Eric Farman (1):
      KVM: s390: fix cc for successful PQAP

Kirill A. Shutemov (1):
      x86/kvm: Fix SEV check in sev_map_percpu_data()

Maciej S. Szmigiero (1):
      KVM: x86: Give a hint when Win2016 might fail to boot due to XSAVES erratum

Nathan Chancellor (1):
      x86/coco: Define cc_vendor without CONFIG_ARCH_HAS_CC_PLATFORM

Paolo Bonzini (2):
      Merge tag 'kvm-s390-master-6.8-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvm-riscv-6.8-2' of https://github.com/kvm-riscv/linux into HEAD

Tengfei Yu (1):
      KVM: x86: Check irqchip mode before create PIT

 arch/riscv/include/uapi/asm/kvm.h                |  27 ++++++
 arch/riscv/kvm/vcpu_onereg.c                     |  54 ++++++++++++
 arch/s390/kvm/priv.c                             |   8 +-
 arch/s390/kvm/vsie.c                             |   1 -
 arch/s390/mm/gmap.c                              |   1 +
 arch/x86/include/asm/coco.h                      |   5 +-
 arch/x86/include/asm/kvm_host.h                  |   2 +
 arch/x86/kernel/kvm.c                            |   3 +-
 arch/x86/kvm/hyperv.c                            |  50 +++++++++++
 arch/x86/kvm/hyperv.h                            |   3 +
 arch/x86/kvm/x86.c                               |   7 ++
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 108 +++++++++++++++++++++++
 12 files changed, 263 insertions(+), 6 deletions(-)


