Return-Path: <kvm+bounces-37764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57310A2FED9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 01:09:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C30B61888C33
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 00:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF0ADDBC;
	Tue, 11 Feb 2025 00:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIFBrd8V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27234524F
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 00:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739232580; cv=none; b=mbR62bn/ouc1RWE/d131/v3/JHTFRjyqfC+RrKSPXlXsIsPB9T/QmfjB6t8mfdLp/FrnJq6+1JK9i5HOw9ieG1DcFHep4UFQS7y8HOPdeE2AwKaynt3jtSWTbXqIKKDKqpudzRjehMy702E9tx1odnBalNYiu78xmUoW3SRqCJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739232580; c=relaxed/simple;
	bh=kbNjG86W9AzGPqRCEhKG6CUtamg2Jt2c0Ij/m45WACk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=SGKZ64YB0bEJEb0Ezrx7RYSLvHSrzliVbsdLArvslc/0XjfleUuucXu+73eeFi/ec931/qMESAyECvvUn11ISLpmULrn8Pfh4X5Hr9QgHlhFOBFlWpwbuT6roW0Aru0ghUvs+f7MDwH0LPfq2xgC8UKtrG2L7JcGoY9bQ+xXStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DIFBrd8V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739232578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jAgG5PbVpxfjPiUq1P9KoLaJMoVyaxTfP/N5PAh92BE=;
	b=DIFBrd8VCVe3PRLMA361fQe7g24Rg5pbHdrw7h6ewKAXCZZTMOs38eLSdJcYIsnBmp0aIE
	EQZ7fwqETKzfQIVQWF8/LS/CDm7gROKhChsnCB2o/bs66gs0hdFeUyIWG2NLjzp0vQS+G5
	m0LdJEuHkFf3a3byN2n1YJ/Pm+FEJ/U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-4NLqzznmNha3XRZVRKy4uw-1; Mon,
 10 Feb 2025 19:09:30 -0500
X-MC-Unique: 4NLqzznmNha3XRZVRKy4uw-1
X-Mimecast-MFC-AGG-ID: 4NLqzznmNha3XRZVRKy4uw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCD7B1956086;
	Tue, 11 Feb 2025 00:09:25 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.174])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AAFB19560A3;
	Tue, 11 Feb 2025 00:09:18 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm-riscv@lists.infradead.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-riscv@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Anup Patel <anup@brainfault.org>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Atish Patra <atishp@atishpatra.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/3] KVM: extract lock_all_vcpus/unlock_all_vcpus
Date: Mon, 10 Feb 2025 19:09:14 -0500
Message-Id: <20250211000917.166856-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Implement Paolo's suggestion of reusing=0D
sev_lock/unlock_vcpus_for_migration in arm and riscv code=0D
for the purpose of taking vcpu->mutex of all vcpus of a VM.=0D
=0D
Because sev_lock/unlock_vcpus_for_migration already have a workaround=0D
for lockdep max lock depth, this fixes the lockdep warnings on arm=0D
which were the inspiration for this refactoring.=0D
=0D
This patch series was only compile tested on all 3 architectures.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: x86: move sev_lock/unlock_vcpus_for_migration to kvm_main.c=0D
  KVM: arm64: switch to using kvm_lock/unlock_all_vcpus=0D
  RISC-V: KVM: switch to kvm_lock/unlock_all_vcpus=0D
=0D
 arch/arm64/include/asm/kvm_host.h     |  3 --=0D
 arch/arm64/kvm/arch_timer.c           |  8 ++--=0D
 arch/arm64/kvm/arm.c                  | 32 -------------=0D
 arch/arm64/kvm/vgic/vgic-init.c       | 11 +++--=0D
 arch/arm64/kvm/vgic/vgic-its.c        | 18 +++----=0D
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 21 ++++----=0D
 arch/riscv/kvm/aia_device.c           | 36 ++------------=0D
 arch/x86/kvm/svm/sev.c                | 65 ++-----------------------=0D
 include/linux/kvm_host.h              |  6 +++=0D
 virt/kvm/kvm_main.c                   | 69 +++++++++++++++++++++++++++=0D
 10 files changed, 115 insertions(+), 154 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


